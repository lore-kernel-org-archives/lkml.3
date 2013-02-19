Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416Ab3BSSwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:52:05 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:41847 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933434Ab3BSSwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:52:02 -0500
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] dcache: Don't take unncessary lock in d_count update
Date: Tue, 19 Feb 2013 13:50:56 -0500
Message-Id: <1361299859-27056-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1361299859-27056-1-git-send-email-Waiman.Long@hp.com>
References: <1361299859-27056-1-git-send-email-Waiman.Long@hp.com>
To: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code takes the dentry's d_lock lock whenever the d_count
reference count is being updated. In reality, nothing big really
happens until d_count goes to 0 in dput(). So it is not necessary to
take the lock if the reference count won't go to 0.

Without using a lock, multiple threads may update d_count
simultaneously.  Therefore, atomic instructions must be used to
ensure consistency except in shrink_dcache_for_umount*() where the
whole superblock is being dismounted and locking is not needed.

The worst case scenarios are:

1. d_lock taken in dput with d_count = 2 in one thread and another
   thread comes in to atomically decrement d_count without taking
   the lock. This may result in a d_count of 0 with no deleting
   action taken.

2. d_lock taken in dput with d_count = 1 in one thread and another
   thread comes in to atomically increment d_count without taking
   the lock. This may result in the dentry in the deleted state while
   having a d_count of 1.

Without taking a lock, we need to make sure the decrementing or
incrementing action should not be taken while other threads are
updating d_count simultaneously. This can be done by using the
atomic cmpxchg instruction which will fail if the underlying value
is changed.  If the lock is taken, it should be safe to use a simpler
atomic increment or decrement instruction.

To make sure that the above worst case scenerios will not happen,
the dget() function must take the lock if d_count <= 1. Similarly,
the dput() function must take the lock if d_count <= 2. The cmpxchg()
call to update d_count will be tried twice before falling back to
using the lock as there is a fairly good chance that the cmpxchg()
may fail in a busy situation.

Finally, the CPU must have an instructional level cmpxchg instruction
or the emulated cmpxchg() function may be too expensive to
use. Therefore, the above mentioned changes will only be applied if
the __HAVE_ARCH_CMPXCHG flag is set. Most of the major architectures
supported by Linux have this flag set with the notation exception
of ARM.

As for the performance of the updated reference counting code, it
all depends on whether the cmpxchg instruction is used or not. The
original code has 2 atomic instructions to lock and unlock the
spinlock. The new code path has either 1 atomic cmpxchg instruction
or 3 atomic instructions if the lock has to be taken. Depending on
how frequent the cmpxchg instruction is used (d_count > 1 or 2),
the new code can be faster or slower than the original one.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/dcache.c            |   23 ++++++----
 fs/namei.c             |    2 +-
 include/linux/dcache.h |  105 ++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 117 insertions(+), 13 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 19153a0..20cc789 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -484,7 +484,7 @@ relock:
 	}
 
 	if (ref)
-		dentry->d_count--;
+		dcount_dec(dentry);
 	/*
 	 * if dentry was on the d_lru list delete it from there.
 	 * inform the fs via d_prune that this dentry is about to be
@@ -530,10 +530,13 @@ void dput(struct dentry *dentry)
 repeat:
 	if (dentry->d_count == 1)
 		might_sleep();
+	if (dcount_dec_cmpxchg(dentry))
+		return;
+
 	spin_lock(&dentry->d_lock);
 	BUG_ON(!dentry->d_count);
 	if (dentry->d_count > 1) {
-		dentry->d_count--;
+		dcount_dec(dentry);
 		spin_unlock(&dentry->d_lock);
 		return;
 	}
@@ -550,7 +553,7 @@ repeat:
 	dentry->d_flags |= DCACHE_REFERENCED;
 	dentry_lru_add(dentry);
 
-	dentry->d_count--;
+	dcount_dec(dentry);
 	spin_unlock(&dentry->d_lock);
 	return;
 
@@ -621,11 +624,13 @@ EXPORT_SYMBOL(d_invalidate);
 /* This must be called with d_lock held */
 static inline void __dget_dlock(struct dentry *dentry)
 {
-	dentry->d_count++;
+	dcount_inc(dentry);
 }
 
 static inline void __dget(struct dentry *dentry)
 {
+	if (dcount_inc_cmpxchg(dentry))
+		return;
 	spin_lock(&dentry->d_lock);
 	__dget_dlock(dentry);
 	spin_unlock(&dentry->d_lock);
@@ -650,7 +655,7 @@ repeat:
 	}
 	rcu_read_unlock();
 	BUG_ON(!ret->d_count);
