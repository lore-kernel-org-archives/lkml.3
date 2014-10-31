Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498AbaJaT2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 15:28:14 -0400
Received: from skprod2.natinst.com ([130.164.80.23]:50054 "EHLO ni.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751626AbaJaT2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 15:28:13 -0400
X-Greylist: delayed 2206 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Oct 2014 15:28:13 EDT
From: Ben Shelton <ben.shelton@ni.com>
To: linux-mtd@lists.infradead.org
Cc: dedekind1@gmail.com, adrian.hunter@intel.com, linux-kernel@vger.kernel.org,
        Subodh Nijsure <snijsure@grid-net.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Ben Shelton <ben.shelton@ni.com>
Subject: [PATCH 2/4] UBIFS: Add xattr support for symlinks
Date: Fri, 31 Oct 2014 13:50:29 -0500
Message-Id: <1414781431-2911-3-git-send-email-ben.shelton@ni.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414781431-2911-1-git-send-email-ben.shelton@ni.com>
References: <1414781431-2911-1-git-send-email-ben.shelton@ni.com>
X-MIMETrack: Itemize by SMTP Server on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 10/31/2014 01:51:11 PM,
	Serialize by Router on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 10/31/2014 01:51:11 PM,
	Serialize complete at 10/31/2014 01:51:11 PM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-31_08:2014-10-31,2014-10-31,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Subodh Nijsure <snijsure@grid-net.com>

Signed-off-by: Subodh Nijsure <snijsure@grid-net.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Ben Shelton <ben.shelton@ni.com>
Acked-by: Terry Wilcox <terry.wilcox@ni.com>
Acked-by: Gratian Crisan <gratian.crisan@ni.com>
---
 fs/ubifs/file.c  |  4 ++++
 fs/ubifs/xattr.c | 17 ++++++++++++-----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index b5b593c..4a1d4cf 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1573,6 +1573,10 @@ const struct inode_operations ubifs_symlink_inode_operations = {
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
index 5e0a63b..d0f69c2 100644
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
 
-	dbg_gen("xattr '%s', host ino %lu ('%pd'), size %zd", name,
-		host->i_ino, dentry, size);
 	ubifs_assert(mutex_is_locked(&host->i_mutex));
 
 	if (size > UBIFS_MAX_INO_DATA)
@@ -356,6 +354,15 @@ out_free:
 	return err;
 }
 
+int ubifs_setxattr(struct dentry *dentry, const char *name,
+		   const void *value, size_t size, int flags)
+{
+	dbg_gen("xattr '%s', host ino %lu ('%pd'), size %zd",
+		name, dentry->d_inode->i_ino, dentry, size);
+
+	return __ubifs_setxattr(dentry->d_inode, name, value, size, flags);
+}
+
 ssize_t ubifs_getxattr(struct dentry *dentry, const char *name, void *buf,
 		       size_t size)
 {
-- 
2.1.1

