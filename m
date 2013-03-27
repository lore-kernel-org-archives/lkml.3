Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab3C0NKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:10:51 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44310 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab3C0NJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:09:22 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, Lars Ellenberg <lars.ellenberg@linbit.com>,
        Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 13/17] drbd: fix drbd epoch write count for ahead/behind mode
Date: Wed, 27 Mar 2013 14:08:45 +0100
Message-Id: <1364389729-17559-14-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
References: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

The sanity check when receiving P_BARRIER_ACK does expect all write
requests with a given req->epoch to have been either all replicated,
or all not replicated.

Because req->epoch was assigned before calling maybe_pull_ahead(),
this expectation was not met, leading to an off-by-one in the sanity
check, and further to a "Protocol Error".

Fix: move the call to maybe_pull_ahead() a few lines up,
and assign req->epoch only after that.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_req.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index beefe65..c24379f 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -865,8 +865,10 @@ static void maybe_pull_ahead(struct drbd_conf *mdev)
 	bool congested = false;
 	enum drbd_on_congestion on_congestion;
 
+	rcu_read_lock();
 	nc = rcu_dereference(tconn->net_conf);
 	on_congestion = nc ? nc->on_congestion : OC_BLOCK;
+	rcu_read_unlock();
 	if (on_congestion == OC_BLOCK ||
 	    tconn->agreed_pro_version < 96)
 		return;
@@ -960,14 +962,8 @@ static int drbd_process_write_request(struct drbd_request *req)
 	struct drbd_conf *mdev = req->w.mdev;
 	int remote, send_oos;
 
-	rcu_read_lock();
 	remote = drbd_should_do_remote(mdev->state);
-	if (remote) {
-		maybe_pull_ahead(mdev);
-		remote = drbd_should_do_remote(mdev->state);
-	}
 	send_oos = drbd_should_send_out_of_sync(mdev->state);
-	rcu_read_unlock();
 
 	/* Need to replicate writes.  Unless it is an empty flush,
 	 * which is better mapped to a DRBD P_BARRIER packet,
@@ -1087,9 +1083,13 @@ static void drbd_send_and_submit(struct drbd_conf *mdev, struct drbd_request *re
 		 * but will re-aquire it before it returns here.
 		 * Needs to be before the check on drbd_suspended() */
 		complete_conflicting_writes(req);
+		/* no more giving up req_lock from now on! */
+
+		/* check for congestion, and potentially stop sending
+		 * full data updates, but start sending "dirty bits" only. */
+		maybe_pull_ahead(mdev);
 	}
 
-	/* no more giving up req_lock from now on! */
 
 	if (drbd_suspended(mdev)) {
 		/* push back and retry: */
-- 
1.7.9.5

