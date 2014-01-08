Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbaAHWKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:10:07 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:42278 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270AbaAHWJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:09:50 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, zab@redhat.com,
        jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: [PATCH 05/11] vfs: add RENAME_NOREPLACE flag
Date: Wed,  8 Jan 2014 23:10:09 +0100
Message-Id: <1389219015-10980-6-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

If this flag is specified and the target of the rename exists then the
rename syscall fails with EEXIST.

The VFS does the existence checking, so it is trivial to enable for most
local filesystems.  This patch only enables it in ext4.

For network filesystems the VFS check is not enough as there may be a race
between a remote create and the rename, so these filesystems need to handle
this flag in their ->rename() implementations to ensure atomicity.

Suggested-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ext4/namei.c         |  2 +-
 fs/namei.c              | 21 +++++++++++++--------
 include/uapi/linux/fs.h |  2 ++
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 08c40f4e7eed..e0129b6e74cf 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3021,7 +3021,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	int inlined = 0, new_inlined = 0;
 	struct ext4_dir_entry_2 *parent_de;
 
-	if (flags)
+	if (flags & ~RENAME_NOREPLACE)
 		return -EOPNOTSUPP;
 
 	dquot_initialize(old_dir);
diff --git a/fs/namei.c b/fs/namei.c
index 593673fcbfef..f9cf3020394c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4123,7 +4123,7 @@ SYSCALL_DEFINE5(renameat2, int, olddfd, const char __user *, oldname,
 	bool should_retry = false;
 	int error;
 
-	if (flags)
+	if (flags & ~RENAME_NOREPLACE)
 		return -EOPNOTSUPP;
 
 retry:
@@ -4149,6 +4149,8 @@ retry:
 		goto exit2;
 
 	new_dir = newnd.path.dentry;
+	if (flags & RENAME_NOREPLACE)
+		error = -EEXIST;
 	if (newnd.last_type != LAST_NORM)
 		goto exit2;
 
@@ -4171,22 +4173,25 @@ retry_deleg:
 	error = -ENOENT;
 	if (d_is_negative(old_dentry))
 		goto exit4;
+	new_dentry = lookup_hash(&newnd);
+	error = PTR_ERR(new_dentry);
+	if (IS_ERR(new_dentry))
+		goto exit4;
+	error = -EEXIST;
+	if ((flags & RENAME_NOREPLACE) && d_is_positive(new_dentry))
+		goto exit5;
 	/* unless the source is a directory trailing slashes give -ENOTDIR */
 	if (!d_is_dir(old_dentry)) {
 		error = -ENOTDIR;
 		if (oldnd.last.name[oldnd.last.len])
-			goto exit4;
+			goto exit5;
 		if (newnd.last.name[newnd.last.len])
-			goto exit4;
+			goto exit5;
 	}
 	/* source should not be ancestor of target */
 	error = -EINVAL;
 	if (old_dentry == trap)
-		goto exit4;
-	new_dentry = lookup_hash(&newnd);
-	error = PTR_ERR(new_dentry);
-	if (IS_ERR(new_dentry))
-		goto exit4;
+		goto exit5;
 	/* target should not be an ancestor of source */
 	error = -ENOTEMPTY;
 	if (new_dentry == trap)
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 6c28b61bb690..9250f4dd7d96 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -35,6 +35,8 @@
 #define SEEK_HOLE	4	/* seek to the next hole */
 #define SEEK_MAX	SEEK_HOLE
 
+#define RENAME_NOREPLACE	(1 << 0)	/* Don't overwrite target */
+
 struct fstrim_range {
 	__u64 start;
 	__u64 len;
-- 
1.8.1.4

