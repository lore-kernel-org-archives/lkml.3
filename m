Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab3JYVvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 17:51:17 -0400
Received: from mail-qc0-f201.google.com ([209.85.216.201]:48425 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab3JYVvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 17:51:15 -0400
From: Aditya Kali <adityakali@google.com>
To: ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Aditya Kali <adityakali@google.com>
Subject: [PATCH] proc: Fix namespace mountpoint path in /proc/mounts
Date: Fri, 25 Oct 2013 14:51:10 -0700
Message-Id: <1382737870-12792-1-git-send-email-adityakali@google.com>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit bf056bfa80596a5d14b26b17276a56a0dcb080e5:
"proc: Fix the namespace inode permission checks." converted
the namespace files into symlinks. The same commit changed
the way namespace bind mounts appear in /proc/mounts:
  $ mount --bind /proc/self/ns/ipc /mnt/ipc
Originally:
  $ cat /proc/mounts | grep ipc
  proc /mnt/ipc proc rw,nosuid,nodev,noexec 0 0

After commit bf056bfa80596a5d14b26b17276a56a0dcb080e5:
  $ cat /proc/mounts | grep ipc
  proc ipc:[4026531839] proc rw,nosuid,nodev,noexec 0 0

This breaks userspace which expects the 2nd field in
/proc/mounts to be a valid path. This patch restores the
original format of namespace bind-mount entries in
/proc/mounts.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 fs/proc/namespaces.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index 49a7fff..d19989d 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -48,19 +48,9 @@ static int ns_delete_dentry(const struct dentry *dentry)
 	return 1;
 }
 
-static char *ns_dname(struct dentry *dentry, char *buffer, int buflen)
-{
-	struct inode *inode = dentry->d_inode;
-	const struct proc_ns_operations *ns_ops = PROC_I(inode)->ns.ns_ops;
-
-	return dynamic_dname(dentry, buffer, buflen, "%s:[%lu]",
-		ns_ops->name, inode->i_ino);
-}
-
 const struct dentry_operations ns_dentry_operations =
 {
 	.d_delete	= ns_delete_dentry,
-	.d_dname	= ns_dname,
 };
 
 static struct dentry *proc_ns_get_dentry(struct super_block *sb,
-- 
1.8.4.1

