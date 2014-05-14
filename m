Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320AbaENSLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 14:11:21 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:34340 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799AbaENSLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 14:11:20 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugNABOxc1NXQ68k/2dsb2JhbABZgwZPrBoEAQEBAQEBBQGaHYElF3SCUxMcIxiBAiQTiEUB0VSFVIZagiCERwEDjyqKJgGBPYlQiAeDODsw
Date: Wed, 14 May 2014 20:11:17 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Joe <joe@perches.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH V2 1/3] FS/EFS: convert printk to pr_foo()
Message-Id: <20140514201117.289cb821a95f1d273c7e0f07@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all except KERN_DEBUG
(pr_debug doesn't work the same as printk(KERN_DEBUG and requires
special check)

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/efs/dir.c   |  8 ++++----
 fs/efs/file.c  | 10 ++++------
 fs/efs/inode.c | 20 ++++++++++----------
 fs/efs/namei.c |  6 +++---
 fs/efs/super.c | 23 +++++++++++------------
 5 files changed, 32 insertions(+), 35 deletions(-)

diff --git a/fs/efs/dir.c b/fs/efs/dir.c
index b72307c..46a9a60 100644
--- a/fs/efs/dir.c
+++ b/fs/efs/dir.c
@@ -26,7 +26,7 @@ static int efs_readdir(struct file *file, struct dir_context *ctx)
 	int			slot;
 
 	if (inode->i_size & (EFS_DIRBSIZE-1))
-		printk(KERN_WARNING "EFS: WARNING: readdir(): directory size not a multiple of EFS_DIRBSIZE\n");
+		pr_warn("EFS: WARNING: readdir(): directory size not a multiple of EFS_DIRBSIZE\n");
 
 	/* work out where this entry can be found */
 	block = ctx->pos >> EFS_DIRBSIZE_BITS;
@@ -43,14 +43,14 @@ static int efs_readdir(struct file *file, struct dir_context *ctx)
 		bh = sb_bread(inode->i_sb, efs_bmap(inode, block));
 
 		if (!bh) {
-			printk(KERN_ERR "EFS: readdir(): failed to read dir block %d\n", block);
+			pr_err("EFS: readdir(): failed to read dir block %d\n", block);
 			break;
 		}
 
 		dirblock = (struct efs_dir *) bh->b_data; 
 
 		if (be16_to_cpu(dirblock->magic) != EFS_DIRBLK_MAGIC) {
-			printk(KERN_ERR "EFS: readdir(): invalid directory block\n");
+			pr_err("EFS: readdir(): invalid directory block\n");
 			brelse(bh);
 			break;
 		}
@@ -80,7 +80,7 @@ static int efs_readdir(struct file *file, struct dir_context *ctx)
 
 			/* sanity check */
 			if (nameptr - (char *) dirblock + namelen > EFS_DIRBSIZE) {
-				printk(KERN_WARNING "EFS: directory entry %d exceeds directory block\n", slot);
+				pr_warn("EFS: directory entry %d exceeds directory block\n", slot);
 				continue;
 			}
 
