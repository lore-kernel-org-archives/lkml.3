Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbaFZRDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:03:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757958AbaFZRDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:03:22 -0400
Date: Thu, 26 Jun 2014 19:01:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] rcu: uninline rcu_lock_acquire() and rcu_lock_release()
Message-ID: <20140626170143.GA28565@redhat.com>
References: <20140626170116.GA28558@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626170116.GA28558@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uninline rcu_lock_acquire() and rcu_lock_release() to shrink .text/data.
The difference in "size vmlinux" looks good,

with CONFIG_DEBUG_LOCK_ALLOC

	- 5377829 3018320 14757888 23154037
	+ 5352229 3010160 14757888 23120277

33760 bytes saved.

with CONFIG_DEBUG_LOCK_ALLOC + CONFIG_PROVE_RCU + CONFIG_TREE_RCU_TRACE

	- 5682283 3022936 14757888 23463107
	+ 5578667 3026776 14757888 23363331

saves 99776 bytes.

However, this obviously means that the "warn once" logic is moved from
the current callers of rcu_lockdep_assert(rcu_is_watching()) to update.c.

Also, with this patch we do not bother to report which function abused
rcu_is_watching(), this should be clear from dump_stack().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/rcupdate.h |   55 ++++++++++++++++++++++---------------------
 include/linux/srcu.h     |    4 +-
 kernel/rcu/rcu.h         |    6 ++--
 kernel/rcu/update.c      |   57 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 90 insertions(+), 32 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 5a75d19..a5b1631 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -379,18 +379,34 @@ static inline bool rcu_lockdep_current_cpu_online(void)
 }
 #endif /* #else #if defined(CONFIG_HOTPLUG_CPU) && defined(CONFIG_PROVE_RCU) */
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-
-static inline void rcu_lock_acquire(struct lockdep_map *map)
+static inline void __rcu_lock_acquire(struct lockdep_map *map, unsigned long ip)
 {
-	lock_acquire(map, 0, 0, 2, 0, NULL, _THIS_IP_);
+	lock_acquire(map, 0, 0, 2, 0, NULL, ip);
 }
 
-static inline void rcu_lock_release(struct lockdep_map *map)
+static inline void __rcu_lock_release(struct lockdep_map *map, unsigned long ip)
 {
-	lock_release(map, 1, _THIS_IP_);
+	lock_release(map, 1, ip);
 }
 
+#if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_PROVE_RCU)
+extern void rcu_lock_acquire(void);
+extern void rcu_lock_release(void);
+extern void rcu_lock_acquire_bh(void);
+extern void rcu_lock_release_bh(void);
+extern void rcu_lock_acquire_sched(void);
+extern void rcu_lock_release_sched(void);
+#else
+#define rcu_lock_acquire()		do { } while (0)
+#define rcu_lock_release()		do { } while (0)
+#define rcu_lock_acquire_bh()		do { } while (0)
+#define rcu_lock_release_bh()		do { } while (0)
+#define rcu_lock_acquire_sched()	do { } while (0)
+#define rcu_lock_release_sched()	do { } while (0)
+#endif
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+
 extern struct lockdep_map rcu_lock_map;
 extern struct lockdep_map rcu_bh_lock_map;
 extern struct lockdep_map rcu_sched_lock_map;
