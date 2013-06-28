Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab3F1TUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:20:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41560 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3F1Sw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:52:28 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Mahoney <jeffm@suse.com>, Jan Kara <jack@suse.cz>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 020/105] reiserfs: fix problems with chowning setuid file w/ xattrs
Date: Fri, 28 Jun 2013 11:50:42 -0700
Message-Id: <1372445527-24414-21-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Mahoney <jeffm@suse.com>

commit 4a8570112b76a63ad21cfcbe2783f98f7fd5ba1b upstream.

reiserfs_chown_xattrs() takes the iattr struct passed into ->setattr
and uses it to iterate over all the attrs associated with a file to change
ownership of xattrs (and transfer quota associated with the xattr files).

When the setuid bit is cleared during chown, ATTR_MODE and iattr->ia_mode
are passed to all the xattrs as well. This means that the xattr directory
will have S_IFREG added to its mode bits.

This has been prevented in practice by a missing IS_PRIVATE check
in reiserfs_acl_chmod, which caused a double-lock to occur while holding
the write lock. Since the file system was completely locked up, the
writeout of the corrupted mode never happened.

This patch temporarily clears everything but ATTR_UID|ATTR_GID for the
calls to reiserfs_setattr and adds the missing IS_PRIVATE check.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/reiserfs/xattr.c     | 14 +++++++++++++-
 fs/reiserfs/xattr_acl.c |  3 +++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 4cce1d9..821bcf7 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -318,7 +318,19 @@ static int delete_one_xattr(struct dentry *dentry, void *data)
 static int chown_one_xattr(struct dentry *dentry, void *data)
 {
 	struct iattr *attrs = data;
-	return reiserfs_setattr(dentry, attrs);
+	int ia_valid = attrs->ia_valid;
+	int err;
+
+	/*
+	 * We only want the ownership bits. Otherwise, we'll do
+	 * things like change a directory to a regular file if
+	 * ATTR_MODE is set.
+	 */
+	attrs->ia_valid &= (ATTR_UID|ATTR_GID);
+	err = reiserfs_setattr(dentry, attrs);
+	attrs->ia_valid = ia_valid;
+
+	return err;
 }
 
 /* No i_mutex, but the inode is unconnected. */
diff --git a/fs/reiserfs/xattr_acl.c b/fs/reiserfs/xattr_acl.c
index d7c01ef..6c8767f 100644
--- a/fs/reiserfs/xattr_acl.c
+++ b/fs/reiserfs/xattr_acl.c
@@ -443,6 +443,9 @@ int reiserfs_acl_chmod(struct inode *inode)
 	int depth;
 	int error;
 
+	if (IS_PRIVATE(inode))
+		return 0;
+
 	if (S_ISLNK(inode->i_mode))
 		return -EOPNOTSUPP;
 
-- 
1.8.1.2

