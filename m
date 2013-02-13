Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128Ab3BMKXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 05:23:31 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39137 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab3BMKX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 05:23:29 -0500
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: linux-mtd@lists.infradead.org
Cc: kernel@pengutronix.de, artem.bityutskiy@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Subodh Nijsure <snijsure@grid-net.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH RFC 3/5] UBIFS: Add xattr support for symlinks
Date: Wed, 13 Feb 2013 11:23:16 +0100
Message-Id: <1360750998-15191-4-git-send-email-mkl@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360750998-15191-1-git-send-email-mkl@pengutronix.de>
References: <1360750998-15191-1-git-send-email-mkl@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Subodh Nijsure <snijsure@grid-net.com>

Signed-off-by: Subodh Nijsure <snijsure@grid-net.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 fs/ubifs/file.c  |    4 ++++
 fs/ubifs/xattr.c |   18 +++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 5bc7781..ed9655c 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1574,6 +1574,10 @@ const struct inode_operations ubifs_symlink_inode_operations = {
 	.follow_link = ubifs_follow_link,
 	.setattr     = ubifs_setattr,
 	.getattr     = ubifs_getattr,
+	.setxattr    = ubifs_setxattr,
+	.getxattr    = ubifs_getxattr,
+	.listxattr   = ubifs_listxattr,
+	.removexattr = ubifs_removexattr,
 };
 
 const struct file_operations ubifs_file_operations = {
diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
index 1395307..d496aa4 100644
--- a/fs/ubifs/xattr.c
+++ b/fs/ubifs/xattr.c
@@ -293,18 +293,16 @@ static struct inode *iget_xattr(struct ubifs_info *c, ino_t inum)
 	return ERR_PTR(-EINVAL);
 }
 
-int ubifs_setxattr(struct dentry *dentry, const char *name,
-		   const void *value, size_t size, int flags)
+static int __ubifs_setxattr(struct inode *host, const char *name,
+			    const void *value, size_t size, int flags)
 {
-	struct inode *inode, *host = dentry->d_inode;
+	struct inode *inode;
 	struct ubifs_info *c = host->i_sb->s_fs_info;
 	struct qstr nm = QSTR_INIT(name, strlen(name));
 	struct ubifs_dent_node *xent;
 	union ubifs_key key;
 	int err, type;
 
-	dbg_gen("xattr '%s', host ino %lu ('%.*s'), size %zd", name,
-		host->i_ino, dentry->d_name.len, dentry->d_name.name, size);
 	ubifs_assert(mutex_is_locked(&host->i_mutex));
 
 	if (size > UBIFS_MAX_INO_DATA)
@@ -356,6 +354,16 @@ out_free:
 	return err;
 }
 
+int ubifs_setxattr(struct dentry *dentry, const char *name,
+		     const void *value, size_t size, int flags)
+{
+	dbg_gen("xattr '%s', host ino %lu ('%.*s'), size %zd",
+		name, dentry->d_inode->i_ino, dentry->d_name.len,
+		dentry->d_name.name, size);
+
+	return __ubifs_setxattr(dentry->d_inode, name, value, size, flags);
+}
+
 ssize_t ubifs_getxattr(struct dentry *dentry, const char *name, void *buf,
 		       size_t size)
 {
-- 
1.7.10.4

