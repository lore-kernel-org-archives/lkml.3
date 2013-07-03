Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965359Ab3GCUVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:21:10 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:47438 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964882Ab3GCUVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:21:06 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Ian Kent <raven@themaw.net>, autofs@vger.kernel.org,
        Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v3 08/25] auto-fs: Change how dentry's d_lock and d_count fields are accessed
Date: Wed,  3 Jul 2013 16:20:51 -0400
Message-Id: <1372882851-22781-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of the changes made in dcache.h header file, files that use
the d_lock and d_count fields of the dentry structure need to be
changed accordingly.  All the d_lock's spin_lock() and spin_unlock()
calls are replaced by the corresponding d_lock() and d_unlock() calls.
References to d_count are replaced by the d_ret_count() calls.
There is no change in logic and everything should just work.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/autofs4/autofs_i.h |   24 ++++++++++++------------
 fs/autofs4/expire.c   |   48 ++++++++++++++++++++++++------------------------
 fs/autofs4/root.c     |   14 +++++++-------
 3 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index 3f1128b..dc7df32 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -198,9 +198,9 @@ static inline void __managed_dentry_set_automount(struct dentry *dentry)
 
 static inline void managed_dentry_set_automount(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	__managed_dentry_set_automount(dentry);
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 }
 
 static inline void __managed_dentry_clear_automount(struct dentry *dentry)
@@ -210,9 +210,9 @@ static inline void __managed_dentry_clear_automount(struct dentry *dentry)
 
 static inline void managed_dentry_clear_automount(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	__managed_dentry_clear_automount(dentry);
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 }
 
 static inline void __managed_dentry_set_transit(struct dentry *dentry)
@@ -222,9 +222,9 @@ static inline void __managed_dentry_set_transit(struct dentry *dentry)
 
 static inline void managed_dentry_set_transit(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	__managed_dentry_set_transit(dentry);
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 }
 
 static inline void __managed_dentry_clear_transit(struct dentry *dentry)
@@ -234,9 +234,9 @@ static inline void __managed_dentry_clear_transit(struct dentry *dentry)
 
 static inline void managed_dentry_clear_transit(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	__managed_dentry_clear_transit(dentry);
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 }
 
 static inline void __managed_dentry_set_managed(struct dentry *dentry)
@@ -246,9 +246,9 @@ static inline void __managed_dentry_set_managed(struct dentry *dentry)
 
 static inline void managed_dentry_set_managed(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	__managed_dentry_set_managed(dentry);
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 }
 
 static inline void __managed_dentry_clear_managed(struct dentry *dentry)
@@ -258,9 +258,9 @@ static inline void __managed_dentry_clear_managed(struct dentry *dentry)
 
 static inline void managed_dentry_clear_managed(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	__managed_dentry_clear_managed(dentry);
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 }
 
 /* Initializing function */
diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 13ddec9..0a7287c 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -88,7 +88,7 @@ static struct dentry *get_next_positive_subdir(struct dentry *prev,
 	struct dentry *q;
 
 	spin_lock(&sbi->lookup_lock);
-	spin_lock(&root->d_lock);
+	d_lock(root);
 
 	if (prev)
 		next = prev->d_u.d_child.next;
@@ -99,7 +99,7 @@ static struct dentry *get_next_positive_subdir(struct dentry *prev,
 
 cont:
 	if (next == &root->d_subdirs) {
-		spin_unlock(&root->d_lock);
+		d_unlock(root);
 		spin_unlock(&sbi->lookup_lock);
 		dput(prev);
 		return NULL;
@@ -107,16 +107,16 @@ cont:
 
 	q = list_entry(next, struct dentry, d_u.d_child);
 
-	spin_lock_nested(&q->d_lock, DENTRY_D_LOCK_NESTED);
+	d_lock_nested(q, DENTRY_D_LOCK_NESTED);
 	/* Already gone or negative dentry (under construction) - try next */
-	if (q->d_count == 0 || !simple_positive(q)) {
-		spin_unlock(&q->d_lock);
+	if (d_ret_count(q) == 0 || !simple_positive(q)) {
+		d_unlock(q);
 		next = q->d_u.d_child.next;
 		goto cont;
 	}
 	dget_dlock(q);
-	spin_unlock(&q->d_lock);
-	spin_unlock(&root->d_lock);
+	d_unlock(q);
+	d_unlock(root);
 	spin_unlock(&sbi->lookup_lock);
 
 	dput(prev);
@@ -140,7 +140,7 @@ static struct dentry *get_next_positive_dentry(struct dentry *prev,
 	spin_lock(&sbi->lookup_lock);
 relock:
 	p = prev;
-	spin_lock(&p->d_lock);
+	d_lock(p);
 again:
 	next = p->d_subdirs.next;
 	if (next == &p->d_subdirs) {
@@ -148,19 +148,19 @@ again:
 			struct dentry *parent;
 
 			if (p == root) {
-				spin_unlock(&p->d_lock);
+				d_unlock(p);
 				spin_unlock(&sbi->lookup_lock);
 				dput(prev);
 				return NULL;
 			}
 
 			parent = p->d_parent;
-			if (!spin_trylock(&parent->d_lock)) {
-				spin_unlock(&p->d_lock);
+			if (!d_trylock(parent)) {
+				d_unlock(p);
 				cpu_relax();
 				goto relock;
 			}
-			spin_unlock(&p->d_lock);
+			d_unlock(p);
 			next = p->d_u.d_child.next;
 			p = parent;
 			if (next != &parent->d_subdirs)
@@ -169,17 +169,17 @@ again:
 	}
 	ret = list_entry(next, struct dentry, d_u.d_child);
 
-	spin_lock_nested(&ret->d_lock, DENTRY_D_LOCK_NESTED);
+	d_lock_nested(ret, DENTRY_D_LOCK_NESTED);
 	/* Negative dentry - try next */
 	if (!simple_positive(ret)) {
-		spin_unlock(&p->d_lock);
-		lock_set_subclass(&ret->d_lock.dep_map, 0, _RET_IP_);
+		d_unlock(p);
+		lock_set_subclass(&d_ret_lock(ret).dep_map, 0, _RET_IP_);
 		p = ret;
 		goto again;
 	}
 	dget_dlock(ret);
-	spin_unlock(&ret->d_lock);
-	spin_unlock(&p->d_lock);
+	d_unlock(ret);
+	d_unlock(p);
 	spin_unlock(&sbi->lookup_lock);
 
 	dput(prev);
@@ -267,7 +267,7 @@ static int autofs4_tree_busy(struct vfsmount *mnt,
 			else
 				ino_count++;
 
-			if (p->d_count > ino_count) {
+			if (d_ret_count(p) > ino_count) {
 				top_ino->last_used = jiffies;
 				dput(p);
 				return 1;
@@ -409,7 +409,7 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 		if (!exp_leaves) {
 			/* Path walk currently on this dentry? */
 			ino_count = atomic_read(&ino->count) + 1;
-			if (dentry->d_count > ino_count)
+			if (d_ret_count(dentry) > ino_count)
 				goto next;
 
 			if (!autofs4_tree_busy(mnt, dentry, timeout, do_now)) {
@@ -423,7 +423,7 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 		} else {
 			/* Path walk currently on this dentry? */
 			ino_count = atomic_read(&ino->count) + 1;
-			if (dentry->d_count > ino_count)
+			if (d_ret_count(dentry) > ino_count)
 				goto next;
 
 			expired = autofs4_check_leaves(mnt, dentry, timeout, do_now);
@@ -445,11 +445,11 @@ found:
 	init_completion(&ino->expire_complete);
 	spin_unlock(&sbi->fs_lock);
 	spin_lock(&sbi->lookup_lock);
-	spin_lock(&expired->d_parent->d_lock);
-	spin_lock_nested(&expired->d_lock, DENTRY_D_LOCK_NESTED);
+	d_lock(expired->d_parent);
+	d_lock_nested(expired, DENTRY_D_LOCK_NESTED);
 	list_move(&expired->d_parent->d_subdirs, &expired->d_u.d_child);
-	spin_unlock(&expired->d_lock);
-	spin_unlock(&expired->d_parent->d_lock);
+	d_unlock(expired);
+	d_unlock(expired->d_parent);
 	spin_unlock(&sbi->lookup_lock);
 	return expired;
 }
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 085da86..e33a0f6 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -176,10 +176,10 @@ static struct dentry *autofs4_lookup_active(struct dentry *dentry)
 		ino = list_entry(p, struct autofs_info, active);
 		active = ino->dentry;
 
-		spin_lock(&active->d_lock);
+		d_lock(active);
 
 		/* Already gone? */
-		if (active->d_count == 0)
+		if (d_ret_count(active) == 0)
 			goto next;
 
 		qstr = &active->d_name;
@@ -196,12 +196,12 @@ static struct dentry *autofs4_lookup_active(struct dentry *dentry)
 
 		if (d_unhashed(active)) {
 			dget_dlock(active);
-			spin_unlock(&active->d_lock);
+			d_unlock(active);
 			spin_unlock(&sbi->lookup_lock);
 			return active;
 		}
 next:
-		spin_unlock(&active->d_lock);
+		d_unlock(active);
 	}
 	spin_unlock(&sbi->lookup_lock);
 
@@ -228,7 +228,7 @@ static struct dentry *autofs4_lookup_expiring(struct dentry *dentry)
 		ino = list_entry(p, struct autofs_info, expiring);
 		expiring = ino->dentry;
 
-		spin_lock(&expiring->d_lock);
+		d_lock(expiring);
 
 		/* Bad luck, we've already been dentry_iput */
 		if (!expiring->d_inode)
@@ -248,12 +248,12 @@ static struct dentry *autofs4_lookup_expiring(struct dentry *dentry)
 
 		if (d_unhashed(expiring)) {
 			dget_dlock(expiring);
-			spin_unlock(&expiring->d_lock);
+			d_unlock(expiring);
 			spin_unlock(&sbi->lookup_lock);
 			return expiring;
 		}
 next:
-		spin_unlock(&expiring->d_lock);
+		d_unlock(expiring);
 	}
 	spin_unlock(&sbi->lookup_lock);
 
-- 
1.7.1

