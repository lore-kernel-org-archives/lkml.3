Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763479AbbA2C7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:59:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47012 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965351AbbA2Chu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:37:50 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tyler Hicks <tyhicks@canonical.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 019/139] eCryptfs: Force RO mount when encrypted view is enabled
Date: Wed, 28 Jan 2015 14:19:22 -0800
Message-Id: <1422483682-15393-20-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@canonical.com>

commit 332b122d39c9cbff8b799007a825d94b2e7c12f2 upstream.

The ecryptfs_encrypted_view mount option greatly changes the
functionality of an eCryptfs mount. Instead of encrypting and decrypting
lower files, it provides a unified view of the encrypted files in the
lower filesystem. The presence of the ecryptfs_encrypted_view mount
option is intended to force a read-only mount and modifying files is not
supported when the feature is in use. See the following commit for more
information:

  e77a56d [PATCH] eCryptfs: Encrypted passthrough

This patch forces the mount to be read-only when the
ecryptfs_encrypted_view mount option is specified by setting the
MS_RDONLY flag on the superblock. Additionally, this patch removes some
broken logic in ecryptfs_open() that attempted to prevent modifications
of files when the encrypted view feature was in use. The check in
ecryptfs_open() was not sufficient to prevent file modifications using
system calls that do not operate on a file descriptor.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Reported-by: Priya Bansal <p.bansal@samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ecryptfs/file.c | 12 ------------
 fs/ecryptfs/main.c | 16 +++++++++++++---
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index b1eaa7a..03df502 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -191,23 +191,11 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 {
 	int rc = 0;
 	struct ecryptfs_crypt_stat *crypt_stat = NULL;
-	struct ecryptfs_mount_crypt_stat *mount_crypt_stat;
 	struct dentry *ecryptfs_dentry = file->f_path.dentry;
 	/* Private value of ecryptfs_dentry allocated in
 	 * ecryptfs_lookup() */
 	struct ecryptfs_file_info *file_info;
 
-	mount_crypt_stat = &ecryptfs_superblock_to_private(
-		ecryptfs_dentry->d_sb)->mount_crypt_stat;
-	if ((mount_crypt_stat->flags & ECRYPTFS_ENCRYPTED_VIEW_ENABLED)
-	    && ((file->f_flags & O_WRONLY) || (file->f_flags & O_RDWR)
-		|| (file->f_flags & O_CREAT) || (file->f_flags & O_TRUNC)
-		|| (file->f_flags & O_APPEND))) {
-		printk(KERN_WARNING "Mount has encrypted view enabled; "
-		       "files may only be read\n");
-		rc = -EPERM;
-		goto out;
-	}
 	/* Released in ecryptfs_release or end of function if failure */
 	file_info = kmem_cache_zalloc(ecryptfs_file_info_cache, GFP_KERNEL);
 	ecryptfs_set_file_private(file, file_info);
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 1b119d3..34eb843 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -493,6 +493,7 @@ static struct dentry *ecryptfs_mount(struct file_system_type *fs_type, int flags
 {
 	struct super_block *s;
 	struct ecryptfs_sb_info *sbi;
+	struct ecryptfs_mount_crypt_stat *mount_crypt_stat;
 	struct ecryptfs_dentry_info *root_info;
 	const char *err = "Getting sb failed";
 	struct inode *inode;
@@ -511,6 +512,7 @@ static struct dentry *ecryptfs_mount(struct file_system_type *fs_type, int flags
 		err = "Error parsing options";
 		goto out;
 	}
+	mount_crypt_stat = &sbi->mount_crypt_stat;
 
 	s = sget(fs_type, NULL, set_anon_super, flags, NULL);
 	if (IS_ERR(s)) {
@@ -557,11 +559,19 @@ static struct dentry *ecryptfs_mount(struct file_system_type *fs_type, int flags
 
 	/**
 	 * Set the POSIX ACL flag based on whether they're enabled in the lower
-	 * mount. Force a read-only eCryptfs mount if the lower mount is ro.
-	 * Allow a ro eCryptfs mount even when the lower mount is rw.
+	 * mount.
 	 */
 	s->s_flags = flags & ~MS_POSIXACL;
-	s->s_flags |= path.dentry->d_sb->s_flags & (MS_RDONLY | MS_POSIXACL);
+	s->s_flags |= path.dentry->d_sb->s_flags & MS_POSIXACL;
+
+	/**
+	 * Force a read-only eCryptfs mount when:
+	 *   1) The lower mount is ro
+	 *   2) The ecryptfs_encrypted_view mount option is specified
+	 */
+	if (path.dentry->d_sb->s_flags & MS_RDONLY ||
+	    mount_crypt_stat->flags & ECRYPTFS_ENCRYPTED_VIEW_ENABLED)
+		s->s_flags |= MS_RDONLY;
 
 	s->s_maxbytes = path.dentry->d_sb->s_maxbytes;
 	s->s_blocksize = path.dentry->d_sb->s_blocksize;
-- 
1.9.1

