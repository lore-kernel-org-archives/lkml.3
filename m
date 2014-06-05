Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbaFESO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 14:14:58 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:47864 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751915AbaFESO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 14:14:57 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsYNAEGzkFNXQDfT/2dsb2JhbABZgwesCQUBmCcBgQ4XdIImAQUnLyMQUTkeGYhGAdM1F4VViCZXB4RABI9OikWLIIgZgzo7gTE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, akpm@linux-foundation.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 2/3] FS/QNX6: use pr_fmt and __func__ in logging
Date: Thu,  5 Jun 2014 20:12:12 +0200
Message-Id: <1401991933-7377-3-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1401991933-7377-1-git-send-email-fabf@skynet.be>
References: <1401991933-7377-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove "qnx6:" and "qnx6: " from each logging instruction

Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/qnx6/dir.c       | 12 ++++++------
 fs/qnx6/inode.c     | 44 ++++++++++++++++++++++----------------------
 fs/qnx6/qnx6.h      |  6 ++++++
 fs/qnx6/super_mmi.c | 20 ++++++++++----------
 4 files changed, 44 insertions(+), 38 deletions(-)

diff --git a/fs/qnx6/dir.c b/fs/qnx6/dir.c
index 2289ea1..c78a339 100644
--- a/fs/qnx6/dir.c
+++ b/fs/qnx6/dir.c
@@ -77,12 +77,12 @@ static int qnx6_dir_longfilename(struct inode *inode,
 	if (de->de_size != 0xff) {
 		/* error - long filename entries always have size 0xff
 		   in direntry */
-		pr_err("qnx6: invalid direntry size (%i).\n", de->de_size);
+		pr_err("invalid direntry size (%i).\n", de->de_size);
 		return 0;
 	}
 	lf = qnx6_longname(s, de, &page);
 	if (IS_ERR(lf)) {
-		pr_err("qnx6:Error reading longname\n");
+		pr_err("Error reading longname\n");
 		return 0;
 	}
 
@@ -90,7 +90,7 @@ static int qnx6_dir_longfilename(struct inode *inode,
 
 	if (lf_size > QNX6_LONG_NAME_MAX) {
 		QNX6DEBUG((KERN_INFO "file %s\n", lf->lf_fname));
-		pr_err("qnx6:Filename too long (%i)\n", lf_size);
+		pr_err("Filename too long (%i)\n", lf_size);
 		qnx6_put_page(page);
 		return 0;
 	}
@@ -99,7 +99,7 @@ static int qnx6_dir_longfilename(struct inode *inode,
 	   mmi 3g filesystem does not have that checksum */
 	if (!test_opt(s, MMI_FS) && fs32_to_cpu(sbi, de->de_checksum) !=
 			qnx6_lfile_checksum(lf->lf_fname, lf_size))
-		pr_info("qnx6: long filename checksum error.\n");
+		pr_info("long filename checksum error.\n");
 
 	QNX6DEBUG((KERN_INFO "qnx6_readdir:%.*s inode:%u\n",
 					lf_size, lf->lf_fname, de_inode));
@@ -135,7 +135,7 @@ static int qnx6_readdir(struct file *file, struct dir_context *ctx)
 		int i = start;
 
 		if (IS_ERR(page)) {
-			pr_err("qnx6_readdir: read failed\n");
+			pr_err("%s(): read failed\n", __func__);
 			ctx->pos = (n + 1) << PAGE_CACHE_SHIFT;
 			return PTR_ERR(page);
 		}
@@ -258,7 +258,7 @@ unsigned qnx6_find_entry(int len, struct inode *dir, const char *name,
 					if (ino)
 						goto found;
 				} else
-					pr_err("qnx6: undefined filename size in inode.\n");
+					pr_err("undefined filename size in inode.\n");
 			}
 			qnx6_put_page(page);
 		}
diff --git a/fs/qnx6/inode.c b/fs/qnx6/inode.c
index 0042af9..1652e8b 100644
--- a/fs/qnx6/inode.c
+++ b/fs/qnx6/inode.c
@@ -87,7 +87,7 @@ static int qnx6_get_block(struct inode *inode, sector_t iblock,
 static int qnx6_check_blockptr(__fs32 ptr)
 {
 	if (ptr == ~(__fs32)0) {
-		pr_err("qnx6: hit unused blockpointer.\n");
+		pr_err("hit unused blockpointer.\n");
 		return 0;
 	}
 	return 1;
@@ -127,7 +127,7 @@ static unsigned qnx6_block_map(struct inode *inode, unsigned no)
 	levelptr = no >> bitdelta;
 
 	if (levelptr > QNX6_NO_DIRECT_POINTERS - 1) {
-		pr_err("qnx6:Requested file block number (%u) too big.", no);
+		pr_err("Requested file block number (%u) too big.", no);
 		return 0;
 	}
 
@@ -136,7 +136,7 @@ static unsigned qnx6_block_map(struct inode *inode, unsigned no)
 	for (i = 0; i < depth; i++) {
 		bh = sb_bread(s, block);
 		if (!bh) {
-			pr_err("qnx6:Error reading block (%u)\n", block);
+			pr_err("Error reading block (%u)\n", block);
 			return 0;
 		}
 		bitdelta -= ptrbits;
@@ -275,7 +275,7 @@ static struct buffer_head *qnx6_check_first_superblock(struct super_block *s,
 	   start with the first superblock */
 	bh = sb_bread(s, offset);
 	if (!bh) {
-		pr_err("qnx6: unable to read the first superblock\n");
+		pr_err("unable to read the first superblock\n");
 		return NULL;
 	}
 	sb = (struct qnx6_super_block *)bh->b_data;
@@ -290,9 +290,9 @@ static struct buffer_head *qnx6_check_first_superblock(struct super_block *s,
 			sbi->s_bytesex = BYTESEX_LE;
 		if (!silent) {
 			if (offset == 0) {
-				pr_err("qnx6: wrong signature (magic) in superblock #1.\n");
+				pr_err("wrong signature (magic) in superblock #1.\n");
 			} else {
-				pr_info("qnx6: wrong signature (magic) at position (0x%lx) - will try alternative position (0x0000).\n",
+				pr_info("wrong signature (magic) at position (0x%lx) - will try alternative position (0x0000).\n",
 					offset * s->s_blocksize);
 			}
 		}
@@ -324,13 +324,13 @@ static int qnx6_fill_super(struct super_block *s, void *data, int silent)
 
 	/* Superblock always is 512 Byte long */
 	if (!sb_set_blocksize(s, QNX6_SUPERBLOCK_SIZE)) {
-		pr_err("qnx6: unable to set blocksize\n");
+		pr_err("unable to set blocksize\n");
 		goto outnobh;
 	}
 
 	/* parse the mount-options */
 	if (!qnx6_parse_options((char *) data, s)) {
-		pr_err("qnx6: invalid mount options.\n");
+		pr_err("invalid mount options.\n");
 		goto outnobh;
 	}
 	if (test_opt(s, MMI_FS)) {
@@ -350,7 +350,7 @@ static int qnx6_fill_super(struct super_block *s, void *data, int silent)
 		/* try again without bootblock offset */
 		bh1 = qnx6_check_first_superblock(s, 0, silent);
 		if (!bh1) {
-			pr_err("qnx6: unable to read the first superblock\n");
+			pr_err("unable to read the first superblock\n");
 			goto outnobh;
 		}
 		/* seems that no bootblock at partition start */
@@ -365,13 +365,13 @@ static int qnx6_fill_super(struct super_block *s, void *data, int silent)
 	/* checksum check - start at byte 8 and end at byte 512 */
 	if (fs32_to_cpu(sbi, sb1->sb_checksum) !=
 			crc32_be(0, (char *)(bh1->b_data + 8), 504)) {
-		pr_err("qnx6: superblock #1 checksum error\n");
+		pr_err("superblock #1 checksum error\n");
 		goto out;
 	}
 
 	/* set new blocksize */
 	if (!sb_set_blocksize(s, fs32_to_cpu(sbi, sb1->sb_blocksize))) {
-		pr_err("qnx6: unable to set blocksize\n");
+		pr_err("unable to set blocksize\n");
 		goto out;
 	}
 	/* blocksize invalidates bh - pull it back in */
@@ -393,20 +393,20 @@ static int qnx6_fill_super(struct super_block *s, void *data, int silent)
 	/* next the second superblock */
 	bh2 = sb_bread(s, offset);
 	if (!bh2) {
-		pr_err("qnx6: unable to read the second superblock\n");
+		pr_err("unable to read the second superblock\n");
 		goto out;
 	}
 	sb2 = (struct qnx6_super_block *)bh2->b_data;
 	if (fs32_to_cpu(sbi, sb2->sb_magic) != QNX6_SUPER_MAGIC) {
 		if (!silent)
-			pr_err("qnx6: wrong signature (magic) in superblock #2.\n");
+			pr_err("wrong signature (magic) in superblock #2.\n");
 		goto out;
 	}
 
 	/* checksum check - start at byte 8 and end at byte 512 */
 	if (fs32_to_cpu(sbi, sb2->sb_checksum) !=
 				crc32_be(0, (char *)(bh2->b_data + 8), 504)) {
-		pr_err("qnx6: superblock #2 checksum error\n");
+		pr_err("superblock #2 checksum error\n");
 		goto out;
 	}
 
@@ -416,23 +416,23 @@ static int qnx6_fill_super(struct super_block *s, void *data, int silent)
 		sbi->sb_buf = bh1;
 		sbi->sb = (struct qnx6_super_block *)bh1->b_data;
 		brelse(bh2);
-		pr_info("qnx6: superblock #1 active\n");
+		pr_info("superblock #1 active\n");
 	} else {
 		/* superblock #2 active */
 		sbi->sb_buf = bh2;
 		sbi->sb = (struct qnx6_super_block *)bh2->b_data;
 		brelse(bh1);
-		pr_info("qnx6: superblock #2 active\n");
+		pr_info("superblock #2 active\n");
 	}
 mmi_success:
 	/* sanity check - limit maximum indirect pointer levels */
 	if (sb1->Inode.levels > QNX6_PTR_MAX_LEVELS) {
-		pr_err("qnx6: too many inode levels (max %i, sb %i)\n",
+		pr_err("too many inode levels (max %i, sb %i)\n",
 		       QNX6_PTR_MAX_LEVELS, sb1->Inode.levels);
 		goto out;
 	}
 	if (sb1->Longfile.levels > QNX6_PTR_MAX_LEVELS) {
-		pr_err("qnx6: too many longfilename levels (max %i, sb %i)\n",
+		pr_err("too many longfilename levels (max %i, sb %i)\n",
 		       QNX6_PTR_MAX_LEVELS, sb1->Longfile.levels);
 		goto out;
 	}
@@ -453,7 +453,7 @@ mmi_success:
 	/* prefetch root inode */
 	root = qnx6_iget(s, QNX6_ROOT_INO);
 	if (IS_ERR(root)) {
-		pr_err("qnx6: get inode failed\n");
+		pr_err("get inode failed\n");
 		ret = PTR_ERR(root);
 		goto out2;
 	}
@@ -467,7 +467,7 @@ mmi_success:
 	errmsg = qnx6_checkroot(s);
 	if (errmsg != NULL) {
 		if (!silent)
-			pr_err("qnx6: %s\n", errmsg);
+			pr_err("%s\n", errmsg);
 		goto out3;
 	}
 	return 0;
@@ -548,7 +548,7 @@ struct inode *qnx6_iget(struct super_block *sb, unsigned ino)
 	inode->i_mode = 0;
 
 	if (ino == 0) {
-		pr_err("qnx6: bad inode number on dev %s: %u is out of range\n",
+		pr_err("bad inode number on dev %s: %u is out of range\n",
 		       sb->s_id, ino);
 		iget_failed(inode);
 		return ERR_PTR(-EIO);
@@ -558,7 +558,7 @@ struct inode *qnx6_iget(struct super_block *sb, unsigned ino)
 	mapping = sbi->inodes->i_mapping;
 	page = read_mapping_page(mapping, n, NULL);
 	if (IS_ERR(page)) {
-		pr_err("qnx6: major problem: unable to read inode from dev %s\n",
+		pr_err("major problem: unable to read inode from dev %s\n",
 		       sb->s_id);
 		iget_failed(inode);
 		return ERR_CAST(page);
diff --git a/fs/qnx6/qnx6.h b/fs/qnx6/qnx6.h
index b00fcc9..b0aceda 100644
--- a/fs/qnx6/qnx6.h
+++ b/fs/qnx6/qnx6.h
@@ -10,6 +10,12 @@
  *
  */
 
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 
diff --git a/fs/qnx6/super_mmi.c b/fs/qnx6/super_mmi.c
index 8e056b0..62aaf3e 100644
--- a/fs/qnx6/super_mmi.c
+++ b/fs/qnx6/super_mmi.c
@@ -44,14 +44,14 @@ struct qnx6_super_block *qnx6_mmi_fill_super(struct super_block *s, int silent)
 	   start with the first superblock */
 	bh1 = sb_bread(s, 0);
 	if (!bh1) {
-		pr_err("qnx6: Unable to read first mmi superblock\n");
+		pr_err("Unable to read first mmi superblock\n");
 		return NULL;
 	}
 	sb1 = (struct qnx6_mmi_super_block *)bh1->b_data;
 	sbi = QNX6_SB(s);
 	if (fs32_to_cpu(sbi, sb1->sb_magic) != QNX6_SUPER_MAGIC) {
 		if (!silent) {
-			pr_err("qnx6: wrong signature (magic) in superblock #1.\n");
+			pr_err("wrong signature (magic) in superblock #1.\n");
 			goto out;
 		}
 	}
@@ -59,7 +59,7 @@ struct qnx6_super_block *qnx6_mmi_fill_super(struct super_block *s, int silent)
 	/* checksum check - start at byte 8 and end at byte 512 */
 	if (fs32_to_cpu(sbi, sb1->sb_checksum) !=
 				crc32_be(0, (char *)(bh1->b_data + 8), 504)) {
-		pr_err("qnx6: superblock #1 checksum error\n");
+		pr_err("superblock #1 checksum error\n");
 		goto out;
 	}
 
@@ -69,7 +69,7 @@ struct qnx6_super_block *qnx6_mmi_fill_super(struct super_block *s, int silent)
 
 	/* set new blocksize */
 	if (!sb_set_blocksize(s, fs32_to_cpu(sbi, sb1->sb_blocksize))) {
-		pr_err("qnx6: unable to set blocksize\n");
+		pr_err("unable to set blocksize\n");
 		goto out;
 	}
 	/* blocksize invalidates bh - pull it back in */
@@ -82,26 +82,26 @@ struct qnx6_super_block *qnx6_mmi_fill_super(struct super_block *s, int silent)
 	/* read second superblock */
 	bh2 = sb_bread(s, offset);
 	if (!bh2) {
-		pr_err("qnx6: unable to read the second superblock\n");
+		pr_err("unable to read the second superblock\n");
 		goto out;
 	}
 	sb2 = (struct qnx6_mmi_super_block *)bh2->b_data;
 	if (fs32_to_cpu(sbi, sb2->sb_magic) != QNX6_SUPER_MAGIC) {
 		if (!silent)
-			pr_err("qnx6: wrong signature (magic) in superblock #2.\n");
+			pr_err("wrong signature (magic) in superblock #2.\n");
 		goto out;
 	}
 
 	/* checksum check - start at byte 8 and end at byte 512 */
 	if (fs32_to_cpu(sbi, sb2->sb_checksum)
 			!= crc32_be(0, (char *)(bh2->b_data + 8), 504)) {
-		pr_err("qnx6: superblock #1 checksum error\n");
+		pr_err("superblock #1 checksum error\n");
 		goto out;
 	}
 
 	qsb = kmalloc(sizeof(*qsb), GFP_KERNEL);
 	if (!qsb) {
-		pr_err("qnx6: unable to allocate memory.\n");
+		pr_err("unable to allocate memory.\n");
 		goto out;
 	}
 
@@ -117,7 +117,7 @@ struct qnx6_super_block *qnx6_mmi_fill_super(struct super_block *s, int silent)
 		sbi->sb_buf = bh1;
 		sbi->sb = (struct qnx6_super_block *)bh1->b_data;
 		brelse(bh2);
-		pr_info("qnx6: superblock #1 active\n");
+		pr_info("superblock #1 active\n");
 	} else {
 		/* superblock #2 active */
 		qnx6_mmi_copy_sb(qsb, sb2);
@@ -129,7 +129,7 @@ struct qnx6_super_block *qnx6_mmi_fill_super(struct super_block *s, int silent)
 		sbi->sb_buf = bh2;
 		sbi->sb = (struct qnx6_super_block *)bh2->b_data;
 		brelse(bh1);
-		pr_info("qnx6: superblock #2 active\n");
+		pr_info("superblock #2 active\n");
 	}
 	kfree(qsb);
 
-- 
1.8.4.5

