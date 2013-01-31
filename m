Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab3AaMLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:11:30 -0500
Received: from www.linutronix.de ([62.245.132.108]:55881 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab3AaMLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:20 -0500
Message-Id: <20130131120742.098044736@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:19 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 09/40] cpu: hotplug: Implement setup/removal interface
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline;
 filename=cpu-hotplug-implement-registration-interface.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement function which allow to setup/remove hotplug state
callbacks.

The default behaviour for setup is to call the startup function for
this state for (or on) all cpus which have a hotplug state >= the
installed state.

The default behaviour for removal is to call the teardown function for
this state for (or on) all cpus which have a hotplug state >= the
installed state.

For both setup and remove helper functions are provided, which prevent
the core to issue the callbacks. This simplifies the conversion of
existing hotplug notifiers.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/cpu.h        |    1 
 include/linux/cpuhotplug.h |   70 +++++++++++++++++
 kernel/cpu.c               |  185 ++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 255 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/cpu.h
===================================================================
--- linux-2.6.orig/include/linux/cpu.h
+++ linux-2.6/include/linux/cpu.h
@@ -17,6 +17,7 @@
 #include <linux/node.h>
 #include <linux/compiler.h>
 #include <linux/cpumask.h>
+#include <linux/cpuhotplug.h>
 
 struct device;
 
Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -17,4 +17,74 @@ enum cpuhp_states {
 	CPUHP_NOTIFY_DOWN_PREPARE,
 	CPUHP_MAX,
 };
+
+int __cpuhp_setup_state(enum cpuhp_states state, bool invoke,
+			int (*startup)(unsigned int cpu),
+			int (*teardown)(unsigned int cpu));
+
+/**
+ * cpuhp_setup_state - Setup hotplug state callbacks with calling the callbacks
+ * @state:	The state for which the calls are installed
+ * @startup:	startup callback function
+ * @teardown:	teardown callback function
+ *
+ * Installs the callback functions and invokes the startup callback on
+ * the present cpus which have already reached the @state.
+ */
+static inline int
+cpuhp_setup_state(enum cpuhp_states state, int (*startup)(unsigned int cpu),
+		  int (*teardown)(unsigned int cpu))
+{
+	return __cpuhp_setup_state(state, true, startup, teardown);
+}
+
+/**
+ * cpuhp_setup_state_nocalls - Setup hotplug state callbacks without calling the callbacks
+ * @state:	The state for which the calls are installed
+ * @startup:	startup callback function
+ * @teardown:	teardown callback function
+ *
+ * No calls are executed. NOP if SMP=n or HOTPLUG_CPU=n
+ */
+#if defined(CONFIG_SMP) && defined(CONFIG_HOTPLUG_CPU)
+static inline int
+cpuhp_setup_state_nocalls(enum cpuhp_states state,
+			 int (*startup)(unsigned int cpu),
+			 int (*teardown)(unsigned int cpu))
+{
+	return __cpuhp_setup_state(state, false, startup, teardown);
+}
+#else
+static inline int
+cpuhp_setup_state_nocalls(enum cpuhp_states state,
+			 int (*startup)(unsigned int cpu),
+			 int (*teardown)(unsigned int cpu))
+{
+	return 0;
+}
+#endif
+
+void __cpuhp_remove_state(enum cpuhp_states state, bool invoke);
+
+/**
+ * cpuhp_remove_state - Remove hotplug state callbacks and invoke the teardown
+ * @state:	The state for which the calls are removed
+ *
+ * Removes the callback functions and invokes the teardown callback on
+ * the present cpus which have already reached the @state.
+ */
+static inline void cpuhp_remove_state(enum cpuhp_states state)
+{
+	__cpuhp_remove_state(state, true);
+}
+
+/**
+ * cpuhp_remove_state_nocalls - Remove hotplug state callbacks without invoking teardown
+ * @state:	The state for which the calls are removed
+ */
+static inline void cpuhp_remove_state_nocalls(enum cpuhp_states state)
+{
+	__cpuhp_remove_state(state, false);
+}
+
 #endif
Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -19,7 +19,6 @@
 #include <linux/mutex.h>
 #include <linux/gfp.h>
 #include <linux/suspend.h>
-#include <linux/cpuhotplug.h>
 
 #include "smpboot.h"
 
@@ -804,6 +803,190 @@ static struct cpuhp_step cpuhp_ap_states
 	},
 };
 
