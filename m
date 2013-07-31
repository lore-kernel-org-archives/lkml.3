Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970Ab3GaDAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 23:00:30 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:55591 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab3GaDAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 23:00:25 -0400
Subject: [PATCH V2 4/6] cpuidle/pseries: Move the pseries_idle backend
 driver to sysdev.
To: benh@kernel.crashing.org, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au,
        srivatsa.bhat@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, dongsheng.wang@freescale.com, linux-pm@vger.kernel.org
Date: Wed, 31 Jul 2013 08:29:28 +0530
Message-ID: <20130731025924.19448.46538.stgit@deepthi>
In-Reply-To: <20130731025840.19448.24468.stgit@deepthi>
References: <20130731025840.19448.24468.stgit@deepthi>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073102-3864-0000-0000-00000955A665
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move pseries_idle backend driver code to arch/powerpc/sysdev
so that the code can be used for a common driver for powernv
and pseries. This removes a lot of code duplicacy.

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/Kconfig          |    9 -
 arch/powerpc/platforms/pseries/Makefile         |    1 
 arch/powerpc/platforms/pseries/processor_idle.c |  384 -----------------------
 arch/powerpc/sysdev/Kconfig                     |    9 +
 arch/powerpc/sysdev/Makefile                    |    1 
 arch/powerpc/sysdev/processor_idle.c            |  384 +++++++++++++++++++++++
 6 files changed, 394 insertions(+), 394 deletions(-)
 delete mode 100644 arch/powerpc/platforms/pseries/processor_idle.c
 create mode 100644 arch/powerpc/sysdev/processor_idle.c

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
index 0d75a54..0000000
--- a/arch/powerpc/platforms/pseries/processor_idle.c
+++ /dev/null
@@ -1,384 +0,0 @@
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
-/* Snooze Delay, pseries_idle */
-DECLARE_PER_CPU(long, smt_snooze_delay);
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
-	struct cpuidle_device *dev;
-
-	if (cpuidle_state_table != dedicated_states)
-		return;
-
-	if (!drv)
-		return;
-
-	if (cpu == -1) {
-		if (residency < 0) {
-			/* Disable NAP on all cpus */
-			drv->states[1].disabled = true;
-			return;
-		} else {
-			drv->states[1].target_residency = residency;
-			drv->states[1].disabled = false;
-			return;
-		}
-	}
-
-	dev = per_cpu(cpuidle_devices, cpu);
-	if (!dev)
-		return;
-
-	if (residency < 0)
-		dev->states_usage[1].disable = 1;
-	else {
-		drv->states[1].target_residency = residency;
-		drv->states[1].disabled = false;
-		dev->states_usage[1].disable = 0;
-	}
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
-	update_smt_snooze_delay(-1, per_cpu(smt_snooze_delay, 0));
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
diff --git a/arch/powerpc/sysdev/Kconfig b/arch/powerpc/sysdev/Kconfig
index ab4cb54..8564a3f 100644
--- a/arch/powerpc/sysdev/Kconfig
+++ b/arch/powerpc/sysdev/Kconfig
@@ -34,3 +34,12 @@ config SCOM_DEBUGFS
 config GE_FPGA
 	bool
 	default n
+
+config PSERIES_IDLE
+	bool "Cpuidle driver for pSeries platforms"
+	depends on CPU_IDLE
+	depends on PPC_PSERIES
+	default y
+	help
+	  Select this option to enable processor idle state management
+	  for pSeries through cpuidle subsystem.
diff --git a/arch/powerpc/sysdev/Makefile b/arch/powerpc/sysdev/Makefile
index f67ac90..93d2cdd 100644
--- a/arch/powerpc/sysdev/Makefile
+++ b/arch/powerpc/sysdev/Makefile
@@ -49,6 +49,7 @@ endif
 obj-$(CONFIG_PPC4xx_MSI)	+= ppc4xx_msi.o
 obj-$(CONFIG_PPC4xx_CPM)	+= ppc4xx_cpm.o
 obj-$(CONFIG_PPC4xx_GPIO)	+= ppc4xx_gpio.o
+obj-$(CONFIG_PSERIES_IDLE)	+= processor_idle.o
 
 obj-$(CONFIG_CPM)		+= cpm_common.o
 obj-$(CONFIG_CPM2)		+= cpm2.o cpm2_pic.o
