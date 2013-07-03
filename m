Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271Ab3GCUY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:24:28 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:21952 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932764Ab3GCUYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:24:25 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Eric Paris <eparis@redhat.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v3 21/25] fsnotify: Change how dentry's d_lock field is accessed
Date: Wed,  3 Jul 2013 16:24:08 -0400
Message-Id: <1372883048-23344-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of the changes made in dcache.h header file, files that
use the d_lock field of the dentry structure need to be changed
accordingly. All the d_lock's spin_lock() and spin_unlock() calls
are replaced by the corresponding d_lock() and d_unlock() calls.
There is no change in logic and everything should just work.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/notify/fsnotify.c             |    8 ++++----
 fs/notify/vfsmount_mark.c        |   24 ++++++++++++------------
 include/linux/fsnotify_backend.h |    6 +++---
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 4bb21d6..01b96a8 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -69,19 +69,19 @@ void __fsnotify_update_child_dentry_flags(struct inode *inode)
 		/* run all of the children of the original inode and fix their
 		 * d_flags to indicate parental interest (their parent is the
 		 * original inode) */
-		spin_lock(&alias->d_lock);
+		d_lock(alias);
 		list_for_each_entry(child, &alias->d_subdirs, d_u.d_child) {
 			if (!child->d_inode)
 				continue;
 
-			spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
+			d_lock_nested(child, DENTRY_D_LOCK_NESTED);
 			if (watched)
 				child->d_flags |= DCACHE_FSNOTIFY_PARENT_WATCHED;
 			else
 				child->d_flags &= ~DCACHE_FSNOTIFY_PARENT_WATCHED;
-			spin_unlock(&child->d_lock);
+			d_unlock(child);
 		}
-		spin_unlock(&alias->d_lock);
+		d_unlock(alias);
 	}
 	spin_unlock(&inode->i_lock);
 }
diff --git a/fs/notify/vfsmount_mark.c b/fs/notify/vfsmount_mark.c
index 68ca5a8..00dbdbf 100644
--- a/fs/notify/vfsmount_mark.c
+++ b/fs/notify/vfsmount_mark.c
@@ -37,13 +37,13 @@ void fsnotify_clear_marks_by_mount(struct vfsmount *mnt)
 	struct mount *m = real_mount(mnt);
 	LIST_HEAD(free_list);
 
-	spin_lock(&mnt->mnt_root->d_lock);
+	d_lock(mnt->mnt_root);
 	hlist_for_each_entry_safe(mark, n, &m->mnt_fsnotify_marks, m.m_list) {
 		list_add(&mark->m.free_m_list, &free_list);
 		hlist_del_init_rcu(&mark->m.m_list);
 		fsnotify_get_mark(mark);
 	}
-	spin_unlock(&mnt->mnt_root->d_lock);
+	d_unlock(mnt->mnt_root);
 
 	list_for_each_entry_safe(mark, lmark, &free_list, m.free_m_list) {
 		struct fsnotify_group *group;
@@ -73,7 +73,7 @@ static void fsnotify_recalc_vfsmount_mask_locked(struct vfsmount *mnt)
 	struct fsnotify_mark *mark;
 	__u32 new_mask = 0;
 
-	assert_spin_locked(&mnt->mnt_root->d_lock);
+	assert_spin_locked(&d_ret_lock(mnt->mnt_root));
 
 	hlist_for_each_entry(mark, &m->mnt_fsnotify_marks, m.m_list)
 		new_mask |= mark->mask;
@@ -86,9 +86,9 @@ static void fsnotify_recalc_vfsmount_mask_locked(struct vfsmount *mnt)
  */
 void fsnotify_recalc_vfsmount_mask(struct vfsmount *mnt)
 {
-	spin_lock(&mnt->mnt_root->d_lock);
+	d_lock(mnt->mnt_root);
 	fsnotify_recalc_vfsmount_mask_locked(mnt);
-	spin_unlock(&mnt->mnt_root->d_lock);
+	d_unlock(mnt->mnt_root);
 }
 
 void fsnotify_destroy_vfsmount_mark(struct fsnotify_mark *mark)
@@ -98,14 +98,14 @@ void fsnotify_destroy_vfsmount_mark(struct fsnotify_mark *mark)
 	BUG_ON(!mutex_is_locked(&mark->group->mark_mutex));
 	assert_spin_locked(&mark->lock);
 
-	spin_lock(&mnt->mnt_root->d_lock);
+	d_lock(mnt->mnt_root);
 
 	hlist_del_init_rcu(&mark->m.m_list);
 	mark->m.mnt = NULL;
 
 	fsnotify_recalc_vfsmount_mask_locked(mnt);
 
-	spin_unlock(&mnt->mnt_root->d_lock);
+	d_unlock(mnt->mnt_root);
 }
 
 static struct fsnotify_mark *fsnotify_find_vfsmount_mark_locked(struct fsnotify_group *group,
@@ -114,7 +114,7 @@ static struct fsnotify_mark *fsnotify_find_vfsmount_mark_locked(struct fsnotify_
 	struct mount *m = real_mount(mnt);
 	struct fsnotify_mark *mark;
 
-	assert_spin_locked(&mnt->mnt_root->d_lock);
+	assert_spin_locked(&d_ret_lock(mnt->mnt_root));
 
 	hlist_for_each_entry(mark, &m->mnt_fsnotify_marks, m.m_list) {
 		if (mark->group == group) {
@@ -134,9 +134,9 @@ struct fsnotify_mark *fsnotify_find_vfsmount_mark(struct fsnotify_group *group,
 {
 	struct fsnotify_mark *mark;
 
-	spin_lock(&mnt->mnt_root->d_lock);
+	d_lock(mnt->mnt_root);
 	mark = fsnotify_find_vfsmount_mark_locked(group, mnt);
-	spin_unlock(&mnt->mnt_root->d_lock);
+	d_unlock(mnt->mnt_root);
 
 	return mark;
 }
@@ -159,7 +159,7 @@ int fsnotify_add_vfsmount_mark(struct fsnotify_mark *mark,
 	BUG_ON(!mutex_is_locked(&group->mark_mutex));
 	assert_spin_locked(&mark->lock);
 
-	spin_lock(&mnt->mnt_root->d_lock);
+	d_lock(mnt->mnt_root);
 
 	mark->m.mnt = mnt;
 
@@ -194,7 +194,7 @@ int fsnotify_add_vfsmount_mark(struct fsnotify_mark *mark,
 	hlist_add_after_rcu(&last->m.m_list, &mark->m.m_list);
 out:
 	fsnotify_recalc_vfsmount_mask_locked(mnt);
-	spin_unlock(&mnt->mnt_root->d_lock);
+	d_unlock(mnt->mnt_root);
 
 	return ret;
 }
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 4b2ee8d..8858088 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -329,7 +329,7 @@ static inline void __fsnotify_update_dcache_flags(struct dentry *dentry)
 {
 	struct dentry *parent;
 
-	assert_spin_locked(&dentry->d_lock);
+	assert_spin_locked(&d_ret_lock(dentry));
 
 	/*
 	 * Serialisation of setting PARENT_WATCHED on the dentries is provided
@@ -353,9 +353,9 @@ static inline void __fsnotify_d_instantiate(struct dentry *dentry, struct inode
 	if (!inode)
 		return;
 
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	__fsnotify_update_dcache_flags(dentry);
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 }
 
 /* called from fsnotify listeners, such as fanotify or dnotify */
-- 
1.7.1

