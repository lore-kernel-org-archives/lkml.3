Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaFESPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 14:15:01 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:47864 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753104AbaFESO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 14:14:59 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsYNAEGzkFNXQDfT/2dsb2JhbABZgwesCQUBmCcBgQ4XdIImAQUnLyMQUTkeGYhGAdM1F4VViH0HhEAEj06KRZM5gzo7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, akpm@linux-foundation.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 3/3] FS/QNX6: update debugging to current functions.
Date: Thu,  5 Jun 2014 20:12:13 +0200
Message-Id: <1401991933-7377-4-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1401991933-7377-1-git-send-email-fabf@skynet.be>
References: <1401991933-7377-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DDEBUG in Makefile when CONFIG_QNX6FS_DEBUG is set.
All QNX6DEBUG messages are replaced by pr_debug which means
debugging will be emitted in debug level only and no more in error
and info levels.
debug uses now pr_fmt and __func__

QNX6DEBUG definition has been removed.

Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/qnx6/Makefile |  1 +
 fs/qnx6/dir.c    | 12 ++++++------
 fs/qnx6/inode.c  | 37 +++++++++++++------------------------
 fs/qnx6/namei.c  |  6 +++---
 fs/qnx6/qnx6.h   |  6 ------
 5 files changed, 23 insertions(+), 39 deletions(-)

diff --git a/fs/qnx6/Makefile b/fs/qnx6/Makefile
index 9dd0619..5e6bae6 100644
--- a/fs/qnx6/Makefile
+++ b/fs/qnx6/Makefile
@@ -5,3 +5,4 @@
 obj-$(CONFIG_QNX6FS_FS) += qnx6.o
 
 qnx6-objs := inode.o dir.o namei.o super_mmi.o
