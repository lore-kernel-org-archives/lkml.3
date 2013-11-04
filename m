Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab3KDLhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:37:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab3KDLgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:36:44 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 16/19] GFS2: Use lockref for glocks
Date: Mon,  4 Nov 2013 11:09:39 +0000
Message-Id: <1383563382-8535-17-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
References: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently glocks have an atomic reference count and also a spinlock
which covers various internal fields, such as the state. This intent of
this patch is to replace the spinlock and the atomic reference count
with a lockref structure. This contains a spinlock which we can continue
to use as before, and a reference counter which is used in conjuction
with the spinlock to replace the previous atomic counter.

As a result of this there are some new rules for reference counting on
glocks. We need to distinguish between reference count changes under
gl_spin (which are now just increment or decrement of the new counter,
provided the count cannot hit zero) and those which are outside of
gl_spin, but which now take gl_spin internally.

The conversion is relatively straight forward. There is probably some
further clean up which can be done, but the priority at this stage is to
make the change in as simple a manner as possible.

A consequence of this change is that the reference count is being
decoupled from the lru list processing. This should allow future
adoption of the lru_list code with glocks in due course.

The reason for using the "dead" state and not just relying on 0 being
the "invalid state" is so that in due course 0 ref counts can be
allowable. The intent is to eventually be able to remove the ref count
changes which are currently hidden away in state_change().

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index c2f41b4..e66a800 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -31,6 +31,7 @@
 #include <linux/bit_spinlock.h>
 #include <linux/percpu.h>
 #include <linux/list_sort.h>
+#include <linux/lockref.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -129,10 +130,10 @@ void gfs2_glock_free(struct gfs2_glock *gl)
  *
  */
 
