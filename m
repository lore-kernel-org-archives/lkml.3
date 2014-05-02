Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbaEBP7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:59:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44189 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbaEBPpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:45:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 100/151] dm: take care to copy the space map roots before locking the superblock
Date: Fri,  2 May 2014 08:38:08 -0700
Message-Id: <1399045139-4531-101-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 5a32083d03fb543f63489b2946c4948398579ba0 upstream.

In theory copying the space map root can fail, but in practice it never
does because we're careful to check what size buffer is needed.

But make certain we're able to copy the space map roots before
locking the superblock.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
[ kamal: backport to 3.13-stable (dropped dm-era-target.c changes) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-cache-metadata.c | 60 +++++++++++++++++++------------
 drivers/md/dm-thin-metadata.c  | 80 +++++++++++++++++++++++++-----------------
 2 files changed, 85 insertions(+), 55 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 3e7fd7d..53ab31e 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -120,6 +120,12 @@ struct dm_cache_metadata {
 	unsigned policy_version[CACHE_POLICY_VERSION_SIZE];
 	size_t policy_hint_size;
 	struct dm_cache_statistics stats;
+
+	/*
+	 * Reading the space map root can fail, so we read it into this
+	 * buffer before the superblock is locked and updated.
+	 */
+	__u8 metadata_space_map_root[SPACE_MAP_ROOT_SIZE];
 };
 
 /*-------------------------------------------------------------------
@@ -260,11 +266,31 @@ static void __setup_mapping_info(struct dm_cache_metadata *cmd)
 	}
 }
 
+static int __save_sm_root(struct dm_cache_metadata *cmd)
+{
+	int r;
+	size_t metadata_len;
+
+	r = dm_sm_root_size(cmd->metadata_sm, &metadata_len);
+	if (r < 0)
+		return r;
+
+	return dm_sm_copy_root(cmd->metadata_sm, &cmd->metadata_space_map_root,
+			       metadata_len);
+}
+
+static void __copy_sm_root(struct dm_cache_metadata *cmd,
+			   struct cache_disk_superblock *disk_super)
+{
+	memcpy(&disk_super->metadata_space_map_root,
+	       &cmd->metadata_space_map_root,
+	       sizeof(cmd->metadata_space_map_root));
+}
+
 static int __write_initial_superblock(struct dm_cache_metadata *cmd)
 {
 	int r;
 	struct dm_block *sblock;
-	size_t metadata_len;
 	struct cache_disk_superblock *disk_super;
 	sector_t bdev_size = i_size_read(cmd->bdev->bd_inode) >> SECTOR_SHIFT;
 
@@ -272,12 +298,16 @@ static int __write_initial_superblock(struct dm_cache_metadata *cmd)
 	if (bdev_size > DM_CACHE_METADATA_MAX_SECTORS)
 		bdev_size = DM_CACHE_METADATA_MAX_SECTORS;
 
-	r = dm_sm_root_size(cmd->metadata_sm, &metadata_len);
+	r = dm_tm_pre_commit(cmd->tm);
 	if (r < 0)
 		return r;
 
-	r = dm_tm_pre_commit(cmd->tm);
-	if (r < 0)
+	/*
+	 * dm_sm_copy_root() can fail.  So we need to do it before we start
+	 * updating the superblock.
+	 */
+	r = __save_sm_root(cmd);
+	if (r)
 		return r;
 
 	r = superblock_lock_zero(cmd, &sblock);
@@ -293,10 +323,7 @@ static int __write_initial_superblock(struct dm_cache_metadata *cmd)
 	memset(disk_super->policy_version, 0, sizeof(disk_super->policy_version));
 	disk_super->policy_hint_size = 0;
 
-	r = dm_sm_copy_root(cmd->metadata_sm, &disk_super->metadata_space_map_root,
-			    metadata_len);
-	if (r < 0)
-		goto bad_locked;
+	__copy_sm_root(cmd, disk_super);
 
 	disk_super->mapping_root = cpu_to_le64(cmd->root);
 	disk_super->hint_root = cpu_to_le64(cmd->hint_root);
@@ -313,10 +340,6 @@ static int __write_initial_superblock(struct dm_cache_metadata *cmd)
 	disk_super->write_misses = cpu_to_le32(0);
 
 	return dm_tm_commit(cmd->tm, sblock);
-
-bad_locked:
-	dm_bm_unlock(sblock);
-	return r;
 }
 
 static int __format_metadata(struct dm_cache_metadata *cmd)
@@ -560,7 +583,6 @@ static int __commit_transaction(struct dm_cache_metadata *cmd,
 				flags_mutator mutator)
 {
 	int r;
-	size_t metadata_len;
 	struct cache_disk_superblock *disk_super;
 	struct dm_block *sblock;
 
@@ -578,8 +600,8 @@ static int __commit_transaction(struct dm_cache_metadata *cmd,
 	if (r < 0)
 		return r;
 
-	r = dm_sm_root_size(cmd->metadata_sm, &metadata_len);
-	if (r < 0)
+	r = __save_sm_root(cmd);
+	if (r)
 		return r;
 
 	r = superblock_lock(cmd, &sblock);
@@ -606,13 +628,7 @@ static int __commit_transaction(struct dm_cache_metadata *cmd,
 	disk_super->read_misses = cpu_to_le32(cmd->stats.read_misses);
 	disk_super->write_hits = cpu_to_le32(cmd->stats.write_hits);
 	disk_super->write_misses = cpu_to_le32(cmd->stats.write_misses);
-
-	r = dm_sm_copy_root(cmd->metadata_sm, &disk_super->metadata_space_map_root,
-			    metadata_len);
-	if (r < 0) {
-		dm_bm_unlock(sblock);
-		return r;
-	}
+	__copy_sm_root(cmd, disk_super);
 
 	return dm_tm_commit(cmd->tm, sblock);
 }
diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 3bb4506..07a6ea3 100644
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

