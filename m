Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbaBEUXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:23:24 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48523 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223AbaBEUHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:33 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Roberto Sassu <roberto.sassu@polito.it>,
        Dustin Kirkland <kirkland@canonical.com>,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 167/213] ecryptfs: call vfs_setxattr() in ecryptfs_setxattr()
Date: Wed, 5 Feb 2014 15:02:02 -0500
Message-ID: <1391630568-49251-168-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roberto Sassu <roberto.sassu@polito.it>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 48b512e6857139393cdfce26348c362b87537018 upstream.

Ecryptfs is a stackable filesystem which relies on lower filesystems the
ability of setting/getting extended attributes.

If there is a security module enabled on the system it updates the
'security' field of inodes according to the owned extended attribute set
with the function vfs_setxattr().  When this function is performed on a
ecryptfs filesystem the 'security' field is not updated for the lower
filesystem since the call security_inode_post_setxattr() is missing for
the lower inode.
Further, the call security_inode_setxattr() is missing for the lower inode,
leading to policy violations in the security module because specific
checks for this hook are not performed (i. e. filesystem
'associate' permission on SELinux is not checked for the lower filesystem).

This patch replaces the call of the setxattr() method of the lower inode
in the function ecryptfs_setxattr() with vfs_setxattr().

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Cc: Dustin Kirkland <kirkland@canonical.com>
Acked-by: James Morris <jmorris@namei.org>
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ecryptfs/inode.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index b39e46f020a7..168706e90e3f 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -32,6 +32,7 @@
 #include <linux/crypto.h>
 #include <linux/fs_stack.h>
 #include <linux/slab.h>
+#include <linux/xattr.h>
 #include <asm/unaligned.h>
 #include "ecryptfs_kernel.h"
 
@@ -1054,10 +1055,8 @@ ecryptfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		rc = -EOPNOTSUPP;
 		goto out;
 	}
-	mutex_lock(&lower_dentry->d_inode->i_mutex);
-	rc = lower_dentry->d_inode->i_op->setxattr(lower_dentry, name, value,
-						   size, flags);
-	mutex_unlock(&lower_dentry->d_inode->i_mutex);
+
+	rc = vfs_setxattr(lower_dentry, name, value, size, flags);
 out:
 	return rc;
 }
-- 
1.8.5.2

