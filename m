Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbaIWFzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 01:55:25 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:57333 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaIWFzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 01:55:23 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: kmo@daterainc.com, axboe@kernel.dk, hch@infradead.org, hannes@cmpxchg.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/9] percpu_ref: relocate percpu_ref_reinit()
Date: Tue, 23 Sep 2014 01:55:10 -0400
Message-Id: <1411451718-17807-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411451718-17807-1-git-send-email-tj@kernel.org>
References: <1411451718-17807-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu_ref is gonna go through restructuring.  Move
percpu_ref_reinit() after percpu_ref_kill_and_confirm().  This will
make later changes easier to follow and result in cleaner
organization.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <kmo@daterainc.com>
---
 include/linux/percpu-refcount.h |  2 +-
 lib/percpu-refcount.c           | 70 ++++++++++++++++++++---------------------
 2 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 5df6784..f015f13 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -68,10 +68,10 @@ struct percpu_ref {
 
 int __must_check percpu_ref_init(struct percpu_ref *ref,
 				 percpu_ref_func_t *release, gfp_t gfp);
-void percpu_ref_reinit(struct percpu_ref *ref);
 void percpu_ref_exit(struct percpu_ref *ref);
 void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
 				 percpu_ref_func_t *confirm_kill);
+void percpu_ref_reinit(struct percpu_ref *ref);
 
 /**
  * percpu_ref_kill - drop the initial ref
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index 559ee0b..070dab5 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -63,41 +63,6 @@ int percpu_ref_init(struct percpu_ref *ref, percpu_ref_func_t *release,
 EXPORT_SYMBOL_GPL(percpu_ref_init);
 
 /**
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
-{
-	unsigned long __percpu *pcpu_count = pcpu_count_ptr(ref);
-	int cpu;
-
-	BUG_ON(!pcpu_count);
-	WARN_ON(!percpu_ref_is_zero(ref));
-
-	atomic_long_set(&ref->count, 1 + PCPU_COUNT_BIAS);
-
-	/*
-	 * Restore per-cpu operation.  smp_store_release() is paired with
-	 * smp_read_barrier_depends() in __pcpu_ref_alive() and guarantees
-	 * that the zeroing is visible to all percpu accesses which can see
-	 * the following PCPU_REF_DEAD clearing.
-	 */
-	for_each_possible_cpu(cpu)
-		*per_cpu_ptr(pcpu_count, cpu) = 0;
-
-	smp_store_release(&ref->pcpu_count_ptr,
-			  ref->pcpu_count_ptr & ~PCPU_REF_DEAD);
-}
-EXPORT_SYMBOL_GPL(percpu_ref_reinit);
-
-/**
  * percpu_ref_exit - undo percpu_ref_init()
  * @ref: percpu_ref to exit
  *
@@ -189,3 +154,38 @@ void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
 	call_rcu_sched(&ref->rcu, percpu_ref_kill_rcu);
 }
 EXPORT_SYMBOL_GPL(percpu_ref_kill_and_confirm);
+
+/**
+ * percpu_ref_reinit - re-initialize a percpu refcount
+ * @ref: perpcu_ref to re-initialize
+ *
+ * Re-initialize @ref so that it's in the same state as when it finished
+ * percpu_ref_init().  @ref must have been initialized successfully, killed
+ * and reached 0 but not exited.
+ *
+ * Note that percpu_ref_tryget[_live]() are safe to perform on @ref while
+ * this function is in progress.
+ */
+void percpu_ref_reinit(struct percpu_ref *ref)
+{
+	unsigned long __percpu *pcpu_count = pcpu_count_ptr(ref);
+	int cpu;
+
+	BUG_ON(!pcpu_count);
+	WARN_ON(!percpu_ref_is_zero(ref));
+
+	atomic_long_set(&ref->count, 1 + PCPU_COUNT_BIAS);
+
+	/*
+	 * Restore per-cpu operation.  smp_store_release() is paired with
+	 * smp_read_barrier_depends() in __pcpu_ref_alive() and guarantees
+	 * that the zeroing is visible to all percpu accesses which can see
+	 * the following PCPU_REF_DEAD clearing.
+	 */
+	for_each_possible_cpu(cpu)
+		*per_cpu_ptr(pcpu_count, cpu) = 0;
+
+	smp_store_release(&ref->pcpu_count_ptr,
+			  ref->pcpu_count_ptr & ~PCPU_REF_DEAD);
+}
+EXPORT_SYMBOL_GPL(percpu_ref_reinit);
-- 
1.9.3