+ccflags-$(CONFIG_QNX6FS_DEBUG)	+= -DDEBUG
diff --git a/fs/qnx6/dir.c b/fs/qnx6/dir.c
index c78a339..8d64bb5 100644
--- a/fs/qnx6/dir.c
+++ b/fs/qnx6/dir.c
@@ -89,7 +89,7 @@ static int qnx6_dir_longfilename(struct inode *inode,
 	lf_size = fs16_to_cpu(sbi, lf->lf_size);
 
 	if (lf_size > QNX6_LONG_NAME_MAX) {
-		QNX6DEBUG((KERN_INFO "file %s\n", lf->lf_fname));
+		pr_debug("file %s\n", lf->lf_fname);
 		pr_err("Filename too long (%i)\n", lf_size);
 		qnx6_put_page(page);
 		return 0;
@@ -101,8 +101,8 @@ static int qnx6_dir_longfilename(struct inode *inode,
 			qnx6_lfile_checksum(lf->lf_fname, lf_size))
 		pr_info("long filename checksum error.\n");
 
-	QNX6DEBUG((KERN_INFO "qnx6_readdir:%.*s inode:%u\n",
-					lf_size, lf->lf_fname, de_inode));
+	pr_debug("qnx6_readdir:%.*s inode:%u\n",
+		 lf_size, lf->lf_fname, de_inode);
 	if (!dir_emit(ctx, lf->lf_fname, lf_size, de_inode, DT_UNKNOWN)) {
 		qnx6_put_page(page);
 		return 0;
@@ -158,9 +158,9 @@ static int qnx6_readdir(struct file *file, struct dir_context *ctx)
 					break;
 				}
 			} else {
-				QNX6DEBUG((KERN_INFO "qnx6_readdir:%.*s"
-				   " inode:%u\n", size, de->de_fname,
-							no_inode));
+				pr_debug("%s():%.*s inode:%u\n",
+					 __func__, size, de->de_fname,
+					 no_inode);
 				if (!dir_emit(ctx, de->de_fname, size,
 				      no_inode, DT_UNKNOWN)) {
 					done = true;
diff --git a/fs/qnx6/inode.c b/fs/qnx6/inode.c
index 1652e8b..44e7392 100644
--- a/fs/qnx6/inode.c
+++ b/fs/qnx6/inode.c
@@ -73,8 +73,8 @@ static int qnx6_get_block(struct inode *inode, sector_t iblock,
 {
 	unsigned phys;
 
-	QNX6DEBUG((KERN_INFO "qnx6: qnx6_get_block inode=[%ld] iblock=[%ld]\n",
-			inode->i_ino, (unsigned long)iblock));
+	pr_debug("qnx6_get_block inode=[%ld] iblock=[%ld]\n",
+		 inode->i_ino, (unsigned long)iblock);
 
 	phys = qnx6_block_map(inode, iblock);
 	if (phys) {
@@ -205,26 +205,16 @@ void qnx6_superblock_debug(struct qnx6_super_block *sb, struct super_block *s)
 {
 	struct qnx6_sb_info *sbi = QNX6_SB(s);
 
-	QNX6DEBUG((KERN_INFO "magic: %08x\n",
-				fs32_to_cpu(sbi, sb->sb_magic)));
-	QNX6DEBUG((KERN_INFO "checksum: %08x\n",
-				fs32_to_cpu(sbi, sb->sb_checksum)));
-	QNX6DEBUG((KERN_INFO "serial: %llx\n",
-				fs64_to_cpu(sbi, sb->sb_serial)));
-	QNX6DEBUG((KERN_INFO "flags: %08x\n",
-				fs32_to_cpu(sbi, sb->sb_flags)));
-	QNX6DEBUG((KERN_INFO "blocksize: %08x\n",
-				fs32_to_cpu(sbi, sb->sb_blocksize)));
-	QNX6DEBUG((KERN_INFO "num_inodes: %08x\n",
-				fs32_to_cpu(sbi, sb->sb_num_inodes)));
-	QNX6DEBUG((KERN_INFO "free_inodes: %08x\n",
-				fs32_to_cpu(sbi, sb->sb_free_inodes)));
-	QNX6DEBUG((KERN_INFO "num_blocks: %08x\n",
-				fs32_to_cpu(sbi, sb->sb_num_blocks)));
-	QNX6DEBUG((KERN_INFO "free_blocks: %08x\n",
-				fs32_to_cpu(sbi, sb->sb_free_blocks)));
-	QNX6DEBUG((KERN_INFO "inode_levels: %02x\n",
-				sb->Inode.levels));
+	pr_debug("magic: %08x\n", fs32_to_cpu(sbi, sb->sb_magic));
+	pr_debug("checksum: %08x\n", fs32_to_cpu(sbi, sb->sb_checksum));
+	pr_debug("serial: %llx\n", fs64_to_cpu(sbi, sb->sb_serial));
+	pr_debug("flags: %08x\n", fs32_to_cpu(sbi, sb->sb_flags));
+	pr_debug("blocksize: %08x\n", fs32_to_cpu(sbi, sb->sb_blocksize));
+	pr_debug("num_inodes: %08x\n", fs32_to_cpu(sbi, sb->sb_num_inodes));
+	pr_debug("free_inodes: %08x\n", fs32_to_cpu(sbi, sb->sb_free_inodes));
+	pr_debug("num_blocks: %08x\n", fs32_to_cpu(sbi, sb->sb_num_blocks));
+	pr_debug("free_blocks: %08x\n", fs32_to_cpu(sbi, sb->sb_free_blocks));
+	pr_debug("inode_levels: %02x\n", sb->Inode.levels);
 }
 #endif
 
@@ -283,8 +273,7 @@ static struct buffer_head *qnx6_check_first_superblock(struct super_block *s,
 		sbi->s_bytesex = BYTESEX_BE;
 		if (fs32_to_cpu(sbi, sb->sb_magic) == QNX6_SUPER_MAGIC) {
 			/* we got a big endian fs */
-			QNX6DEBUG((KERN_INFO "qnx6: fs got different"
-					" endianness.\n"));
+			pr_debug("fs got different endianness.\n");
 			return bh;
 		} else
 			sbi->s_bytesex = BYTESEX_LE;
diff --git a/fs/qnx6/namei.c b/fs/qnx6/namei.c
index 0561326..6c1a323 100644
--- a/fs/qnx6/namei.c
+++ b/fs/qnx6/namei.c
@@ -29,12 +29,12 @@ struct dentry *qnx6_lookup(struct inode *dir, struct dentry *dentry,
 		foundinode = qnx6_iget(dir->i_sb, ino);
 		qnx6_put_page(page);
 		if (IS_ERR(foundinode)) {
-			QNX6DEBUG((KERN_ERR "qnx6: lookup->iget -> "
-				" error %ld\n", PTR_ERR(foundinode)));
+			pr_debug("lookup->iget ->  error %ld\n",
+				 PTR_ERR(foundinode));
 			return ERR_CAST(foundinode);
 		}
 	} else {
-		QNX6DEBUG((KERN_INFO "qnx6_lookup: not found %s\n", name));
+		pr_debug("%s(): not found %s\n", __func__, name);
 		return NULL;
 	}
 	d_add(dentry, foundinode);
diff --git a/fs/qnx6/qnx6.h b/fs/qnx6/qnx6.h
index b0aceda..d3fb2b6 100644
--- a/fs/qnx6/qnx6.h
+++ b/fs/qnx6/qnx6.h
@@ -25,12 +25,6 @@ typedef __u64 __bitwise __fs64;
 
 #include <linux/qnx6_fs.h>
 
-#ifdef CONFIG_QNX6FS_DEBUG
-#define QNX6DEBUG(X) printk X
-#else
-#define QNX6DEBUG(X) (void) 0
-#endif
-
 struct qnx6_sb_info {
 	struct buffer_head	*sb_buf;	/* superblock buffer */
 	struct qnx6_super_block	*sb;		/* our superblock */
-- 
1.8.4.5

