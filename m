Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbaENSN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 14:13:56 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:17801 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750910AbaENSNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 14:13:55 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugNANGwc1NXQ68k/2dsb2JhbABZgwZPrBoEAQEBAQEBBQGaHYElF3SCUxMcIxiBAiQTiEUB0VOFVIZagiCERwEDjyqKJgGBPYlQiAeDODsw
Date: Wed, 14 May 2014 20:13:52 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Joe <joe@perches.com>
Subject: [PATCH V2 2/3] FS/EFS: add pr_fmt / use __func__
Message-Id: <20140514201352.b13f869a120da7d320340ec1@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also uniformize function arguments
 
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/efs/dir.c   | 11 +++++++----
 fs/efs/efs.h   |  6 ++++++
 fs/efs/file.c  | 12 +++++-------
 fs/efs/inode.c | 24 ++++++++++++++----------
 fs/efs/namei.c |  8 +++++---
 fs/efs/super.c | 23 ++++++++++++-----------
 6 files changed, 49 insertions(+), 35 deletions(-)

diff --git a/fs/efs/dir.c b/fs/efs/dir.c
index 46a9a60..7f97031 100644
--- a/fs/efs/dir.c
+++ b/fs/efs/dir.c
@@ -26,7 +26,8 @@ static int efs_readdir(struct file *file, struct dir_context *ctx)
 	int			slot;
 
 	if (inode->i_size & (EFS_DIRBSIZE-1))
-		pr_warn("EFS: WARNING: readdir(): directory size not a multiple of EFS_DIRBSIZE\n");
+		pr_warn("%s(): directory size not a multiple of EFS_DIRBSIZE\n",
+			__func__);
 
 	/* work out where this entry can be found */
 	block = ctx->pos >> EFS_DIRBSIZE_BITS;
@@ -43,14 +44,15 @@ static int efs_readdir(struct file *file, struct dir_context *ctx)
 		bh = sb_bread(inode->i_sb, efs_bmap(inode, block));
 
 		if (!bh) {
-			pr_err("EFS: readdir(): failed to read dir block %d\n", block);
+			pr_err("%s(): failed to read dir block %d\n",
+			       __func__, block);
 			break;
 		}
 
 		dirblock = (struct efs_dir *) bh->b_data; 
 
 		if (be16_to_cpu(dirblock->magic) != EFS_DIRBLK_MAGIC) {
-			pr_err("EFS: readdir(): invalid directory block\n");
+			pr_err("%s(): invalid directory block\n", __func__);
 			brelse(bh);
 			break;
 		}
@@ -80,7 +82,8 @@ static int efs_readdir(struct file *file, struct dir_context *ctx)
 
 			/* sanity check */
 			if (nameptr - (char *) dirblock + namelen > EFS_DIRBSIZE) {
-				pr_warn("EFS: directory entry %d exceeds directory block\n", slot);
+				pr_warn("directory entry %d exceeds directory block\n",
+					slot);
 				continue;
 			}
 
diff --git a/fs/efs/efs.h b/fs/efs/efs.h
index 5528926..5bbf961 100644
--- a/fs/efs/efs.h
+++ b/fs/efs/efs.h
@@ -7,6 +7,12 @@
 #ifndef _EFS_EFS_H_
 #define _EFS_EFS_H_
 
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/fs.h>
 #include <asm/uaccess.h>
 
diff --git a/fs/efs/file.c b/fs/efs/file.c
index a75c710..a37dcee 100644
--- a/fs/efs/file.c
+++ b/fs/efs/file.c
@@ -22,10 +22,8 @@ int efs_get_block(struct inode *inode, sector_t iblock,
 		/*
 		 * i have no idea why this happens as often as it does
 		 */
-		pr_warn("EFS: bmap(): block %d >= %ld (filesize %ld)\n",
-			block,
-			inode->i_blocks,
-			inode->i_size);
+		pr_warn("%s(): block %d >= %ld (filesize %ld)\n",
+			__func__, block, inode->i_blocks, inode->i_size);
 #endif
 		return 0;
 	}
