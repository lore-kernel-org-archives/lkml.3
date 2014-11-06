Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbaKFWuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:50:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59108 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbaKFWoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:44:12 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 070/162] ext4: Replace open coded mdata csum feature to helper function
Date: Thu,  6 Nov 2014 14:35:34 -0800
Message-Id: <1415313426-9622-71-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit 9aa5d32ba269bec0e7eaba2697a986a7b0bc8528 upstream.

Besides the fact that this replacement improves code readability
it also protects from errors caused direct EXT4_S(sb)->s_es manipulation
which may result attempt to use uninitialized  csum machinery.

IMG=/dev/ram0
MNT=/mnt
mkfs.ext4 $IMG
mount $IMG $MNT
tune2fs -O metadata_csum  $IMG
touch $MNT/test
umount $MNT

@@
expression E;
@@
- EXT4_HAS_RO_COMPAT_FEATURE(E, EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
+ ext4_has_metadata_csum(E)

https://bugzilla.kernel.org/show_bug.cgi?id=82201

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/bitmap.c  | 12 ++++--------
 fs/ext4/ext4.h    |  8 ++++++++
 fs/ext4/extents.c |  6 ++----
 fs/ext4/ialloc.c  |  3 +--
 fs/ext4/inline.c  |  3 +--
 fs/ext4/inode.c   |  9 +++------
 fs/ext4/ioctl.c   |  3 +--
 fs/ext4/mmp.c     |  6 ++----
 fs/ext4/namei.c   | 39 +++++++++++++--------------------------
 fs/ext4/resize.c  |  3 +--
 fs/ext4/super.c   | 15 +++++----------
 fs/ext4/xattr.c   |  6 ++----
 12 files changed, 43 insertions(+), 70 deletions(-)

diff --git a/fs/ext4/bitmap.c b/fs/ext4/bitmap.c
index 3285aa5..b610779 100644
--- a/fs/ext4/bitmap.c
+++ b/fs/ext4/bitmap.c
@@ -24,8 +24,7 @@ int ext4_inode_bitmap_csum_verify(struct super_block *sb, ext4_group_t group,
 	__u32 provided, calculated;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
-	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext4_has_metadata_csum(sb))
 		return 1;
 
 	provided = le16_to_cpu(gdp->bg_inode_bitmap_csum_lo);
@@ -46,8 +45,7 @@ void ext4_inode_bitmap_csum_set(struct super_block *sb, ext4_group_t group,
 	__u32 csum;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
-	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext4_has_metadata_csum(sb))
 		return;
 
 	csum = ext4_chksum(sbi, sbi->s_csum_seed, (__u8 *)bh->b_data, sz);
@@ -65,8 +63,7 @@ int ext4_block_bitmap_csum_verify(struct super_block *sb, ext4_group_t group,
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int sz = EXT4_CLUSTERS_PER_GROUP(sb) / 8;
 
-	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext4_has_metadata_csum(sb))
 		return 1;
 
 	provided = le16_to_cpu(gdp->bg_block_bitmap_csum_lo);
@@ -91,8 +88,7 @@ void ext4_block_bitmap_csum_set(struct super_block *sb, ext4_group_t group,
 	__u32 csum;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
-	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
-			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext4_has_metadata_csum(sb))
 		return;
 
 	csum = ext4_chksum(sbi, sbi->s_csum_seed, (__u8 *)bh->b_data, sz);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c9d0794..0e9930f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2345,6 +2345,14 @@ static inline int ext4_has_group_desc_csum(struct super_block *sb)
 					  EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
 }
 
