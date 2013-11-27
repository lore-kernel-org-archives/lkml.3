Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760846Ab3K0CEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:04:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756844Ab3K0A4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:56:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: [PATCH 3.4 16/39] Nest rename_lock inside vfsmount_lock
Date: Tue, 26 Nov 2013 16:56:40 -0800
Message-Id: <20131127005620.168457341@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005619.011763867@linuxfoundation.org>
References: <20131127005619.011763867@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: stable@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
[ zhj: backport to 3.4:
  - Adjust context
  - s/&vfsmount_lock/vfsmount_lock/]
Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/dcache.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2513,7 +2513,6 @@ static int prepend_path(const struct pat
 	bool slash = false;
 	int error = 0;
 
-	br_read_lock(vfsmount_lock);
 	while (dentry != root->dentry || vfsmnt != root->mnt) {
 		struct dentry * parent;
 
@@ -2543,8 +2542,6 @@ static int prepend_path(const struct pat
 	if (!error && !slash)
 		error = prepend(buffer, buflen, "/", 1);
 
-out:
-	br_read_unlock(vfsmount_lock);
 	return error;
 
 global_root:
@@ -2561,7 +2558,7 @@ global_root:
 		error = prepend(buffer, buflen, "/", 1);
 	if (!error)
 		error = real_mount(vfsmnt)->mnt_ns ? 1 : 2;
-	goto out;
+	return error;
 }
 
 /**
@@ -2588,9 +2585,11 @@ char *__d_path(const struct path *path,
 	int error;
 
 	prepend(&res, &buflen, "\0", 1);
+	br_read_lock(vfsmount_lock);
 	write_seqlock(&rename_lock);
 	error = prepend_path(path, root, &res, &buflen);
 	write_sequnlock(&rename_lock);
+	br_read_unlock(vfsmount_lock);
 
 	if (error < 0)
 		return ERR_PTR(error);
@@ -2607,9 +2606,11 @@ char *d_absolute_path(const struct path
 	int error;
 
 	prepend(&res, &buflen, "\0", 1);
+	br_read_lock(vfsmount_lock);
 	write_seqlock(&rename_lock);
 	error = prepend_path(path, &root, &res, &buflen);
 	write_sequnlock(&rename_lock);
+	br_read_unlock(vfsmount_lock);
 
 	if (error > 1)
 		error = -EINVAL;
@@ -2673,11 +2674,13 @@ char *d_path(const struct path *path, ch
 		return path->dentry->d_op->d_dname(path->dentry, buf, buflen);
 
 	get_fs_root(current->fs, &root);
+	br_read_lock(vfsmount_lock);
 	write_seqlock(&rename_lock);
 	error = path_with_deleted(path, &root, &res, &buflen);
+	write_sequnlock(&rename_lock);
+	br_read_unlock(vfsmount_lock);
 	if (error < 0)
 		res = ERR_PTR(error);
-	write_sequnlock(&rename_lock);
 	path_put(&root);
 	return res;
 }
@@ -2832,6 +2835,7 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 	get_fs_root_and_pwd(current->fs, &root, &pwd);
 
 	error = -ENOENT;
+	br_read_lock(vfsmount_lock);
 	write_seqlock(&rename_lock);
 	if (!d_unlinked(pwd.dentry)) {
 		unsigned long len;
@@ -2841,6 +2845,7 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 		prepend(&cwd, &buflen, "\0", 1);
 		error = prepend_path(&pwd, &root, &cwd, &buflen);
 		write_sequnlock(&rename_lock);
+		br_read_unlock(vfsmount_lock);
 
 		if (error < 0)
 			goto out;
@@ -2861,6 +2866,7 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 		}
 	} else {
 		write_sequnlock(&rename_lock);
+		br_read_unlock(vfsmount_lock);
 	}
 
 out:


