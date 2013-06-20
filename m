Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab3FTO6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:58:16 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35305 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757888Ab3FTO6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:58:14 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 1/3] evm: calculate HMAC after initializing posix acl on tmpfs
Date: Thu, 20 Jun 2013 10:56:25 -0400
Message-Id: <1371740187-11989-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062014-5806-0000-0000-000021CCE5D9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Included in the EVM hmac calculation is the i_mode.  Any changes to
the i_mode need to be reflected in the hmac.  shmem_mknod() currently
calls generic_acl_init(), which modifies the i_mode, after calling
security_inode_init_security().  This patch reverses the order in
which they are called.

Reported-by: Sven Vermeulen <sven.vermeulen@siphos.be>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Hugh Dickins <hughd@google.com>
---
 mm/shmem.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 5e6a842..a8e1072 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1939,6 +1939,13 @@ shmem_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t dev)
 
 	inode = shmem_get_inode(dir->i_sb, dir, mode, dev, VM_NORESERVE);
 	if (inode) {
+#ifdef CONFIG_TMPFS_POSIX_ACL
+		error = generic_acl_init(inode, dir);
+		if (error) {
+			iput(inode);
+			return error;
+		}
+#endif
 		error = security_inode_init_security(inode, dir,
 						     &dentry->d_name,
 						     shmem_initxattrs, NULL);
@@ -1948,15 +1955,8 @@ shmem_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t dev)
 				return error;
 			}
 		}
-#ifdef CONFIG_TMPFS_POSIX_ACL
-		error = generic_acl_init(inode, dir);
-		if (error) {
-			iput(inode);
-			return error;
-		}
-#else
+
 		error = 0;
-#endif
 		dir->i_size += BOGO_DIRENT_SIZE;
 		dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 		d_instantiate(dentry, inode);
-- 
1.8.1.4

