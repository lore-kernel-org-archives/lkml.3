Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbaFESO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 14:14:57 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:47864 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751799AbaFESO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 14:14:56 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsYNAEGzkFNXQDfT/2dsb2JhbABZgwesCQUBmCcBgQ4XdIImAQUnLyMQUTkeGYhGAdM1F4VViCZXB4RABI9OikWLIIgZgzo7gTE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, akpm@linux-foundation.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/3] FS/QNX6: Convert printk to pr_foo()
Date: Thu,  5 Jun 2014 20:12:11 +0200
Message-Id: <1401991933-7377-2-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1401991933-7377-1-git-send-email-fabf@skynet.be>
References: <1401991933-7377-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use current logging functions.
coalesce formats

Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/qnx6/dir.c       | 14 ++++++------
 fs/qnx6/inode.c     | 62 +++++++++++++++++++++++------------------------------
 fs/qnx6/super_mmi.c | 22 +++++++++----------
 3 files changed, 43 insertions(+), 55 deletions(-)

diff --git a/fs/qnx6/dir.c b/fs/qnx6/dir.c
index 15b7d92..2289ea1 100644
--- a/fs/qnx6/dir.c
+++ b/fs/qnx6/dir.c
@@ -77,13 +77,12 @@ static int qnx6_dir_longfilename(struct inode *inode,
 	if (de->de_size != 0xff) {
 		/* error - long filename entries always have size 0xff
 		   in direntry */
-		printk(KERN_ERR "qnx6: invalid direntry size (%i).\n",
-				de->de_size);
+		pr_err("qnx6: invalid direntry size (%i).\n", de->de_size);
 		return 0;
 	}
 	lf = qnx6_longname(s, de, &page);
 	if (IS_ERR(lf)) {
-		printk(KERN_ERR "qnx6:Error reading longname\n");
+		pr_err("qnx6:Error reading longname\n");
 		return 0;
 	}
 
@@ -91,7 +90,7 @@ static int qnx6_dir_longfilename(struct inode *inode,
 
 	if (lf_size > QNX6_LONG_NAME_MAX) {
 		QNX6DEBUG((KERN_INFO "file %s\n", lf->lf_fname));
-		printk(KERN_ERR "qnx6:Filename too long (%i)\n", lf_size);
+		pr_err("qnx6:Filename too long (%i)\n", lf_size);
 		qnx6_put_page(page);
 		return 0;
 	}
@@ -100,7 +99,7 @@ static int qnx6_dir_longfilename(struct inode *inode,
 	   mmi 3g filesystem does not have that checksum */
 	if (!test_opt(s, MMI_FS) && fs32_to_cpu(sbi, de->de_checksum) !=
 			qnx6_lfile_checksum(lf->lf_fname, lf_size))
-		printk(KERN_INFO "qnx6: long filename checksum error.\n");
+		pr_info("qnx6: long filename checksum error.\n");
 
 	QNX6DEBUG((KERN_INFO "qnx6_readdir:%.*s inode:%u\n",
 					lf_size, lf->lf_fname, de_inode));
@@ -136,7 +135,7 @@ static int qnx6_readdir(struct file *file, struct dir_context *ctx)
 		int i = start;
 
 		if (IS_ERR(page)) {
-			printk(KERN_ERR "qnx6_readdir: read failed\n");
+			pr_err("qnx6_readdir: read failed\n");
 			ctx->pos = (n + 1) << PAGE_CACHE_SHIFT;
 			return PTR_ERR(page);
 		}
@@ -259,8 +258,7 @@ unsigned qnx6_find_entry(int len, struct inode *dir, const char *name,
 					if (ino)
 						goto found;
 				} else
-					printk(KERN_ERR "qnx6: undefined "
-						"filename size in inode.\n");
+					pr_err("qnx6: undefined filename size in inode.\n");
 			}
 			qnx6_put_page(page);
 		}
diff --git a/fs/qnx6/inode.c b/fs/qnx6/inode.c
index 65cdaab..0042af9 100644
--- a/fs/qnx6/inode.c
+++ b/fs/qnx6/inode.c
@@ -87,7 +87,7 @@ static int qnx6_get_block(struct inode *inode, sector_t iblock,
 static int qnx6_check_blockptr(__fs32 ptr)
 {
 	if (ptr == ~(__fs32)0) {
-		printk(KERN_ERR "qnx6: hit unused blockpointer.\n");
+		pr_err("qnx6: hit unused blockpointer.\n");
 		return 0;
 	}
 	return 1;
@@ -127,8 +127,7 @@ static unsigned qnx6_block_map(struct inode *inode, unsigned no)
 	levelptr = no >> bitdelta;
 
 	if (levelptr > QNX6_NO_DIRECT_POINTERS - 1) {
-		printk(KERN_ERR "qnx6:Requested file block number (%u) too big.",
-				no);
+		pr_err("qnx6:Requested file block number (%u) too big.", no);
 		return 0;
 	}
 
@@ -137,8 +136,7 @@ static unsigned qnx6_block_map(struct inode *inode, unsigned no)
 	for (i = 0; i < depth; i++) {
 		bh = sb_bread(s, block);
 		if (!bh) {
-			printk(KERN_ERR "qnx6:Error reading block (%u)\n",
-					block);
+			pr_err("qnx6:Error reading block (%u)\n", block);
 			return 0;
 		}
 		bitdelta -= ptrbits;
@@ -277,7 +275,7 @@ static struct buffer_head *qnx6_check_first_superblock(struct super_block *s,
 	   start with the first superblock */
 	bh = sb_bread(s, offset);
 	if (!bh) {
-		printk(KERN_ERR "qnx6: unable to read the first superblock\n");
+		pr_err("qnx6: unable to read the first superblock\n");
 		return NULL;
 	}
 	sb = (struct qnx6_super_block *)bh->b_data;
@@ -292,13 +290,10 @@ static struct buffer_head *qnx6_check_first_superblock(struct super_block *s,
 			sbi->s_bytesex = BYTESEX_LE;
 		if (!silent) {
 			if (offset == 0) {
-				printk(KERN_ERR "qnx6: wrong signature (magic)"
-					" in superblock #1.\n");
+				pr_err("qnx6: wrong signature (magic) in superblock #1.\n");
 			} else {
-				printk(KERN_INFO "qnx6: wrong signature (magic)"
-					" at position (0x%lx) - will try"
-					" alternative position (0x0000).\n",
-						offset * s->s_blocksize);
+				pr_info("qnx6: wrong signature (magic) at position (0x%lx) - will try alternative position (0x0000).\n",
+					offset * s->s_blocksize);
 			}
 		}
 		brelse(bh);
@@ -329,13 +324,13 @@ static int qnx6_fill_super(struct super_block *s, void *data, int silent)
 
 	/* Superblock always is 512 Byte long */
 	if (!sb_set_blocksize(s, QNX6_SUPERBLOCK_SIZE)) {
-		printk(KERN_ERR "qnx6: unable to set blocksize\n");
+		pr_err("qnx6: unable to set blocksize\n");
 		goto outnobh;
 	}
 
 	/* parse the mount-options */
 	if (!qnx6_parse_options((char *) data, s)) {
-		printk(KERN_ERR "qnx6: invalid mount options.\n");
+		pr_err("qnx6: invalid mount options.\n");
 		goto outnobh;
 	}
 	if (test_opt(s, MMI_FS)) {
@@ -355,7 +350,7 @@ static int qnx6_fill_super(struct super_block *s, void *data, int silent)
 		/* try again without bootblock offset */
 		bh1 = qnx6_check_first_superblock(s, 0, silent);
 		if (!bh1) {
-			printk(KERN_ERR "qnx6: unable to read the first superblock\n");
+			pr_err("qnx6: unable to read the first superblock\n");
 			goto outnobh;
 		}
 		/* seems that no bootblock at partition start */
@@ -370,13 +365,13 @@ static int qnx6_fill_super(struct super_block *s, void *data, int silent)
 	/* checksum check - start at byte 8 and end at byte 512 */
 	if (fs32_to_cpu(sbi, sb1->sb_checksum) !=
 			crc32_be(0, (char *)(bh1->b_data + 8), 504)) {
-		printk(KERN_ERR "qnx6: superblock #1 checksum error\n");
+		pr_err("qnx6: superblock #1 checksum error\n");
 		goto out;
 	}
 
 	/* set new blocksize */
 	if (!sb_set_blocksize(s, fs32_to_cpu(sbi, sb1->sb_blocksize))) {
-		printk(KERN_ERR "qnx6: unable to set blocksize\n");
+		pr_err("qnx6: unable to set blocksize\n");
 		goto out;
 	}
 	/* blocksize invalidates bh - pull it back in */
@@ -398,21 +393,20 @@ static int qnx6_fill_super(struct super_block *s, void *data, int silent)
 	/* next the second superblock */
 	bh2 = sb_bread(s, offset);
 	if (!bh2) {
-		printk(KERN_ERR "qnx6: unable to read the second superblock\n");
+		pr_err("qnx6: unable to read the second superblock\n");
 		goto out;
 	}
 	sb2 = (struct qnx6_super_block *)bh2->b_data;
 	if (fs32_to_cpu(sbi, sb2->sb_magic) != QNX6_SUPER_MAGIC) {
 		if (!silent)
-			printk(KERN_ERR "qnx6: wrong signature (magic)"
-					" in superblock #2.\n");
+			pr_err("qnx6: wrong signature (magic) in superblock #2.\n");
 		goto out;
 	}
 
 	/* checksum check - start at byte 8 and end at byte 512 */
 	if (fs32_to_cpu(sbi, sb2->sb_checksum) !=
 				crc32_be(0, (char *)(bh2->b_data + 8), 504)) {
-		printk(KERN_ERR "qnx6: superblock #2 checksum error\n");
+		pr_err("qnx6: superblock #2 checksum error\n");
 		goto out;
 	}
 
@@ -422,25 +416,24 @@ static int qnx6_fill_super(struct super_block *s, void *data, int silent)
 		sbi->sb_buf = bh1;
 		sbi->sb = (struct qnx6_super_block *)bh1->b_data;
 		brelse(bh2);
-		printk(KERN_INFO "qnx6: superblock #1 active\n");
+		pr_info("qnx6: superblock #1 active\n");
 	} else {
 		/* superblock #2 active */
 		sbi->sb_buf = bh2;
 		sbi->sb = (struct qnx6_super_block *)bh2->b_data;
 		brelse(bh1);
-		printk(KERN_INFO "qnx6: superblock #2 active\n");
+		pr_info("qnx6: superblock #2 active\n");
 	}
 mmi_success:
 	/* sanity check - limit maximum indirect pointer levels */
 	if (sb1->Inode.levels > QNX6_PTR_MAX_LEVELS) {
-		printk(KERN_ERR "qnx6: too many inode levels (max %i, sb %i)\n",
-			QNX6_PTR_MAX_LEVELS, sb1->Inode.levels);
+		pr_err("qnx6: too many inode levels (max %i, sb %i)\n",
+		       QNX6_PTR_MAX_LEVELS, sb1->Inode.levels);
 		goto out;
 	}
 	if (sb1->Longfile.levels > QNX6_PTR_MAX_LEVELS) {
-		printk(KERN_ERR "qnx6: too many longfilename levels"
-				" (max %i, sb %i)\n",
-			QNX6_PTR_MAX_LEVELS, sb1->Longfile.levels);
+		pr_err("qnx6: too many longfilename levels (max %i, sb %i)\n",
+		       QNX6_PTR_MAX_LEVELS, sb1->Longfile.levels);
 		goto out;
 	}
 	s->s_op = &qnx6_sops;
@@ -460,7 +453,7 @@ mmi_success:
 	/* prefetch root inode */
 	root = qnx6_iget(s, QNX6_ROOT_INO);
 	if (IS_ERR(root)) {
-		printk(KERN_ERR "qnx6: get inode failed\n");
+		pr_err("qnx6: get inode failed\n");
 		ret = PTR_ERR(root);
 		goto out2;
 	}
@@ -474,7 +467,7 @@ mmi_success:
 	errmsg = qnx6_checkroot(s);
 	if (errmsg != NULL) {
 		if (!silent)
-			printk(KERN_ERR "qnx6: %s\n", errmsg);
+			pr_err("qnx6: %s\n", errmsg);
 		goto out3;
 	}
 	return 0;
@@ -555,8 +548,7 @@ struct inode *qnx6_iget(struct super_block *sb, unsigned ino)
 	inode->i_mode = 0;
 
 	if (ino == 0) {
-		printk(KERN_ERR "qnx6: bad inode number on dev %s: %u is "
-				"out of range\n",
+		pr_err("qnx6: bad inode number on dev %s: %u is out of range\n",
 		       sb->s_id, ino);
 		iget_failed(inode);
 		return ERR_PTR(-EIO);
@@ -566,8 +558,8 @@ struct inode *qnx6_iget(struct super_block *sb, unsigned ino)
 	mapping = sbi->inodes->i_mapping;
 	page = read_mapping_page(mapping, n, NULL);
 	if (IS_ERR(page)) {
-		printk(KERN_ERR "qnx6: major problem: unable to read inode from "
-		       "dev %s\n", sb->s_id);
+		pr_err("qnx6: major problem: unable to read inode from dev %s\n",
+		       sb->s_id);
 		iget_failed(inode);
 		return ERR_CAST(page);
 	}
@@ -689,7 +681,7 @@ static int __init init_qnx6_fs(void)
 		return err;
 	}
 
-	printk(KERN_INFO "QNX6 filesystem 1.0.0 registered.\n");
+	pr_info("QNX6 filesystem 1.0.0 registered.\n");
 	return 0;
 }
 
diff --git a/fs/qnx6/super_mmi.c b/fs/qnx6/super_mmi.c
index 29c32cb..8e056b0 100644
--- a/fs/qnx6/super_mmi.c
+++ b/fs/qnx6/super_mmi.c
@@ -44,15 +44,14 @@ struct qnx6_super_block *qnx6_mmi_fill_super(struct super_block *s, int silent)
 	   start with the first superblock */
 	bh1 = sb_bread(s, 0);
 	if (!bh1) {
-		printk(KERN_ERR "qnx6: Unable to read first mmi superblock\n");
+		pr_err("qnx6: Unable to read first mmi superblock\n");
 		return NULL;
 	}
 	sb1 = (struct qnx6_mmi_super_block *)bh1->b_data;
 	sbi = QNX6_SB(s);
 	if (fs32_to_cpu(sbi, sb1->sb_magic) != QNX6_SUPER_MAGIC) {
 		if (!silent) {
-			printk(KERN_ERR "qnx6: wrong signature (magic) in"
-					" superblock #1.\n");
+			pr_err("qnx6: wrong signature (magic) in superblock #1.\n");
 			goto out;
 		}
 	}
@@ -60,7 +59,7 @@ struct qnx6_super_block *qnx6_mmi_fill_super(struct super_block *s, int silent)
 	/* checksum check - start at byte 8 and end at byte 512 */
 	if (fs32_to_cpu(sbi, sb1->sb_checksum) !=
 				crc32_be(0, (char *)(bh1->b_data + 8), 504)) {
-		printk(KERN_ERR "qnx6: superblock #1 checksum error\n");
+		pr_err("qnx6: superblock #1 checksum error\n");
 		goto out;
 	}
 
@@ -70,7 +69,7 @@ struct qnx6_super_block *qnx6_mmi_fill_super(struct super_block *s, int silent)
 
 	/* set new blocksize */
 	if (!sb_set_blocksize(s, fs32_to_cpu(sbi, sb1->sb_blocksize))) {
-		printk(KERN_ERR "qnx6: unable to set blocksize\n");
+		pr_err("qnx6: unable to set blocksize\n");
 		goto out;
 	}
 	/* blocksize invalidates bh - pull it back in */
@@ -83,27 +82,26 @@ struct qnx6_super_block *qnx6_mmi_fill_super(struct super_block *s, int silent)
 	/* read second superblock */
 	bh2 = sb_bread(s, offset);
 	if (!bh2) {
-		printk(KERN_ERR "qnx6: unable to read the second superblock\n");
+		pr_err("qnx6: unable to read the second superblock\n");
 		goto out;
 	}
 	sb2 = (struct qnx6_mmi_super_block *)bh2->b_data;
 	if (fs32_to_cpu(sbi, sb2->sb_magic) != QNX6_SUPER_MAGIC) {
 		if (!silent)
-			printk(KERN_ERR "qnx6: wrong signature (magic) in"
-					" superblock #2.\n");
+			pr_err("qnx6: wrong signature (magic) in superblock #2.\n");
 		goto out;
 	}
 
 	/* checksum check - start at byte 8 and end at byte 512 */
 	if (fs32_to_cpu(sbi, sb2->sb_checksum)
 			!= crc32_be(0, (char *)(bh2->b_data + 8), 504)) {
-		printk(KERN_ERR "qnx6: superblock #1 checksum error\n");
+		pr_err("qnx6: superblock #1 checksum error\n");
 		goto out;
 	}
 
 	qsb = kmalloc(sizeof(*qsb), GFP_KERNEL);
 	if (!qsb) {
-		printk(KERN_ERR "qnx6: unable to allocate memory.\n");
+		pr_err("qnx6: unable to allocate memory.\n");
 		goto out;
 	}
 
@@ -119,7 +117,7 @@ struct qnx6_super_block *qnx6_mmi_fill_super(struct super_block *s, int silent)
 		sbi->sb_buf = bh1;
 		sbi->sb = (struct qnx6_super_block *)bh1->b_data;
 		brelse(bh2);
-		printk(KERN_INFO "qnx6: superblock #1 active\n");
+		pr_info("qnx6: superblock #1 active\n");
 	} else {
 		/* superblock #2 active */
 		qnx6_mmi_copy_sb(qsb, sb2);
@@ -131,7 +129,7 @@ struct qnx6_super_block *qnx6_mmi_fill_super(struct super_block *s, int silent)
 		sbi->sb_buf = bh2;
 		sbi->sb = (struct qnx6_super_block *)bh2->b_data;
 		brelse(bh1);
-		printk(KERN_INFO "qnx6: superblock #2 active\n");
+		pr_info("qnx6: superblock #2 active\n");
 	}
 	kfree(qsb);
 
-- 
1.8.4.5

