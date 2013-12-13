Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab3LMO21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:28:27 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48175 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab3LMO2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:28:22 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH 4/5] xfs: add a new method xfs_vn_tmpfile()
Date: Fri, 13 Dec 2013 22:27:52 +0800
Message-Id: <1386944873-16796-5-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
References: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121314-0320-0000-0000-000001F7EF39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Add a new O_TMPFILE method to VFS inteface.
For more info, please refer to:
  http://oss.sgi.com/archives/xfs/2013-08/msg00336.html

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/xfs/xfs_iops.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index eb55be5..b57cd89 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -39,6 +39,7 @@
 #include "xfs_da_btree.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_dinode.h"
+#include "xfs_trans_space.h"
 
 #include <linux/capability.h>
 #include <linux/xattr.h>
@@ -1051,6 +1052,25 @@ xfs_vn_fiemap(
 	return 0;
 }
 
+STATIC int
+xfs_vn_tmpfile(
+	struct inode	*dir,
+	struct dentry	*dentry,
+	umode_t		mode)
+{
+	struct xfs_inode *ip = NULL;
+	int		error;
+
+	error = xfs_create_tmpfile(XFS_I(dir), XFS_I(dir)->i_mount,
+				mode, 0, &ip);
+	if (error)
+		return -error;
+
+	d_instantiate(dentry, VFS_I(ip));
+
+	return -error;
+}
+
 static const struct inode_operations xfs_inode_operations = {
 	.get_acl		= xfs_get_acl,
 	.getattr		= xfs_vn_getattr,
@@ -1087,6 +1107,7 @@ static const struct inode_operations xfs_dir_inode_operations = {
 	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
 	.update_time		= xfs_vn_update_time,
+	.tmpfile		= xfs_vn_tmpfile,
 };
 
 static const struct inode_operations xfs_dir_ci_inode_operations = {
@@ -1113,6 +1134,7 @@ static const struct inode_operations xfs_dir_ci_inode_operations = {
 	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
 	.update_time		= xfs_vn_update_time,
+	.tmpfile		= xfs_vn_tmpfile,
 };
 
 static const struct inode_operations xfs_symlink_inode_operations = {
-- 
1.7.6.5