@@ -38,7 +36,7 @@ int efs_get_block(struct inode *inode, sector_t iblock,
 int efs_bmap(struct inode *inode, efs_block_t block) {
 
 	if (block < 0) {
-		pr_warn("EFS: bmap(): block < 0\n");
+		pr_warn("%s(): block < 0\n", __func__);
 		return 0;
 	}
 
@@ -48,8 +46,8 @@ int efs_bmap(struct inode *inode, efs_block_t block) {
 		/*
 		 * i have no idea why this happens as often as it does
 		 */
-		pr_warn("EFS: bmap(): block %d >= %ld (filesize %ld)\n",
-			block, inode->i_blocks, inode->i_size);
+		pr_warn("%s(): block %d >= %ld (filesize %ld)\n",
+			__func__, block, inode->i_blocks, inode->i_size);
 #endif
 		return 0;
 	}
diff --git a/fs/efs/inode.c b/fs/efs/inode.c
index 54f1cbb..6c9684a 100644
--- a/fs/efs/inode.c
+++ b/fs/efs/inode.c
@@ -89,7 +89,7 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
 
 	bh = sb_bread(inode->i_sb, block);
 	if (!bh) {
-		pr_warn("EFS: bread() failed at block %d\n", block);
+		pr_warn("%s() failed at block %d\n", __func__, block);
 		goto read_inode_error;
 	}
 
@@ -130,7 +130,8 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
 	for(i = 0; i < EFS_DIRECTEXTENTS; i++) {
 		extent_copy(&(efs_inode->di_u.di_extents[i]), &(in->extents[i]));
 		if (i < in->numextents && in->extents[i].cooked.ex_magic != 0) {
-			pr_warn("EFS: extent %d has bad magic number in inode %lu\n", i, inode->i_ino);
+			pr_warn("extent %d has bad magic number in inode %lu\n",
+				i, inode->i_ino);
 			brelse(bh);
 			goto read_inode_error;
 		}
@@ -162,7 +163,7 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
 			init_special_inode(inode, inode->i_mode, device);
 			break;
 		default:
-			pr_warn("EFS: unsupported inode mode %o\n", inode->i_mode);
+			pr_warn("unsupported inode mode %o\n", inode->i_mode);
 			goto read_inode_error;
 			break;
 	}
@@ -171,7 +172,7 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
 	return inode;
         
 read_inode_error:
-	pr_warn("EFS: failed to read inode %lu\n", inode->i_ino);
+	pr_warn("failed to read inode %lu\n", inode->i_ino);
 	iget_failed(inode);
 	return ERR_PTR(-EIO);
 }
@@ -216,7 +217,7 @@ efs_block_t efs_map_block(struct inode *inode, efs_block_t block) {
     
 		/* if we only have one extent then nothing can be found */
 		if (in->numextents == 1) {
-			pr_err("EFS: map_block() failed to map (1 extent)\n");
+			pr_err("%s() failed to map (1 extent)\n", __func__);
 			return 0;
 		}
 
@@ -234,7 +235,7 @@ efs_block_t efs_map_block(struct inode *inode, efs_block_t block) {
 			}
 		}
 
-		pr_err("EFS: map_block() failed to map block %u (dir)\n", block);
+		pr_err("%s() failed to map block %u (dir)\n", __func__, block);
 		return 0;
 	}
 
