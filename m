Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532Ab3CSRS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:18:29 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44776 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933370Ab3CSRRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:17:06 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, drbd-dev@lists.linbit.com,
        lars.ellenberg@linbit.com
Subject: [PATCH 13/18] drbd: queue writes on submitter thread, unless they pass the activity log fastpath
Date: Tue, 19 Mar 2013 18:16:54 +0100
Message-Id: <1363713419-17803-14-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
References: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_req.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 4af709e..43bc1d0 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1020,6 +1020,14 @@ drbd_submit_req_private_bio(struct drbd_request *req)
 		bio_endio(bio, -EIO);
 }
 
+static void drbd_queue_write(struct drbd_conf *mdev, struct drbd_request *req)
+{
+	spin_lock(&mdev->submit.lock);
+	list_add_tail(&req->tl_requests, &mdev->submit.writes);
+	spin_unlock(&mdev->submit.lock);
+	queue_work(mdev->submit.wq, &mdev->submit.worker);
+}
+
 /* returns the new drbd_request pointer, if the caller is expected to
  * drbd_send_and_submit() it (to save latency), or NULL if we queued the
  * request on the submitter thread.
@@ -1048,17 +1056,13 @@ drbd_request_prepare(struct drbd_conf *mdev, struct bio *bio, unsigned long star
 		req->private_bio = NULL;
 	}
 
-	/* For WRITES going to the local disk, grab a reference on the target
-	 * extent.  This waits for any resync activity in the corresponding
-	 * resync extent to finish, and, if necessary, pulls in the target
-	 * extent into the activity log, which involves further disk io because
-	 * of transactional on-disk meta data updates.
-	 * Empty flushes don't need to go into the activity log, they can only
-	 * flush data for pending writes which are already in there. */
 	if (rw == WRITE && req->private_bio && req->i.size
 	&& !test_bit(AL_SUSPENDED, &mdev->flags)) {
+		if (!drbd_al_begin_io_fastpath(mdev, &req->i)) {
+			drbd_queue_write(mdev, req);
+			return NULL;
+		}
 		req->rq_state |= RQ_IN_ACT_LOG;
-		drbd_al_begin_io(mdev, &req->i, true);
 	}
 
 	return req;
-- 
1.7.9.5