-void gfs2_glock_hold(struct gfs2_glock *gl)
+static void gfs2_glock_hold(struct gfs2_glock *gl)
 {
-	GLOCK_BUG_ON(gl, atomic_read(&gl->gl_ref) == 0);
-	atomic_inc(&gl->gl_ref);
+	GLOCK_BUG_ON(gl, __lockref_is_dead(&gl->gl_lockref));
+	lockref_get(&gl->gl_lockref);
 }
 
 /**
@@ -187,20 +188,6 @@ static void gfs2_glock_remove_from_lru(struct gfs2_glock *gl)
 }
 
 /**
- * gfs2_glock_put_nolock() - Decrement reference count on glock
- * @gl: The glock to put
- *
- * This function should only be used if the caller has its own reference
- * to the glock, in addition to the one it is dropping.
- */
-
-void gfs2_glock_put_nolock(struct gfs2_glock *gl)
-{
-	if (atomic_dec_and_test(&gl->gl_ref))
-		GLOCK_BUG_ON(gl, 1);
-}
-
-/**
  * gfs2_glock_put() - Decrement reference count on glock
  * @gl: The glock to put
  *
@@ -211,17 +198,22 @@ void gfs2_glock_put(struct gfs2_glock *gl)
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	struct address_space *mapping = gfs2_glock2aspace(gl);
 
-	if (atomic_dec_and_lock(&gl->gl_ref, &lru_lock)) {
-		__gfs2_glock_remove_from_lru(gl);
-		spin_unlock(&lru_lock);
-		spin_lock_bucket(gl->gl_hash);
-		hlist_bl_del_rcu(&gl->gl_list);
-		spin_unlock_bucket(gl->gl_hash);
-		GLOCK_BUG_ON(gl, !list_empty(&gl->gl_holders));
-		GLOCK_BUG_ON(gl, mapping && mapping->nrpages);
-		trace_gfs2_glock_put(gl);
-		sdp->sd_lockstruct.ls_ops->lm_put_lock(gl);
-	}
+	if (lockref_put_or_lock(&gl->gl_lockref))
+		return;
+
+	lockref_mark_dead(&gl->gl_lockref);
+
+	spin_lock(&lru_lock);
+	__gfs2_glock_remove_from_lru(gl);
+	spin_unlock(&lru_lock);
+	spin_unlock(&gl->gl_lockref.lock);
+	spin_lock_bucket(gl->gl_hash);
+	hlist_bl_del_rcu(&gl->gl_list);
+	spin_unlock_bucket(gl->gl_hash);
+	GLOCK_BUG_ON(gl, !list_empty(&gl->gl_holders));
+	GLOCK_BUG_ON(gl, mapping && mapping->nrpages);
+	trace_gfs2_glock_put(gl);
+	sdp->sd_lockstruct.ls_ops->lm_put_lock(gl);
 }
 
 /**
@@ -244,7 +236,7 @@ static struct gfs2_glock *search_bucket(unsigned int hash,
 			continue;
 		if (gl->gl_sbd != sdp)
 			continue;
-		if (atomic_inc_not_zero(&gl->gl_ref))
+		if (lockref_get_not_dead(&gl->gl_lockref))
 			return gl;
 	}
 
@@ -396,10 +388,11 @@ static void state_change(struct gfs2_glock *gl, unsigned int new_state)
 	held2 = (new_state != LM_ST_UNLOCKED);
 
 	if (held1 != held2) {
+		GLOCK_BUG_ON(gl, __lockref_is_dead(&gl->gl_lockref));
 		if (held2)
-			gfs2_glock_hold(gl);
+			gl->gl_lockref.count++;
 		else
-			gfs2_glock_put_nolock(gl);
+			gl->gl_lockref.count--;
 	}
 	if (held1 && held2 && list_empty(&gl->gl_holders))
 		clear_bit(GLF_QUEUED, &gl->gl_flags);
@@ -626,9 +619,9 @@ out:
 out_sched:
 	clear_bit(GLF_LOCK, &gl->gl_flags);
 	smp_mb__after_clear_bit();
-	gfs2_glock_hold(gl);
+	gl->gl_lockref.count++;
 	if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
-		gfs2_glock_put_nolock(gl);
+		gl->gl_lockref.count--;
 	return;
 
 out_unlock:
@@ -754,7 +747,7 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	gl->gl_sbd = sdp;
 	gl->gl_flags = 0;
 	gl->gl_name = name;
-	atomic_set(&gl->gl_ref, 1);
+	gl->gl_lockref.count = 1;
 	gl->gl_state = LM_ST_UNLOCKED;
 	gl->gl_target = LM_ST_UNLOCKED;
 	gl->gl_demote_state = LM_ST_EXCLUSIVE;
@@ -1356,10 +1349,10 @@ void gfs2_glock_complete(struct gfs2_glock *gl, int ret)
 		}
 	}
 
-	spin_unlock(&gl->gl_spin);
+	gl->gl_lockref.count++;
 	set_bit(GLF_REPLY_PENDING, &gl->gl_flags);
-	smp_wmb();
-	gfs2_glock_hold(gl);
+	spin_unlock(&gl->gl_spin);
+
 	if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
 		gfs2_glock_put(gl);
 }
@@ -1404,15 +1397,19 @@ __acquires(&lru_lock)
 	while(!list_empty(list)) {
 		gl = list_entry(list->next, struct gfs2_glock, gl_lru);
 		list_del_init(&gl->gl_lru);
+		if (!spin_trylock(&gl->gl_spin)) {
+			list_add(&gl->gl_lru, &lru_list);
+			atomic_inc(&lru_count);
+			continue;
+		}
 		clear_bit(GLF_LRU, &gl->gl_flags);
-		gfs2_glock_hold(gl);
 		spin_unlock(&lru_lock);
-		spin_lock(&gl->gl_spin);
+		gl->gl_lockref.count++;
 		if (demote_ok(gl))
 			handle_callback(gl, LM_ST_UNLOCKED, 0, false);
 		WARN_ON(!test_and_clear_bit(GLF_LOCK, &gl->gl_flags));
 		if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
-			gfs2_glock_put_nolock(gl);
+			gl->gl_lockref.count--;
 		spin_unlock(&gl->gl_spin);
 		spin_lock(&lru_lock);
 	}
@@ -1493,7 +1490,7 @@ static void examine_bucket(glock_examiner examiner, const struct gfs2_sbd *sdp,
 
 	rcu_read_lock();
 	hlist_bl_for_each_entry_rcu(gl, pos, head, gl_list) {
-		if ((gl->gl_sbd == sdp) && atomic_inc_not_zero(&gl->gl_ref))
+		if ((gl->gl_sbd == sdp) && lockref_get_not_dead(&gl->gl_lockref))
 			examiner(gl);
 	}
 	rcu_read_unlock();
@@ -1746,7 +1743,7 @@ int gfs2_dump_glock(struct seq_file *seq, const struct gfs2_glock *gl)
 		  state2str(gl->gl_demote_state), dtime,
 		  atomic_read(&gl->gl_ail_count),
 		  atomic_read(&gl->gl_revokes),
-		  atomic_read(&gl->gl_ref), gl->gl_hold_time);
+		  (int)gl->gl_lockref.count, gl->gl_hold_time);
 
 	list_for_each_entry(gh, &gl->gl_holders, gh_list) {
 		error = dump_holder(seq, gh);
@@ -1902,7 +1899,7 @@ static int gfs2_glock_iter_next(struct gfs2_glock_iter *gi)
 			gi->nhash = 0;
 		}
 	/* Skip entries for other sb and dead entries */
