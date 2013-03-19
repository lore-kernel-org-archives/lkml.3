Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604Ab3CSRSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:18:32 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44701 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933335Ab3CSRRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:17:06 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, drbd-dev@lists.linbit.com,
        lars.ellenberg@linbit.com
Subject: [PATCH 12/18] drbd: split out some helper functions to drbd_al_begin_io
Date: Tue, 19 Mar 2013 18:16:53 +0100
Message-Id: <1363713419-17803-13-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
References: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

To make the code easier to follow,
use an explicit find_active_resync_extent(),
and add a "nonblock" parameter to _al_get().

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c |   49 ++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index e4f1231..ff03f90 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -222,25 +222,37 @@ int drbd_md_sync_page_io(struct drbd_conf *mdev, struct drbd_backing_dev *bdev,
 	return err;
 }
 
-static struct lc_element *_al_get(struct drbd_conf *mdev, unsigned int enr)
+static struct bm_extent *find_active_resync_extent(struct drbd_conf *mdev, unsigned int enr)
 {
-	struct lc_element *al_ext;
 	struct lc_element *tmp;
-	int wake;
-
-	spin_lock_irq(&mdev->al_lock);
 	tmp = lc_find(mdev->resync, enr/AL_EXT_PER_BM_SECT);
 	if (unlikely(tmp != NULL)) {
 		struct bm_extent  *bm_ext = lc_entry(tmp, struct bm_extent, lce);
-		if (test_bit(BME_NO_WRITES, &bm_ext->flags)) {
-			wake = !test_and_set_bit(BME_PRIORITY, &bm_ext->flags);
-			spin_unlock_irq(&mdev->al_lock);
-			if (wake)
-				wake_up(&mdev->al_wait);
-			return NULL;
-		}
+		if (test_bit(BME_NO_WRITES, &bm_ext->flags))
+			return bm_ext;
 	}
-	al_ext = lc_get(mdev->act_log, enr);
+	return NULL;
+}
+
+static struct lc_element *_al_get(struct drbd_conf *mdev, unsigned int enr, bool nonblock)
+{
+	struct lc_element *al_ext;
+	struct bm_extent *bm_ext;
+	int wake;
+
+	spin_lock_irq(&mdev->al_lock);
+	bm_ext = find_active_resync_extent(mdev, enr);
+	if (bm_ext) {
+		wake = !test_and_set_bit(BME_PRIORITY, &bm_ext->flags);
+		spin_unlock_irq(&mdev->al_lock);
+		if (wake)
+			wake_up(&mdev->al_wait);
+		return NULL;
+	}
+	if (nonblock)
+		al_ext = lc_try_get(mdev->act_log, enr);
+	else
+		al_ext = lc_get(mdev->act_log, enr);
 	spin_unlock_irq(&mdev->al_lock);
 	return al_ext;
 }
@@ -251,7 +263,6 @@ bool drbd_al_begin_io_fastpath(struct drbd_conf *mdev, struct drbd_interval *i)
 	 * we may need to activate two extents in one go */
 	unsigned first = i->sector >> (AL_EXTENT_SHIFT-9);
 	unsigned last = i->size == 0 ? first : (i->sector + (i->size >> 9) - 1) >> (AL_EXTENT_SHIFT-9);
-	bool fastpath_ok = true;
 
 	D_ASSERT((unsigned)(last - first) <= 1);
 	D_ASSERT(atomic_read(&mdev->local_cnt) > 0);
@@ -260,12 +271,7 @@ bool drbd_al_begin_io_fastpath(struct drbd_conf *mdev, struct drbd_interval *i)
 	if (first != last)
 		return false;
 
-	spin_lock_irq(&mdev->al_lock);
-	fastpath_ok =
-		lc_find(mdev->resync, first/AL_EXT_PER_BM_SECT) == NULL &&
-		lc_try_get(mdev->act_log, first) != NULL;
-	spin_unlock_irq(&mdev->al_lock);
-	return fastpath_ok;
+	return _al_get(mdev, first, true);
 }
 
 bool drbd_al_begin_io_prepare(struct drbd_conf *mdev, struct drbd_interval *i)
@@ -282,7 +288,8 @@ bool drbd_al_begin_io_prepare(struct drbd_conf *mdev, struct drbd_interval *i)
 
 	for (enr = first; enr <= last; enr++) {
 		struct lc_element *al_ext;
-		wait_event(mdev->al_wait, (al_ext = _al_get(mdev, enr)) != NULL);
+		wait_event(mdev->al_wait,
+				(al_ext = _al_get(mdev, enr, false)) != NULL);
 		if (al_ext->lc_number != enr)
 			need_transaction = true;
 	}
-- 
1.7.9.5

