Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaANLCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:02:31 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:37390 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaANLC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:02:27 -0500
Subject: [PATCH v1] powernv/cpuidle: Back-end cpuidle driver for powernv
 platform.
To: linux-pm@vger.kernel.org, benh@kernel.crashing.org,
        daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Date: Tue, 14 Jan 2014 16:32:40 +0530
Message-ID: <20140114110229.4091.25232.stgit@deepthi.in.ibm.com>
In-Reply-To: <20140114110157.4091.80684.stgit@deepthi.in.ibm.com>
References: <20140114110157.4091.80684.stgit@deepthi.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011411-8878-0000-0000-00000A73F658
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch ports the cpuidle framework for powernv
platform and also implements a cpuidle back-end powernv
idle driver calling on to power7_nap and snooze idle states.

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/powernv/setup.c |   13 ++
 drivers/cpuidle/Kconfig.powerpc        |    9 ++
 drivers/cpuidle/Makefile               |    1 
 drivers/cpuidle/cpuidle-powernv.c      |  169 ++++++++++++++++++++++++++++++++
 4 files changed, 191 insertions(+), 1 deletion(-)
 create mode 100644 drivers/cpuidle/cpuidle-powernv.c

diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index 19884b2..764a14e 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -26,6 +26,7 @@
 #include <linux/of_fdt.h>
 #include <linux/interrupt.h>
 #include <linux/bug.h>
+#include <linux/cpuidle.h>
 
 #include <asm/machdep.h>
 #include <asm/firmware.h>
@@ -214,6 +215,16 @@ static int __init pnv_probe(void)
 	return 1;
 }
 
+void powernv_idle(void)
+{
+	/* Hook to cpuidle framework if available, else
+	 * call on default platform idle code
+	 */
+	if (cpuidle_idle_call()) {
+		power7_idle();
+	}
+}
+
 define_machine(powernv) {
 	.name			= "PowerNV",
 	.probe			= pnv_probe,
@@ -223,7 +234,7 @@ define_machine(powernv) {
 	.show_cpuinfo		= pnv_show_cpuinfo,
 	.progress		= pnv_progress,
 	.machine_shutdown	= pnv_shutdown,
-	.power_save             = power7_idle,
+	.power_save             = powernv_idle,
 	.calibrate_decr		= generic_calibrate_decr,
 #ifdef CONFIG_KEXEC
 	.kexec_cpu_down		= pnv_kexec_cpu_down,
diff --git a/drivers/cpuidle/Kconfig.powerpc b/drivers/cpuidle/Kconfig.powerpc
index 8147de5..66c3a09 100644
--- a/drivers/cpuidle/Kconfig.powerpc
+++ b/drivers/cpuidle/Kconfig.powerpc
@@ -9,3 +9,12 @@ config PSERIES_CPUIDLE
 	help
 	  Select this option to enable processor idle state management
 	  through cpuidle subsystem.
+
+config POWERNV_CPUIDLE
+	bool "Cpuidle driver for powernv platforms"
+	depends on CPU_IDLE
+	depends on PPC_POWERNV
+	default y
+	help
+	  Select this option to enable processor idle state management
+	  through cpuidle subsystem.
diff --git a/drivers/cpuidle/Makefile b/drivers/cpuidle/Makefile
index a6331ad..f71ae1b 100644
--- a/drivers/cpuidle/Makefile
+++ b/drivers/cpuidle/Makefile
@@ -17,3 +17,4 @@ obj-$(CONFIG_ARM_AT91_CPUIDLE)          += cpuidle-at91.o
 ###############################################################################
 # POWERPC drivers
 obj-$(CONFIG_PSERIES_CPUIDLE)		+= cpuidle-pseries.o
+obj-$(CONFIG_POWERNV_CPUIDLE)		+= cpuidle-powernv.o
diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
new file mode 100644
index 0000000..78fd174
--- /dev/null
+++ b/drivers/cpuidle/cpuidle-powernv.c
@@ -0,0 +1,169 @@
+/*
+ *  cpuidle-powernv - idle state cpuidle driver.
+ *  Adapted from drivers/cpuidle/cpuidle-pseries
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
+#include <asm/machdep.h>
+#include <asm/firmware.h>
+
+struct cpuidle_driver powernv_idle_driver = {
+	.name             = "powernv_idle",
+	.owner            = THIS_MODULE,
+};
+
+static int max_idle_state;
+static struct cpuidle_state *cpuidle_state_table;
+
+static int snooze_loop(struct cpuidle_device *dev,
+			struct cpuidle_driver *drv,
+			int index)
+{
+	local_irq_enable();
+	set_thread_flag(TIF_POLLING_NRFLAG);
+
+	while (!need_resched()) {
+		HMT_low();
+		HMT_very_low();
+	}
+
+	HMT_medium();
+	clear_thread_flag(TIF_POLLING_NRFLAG);
+	smp_mb();
+	return index;
+}
+
+static int nap_loop(struct cpuidle_device *dev,
+			struct cpuidle_driver *drv,
+			int index)
+{
+	power7_idle();
+	return index;
+}
+
+/*
+ * States for dedicated partition case.
+ */
+static struct cpuidle_state powernv_states[] = {
+	{ /* Snooze */
+		.name = "snooze",
+		.desc = "snooze",
+		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 0,
+		.target_residency = 0,
+		.enter = &snooze_loop },
+	{ /* NAP */
+		.name = "NAP",
+		.desc = "NAP",
+		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 10,
+		.target_residency = 100,
+		.enter = &nap_loop },
+};
+
+static int powernv_cpuidle_add_cpu_notifier(struct notifier_block *n,
+			unsigned long action, void *hcpu)
+{
+	int hotcpu = (unsigned long)hcpu;
+	struct cpuidle_device *dev =
+				per_cpu(cpuidle_devices, hotcpu);
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
+	.notifier_call = powernv_cpuidle_add_cpu_notifier,
+};
+
+/*
+ * powernv_cpuidle_driver_init()
+ */
+static int powernv_cpuidle_driver_init(void)
+{
+	int idle_state;
+	struct cpuidle_driver *drv = &powernv_idle_driver;
+
+	drv->state_count = 0;
+
+	for (idle_state = 0; idle_state < max_idle_state; ++idle_state) {
+		/* Is the state not enabled? */
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
+ * powernv_idle_probe()
+ * Choose state table for shared versus dedicated partition
+ */
+static int powernv_idle_probe(void)
+{
+
+	if (cpuidle_disable != IDLE_NO_OVERRIDE)
+		return -ENODEV;
+
+	if (firmware_has_feature(FW_FEATURE_OPALv3)) {
+		cpuidle_state_table = powernv_states;
+		max_idle_state = ARRAY_SIZE(powernv_states);
+ 	} else
+ 		return -ENODEV;
+
+	return 0;
+}
+
+static int __init powernv_processor_idle_init(void)
+{
+	int retval;
+
+	retval = powernv_idle_probe();
+	if (retval)
+		return retval;
+
+	powernv_cpuidle_driver_init();
+	retval = cpuidle_register(&powernv_idle_driver, NULL);
+	if (retval) {
+		printk(KERN_DEBUG "Registration of powernv driver failed.\n");
+		return retval;
+	}
+
+	register_cpu_notifier(&setup_hotplug_notifier);
+	printk(KERN_DEBUG "powernv_idle_driver registered\n");
+	return 0;
+}
+
+device_initcall(powernv_processor_idle_init);