diff --git a/fs/efs/file.c b/fs/efs/file.c
index 1ccb364..a75c710 100644
--- a/fs/efs/file.c
+++ b/fs/efs/file.c
@@ -22,7 +22,7 @@ int efs_get_block(struct inode *inode, sector_t iblock,
 		/*
 		 * i have no idea why this happens as often as it does
 		 */
-		printk(KERN_WARNING "EFS: bmap(): block %d >= %ld (filesize %ld)\n",
+		pr_warn("EFS: bmap(): block %d >= %ld (filesize %ld)\n",
 			block,
 			inode->i_blocks,
 			inode->i_size);
@@ -38,7 +38,7 @@ int efs_get_block(struct inode *inode, sector_t iblock,
 int efs_bmap(struct inode *inode, efs_block_t block) {
 
 	if (block < 0) {
-		printk(KERN_WARNING "EFS: bmap(): block < 0\n");
+		pr_warn("EFS: bmap(): block < 0\n");
 		return 0;
 	}
 
@@ -48,10 +48,8 @@ int efs_bmap(struct inode *inode, efs_block_t block) {
 		/*
 		 * i have no idea why this happens as often as it does
 		 */
-		printk(KERN_WARNING "EFS: bmap(): block %d >= %ld (filesize %ld)\n",
-			block,
-			inode->i_blocks,
-			inode->i_size);
+		pr_warn("EFS: bmap(): block %d >= %ld (filesize %ld)\n",
+			block, inode->i_blocks, inode->i_size);
 #endif
 		return 0;
 	}
diff --git a/fs/efs/inode.c b/fs/efs/inode.c
index d15ccf2..54f1cbb 100644
--- a/fs/efs/inode.c
+++ b/fs/efs/inode.c
@@ -89,7 +89,7 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
 
 	bh = sb_bread(inode->i_sb, block);
 	if (!bh) {
-		printk(KERN_WARNING "EFS: bread() failed at block %d\n", block);
+		pr_warn("EFS: bread() failed at block %d\n", block);
 		goto read_inode_error;
 	}
 
@@ -130,7 +130,7 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
 	for(i = 0; i < EFS_DIRECTEXTENTS; i++) {
 		extent_copy(&(efs_inode->di_u.di_extents[i]), &(in->extents[i]));
 		if (i < in->numextents && in->extents[i].cooked.ex_magic != 0) {
-			printk(KERN_WARNING "EFS: extent %d has bad magic number in inode %lu\n", i, inode->i_ino);
+			pr_warn("EFS: extent %d has bad magic number in inode %lu\n", i, inode->i_ino);
 			brelse(bh);
 			goto read_inode_error;
 		}
@@ -162,7 +162,7 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
 			init_special_inode(inode, inode->i_mode, device);
 			break;
 		default:
-			printk(KERN_WARNING "EFS: unsupported inode mode %o\n", inode->i_mode);
+			pr_warn("EFS: unsupported inode mode %o\n", inode->i_mode);
 			goto read_inode_error;
 			break;
 	}
@@ -171,7 +171,7 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
 	return inode;
         
 read_inode_error:
-	printk(KERN_WARNING "EFS: failed to read inode %lu\n", inode->i_ino);
+	pr_warn("EFS: failed to read inode %lu\n", inode->i_ino);
 	iget_failed(inode);
 	return ERR_PTR(-EIO);
 }
@@ -216,7 +216,7 @@ efs_block_t efs_map_block(struct inode *inode, efs_block_t block) {
     
 		/* if we only have one extent then nothing can be found */
 		if (in->numextents == 1) {
-			printk(KERN_ERR "EFS: map_block() failed to map (1 extent)\n");
+			pr_err("EFS: map_block() failed to map (1 extent)\n");
 			return 0;
 		}
 
@@ -234,7 +234,7 @@ efs_block_t efs_map_block(struct inode *inode, efs_block_t block) {
 			}
 		}
 
-		printk(KERN_ERR "EFS: map_block() failed to map block %u (dir)\n", block);
+		pr_err("EFS: map_block() failed to map block %u (dir)\n", block);
 		return 0;
 	}
 
@@ -262,7 +262,7 @@ efs_block_t efs_map_block(struct inode *inode, efs_block_t block) {
 
 		if (dirext == direxts) {
 			/* should never happen */
-			printk(KERN_ERR "EFS: couldn't find direct extent for indirect extent %d (block %u)\n", cur, block);
+			pr_err("EFS: couldn't find direct extent for indirect extent %d (block %u)\n", cur, block);
 			if (bh) brelse(bh);
 			return 0;
 		}
@@ -279,7 +279,7 @@ efs_block_t efs_map_block(struct inode *inode, efs_block_t block) {
 
 			bh = sb_bread(inode->i_sb, iblock);
 			if (!bh) {
-				printk(KERN_ERR "EFS: bread() failed at block %d\n", iblock);
+				pr_err("EFS: bread() failed at block %d\n", iblock);
 				return 0;
 			}
 #ifdef DEBUG
@@ -294,7 +294,7 @@ efs_block_t efs_map_block(struct inode *inode, efs_block_t block) {
 		extent_copy(&(exts[ioffset]), &ext);
 
 		if (ext.cooked.ex_magic != 0) {
-			printk(KERN_ERR "EFS: extent %d has bad magic number in block %d\n", cur, iblock);
+			pr_err("EFS: extent %d has bad magic number in block %d\n", cur, iblock);
 			if (bh) brelse(bh);
 			return 0;
 		}
@@ -306,7 +306,7 @@ efs_block_t efs_map_block(struct inode *inode, efs_block_t block) {
 		}
 	}
 	if (bh) brelse(bh);
-	printk(KERN_ERR "EFS: map_block() failed to map block %u (indir)\n", block);
+	pr_err("EFS: map_block() failed to map block %u (indir)\n", block);
 	return 0;
 }  
 
diff --git a/fs/efs/namei.c b/fs/efs/namei.c
index 96f66d2..527d0b9 100644
--- a/fs/efs/namei.c
+++ b/fs/efs/namei.c
@@ -23,20 +23,20 @@ static efs_ino_t efs_find_entry(struct inode *inode, const char *name, int len)
 	efs_block_t		block;
  
 	if (inode->i_size & (EFS_DIRBSIZE-1))
-		printk(KERN_WARNING "EFS: WARNING: find_entry(): directory size not a multiple of EFS_DIRBSIZE\n");
+		pr_warn("EFS: WARNING: find_entry(): directory size not a multiple of EFS_DIRBSIZE\n");
 
 	for(block = 0; block < inode->i_blocks; block++) {
 
 		bh = sb_bread(inode->i_sb, efs_bmap(inode, block));
 		if (!bh) {
-			printk(KERN_ERR "EFS: find_entry(): failed to read dir block %d\n", block);
+			pr_err("EFS: find_entry(): failed to read dir block %d\n", block);
 			return 0;
 		}
     
 		dirblock = (struct efs_dir *) bh->b_data;
 
 		if (be16_to_cpu(dirblock->magic) != EFS_DIRBLK_MAGIC) {
-			printk(KERN_ERR "EFS: find_entry(): invalid directory block\n");
+			pr_err("EFS: find_entry(): invalid directory block\n");
 			brelse(bh);
 			return(0);
 		}
diff --git a/fs/efs/super.c b/fs/efs/super.c
index 3befcc9..0590232 100644
--- a/fs/efs/super.c
+++ b/fs/efs/super.c
@@ -134,7 +134,7 @@ static const struct export_operations efs_export_ops = {
 
 static int __init init_efs_fs(void) {
 	int err;
-	printk("EFS: "EFS_VERSION" - http://aeschi.ch.eu.org/efs/\n");
+	pr_info("EFS: "EFS_VERSION" - http://aeschi.ch.eu.org/efs/\n");
 	err = init_inodecache();
 	if (err)
 		goto out1;
@@ -179,7 +179,7 @@ static efs_block_t efs_validate_vh(struct volume_header *vh) {
 		csum += be32_to_cpu(cs);
 	}
 	if (csum) {
-		printk(KERN_INFO "EFS: SGI disklabel: checksum bad, label corrupted\n");
+		pr_warn("EFS: SGI disklabel: checksum bad, label corrupted\n");
 		return 0;
 	}
 
@@ -226,11 +226,10 @@ static efs_block_t efs_validate_vh(struct volume_header *vh) {
 	}
 
 	if (slice == -1) {
-		printk(KERN_NOTICE "EFS: partition table contained no EFS partitions\n");
+		pr_notice("EFS: partition table contained no EFS partitions\n");
 #ifdef DEBUG
 	} else {
-		printk(KERN_INFO "EFS: using slice %d (type %s, offset 0x%x)\n",
-			slice,
+		pr_info("EFS: using slice %d (type %s, offset 0x%x)\n", slice,
 			(pt_entry->pt_name) ? pt_entry->pt_name : "unknown",
 			sblock);
 #endif
@@ -268,7 +267,7 @@ static int efs_fill_super(struct super_block *s, void *d, int silent)
  
 	s->s_magic		= EFS_SUPER_MAGIC;
 	if (!sb_set_blocksize(s, EFS_BLOCKSIZE)) {
-		printk(KERN_ERR "EFS: device does not support %d byte blocks\n",
+		pr_err("EFS: device does not support %d byte blocks\n",
 			EFS_BLOCKSIZE);
 		return -EINVAL;
 	}
@@ -277,7 +276,7 @@ static int efs_fill_super(struct super_block *s, void *d, int silent)
 	bh = sb_bread(s, 0);
 
 	if (!bh) {
-		printk(KERN_ERR "EFS: cannot read volume header\n");
+		pr_err("EFS: cannot read volume header\n");
 		return -EINVAL;
 	}
 
@@ -295,13 +294,13 @@ static int efs_fill_super(struct super_block *s, void *d, int silent)
 
 	bh = sb_bread(s, sb->fs_start + EFS_SUPER);
 	if (!bh) {
-		printk(KERN_ERR "EFS: cannot read superblock\n");
+		pr_err("EFS: cannot read superblock\n");
 		return -EINVAL;
 	}
 		
 	if (efs_validate_super(sb, (struct efs_super *) bh->b_data)) {
 #ifdef DEBUG
-		printk(KERN_WARNING "EFS: invalid superblock at block %u\n", sb->fs_start + EFS_SUPER);
+		pr_warn("EFS: invalid superblock at block %u\n", sb->fs_start + EFS_SUPER);
 #endif
 		brelse(bh);
 		return -EINVAL;
@@ -310,7 +309,7 @@ static int efs_fill_super(struct super_block *s, void *d, int silent)
 
 	if (!(s->s_flags & MS_RDONLY)) {
 #ifdef DEBUG
-		printk(KERN_INFO "EFS: forcing read-only mode\n");
+		pr_info("EFS: forcing read-only mode\n");
 #endif
 		s->s_flags |= MS_RDONLY;
 	}
@@ -318,13 +317,13 @@ static int efs_fill_super(struct super_block *s, void *d, int silent)
 	s->s_export_op = &efs_export_ops;
 	root = efs_iget(s, EFS_ROOTINODE);
 	if (IS_ERR(root)) {
-		printk(KERN_ERR "EFS: get root inode failed\n");
+		pr_err("EFS: get root inode failed\n");
 		return PTR_ERR(root);
 	}
 
 	s->s_root = d_make_root(root);
 	if (!(s->s_root)) {
-		printk(KERN_ERR "EFS: get root dentry failed\n");
+		pr_err("EFS: get root dentry failed\n");
 		return -ENOMEM;
 	}
 
-- 
1.9.1