@@ -489,9 +505,6 @@ static inline int rcu_read_lock_sched_held(void)
 
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
-# define rcu_lock_acquire(a)		do { } while (0)
-# define rcu_lock_release(a)		do { } while (0)
-
 static inline int rcu_read_lock_held(void)
 {
 	return 1;
@@ -866,9 +879,7 @@ static inline void rcu_read_lock(void)
 {
 	__rcu_read_lock();
 	__acquire(RCU);
-	rcu_lock_acquire(&rcu_lock_map);
-	rcu_lockdep_assert(rcu_is_watching(),
-			   "rcu_read_lock() used illegally while idle");
+	rcu_lock_acquire();
 }
 
 /*
@@ -888,9 +899,7 @@ static inline void rcu_read_lock(void)
  */
 static inline void rcu_read_unlock(void)
 {
-	rcu_lockdep_assert(rcu_is_watching(),
-			   "rcu_read_unlock() used illegally while idle");
-	rcu_lock_release(&rcu_lock_map);
+	rcu_lock_release();
 	__release(RCU);
 	__rcu_read_unlock();
 }
@@ -916,9 +925,7 @@ static inline void rcu_read_lock_bh(void)
 {
 	local_bh_disable();
 	__acquire(RCU_BH);
-	rcu_lock_acquire(&rcu_bh_lock_map);
-	rcu_lockdep_assert(rcu_is_watching(),
-			   "rcu_read_lock_bh() used illegally while idle");
+	rcu_lock_acquire_bh();
 }
 
 /*
@@ -928,9 +935,7 @@ static inline void rcu_read_lock_bh(void)
  */
 static inline void rcu_read_unlock_bh(void)
 {
-	rcu_lockdep_assert(rcu_is_watching(),
-			   "rcu_read_unlock_bh() used illegally while idle");
-	rcu_lock_release(&rcu_bh_lock_map);
+	rcu_lock_release_bh();
 	__release(RCU_BH);
 	local_bh_enable();
 }
@@ -952,9 +957,7 @@ static inline void rcu_read_lock_sched(void)
 {
 	preempt_disable();
 	__acquire(RCU_SCHED);
-	rcu_lock_acquire(&rcu_sched_lock_map);
-	rcu_lockdep_assert(rcu_is_watching(),
-			   "rcu_read_lock_sched() used illegally while idle");
+	rcu_lock_acquire_sched();
 }
 
 /* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
@@ -971,9 +974,7 @@ static inline notrace void rcu_read_lock_sched_notrace(void)
  */
 static inline void rcu_read_unlock_sched(void)
 {
-	rcu_lockdep_assert(rcu_is_watching(),
-			   "rcu_read_unlock_sched() used illegally while idle");
-	rcu_lock_release(&rcu_sched_lock_map);
+	rcu_lock_release_sched();
 	__release(RCU_SCHED);
 	preempt_enable();
 }
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index a2783cb..5c06289 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -219,7 +219,7 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
 {
 	int retval = __srcu_read_lock(sp);
 
-	rcu_lock_acquire(&(sp)->dep_map);
+	__rcu_lock_acquire(&(sp)->dep_map, _THIS_IP_);
 	return retval;
 }
 
@@ -233,7 +233,7 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
 static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
 	__releases(sp)
 {
-	rcu_lock_release(&(sp)->dep_map);
+	__rcu_lock_release(&(sp)->dep_map, _THIS_IP_);
 	__srcu_read_unlock(sp, idx);
 }
 
diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
index bfda272..5702910 100644
--- a/kernel/rcu/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -103,16 +103,16 @@ static inline bool __rcu_reclaim(const char *rn, struct rcu_head *head)
 {
 	unsigned long offset = (unsigned long)head->func;
 
-	rcu_lock_acquire(&rcu_callback_map);
+	__rcu_lock_acquire(&rcu_callback_map, _THIS_IP_);
 	if (__is_kfree_rcu_offset(offset)) {
 		RCU_TRACE(trace_rcu_invoke_kfree_callback(rn, head, offset));
 		kfree((void *)head - offset);
-		rcu_lock_release(&rcu_callback_map);
+		__rcu_lock_release(&rcu_callback_map, _THIS_IP_);
 		return 1;
 	} else {
 		RCU_TRACE(trace_rcu_invoke_callback(rn, head));
 		head->func(head);
-		rcu_lock_release(&rcu_callback_map);
+		__rcu_lock_release(&rcu_callback_map, _THIS_IP_);
 		return 0;
 	}
 }
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index a2aeb4d..bf98a37 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -168,6 +168,63 @@ EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
 
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
+#if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_PROVE_RCU)
+
+static void rcu_lockdep_assert_watching(void)
+{
+	rcu_lockdep_assert(rcu_is_watching(), "RCU used illegally while idle");
+}
+
+static void rcu_acquire_map(struct lockdep_map *map, unsigned long ip)
+{
+	__rcu_lock_acquire(map, ip);
+	rcu_lockdep_assert_watching();
+}
+
+static void rcu_release_map(struct lockdep_map *map, unsigned long ip)
+{
+	rcu_lockdep_assert_watching();
+	__rcu_lock_release(&rcu_lock_map, ip);
+}
+
+void rcu_lock_acquire(void)
+{
+	rcu_acquire_map(&rcu_lock_map, _RET_IP_);
+}
+EXPORT_SYMBOL(rcu_lock_acquire);
+
+void rcu_lock_release(void)
+{
+	rcu_release_map(&rcu_lock_map, _RET_IP_);
+}
+EXPORT_SYMBOL(rcu_lock_release);
+
+void rcu_lock_acquire_bh(void)
+{
+	rcu_acquire_map(&rcu_bh_lock_map, _RET_IP_);
+}
+EXPORT_SYMBOL(rcu_lock_acquire_bh);
+
+void rcu_lock_release_bh(void)
+{
+	rcu_release_map(&rcu_bh_lock_map, _RET_IP_);
+}
+EXPORT_SYMBOL(rcu_lock_release_bh);
+
+void rcu_lock_acquire_sched(void)
+{
+	rcu_acquire_map(&rcu_sched_lock_map, _RET_IP_);
+}
+EXPORT_SYMBOL(rcu_lock_acquire_sched);
+
+void rcu_lock_release_sched(void)
+{
+	rcu_release_map(&rcu_sched_lock_map, _RET_IP_);
+}
+EXPORT_SYMBOL(rcu_lock_release_sched);
+
+#endif
+
 struct rcu_synchronize {
 	struct rcu_head head;
 	struct completion completion;
-- 
1.5.5.1


