Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab3GWJC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 05:02:57 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:59920 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab3GWJCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 05:02:38 -0400
Subject: [PATCH 1/3] cpuidle/powernv: cpuidle backend driver for powernv
To: linuxppc-dev@lists.ozlabs.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: benh@kernel.crashing.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Tue, 23 Jul 2013 14:31:41 +0530
Message-ID: <20130723090137.7291.36657.stgit@deepthi.in.ibm.com>
In-Reply-To: <20130723090111.7291.99479.stgit@deepthi.in.ibm.com>
References: <20130723090111.7291.99479.stgit@deepthi.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072308-8878-0000-0000-000008127149
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a back-end cpuidle driver for
powernv calling power7_nap and snooze idle states.
This can be extended by adding more idle states
in the future to the existing framework.

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/powernv/Kconfig          |    9 +
 arch/powerpc/platforms/powernv/Makefile         |    1 
 arch/powerpc/platforms/powernv/processor_idle.c |  239 +++++++++++++++++++++++
 3 files changed, 249 insertions(+)
 create mode 100644 arch/powerpc/platforms/powernv/processor_idle.c

diff --git a/arch/powerpc/platforms/powernv/Kconfig b/arch/powerpc/platforms/powernv/Kconfig
index c24684c..ace2d22 100644
--- a/arch/powerpc/platforms/powernv/Kconfig
+++ b/arch/powerpc/platforms/powernv/Kconfig
@@ -20,3 +20,12 @@ config PPC_POWERNV_RTAS
 	default y
 	select PPC_ICS_RTAS
 	select PPC_RTAS
+
+config POWERNV_IDLE
+	bool "CPUIdle driver for powernv platform"
+	depends on CPU_IDLE
+	depends on PPC_POWERNV
+	default y
+	help
+	Select this option to enable processor idle state management
+	through cpuidle subsystem.
diff --git a/arch/powerpc/platforms/powernv/Makefile b/arch/powerpc/platforms/powernv/Makefile
index 7fe5951..c0e44eb 100644
--- a/arch/powerpc/platforms/powernv/Makefile
+++ b/arch/powerpc/platforms/powernv/Makefile
@@ -4,3 +4,4 @@ obj-y			+= opal-rtc.o opal-nvram.o
 obj-$(CONFIG_SMP)	+= smp.o
 obj-$(CONFIG_PCI)	+= pci.o pci-p5ioc2.o pci-ioda.o
 obj-$(CONFIG_EEH)	+= eeh-ioda.o eeh-powernv.o
+obj-$(CONFIG_POWERNV_IDLE)     += processor_idle.o
diff --git a/arch/powerpc/platforms/powernv/processor_idle.c b/arch/powerpc/platforms/powernv/processor_idle.c
new file mode 100644
index 0000000..f43ad91a
--- /dev/null
+++ b/arch/powerpc/platforms/powernv/processor_idle.c
@@ -0,0 +1,239 @@
+/*
+ *  processor_idle - idle state cpuidle driver.
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
+#include <asm/runlatch.h>
+
+struct cpuidle_driver powernv_idle_driver = {
+	.name =		"powernv_idle",
+	.owner =	THIS_MODULE,
+};
+
+#define MAX_IDLE_STATE_COUNT	2
+
+static int max_idle_state = MAX_IDLE_STATE_COUNT - 1;
+static struct cpuidle_device __percpu *powernv_cpuidle_devices;
+static struct cpuidle_state *cpuidle_state_table;
+
+static int snooze_loop(struct cpuidle_device *dev,
+			struct cpuidle_driver *drv,
+			int index)
+{
+	int cpu = dev->cpu;
+
+	local_irq_enable();
+	set_thread_flag(TIF_POLLING_NRFLAG);
+
+	while ((!need_resched()) && cpu_online(cpu)) {
+		ppc64_runlatch_off();
+		HMT_very_low();
+	}
+
+	HMT_medium();
+	clear_thread_flag(TIF_POLLING_NRFLAG);
+	smp_mb();
+	return index;
+}
+
+
+static int nap_loop(struct cpuidle_device *dev,
+				struct cpuidle_driver *drv,
+				int index)
+{
+	ppc64_runlatch_off();
+	power7_idle();
+	return index;
+}
+
+/*
+ * States for dedicated partition case.
+ */
+static struct cpuidle_state powernv_states[MAX_IDLE_STATE_COUNT] = {
+	{ /* Snooze */
+		.name = "snooze",
+		.desc = "snooze",
+		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 0,
+		.target_residency = 0,
+		.enter = &snooze_loop },
+	 { /* Nap */
+		.name = "Nap",
+		.desc = "Nap",
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
+			per_cpu_ptr(powernv_cpuidle_devices, hotcpu);
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
+/* powernv_idle_devices_uninit(void)
+ * unregister cpuidle devices and de-allocate memory
+ */
+static void powernv_idle_devices_uninit(void)
+{
+	int i;
+	struct cpuidle_device *dev;
+
+	for_each_possible_cpu(i) {
+		dev = per_cpu_ptr(powernv_cpuidle_devices, i);
+		cpuidle_unregister_device(dev);
+	}
+
+	free_percpu(powernv_cpuidle_devices);
+	return;
+}
+
+/* powernv_idle_devices_init()
+ * allocate, initialize and register cpuidle device
+ */
+static int powernv_idle_devices_init(void)
+{
+	int i;
+	struct cpuidle_driver *drv = &powernv_idle_driver;
+	struct cpuidle_device *dev;
+
+	powernv_cpuidle_devices = alloc_percpu(struct cpuidle_device);
+	if (powernv_cpuidle_devices == NULL)
+		return -ENOMEM;
+
+	for_each_possible_cpu(i) {
+		dev = per_cpu_ptr(powernv_cpuidle_devices, i);
+		dev->state_count = drv->state_count;
+		dev->cpu = i;
+		if (cpuidle_register_device(dev)) {
+			printk(KERN_DEBUG \
+				"cpuidle_register_device %d failed!\n", i);
+			return -EIO;
+		}
+	}
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
+	cpuidle_state_table = powernv_states;
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
+	retval = cpuidle_register_driver(&powernv_idle_driver);
+	if (retval) {
+		printk(KERN_DEBUG "Registration of powernv driver failed.\n");
+		return retval;
+	}
+
+	retval = powernv_idle_devices_init();
+	if (retval) {
+		powernv_idle_devices_uninit();
+		cpuidle_unregister_driver(&powernv_idle_driver);
+		return retval;
+	}
+
+	register_cpu_notifier(&setup_hotplug_notifier);
+	printk(KERN_DEBUG "powernv_idle_driver registered\n");
+
+	return 0;
+}
+
+static void __exit powernv_processor_idle_exit(void)
+{
+
+	unregister_cpu_notifier(&setup_hotplug_notifier);
+	powernv_idle_devices_uninit();
+	cpuidle_unregister_driver(&powernv_idle_driver);
+
+	return;
+}
+
+module_init(powernv_processor_idle_init);
+module_exit(powernv_processor_idle_exit);
+
+MODULE_AUTHOR("Deepthi Dharwar <deepthi@linux.vnet.ibm.com>");
+MODULE_DESCRIPTION("Cpuidle driver for POWERNV");
+MODULE_LICENSE("GPL");

