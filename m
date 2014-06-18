Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964852AbaFRBJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 21:09:05 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:65193 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932733AbaFRBIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 21:08:14 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org, kmo@daterainc.com
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/6] percpu-refcount: add helpers for ->percpu_count accesses
Date: Tue, 17 Jun 2014 21:08:02 -0400
Message-Id: <1403053685-28240-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403053685-28240-1-git-send-email-tj@kernel.org>
References: <1403053685-28240-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* All four percpu_ref_*() operations implemented in the header file
  perform the same operation to determine whether the percpu_ref is
  alive and extract the percpu pointer.  Factor out the common logic
  into __pcpu_ref_alive().  This doesn't change the generated code.

* There are a couple places in percpu-refcount.c which masks out
  PCPU_REF_DEAD to obtain the percpu pointer.  Factor it out into
  pcpu_count_ptr().

* The above changes make the WARN_ON_ONCE() conditional at the top of
  percpu_ref_kill_and_confirm() the only user of REF_STATUS().  Test
  PCPU_REF_DEAD directly and remove REF_STATUS().

This patch doesn't introduce any functional change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 include/linux/percpu-refcount.h | 35 +++++++++++++++++++++--------------
 lib/percpu-refcount.c           | 17 +++++++++--------
 2 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index bfdeb0d4..b62a4ee 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -88,10 +88,25 @@ static inline void percpu_ref_kill(struct percpu_ref *ref)
 	return percpu_ref_kill_and_confirm(ref, NULL);
 }
 
-#define PCPU_REF_PTR		0
 #define PCPU_REF_DEAD		1
 
-#define REF_STATUS(count)	(((unsigned long) count) & PCPU_REF_DEAD)
+/*
+ * Internal helper.  Don't use outside percpu-refcount proper.  The
+ * function doesn't return the pointer and let the caller test it for NULL
+ * because doing so forces the compiler to generate two conditional
+ * branches as it can't assume that @ref->pcpu_count is not NULL.
+ */
+static inline bool __pcpu_ref_alive(struct percpu_ref *ref,
+				    unsigned __percpu **pcpu_countp)
+{
+	unsigned long pcpu_ptr = (unsigned long)ACCESS_ONCE(ref->pcpu_count);
+
+	if (unlikely(pcpu_ptr & PCPU_REF_DEAD))
+		return false;
+
+	*pcpu_countp = (unsigned __percpu *)pcpu_ptr;
+	return true;
+}
 
 /**
  * percpu_ref_get - increment a percpu refcount
@@ -105,9 +120,7 @@ static inline void percpu_ref_get(struct percpu_ref *ref)
 
 	rcu_read_lock_sched();
 
-	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
-
-	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR))
+	if (__pcpu_ref_alive(ref, &pcpu_count))
 		this_cpu_inc(*pcpu_count);
 	else
 		atomic_inc(&ref->count);
@@ -131,9 +144,7 @@ static inline bool percpu_ref_tryget(struct percpu_ref *ref)
 
 	rcu_read_lock_sched();
 
-	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
-
-	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR)) {
+	if (__pcpu_ref_alive(ref, &pcpu_count)) {
 		this_cpu_inc(*pcpu_count);
 		ret = true;
 	} else {
@@ -166,9 +177,7 @@ static inline bool percpu_ref_tryget_live(struct percpu_ref *ref)
 
 	rcu_read_lock_sched();
 
-	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
-
-	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR)) {
+	if (__pcpu_ref_alive(ref, &pcpu_count)) {
 		this_cpu_inc(*pcpu_count);
 		ret = true;
 	}
@@ -191,9 +200,7 @@ static inline void percpu_ref_put(struct percpu_ref *ref)
 
 	rcu_read_lock_sched();
 
-	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
-
-	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR))
+	if (__pcpu_ref_alive(ref, &pcpu_count))
 		this_cpu_dec(*pcpu_count);
 	else if (unlikely(atomic_dec_and_test(&ref->count)))
 		ref->release(ref);
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index 17bce2b..087f1a0 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -31,6 +31,11 @@
 
 #define PCPU_COUNT_BIAS		(1U << 31)
 
+static unsigned __percpu *pcpu_count_ptr(struct percpu_ref *ref)
+{
+	return (unsigned __percpu *)((unsigned long)ref->pcpu_count & ~PCPU_REF_DEAD);
+}
+
 /**
  * percpu_ref_init - initialize a percpu refcount
  * @ref: percpu_ref to initialize
@@ -74,7 +79,7 @@ EXPORT_SYMBOL_GPL(percpu_ref_init);
  */
 void percpu_ref_cancel_init(struct percpu_ref *ref)
 {
-	unsigned __percpu *pcpu_count = ref->pcpu_count;
+	unsigned __percpu *pcpu_count = pcpu_count_ptr(ref);
 	int cpu;
 
 	WARN_ON_ONCE(atomic_read(&ref->count) != 1 + PCPU_COUNT_BIAS);
@@ -82,7 +87,7 @@ void percpu_ref_cancel_init(struct percpu_ref *ref)
 	if (pcpu_count) {
 		for_each_possible_cpu(cpu)
 			WARN_ON_ONCE(*per_cpu_ptr(pcpu_count, cpu));
-		free_percpu(ref->pcpu_count);
+		free_percpu(pcpu_count);
 	}
 }
 EXPORT_SYMBOL_GPL(percpu_ref_cancel_init);
@@ -90,14 +95,10 @@ EXPORT_SYMBOL_GPL(percpu_ref_cancel_init);
 static void percpu_ref_kill_rcu(struct rcu_head *rcu)
 {
 	struct percpu_ref *ref = container_of(rcu, struct percpu_ref, rcu);
-	unsigned __percpu *pcpu_count = ref->pcpu_count;
+	unsigned __percpu *pcpu_count = pcpu_count_ptr(ref);
 	unsigned count = 0;
 	int cpu;
 
-	/* Mask out PCPU_REF_DEAD */
-	pcpu_count = (unsigned __percpu *)
-		(((unsigned long) pcpu_count) & ~PCPU_REF_DEAD);
-
 	for_each_possible_cpu(cpu)
 		count += *per_cpu_ptr(pcpu_count, cpu);
 
@@ -152,7 +153,7 @@ static void percpu_ref_kill_rcu(struct rcu_head *rcu)
 void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
 				 percpu_ref_func_t *confirm_kill)
 {
-	WARN_ONCE(REF_STATUS(ref->pcpu_count) == PCPU_REF_DEAD,
+	WARN_ONCE((unsigned long)ref->pcpu_count & PCPU_REF_DEAD,
 		  "percpu_ref_kill() called more than once!\n");
 
 	ref->pcpu_count = (unsigned __percpu *)
-- 
1.9.3