diff --git a/arch/powerpc/sysdev/processor_idle.c b/arch/powerpc/sysdev/processor_idle.c
new file mode 100644
index 0000000..0d75a54
--- /dev/null
+++ b/arch/powerpc/sysdev/processor_idle.c
@@ -0,0 +1,384 @@
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
+/* Snooze Delay, pseries_idle */
+DECLARE_PER_CPU(long, smt_snooze_delay);
+
+struct cpuidle_driver pseries_idle_driver = {
+	.name             = "pseries_idle",
+	.owner            = THIS_MODULE,
+};
+
+#define MAX_IDLE_STATE_COUNT	2
+
+static int max_idle_state = MAX_IDLE_STATE_COUNT - 1;
+static struct cpuidle_device __percpu *pseries_cpuidle_devices;
+static struct cpuidle_state *cpuidle_state_table;
+
+static inline void idle_loop_prolog(unsigned long *in_purr)
+{
+	*in_purr = mfspr(SPRN_PURR);
+	/*
+	 * Indicate to the HV that we are idle. Now would be
+	 * a good time to find other work to dispatch.
+	 */
+	get_lppaca()->idle = 1;
+}
+
+static inline void idle_loop_epilog(unsigned long in_purr)
+{
+	get_lppaca()->wait_state_cycles += mfspr(SPRN_PURR) - in_purr;
+	get_lppaca()->idle = 0;
+}
+
+static int snooze_loop(struct cpuidle_device *dev,
+			struct cpuidle_driver *drv,
+			int index)
+{
+	unsigned long in_purr;
+	int cpu = dev->cpu;
+
+	idle_loop_prolog(&in_purr);
+	local_irq_enable();
+	set_thread_flag(TIF_POLLING_NRFLAG);
+
+	while ((!need_resched()) && cpu_online(cpu)) {
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
+	get_lppaca()->donate_dedicated_cpu = 1;
+
+	ppc64_runlatch_off();
+	HMT_medium();
+	check_and_cede_processor();
+
+	get_lppaca()->donate_dedicated_cpu = 0;
+
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
+	struct cpuidle_device *dev;
+
+	if (cpuidle_state_table != dedicated_states)
+		return;
+
+	if (!drv)
+		return;
+
+	if (cpu == -1) {
+		if (residency < 0) {
+			/* Disable NAP on all cpus */
+			drv->states[1].disabled = true;
+			return;
+		} else {
+			drv->states[1].target_residency = residency;
+			drv->states[1].disabled = false;
+			return;
+		}
+	}
+
+	dev = per_cpu(cpuidle_devices, cpu);
+	if (!dev)
+		return;
+
+	if (residency < 0)
+		dev->states_usage[1].disable = 1;
+	else {
+		drv->states[1].target_residency = residency;
+		drv->states[1].disabled = false;
+		dev->states_usage[1].disable = 0;
+	}
+}
+
+static int pseries_cpuidle_add_cpu_notifier(struct notifier_block *n,
+			unsigned long action, void *hcpu)
+{
+	int hotcpu = (unsigned long)hcpu;
+	struct cpuidle_device *dev =
+			per_cpu_ptr(pseries_cpuidle_devices, hotcpu);
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
+	.notifier_call = pseries_cpuidle_add_cpu_notifier,
+};
+
+/*
+ * pseries_cpuidle_driver_init()
+ */
+static int pseries_cpuidle_driver_init(void)
+{
+	int idle_state;
+	struct cpuidle_driver *drv = &pseries_idle_driver;
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
+/* pseries_idle_devices_uninit(void)
+ * unregister cpuidle devices and de-allocate memory
+ */
+static void pseries_idle_devices_uninit(void)
+{
+	int i;
+	struct cpuidle_device *dev;
+
+	for_each_possible_cpu(i) {
+		dev = per_cpu_ptr(pseries_cpuidle_devices, i);
+		cpuidle_unregister_device(dev);
+	}
+
+	free_percpu(pseries_cpuidle_devices);
+	return;
+}
+
+/* pseries_idle_devices_init()
+ * allocate, initialize and register cpuidle device
+ */
+static int pseries_idle_devices_init(void)
+{
+	int i;
+	struct cpuidle_driver *drv = &pseries_idle_driver;
+	struct cpuidle_device *dev;
+
+	pseries_cpuidle_devices = alloc_percpu(struct cpuidle_device);
+	if (pseries_cpuidle_devices == NULL)
+		return -ENOMEM;
+
+	for_each_possible_cpu(i) {
+		dev = per_cpu_ptr(pseries_cpuidle_devices, i);
+		dev->state_count = drv->state_count;
+		dev->cpu = i;
+		if (cpuidle_register_device(dev)) {
+			printk(KERN_DEBUG \
+				"cpuidle_register_device %d failed!\n", i);
+			return -EIO;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * pseries_idle_probe()
+ * Choose state table for shared versus dedicated partition
+ */
+static int pseries_idle_probe(void)
+{
+
+	if (!firmware_has_feature(FW_FEATURE_SPLPAR))
+		return -ENODEV;
+
+	if (cpuidle_disable != IDLE_NO_OVERRIDE)
+		return -ENODEV;
+
+	if (max_idle_state == 0) {
+		printk(KERN_DEBUG "pseries processor idle disabled.\n");
+		return -EPERM;
+	}
+
+	if (get_lppaca()->shared_proc)
+		cpuidle_state_table = shared_states;
+	else
+		cpuidle_state_table = dedicated_states;
+
+	return 0;
+}
+
+static int __init pseries_processor_idle_init(void)
+{
+	int retval;
+
+	retval = pseries_idle_probe();
+	if (retval)
+		return retval;
+
+	pseries_cpuidle_driver_init();
+	retval = cpuidle_register_driver(&pseries_idle_driver);
+	if (retval) {
+		printk(KERN_DEBUG "Registration of pseries driver failed.\n");
+		return retval;
+	}
+
+	update_smt_snooze_delay(-1, per_cpu(smt_snooze_delay, 0));
+
+	retval = pseries_idle_devices_init();
+	if (retval) {
+		pseries_idle_devices_uninit();
+		cpuidle_unregister_driver(&pseries_idle_driver);
+		return retval;
+	}
+
+	register_cpu_notifier(&setup_hotplug_notifier);
+	printk(KERN_DEBUG "pseries_idle_driver registered\n");
+
+	return 0;
+}
+
+static void __exit pseries_processor_idle_exit(void)
+{
+
+	unregister_cpu_notifier(&setup_hotplug_notifier);
+	pseries_idle_devices_uninit();
+	cpuidle_unregister_driver(&pseries_idle_driver);
+
+	return;
+}
+
+module_init(pseries_processor_idle_init);
+module_exit(pseries_processor_idle_exit);
+
+MODULE_AUTHOR("Deepthi Dharwar <deepthi@linux.vnet.ibm.com>");
+MODULE_DESCRIPTION("Cpuidle driver for POWER");
+MODULE_LICENSE("GPL");

