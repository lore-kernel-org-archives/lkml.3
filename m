Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524Ab3CSRVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:21:47 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44515 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933058Ab3CSRRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:17:02 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, drbd-dev@lists.linbit.com,
        lars.ellenberg@linbit.com
Subject: [PATCH 01/18] drbd: cleanup bogus assert message
Date: Tue, 19 Mar 2013 18:16:42 +0100
Message-Id: <1363713419-17803-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
References: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

This fixes ASSERT( mdev->state.disk == D_FAILED ) in drivers/block/drbd/drbd_main.c

When we detach from local disk, we let the local refcount hit zero twice.

First, we transition to D_FAILED, so we won't give out new references
to incoming requests; we still may give out *internal* references, though.
Once the refcount hits zero [1] while in D_FAILED, we queue a transition
to D_DISKLESS to our worker.  We need to queue it, because we may be in
atomic context when putting the reference.
Once the transition to D_DISKLESS actually happened [2] from worker context,
we don't give out new internal references either.

Between hitting zero the first time [1] and actually transition to
D_DISKLESS [2], there may be a few very short lived internal get/put,
so we may hit zero more than once while being in D_FAILED, or even see a
race where a an internal get_ldev() happened while D_FAILED, but the
corresponding put_ldev() happens just after the transition to D_DISKLESS.

That's why we have the additional test_and_set_bit(GO_DISKLESS,);
and that's why the assert was placed wrong.
Since there was exactly one code path left to drbd_go_diskless(),
and that checks already for D_FAILED, drop that assert,
and fold in the drbd_queue_work().

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    7 ++++---
 drivers/block/drbd/drbd_main.c |    7 -------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 6b51afa..db504d0 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1148,7 +1148,6 @@ extern int drbd_bitmap_io_from_worker(struct drbd_conf *mdev,
 		char *why, enum bm_flag flags);
 extern int drbd_bmio_set_n_write(struct drbd_conf *mdev);
 extern int drbd_bmio_clear_n_write(struct drbd_conf *mdev);
-extern void drbd_go_diskless(struct drbd_conf *mdev);
 extern void drbd_ldev_destroy(struct drbd_conf *mdev);
 
 /* Meta data layout
@@ -2053,9 +2052,11 @@ static inline void put_ldev(struct drbd_conf *mdev)
 		if (mdev->state.disk == D_DISKLESS)
 			/* even internal references gone, safe to destroy */
 			drbd_ldev_destroy(mdev);
-		if (mdev->state.disk == D_FAILED)
+		if (mdev->state.disk == D_FAILED) {
 			/* all application IO references gone. */
-			drbd_go_diskless(mdev);
+			if (!test_and_set_bit(GO_DISKLESS, &mdev->flags))
+				drbd_queue_work(&mdev->tconn->sender_work, &mdev->go_diskless);
+		}
 		wake_up(&mdev->misc_wait);
 	}
 }
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 8c13eeb..6224963 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -3255,13 +3255,6 @@ static int w_go_diskless(struct drbd_work *w, int unused)
 	return 0;
 }
 
-void drbd_go_diskless(struct drbd_conf *mdev)
-{
-	D_ASSERT(mdev->state.disk == D_FAILED);
-	if (!test_and_set_bit(GO_DISKLESS, &mdev->flags))
-		drbd_queue_work(&mdev->tconn->sender_work, &mdev->go_diskless);
-}
-
 /**
  * drbd_queue_bitmap_io() - Queues an IO operation on the whole bitmap
  * @mdev:	DRBD device.
-- 
1.7.9.5