+/* Sanity check for callbacks */
+static int cpuhp_cb_check(enum cpuhp_states state)
+{
+	if (state <= CPUHP_OFFLINE || state >= CPUHP_MAX)
+		return -EINVAL;
+	return 0;
+}
+
+static bool cpuhp_is_ap_state(enum cpuhp_states state)
+{
+	return (state > CPUHP_AP_OFFLINE && state < CPUHP_AP_MAX);
+}
+
+static void cpuhp_store_callbacks(enum cpuhp_states state,
+				  int (*startup)(unsigned int cpu),
+				  int (*teardown)(unsigned int cpu))
+{
+	/* (Un)Install the callbacks for further cpu hotplug operations */
+	struct cpuhp_step *sp;
+
+	sp = cpuhp_is_ap_state(state) ? cpuhp_ap_states : cpuhp_bp_states;
+	sp[state].startup = startup;
+	sp[state].teardown = teardown;
+}
+
+static void *cpuhp_get_teardown_cb(enum cpuhp_states state)
+{
+	/* (Un)Install the callbacks for further cpu hotplug operations */
+	struct cpuhp_step *sp;
+
+	sp = cpuhp_is_ap_state(state) ? cpuhp_ap_states : cpuhp_bp_states;
+	return sp[state].teardown;
+}
+
+/* Helper function to run callback on the target cpu */
+static void cpuhp_on_cpu_cb(void *__cb)
+{
+	int (*cb)(unsigned int cpu) = __cb;
+
+	BUG_ON(cb(smp_processor_id()));
+}
+
+/*
+ * Call the startup/teardown function for a step either on the AP or
+ * on the current CPU.
+ */
+static int cpuhp_issue_call(int cpu, enum cpuhp_states state,
+			    int (*cb)(unsigned int), bool bringup)
+{
+	int ret;
+
+	if (!cb)
+		return 0;
+
+	if (cpuhp_is_ap_state(state)) {
+		/*
+		 * Note, that a function called on the AP is not
+		 * allowed to fail.
+		 */
+		smp_call_function_single(cpu, cpuhp_on_cpu_cb, cb, 1);
+		return 0;
+	}
+
+	/*
+	 * The non AP bound callbacks can fail on bringup. On teardown
+	 * e.g. module removal we crash for now.
+	 */
+	ret = cb(cpu);
+	BUG_ON(ret && !bringup);
+	return ret;
+}
+
+/*
+ * Called from __cpuhp_setup_state on a recoverable failure.
+ *
+ * Note: The teardown callbacks for rollback are not allowed to fail!
+ */
+static void cpuhp_rollback_install(int failedcpu, enum cpuhp_states state,
+				   int (*teardown)(unsigned int cpu))
+{
+	int cpu;
+
+	if (!teardown)
+		return;
+
+	/* Roll back the already executed steps on the other cpus */
+	for_each_present_cpu(cpu) {
+		int cpustate = per_cpu(cpuhp_state, cpu);
+
+		if (cpu >= failedcpu)
+			break;
+
+		/* Did we invoke the startup call on that cpu ? */
+		if (cpustate >= state)
+			cpuhp_issue_call(cpu, state, teardown, false);
+	}
+}
+
+/**
+ * __cpuhp_setup_state - Setup the callbacks for an hotplug machine state
+ * @state:	The state to setup
+ * @invoke:	If true, the startup function is invoked for cpus where
+ *		cpu state >= @state
+ * @startup:	startup callback function
+ * @teardown:	teardown callback function
+ *
+ * Returns 0 if successful, otherwise a proper error code
+ */
+int __cpuhp_setup_state(enum cpuhp_states state, bool invoke,
+			int (*startup)(unsigned int cpu),
+			int (*teardown)(unsigned int cpu))
+{
+	int cpu, ret = 0;
+
+	if (cpuhp_cb_check(state))
+		return -EINVAL;
+
+	get_online_cpus();
+
+	if (!invoke || !startup)
+		goto install;
+
+	/*
+	 * Try to call the startup callback for each present cpu
+	 * depending on the hotplug state of the cpu.
+	 */
+	for_each_present_cpu(cpu) {
+		int ret, cpustate = per_cpu(cpuhp_state, cpu);
+
+		if (cpustate < state)
+			continue;
+
+		ret = cpuhp_issue_call(cpu, state, startup, true);
+		if (ret) {
+			cpuhp_rollback_install(cpu, state, teardown);
+			goto out;
+		}
+	}
+install:
+	cpuhp_store_callbacks(state, startup, teardown);
+out:
+	put_online_cpus();
+	return ret;
+}
+EXPORT_SYMBOL(__cpuhp_setup_state);
+
+/**
+ * __cpuhp_remove_state - Remove the callbacks for an hotplug machine state
+ * @state:	The state to remove
+ * @invoke:	If true, the teardown function is invoked for cpus where
+ *		cpu state >= @state
+ *
+ * The teardown callback is currently not allowed to fail. Think
+ * about module removal!
+ */
+void __cpuhp_remove_state(enum cpuhp_states state, bool invoke)
+{
+	int (*teardown)(unsigned int cpu) = cpuhp_get_teardown_cb(state);
+	int cpu;
+
+	BUG_ON(cpuhp_cb_check(state));
+
+	get_online_cpus();
+
+	if (!invoke || !teardown)
+		goto remove;
+
+	/*
+	 * Call the teardown callback for each present cpu depending
+	 * on the hotplug state of the cpu. This function is not
+	 * allowed to fail currently!
+	 */
+	for_each_present_cpu(cpu) {
+		int cpustate = per_cpu(cpuhp_state, cpu);
+
+		if (cpustate >= state)
+			cpuhp_issue_call(cpu, state, teardown, false);
+	}
+remove:
+	cpuhp_store_callbacks(state, NULL, NULL);
+	put_online_cpus();
+}
+EXPORT_SYMBOL(__cpuhp_remove_state);
+
 /*
  * cpu_bit_bitmap[] is a special, "compressed" data structure that
  * represents all NR_CPUS bits binary values of 1<<nr.


