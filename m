Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbaLULG1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 06:06:27 -0500
Received: from xavier.telenet-ops.be ([195.130.132.52]:45567 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaLULGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 06:06:23 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] fs/affs: Fix casting in printed messages
Date: Sun, 21 Dec 2014 12:06:18 +0100
Message-Id: <1419159978-13303-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  - "inode.i_ino" is "unsigned long",
  - "loff_t" is always "unsigned long long",
  - "sector_t" should be cast to "unsigned long long" for printing,
  - "u32" should not be cast to "unsigned int" for printing.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/affs/amigaffs.c |  6 +++---
 fs/affs/dir.c      |  8 +++-----
 fs/affs/file.c     | 36 ++++++++++++++++++------------------
 fs/affs/inode.c    |  5 ++---
 fs/affs/namei.c    | 18 +++++++-----------
 5 files changed, 33 insertions(+), 40 deletions(-)

diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index c852f2fa17102a24..511ab6b126183ef8 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -30,7 +30,7 @@ affs_insert_hash(struct inode *dir, struct buffer_head *bh)
 	ino = bh->b_blocknr;
 	offset = affs_hash_name(sb, AFFS_TAIL(sb, bh)->name + 1, AFFS_TAIL(sb, bh)->name[0]);
 
-	pr_debug("%s(dir=%u, ino=%d)\n", __func__, (u32)dir->i_ino, ino);
+	pr_debug("%s(dir=%lu, ino=%d)\n", __func__, dir->i_ino, ino);
 
 	dir_bh = affs_bread(sb, dir->i_ino);
 	if (!dir_bh)
@@ -80,8 +80,8 @@ affs_remove_hash(struct inode *dir, struct buffer_head *rem_bh)
 	sb = dir->i_sb;
 	rem_ino = rem_bh->b_blocknr;
 	offset = affs_hash_name(sb, AFFS_TAIL(sb, rem_bh)->name+1, AFFS_TAIL(sb, rem_bh)->name[0]);
-	pr_debug("%s(dir=%d, ino=%d, hashval=%d)\n",
-		 __func__, (u32)dir->i_ino, rem_ino, offset);
+	pr_debug("%s(dir=%lu, ino=%d, hashval=%d)\n", __func__, dir->i_ino,
+		 rem_ino, offset);
 
 	bh = affs_bread(sb, dir->i_ino);
 	if (!bh)
diff --git a/fs/affs/dir.c b/fs/affs/dir.c
index 59f07bec92a6c189..a682892878a829e4 100644
--- a/fs/affs/dir.c
+++ b/fs/affs/dir.c
@@ -54,8 +54,7 @@ affs_readdir(struct file *file, struct dir_context *ctx)
 	u32			 ino;
 	int			 error = 0;
 
