Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbaFSCVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 22:21:00 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:43195 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbaFSCU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 22:20:59 -0400
Date: Wed, 18 Jun 2014 22:20:55 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org, kmo@daterainc.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/6] percpu-refcount: implement percpu_ref_reinit() and
 percpu_ref_is_zero()
Message-ID: <20140619022055.GD20100@mtj.dyndns.org>
References: <1403053685-28240-1-git-send-email-tj@kernel.org>
 <1403053685-28240-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403053685-28240-7-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that explicit invocation of percpu_ref_exit() is necessary to free
the percpu counter, we can implement percpu_ref_reinit() which
reinitializes a released percpu_ref.  This can be used implement
scalable gating switch which can be drained and then re-opened without
worrying about memory allocation failures.

percpu_ref_is_zero() is added to be used in a sanity check in
percpu_ref_exit().  As this function will be useful for other purposes
too, make it a public interface.

v2: Use smp_read_barrier_depends() instead of smp_load_acquire().  We
    only need data dep barrier and smp_load_acquire() is stronger and
    heavier on some archs.  Spotted by Lai Jiangshan.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/percpu-refcount.h |   19 +++++++++++++++++++
 lib/percpu-refcount.c           |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -67,6 +67,7 @@ struct percpu_ref {
 
 int __must_check percpu_ref_init(struct percpu_ref *ref,
 				 percpu_ref_func_t *release);
+void percpu_ref_reinit(struct percpu_ref *ref);
 void percpu_ref_exit(struct percpu_ref *ref);
 void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
 				 percpu_ref_func_t *confirm_kill);
@@ -99,6 +100,9 @@ static inline bool __pcpu_ref_alive(stru
 {
 	unsigned long pcpu_ptr = ACCESS_ONCE(ref->pcpu_count_ptr);
 
+	/* paired with smp_store_release() in percpu_ref_reinit() */
+	smp_read_barrier_depends();
+
 	if (unlikely(pcpu_ptr & PCPU_REF_DEAD))
 		return false;
 
@@ -206,4 +210,19 @@ static inline void percpu_ref_put(struct
 	rcu_read_unlock_sched();
 }
 
+/**
+ * percpu_ref_is_zero - test whether a percpu refcount reached zero
+ * @ref: percpu_ref to test
+ *
+ * Returns %true if @ref reached zero.
+ */
+static inline bool percpu_ref_is_zero(struct percpu_ref *ref)
+{
+	unsigned __percpu *pcpu_count;
+
+	if (__pcpu_ref_alive(ref, &pcpu_count))
+		return false;
+	return !atomic_read(&ref->count);
+}
+
 #endif
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -61,6 +61,41 @@ int percpu_ref_init(struct percpu_ref *r
 EXPORT_SYMBOL_GPL(percpu_ref_init);
 
 /**
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
+	unsigned __percpu *pcpu_count = pcpu_count_ptr(ref);
+	int cpu;
+
+	BUG_ON(!pcpu_count);
+	WARN_ON(!percpu_ref_is_zero(ref));
+
+	atomic_set(&ref->count, 1 + PCPU_COUNT_BIAS);
+
+	/*
+	 * Restore per-cpu operation.  smp_store_release() is paired with
+	 * smp_load_acquire() in __pcpu_ref_alive() and guarantees that the
+	 * zeroing is visible to all percpu accesses which can see the
+	 * following PCPU_REF_DEAD clearing.
+	 */
+	for_each_possible_cpu(cpu)
+		*per_cpu_ptr(pcpu_count, cpu) = 0;
+
+	smp_store_release(&ref->pcpu_count_ptr,
+			  ref->pcpu_count_ptr & ~PCPU_REF_DEAD);
+}
+EXPORT_SYMBOL_GPL(percpu_ref_reinit);
+
+/**
  * percpu_ref_exit - undo percpu_ref_init()
  * @ref: percpu_ref to exit
  *
