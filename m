Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab3JCGT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:19:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41568 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab3JCGT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:19:57 -0400
Date: Thu, 03 Oct 2013 07:19:56 +0100
To: torvalds@linux-foundation.org
Subject: [PATCH 15/17] split __lookup_mnt() in two functions
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VRcGS-0008Dw-Da@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Instead of passing the direction as argument (and checking it on every
step through the hash chain), just have separate __lookup_mnt() and
__lookup_mnt_last().  And use the standard iterators...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/mount.h     |    3 ++-
 fs/namei.c     |    4 ++--
 fs/namespace.c |   44 ++++++++++++++++++++++++--------------------
 fs/pnode.c     |    6 +++---
 4 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/fs/mount.h b/fs/mount.h
index 7076f25..f086607 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -77,7 +77,8 @@ static inline int is_mounted(struct vfsmount *mnt)
 	return !IS_ERR_OR_NULL(real_mount(mnt));
 }
 
-extern struct mount *__lookup_mnt(struct vfsmount *, struct dentry *, int);
+extern struct mount *__lookup_mnt(struct vfsmount *, struct dentry *);
+extern struct mount *__lookup_mnt_last(struct vfsmount *, struct dentry *);
 
 static inline void get_mnt_ns(struct mnt_namespace *ns)
 {
diff --git a/fs/namei.c b/fs/namei.c
index 645268f..1f844fb 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1111,7 +1111,7 @@ static bool __follow_mount_rcu(struct nameidata *nd, struct path *path,
 		if (!d_mountpoint(path->dentry))
 			break;
 
-		mounted = __lookup_mnt(path->mnt, path->dentry, 1);
+		mounted = __lookup_mnt(path->mnt, path->dentry);
 		if (!mounted)
 			break;
 		path->mnt = &mounted->mnt;
@@ -1132,7 +1132,7 @@ static void follow_mount_rcu(struct nameidata *nd)
 {
 	while (d_mountpoint(nd->path.dentry)) {
 		struct mount *mounted;
-		mounted = __lookup_mnt(nd->path.mnt, nd->path.dentry, 1);
+		mounted = __lookup_mnt(nd->path.mnt, nd->path.dentry);
 		if (!mounted)
 			break;
 		nd->path.mnt = &mounted->mnt;
diff --git a/fs/namespace.c b/fs/namespace.c
index aa6dd93..8ae16b9f 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -548,29 +548,33 @@ static void free_vfsmnt(struct mount *mnt)
 }
 
 /*
- * find the first or last mount at @dentry on vfsmount @mnt depending on
- * @dir. If @dir is set return the first mount else return the last mount.
+ * find the first mount at @dentry on vfsmount @mnt.
  * vfsmount_lock must be held for read or write.
  */
-struct mount *__lookup_mnt(struct vfsmount *mnt, struct dentry *dentry,
-			      int dir)
+struct mount *__lookup_mnt(struct vfsmount *mnt, struct dentry *dentry)
 {
 	struct list_head *head = mount_hashtable + hash(mnt, dentry);
-	struct list_head *tmp = head;
-	struct mount *p, *found = NULL;
+	struct mount *p;
 
-	for (;;) {
-		tmp = dir ? tmp->next : tmp->prev;
-		p = NULL;
-		if (tmp == head)
-			break;
-		p = list_entry(tmp, struct mount, mnt_hash);
-		if (&p->mnt_parent->mnt == mnt && p->mnt_mountpoint == dentry) {
-			found = p;
-			break;
-		}
-	}
-	return found;
+	list_for_each_entry(p, head, mnt_hash)
+		if (&p->mnt_parent->mnt == mnt && p->mnt_mountpoint == dentry)
+			return p;
+	return NULL;
+}
+
+/*
+ * find the last mount at @dentry on vfsmount @mnt.
+ * vfsmount_lock must be held for read or write.
+ */
+struct mount *__lookup_mnt_last(struct vfsmount *mnt, struct dentry *dentry)
+{
+	struct list_head *head = mount_hashtable + hash(mnt, dentry);
+	struct mount *p;
+
+	list_for_each_entry_reverse(p, head, mnt_hash)
+		if (&p->mnt_parent->mnt == mnt && p->mnt_mountpoint == dentry)
+			return p;
+	return NULL;
 }
 
 /*
@@ -594,7 +598,7 @@ struct vfsmount *lookup_mnt(struct path *path)
 	struct mount *child_mnt;
 
 	br_read_lock(&vfsmount_lock);
-	child_mnt = __lookup_mnt(path->mnt, path->dentry, 1);
+	child_mnt = __lookup_mnt(path->mnt, path->dentry);
 	if (child_mnt) {
 		mnt_add_count(child_mnt, 1);
 		br_read_unlock(&vfsmount_lock);
diff --git a/fs/pnode.c b/fs/pnode.c
index 58933fd..c7221bb 100644
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -310,7 +310,7 @@ int propagate_mount_busy(struct mount *mnt, int refcnt)
 
 	for (m = propagation_next(parent, parent); m;
 	     		m = propagation_next(m, parent)) {
-		child = __lookup_mnt(&m->mnt, mnt->mnt_mountpoint, 0);
+		child = __lookup_mnt_last(&m->mnt, mnt->mnt_mountpoint);
 		if (child && list_empty(&child->mnt_mounts) &&
 		    (ret = do_refcount_check(child, 1)))
 			break;
@@ -332,8 +332,8 @@ static void __propagate_umount(struct mount *mnt)
 	for (m = propagation_next(parent, parent); m;
 			m = propagation_next(m, parent)) {
 
-		struct mount *child = __lookup_mnt(&m->mnt,
-					mnt->mnt_mountpoint, 0);
+		struct mount *child = __lookup_mnt_last(&m->mnt,
+						mnt->mnt_mountpoint);
 		/*
 		 * umount the child only if the child has no
 		 * other children
-- 
1.7.2.5


