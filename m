Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbaGWOuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:50:06 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:54935 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758063AbaGWOtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:49:05 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4KAADLz1NXQypd/2dsb2JhbABZgw5SV682BQEBAQEBAQUBbgGXK4dNgQsXdoQxLyOBGjeIRgHAQYV7iVCETQWbLZRAg0o7Lw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: hch@infradead.org, joe@perches.com, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH V2] SYSV: logging update
Date: Wed, 23 Jul 2014 16:50:18 +0200
Message-Id: <1406127018-15953-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-use current logging functions
-replace no level printk by pr_err
-add debug.c / sysv_err function to include sb->s_id
-standardize prefix: "sysv (sb id): " and remove sb id from various logging at different places.
-use __func__
-coalesce formats

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---

V2: add sb->s_id in logging (suggested by Christoph Hellwig)


 fs/sysv/Makefile |  2 +-
 fs/sysv/balloc.c | 28 +++++++++++++++-------------
 fs/sysv/debug.c  | 15 +++++++++++++++
 fs/sysv/ialloc.c | 14 +++++++-------
 fs/sysv/inode.c  | 15 ++++++---------
 fs/sysv/itree.c  |  2 +-
 fs/sysv/super.c  | 28 +++++++++++-----------------
 fs/sysv/sysv.h   |  3 +++
 8 files changed, 59 insertions(+), 48 deletions(-)
 create mode 100644 fs/sysv/debug.c

diff --git a/fs/sysv/Makefile b/fs/sysv/Makefile
index 3591f9d..46721fb 100644
--- a/fs/sysv/Makefile
+++ b/fs/sysv/Makefile
@@ -5,4 +5,4 @@
 obj-$(CONFIG_SYSV_FS) += sysv.o
 
 sysv-objs := ialloc.o balloc.o inode.o itree.o file.o dir.o \
-	     namei.o super.o symlink.o
+	     namei.o super.o symlink.o debug.o
diff --git a/fs/sysv/balloc.c b/fs/sysv/balloc.c
index 921c053..aae4ee4 100644
--- a/fs/sysv/balloc.c
+++ b/fs/sysv/balloc.c
@@ -56,7 +56,8 @@ void sysv_free_block(struct super_block * sb, sysv_zone_t nr)
 		return;
 
 	if (block < sbi->s_firstdatazone || block >= sbi->s_nzones) {
-		printk("sysv_free_block: trying to free block not in datazone\n");
+		sysv_err(sb, "%s: trying to free block not in datazone\n",
+			 __func__);
 		return;
 	}
 
@@ -64,7 +65,7 @@ void sysv_free_block(struct super_block * sb, sysv_zone_t nr)
 	count = fs16_to_cpu(sbi, *sbi->s_bcache_count);
 
 	if (count > sbi->s_flc_size) {
-		printk("sysv_free_block: flc_count > flc_size\n");
+		sysv_err(sb, "%s: flc_count > flc_size\n", __func__);
 		mutex_unlock(&sbi->s_lock);
 		return;
 	}
@@ -76,7 +77,7 @@ void sysv_free_block(struct super_block * sb, sysv_zone_t nr)
 		block += sbi->s_block_base;
 		bh = sb_getblk(sb, block);
 		if (!bh) {
-			printk("sysv_free_block: getblk() failed\n");
+			sysv_err(sb, "%s: getblk() failed\n", __func__);
 			mutex_unlock(&sbi->s_lock);
 			return;
 		}
@@ -118,8 +119,8 @@ sysv_zone_t sysv_new_block(struct super_block * sb)
 	*sbi->s_bcache_count = cpu_to_fs16(sbi, count);
 
 	if (block < sbi->s_firstdatazone || block >= sbi->s_nzones) {
-		printk("sysv_new_block: new block %d is not in data zone\n",
-			block);
+		sysv_err(sb, "%s: new block %d is not in data zone\n",
+			 __func__, block);
 		goto Enospc;
 	}
 