+static inline int ext4_has_metadata_csum(struct super_block *sb)
+{
+	WARN_ON_ONCE(EXT4_HAS_RO_COMPAT_FEATURE(sb,
+			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+		     !EXT4_SB(sb)->s_chksum_driver);
+
+	return (EXT4_SB(sb)->s_chksum_driver != NULL);
+}
 static inline ext4_fsblk_t ext4_blocks_count(struct ext4_super_block *es)
 {
 	return ((ext4_fsblk_t)le32_to_cpu(es->s_blocks_count_hi) << 32) |
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3a09bb7..da05fe2 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -74,8 +74,7 @@ static int ext4_extent_block_csum_verify(struct inode *inode,
 {
 	struct ext4_extent_tail *et;
 
-	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
-		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext4_has_metadata_csum(inode->i_sb))
 		return 1;
 
 	et = find_ext4_extent_tail(eh);
@@ -89,8 +88,7 @@ static void ext4_extent_block_csum_set(struct inode *inode,
 {
 	struct ext4_extent_tail *et;
 
-	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
-		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext4_has_metadata_csum(inode->i_sb))
 		return;
 
 	et = find_ext4_extent_tail(eh);
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 64bb32f1..158ddf6 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -988,8 +988,7 @@ got:
 	spin_unlock(&sbi->s_next_gen_lock);
 
 	/* Precompute checksum seed for inode metadata */
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
-			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+	if (ext4_has_metadata_csum(sb)) {
 		__u32 csum;
 		__le32 inum = cpu_to_le32(inode->i_ino);
 		__le32 gen = cpu_to_le32(inode->i_generation);
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 7f03208..3af1fc4 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1124,8 +1124,7 @@ static int ext4_finish_convert_inline_dir(handle_t *handle,
 	memcpy((void *)de, buf + EXT4_INLINE_DOTDOT_SIZE,
 		inline_size - EXT4_INLINE_DOTDOT_SIZE);
 
-	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (ext4_has_metadata_csum(inode->i_sb))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
 	inode->i_size = inode->i_sb->s_blocksize;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 37a8c8b..f2a02dd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -83,8 +83,7 @@ static int ext4_inode_csum_verify(struct inode *inode, struct ext4_inode *raw,
 
 	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
 	    cpu_to_le32(EXT4_OS_LINUX) ||
-	    !EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
-		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	    !ext4_has_metadata_csum(inode->i_sb))
 		return 1;
 
 	provided = le16_to_cpu(raw->i_checksum_lo);
@@ -105,8 +104,7 @@ static void ext4_inode_csum_set(struct inode *inode, struct ext4_inode *raw,
 
 	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
 	    cpu_to_le32(EXT4_OS_LINUX) ||
-	    !EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
-		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	    !ext4_has_metadata_csum(inode->i_sb))
 		return;
 
 	csum = ext4_inode_csum(inode, raw, ei);
@@ -4086,8 +4084,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 		ei->i_extra_isize = 0;
 
 	/* Precompute checksum seed for inode metadata */
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
-			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+	if (ext4_has_metadata_csum(sb)) {
 		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 		__u32 csum;
 		__le32 inum = cpu_to_le32(inode->i_ino);
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 2c3541b..fdcadc9 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -347,8 +347,7 @@ flags_out:
 		if (!inode_owner_or_capable(inode))
 			return -EPERM;
 
-		if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
-				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+		if (ext4_has_metadata_csum(inode->i_sb)) {
 			ext4_warning(sb, "Setting inode version is not "
 				     "supported with metadata_csum enabled.");
 			return -ENOTTY;
diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 04434ad..1268a1b 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -20,8 +20,7 @@ static __le32 ext4_mmp_csum(struct super_block *sb, struct mmp_struct *mmp)
 
 int ext4_mmp_csum_verify(struct super_block *sb, struct mmp_struct *mmp)
 {
-	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext4_has_metadata_csum(sb))
 		return 1;
 
 	return mmp->mmp_checksum == ext4_mmp_csum(sb, mmp);
@@ -29,8 +28,7 @@ int ext4_mmp_csum_verify(struct super_block *sb, struct mmp_struct *mmp)
 
 void ext4_mmp_csum_set(struct super_block *sb, struct mmp_struct *mmp)
 {
-	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext4_has_metadata_csum(sb))
 		return;
 
 	mmp->mmp_checksum = ext4_mmp_csum(sb, mmp);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 5bfbf94..08de398 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -123,8 +123,7 @@ static struct buffer_head *__ext4_read_dirblock(struct inode *inode,
 		       "directory leaf block found instead of index block");
 		return ERR_PTR(-EIO);
 	}
-	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) ||
+	if (!ext4_has_metadata_csum(inode->i_sb) ||
 	    buffer_verified(bh))
 		return bh;
 
@@ -339,8 +338,7 @@ int ext4_dirent_csum_verify(struct inode *inode, struct ext4_dir_entry *dirent)
 {
 	struct ext4_dir_entry_tail *t;
 
-	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext4_has_metadata_csum(inode->i_sb))
 		return 1;
 
 	t = get_dirent_tail(inode, dirent);
@@ -361,8 +359,7 @@ static void ext4_dirent_csum_set(struct inode *inode,
 {
 	struct ext4_dir_entry_tail *t;
 
-	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext4_has_metadata_csum(inode->i_sb))
 		return;
 
 	t = get_dirent_tail(inode, dirent);
@@ -437,8 +434,7 @@ static int ext4_dx_csum_verify(struct inode *inode,
 	struct dx_tail *t;
 	int count_offset, limit, count;
 
-	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext4_has_metadata_csum(inode->i_sb))
 		return 1;
 
 	c = get_dx_countlimit(inode, dirent, &count_offset);
@@ -467,8 +463,7 @@ static void ext4_dx_csum_set(struct inode *inode, struct ext4_dir_entry *dirent)
 	struct dx_tail *t;
 	int count_offset, limit, count;
 
-	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext4_has_metadata_csum(inode->i_sb))
 		return;
 
 	c = get_dx_countlimit(inode, dirent, &count_offset);
@@ -556,8 +551,7 @@ static inline unsigned dx_root_limit(struct inode *dir, unsigned infosize)
 	unsigned entry_space = dir->i_sb->s_blocksize - EXT4_DIR_REC_LEN(1) -
 		EXT4_DIR_REC_LEN(2) - infosize;
 
-	if (EXT4_HAS_RO_COMPAT_FEATURE(dir->i_sb,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (ext4_has_metadata_csum(dir->i_sb))
 		entry_space -= sizeof(struct dx_tail);
 	return entry_space / sizeof(struct dx_entry);
 }
@@ -566,8 +560,7 @@ static inline unsigned dx_node_limit(struct inode *dir)
 {
 	unsigned entry_space = dir->i_sb->s_blocksize - EXT4_DIR_REC_LEN(0);
 
-	if (EXT4_HAS_RO_COMPAT_FEATURE(dir->i_sb,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (ext4_has_metadata_csum(dir->i_sb))
 		entry_space -= sizeof(struct dx_tail);
 	return entry_space / sizeof(struct dx_entry);
 }
@@ -1535,8 +1528,7 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	int	csum_size = 0;
 	int	err = 0, i;
 
-	if (EXT4_HAS_RO_COMPAT_FEATURE(dir->i_sb,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (ext4_has_metadata_csum(dir->i_sb))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
 	bh2 = ext4_append(handle, dir, &newblock);
@@ -1705,8 +1697,7 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
 	int		csum_size = 0;
 	int		err;
 
-	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (ext4_has_metadata_csum(inode->i_sb))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
 	if (!de) {
@@ -1773,8 +1764,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	struct fake_dirent *fde;
 	int		csum_size = 0;
 
-	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (ext4_has_metadata_csum(inode->i_sb))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
 	blocksize =  dir->i_sb->s_blocksize;
@@ -1890,8 +1880,7 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 	ext4_lblk_t block, blocks;
 	int	csum_size = 0;
 
-	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (ext4_has_metadata_csum(inode->i_sb))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
 	sb = dir->i_sb;
@@ -2153,8 +2142,7 @@ static int ext4_delete_entry(handle_t *handle,
 			return err;
 	}
 
-	if (EXT4_HAS_RO_COMPAT_FEATURE(dir->i_sb,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (ext4_has_metadata_csum(dir->i_sb))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
 	BUFFER_TRACE(bh, "get_write_access");
@@ -2373,8 +2361,7 @@ static int ext4_init_new_dir(handle_t *handle, struct inode *dir,
 	int csum_size = 0;
 	int err;
 
-	if (EXT4_HAS_RO_COMPAT_FEATURE(dir->i_sb,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (ext4_has_metadata_csum(dir->i_sb))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
 	if (ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index f3b84cd..14e0f8a 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1200,8 +1200,7 @@ static int ext4_set_bitmap_checksums(struct super_block *sb,
 {
 	struct buffer_head *bh;
 
-	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext4_has_metadata_csum(sb))
 		return 0;
 
 	bh = ext4_get_bitmap(sb, group_data->inode_bitmap);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c888f23..6686ce4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -140,8 +140,7 @@ static __le32 ext4_superblock_csum(struct super_block *sb,
 int ext4_superblock_csum_verify(struct super_block *sb,
 				struct ext4_super_block *es)
 {
-	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext4_has_metadata_csum(sb))
 		return 1;
 
 	return es->s_checksum == ext4_superblock_csum(sb, es);
@@ -151,8 +150,7 @@ void ext4_superblock_csum_set(struct super_block *sb)
 {
 	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
 
-	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
-		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext4_has_metadata_csum(sb))
 		return;
 
 	es->s_checksum = ext4_superblock_csum(sb, es);
@@ -2003,8 +2001,7 @@ static __le16 ext4_group_desc_csum(struct ext4_sb_info *sbi, __u32 block_group,
 	__u16 crc = 0;
 	__le32 le_group = cpu_to_le32(block_group);
 
-	if ((sbi->s_es->s_feature_ro_compat &
-	     cpu_to_le32(EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))) {
+	if (ext4_has_metadata_csum(sbi->s_sb)) {
 		/* Use new metadata_csum algorithm */
 		__le16 save_csum;
 		__u32 csum32;
@@ -3160,8 +3157,7 @@ static int set_journal_csum_feature_set(struct super_block *sb)
 	int compat, incompat;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+	if (ext4_has_metadata_csum(sb)) {
 		/* journal checksum v3 */
 		compat = 0;
 		incompat = JBD2_FEATURE_INCOMPAT_CSUM_V3;
@@ -3468,8 +3464,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	/* Precompute checksum seed for all metadata */
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
-			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (ext4_has_metadata_csum(sb))
 		sbi->s_csum_seed = ext4_chksum(sbi, ~0, es->s_uuid,
 					       sizeof(es->s_uuid));
 
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index a20816e..a5d2f1b 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -141,8 +141,7 @@ static int ext4_xattr_block_csum_verify(struct inode *inode,
 					sector_t block_nr,
 					struct ext4_xattr_header *hdr)
 {
-	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
-		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	if (ext4_has_metadata_csum(inode->i_sb) &&
 	    (hdr->h_checksum != ext4_xattr_block_csum(inode, block_nr, hdr)))
 		return 0;
 	return 1;
@@ -152,8 +151,7 @@ static void ext4_xattr_block_csum_set(struct inode *inode,
 				      sector_t block_nr,
 				      struct ext4_xattr_header *hdr)
 {
-	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
-		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext4_has_metadata_csum(inode->i_sb))
 		return;
 
 	hdr->h_checksum = ext4_xattr_block_csum(inode, block_nr, hdr);
-- 
1.9.1

