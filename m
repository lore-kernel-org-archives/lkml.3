Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab3JCGUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:20:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41570 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab3JCGUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:20:07 -0400
Date: Thu, 03 Oct 2013 07:20:06 +0100
To: torvalds@linux-foundation.org
Subject: [PATCH 16/17] move taking vfsmount_lock down into prepend_path()
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VRcGc-0008EZ-Dj@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/dcache.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 4100030..d888223 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2889,6 +2889,7 @@ static int prepend_path(const struct path *path,
 	char *bptr;
 	int blen;
 
+	br_read_lock(&vfsmount_lock);
 	rcu_read_lock();
 restart:
 	bptr = *buffer;
@@ -2935,6 +2936,7 @@ restart:
 		goto restart;
 	}
 	done_seqretry(&rename_lock, seq);
+	br_read_unlock(&vfsmount_lock);
 
 	if (error >= 0 && bptr == *buffer) {
 		if (--blen < 0)
@@ -2971,9 +2973,7 @@ char *__d_path(const struct path *path,
 	int error;
 
 	prepend(&res, &buflen, "\0", 1);
-	br_read_lock(&vfsmount_lock);
 	error = prepend_path(path, root, &res, &buflen);
-	br_read_unlock(&vfsmount_lock);
 
 	if (error < 0)
 		return ERR_PTR(error);
@@ -2990,9 +2990,7 @@ char *d_absolute_path(const struct path *path,
 	int error;
 
 	prepend(&res, &buflen, "\0", 1);
-	br_read_lock(&vfsmount_lock);
 	error = prepend_path(path, &root, &res, &buflen);
-	br_read_unlock(&vfsmount_lock);
 
 	if (error > 1)
 		error = -EINVAL;
@@ -3067,9 +3065,7 @@ char *d_path(const struct path *path, char *buf, int buflen)
 
 	rcu_read_lock();
 	get_fs_root_rcu(current->fs, &root);
-	br_read_lock(&vfsmount_lock);
 	error = path_with_deleted(path, &root, &res, &buflen);
-	br_read_unlock(&vfsmount_lock);
 	rcu_read_unlock();
 
 	if (error < 0)
@@ -3224,7 +3220,6 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 	get_fs_root_and_pwd_rcu(current->fs, &root, &pwd);
 
 	error = -ENOENT;
-	br_read_lock(&vfsmount_lock);
 	if (!d_unlinked(pwd.dentry)) {
 		unsigned long len;
 		char *cwd = page + PATH_MAX;
@@ -3232,7 +3227,6 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 
 		prepend(&cwd, &buflen, "\0", 1);
 		error = prepend_path(&pwd, &root, &cwd, &buflen);
-		br_read_unlock(&vfsmount_lock);
 		rcu_read_unlock();
 
 		if (error < 0)
@@ -3253,7 +3247,6 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 				error = -EFAULT;
 		}
 	} else {
-		br_read_unlock(&vfsmount_lock);
 		rcu_read_unlock();
 	}
 
-- 
1.7.2.5


