Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbaIWFzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 01:55:36 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:55920 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbaIWFza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 01:55:30 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: kmo@daterainc.com, axboe@kernel.dk, hch@infradead.org, hannes@cmpxchg.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/9] percpu_ref: decouple switching to percpu mode and reinit
Date: Tue, 23 Sep 2014 01:55:16 -0400
Message-Id: <1411451718-17807-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411451718-17807-1-git-send-email-tj@kernel.org>
References: <1411451718-17807-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu_ref has treated the dropping of the base reference and
switching to atomic mode as an integral operation; however, there's
nothing inherent tying the two together.

The use cases for percpu_ref have been expanding continuously.  While
the current init/kill/reinit/exit model can cover a lot, the coupling
of kill/reinit with atomic/percpu mode switching is turning out to be
too restrictive for use cases where many percpu_refs are created and
destroyed back-to-back with only some of them reaching extended
operation.  The coupling also makes implementing always-atomic debug
mode difficult.

This patch separates out percpu mode switching into
percpu_ref_switch_to_percpu() and reimplements percpu_ref_reinit() on
top of it.

* DEAD still requires ATOMIC.  A dead ref can't be switched to percpu
  mode w/o going through reinit.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/percpu-refcount.h |  3 +-
 lib/percpu-refcount.c           | 73 ++++++++++++++++++++++++++++++-----------
 2 files changed, 56 insertions(+), 20 deletions(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 03a02e9..e41ca20 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -78,9 +78,10 @@ int __must_check percpu_ref_init(struct percpu_ref *ref,
 void percpu_ref_exit(struct percpu_ref *ref);
 void percpu_ref_switch_to_atomic(struct percpu_ref *ref,
 				 percpu_ref_func_t *confirm_switch);
-void percpu_ref_reinit(struct percpu_ref *ref);
+void percpu_ref_switch_to_percpu(struct percpu_ref *ref);
 void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
 				 percpu_ref_func_t *confirm_kill);
+void percpu_ref_reinit(struct percpu_ref *ref);
 
 /**
  * percpu_ref_kill - drop the initial ref
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index 56a7c0d..548b19e 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -206,40 +206,54 @@ void percpu_ref_switch_to_atomic(struct percpu_ref *ref,
 	__percpu_ref_switch_to_atomic(ref, confirm_switch);
 }
 
-/**
- * percpu_ref_reinit - re-initialize a percpu refcount
- * @ref: perpcu_ref to re-initialize
- *
- * Re-initialize @ref so that it's in the same state as when it finished
- * percpu_ref_init().  @ref must have been initialized successfully, killed
- * and reached 0 but not exited.
- *
- * Note that percpu_ref_tryget[_live]() are safe to perform on @ref while
- * this function is in progress.
- */
-void percpu_ref_reinit(struct percpu_ref *ref)
+void __percpu_ref_switch_to_percpu(struct percpu_ref *ref)
 {
 	unsigned long __percpu *percpu_count = percpu_count_ptr(ref);
 	int cpu;
 
 	BUG_ON(!percpu_count);
-	WARN_ON_ONCE(!percpu_ref_is_zero(ref));
 
-	atomic_long_set(&ref->count, 1 + PERCPU_COUNT_BIAS);
+	if (!(ref->percpu_count_ptr & __PERCPU_REF_ATOMIC))
+		return;
+
+	wait_event(percpu_ref_switch_waitq, !ref->confirm_switch);
+
+	atomic_long_add(PERCPU_COUNT_BIAS, &ref->count);
 
 	/*
 	 * Restore per-cpu operation.  smp_store_release() is paired with
 	 * smp_read_barrier_depends() in __ref_is_percpu() and guarantees
 	 * that the zeroing is visible to all percpu accesses which can see
-	 * the following __PERCPU_REF_ATOMIC_DEAD clearing.
+	 * the following __PERCPU_REF_ATOMIC clearing.
 	 */
 	for_each_possible_cpu(cpu)
 		*per_cpu_ptr(percpu_count, cpu) = 0;
 
 	smp_store_release(&ref->percpu_count_ptr,
-			  ref->percpu_count_ptr & ~__PERCPU_REF_ATOMIC_DEAD);
+			  ref->percpu_count_ptr & ~__PERCPU_REF_ATOMIC);
+}
+
+/**
+ * percpu_ref_switch_to_percpu - switch a percpu_ref to percpu mode
+ * @ref: percpu_ref to switch to percpu mode
+ *
+ * There's no reason to use this function for the usual reference counting.
+ * To re-use an expired ref, use percpu_ref_reinit().
+ *
+ * Switch @ref to percpu mode.  This function may be invoked concurrently
+ * with all the get/put operations and can safely be mixed with kill and
+ * reinit operations.
+ *
+ * This function normally doesn't block and can be called from any context
+ * but it may block if @ref is in the process of switching to atomic mode
+ * by percpu_ref_switch_atomic().
+ */
+void percpu_ref_switch_to_percpu(struct percpu_ref *ref)
+{
+	/* a dying or dead ref can't be switched to percpu mode w/o reinit */
+	if (!(ref->percpu_count_ptr & __PERCPU_REF_DEAD))
+		__percpu_ref_switch_to_percpu(ref);
 }
-EXPORT_SYMBOL_GPL(percpu_ref_reinit);
 
 /**
  * percpu_ref_kill_and_confirm - drop the initial ref and schedule confirmation
@@ -253,8 +267,8 @@ EXPORT_SYMBOL_GPL(percpu_ref_reinit);
  * percpu_ref_tryget_live() for details.
  *
  * This function normally doesn't block and can be called from any context
- * but it may block if @confirm_kill is specified and @ref is already in
- * the process of switching to atomic mode by percpu_ref_switch_atomic().
+ * but it may block if @confirm_kill is specified and @ref is in the
+ * process of switching to atomic mode by percpu_ref_switch_atomic().
  *
  * Due to the way percpu_ref is implemented, @confirm_switch will be called
  * after at least one full sched RCU grace period has passed but this is an
@@ -271,3 +285,24 @@ void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
 	percpu_ref_put(ref);
 }
 EXPORT_SYMBOL_GPL(percpu_ref_kill_and_confirm);
+
+/**
+ * percpu_ref_reinit - re-initialize a percpu refcount
+ * @ref: perpcu_ref to re-initialize
+ *
+ * Re-initialize @ref so that it's in the same state as when it finished
+ * percpu_ref_init().  @ref must have been initialized successfully and
+ * reached 0 but not exited.
+ *
+ * Note that percpu_ref_tryget[_live]() are safe to perform on @ref while
+ * this function is in progress.
+ */
+void percpu_ref_reinit(struct percpu_ref *ref)
+{
+	WARN_ON_ONCE(!percpu_ref_is_zero(ref));
+
+	ref->percpu_count_ptr &= ~__PERCPU_REF_DEAD;
+	percpu_ref_get(ref);
+	__percpu_ref_switch_to_percpu(ref);
+}
+EXPORT_SYMBOL_GPL(percpu_ref_reinit);
-- 
1.9.3

