Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab3JCGS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:18:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41556 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab3JCGS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:18:57 -0400
Date: Thu, 03 Oct 2013 07:18:56 +0100
To: torvalds@linux-foundation.org
Subject: [PATCH 09/17] fold dup_mnt_ns() into its only surviving caller
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VRcFU-0008AW-AF@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


should've been done 6 years ago...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namespace.c |   48 ++++++++++++++++++------------------------------
 1 files changed, 18 insertions(+), 30 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index d5cd086..632c551 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2397,20 +2397,25 @@ static struct mnt_namespace *alloc_mnt_ns(struct user_namespace *user_ns)
 	return new_ns;
 }
 
-/*
- * Allocate a new namespace structure and populate it with contents
- * copied from the namespace of the passed in task structure.
- */
-static struct mnt_namespace *dup_mnt_ns(struct mnt_namespace *mnt_ns,
-		struct user_namespace *user_ns, struct fs_struct *fs)
+struct mnt_namespace *copy_mnt_ns(unsigned long flags, struct mnt_namespace *ns,
+		struct user_namespace *user_ns, struct fs_struct *new_fs)
 {
 	struct mnt_namespace *new_ns;
 	struct vfsmount *rootmnt = NULL, *pwdmnt = NULL;
 	struct mount *p, *q;
-	struct mount *old = mnt_ns->root;
+	struct mount *old;
 	struct mount *new;
 	int copy_flags;
 
+	BUG_ON(!ns);
+
+	if (likely(!(flags & CLONE_NEWNS))) {
+		get_mnt_ns(ns);
+		return ns;
+	}
+
+	old = ns->root;
+
 	new_ns = alloc_mnt_ns(user_ns);
 	if (IS_ERR(new_ns))
 		return new_ns;
@@ -2418,7 +2423,7 @@ static struct mnt_namespace *dup_mnt_ns(struct mnt_namespace *mnt_ns,
 	namespace_lock();
 	/* First pass: copy the tree topology */
 	copy_flags = CL_COPY_UNBINDABLE | CL_EXPIRE;
-	if (user_ns != mnt_ns->user_ns)
+	if (user_ns != ns->user_ns)
 		copy_flags |= CL_SHARED_TO_SLAVE | CL_UNPRIVILEGED;
 	new = copy_tree(old, old->mnt.mnt_root, copy_flags);
 	if (IS_ERR(new)) {
@@ -2438,13 +2443,13 @@ static struct mnt_namespace *dup_mnt_ns(struct mnt_namespace *mnt_ns,
 	q = new;
 	while (p) {
 		q->mnt_ns = new_ns;
-		if (fs) {
-			if (&p->mnt == fs->root.mnt) {
-				fs->root.mnt = mntget(&q->mnt);
+		if (new_fs) {
+			if (&p->mnt == new_fs->root.mnt) {
+				new_fs->root.mnt = mntget(&q->mnt);
 				rootmnt = &p->mnt;
 			}
-			if (&p->mnt == fs->pwd.mnt) {
-				fs->pwd.mnt = mntget(&q->mnt);
+			if (&p->mnt == new_fs->pwd.mnt) {
+				new_fs->pwd.mnt = mntget(&q->mnt);
 				pwdmnt = &p->mnt;
 			}
 		}
@@ -2465,23 +2470,6 @@ static struct mnt_namespace *dup_mnt_ns(struct mnt_namespace *mnt_ns,
 	return new_ns;
 }
 
-struct mnt_namespace *copy_mnt_ns(unsigned long flags, struct mnt_namespace *ns,
-		struct user_namespace *user_ns, struct fs_struct *new_fs)
-{
-	struct mnt_namespace *new_ns;
-
-	BUG_ON(!ns);
-	get_mnt_ns(ns);
-
-	if (!(flags & CLONE_NEWNS))
-		return ns;
-
-	new_ns = dup_mnt_ns(ns, user_ns, new_fs);
-
-	put_mnt_ns(ns);
-	return new_ns;
-}
-
 /**
  * create_mnt_ns - creates a private namespace and adds a root filesystem
  * @mnt: pointer to the new root filesystem mountpoint
-- 
1.7.2.5