@@ -262,7 +263,8 @@ efs_block_t efs_map_block(struct inode *inode, efs_block_t block) {
 
 		if (dirext == direxts) {
 			/* should never happen */
-			pr_err("EFS: couldn't find direct extent for indirect extent %d (block %u)\n", cur, block);
+			pr_err("couldn't find direct extent for indirect extent %d (block %u)\n",
+			       cur, block);
 			if (bh) brelse(bh);
 			return 0;
 		}
@@ -279,7 +281,8 @@ efs_block_t efs_map_block(struct inode *inode, efs_block_t block) {
 
 			bh = sb_bread(inode->i_sb, iblock);
 			if (!bh) {
-				pr_err("EFS: bread() failed at block %d\n", iblock);
+				pr_err("%s() failed at block %d\n",
+				       __func__, iblock);
 				return 0;
 			}
 #ifdef DEBUG
@@ -294,7 +297,8 @@ efs_block_t efs_map_block(struct inode *inode, efs_block_t block) {
 		extent_copy(&(exts[ioffset]), &ext);
 
 		if (ext.cooked.ex_magic != 0) {
-			pr_err("EFS: extent %d has bad magic number in block %d\n", cur, iblock);
+			pr_err("extent %d has bad magic number in block %d\n",
+			       cur, iblock);
 			if (bh) brelse(bh);
 			return 0;
 		}
@@ -306,7 +310,7 @@ efs_block_t efs_map_block(struct inode *inode, efs_block_t block) {
 		}
 	}
 	if (bh) brelse(bh);
-	pr_err("EFS: map_block() failed to map block %u (indir)\n", block);
+	pr_err("%s() failed to map block %u (indir)\n", __func__, block);
 	return 0;
 }  
 
diff --git a/fs/efs/namei.c b/fs/efs/namei.c
index 527d0b9..356c044 100644
--- a/fs/efs/namei.c
+++ b/fs/efs/namei.c
@@ -23,20 +23,22 @@ static efs_ino_t efs_find_entry(struct inode *inode, const char *name, int len)
 	efs_block_t		block;
  
 	if (inode->i_size & (EFS_DIRBSIZE-1))
-		pr_warn("EFS: WARNING: find_entry(): directory size not a multiple of EFS_DIRBSIZE\n");
+		pr_warn("%s(): directory size not a multiple of EFS_DIRBSIZE\n",
+			__func__);
 
 	for(block = 0; block < inode->i_blocks; block++) {
 
 		bh = sb_bread(inode->i_sb, efs_bmap(inode, block));
 		if (!bh) {
-			pr_err("EFS: find_entry(): failed to read dir block %d\n", block);
+			pr_err("%s(): failed to read dir block %d\n",
+			       __func__, block);
 			return 0;
 		}
     
 		dirblock = (struct efs_dir *) bh->b_data;
 
 		if (be16_to_cpu(dirblock->magic) != EFS_DIRBLK_MAGIC) {
-			pr_err("EFS: find_entry(): invalid directory block\n");
+			pr_err("%s(): invalid directory block\n", __func__);
 			brelse(bh);
 			return(0);
 		}
diff --git a/fs/efs/super.c b/fs/efs/super.c
index 0590232..cd1399e 100644
--- a/fs/efs/super.c
+++ b/fs/efs/super.c
@@ -134,7 +134,7 @@ static const struct export_operations efs_export_ops = {
 
 static int __init init_efs_fs(void) {
 	int err;
-	pr_info("EFS: "EFS_VERSION" - http://aeschi.ch.eu.org/efs/\n");
+	pr_info(EFS_VERSION" - http://aeschi.ch.eu.org/efs/\n");
 	err = init_inodecache();
 	if (err)
 		goto out1;
@@ -179,7 +179,7 @@ static efs_block_t efs_validate_vh(struct volume_header *vh) {
 		csum += be32_to_cpu(cs);
 	}
 	if (csum) {
-		pr_warn("EFS: SGI disklabel: checksum bad, label corrupted\n");
+		pr_warn("SGI disklabel: checksum bad, label corrupted\n");
 		return 0;
 	}
 
@@ -226,10 +226,10 @@ static efs_block_t efs_validate_vh(struct volume_header *vh) {
 	}
 
 	if (slice == -1) {
-		pr_notice("EFS: partition table contained no EFS partitions\n");
+		pr_notice("partition table contained no EFS partitions\n");
 #ifdef DEBUG
 	} else {
-		pr_info("EFS: using slice %d (type %s, offset 0x%x)\n", slice,
+		pr_info("using slice %d (type %s, offset 0x%x)\n", slice,
 			(pt_entry->pt_name) ? pt_entry->pt_name : "unknown",
 			sblock);
 #endif
@@ -267,7 +267,7 @@ static int efs_fill_super(struct super_block *s, void *d, int silent)
  
 	s->s_magic		= EFS_SUPER_MAGIC;
 	if (!sb_set_blocksize(s, EFS_BLOCKSIZE)) {
-		pr_err("EFS: device does not support %d byte blocks\n",
+		pr_err("device does not support %d byte blocks\n",
 			EFS_BLOCKSIZE);
 		return -EINVAL;
 	}
@@ -276,7 +276,7 @@ static int efs_fill_super(struct super_block *s, void *d, int silent)
 	bh = sb_bread(s, 0);
 
 	if (!bh) {
-		pr_err("EFS: cannot read volume header\n");
+		pr_err("cannot read volume header\n");
 		return -EINVAL;
 	}
 
@@ -294,13 +294,14 @@ static int efs_fill_super(struct super_block *s, void *d, int silent)
 
 	bh = sb_bread(s, sb->fs_start + EFS_SUPER);
 	if (!bh) {
-		pr_err("EFS: cannot read superblock\n");
+		pr_err("cannot read superblock\n");
 		return -EINVAL;
 	}
 		
 	if (efs_validate_super(sb, (struct efs_super *) bh->b_data)) {
 #ifdef DEBUG
-		pr_warn("EFS: invalid superblock at block %u\n", sb->fs_start + EFS_SUPER);
+		pr_warn("invalid superblock at block %u\n",
+			sb->fs_start + EFS_SUPER);
 #endif
 		brelse(bh);
 		return -EINVAL;
@@ -309,7 +310,7 @@ static int efs_fill_super(struct super_block *s, void *d, int silent)
 
 	if (!(s->s_flags & MS_RDONLY)) {
 #ifdef DEBUG
-		pr_info("EFS: forcing read-only mode\n");
+		pr_info("forcing read-only mode\n");
 #endif
 		s->s_flags |= MS_RDONLY;
 	}
@@ -317,13 +318,13 @@ static int efs_fill_super(struct super_block *s, void *d, int silent)
 	s->s_export_op = &efs_export_ops;
 	root = efs_iget(s, EFS_ROOTINODE);
 	if (IS_ERR(root)) {
-		pr_err("EFS: get root inode failed\n");
+		pr_err("get root inode failed\n");
 		return PTR_ERR(root);
 	}
 
 	s->s_root = d_make_root(root);
 	if (!(s->s_root)) {
-		pr_err("EFS: get root dentry failed\n");
+		pr_err("get root dentry failed\n");
 		return -ENOMEM;
 	}
 
-- 
1.9.1
