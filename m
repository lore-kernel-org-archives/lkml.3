Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432Ab3CSRRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:17:09 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44518 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933067Ab3CSRRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:17:02 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, drbd-dev@lists.linbit.com,
        lars.ellenberg@linbit.com
Subject: [PATCH 04/18] drbd: use the cached meta_dev_idx
Date: Tue, 19 Mar 2013 18:16:45 +0100
Message-Id: <1363713419-17803-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
References: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Now we have the cached meta_dev_idx member,
we can get rid of a few rcu_read_lock() sections and rcu_dereference().

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h |   32 +++++---------------------------
 drivers/block/drbd/drbd_nl.c  |    7 +------
 2 files changed, 6 insertions(+), 33 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index ee19ba2..6eecdec 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1777,9 +1777,9 @@ static inline void drbd_chk_io_error_(struct drbd_conf *mdev,
  * BTW, for internal meta data, this happens to be the maximum capacity
  * we could agree upon with our peer node.
  */
-static inline sector_t _drbd_md_first_sector(int meta_dev_idx, struct drbd_backing_dev *bdev)
+static inline sector_t drbd_md_first_sector(struct drbd_backing_dev *bdev)
 {
-	switch (meta_dev_idx) {
+	switch (bdev->md.meta_dev_idx) {
 	case DRBD_MD_INDEX_INTERNAL:
 	case DRBD_MD_INDEX_FLEX_INT:
 		return bdev->md.md_offset + bdev->md.bm_offset;
@@ -1789,30 +1789,13 @@ static inline sector_t _drbd_md_first_sector(int meta_dev_idx, struct drbd_backi
 	}
 }
 
-static inline sector_t drbd_md_first_sector(struct drbd_backing_dev *bdev)
-{
-	int meta_dev_idx;
-
-	rcu_read_lock();
-	meta_dev_idx = rcu_dereference(bdev->disk_conf)->meta_dev_idx;
-	rcu_read_unlock();
-
-	return _drbd_md_first_sector(meta_dev_idx, bdev);
-}
-
 /**
  * drbd_md_last_sector() - Return the last sector number of the meta data area
  * @bdev:	Meta data block device.
  */
 static inline sector_t drbd_md_last_sector(struct drbd_backing_dev *bdev)
 {
-	int meta_dev_idx;
-
-	rcu_read_lock();
-	meta_dev_idx = rcu_dereference(bdev->disk_conf)->meta_dev_idx;
-	rcu_read_unlock();
-
-	switch (meta_dev_idx) {
+	switch (bdev->md.meta_dev_idx) {
 	case DRBD_MD_INDEX_INTERNAL:
 	case DRBD_MD_INDEX_FLEX_INT:
 		return bdev->md.md_offset + MD_4kB_SECT -1;
@@ -1840,18 +1823,13 @@ static inline sector_t drbd_get_capacity(struct block_device *bdev)
 static inline sector_t drbd_get_max_capacity(struct drbd_backing_dev *bdev)
 {
 	sector_t s;
-	int meta_dev_idx;
-
-	rcu_read_lock();
-	meta_dev_idx = rcu_dereference(bdev->disk_conf)->meta_dev_idx;
-	rcu_read_unlock();
 
-	switch (meta_dev_idx) {
+	switch (bdev->md.meta_dev_idx) {
 	case DRBD_MD_INDEX_INTERNAL:
 	case DRBD_MD_INDEX_FLEX_INT:
 		s = drbd_get_capacity(bdev->backing_bdev)
 			? min_t(sector_t, DRBD_MAX_SECTORS_FLEX,
-				_drbd_md_first_sector(meta_dev_idx, bdev))
+				drbd_md_first_sector(bdev))
 			: 0;
 		break;
 	case DRBD_MD_INDEX_FLEX_EXT:
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 104b7ce..5621df8 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -722,14 +722,10 @@ static void drbd_md_set_sector_offsets(struct drbd_conf *mdev,
 {
 	sector_t md_size_sect = 0;
 	unsigned int al_size_sect = MD_32kB_SECT;
-	int meta_dev_idx;
-
-	rcu_read_lock();
-	meta_dev_idx = rcu_dereference(bdev->disk_conf)->meta_dev_idx;
 
 	bdev->md.md_offset = drbd_md_ss(bdev);
 
-	switch (meta_dev_idx) {
+	switch (bdev->md.meta_dev_idx) {
 	default:
 		/* v07 style fixed size indexed meta data */
 		bdev->md.md_size_sect = MD_128MB_SECT;
@@ -761,7 +757,6 @@ static void drbd_md_set_sector_offsets(struct drbd_conf *mdev,
 		bdev->md.bm_offset   = -md_size_sect + MD_4kB_SECT;
 		break;
 	}
-	rcu_read_unlock();
 }
 
 /* input size is expected to be in KB */
-- 
1.7.9.5

