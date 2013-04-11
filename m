Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936461Ab3DKVGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:06:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20734 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935710Ab3DKUtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:14 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=9iYy0BBEhSEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=vrmkKAql9u0A:10 a=drOt6m5kAAAA:8 a=XxtmG6sFAAAA:8 a=VwQbUJbxAAAA:8 a=0u0nhMPvhaUjrep2UKUA:9 a=NuBSTLBdITsA:10 a=jeBq3FmKZ4MA:10 a=7v2BBwS4cPHt6BXJ:21 a=8yrlGwXHrq0a3pJ_:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202603.702393237@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 106/171 ] Nest rename_lock inside vfsmount_lock
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0106-Nest-rename_lock-inside-vfsmount_lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 7ea600b5314529f9d1b9d6d3c41cb26fce6a7a4a ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/dcache.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 693f95b..2488c47 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2583,7 +2583,6 @@ static int prepend_path(const struct path *path,
 	bool slash = false;
 	int error = 0;
 
-	br_read_lock(&vfsmount_lock);
 	while (dentry != root->dentry || vfsmnt != root->mnt) {
 		struct dentry * parent;
 
@@ -2613,8 +2612,6 @@ static int prepend_path(const struct path *path,
 	if (!error && !slash)
 		error = prepend(buffer, buflen, "/", 1);
 
-out:
-	br_read_unlock(&vfsmount_lock);
 	return error;
 
 global_root:
@@ -2631,7 +2628,7 @@ global_root:
 		error = prepend(buffer, buflen, "/", 1);
 	if (!error)
 		error = is_mounted(vfsmnt) ? 1 : 2;
-	goto out;
+	return error;
 }
 
 /**
@@ -2658,9 +2655,11 @@ char *__d_path(const struct path *path,
 	int error;
 
 	prepend(&res, &buflen, "\0", 1);
+	br_read_lock(&vfsmount_lock);
 	write_seqlock(&rename_lock);
 	error = prepend_path(path, root, &res, &buflen);
 	write_sequnlock(&rename_lock);
+	br_read_unlock(&vfsmount_lock);
 
 	if (error < 0)
 		return ERR_PTR(error);
@@ -2677,9 +2676,11 @@ char *d_absolute_path(const struct path *path,
 	int error;
 
 	prepend(&res, &buflen, "\0", 1);
+	br_read_lock(&vfsmount_lock);
 	write_seqlock(&rename_lock);
 	error = prepend_path(path, &root, &res, &buflen);
 	write_sequnlock(&rename_lock);
+	br_read_unlock(&vfsmount_lock);
 
 	if (error > 1)
 		error = -EINVAL;
@@ -2743,11 +2744,13 @@ char *d_path(const struct path *path, char *buf, int buflen)
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
@@ -2902,6 +2905,7 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 	get_fs_root_and_pwd(current->fs, &root, &pwd);
 
 	error = -ENOENT;
+	br_read_lock(&vfsmount_lock);
 	write_seqlock(&rename_lock);
 	if (!d_unlinked(pwd.dentry)) {
 		unsigned long len;
@@ -2911,6 +2915,7 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 		prepend(&cwd, &buflen, "\0", 1);
 		error = prepend_path(&pwd, &root, &cwd, &buflen);
 		write_sequnlock(&rename_lock);
+		br_read_unlock(&vfsmount_lock);
 
 		if (error < 0)
 			goto out;
@@ -2931,6 +2936,7 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 		}
 	} else {
 		write_sequnlock(&rename_lock);
+		br_read_unlock(&vfsmount_lock);
 	}
 
 out:
-- 
1.7.10.4


