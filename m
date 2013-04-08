Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935497Ab3DHJv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:51:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42642 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935436Ab3DHJvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:18 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 013/102] Nest rename_lock inside vfsmount_lock
Date: Mon,  8 Apr 2013 10:49:28 +0100
Message-Id: <1365414657-29191-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 7ea600b5314529f9d1b9d6d3c41cb26fce6a7a4a upstream.

... lest we get livelocks between path_is_under() and d_path() and friends.

The thing is, wrt fairness lglocks are more similar to rwsems than to rwlocks;
it is possible to have thread B spin on attempt to take lock shared while thread
A is already holding it shared, if B is on lower-numbered CPU than A and there's
a thread C spinning on attempt to take the same lock exclusive.

As the result, we need consistent ordering between vfsmount_lock (lglock) and
rename_lock (seq_lock), even though everything that takes both is going to take
vfsmount_lock only shared.

Spotted-by: Brad Spengler <spender@grsecurity.net>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/dcache.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 1845c46..458ec45 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2579,7 +2579,6 @@ static int prepend_path(const struct path *path,
 	bool slash = false;
 	int error = 0;
 
-	br_read_lock(&vfsmount_lock);
 	while (dentry != root->dentry || vfsmnt != root->mnt) {
 		struct dentry * parent;
 
@@ -2609,8 +2608,6 @@ static int prepend_path(const struct path *path,
 	if (!error && !slash)
 		error = prepend(buffer, buflen, "/", 1);
 
-out:
-	br_read_unlock(&vfsmount_lock);
 	return error;
 
 global_root:
@@ -2627,7 +2624,7 @@ global_root:
 		error = prepend(buffer, buflen, "/", 1);
 	if (!error)
 		error = real_mount(vfsmnt)->mnt_ns ? 1 : 2;
-	goto out;
+	return error;
 }
 
 /**
@@ -2654,9 +2651,11 @@ char *__d_path(const struct path *path,
 	int error;
 
 	prepend(&res, &buflen, "\0", 1);
+	br_read_lock(&vfsmount_lock);
 	write_seqlock(&rename_lock);
 	error = prepend_path(path, root, &res, &buflen);
 	write_sequnlock(&rename_lock);
+	br_read_unlock(&vfsmount_lock);
 
 	if (error < 0)
 		return ERR_PTR(error);
@@ -2673,9 +2672,11 @@ char *d_absolute_path(const struct path *path,
 	int error;
 
 	prepend(&res, &buflen, "\0", 1);
+	br_read_lock(&vfsmount_lock);
 	write_seqlock(&rename_lock);
 	error = prepend_path(path, &root, &res, &buflen);
 	write_sequnlock(&rename_lock);
+	br_read_unlock(&vfsmount_lock);
 
 	if (error > 1)
 		error = -EINVAL;
@@ -2739,11 +2740,13 @@ char *d_path(const struct path *path, char *buf, int buflen)
 		return path->dentry->d_op->d_dname(path->dentry, buf, buflen);
 
 	get_fs_root(current->fs, &root);
+	br_read_lock(&vfsmount_lock);
 	write_seqlock(&rename_lock);
 	error = path_with_deleted(path, &root, &res, &buflen);
+	write_sequnlock(&rename_lock);
+	br_read_unlock(&vfsmount_lock);
 	if (error < 0)
 		res = ERR_PTR(error);
-	write_sequnlock(&rename_lock);
 	path_put(&root);
 	return res;
 }
@@ -2898,6 +2901,7 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 	get_fs_root_and_pwd(current->fs, &root, &pwd);
 
 	error = -ENOENT;
+	br_read_lock(&vfsmount_lock);
 	write_seqlock(&rename_lock);
 	if (!d_unlinked(pwd.dentry)) {
 		unsigned long len;
@@ -2907,6 +2911,7 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 		prepend(&cwd, &buflen, "\0", 1);
 		error = prepend_path(&pwd, &root, &cwd, &buflen);
 		write_sequnlock(&rename_lock);
+		br_read_unlock(&vfsmount_lock);
 
 		if (error < 0)
 			goto out;
@@ -2927,6 +2932,7 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 		}
 	} else {
 		write_sequnlock(&rename_lock);
+		br_read_unlock(&vfsmount_lock);
 	}
 
 out:
-- 
1.8.1.2

