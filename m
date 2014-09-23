Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbaIWFz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 01:55:28 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:48528 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbaIWFzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 01:55:25 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: kmo@daterainc.com, axboe@kernel.dk, hch@infradead.org, hannes@cmpxchg.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/9] percpu_ref: replace pcpu_ prefix with percpu_
Date: Tue, 23 Sep 2014 01:55:12 -0400
Message-Id: <1411451718-17807-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411451718-17807-1-git-send-email-tj@kernel.org>
References: <1411451718-17807-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu_ref uses pcpu_ prefix for internal stuff and percpu_ for
externally visible ones.  This is the same convention used in the
percpu allocator implementation.  It works fine there but percpu_ref
doesn't have too much internal-only stuff and scattered usages of
pcpu_ prefix are confusing than helpful.

This patch replaces all pcpu_ prefixes with percpu_.  This is pure
rename and there's no functional change.  Note that PCPU_REF_DEAD is
renamed to __PERCPU_REF_DEAD to signify that the flag is internal.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <kmo@daterainc.com>
---
 include/linux/percpu-refcount.h | 46 ++++++++++++++++-----------------
 lib/percpu-refcount.c           | 56 +++++++++++++++++++++--------------------
 2 files changed, 52 insertions(+), 50 deletions(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index d44b027..3d463a3 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -13,7 +13,7 @@
  *
  * The refcount will have a range of 0 to ((1U << 31) - 1), i.e. one bit less
  * than an atomic_t - this is because of the way shutdown works, see
- * percpu_ref_kill()/PCPU_COUNT_BIAS.
+ * percpu_ref_kill()/PERCPU_COUNT_BIAS.
  *
  * Before you call percpu_ref_kill(), percpu_ref_put() does not check for the
  * refcount hitting 0 - it can't, if it was in percpu mode. percpu_ref_kill()
@@ -60,7 +60,7 @@ struct percpu_ref {
 	 * The low bit of the pointer indicates whether the ref is in percpu
 	 * mode; if set, then get/put will manipulate the atomic_t.
 	 */
-	unsigned long		pcpu_count_ptr;
+	unsigned long		percpu_count_ptr;
 	percpu_ref_func_t	*release;
 	percpu_ref_func_t	*confirm_kill;
 	struct rcu_head		rcu;
@@ -88,26 +88,26 @@ static inline void percpu_ref_kill(struct percpu_ref *ref)
 	return percpu_ref_kill_and_confirm(ref, NULL);
 }
 
-#define PCPU_REF_DEAD		1
+#define __PERCPU_REF_DEAD	1
 
 /*
  * Internal helper.  Don't use outside percpu-refcount proper.  The
  * function doesn't return the pointer and let the caller test it for NULL
  * because doing so forces the compiler to generate two conditional
- * branches as it can't assume that @ref->pcpu_count is not NULL.
+ * branches as it can't assume that @ref->percpu_count is not NULL.
  */
-static inline bool __pcpu_ref_alive(struct percpu_ref *ref,
-				    unsigned long __percpu **pcpu_countp)
+static inline bool __percpu_ref_alive(struct percpu_ref *ref,
+				      unsigned long __percpu **percpu_countp)
 {
-	unsigned long pcpu_ptr = ACCESS_ONCE(ref->pcpu_count_ptr);
+	unsigned long percpu_ptr = ACCESS_ONCE(ref->percpu_count_ptr);
 
 	/* paired with smp_store_release() in percpu_ref_reinit() */
 	smp_read_barrier_depends();
 
-	if (unlikely(pcpu_ptr & PCPU_REF_DEAD))
+	if (unlikely(percpu_ptr & __PERCPU_REF_DEAD))
 		return false;
 
-	*pcpu_countp = (unsigned long __percpu *)pcpu_ptr;
+	*percpu_countp = (unsigned long __percpu *)percpu_ptr;
 	return true;
 }
 
@@ -121,12 +121,12 @@ static inline bool __pcpu_ref_alive(struct percpu_ref *ref,
  */
 static inline void percpu_ref_get(struct percpu_ref *ref)
 {
-	unsigned long __percpu *pcpu_count;
+	unsigned long __percpu *percpu_count;
 
 	rcu_read_lock_sched();
 
-	if (__pcpu_ref_alive(ref, &pcpu_count))
-		this_cpu_inc(*pcpu_count);
+	if (__percpu_ref_alive(ref, &percpu_count))
+		this_cpu_inc(*percpu_count);
 	else
 		atomic_long_inc(&ref->count);
 
@@ -144,13 +144,13 @@ static inline void percpu_ref_get(struct percpu_ref *ref)
  */
 static inline bool percpu_ref_tryget(struct percpu_ref *ref)
 {
-	unsigned long __percpu *pcpu_count;
+	unsigned long __percpu *percpu_count;
 	int ret;
 
 	rcu_read_lock_sched();
 
-	if (__pcpu_ref_alive(ref, &pcpu_count)) {
-		this_cpu_inc(*pcpu_count);
+	if (__percpu_ref_alive(ref, &percpu_count)) {
+		this_cpu_inc(*percpu_count);
 		ret = true;
 	} else {
 		ret = atomic_long_inc_not_zero(&ref->count);
@@ -178,13 +178,13 @@ static inline bool percpu_ref_tryget(struct percpu_ref *ref)
  */
 static inline bool percpu_ref_tryget_live(struct percpu_ref *ref)
 {
-	unsigned long __percpu *pcpu_count;
+	unsigned long __percpu *percpu_count;
 	int ret = false;
 
 	rcu_read_lock_sched();
 
-	if (__pcpu_ref_alive(ref, &pcpu_count)) {
-		this_cpu_inc(*pcpu_count);
+	if (__percpu_ref_alive(ref, &percpu_count)) {
+		this_cpu_inc(*percpu_count);
 		ret = true;
 	}
 
@@ -204,12 +204,12 @@ static inline bool percpu_ref_tryget_live(struct percpu_ref *ref)
  */
 static inline void percpu_ref_put(struct percpu_ref *ref)
 {
-	unsigned long __percpu *pcpu_count;
+	unsigned long __percpu *percpu_count;
 
 	rcu_read_lock_sched();
 
-	if (__pcpu_ref_alive(ref, &pcpu_count))
-		this_cpu_dec(*pcpu_count);
+	if (__percpu_ref_alive(ref, &percpu_count))
+		this_cpu_dec(*percpu_count);
 	else if (unlikely(atomic_long_dec_and_test(&ref->count)))
 		ref->release(ref);
 
@@ -226,9 +226,9 @@ static inline void percpu_ref_put(struct percpu_ref *ref)
  */
 static inline bool percpu_ref_is_zero(struct percpu_ref *ref)
 {
-	unsigned long __percpu *pcpu_count;
+	unsigned long __percpu *percpu_count;
 
-	if (__pcpu_ref_alive(ref, &pcpu_count))
+	if (__percpu_ref_alive(ref, &percpu_count))
 		return false;
 	return !atomic_long_read(&ref->count);
 }
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index 8ef3f5c..5aea6b7 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -11,8 +11,8 @@
  * percpu counters will all sum to the correct value
  *
  * (More precisely: because moduler arithmatic is commutative the sum of all the
- * pcpu_count vars will be equal to what it would have been if all the gets and
- * puts were done to a single integer, even if some of the percpu integers
+ * percpu_count vars will be equal to what it would have been if all the gets
+ * and puts were done to a single integer, even if some of the percpu integers
  * overflow or underflow).
  *
  * The real trick to implementing percpu refcounts is shutdown. We can't detect
@@ -29,11 +29,12 @@
  * atomic_long_t can't hit 0 before we've added up all the percpu refs.
  */
 
-#define PCPU_COUNT_BIAS		(1LU << (BITS_PER_LONG - 1))
+#define PERCPU_COUNT_BIAS	(1LU << (BITS_PER_LONG - 1))
 
-static unsigned long __percpu *pcpu_count_ptr(struct percpu_ref *ref)
+static unsigned long __percpu *percpu_count_ptr(struct percpu_ref *ref)
 {
-	return (unsigned long __percpu *)(ref->pcpu_count_ptr & ~PCPU_REF_DEAD);
+	return (unsigned long __percpu *)
+		(ref->percpu_count_ptr & ~__PERCPU_REF_DEAD);
 }
 
 /**
@@ -51,10 +52,11 @@ static unsigned long __percpu *pcpu_count_ptr(struct percpu_ref *ref)
 int percpu_ref_init(struct percpu_ref *ref, percpu_ref_func_t *release,
 		    gfp_t gfp)
 {
-	atomic_long_set(&ref->count, 1 + PCPU_COUNT_BIAS);
+	atomic_long_set(&ref->count, 1 + PERCPU_COUNT_BIAS);
 
-	ref->pcpu_count_ptr = (unsigned long)alloc_percpu_gfp(unsigned long, gfp);
-	if (!ref->pcpu_count_ptr)
+	ref->percpu_count_ptr =
+		(unsigned long)alloc_percpu_gfp(unsigned long, gfp);
+	if (!ref->percpu_count_ptr)
 		return -ENOMEM;
 
 	ref->release = release;
@@ -74,11 +76,11 @@ EXPORT_SYMBOL_GPL(percpu_ref_init);
  */
 void percpu_ref_exit(struct percpu_ref *ref)
 {
-	unsigned long __percpu *pcpu_count = pcpu_count_ptr(ref);
+	unsigned long __percpu *percpu_count = percpu_count_ptr(ref);
 
-	if (pcpu_count) {
-		free_percpu(pcpu_count);
-		ref->pcpu_count_ptr = PCPU_REF_DEAD;
+	if (percpu_count) {
+		free_percpu(percpu_count);
+		ref->percpu_count_ptr = __PERCPU_REF_DEAD;
 	}
 }
 EXPORT_SYMBOL_GPL(percpu_ref_exit);
@@ -86,14 +88,14 @@ EXPORT_SYMBOL_GPL(percpu_ref_exit);
 static void percpu_ref_kill_rcu(struct rcu_head *rcu)
 {
 	struct percpu_ref *ref = container_of(rcu, struct percpu_ref, rcu);
-	unsigned long __percpu *pcpu_count = pcpu_count_ptr(ref);
+	unsigned long __percpu *percpu_count = percpu_count_ptr(ref);
 	unsigned long count = 0;
 	int cpu;
 
 	for_each_possible_cpu(cpu)
-		count += *per_cpu_ptr(pcpu_count, cpu);
+		count += *per_cpu_ptr(percpu_count, cpu);
 
-	pr_debug("global %ld pcpu %ld",
+	pr_debug("global %ld percpu %ld",
 		 atomic_long_read(&ref->count), (long)count);
 
 	/*
@@ -108,7 +110,7 @@ static void percpu_ref_kill_rcu(struct rcu_head *rcu)
 	 * reaching 0 before we add the percpu counts. But doing it at the same
 	 * time is equivalent and saves us atomic operations:
 	 */
-	atomic_long_add((long)count - PCPU_COUNT_BIAS, &ref->count);
+	atomic_long_add((long)count - PERCPU_COUNT_BIAS, &ref->count);
 
 	WARN_ONCE(atomic_long_read(&ref->count) <= 0,
 		  "percpu ref (%pf) <= 0 (%ld) after killed",
@@ -143,10 +145,10 @@ static void percpu_ref_kill_rcu(struct rcu_head *rcu)
 void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
 				 percpu_ref_func_t *confirm_kill)
 {
-	WARN_ONCE(ref->pcpu_count_ptr & PCPU_REF_DEAD,
+	WARN_ONCE(ref->percpu_count_ptr & __PERCPU_REF_DEAD,
 		  "%s called more than once on %pf!", __func__, ref->release);
 
-	ref->pcpu_count_ptr |= PCPU_REF_DEAD;
+	ref->percpu_count_ptr |= __PERCPU_REF_DEAD;
 	ref->confirm_kill = confirm_kill;
 
 	call_rcu_sched(&ref->rcu, percpu_ref_kill_rcu);
@@ -166,24 +168,24 @@ EXPORT_SYMBOL_GPL(percpu_ref_kill_and_confirm);
  */
 void percpu_ref_reinit(struct percpu_ref *ref)
 {
-	unsigned long __percpu *pcpu_count = pcpu_count_ptr(ref);
+	unsigned long __percpu *percpu_count = percpu_count_ptr(ref);
 	int cpu;
 
-	BUG_ON(!pcpu_count);
+	BUG_ON(!percpu_count);
 	WARN_ON_ONCE(!percpu_ref_is_zero(ref));
 
-	atomic_long_set(&ref->count, 1 + PCPU_COUNT_BIAS);
+	atomic_long_set(&ref->count, 1 + PERCPU_COUNT_BIAS);
 
 	/*
 	 * Restore per-cpu operation.  smp_store_release() is paired with
-	 * smp_read_barrier_depends() in __pcpu_ref_alive() and guarantees
-	 * that the zeroing is visible to all percpu accesses which can see
-	 * the following PCPU_REF_DEAD clearing.
+	 * smp_read_barrier_depends() in __percpu_ref_alive() and
+	 * guarantees that the zeroing is visible to all percpu accesses
+	 * which can see the following __PERCPU_REF_DEAD clearing.
 	 */
 	for_each_possible_cpu(cpu)
-		*per_cpu_ptr(pcpu_count, cpu) = 0;
+		*per_cpu_ptr(percpu_count, cpu) = 0;
 
-	smp_store_release(&ref->pcpu_count_ptr,
-			  ref->pcpu_count_ptr & ~PCPU_REF_DEAD);
+	smp_store_release(&ref->percpu_count_ptr,
+			  ref->percpu_count_ptr & ~__PERCPU_REF_DEAD);
 }
 EXPORT_SYMBOL_GPL(percpu_ref_reinit);
-- 
1.9.3

