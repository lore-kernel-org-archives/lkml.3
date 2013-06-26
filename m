Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab3FZNmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:42:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16203 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3FZNmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:42:17 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=KZaNYjsK-MgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=vxuSCLhWTWQA:10 a=vsRtZte0DsJuhYkqPIYA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1372254133.18733.252.camel@gandalf.local.home>
Subject: [RFC][PATCH RT] rcu,rt: Allow rcu_read_lock_sched() to schedule
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>
Date: Wed, 26 Jun 2013 09:42:13 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at the 3.10 workqueue code, there's new code that adds
local_irq_disable() around places that call spin locks which will turn
into rt_mutexes for -rt. Reading the change log to why those
local_irq_*() calls were added, it seems to just be to synchronize with
synchronize_sched(). Talking with Tejun Heo, he may let me change those
to rcu_read_lock_sched() as that is a more appropriate API for the
purpose.

But that does not solve the -rt issue because even in -rt,
rcu_read_lock_sched() disables preemption, which brings us to the
purpose of this patch, to allow rcu_read_lock_sched() to preempt in -rt.

To allow rcu_read_lock_sched() sections to preempt in -rt, instead of
disabling preemption, it will grab a local_lock(). Then the
synchronize_sched() will grab all CPUs local_locks() and release them.
After that, it still does the normal synchronize_sched() as there may be
places that still disable preemption or irqs that it needs to
synchronize with. By grabbing all the locks and releasing them, it will
properly synchronize with those that use the locks instead of disabling
preemption or interrupts.

Note: The rcu_read_lock_sched_notrace() version still only disables
preemption, because they are used for lockdep and tracing, which require
real preemption disabling and not mutexes.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-rt.git/include/linux/rcupdate.h
===================================================================
--- linux-rt.git.orig/include/linux/rcupdate.h
+++ linux-rt.git/include/linux/rcupdate.h
@@ -36,6 +36,7 @@
 #include <linux/types.h>
 #include <linux/cache.h>
 #include <linux/spinlock.h>
+#include <linux/locallock.h>
 #include <linux/threads.h>
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
@@ -870,6 +871,28 @@ static inline void rcu_read_unlock_bh(vo
 	local_bh_enable();
 }
 
+/* asm-offsets.c gets confused with local_lock here */
+#if defined(CONFIG_PREEMPT_RT_FULL)
+DECLARE_LOCAL_IRQ_LOCK(rcu_sched_lock);
+static inline void rcu_read_lock_sched_disable(void)
+{
+	local_lock(rcu_sched_lock);
+}
+static inline void rcu_read_lock_sched_enable(void)
+{
+	local_unlock(rcu_sched_lock);
+}
+#else
+static inline void rcu_read_lock_sched_disable(void)
+{
+	preempt_disable();
+}
+static inline void rcu_read_lock_sched_enable(void)
+{
+	preempt_enable();
+}
+#endif
+
 /**
  * rcu_read_lock_sched() - mark the beginning of a RCU-sched critical section
  *
@@ -885,7 +908,7 @@ static inline void rcu_read_unlock_bh(vo
  */
 static inline void rcu_read_lock_sched(void)
 {
-	preempt_disable();
+	rcu_read_lock_sched_disable();
 	__acquire(RCU_SCHED);
 	rcu_lock_acquire(&rcu_sched_lock_map);
 	rcu_lockdep_assert(!rcu_is_cpu_idle(),
@@ -910,7 +933,7 @@ static inline void rcu_read_unlock_sched
 			   "rcu_read_unlock_sched() used illegally while idle");
 	rcu_lock_release(&rcu_sched_lock_map);
 	__release(RCU_SCHED);
-	preempt_enable();
+	rcu_read_lock_sched_enable();
 }
 
 /* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
Index: linux-rt.git/kernel/rcutree.c
===================================================================
--- linux-rt.git.orig/kernel/rcutree.c
+++ linux-rt.git/kernel/rcutree.c
@@ -2491,6 +2491,31 @@ static inline int rcu_blocking_is_gp(voi
 	return ret;
 }
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+DEFINE_LOCAL_IRQ_LOCK(rcu_sched_lock);
+/*
+ * Real-time allows for synchronize sched to sleep but not migrate.
+ * This is done via the local locks. When calling synchronize_sched(),
+ * all the local locks need to be taken and released. This will ensure
+ * that all users of rcu_read_lock_sched() will be out of their critical
+ * sections at the completion of this function. synchronize_sched() will
+ * still perform the normal RCU sched operations to synchronize with
+ * locations that use disabling preemption or interrupts.
+ */
+static void rcu_synchronize_sched_rt(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		spin_lock(&per_cpu(rcu_sched_lock, cpu).lock);
+		spin_unlock(&per_cpu(rcu_sched_lock, cpu).lock);
+	}
+}
+#else
+static inline void rcu_synchronize_sched_rt(void)
+{
+}
+#endif
 /**
  * synchronize_sched - wait until an rcu-sched grace period has elapsed.
  *
@@ -2538,6 +2563,9 @@ void synchronize_sched(void)
 			   !lock_is_held(&rcu_lock_map) &&
 			   !lock_is_held(&rcu_sched_lock_map),
 			   "Illegal synchronize_sched() in RCU-sched read-side critical section");
+
+	rcu_synchronize_sched_rt();
+
 	if (rcu_blocking_is_gp())
 		return;
 	if (rcu_expedited)


