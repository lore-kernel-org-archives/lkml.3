Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136AbaITFbP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 01:31:15 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:64851 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945AbaITFbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 01:31:14 -0400
Date: Sat, 20 Sep 2014 01:31:10 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org, kmo@daterainc.com
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH v2 3/3] percpu-refcount: make percpu_ref based on longs
 instead of ints
Message-ID: <20140920053110.GC7926@mtj.dyndns.org>
References: <1410142342-8185-1-git-send-email-tj@kernel.org>
 <1410142342-8185-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410142342-8185-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e625305b390790717cf2cccf61efb81299647028 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Sat, 20 Sep 2014 01:27:25 -0400

percpu_ref is currently based on ints and the number of refs it can
cover is (1 << 31).  This makes it impossible to use a percpu_ref to
count memory objects or pages on 64bit machines as it may overflow.
This forces those users to somehow aggregate the references before
contributing to the percpu_ref which is often cumbersome and sometimes
challenging to get the same level of performance as using the
percpu_ref directly.

While using ints for the percpu counters makes them pack tighter on
64bit machines, the possible gain from using ints instead of longs is
extremely small compared to the overall gain from per-cpu operation.
This patch makes percpu_ref based on longs so that it can be used to
directly count memory objects or pages.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
This is the version which got applied.  Refreshed to reflect the
previous patch being dropped and a couple atomic_t references in
comments removed.

