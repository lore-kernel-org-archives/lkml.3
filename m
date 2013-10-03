Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab3JCGTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:19:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41558 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab3JCGTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:19:07 -0400
Date: Thu, 03 Oct 2013 07:19:06 +0100
To: torvalds@linux-foundation.org
Subject: [PATCH 10/17] namespace.c: get rid of mnt_ghosts
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VRcFe-0008BF-AT@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/mount.h     |    2 +-
 fs/namespace.c |   22 +++++++---------------
 fs/pnode.c     |    3 +--
 3 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/fs/mount.h b/fs/mount.h
index 64a8581..3168dc4 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -55,7 +55,7 @@ struct mount {
 	int mnt_group_id;		/* peer group identifier */
 	int mnt_expiry_mark;		/* true if marked for expiry */
 	int mnt_pinned;
-	int mnt_ghosts;
+	struct path mnt_ex_mountpoint;
 };
 
 #define MNT_NS_INTERNAL ERR_PTR(-EINVAL) /* distinct from any mnt_namespace */
diff --git a/fs/namespace.c b/fs/namespace.c
index 632c551..6985d52 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1136,20 +1136,8 @@ static void namespace_unlock(void)
 	while (!list_empty(&head)) {
 		mnt = list_first_entry(&head, struct mount, mnt_hash);
 		list_del_init(&mnt->mnt_hash);
-		if (mnt_has_parent(mnt)) {
-			struct dentry *dentry;
-			struct mount *m;
-
-			br_write_lock(&vfsmount_lock);
-			dentry = mnt->mnt_mountpoint;
-			m = mnt->mnt_parent;
-			mnt->mnt_mountpoint = mnt->mnt.mnt_root;
-			mnt->mnt_parent = mnt;
-			m->mnt_ghosts--;
-			br_write_unlock(&vfsmount_lock);
-			dput(dentry);
-			mntput(&m->mnt);
-		}
+		if (mnt->mnt_ex_mountpoint.mnt)
+			path_put(&mnt->mnt_ex_mountpoint);
 		mntput(&mnt->mnt);
 	}
 }
@@ -1181,8 +1169,12 @@ void umount_tree(struct mount *mnt, int propagate)
 		p->mnt_ns = NULL;
 		list_del_init(&p->mnt_child);
 		if (mnt_has_parent(p)) {
-			p->mnt_parent->mnt_ghosts++;
 			put_mountpoint(p->mnt_mp);
+			/* move the reference to mountpoint into ->mnt_ex_mountpoint */
+			p->mnt_ex_mountpoint.dentry = p->mnt_mountpoint;
+			p->mnt_ex_mountpoint.mnt = &p->mnt_parent->mnt;
+			p->mnt_mountpoint = p->mnt.mnt_root;
+			p->mnt_parent = p;
 			p->mnt_mp = NULL;
 		}
 		change_mnt_propagation(p, MS_PRIVATE);
diff --git a/fs/pnode.c b/fs/pnode.c
index 9af0df1..3cfd48c 100644
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -278,8 +278,7 @@ out:
  */
 static inline int do_refcount_check(struct mount *mnt, int count)
 {
-	int mycount = mnt_get_count(mnt) - mnt->mnt_ghosts;
-	return (mycount > count);
+	return mnt_get_count(mnt) > count;
 }
 
 /*
-- 
1.7.2.5


