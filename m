Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbaJRPYX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 11:24:23 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:14896 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbaJRPYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 11:24:21 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
        Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 4/4] cifs: add set_flag callback
Date: Sat, 18 Oct 2014 19:21:28 +0400
Message-Id: <1413645688-13524-5-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413645688-13524-1-git-send-email-dmonakhov@openvz.org>
References: <1413645688-13524-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add set_flag callback which is called from fcntl(F_SETFL)
Share common logic for cifs_open and cifs_set_flags
I'm not cifs expert, but it is looks like toggling O_DIRECT on file is
unsafe operation so disable it temporally.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/cifs/cifsfs.c |    6 ++++++
 fs/cifs/cifsfs.h |    1 +
 fs/cifs/file.c   |   37 ++++++++++++++++++++++++++++++-------
 3 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 889b984..18ad412 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -918,6 +918,7 @@ const struct file_operations cifs_file_ops = {
 	.mmap  = cifs_file_mmap,
 	.splice_read = generic_file_splice_read,
 	.llseek = cifs_llseek,
+	.set_flags = cifs_set_flags,
 #ifdef CONFIG_CIFS_POSIX
 	.unlocked_ioctl	= cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
@@ -938,6 +939,7 @@ const struct file_operations cifs_file_strict_ops = {
 	.mmap = cifs_file_strict_mmap,
 	.splice_read = generic_file_splice_read,
 	.llseek = cifs_llseek,
+	.set_flags = cifs_set_flags,
 #ifdef CONFIG_CIFS_POSIX
 	.unlocked_ioctl	= cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
@@ -958,6 +960,7 @@ const struct file_operations cifs_file_direct_ops = {
 	.flush = cifs_flush,
 	.mmap = cifs_file_mmap,
 	.splice_read = generic_file_splice_read,
+	.set_flags = cifs_set_flags,
 #ifdef CONFIG_CIFS_POSIX
 	.unlocked_ioctl  = cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
@@ -978,6 +981,7 @@ const struct file_operations cifs_file_nobrl_ops = {
 	.mmap  = cifs_file_mmap,
 	.splice_read = generic_file_splice_read,
 	.llseek = cifs_llseek,
+	.set_flags = cifs_set_flags,
 #ifdef CONFIG_CIFS_POSIX
 	.unlocked_ioctl	= cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
@@ -997,6 +1001,7 @@ const struct file_operations cifs_file_strict_nobrl_ops = {
 	.mmap = cifs_file_strict_mmap,
 	.splice_read = generic_file_splice_read,
 	.llseek = cifs_llseek,
+	.set_flags = cifs_set_flags,
 #ifdef CONFIG_CIFS_POSIX
 	.unlocked_ioctl	= cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
@@ -1016,6 +1021,7 @@ const struct file_operations cifs_file_direct_nobrl_ops = {
 	.flush = cifs_flush,
 	.mmap = cifs_file_mmap,
 	.splice_read = generic_file_splice_read,
+	.set_flags = cifs_set_flags,
 #ifdef CONFIG_CIFS_POSIX
 	.unlocked_ioctl  = cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 002e0c1..353190d 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -92,6 +92,7 @@ extern const struct file_operations cifs_file_strict_ops; /* if strictio mnt */
 extern const struct file_operations cifs_file_nobrl_ops; /* no brlocks */
 extern const struct file_operations cifs_file_direct_nobrl_ops;
 extern const struct file_operations cifs_file_strict_nobrl_ops;
+extern int cifs_set_flags(struct file *filp, unsigned arg);
 extern int cifs_open(struct inode *inode, struct file *file);
 extern int cifs_close(struct inode *inode, struct file *file);
 extern int cifs_closedir(struct inode *inode, struct file *file);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index dc3c7e6..5167ecb 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -431,6 +431,33 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 	kfree(cifs_file);
 }
 
+int cifs_set_flags(struct file *file, unsigned arg)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
+	int rc = 0;
+
+	spin_lock(&file->f_lock);
+	if ((file->f_flags ^ arg) & O_DIRECT) {
+		/*
+		 * TODO: Toggling O_DIRECT is not obvious task,
+		 * temproraly disabled for safity reason
+		 */
+		rc = -EINVAL;
+		goto out;
+	}
+	file->f_flags = (arg & SETFL_MASK) | (file->f_flags & ~SETFL_MASK);
+	if (file->f_flags & O_DIRECT &&
+	    cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) {
+		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
+			file->f_op = &cifs_file_direct_nobrl_ops;
+		else
+			file->f_op = &cifs_file_direct_ops;
+	}
+out:
+	spin_unlock(&file->f_lock);
+	return rc;
+}
+
 int cifs_open(struct inode *inode, struct file *file)
 
 {
@@ -467,13 +494,9 @@ int cifs_open(struct inode *inode, struct file *file)
 	cifs_dbg(FYI, "inode = 0x%p file flags are 0x%x for %s\n",
 		 inode, file->f_flags, full_path);
 
-	if (file->f_flags & O_DIRECT &&
-	    cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) {
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
-			file->f_op = &cifs_file_direct_nobrl_ops;
-		else
-			file->f_op = &cifs_file_direct_ops;
-	}
+	rc = cifs_set_flags(file, file->f_flags);
+	if (rc)
+		goto out;
 
 	if (server->oplocks)
 		oplock = REQ_OPLOCK;
-- 
1.7.1