Thanks.

 include/linux/percpu-refcount.h | 24 ++++++++++++------------
 lib/percpu-refcount.c           | 37 +++++++++++++++++++------------------
 2 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index ee83251..5df6784 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -55,7 +55,7 @@ struct percpu_ref;
 typedef void (percpu_ref_func_t)(struct percpu_ref *);
 
 struct percpu_ref {
-	atomic_t		count;
+	atomic_long_t		count;
 	/*
 	 * The low bit of the pointer indicates whether the ref is in percpu
 	 * mode; if set, then get/put will manipulate the atomic_t.
@@ -97,7 +97,7 @@ static inline void percpu_ref_kill(struct percpu_ref *ref)
  * branches as it can't assume that @ref->pcpu_count is not NULL.
  */
 static inline bool __pcpu_ref_alive(struct percpu_ref *ref,
-				    unsigned __percpu **pcpu_countp)
+				    unsigned long __percpu **pcpu_countp)
 {
 	unsigned long pcpu_ptr = ACCESS_ONCE(ref->pcpu_count_ptr);
 
@@ -107,7 +107,7 @@ static inline bool __pcpu_ref_alive(struct percpu_ref *ref,
 	if (unlikely(pcpu_ptr & PCPU_REF_DEAD))
 		return false;
 
-	*pcpu_countp = (unsigned __percpu *)pcpu_ptr;
+	*pcpu_countp = (unsigned long __percpu *)pcpu_ptr;
 	return true;
 }
 
@@ -119,14 +119,14 @@ static inline bool __pcpu_ref_alive(struct percpu_ref *ref,
   */
 static inline void percpu_ref_get(struct percpu_ref *ref)
 {
-	unsigned __percpu *pcpu_count;
+	unsigned long __percpu *pcpu_count;
 
 	rcu_read_lock_sched();
 
 	if (__pcpu_ref_alive(ref, &pcpu_count))
 		this_cpu_inc(*pcpu_count);
 	else
-		atomic_inc(&ref->count);
+		atomic_long_inc(&ref->count);
 
 	rcu_read_unlock_sched();
 }
@@ -142,7 +142,7 @@ static inline void percpu_ref_get(struct percpu_ref *ref)
  */
 static inline bool percpu_ref_tryget(struct percpu_ref *ref)
 {
-	unsigned __percpu *pcpu_count;
+	unsigned long __percpu *pcpu_count;
 	int ret = false;
 
 	rcu_read_lock_sched();
@@ -151,7 +151,7 @@ static inline bool percpu_ref_tryget(struct percpu_ref *ref)
 		this_cpu_inc(*pcpu_count);
 		ret = true;
 	} else {
-		ret = atomic_inc_not_zero(&ref->count);
+		ret = atomic_long_inc_not_zero(&ref->count);
 	}
 
 	rcu_read_unlock_sched();
@@ -175,7 +175,7 @@ static inline bool percpu_ref_tryget(struct percpu_ref *ref)
  */
 static inline bool percpu_ref_tryget_live(struct percpu_ref *ref)
 {
-	unsigned __percpu *pcpu_count;
+	unsigned long __percpu *pcpu_count;
 	int ret = false;
 
 	rcu_read_lock_sched();
@@ -199,13 +199,13 @@ static inline bool percpu_ref_tryget_live(struct percpu_ref *ref)
  */
 static inline void percpu_ref_put(struct percpu_ref *ref)
 {
-	unsigned __percpu *pcpu_count;
+	unsigned long __percpu *pcpu_count;
 
 	rcu_read_lock_sched();
 
 	if (__pcpu_ref_alive(ref, &pcpu_count))
 		this_cpu_dec(*pcpu_count);
-	else if (unlikely(atomic_dec_and_test(&ref->count)))
+	else if (unlikely(atomic_long_dec_and_test(&ref->count)))
 		ref->release(ref);
 
 	rcu_read_unlock_sched();
@@ -219,11 +219,11 @@ static inline void percpu_ref_put(struct percpu_ref *ref)
  */
 static inline bool percpu_ref_is_zero(struct percpu_ref *ref)
 {
-	unsigned __percpu *pcpu_count;
+	unsigned long __percpu *pcpu_count;
 
 	if (__pcpu_ref_alive(ref, &pcpu_count))
 		return false;
-	return !atomic_read(&ref->count);
+	return !atomic_long_read(&ref->count);
 }
 
 #endif
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index 70d28c9..559ee0b 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -25,15 +25,15 @@
  * works.
  *
  * Converting to non percpu mode is done with some RCUish stuff in
- * percpu_ref_kill. Additionally, we need a bias value so that the atomic_t
- * can't hit 0 before we've added up all the percpu refs.
+ * percpu_ref_kill. Additionally, we need a bias value so that the
+ * atomic_long_t can't hit 0 before we've added up all the percpu refs.
  */
 
-#define PCPU_COUNT_BIAS		(1U << 31)
+#define PCPU_COUNT_BIAS		(1LU << (BITS_PER_LONG - 1))
 
-static unsigned __percpu *pcpu_count_ptr(struct percpu_ref *ref)
+static unsigned long __percpu *pcpu_count_ptr(struct percpu_ref *ref)
 {
-	return (unsigned __percpu *)(ref->pcpu_count_ptr & ~PCPU_REF_DEAD);
+	return (unsigned long __percpu *)(ref->pcpu_count_ptr & ~PCPU_REF_DEAD);
 }
 
 /**
@@ -43,7 +43,7 @@ static unsigned __percpu *pcpu_count_ptr(struct percpu_ref *ref)
  * @gfp: allocation mask to use
  *
  * Initializes the refcount in single atomic counter mode with a refcount of 1;
- * analagous to atomic_set(ref, 1).
+ * analagous to atomic_long_set(ref, 1).
  *
  * Note that @release must not sleep - it may potentially be called from RCU
  * callback context by percpu_ref_kill().
@@ -51,9 +51,9 @@ static unsigned __percpu *pcpu_count_ptr(struct percpu_ref *ref)
 int percpu_ref_init(struct percpu_ref *ref, percpu_ref_func_t *release,
 		    gfp_t gfp)
 {
-	atomic_set(&ref->count, 1 + PCPU_COUNT_BIAS);
+	atomic_long_set(&ref->count, 1 + PCPU_COUNT_BIAS);
 
-	ref->pcpu_count_ptr = (unsigned long)alloc_percpu_gfp(unsigned, gfp);
+	ref->pcpu_count_ptr = (unsigned long)alloc_percpu_gfp(unsigned long, gfp);
 	if (!ref->pcpu_count_ptr)
 		return -ENOMEM;
 
@@ -75,13 +75,13 @@ EXPORT_SYMBOL_GPL(percpu_ref_init);
  */
 void percpu_ref_reinit(struct percpu_ref *ref)
 {
-	unsigned __percpu *pcpu_count = pcpu_count_ptr(ref);
+	unsigned long __percpu *pcpu_count = pcpu_count_ptr(ref);
 	int cpu;
 
 	BUG_ON(!pcpu_count);
 	WARN_ON(!percpu_ref_is_zero(ref));
 
-	atomic_set(&ref->count, 1 + PCPU_COUNT_BIAS);
+	atomic_long_set(&ref->count, 1 + PCPU_COUNT_BIAS);
 
 	/*
 	 * Restore per-cpu operation.  smp_store_release() is paired with
@@ -109,7 +109,7 @@ EXPORT_SYMBOL_GPL(percpu_ref_reinit);
  */
 void percpu_ref_exit(struct percpu_ref *ref)
 {
-	unsigned __percpu *pcpu_count = pcpu_count_ptr(ref);
+	unsigned long __percpu *pcpu_count = pcpu_count_ptr(ref);
 
 	if (pcpu_count) {
 		free_percpu(pcpu_count);
@@ -121,14 +121,15 @@ EXPORT_SYMBOL_GPL(percpu_ref_exit);
 static void percpu_ref_kill_rcu(struct rcu_head *rcu)
 {
 	struct percpu_ref *ref = container_of(rcu, struct percpu_ref, rcu);
-	unsigned __percpu *pcpu_count = pcpu_count_ptr(ref);
-	unsigned count = 0;
+	unsigned long __percpu *pcpu_count = pcpu_count_ptr(ref);
+	unsigned long count = 0;
 	int cpu;
 
 	for_each_possible_cpu(cpu)
 		count += *per_cpu_ptr(pcpu_count, cpu);
 
-	pr_debug("global %i pcpu %i", atomic_read(&ref->count), (int) count);
+	pr_debug("global %ld pcpu %ld",
+		 atomic_long_read(&ref->count), (long)count);
 
 	/*
 	 * It's crucial that we sum the percpu counters _before_ adding the sum
@@ -143,11 +144,11 @@ static void percpu_ref_kill_rcu(struct rcu_head *rcu)
 	 * time is equivalent and saves us atomic operations:
 	 */
 
-	atomic_add((int) count - PCPU_COUNT_BIAS, &ref->count);
+	atomic_long_add((long)count - PCPU_COUNT_BIAS, &ref->count);
 
-	WARN_ONCE(atomic_read(&ref->count) <= 0,
-		  "percpu ref (%pf) <= 0 (%i) after killed",
-		  ref->release, atomic_read(&ref->count));
+	WARN_ONCE(atomic_long_read(&ref->count) <= 0,
+		  "percpu ref (%pf) <= 0 (%ld) after killed",
+		  ref->release, atomic_long_read(&ref->count));
 
 	/* @ref is viewed as dead on all CPUs, send out kill confirmation */
 	if (ref->confirm_kill)
-- 
1.9.3

