Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab3HVFbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 01:31:21 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:35543 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab3HVFbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 01:31:18 -0400
Subject: [PATCH V4 3/5] powerpc/cpuidle: Generic powerpc backend cpuidle
 driver.
To: linux-pm@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: michael@ellerman.id.au, benh@kernel.crashing.org,
        daniel.lezcano@linaro.org, dongsheng.wang@freescale.com, rjw@sisk.pl,
        scottwood@freescale.com, srivatsa.bhat@linux.vnet.ibm.com,
        preeti@linux.vnet.ibm.com, svaidy@linux.vnet.ibm.com
Date: Thu, 22 Aug 2013 11:00:29 +0530
Message-ID: <20130822053026.23277.8122.stgit@deepthi.in.ibm.com>
In-Reply-To: <20130822052938.23277.67621.stgit@deepthi.in.ibm.com>
References: <20130822052938.23277.67621.stgit@deepthi.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082205-7014-0000-0000-0000037F53AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch involves moving the current pseries_idle backend driver code
from pseries/processor_idle.c to drivers/cpuidle/cpuidle-powerpc.c,
and making the backend code generic enough to be able to extend this
driver code for both powernv and pseries.

It enables the support for pseries platform, such that going forward the same code
with minimal efforts can be re-used for a common driver on powernv
and can be further extended to support cpuidle idle state mgmt for the rest
of the powerpc platforms in the future. This removes a lot of code duplicacy,
making the code elegant.

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/paca.h                 |   23 +
 arch/powerpc/include/asm/processor.h            |    2 
 arch/powerpc/platforms/pseries/Kconfig          |    9 -
 arch/powerpc/platforms/pseries/Makefile         |    1 
 arch/powerpc/platforms/pseries/processor_idle.c |  360 -----------------------
 drivers/cpuidle/Kconfig                         |    7 
 drivers/cpuidle/Makefile                        |    2 
 drivers/cpuidle/cpuidle-powerpc.c               |  304 +++++++++++++++++++
 8 files changed, 337 insertions(+), 371 deletions(-)
 delete mode 100644 arch/powerpc/platforms/pseries/processor_idle.c
 create mode 100644 drivers/cpuidle/cpuidle-powerpc.c

diff --git a/arch/powerpc/include/asm/paca.h b/arch/powerpc/include/asm/paca.h
index 77c91e7..7bd83ff 100644
--- a/arch/powerpc/include/asm/paca.h
+++ b/arch/powerpc/include/asm/paca.h
@@ -175,6 +175,29 @@ extern void setup_paca(struct paca_struct *new_paca);
 extern void allocate_pacas(void);
 extern void free_unused_pacas(void);
 
+#ifdef CONFIG_PPC_BOOK3S
+#define get_lppaca_is_shared_proc()  get_paca()->lppaca_ptr->shared_proc
+static inline void set_lppaca_idle(u8  idle)
+{
+	get_paca()->lppaca_ptr->idle = idle;
+}
+
+static inline void add_lppaca_wait_state(u64 cycles)
+{
+	get_paca()->lppaca_ptr->wait_state_cycles += cycles;
+}
+
+static inline void set_lppaca_donate_dedicated_cpu(u8 value)
+{
+	get_paca()->lppaca_ptr->donate_dedicated_cpu = value;
+}
+#else
+#define get_lppaca_is_shared_proc()	-1
+static inline void set_lppaca_idle(u8 idle) { }
+static inline void  add_lppaca_wait_state(u64 cycles) { }
+static inline void  set_lppaca_donate_dedicated_cpu(u8 value) { }
+#endif
+
 #else /* CONFIG_PPC64 */
 
 static inline void allocate_pacas(void) { };
diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index e378ccc..5f57c56 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -430,7 +430,7 @@ enum idle_boot_override {IDLE_NO_OVERRIDE = 0, IDLE_POWERSAVE_OFF};
 extern int powersave_nap;	/* set if nap mode can be used in idle loop */
 extern void power7_nap(void);
 