-	ret->d_count++;
+	dcount_inc(ret);
 	spin_unlock(&ret->d_lock);
 	return ret;
 }
@@ -782,7 +787,7 @@ static void try_prune_one_dentry(struct dentry *dentry)
 	while (dentry) {
 		spin_lock(&dentry->d_lock);
 		if (dentry->d_count > 1) {
-			dentry->d_count--;
+			dcount_dec(dentry);
 			spin_unlock(&dentry->d_lock);
 			return;
 		}
@@ -1980,7 +1985,7 @@ struct dentry *__d_lookup(struct dentry *parent, struct qstr *name)
 				goto next;
 		}
 
-		dentry->d_count++;
+		dcount_inc(dentry);
 		found = dentry;
 		spin_unlock(&dentry->d_lock);
 		break;
@@ -2984,7 +2989,7 @@ resume:
 		}
 		if (!(dentry->d_flags & DCACHE_GENOCIDE)) {
 			dentry->d_flags |= DCACHE_GENOCIDE;
-			dentry->d_count--;
+			dcount_dec(dentry);
 		}
 		spin_unlock(&dentry->d_lock);
 	}
@@ -2992,7 +2997,7 @@ resume:
 		struct dentry *child = this_parent;
 		if (!(this_parent->d_flags & DCACHE_GENOCIDE)) {
 			this_parent->d_flags |= DCACHE_GENOCIDE;
-			this_parent->d_count--;
+			dcount_dec(this_parent);
 		}
 		this_parent = try_to_ascend(this_parent, locked, seq);
 		if (!this_parent)
diff --git a/fs/namei.c b/fs/namei.c
index 43a97ee..a1d5a36 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -537,7 +537,7 @@ static int unlazy_walk(struct nameidata *nd, struct dentry *dentry)
 		 */
 		BUG_ON(!IS_ROOT(dentry) && dentry->d_parent != parent);
 		BUG_ON(!parent->d_count);
