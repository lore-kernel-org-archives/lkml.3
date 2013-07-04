Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792Ab3GDBxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 21:53:32 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:2879 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933398Ab3GDBwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 21:52:53 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH 2/4] dcache: Use blocking reader seqlock when protected data are not changed
Date: Wed,  3 Jul 2013 21:52:16 -0400
Message-Id: <1372902738-30693-3-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1372902738-30693-1-git-send-email-Waiman.Long@hp.com>
References: <1372902738-30693-1-git-send-email-Waiman.Long@hp.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following functions in the fs/dcache.c file are changed to use
the blocking reader seqlock as none of the dentries are being changed
by those functions. This will allow other non-blocking readers to
proceed when the blocking readers have taken the lock.

1. __d_path
2. d_absolute_path
3. d_path
4. dentry_path_raw
5. dentry_path
6. getcwd syscall

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/dcache.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index f09b908..480c81f 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2603,9 +2603,9 @@ char *__d_path(const struct path *path,
 
 	prepend(&res, &buflen, "\0", 1);
 	br_read_lock(&vfsmount_lock);
-	write_seqlock(&rename_lock);
+	read_seqlock(&rename_lock);
 	error = prepend_path(path, root, &res, &buflen);
-	write_sequnlock(&rename_lock);
+	read_sequnlock(&rename_lock);
 	br_read_unlock(&vfsmount_lock);
 
 	if (error < 0)
@@ -2624,9 +2624,9 @@ char *d_absolute_path(const struct path *path,
 
 	prepend(&res, &buflen, "\0", 1);
 	br_read_lock(&vfsmount_lock);
-	write_seqlock(&rename_lock);
+	read_seqlock(&rename_lock);
 	error = prepend_path(path, &root, &res, &buflen);
-	write_sequnlock(&rename_lock);
+	read_sequnlock(&rename_lock);
 	br_read_unlock(&vfsmount_lock);
 
 	if (error > 1)
@@ -2692,9 +2692,9 @@ char *d_path(const struct path *path, char *buf, int buflen)
 
 	get_fs_root(current->fs, &root);
 	br_read_lock(&vfsmount_lock);
-	write_seqlock(&rename_lock);
+	read_seqlock(&rename_lock);
 	error = path_with_deleted(path, &root, &res, &buflen);
-	write_sequnlock(&rename_lock);
+	read_sequnlock(&rename_lock);
 	br_read_unlock(&vfsmount_lock);
 	if (error < 0)
 		res = ERR_PTR(error);
@@ -2762,9 +2762,9 @@ char *dentry_path_raw(struct dentry *dentry, char *buf, int buflen)
 {
 	char *retval;
 
-	write_seqlock(&rename_lock);
+	read_seqlock(&rename_lock);
 	retval = __dentry_path(dentry, buf, buflen);
-	write_sequnlock(&rename_lock);
+	read_sequnlock(&rename_lock);
 
 	return retval;
 }
@@ -2775,7 +2775,7 @@ char *dentry_path(struct dentry *dentry, char *buf, int buflen)
 	char *p = NULL;
 	char *retval;
 
-	write_seqlock(&rename_lock);
+	read_seqlock(&rename_lock);
 	if (d_unlinked(dentry)) {
 		p = buf + buflen;
 		if (prepend(&p, &buflen, "//deleted", 10) != 0)
@@ -2783,7 +2783,7 @@ char *dentry_path(struct dentry *dentry, char *buf, int buflen)
 		buflen++;
 	}
 	retval = __dentry_path(dentry, buf, buflen);
-	write_sequnlock(&rename_lock);
+	read_sequnlock(&rename_lock);
 	if (!IS_ERR(retval) && p)
 		*p = '/';	/* restore '/' overriden with '\0' */
 	return retval;
@@ -2822,7 +2822,7 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 
 	error = -ENOENT;
 	br_read_lock(&vfsmount_lock);
-	write_seqlock(&rename_lock);
+	read_seqlock(&rename_lock);
 	if (!d_unlinked(pwd.dentry)) {
 		unsigned long len;
 		char *cwd = page + PAGE_SIZE;
@@ -2830,7 +2830,7 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 
 		prepend(&cwd, &buflen, "\0", 1);
 		error = prepend_path(&pwd, &root, &cwd, &buflen);
-		write_sequnlock(&rename_lock);
+		read_sequnlock(&rename_lock);
 		br_read_unlock(&vfsmount_lock);
 
 		if (error < 0)
@@ -2851,7 +2851,7 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 				error = -EFAULT;
 		}
 	} else {
-		write_sequnlock(&rename_lock);
+		read_sequnlock(&rename_lock);
 		br_read_unlock(&vfsmount_lock);
 	}
 
-- 
1.7.1

