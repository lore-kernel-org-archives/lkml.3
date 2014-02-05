Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbaBEWKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 17:10:16 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:49676 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbaBEWKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 17:10:09 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 01/51] CPU hotplug: Provide lockless versions of callback
 registration functions
To: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
Cc: mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>, Toshi Kani <toshi.kani@hp.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Thu, 06 Feb 2014 03:34:48 +0530
Message-ID: <20140205220447.19080.9460.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020522-9574-0000-0000-00000BCF3507
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following method of CPU hotplug callback registration is not safe
due to the possibility of an ABBA deadlock involving the cpu_add_remove_lock
and the cpu_hotplug.lock.

	get_online_cpus();

	for_each_online_cpu(cpu)
		init_cpu(cpu);

	register_cpu_notifier(&foobar_cpu_notifier);

	put_online_cpus();

The deadlock is shown below:

          CPU 0                                         CPU 1
          -----                                         -----

   Acquire cpu_hotplug.lock
   [via get_online_cpus()]

                                              CPU online/offline operation
                                              takes cpu_add_remove_lock
                                              [via cpu_maps_update_begin()]


   Try to acquire
   cpu_add_remove_lock
   [via register_cpu_notifier()]


                                              CPU online/offline operation
                                              tries to acquire cpu_hotplug.lock
                                              [via cpu_hotplug_begin()]


                            *** DEADLOCK! ***

The problem here is that callback registration takes the locks in one order
whereas the CPU hotplug operations take the same locks in the opposite order.
To avoid this issue and to provide a race-free method to register CPU hotplug
callbacks (along with initialization of already online CPUs), introduce new
variants of the callback registration APIs that simply register the callbacks
without holding the cpu_add_remove_lock during the registration. That way,
we can avoid the ABBA scenario. However, we will need to hold the
cpu_add_remove_lock throughout the entire critical section, to protect updates
to the callback/notifier chain.

This can be achieved by writing the callback registration code as follows:

	cpu_maps_update_begin();

	for_each_online_cpu(cpu)
		init_cpu(cpu);

	/* This doesn't take the cpu_add_remove_lock */
	__register_cpu_notifier(&foobar_cpu_notifier);

	cpu_maps_update_done();

Note that we can't use get_online_cpus() here instead of cpu_maps_update_begin()
because the cpu_hotplug.lock is dropped during the invocation of CPU_POST_DEAD
notifiers, and hence get_online_cpus() cannot provide the necessary
synchronization to protect the callback/notifier chains against concurrent
reads and writes. On the other hand, since the cpu_add_remove_lock protects
the entire hotplug operation (including CPU_POST_DEAD), we can use
cpu_maps_update_begin/done() to guarantee proper synchronization.

Also, since cpu_maps_update_begin/done() is like a super-set of
get/put_online_cpus(), the former naturally protects the critical sections
from concurrent hotplug operations.

