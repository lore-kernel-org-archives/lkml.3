Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbaDVVGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:06:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36324 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757680AbaDVUTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:19:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 099/133] dm: take care to copy the space map roots before locking the superblock
Date: Tue, 22 Apr 2014 13:13:57 -0700
Message-Id: <1398197671-12786-100-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 5a32083d03fb543f63489b2946c4948398579ba0 upstream.

In theory copying the space map root can fail, but in practice it never
does because we're careful to check what size buffer is needed.

But make certain we're able to copy the space map roots before
locking the superblock.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
[ kamal: backport to 3.8 (no dm-cache-metadata.c, dm-era-target.c) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-thin-metadata.c | 80 +++++++++++++++++++++++++------------------
 1 file changed, 47 insertions(+), 33 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 4f67945..f074f92 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -192,6 +192,13 @@ struct dm_pool_metadata {
 	 * operation possible in this state is the closing of the device.
 	 */
 	bool fail_io:1;
+
+	/*
+	 * Reading the space map roots can fail, so we read it into these
+	 * buffers before the superblock is locked and updated.
+	 */
+	__u8 data_space_map_root[SPACE_MAP_ROOT_SIZE];
+	__u8 metadata_space_map_root[SPACE_MAP_ROOT_SIZE];
 };
 
 struct dm_thin_device {
@@ -431,26 +438,53 @@ static void __setup_btree_details(struct dm_pool_metadata *pmd)
 	pmd->details_info.value_type.equal = NULL;
 }
 
+static int save_sm_roots(struct dm_pool_metadata *pmd)
+{
+	int r;
+	size_t len;
+
+	r = dm_sm_root_size(pmd->metadata_sm, &len);
+	if (r < 0)
+		return r;
+
+	r = dm_sm_copy_root(pmd->metadata_sm, &pmd->metadata_space_map_root, len);
+	if (r < 0)
+		return r;
+
+	r = dm_sm_root_size(pmd->data_sm, &len);
+	if (r < 0)
+		return r;
+
+	return dm_sm_copy_root(pmd->data_sm, &pmd->data_space_map_root, len);
+}
+
+static void copy_sm_roots(struct dm_pool_metadata *pmd,
+			  struct thin_disk_superblock *disk)
+{
+	memcpy(&disk->metadata_space_map_root,
+	       &pmd->metadata_space_map_root,
+	       sizeof(pmd->metadata_space_map_root));
+
+	memcpy(&disk->data_space_map_root,
+	       &pmd->data_space_map_root,
+	       sizeof(pmd->data_space_map_root));
+}
+
 static int __write_initial_superblock(struct dm_pool_metadata *pmd)
 {
 	int r;
 	struct dm_block *sblock;
-	size_t metadata_len, data_len;
 	struct thin_disk_superblock *disk_super;
 	sector_t bdev_size = i_size_read(pmd->bdev->bd_inode) >> SECTOR_SHIFT;
 
 	if (bdev_size > THIN_METADATA_MAX_SECTORS)
 		bdev_size = THIN_METADATA_MAX_SECTORS;
 
-	r = dm_sm_root_size(pmd->metadata_sm, &metadata_len);
-	if (r < 0)
-		return r;
-
-	r = dm_sm_root_size(pmd->data_sm, &data_len);
+	r = dm_sm_commit(pmd->data_sm);
 	if (r < 0)
 		return r;
 
-	r = dm_sm_commit(pmd->data_sm);
+	r = save_sm_roots(pmd);
 	if (r < 0)
 		return r;
 
@@ -471,15 +505,7 @@ static int __write_initial_superblock(struct dm_pool_metadata *pmd)
 	disk_super->trans_id = 0;
 	disk_super->held_root = 0;
 
-	r = dm_sm_copy_root(pmd->metadata_sm, &disk_super->metadata_space_map_root,
-			    metadata_len);
-	if (r < 0)
-		goto bad_locked;
-
-	r = dm_sm_copy_root(pmd->data_sm, &disk_super->data_space_map_root,
-			    data_len);
-	if (r < 0)
-		goto bad_locked;
+	copy_sm_roots(pmd, disk_super);
 
 	disk_super->data_mapping_root = cpu_to_le64(pmd->root);
 	disk_super->device_details_root = cpu_to_le64(pmd->details_root);
@@ -488,10 +514,6 @@ static int __write_initial_superblock(struct dm_pool_metadata *pmd)
 	disk_super->data_block_size = cpu_to_le32(pmd->data_block_size);
 
 	return dm_tm_commit(pmd->tm, sblock);
-
-bad_locked:
-	dm_bm_unlock(sblock);
-	return r;
 }
 
 static int __format_metadata(struct dm_pool_metadata *pmd)
@@ -769,6 +791,10 @@ static int __commit_transaction(struct dm_pool_metadata *pmd)
 	if (r < 0)
 		return r;
 
+	r = save_sm_roots(pmd);
+	if (r < 0)
+		return r;
+
 	r = superblock_lock(pmd, &sblock);
 	if (r)
 		return r;
@@ -780,21 +806,9 @@ static int __commit_transaction(struct dm_pool_metadata *pmd)
 	disk_super->trans_id = cpu_to_le64(pmd->trans_id);
 	disk_super->flags = cpu_to_le32(pmd->flags);
 
-	r = dm_sm_copy_root(pmd->metadata_sm, &disk_super->metadata_space_map_root,
-			    metadata_len);
-	if (r < 0)
-		goto out_locked;
-
-	r = dm_sm_copy_root(pmd->data_sm, &disk_super->data_space_map_root,
-			    data_len);
-	if (r < 0)
-		goto out_locked;
+	copy_sm_roots(pmd, disk_super);
 
 	return dm_tm_commit(pmd->tm, sblock);
-
-out_locked:
-	dm_bm_unlock(sblock);
-	return r;
 }
 
 struct dm_pool_metadata *dm_pool_metadata_open(struct block_device *bdev,
-- 
1.9.1