-		parent->d_count++;
+		dcount_inc(parent);
 		spin_unlock(&dentry->d_lock);
 	}
 	spin_unlock(&parent->d_lock);
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index c1754b5..09495ba 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -255,6 +255,103 @@ extern int have_submounts(struct dentry *);
 extern void d_rehash(struct dentry *);
 
 /**
+ *	dcount_inc, dcount_dec - increment or decrement the dentry reference
+ *				 count
+ *	@dentry: dentry to get a reference to
+ */
+static inline void dcount_inc(struct dentry *dentry)
+{
+#ifdef __HAVE_ARCH_CMPXCHG
+	atomic_inc((atomic_t *)&dentry->d_count);
+#else
+	dentry->d_count++;
+#endif
+}
+
+static inline void dcount_dec(struct dentry *dentry)
+{
+#ifdef __HAVE_ARCH_CMPXCHG
+	atomic_dec((atomic_t *)&dentry->d_count);
+#else
+	dentry->d_count--;
+#endif
+}
+
+/**
+ *	dcount_inc_cmpxchg - increment dentry reference count using cmpxchg
+ *	@dentry: dentry to get a reference to
+ *	Return : 0 on failure, else 1
+ *
+ *	N.B. For architectures that do not have a cmpxchg instruction, the
+ *	     substitute code may not perform better than taking the lock.
+ *	     So this cmpxchg code path is disabled for those cases.
+ */
+static inline int dcount_inc_cmpxchg(struct dentry *dentry)
+{
+#ifdef __HAVE_ARCH_CMPXCHG
+	int oldc = dentry->d_count,
+	    newc;
+
+	if (oldc > 1) {
+		/*
+		 * If reference count > 1, we can safely increment its
+		 * value using atomic cmpxchg without locking. If the
+		 * operation fails, fall back to using the lock.
+		 */
+		newc = oldc + 1;
+		if (cmpxchg(&dentry->d_count, oldc, newc) == oldc)
+			return 1;
+		cpu_relax();
+		/* Retry one more time */
+		oldc = ACCESS_ONCE(dentry->d_count);
+		if (likely(oldc > 1)) {
+			newc = oldc + 1;
+			if (cmpxchg(&dentry->d_count, oldc, newc) == oldc)
+				return 1;
+			cpu_relax();
+		}
+	}
+#endif
+	return 0;
+}
+
+/**
+ *	dcount_dec_cmpxchg - decrement dentry reference count using cmpxchg
+ *	@dentry: dentry to get a reference to
+ *	Return : 0 on failure, else 1
+ */
+static inline int dcount_dec_cmpxchg(struct dentry *dentry)
+{
+#ifdef __HAVE_ARCH_CMPXCHG
+	int oldc = dentry->d_count,
+	    newc;
+
+	/*
+	 * If d_count is bigger than 2, we can safely decrement the
+	 * reference count using atomic cmpxchg instruction without locking.
+	 * Even if d_lock is taken by a thread running dput() with a parallel
+	 * atomic_dec(), the reference count won't go to 0 without anyone
+	 * noticing.
+	 */
+	if (oldc > 2) {
+		newc = oldc - 1;
+		if (cmpxchg(&dentry->d_count, oldc, newc) == oldc)
+			return 1;
+		cpu_relax();
+		/* Retry one more time */
+		oldc = ACCESS_ONCE(dentry->d_count);
+		if (likely(oldc > 2)) {
+			newc = oldc - 1;
+			if (cmpxchg(&dentry->d_count, oldc, newc) == oldc)
+				return 1;
+			cpu_relax();
+		}
+	}
+#endif
+	return 0;
+}
+
+/**
  * d_add - add dentry to hash queues
  * @entry: dentry to add
  * @inode: The inode to attach to this dentry
@@ -316,7 +413,7 @@ static inline int __d_rcu_to_refcount(struct dentry *dentry, unsigned seq)
 	assert_spin_locked(&dentry->d_lock);
 	if (!read_seqcount_retry(&dentry->d_seq, seq)) {
 		ret = 1;
-		dentry->d_count++;
+		dcount_inc(dentry);
 	}
 
 	return ret;
@@ -338,7 +435,6 @@ extern char *dentry_path_raw(struct dentry *, char *, int);
 extern char *dentry_path(struct dentry *, char *, int);
 
 /* Allocation counts.. */
-
 /**
  *	dget, dget_dlock -	get a reference to a dentry
  *	@dentry: dentry to get a reference to
@@ -350,13 +446,16 @@ extern char *dentry_path(struct dentry *, char *, int);
 static inline struct dentry *dget_dlock(struct dentry *dentry)
 {
 	if (dentry)
-		dentry->d_count++;
+		dcount_inc(dentry);
 	return dentry;
 }
 
 static inline struct dentry *dget(struct dentry *dentry)
 {
 	if (dentry) {
+		if (dcount_inc_cmpxchg(dentry))
+			return dentry;
+
 		spin_lock(&dentry->d_lock);
 		dget_dlock(dentry);
 		spin_unlock(&dentry->d_lock);
-- 
1.7.1

