Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab3DLT4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 15:56:42 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:18308 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab3DLT4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 15:56:41 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Apr 2013 15:56:40 EDT
X-MDAV-Processed: mail.digidescorp.com, Fri, 12 Apr 2013 14:47:07 -0500
X-Spam-Processed: mail.digidescorp.com, Fri, 12 Apr 2013 14:47:06 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: smagnani@iscandar.digidescorp.com
X-Envelope-From: smagnani@iscandar.digidescorp.com
From: Steve Magnani <smagnani@iscandar.digidescorp.com>
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH] mmc: debugfs: Add debugfs ability to read CID and CSD
Date: Fri, 12 Apr 2013 14:46:53 -0500
Message-Id: <1365796013-11399-1-git-send-email-smagnani@iscandar.digidescorp.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds 'cid' and 'csd' debugfs entries for SD/MMC devices that allow
userland to obtain the values of the corresponding device registers.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
--- a/drivers/mmc/core/debugfs.c	2013-04-12 07:39:22.532586948 -0500
+++ b/drivers/mmc/core/debugfs.c	2013-04-12 07:40:14.513331587 -0500
@@ -321,7 +321,7 @@ static ssize_t mmc_ext_csd_read(struct f
 				       buf, EXT_CSD_STR_LEN);
 }
 
-static int mmc_ext_csd_release(struct inode *inode, struct file *file)
+static int mmc_dbg_buf_release(struct inode *inode, struct file *file)
 {
 	kfree(file->private_data);
 	return 0;
@@ -330,7 +330,65 @@ static int mmc_ext_csd_release(struct in
 static const struct file_operations mmc_dbg_ext_csd_fops = {
 	.open		= mmc_ext_csd_open,
 	.read		= mmc_ext_csd_read,
-	.release	= mmc_ext_csd_release,
+	.release	= mmc_dbg_buf_release,
+	.llseek		= default_llseek,
+};
+
+/* CSD and CID have the same length and so can be handled much the same */
+#define CXD_STR_LEN 33
+
+static int mmc_cxd_open(struct file *filp, u32 *raw_cxd)
+{
+	char *buf;
+	ssize_t n = 0;
+	int i;
+
+	buf = kmalloc(CXD_STR_LEN + 1, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	for (i = 0; i < 4; i++)
+		n += sprintf(buf + n, "%08x", raw_cxd[i]);
+	n += sprintf(buf + n, "\n");
+	BUG_ON(n != CXD_STR_LEN);
+
+	filp->private_data = buf;
+	return 0;
+}
+
+static ssize_t mmc_cxd_read(struct file *filp, char __user *ubuf,
+				size_t cnt, loff_t *ppos)
+{
+	char *buf = filp->private_data;
+
+	return simple_read_from_buffer(ubuf, cnt, ppos,
+				       buf, CXD_STR_LEN);
+}
+
+static int mmc_csd_open(struct inode *inode, struct file *filp)
+{
+	struct mmc_card *card = inode->i_private;
+	return mmc_cxd_open(filp, card->raw_csd);
+}
+
+static const struct file_operations mmc_dbg_csd_fops = {
+	.open		= mmc_csd_open,
+	.read		= mmc_cxd_read,
+	.release	= mmc_dbg_buf_release,
+	.llseek		= default_llseek,
+};
+
+
+static int mmc_cid_open(struct inode *inode, struct file *filp)
+{
+	struct mmc_card *card = inode->i_private;
+	return mmc_cxd_open(filp, card->raw_cid);
+}
+
+static const struct file_operations mmc_dbg_cid_fops = {
+	.open		= mmc_cid_open,
+	.read		= mmc_cxd_read,
+	.release	= mmc_dbg_buf_release,
 	.llseek		= default_llseek,
 };
 
@@ -356,10 +414,17 @@ void mmc_add_card_debugfs(struct mmc_car
 	if (!debugfs_create_x32("state", S_IRUSR, root, &card->state))
 		goto err;
 
-	if (mmc_card_mmc(card) || mmc_card_sd(card))
+	if (mmc_card_mmc(card) || mmc_card_sd(card)) {
 		if (!debugfs_create_file("status", S_IRUSR, root, card,
 					&mmc_dbg_card_status_fops))
 			goto err;
+		if (!debugfs_create_file("csd", S_IRUSR, root, card,
+					&mmc_dbg_csd_fops))
+			goto err;
+		if (!debugfs_create_file("cid", S_IRUSR, root, card,
+					&mmc_dbg_cid_fops))
+			goto err;
+	}
 
 	if (mmc_card_mmc(card))
 		if (!debugfs_create_file("ext_csd", S_IRUSR, root, card,