@@ -128,14 +129,16 @@ sysv_zone_t sysv_new_block(struct super_block * sb)
 
 		block += sbi->s_block_base;
 		if (!(bh = sb_bread(sb, block))) {
-			printk("sysv_new_block: cannot read free-list block\n");
+			sysv_err(sb, "%s: cannot read free-list block\n",
+				 __func__);
 			/* retry this same block next time */
 			*sbi->s_bcache_count = cpu_to_fs16(sbi, 1);
 			goto Enospc;
 		}
 		count = fs16_to_cpu(sbi, *(__fs16*)bh->b_data);
 		if (count > sbi->s_flc_size) {
-			printk("sysv_new_block: free-list block with >flc_size entries\n");
+			sysv_err(sb, "%s: free-list block with >flc_size entries\n",
+				 __func__);
 			brelse(bh);
 			goto Enospc;
 		}
@@ -215,22 +218,21 @@ done:
 	return count;
 
 Einval:
-	printk("sysv_count_free_blocks: new block %d is not in data zone\n",
-		block);
+	sysv_err(sb, "%s: new block %d is not in data zone\n", __func__, block);
 	goto trust_sb;
 Eio:
-	printk("sysv_count_free_blocks: cannot read free-list block\n");
+	sysv_err(sb, "%s: cannot read free-list block\n", __func__);
 	goto trust_sb;
 E2big:
-	printk("sysv_count_free_blocks: >flc_size entries in free-list block\n");
+	sysv_err(sb, "%s: >flc_size entries in free-list block\n", __func__);
 	if (bh)
 		brelse(bh);
 trust_sb:
 	count = sb_count;
 	goto done;
 Ecount:
-	printk("sysv_count_free_blocks: free block count was %d, "
-		"correcting to %d\n", sb_count, count);
+	sysv_err(sb, "%s: free block count was %d, correcting to %d\n",
+	       __func__, sb_count, count);
 	if (!(sb->s_flags & MS_RDONLY)) {
 		*sbi->s_free_blocks = cpu_to_fs32(sbi, count);
 		dirty_sb(sb);
diff --git a/fs/sysv/debug.c b/fs/sysv/debug.c
new file mode 100644
index 0000000..8afcf38
--- /dev/null
+++ b/fs/sysv/debug.c
@@ -0,0 +1,15 @@
+#define pr_fmt(fmt) KBUILD_MODNAME " " fmt
+
+#include "sysv.h"
+
+void sysv_err(struct super_block *sb, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	pr_err("(%s): %pV\n", sb->s_id, &vaf);
+	va_end(args);
+}
diff --git a/fs/sysv/ialloc.c b/fs/sysv/ialloc.c
index f9db4eb..dccf5e2 100644
--- a/fs/sysv/ialloc.c
+++ b/fs/sysv/ialloc.c
@@ -109,13 +109,14 @@ void sysv_free_inode(struct inode * inode)
 	sb = inode->i_sb;
 	ino = inode->i_ino;
 	if (ino <= SYSV_ROOT_INO || ino > sbi->s_ninodes) {
-		printk("sysv_free_inode: inode 0,1,2 or nonexistent inode\n");
+		sysv_err(sb, "%s: inode 0,1,2 or nonexistent inode\n",
+			 __func__);
 		return;
 	}
 	raw_inode = sysv_raw_inode(sb, ino, &bh);
 	if (!raw_inode) {
-		printk("sysv_free_inode: unable to read inode block on device "
-		       "%s\n", inode->i_sb->s_id);
+		sysv_err(sb, "%s: unable to read inode block on device\n",
+			 __func__);
 		return;
 	}
 	mutex_lock(&sbi->s_lock);
@@ -217,9 +218,8 @@ out:
 	return count;
 
 Einval:
-	printk("sysv_count_free_inodes: "
-		"free inode count was %d, correcting to %d\n",
-		sb_count, count);
+	sysv_err(sb, "%s: free inode count was %d, correcting to %d\n",
+		 __func__, sb_count, count);
 	if (!(sb->s_flags & MS_RDONLY)) {
 		*sbi->s_sb_total_free_inodes = cpu_to_fs16(SYSV_SB(sb), count);
 		dirty_sb(sb);
@@ -227,7 +227,7 @@ Einval:
 	goto out;
 
 Eio:
-	printk("sysv_count_free_inodes: unable to read inode table\n");
+	sysv_err(sb, "%s: unable to read inode table\n", __func__);
 trust_sb:
 	count = sb_count;
 	goto out;
diff --git a/fs/sysv/inode.c b/fs/sysv/inode.c
index 8895630..2d0644f 100644
--- a/fs/sysv/inode.c
+++ b/fs/sysv/inode.c
@@ -184,8 +184,7 @@ struct inode *sysv_iget(struct super_block *sb, unsigned int ino)
 	unsigned int block;
 
 	if (!ino || ino > sbi->s_ninodes) {
-		printk("Bad inode number on dev %s: %d is out of range\n",
-		       sb->s_id, ino);
+		sysv_err(sb, "Bad inode number %d is out of range\n", ino);
 		return ERR_PTR(-EIO);
 	}
 
@@ -197,8 +196,7 @@ struct inode *sysv_iget(struct super_block *sb, unsigned int ino)
 
 	raw_inode = sysv_raw_inode(sb, ino, &bh);
 	if (!raw_inode) {
-		printk("Major problem: unable to read inode from dev %s\n",
-		       inode->i_sb->s_id);
+		sysv_err(sb, "Major problem: unable to read inode from dev\n");
 		goto bad_inode;
 	}
 	/* SystemV FS: kludge permissions if ino==SYSV_ROOT_INO ?? */
@@ -246,13 +244,12 @@ static int __sysv_write_inode(struct inode *inode, int wait)
 
 	ino = inode->i_ino;
 	if (!ino || ino > sbi->s_ninodes) {
-		printk("Bad inode number on dev %s: %d is out of range\n",
-		       inode->i_sb->s_id, ino);
+		sysv_err(sb, "Bad inode number %d is out of range\n", ino);
 		return -EIO;
 	}
 	raw_inode = sysv_raw_inode(sb, ino, &bh);
 	if (!raw_inode) {
-		printk("unable to read i-node block\n");
+		sysv_err(sb, "unable to read i-node block\n");
 		return -EIO;
 	}
 
@@ -275,8 +272,8 @@ static int __sysv_write_inode(struct inode *inode, int wait)
 	if (wait) {
                 sync_dirty_buffer(bh);
                 if (buffer_req(bh) && !buffer_uptodate(bh)) {
-                        printk ("IO error syncing sysv inode [%s:%08x]\n",
-                                sb->s_id, ino);
+			sysv_err(sb, "IO error syncing sysv inode [%s:%08x]\n",
+				 sb->s_id, ino);
                         err = -EIO;
                 }
         }
diff --git a/fs/sysv/itree.c b/fs/sysv/itree.c
index 66bc316..0742a8b 100644
--- a/fs/sysv/itree.c
+++ b/fs/sysv/itree.c
@@ -29,7 +29,7 @@ static int block_to_path(struct inode *inode, long block, int offsets[DEPTH])
 	int n = 0;
 
 	if (block < 0) {
-		printk("sysv_block_map: block < 0\n");
+		sysv_err(sb, "%s: block < 0\n", __func__);
 	} else if (block < DIRECT) {
 		offsets[n++] = block;
 	} else if ( (block -= DIRECT) < indirect_blocks) {
diff --git a/fs/sysv/super.c b/fs/sysv/super.c
index eda1095..7b667c0 100644
--- a/fs/sysv/super.c
+++ b/fs/sysv/super.c
@@ -217,9 +217,7 @@ static int detect_sysv(struct sysv_sb_info *sbi, struct buffer_head *bh)
  		sbi->s_type = FSTYPE_AFS;
 		sbi->s_forced_ro = 1;
  		if (!(sb->s_flags & MS_RDONLY)) {
- 			printk("SysV FS: SCO EAFS on %s detected, " 
- 				"forcing read-only mode.\n", 
- 				sb->s_id);
+			sysv_err(sb, "SCO EAFS detected, forcing read-only mode.\n");
  		}
  		return type;
  	}
@@ -240,8 +238,7 @@ static int detect_sysv(struct sysv_sb_info *sbi, struct buffer_head *bh)
            feature read-only mode seems to be a reasonable approach... -KGB */
 
 	if (type >= 0x10) {
-		printk("SysV FS: can't handle long file names on %s, "
-		       "forcing read-only mode.\n", sb->s_id);
+		sysv_err(sb, "can't handle long file names, forcing read-only mode.\n");
 		sbi->s_forced_ro = 1;
 	}
 
@@ -326,8 +323,8 @@ static int complete_read_super(struct super_block *sb, int silent, int size)
 		<< sbi->s_inodes_per_block_bits;
 
 	if (!silent)
-		printk("VFS: Found a %s FS (block size = %ld) on device %s\n",
-		       found, sb->s_blocksize, sb->s_id);
+		sysv_err(sb, "VFS: Found a %s FS (block size = %ld) on device\n",
+		       found, sb->s_blocksize);
 
 	sb->s_magic = SYSV_MAGIC_BASE + sbi->s_type;
 	/* set up enough so that it can read an inode */
@@ -338,12 +335,12 @@ static int complete_read_super(struct super_block *sb, int silent, int size)
 		sb->s_d_op = &sysv_dentry_operations;
 	root_inode = sysv_iget(sb, SYSV_ROOT_INO);
 	if (IS_ERR(root_inode)) {
-		printk("SysV FS: get root inode failed\n");
+		sysv_err(sb, "get root inode failed\n");
 		return 0;
 	}
 	sb->s_root = d_make_root(root_inode);
 	if (!sb->s_root) {
-		printk("SysV FS: get root dentry failed\n");
+		sysv_err(sb, "get root dentry failed\n");
 		return 0;
 	}
 	return 1;
@@ -415,7 +412,7 @@ static int sysv_fill_super(struct super_block *sb, void *data, int silent)
 	brelse(bh1);
 	brelse(bh);
 	sb_set_blocksize(sb, BLOCK_SIZE);
-	printk("oldfs: cannot read superblock\n");
+	sysv_err(sb, "oldfs: cannot read superblock\n");
 failed:
 	kfree(sbi);
 	return -EINVAL;
@@ -423,13 +420,12 @@ failed:
 Eunknown:
 	brelse(bh);
 	if (!silent)
-		printk("VFS: unable to find oldfs superblock on device %s\n",
-			sb->s_id);
+		sysv_err(sb, "VFS: unable to find oldfs superblock on device\n");
 	goto failed;
 Ebadsize:
 	brelse(bh);
 	if (!silent)
-		printk("VFS: oldfs: unsupported block size (%dKb)\n",
+		sysv_err(sb, "VFS: oldfs: unsupported block size (%dKb)\n",
 			1<<(size-2));
 	goto failed;
 }
@@ -494,8 +490,7 @@ static int v7_fill_super(struct super_block *sb, void *data, int silent)
 
 	if ((bh = sb_bread(sb, 1)) == NULL) {
 		if (!silent)
-			printk("VFS: unable to read V7 FS superblock on "
-			       "device %s.\n", sb->s_id);
+			sysv_err(sb, "VFS: unable to read V7 FS superblock on device\n");
 		goto failed;
 	}
 
@@ -518,8 +513,7 @@ detected:
 		return 0;
 
 failed:
-	printk(KERN_ERR "VFS: could not find a valid V7 on %s.\n",
-		sb->s_id);
+	sysv_err(sb, "VFS: could not find a valid V7\n");
 	brelse(bh);
 	kfree(sbi);
 	return -EINVAL;
diff --git a/fs/sysv/sysv.h b/fs/sysv/sysv.h
index 69d4889..d3c9d50 100644
--- a/fs/sysv/sysv.h
+++ b/fs/sysv/sysv.h
@@ -120,6 +120,9 @@ static inline void dirty_sb(struct super_block *sb)
 		mark_buffer_dirty(sbi->s_bh2);
 }
 
+/* debug.c */
+extern __printf(2, 3)
+void sysv_err(struct super_block *, const char *, ...);
 
 /* ialloc.c */
 extern struct sysv_inode *sysv_raw_inode(struct super_block *, unsigned,
-- 
1.8.4.5