-	} while (gi->sdp != gi->gl->gl_sbd || atomic_read(&gi->gl->gl_ref) == 0);
+	} while (gi->sdp != gi->gl->gl_sbd || __lockref_is_dead(&gl->gl_lockref));
 
 	return 0;
 }
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index 69f66e3..6647d77 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -181,8 +181,6 @@ static inline struct address_space *gfs2_glock2aspace(struct gfs2_glock *gl)
 extern int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 			  const struct gfs2_glock_operations *glops,
 			  int create, struct gfs2_glock **glp);
-extern void gfs2_glock_hold(struct gfs2_glock *gl);
-extern void gfs2_glock_put_nolock(struct gfs2_glock *gl);
 extern void gfs2_glock_put(struct gfs2_glock *gl);
 extern void gfs2_holder_init(struct gfs2_glock *gl, unsigned int state,
 			     unsigned flags, struct gfs2_holder *gh);
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index e2e0a90..db908f6 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -525,9 +525,9 @@ static void iopen_go_callback(struct gfs2_glock *gl, bool remote)
 
 	if (gl->gl_demote_state == LM_ST_UNLOCKED &&
 	    gl->gl_state == LM_ST_SHARED && ip) {
-		gfs2_glock_hold(gl);
+		gl->gl_lockref.count++;
 		if (queue_work(gfs2_delete_workqueue, &gl->gl_delete) == 0)
-			gfs2_glock_put_nolock(gl);
+			gl->gl_lockref.count--;
 	}
 }
 
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 2ab4f8d..bb88e41 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -21,6 +21,7 @@
 #include <linux/rbtree.h>
 #include <linux/ktime.h>
 #include <linux/percpu.h>
+#include <linux/lockref.h>
 
 #define DIO_WAIT	0x00000010
 #define DIO_METADATA	0x00000020
@@ -321,9 +322,9 @@ struct gfs2_glock {
 	struct gfs2_sbd *gl_sbd;
 	unsigned long gl_flags;		/* GLF_... */
 	struct lm_lockname gl_name;
-	atomic_t gl_ref;
 
-	spinlock_t gl_spin;
+	struct lockref gl_lockref;
+#define gl_spin gl_lockref.lock
 
 	/* State fields protected by gl_spin */
 	unsigned int gl_state:2,	/* Current state */
diff --git a/include/linux/lockref.h b/include/linux/lockref.h
index f279ed9..13dfd36 100644
--- a/include/linux/lockref.h
+++ b/include/linux/lockref.h
@@ -36,4 +36,10 @@ extern int lockref_put_or_lock(struct lockref *);
 extern void lockref_mark_dead(struct lockref *);
 extern int lockref_get_not_dead(struct lockref *);
 
+/* Must be called under spinlock for reliable results */
+static inline int __lockref_is_dead(const struct lockref *l)
+{
+	return ((int)l->count < 0);
+}
+
 #endif /* __LINUX_LOCKREF_H */
diff --git a/lib/lockref.c b/lib/lockref.c
index e2cd2c0..8ff162f 100644
--- a/lib/lockref.c
+++ b/lib/lockref.c
@@ -136,6 +136,7 @@ void lockref_mark_dead(struct lockref *lockref)
 	assert_spin_locked(&lockref->lock);
 	lockref->count = -128;
 }
+EXPORT_SYMBOL(lockref_mark_dead);
 
 /**
  * lockref_get_not_dead - Increments count unless the ref is dead
-- 
1.7.4.4