-#ifdef CONFIG_PSERIES_IDLE
+#ifdef CONFIG_CPU_IDLE_POWERPC
 extern void update_smt_snooze_delay(int cpu, int residency);
 #else
 static inline void update_smt_snooze_delay(int cpu, int residency) {}
diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
index 62b4f80..bb59bb0 100644
--- a/arch/powerpc/platforms/pseries/Kconfig
+++ b/arch/powerpc/platforms/pseries/Kconfig
@@ -119,12 +119,3 @@ config DTL
 	  which are accessible through a debugfs file.
 
 	  Say N if you are unsure.
-
-config PSERIES_IDLE
-	bool "Cpuidle driver for pSeries platforms"
-	depends on CPU_IDLE
-	depends on PPC_PSERIES
-	default y
-	help
-	  Select this option to enable processor idle state management
-	  through cpuidle subsystem.
diff --git a/arch/powerpc/platforms/pseries/Makefile b/arch/powerpc/platforms/pseries/Makefile
index 8ae0103..4b22379 100644
--- a/arch/powerpc/platforms/pseries/Makefile
+++ b/arch/powerpc/platforms/pseries/Makefile
@@ -21,7 +21,6 @@ obj-$(CONFIG_HCALL_STATS)	+= hvCall_inst.o
 obj-$(CONFIG_CMM)		+= cmm.o
 obj-$(CONFIG_DTL)		+= dtl.o
 obj-$(CONFIG_IO_EVENT_IRQ)	+= io_event_irq.o
-obj-$(CONFIG_PSERIES_IDLE)	+= processor_idle.o
 
 ifeq ($(CONFIG_PPC_PSERIES),y)
 obj-$(CONFIG_SUSPEND)		+= suspend.o