So, introduce the lockless variants of un/register_cpu_notifier() and also
export the cpu_maps_update_begin/done() APIs for use by modules. This way,
we provide a race-free way to register hotplug callbacks as well as perform
initialization for the CPUs that are already online.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/cpu.h |   36 ++++++++++++++++++++++++++++++++++++
 kernel/cpu.c        |   20 ++++++++++++++++++--
 2 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 03e235ad..eb97e37 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -122,26 +122,46 @@ enum {
 		{ .notifier_call = fn, .priority = pri };	\
 	register_cpu_notifier(&fn##_nb);			\
 }
+
+#define __cpu_notifier(fn, pri) {				\
+	static struct notifier_block fn##_nb =			\
+		{ .notifier_call = fn, .priority = pri };	\
+	__register_cpu_notifier(&fn##_nb);			\
+}
 #else /* #if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE) */
 #define cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
+#define __cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 #endif /* #else #if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE) */
+
 #ifdef CONFIG_HOTPLUG_CPU
 extern int register_cpu_notifier(struct notifier_block *nb);
+extern int __register_cpu_notifier(struct notifier_block *nb);
 extern void unregister_cpu_notifier(struct notifier_block *nb);
+extern void __unregister_cpu_notifier(struct notifier_block *nb);
 #else
 
 #ifndef MODULE
 extern int register_cpu_notifier(struct notifier_block *nb);
+extern int __register_cpu_notifier(struct notifier_block *nb);
 #else
 static inline int register_cpu_notifier(struct notifier_block *nb)
 {
 	return 0;
 }
+
+static inline int __register_cpu_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
 #endif
 
 static inline void unregister_cpu_notifier(struct notifier_block *nb)
 {
 }
+
+static inline void __unregister_cpu_notifier(struct notifier_block *nb)
+{
+}
 #endif
 
 int cpu_up(unsigned int cpu);
@@ -152,16 +172,26 @@ extern void cpu_maps_update_done(void);
 #else	/* CONFIG_SMP */
 
 #define cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
+#define __cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 
 static inline int register_cpu_notifier(struct notifier_block *nb)
 {
 	return 0;
 }
 
+static inline int __register_cpu_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+
 static inline void unregister_cpu_notifier(struct notifier_block *nb)
 {
 }
 
+static inline void __unregister_cpu_notifier(struct notifier_block *nb)
+{
+}
+
 static inline void cpu_maps_update_begin(void)
 {
 }
@@ -183,8 +213,11 @@ extern void put_online_cpus(void);
 extern void cpu_hotplug_disable(void);
 extern void cpu_hotplug_enable(void);
 #define hotcpu_notifier(fn, pri)	cpu_notifier(fn, pri)
+#define __hotcpu_notifier(fn, pri)	__cpu_notifier(fn, pri)
 #define register_hotcpu_notifier(nb)	register_cpu_notifier(nb)
+#define __register_hotcpu_notifier(nb)	__register_cpu_notifier(nb)
 #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
+#define __unregister_hotcpu_notifier(nb)	__unregister_cpu_notifier(nb)
 void clear_tasks_mm_cpumask(int cpu);
 int cpu_down(unsigned int cpu);
 
@@ -197,9 +230,12 @@ static inline void cpu_hotplug_done(void) {}
 #define cpu_hotplug_disable()	do { } while (0)
 #define cpu_hotplug_enable()	do { } while (0)
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
+#define __hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 /* These aren't inline functions due to a GCC bug. */
 #define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
+#define __register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
 #define unregister_hotcpu_notifier(nb)	({ (void)(nb); })
+#define __unregister_hotcpu_notifier(nb)	({ (void)(nb); })
 #endif		/* CONFIG_HOTPLUG_CPU */
 
 #ifdef CONFIG_PM_SLEEP_SMP
diff --git a/kernel/cpu.c b/kernel/cpu.c
index deff2e6..12a3a74 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -27,18 +27,22 @@
 static DEFINE_MUTEX(cpu_add_remove_lock);
 
 /*
- * The following two API's must be used when attempting
- * to serialize the updates to cpu_online_mask, cpu_present_mask.
+ * The following two API's must be used when attempting to serialize
+ * the updates to cpu_online_mask, cpu_present_mask. Also, they must
+ * be used to protect CPU hotplug callback (un)registration performed
+ * using __register_cpu_notifier() or __unregister_cpu_notifier().
  */
 void cpu_maps_update_begin(void)
 {
 	mutex_lock(&cpu_add_remove_lock);
 }
+EXPORT_SYMBOL(cpu_maps_update_begin);
 
 void cpu_maps_update_done(void)
 {
 	mutex_unlock(&cpu_add_remove_lock);
 }
+EXPORT_SYMBOL(cpu_maps_update_done);
 
 static RAW_NOTIFIER_HEAD(cpu_chain);
 
@@ -166,6 +170,11 @@ int __ref register_cpu_notifier(struct notifier_block *nb)
 	return ret;
 }
 
+int __ref __register_cpu_notifier(struct notifier_block *nb)
+{
+	return raw_notifier_chain_register(&cpu_chain, nb);
+}
+
 static int __cpu_notify(unsigned long val, void *v, int nr_to_call,
 			int *nr_calls)
 {
@@ -189,6 +198,7 @@ static void cpu_notify_nofail(unsigned long val, void *v)
 	BUG_ON(cpu_notify(val, v));
 }
 EXPORT_SYMBOL(register_cpu_notifier);
+EXPORT_SYMBOL(__register_cpu_notifier);
 
 void __ref unregister_cpu_notifier(struct notifier_block *nb)
 {
@@ -198,6 +208,12 @@ void __ref unregister_cpu_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL(unregister_cpu_notifier);
 
+void __ref __unregister_cpu_notifier(struct notifier_block *nb)
+{
+	raw_notifier_chain_unregister(&cpu_chain, nb);
+}
+EXPORT_SYMBOL(__unregister_cpu_notifier);
+
 /**
  * clear_tasks_mm_cpumask - Safely clear tasks' mm_cpumask for a CPU
  * @cpu: a CPU id