-	pr_debug("%s(ino=%lu,f_pos=%lx)\n",
-		 __func__, inode->i_ino, (unsigned long)ctx->pos);
+	pr_debug("%s(ino=%lu,f_pos=%llx)\n", __func__, inode->i_ino, ctx->pos);
 
 	if (ctx->pos < 2) {
 		file->private_data = (void *)0;
@@ -117,9 +116,8 @@ inside:
 
 			namelen = min(AFFS_TAIL(sb, fh_bh)->name[0], (u8)30);
 			name = AFFS_TAIL(sb, fh_bh)->name + 1;
-			pr_debug("readdir(): dir_emit(\"%.*s\", "
-				 "ino=%u), hash=%d, f_pos=%x\n",
-				 namelen, name, ino, hash_pos, (u32)ctx->pos);
+			pr_debug("readdir(): dir_emit(\"%.*s\", ino=%u), hash=%d, f_pos=%llx\n",
+				 namelen, name, ino, hash_pos, ctx->pos);
 
 			if (!dir_emit(ctx, name, namelen, ino, DT_UNKNOWN))
 				goto done;
diff --git a/fs/affs/file.c b/fs/affs/file.c
index 8faa6593ca6defe4..40a024a9b41deb88 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -299,8 +299,8 @@ affs_get_block(struct inode *inode, sector_t block, struct buffer_head *bh_resul
 	struct buffer_head	*ext_bh;
 	u32			 ext;
 
-	pr_debug("%s(%u, %lu)\n",
-		 __func__, (u32)inode->i_ino, (unsigned long)block);
+	pr_debug("%s(%lu, %llu)\n", __func__, inode->i_ino,
+		 (unsigned long long)block);
 
 	BUG_ON(block > (sector_t)0x7fffffffUL);
 
@@ -330,8 +330,9 @@ affs_get_block(struct inode *inode, sector_t block, struct buffer_head *bh_resul
 
 		/* store new block */
 		if (bh_result->b_blocknr)
-			affs_warning(sb, "get_block", "block already set (%lx)",
-				     (unsigned long)bh_result->b_blocknr);
+			affs_warning(sb, "get_block",
+				     "block already set (%llx)",
+				     (unsigned long long)bh_result->b_blocknr);
 		AFFS_BLOCK(sb, ext_bh, block) = cpu_to_be32(blocknr);
 		AFFS_HEAD(ext_bh)->block_count = cpu_to_be32(block + 1);
 		affs_adjust_checksum(ext_bh, blocknr - bh_result->b_blocknr + 1);
@@ -353,8 +354,8 @@ affs_get_block(struct inode *inode, sector_t block, struct buffer_head *bh_resul
 	return 0;
 
 err_big:
-	affs_error(inode->i_sb, "get_block", "strange block request %d",
-		   (int)block);
+	affs_error(inode->i_sb, "get_block", "strange block request %llu",
+		   (unsigned long long)block);
 	return -EIO;
 err_ext:
 	// unlock cache
@@ -503,7 +504,7 @@ affs_do_readpage_ofs(struct page *page, unsigned to)
 	u32 bidx, boff, bsize;
 	u32 tmp;
 
-	pr_debug("%s(%u, %ld, 0, %d)\n", __func__, (u32)inode->i_ino,
+	pr_debug("%s(%lu, %ld, 0, %d)\n", __func__, inode->i_ino,
 		 page->index, to);
 	BUG_ON(to > PAGE_CACHE_SIZE);
 	kmap(page);
@@ -539,7 +540,7 @@ affs_extent_file_ofs(struct inode *inode, u32 newsize)
 	u32 size, bsize;
 	u32 tmp;
 
-	pr_debug("%s(%u, %d)\n", __func__, (u32)inode->i_ino, newsize);
+	pr_debug("%s(%lu, %d)\n", __func__, inode->i_ino, newsize);
 	bsize = AFFS_SB(sb)->s_data_blksize;
 	bh = NULL;
 	size = AFFS_I(inode)->mmu_private;
@@ -608,7 +609,7 @@ affs_readpage_ofs(struct file *file, struct page *page)
 	u32 to;
 	int err;
 
-	pr_debug("%s(%u, %ld)\n", __func__, (u32)inode->i_ino, page->index);
+	pr_debug("%s(%lu, %ld)\n", __func__, inode->i_ino, page->index);
 	to = PAGE_CACHE_SIZE;
 	if (((page->index + 1) << PAGE_CACHE_SHIFT) > inode->i_size) {
 		to = inode->i_size & ~PAGE_CACHE_MASK;
@@ -631,8 +632,8 @@ static int affs_write_begin_ofs(struct file *file, struct address_space *mapping
 	pgoff_t index;
 	int err = 0;
 
-	pr_debug("%s(%u, %llu, %llu)\n", __func__, (u32)inode->i_ino,
-		 (unsigned long long)pos, (unsigned long long)pos + len);
+	pr_debug("%s(%lu, %llu, %llu)\n", __func__, inode->i_ino, pos,
+		 pos + len);
 	if (pos > AFFS_I(inode)->mmu_private) {
 		/* XXX: this probably leaves a too-big i_size in case of
 		 * failure. Should really be updating i_size at write_end time
@@ -681,9 +682,8 @@ static int affs_write_end_ofs(struct file *file, struct address_space *mapping,
 	 * due to write_begin.
 	 */
 
-	pr_debug("%s(%u, %llu, %llu)\n",
-		 __func__, (u32)inode->i_ino, (unsigned long long)pos,
-		(unsigned long long)pos + len);
+	pr_debug("%s(%lu, %llu, %llu)\n", __func__, inode->i_ino, pos,
+		 pos + len);
 	bsize = AFFS_SB(sb)->s_data_blksize;
 	data = page_address(page);
 
@@ -831,8 +831,8 @@ affs_truncate(struct inode *inode)
 	struct buffer_head *ext_bh;
 	int i;
 
-	pr_debug("truncate(inode=%d, oldsize=%u, newsize=%u)\n",
-		 (u32)inode->i_ino, (u32)AFFS_I(inode)->mmu_private, (u32)inode->i_size);
+	pr_debug("truncate(inode=%lu, oldsize=%llu, newsize=%llu)\n",
+		 inode->i_ino, AFFS_I(inode)->mmu_private, inode->i_size);
 
 	last_blk = 0;
 	ext = 0;
@@ -863,7 +863,7 @@ affs_truncate(struct inode *inode)
 	if (IS_ERR(ext_bh)) {
 		affs_warning(sb, "truncate",
 			     "unexpected read error for ext block %u (%ld)",
-			     (unsigned int)ext, PTR_ERR(ext_bh));
+			     ext, PTR_ERR(ext_bh));
 		return;
 	}
 	if (AFFS_I(inode)->i_lc) {
@@ -911,7 +911,7 @@ affs_truncate(struct inode *inode)
 			if (IS_ERR(bh)) {
 				affs_warning(sb, "truncate",
 					     "unexpected read error for last block %u (%ld)",
-					     (unsigned int)ext, PTR_ERR(bh));
+					     ext, PTR_ERR(bh));
 				return;
 			}
 			tmp = be32_to_cpu(AFFS_DATA_HEAD(bh)->next);
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index d0609a282e1dadb8..25cb4b43f2f16ab1 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -348,9 +348,8 @@ affs_add_entry(struct inode *dir, struct inode *inode, struct dentry *dentry, s3
 	u32 block = 0;
 	int retval;
 
-	pr_debug("%s(dir=%u, inode=%u, \"%pd\", type=%d)\n",
-		 __func__, (u32)dir->i_ino,
-	         (u32)inode->i_ino, dentry, type);
+	pr_debug("%s(dir=%lu, inode=%lu, \"%pd\", type=%d)\n", __func__,
+		 dir->i_ino, inode->i_ino, dentry, type);
 
 	retval = -EIO;
 	bh = affs_bread(sb, inode->i_ino);
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index bbc38530e924eb61..de84f4d3e9eccdfe 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -248,9 +248,8 @@ affs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 int
 affs_unlink(struct inode *dir, struct dentry *dentry)
 {
-	pr_debug("%s(dir=%d, %lu \"%pd\")\n",
-		 __func__, (u32)dir->i_ino, dentry->d_inode->i_ino,
-		dentry);
+	pr_debug("%s(dir=%lu, %lu \"%pd\")\n", __func__, dir->i_ino,
+		 dentry->d_inode->i_ino, dentry);
 
 	return affs_remove_header(dentry);
 }
@@ -317,9 +316,8 @@ affs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 int
 affs_rmdir(struct inode *dir, struct dentry *dentry)
 {
-	pr_debug("%s(dir=%u, %lu \"%pd\")\n",
-		__func__, (u32)dir->i_ino, dentry->d_inode->i_ino,
-		 dentry);
+	pr_debug("%s(dir=%lu, %lu \"%pd\")\n", __func__, dir->i_ino,
+		 dentry->d_inode->i_ino, dentry);
 
 	return affs_remove_header(dentry);
 }
@@ -404,8 +402,7 @@ affs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = old_dentry->d_inode;
 
-	pr_debug("%s(%u, %u, \"%pd\")\n",
-		 __func__, (u32)inode->i_ino, (u32)dir->i_ino,
+	pr_debug("%s(%lu, %lu, \"%pd\")\n", __func__, inode->i_ino, dir->i_ino,
 		 dentry);
 
 	return affs_add_entry(dir, inode, dentry, ST_LINKFILE);
@@ -419,9 +416,8 @@ affs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct buffer_head *bh = NULL;
 	int retval;
 
-	pr_debug("%s(old=%u,\"%pd\" to new=%u,\"%pd\")\n",
-		 __func__, (u32)old_dir->i_ino, old_dentry,
-		 (u32)new_dir->i_ino, new_dentry);
+	pr_debug("%s(old=%lu,\"%pd\" to new=%lu,\"%pd\")\n", __func__,
+		 old_dir->i_ino, old_dentry, new_dir->i_ino, new_dentry);
 
 	retval = affs_check_name(new_dentry->d_name.name,
 				 new_dentry->d_name.len,
-- 
1.9.1