diff --git a/arch/powerpc/platforms/pseries/processor_idle.c b/arch/powerpc/platforms/pseries/processor_idle.c
deleted file mode 100644
index c905b99..0000000
--- a/arch/powerpc/platforms/pseries/processor_idle.c
+++ /dev/null
@@ -1,360 +0,0 @@
-/*
- *  processor_idle - idle state cpuidle driver.
- *  Adapted from drivers/idle/intel_idle.c and
- *  drivers/acpi/processor_idle.c
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/moduleparam.h>
-#include <linux/cpuidle.h>
-#include <linux/cpu.h>
-#include <linux/notifier.h>
-
-#include <asm/paca.h>
-#include <asm/reg.h>
-#include <asm/machdep.h>
-#include <asm/firmware.h>
-#include <asm/runlatch.h>
-#include <asm/plpar_wrappers.h>
-
-struct cpuidle_driver pseries_idle_driver = {
-	.name             = "pseries_idle",
-	.owner            = THIS_MODULE,
-};
-
-#define MAX_IDLE_STATE_COUNT	2
-
-static int max_idle_state = MAX_IDLE_STATE_COUNT - 1;
-static struct cpuidle_device __percpu *pseries_cpuidle_devices;
-static struct cpuidle_state *cpuidle_state_table;
-
-static inline void idle_loop_prolog(unsigned long *in_purr)
-{
-	*in_purr = mfspr(SPRN_PURR);
-	/*
-	 * Indicate to the HV that we are idle. Now would be
-	 * a good time to find other work to dispatch.
-	 */
-	get_lppaca()->idle = 1;
-}
-
-static inline void idle_loop_epilog(unsigned long in_purr)
-{
-	get_lppaca()->wait_state_cycles += mfspr(SPRN_PURR) - in_purr;
-	get_lppaca()->idle = 0;
-}
-
-static int snooze_loop(struct cpuidle_device *dev,
-			struct cpuidle_driver *drv,
-			int index)
-{
-	unsigned long in_purr;
-	int cpu = dev->cpu;
-
-	idle_loop_prolog(&in_purr);
-	local_irq_enable();
-	set_thread_flag(TIF_POLLING_NRFLAG);
-
-	while ((!need_resched()) && cpu_online(cpu)) {
-		ppc64_runlatch_off();
-		HMT_low();
-		HMT_very_low();
-	}
-
-	HMT_medium();
-	clear_thread_flag(TIF_POLLING_NRFLAG);
-	smp_mb();
-
-	idle_loop_epilog(in_purr);
-
-	return index;
-}
-
-static void check_and_cede_processor(void)
-{
-	/*
-	 * Ensure our interrupt state is properly tracked,
-	 * also checks if no interrupt has occurred while we
-	 * were soft-disabled
-	 */
-	if (prep_irq_for_idle()) {
-		cede_processor();
-#ifdef CONFIG_TRACE_IRQFLAGS
-		/* Ensure that H_CEDE returns with IRQs on */
-		if (WARN_ON(!(mfmsr() & MSR_EE)))
-			__hard_irq_enable();
-#endif
-	}
-}
-
-static int dedicated_cede_loop(struct cpuidle_device *dev,
-				struct cpuidle_driver *drv,
-				int index)
-{
-	unsigned long in_purr;
-
-	idle_loop_prolog(&in_purr);
-	get_lppaca()->donate_dedicated_cpu = 1;
-
-	ppc64_runlatch_off();
-	HMT_medium();
-	check_and_cede_processor();
-
-	get_lppaca()->donate_dedicated_cpu = 0;
-
-	idle_loop_epilog(in_purr);
-
-	return index;
-}
-
-static int shared_cede_loop(struct cpuidle_device *dev,
-			struct cpuidle_driver *drv,
-			int index)
-{
-	unsigned long in_purr;
-
-	idle_loop_prolog(&in_purr);
-
-	/*
-	 * Yield the processor to the hypervisor.  We return if
-	 * an external interrupt occurs (which are driven prior
-	 * to returning here) or if a prod occurs from another
-	 * processor. When returning here, external interrupts
-	 * are enabled.
-	 */
-	check_and_cede_processor();
-
-	idle_loop_epilog(in_purr);
-
-	return index;
-}
-
-/*
- * States for dedicated partition case.
- */
-static struct cpuidle_state dedicated_states[MAX_IDLE_STATE_COUNT] = {
-	{ /* Snooze */
-		.name = "snooze",
-		.desc = "snooze",
-		.flags = CPUIDLE_FLAG_TIME_VALID,
-		.exit_latency = 0,
-		.target_residency = 0,
-		.enter = &snooze_loop },
-	{ /* CEDE */
-		.name = "CEDE",
-		.desc = "CEDE",
-		.flags = CPUIDLE_FLAG_TIME_VALID,
-		.exit_latency = 10,
-		.target_residency = 100,
-		.enter = &dedicated_cede_loop },
-};
-
-/*
- * States for shared partition case.
- */
-static struct cpuidle_state shared_states[MAX_IDLE_STATE_COUNT] = {
-	{ /* Shared Cede */
-		.name = "Shared Cede",
-		.desc = "Shared Cede",
-		.flags = CPUIDLE_FLAG_TIME_VALID,
-		.exit_latency = 0,
-		.target_residency = 0,
-		.enter = &shared_cede_loop },
-};
-
-void update_smt_snooze_delay(int cpu, int residency)
-{
-	struct cpuidle_driver *drv = cpuidle_get_driver();
-	struct cpuidle_device *dev = per_cpu(cpuidle_devices, cpu);
-
-	if (cpuidle_state_table != dedicated_states)
-		return;
-
-	if (residency < 0) {
-		/* Disable the Nap state on that cpu */
-		if (dev)
-			dev->states_usage[1].disable = 1;
-	} else
-		if (drv)
-			drv->states[1].target_residency = residency;
-}
-
-static int pseries_cpuidle_add_cpu_notifier(struct notifier_block *n,
-			unsigned long action, void *hcpu)
-{
-	int hotcpu = (unsigned long)hcpu;
-	struct cpuidle_device *dev =
-			per_cpu_ptr(pseries_cpuidle_devices, hotcpu);
-
-	if (dev && cpuidle_get_driver()) {
-		switch (action) {
-		case CPU_ONLINE:
-		case CPU_ONLINE_FROZEN:
-			cpuidle_pause_and_lock();
-			cpuidle_enable_device(dev);
-			cpuidle_resume_and_unlock();
-			break;
-
-		case CPU_DEAD:
-		case CPU_DEAD_FROZEN:
-			cpuidle_pause_and_lock();
-			cpuidle_disable_device(dev);
-			cpuidle_resume_and_unlock();
-			break;
-
-		default:
-			return NOTIFY_DONE;
-		}
-	}
-	return NOTIFY_OK;
-}
-
-static struct notifier_block setup_hotplug_notifier = {
-	.notifier_call = pseries_cpuidle_add_cpu_notifier,
-};
-
-/*
- * pseries_cpuidle_driver_init()
- */
-static int pseries_cpuidle_driver_init(void)
-{
-	int idle_state;
-	struct cpuidle_driver *drv = &pseries_idle_driver;
-
-	drv->state_count = 0;
-
-	for (idle_state = 0; idle_state < MAX_IDLE_STATE_COUNT; ++idle_state) {
-
-		if (idle_state > max_idle_state)
-			break;
-
-		/* is the state not enabled? */
-		if (cpuidle_state_table[idle_state].enter == NULL)
-			continue;
-
-		drv->states[drv->state_count] =	/* structure copy */
-			cpuidle_state_table[idle_state];
-
-		drv->state_count += 1;
-	}
-
-	return 0;
-}
-
-/* pseries_idle_devices_uninit(void)
- * unregister cpuidle devices and de-allocate memory
- */
-static void pseries_idle_devices_uninit(void)
-{
-	int i;
-	struct cpuidle_device *dev;
-
-	for_each_possible_cpu(i) {
-		dev = per_cpu_ptr(pseries_cpuidle_devices, i);
-		cpuidle_unregister_device(dev);
-	}
-
-	free_percpu(pseries_cpuidle_devices);
-	return;
-}
-
-/* pseries_idle_devices_init()
- * allocate, initialize and register cpuidle device
- */
-static int pseries_idle_devices_init(void)
-{
-	int i;
-	struct cpuidle_driver *drv = &pseries_idle_driver;
-	struct cpuidle_device *dev;
-
-	pseries_cpuidle_devices = alloc_percpu(struct cpuidle_device);
-	if (pseries_cpuidle_devices == NULL)
-		return -ENOMEM;
-
-	for_each_possible_cpu(i) {
-		dev = per_cpu_ptr(pseries_cpuidle_devices, i);
-		dev->state_count = drv->state_count;
-		dev->cpu = i;
-		if (cpuidle_register_device(dev)) {
-			printk(KERN_DEBUG \
-				"cpuidle_register_device %d failed!\n", i);
-			return -EIO;
-		}
-	}
-
-	return 0;
-}
-
-/*
- * pseries_idle_probe()
- * Choose state table for shared versus dedicated partition
- */
-static int pseries_idle_probe(void)
-{
-
-	if (!firmware_has_feature(FW_FEATURE_SPLPAR))
-		return -ENODEV;
-
-	if (cpuidle_disable != IDLE_NO_OVERRIDE)
-		return -ENODEV;
-
-	if (max_idle_state == 0) {
-		printk(KERN_DEBUG "pseries processor idle disabled.\n");
-		return -EPERM;
-	}
-
-	if (get_lppaca()->shared_proc)
-		cpuidle_state_table = shared_states;
-	else
-		cpuidle_state_table = dedicated_states;
-
-	return 0;
-}
-
-static int __init pseries_processor_idle_init(void)
-{
-	int retval;
-
-	retval = pseries_idle_probe();
-	if (retval)
-		return retval;
-
-	pseries_cpuidle_driver_init();
-	retval = cpuidle_register_driver(&pseries_idle_driver);
-	if (retval) {
-		printk(KERN_DEBUG "Registration of pseries driver failed.\n");
-		return retval;
-	}
-
-	retval = pseries_idle_devices_init();
-	if (retval) {
-		pseries_idle_devices_uninit();
-		cpuidle_unregister_driver(&pseries_idle_driver);
-		return retval;
-	}
-
-	register_cpu_notifier(&setup_hotplug_notifier);
-	printk(KERN_DEBUG "pseries_idle_driver registered\n");
-
-	return 0;
-}
-
-static void __exit pseries_processor_idle_exit(void)
-{
-
-	unregister_cpu_notifier(&setup_hotplug_notifier);
-	pseries_idle_devices_uninit();
-	cpuidle_unregister_driver(&pseries_idle_driver);
-
-	return;
-}
-
-module_init(pseries_processor_idle_init);
-module_exit(pseries_processor_idle_exit);
-
-MODULE_AUTHOR("Deepthi Dharwar <deepthi@linux.vnet.ibm.com>");
-MODULE_DESCRIPTION("Cpuidle driver for POWER");
-MODULE_LICENSE("GPL");
diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
index 0e2cd5c..53ce03d 100644
--- a/drivers/cpuidle/Kconfig
+++ b/drivers/cpuidle/Kconfig
@@ -42,6 +42,13 @@ config CPU_IDLE_ZYNQ
 	help
 	  Select this to enable cpuidle on Xilinx Zynq processors.
 
