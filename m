Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934906Ab3DGXb6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:31:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46798 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934776Ab3DGXbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:31:35 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Al Viro" <viro@zeniv.linux.org.uk>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.832741758@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [31/74] Nest rename_lock inside vfsmount_lock
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust context
 - s/&vfsmount_lock/vfsmount_lock/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/dcache.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2445,7 +2445,6 @@ static int prepend_path(const struct pat
 	bool slash = false;
 	int error = 0;
 
-	br_read_lock(vfsmount_lock);
 	while (dentry != root->dentry || vfsmnt != root->mnt) {
 		struct dentry * parent;
 
@@ -2475,8 +2474,6 @@ static int prepend_path(const struct pat
 	if (!error && !slash)
 		error = prepend(buffer, buflen, "/", 1);
 
-out:
-	br_read_unlock(vfsmount_lock);
 	return error;
 
 global_root:
@@ -2493,7 +2490,7 @@ global_root:
 		error = prepend(buffer, buflen, "/", 1);
 	if (!error)
 		error = vfsmnt->mnt_ns ? 1 : 2;
-	goto out;
+	return error;
 }
 
 /**
@@ -2520,9 +2517,11 @@ char *__d_path(const struct path *path,
 	int error;
 
 	prepend(&res, &buflen, "\0", 1);
+	br_read_lock(vfsmount_lock);
 	write_seqlock(&rename_lock);
 	error = prepend_path(path, root, &res, &buflen);
 	write_sequnlock(&rename_lock);
+	br_read_unlock(vfsmount_lock);
 
 	if (error < 0)
 		return ERR_PTR(error);
@@ -2539,9 +2538,11 @@ char *d_absolute_path(const struct path
 	int error;
 
 	prepend(&res, &buflen, "\0", 1);
+	br_read_lock(vfsmount_lock);
 	write_seqlock(&rename_lock);
 	error = prepend_path(path, &root, &res, &buflen);
 	write_sequnlock(&rename_lock);
+	br_read_unlock(vfsmount_lock);
 
 	if (error > 1)
 		error = -EINVAL;
@@ -2605,11 +2606,13 @@ char *d_path(const struct path *path, ch
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
@@ -2764,6 +2767,7 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 	get_fs_root_and_pwd(current->fs, &root, &pwd);
 
 	error = -ENOENT;
+	br_read_lock(vfsmount_lock);
 	write_seqlock(&rename_lock);
 	if (!d_unlinked(pwd.dentry)) {
 		unsigned long len;
@@ -2773,6 +2777,7 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 		prepend(&cwd, &buflen, "\0", 1);
 		error = prepend_path(&pwd, &root, &cwd, &buflen);
 		write_sequnlock(&rename_lock);
+		br_read_unlock(vfsmount_lock);
 
 		if (error < 0)
 			goto out;
@@ -2793,6 +2798,7 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 		}
 	} else {
 		write_sequnlock(&rename_lock);
+		br_read_unlock(vfsmount_lock);
 	}
 
 out:

