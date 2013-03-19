Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463Ab3CSRRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:17:53 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44800 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933045Ab3CSRRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:17:07 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, drbd-dev@lists.linbit.com,
        lars.ellenberg@linbit.com
Subject: [PATCH 17/18] drbd: try hard to max out the updates per AL transaction
Date: Tue, 19 Mar 2013 18:16:58 +0100
Message-Id: <1363713419-17803-18-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
References: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

There may have been more incoming requests while we where preparing
the current transaction. Try to consolidate more updates into this
transaction until we make no more progres.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_req.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index d72f2fe..9f7ff1c 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1226,6 +1226,37 @@ void do_submit(struct work_struct *ws)
 			break;
 
 		wait_event(mdev->al_wait, prepare_al_transaction_nonblock(mdev, &incoming, &pending));
+		/* Maybe more was queued, while we prepared the transaction?
+		 * Try to stuff them into this transaction as well.
+		 * Be strictly non-blocking here, no wait_event, we already
+		 * have something to commit.
+		 * Stop if we don't make any more progres.
+		 */
+		for (;;) {
+			LIST_HEAD(more_pending);
+			LIST_HEAD(more_incoming);
+			bool made_progress;
+
+			/* It is ok to look outside the lock,
+			 * it's only an optimization anyways */
+			if (list_empty(&mdev->submit.writes))
+				break;
+
+			spin_lock(&mdev->submit.lock);
+			list_splice_tail_init(&mdev->submit.writes, &more_incoming);
+			spin_unlock(&mdev->submit.lock);
+
+			if (list_empty(&more_incoming))
+				break;
+
+			made_progress = prepare_al_transaction_nonblock(mdev, &more_incoming, &more_pending);
+
+			list_splice_tail_init(&more_pending, &pending);
+			list_splice_tail_init(&more_incoming, &incoming);
+
+			if (!made_progress)
+				break;
+		}
 		drbd_al_begin_io_commit(mdev, false);
 
 		list_for_each_entry_safe(req, tmp, &pending, tl_requests) {
-- 
1.7.9.5