+config CPU_IDLE_POWERPC
+	bool "CPU Idle driver for POWERPC platforms"
+	depends on PPC_PSERIES || PPC_POWERNV
+	default y
+        help
+          Select this option to enable processor idle state management
+	  for POWERPC platform.
 endif
 
 config ARCH_NEEDS_CPU_IDLE_COUPLED
diff --git a/drivers/cpuidle/Makefile b/drivers/cpuidle/Makefile
index 8767a7b..d12e205 100644
--- a/drivers/cpuidle/Makefile
+++ b/drivers/cpuidle/Makefile
@@ -8,3 +8,5 @@ obj-$(CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED) += coupled.o
 obj-$(CONFIG_CPU_IDLE_CALXEDA) += cpuidle-calxeda.o
 obj-$(CONFIG_ARCH_KIRKWOOD) += cpuidle-kirkwood.o
 obj-$(CONFIG_CPU_IDLE_ZYNQ) += cpuidle-zynq.o
+
+obj-$(CONFIG_CPU_IDLE_POWERPC) += cpuidle-powerpc.o
diff --git a/drivers/cpuidle/cpuidle-powerpc.c b/drivers/cpuidle/cpuidle-powerpc.c
new file mode 100644
index 0000000..3662aba
--- /dev/null
+++ b/drivers/cpuidle/cpuidle-powerpc.c
@@ -0,0 +1,304 @@
+/*
+ *  processor_idle - idle state cpuidle driver.
+ *  Adapted from drivers/idle/intel_idle.c and
+ *  drivers/acpi/processor_idle.c
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/moduleparam.h>
+#include <linux/cpuidle.h>
+#include <linux/cpu.h>
+#include <linux/notifier.h>
+
+#include <asm/paca.h>
+#include <asm/reg.h>
+#include <asm/machdep.h>
+#include <asm/firmware.h>
+#include <asm/runlatch.h>
+#include <asm/plpar_wrappers.h>
+
+struct cpuidle_driver powerpc_idle_driver = {
+	.name             = "powerpc_idle",
+	.owner            = THIS_MODULE,
+};
+
+#define MAX_IDLE_STATE_COUNT	2
+
+static int max_idle_state = MAX_IDLE_STATE_COUNT - 1;
+static struct cpuidle_state *cpuidle_state_table;
+
+static inline void idle_loop_prolog(unsigned long *in_purr)
+{
+	*in_purr = mfspr(SPRN_PURR);
+	/*
+	 * Indicate to the HV that we are idle. Now would be
+	 * a good time to find other work to dispatch.
+	 */
+	set_lppaca_idle(1);
+}
+
+static inline void idle_loop_epilog(unsigned long in_purr)
+{
+	add_lppaca_wait_state(mfspr(SPRN_PURR) - in_purr);
+	set_lppaca_idle(0);
+}
+
+static int snooze_loop(struct cpuidle_device *dev,
+			struct cpuidle_driver *drv,
+			int index)
+{
+	unsigned long in_purr;
+
+	idle_loop_prolog(&in_purr);
+	local_irq_enable();
+	set_thread_flag(TIF_POLLING_NRFLAG);
+
+	while (!need_resched()) {
+		ppc64_runlatch_off();
+		HMT_low();
+		HMT_very_low();
+	}
+
+	HMT_medium();
+	clear_thread_flag(TIF_POLLING_NRFLAG);
+	smp_mb();
+
+	idle_loop_epilog(in_purr);
+
+	return index;
+}
+
+static void check_and_cede_processor(void)
+{
+	/*
+	 * Ensure our interrupt state is properly tracked,
+	 * also checks if no interrupt has occurred while we
+	 * were soft-disabled
+	 */
+	if (prep_irq_for_idle()) {
+		cede_processor();
+#ifdef CONFIG_TRACE_IRQFLAGS
+		/* Ensure that H_CEDE returns with IRQs on */
+		if (WARN_ON(!(mfmsr() & MSR_EE)))
+			__hard_irq_enable();
+#endif
+	}
+}
+
+static int dedicated_cede_loop(struct cpuidle_device *dev,
+				struct cpuidle_driver *drv,
+				int index)
+{
+	unsigned long in_purr;
+
+	idle_loop_prolog(&in_purr);
+	set_lppaca_donate_dedicated_cpu(1);
+
+	ppc64_runlatch_off();
+	HMT_medium();
+	check_and_cede_processor();
+
+	set_lppaca_donate_dedicated_cpu(0);
+	idle_loop_epilog(in_purr);
+
+	return index;
+}
+
+static int shared_cede_loop(struct cpuidle_device *dev,
+			struct cpuidle_driver *drv,
+			int index)
+{
+	unsigned long in_purr;
+
+	idle_loop_prolog(&in_purr);
+
+	/*
+	 * Yield the processor to the hypervisor.  We return if
+	 * an external interrupt occurs (which are driven prior
+	 * to returning here) or if a prod occurs from another
+	 * processor. When returning here, external interrupts
+	 * are enabled.
+	 */
+	check_and_cede_processor();
+
+	idle_loop_epilog(in_purr);
+
+	return index;
+}
+
+/*
+ * States for dedicated partition case.
+ */
+static struct cpuidle_state dedicated_states[MAX_IDLE_STATE_COUNT] = {
+	{ /* Snooze */
+		.name = "snooze",
+		.desc = "snooze",
+		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 0,
+		.target_residency = 0,
+		.enter = &snooze_loop },
+	{ /* CEDE */
+		.name = "CEDE",
+		.desc = "CEDE",
+		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 10,
+		.target_residency = 100,
+		.enter = &dedicated_cede_loop },
+};
+
+/*
+ * States for shared partition case.
+ */
+static struct cpuidle_state shared_states[MAX_IDLE_STATE_COUNT] = {
+	{ /* Shared Cede */
+		.name = "Shared Cede",
+		.desc = "Shared Cede",
+		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 0,
+		.target_residency = 0,
+		.enter = &shared_cede_loop },
+};
+
+void update_smt_snooze_delay(int cpu, int residency)
+{
+	struct cpuidle_driver *drv = cpuidle_get_driver();
+	struct cpuidle_device *dev = per_cpu(cpuidle_devices, cpu);
+
+	if (cpuidle_state_table != dedicated_states)
+		return;
+
+	if (residency < 0) {
+		/* Disable the Nap state on that cpu */
+		if (dev)
+			dev->states_usage[1].disable = 1;
+	} else
+		if (drv)
+			drv->states[1].target_residency = residency;
+}
+
+static int powerpc_cpuidle_add_cpu_notifier(struct notifier_block *n,
+			unsigned long action, void *hcpu)
+{
+	int hotcpu = (unsigned long)hcpu;
+	struct cpuidle_device *dev =
+			per_cpu_ptr(cpuidle_devices, hotcpu);
+
+	if (dev && cpuidle_get_driver()) {
+		switch (action) {
+		case CPU_ONLINE:
+		case CPU_ONLINE_FROZEN:
+			cpuidle_pause_and_lock();
+			cpuidle_enable_device(dev);
+			cpuidle_resume_and_unlock();
+			break;
+
+		case CPU_DEAD:
+		case CPU_DEAD_FROZEN:
+			cpuidle_pause_and_lock();
+			cpuidle_disable_device(dev);
+			cpuidle_resume_and_unlock();
+			break;
+
+		default:
+			return NOTIFY_DONE;
+		}
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block setup_hotplug_notifier = {
+	.notifier_call = powerpc_cpuidle_add_cpu_notifier,
+};
+
+/*
+ * powerpc_cpuidle_driver_init()
+ */
+static int powerpc_cpuidle_driver_init(void)
+{
+	int idle_state;
+	struct cpuidle_driver *drv = &powerpc_idle_driver;
+
+	drv->state_count = 0;
+
+	for (idle_state = 0; idle_state < MAX_IDLE_STATE_COUNT; ++idle_state) {
+
+		if (idle_state > max_idle_state)
+			break;
+
+		/* is the state not enabled? */
+		if (cpuidle_state_table[idle_state].enter == NULL)
+			continue;
+
+		drv->states[drv->state_count] =	/* structure copy */
+			cpuidle_state_table[idle_state];
+
+		drv->state_count += 1;
+	}
+
+	return 0;
+}
+
+/*
+ * powerpc_idle_probe()
+ * Choose state table for shared versus dedicated partition
+ */
+static int powerpc_idle_probe(void)
+{
+
+	if (cpuidle_disable != IDLE_NO_OVERRIDE)
+		return -ENODEV;
+
+	if (max_idle_state == 0) {
+		printk(KERN_DEBUG "powerpc processor idle disabled.\n");
+		return -EPERM;
+	}
+
+	if (firmware_has_feature(FW_FEATURE_SPLPAR)) {
+		if (get_lppaca_is_shared_proc() == 1)
+			cpuidle_state_table = shared_states;
+		else if (get_lppaca_is_shared_proc() == 0)
+			cpuidle_state_table = dedicated_states;
+	} else
+		return -ENODEV;
+
+	return 0;
+}
+
+static int __init powerpc_processor_idle_init(void)
+{
+	int retval;
+
+	retval = powerpc_idle_probe();
+	if (retval)
+		return retval;
+
+	powerpc_cpuidle_driver_init();
+	retval = cpuidle_register(&powerpc_idle_driver, NULL);
+	if (retval) {
+		printk(KERN_DEBUG "Registration of powerpc driver failed.\n");
+		return retval;
+	}
+
+	register_cpu_notifier(&setup_hotplug_notifier);
+	printk(KERN_DEBUG "powerpc_idle_driver registered\n");
+
+	return 0;
+}
+
+static void __exit powerpc_processor_idle_exit(void)
+{
+
+	unregister_cpu_notifier(&setup_hotplug_notifier);
+	cpuidle_unregister(&powerpc_idle_driver);
+	return;
+}
+
+module_init(powerpc_processor_idle_init);
+module_exit(powerpc_processor_idle_exit);
+
+MODULE_AUTHOR("Deepthi Dharwar <deepthi@linux.vnet.ibm.com>");
+MODULE_DESCRIPTION("Cpuidle driver for powerpc");
+MODULE_LICENSE("GPL");

