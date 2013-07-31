Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077Ab3GaDA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 23:00:56 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:53249 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758994Ab3GaDAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 23:00:53 -0400
Subject: [PATCH V2 5/6] cpuidle/powerpc: Backend-powerpc idle driver for
 powernv and pseries.
To: benh@kernel.crashing.org, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au,
        srivatsa.bhat@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, dongsheng.wang@freescale.com, linux-pm@vger.kernel.org
Date: Wed, 31 Jul 2013 08:29:38 +0530
Message-ID: <20130731025934.19448.16658.stgit@deepthi>
In-Reply-To: <20130731025840.19448.24468.stgit@deepthi>
References: <20130731025840.19448.24468.stgit@deepthi>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073102-5490-0000-0000-000003E97484
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch extends the current pseries backend
idle driver to powernv platform.

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/processor.h |    2 -
 arch/powerpc/sysdev/Kconfig          |    8 +-
 arch/powerpc/sysdev/Makefile         |    2 -
 arch/powerpc/sysdev/processor_idle.c |  132 ++++++++++++++++++++++------------
 4 files changed, 92 insertions(+), 52 deletions(-)

diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index 47a35b0..e64b817 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -426,7 +426,7 @@ enum idle_boot_override {IDLE_NO_OVERRIDE = 0, IDLE_POWERSAVE_OFF};
 extern int powersave_nap;	/* set if nap mode can be used in idle loop */
 extern void power7_nap(void);
 
-#ifdef CONFIG_PSERIES_IDLE
+#ifdef CONFIG_POWERPC_IDLE
 extern void update_smt_snooze_delay(int cpu, int residency);
 #else
 static inline void update_smt_snooze_delay(int cpu, int residency) {}
diff --git a/arch/powerpc/sysdev/Kconfig b/arch/powerpc/sysdev/Kconfig
index 8564a3f..f61d794 100644
--- a/arch/powerpc/sysdev/Kconfig
+++ b/arch/powerpc/sysdev/Kconfig
@@ -35,11 +35,11 @@ config GE_FPGA
 	bool
 	default n
 
-config PSERIES_IDLE
-	bool "Cpuidle driver for pSeries platforms"
+config POWERPC_IDLE
+	bool "Cpuidle driver for POWERPC platforms"
 	depends on CPU_IDLE
-	depends on PPC_PSERIES
+	depends on PPC_PSERIES || PPC_POWERNV
 	default y
 	help
 	  Select this option to enable processor idle state management
-	  for pSeries through cpuidle subsystem.
+	  for POWER and POWERNV through cpuidle subsystem.
diff --git a/arch/powerpc/sysdev/Makefile b/arch/powerpc/sysdev/Makefile
index 93d2cdd..ec290e2 100644
--- a/arch/powerpc/sysdev/Makefile
+++ b/arch/powerpc/sysdev/Makefile
@@ -49,7 +49,7 @@ endif
 obj-$(CONFIG_PPC4xx_MSI)	+= ppc4xx_msi.o
 obj-$(CONFIG_PPC4xx_CPM)	+= ppc4xx_cpm.o
 obj-$(CONFIG_PPC4xx_GPIO)	+= ppc4xx_gpio.o
-obj-$(CONFIG_PSERIES_IDLE)	+= processor_idle.o
+obj-$(CONFIG_POWERPC_IDLE)	+= processor_idle.o
 
 obj-$(CONFIG_CPM)		+= cpm_common.o
 obj-$(CONFIG_CPM2)		+= cpm2.o cpm2_pic.o
diff --git a/arch/powerpc/sysdev/processor_idle.c b/arch/powerpc/sysdev/processor_idle.c
index 0d75a54..d152f540d 100644
--- a/arch/powerpc/sysdev/processor_idle.c
+++ b/arch/powerpc/sysdev/processor_idle.c
@@ -20,18 +20,18 @@
 #include <asm/runlatch.h>
 #include <asm/plpar_wrappers.h>
 
-/* Snooze Delay, pseries_idle */
+/* Snooze Delay, powerpc_idle */
 DECLARE_PER_CPU(long, smt_snooze_delay);
 
-struct cpuidle_driver pseries_idle_driver = {
-	.name             = "pseries_idle",
+struct cpuidle_driver powerpc_idle_driver = {
+	.name             = "powerpc_idle",
 	.owner            = THIS_MODULE,
 };
 
 #define MAX_IDLE_STATE_COUNT	2
 
 static int max_idle_state = MAX_IDLE_STATE_COUNT - 1;
-static struct cpuidle_device __percpu *pseries_cpuidle_devices;
+static struct cpuidle_device __percpu *powerpc_cpuidle_devices;
 static struct cpuidle_state *cpuidle_state_table;
 
 static inline void idle_loop_prolog(unsigned long *in_purr)
@@ -55,13 +55,14 @@ static int snooze_loop(struct cpuidle_device *dev,
 			int index)
 {
 	unsigned long in_purr;
-	int cpu = dev->cpu;
 
+#ifndef PPC_POWERNV
 	idle_loop_prolog(&in_purr);
+#endif
 	local_irq_enable();
 	set_thread_flag(TIF_POLLING_NRFLAG);
 
-	while ((!need_resched()) && cpu_online(cpu)) {
+	while (!need_resched()) {
 		ppc64_runlatch_off();
 		HMT_low();
 		HMT_very_low();
@@ -71,7 +72,9 @@ static int snooze_loop(struct cpuidle_device *dev,
 	clear_thread_flag(TIF_POLLING_NRFLAG);
 	smp_mb();
 
+#ifndef PPC_POWERNV
 	idle_loop_epilog(in_purr);
+#endif
 
 	return index;
 }
@@ -135,10 +138,21 @@ static int shared_cede_loop(struct cpuidle_device *dev,
 	return index;
 }
 
+#ifdef PPC_POWERNV
+static int nap_loop(struct cpuidle_device *dev,
+			struct cpuidle_driver *drv,
+			int index)
+{
+	ppc64_runlatch_off();
+	power7_idle();
+	return index;
+}
+#endif
+
 /*
  * States for dedicated partition case.
  */
-static struct cpuidle_state dedicated_states[MAX_IDLE_STATE_COUNT] = {
+static struct cpuidle_state pseries_dedicated_states[MAX_IDLE_STATE_COUNT] = {
 	{ /* Snooze */
 		.name = "snooze",
 		.desc = "snooze",
@@ -158,7 +172,7 @@ static struct cpuidle_state dedicated_states[MAX_IDLE_STATE_COUNT] = {
 /*
  * States for shared partition case.
  */
-static struct cpuidle_state shared_states[MAX_IDLE_STATE_COUNT] = {
+static struct cpuidle_state pseries_shared_states[MAX_IDLE_STATE_COUNT] = {
 	{ /* Shared Cede */
 		.name = "Shared Cede",
 		.desc = "Shared Cede",
@@ -168,13 +182,34 @@ static struct cpuidle_state shared_states[MAX_IDLE_STATE_COUNT] = {
 		.enter = &shared_cede_loop },
 };
 
+#ifdef PPC_POWERNV
+static struct cpuidle_state powernv_states[MAX_IDLE_STATE_COUNT] = {
+	 { /* Snooze */
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
+		.enter = &nap_loop },
+};
+#endif
+
 void update_smt_snooze_delay(int cpu, int residency)
 {
 	struct cpuidle_driver *drv = cpuidle_get_driver();
 	struct cpuidle_device *dev;
 
-	if (cpuidle_state_table != dedicated_states)
+#ifndef PPC_POWERNV
+	if (cpuidle_state_table != pseries_dedicated_states)
 		return;
+#endif
 
 	if (!drv)
 		return;
@@ -204,12 +239,12 @@ void update_smt_snooze_delay(int cpu, int residency)
 	}
 }
 
-static int pseries_cpuidle_add_cpu_notifier(struct notifier_block *n,
+static int powerpc_cpuidle_add_cpu_notifier(struct notifier_block *n,
 			unsigned long action, void *hcpu)
 {
 	int hotcpu = (unsigned long)hcpu;
 	struct cpuidle_device *dev =
-			per_cpu_ptr(pseries_cpuidle_devices, hotcpu);
+			per_cpu_ptr(powerpc_cpuidle_devices, hotcpu);
 
 	if (dev && cpuidle_get_driver()) {
 		switch (action) {
@@ -235,16 +270,16 @@ static int pseries_cpuidle_add_cpu_notifier(struct notifier_block *n,
 }
 
 static struct notifier_block setup_hotplug_notifier = {
-	.notifier_call = pseries_cpuidle_add_cpu_notifier,
+	.notifier_call = powerpc_cpuidle_add_cpu_notifier,
 };
 
 /*
- * pseries_cpuidle_driver_init()
+ * powerpc_cpuidle_driver_init()
  */
-static int pseries_cpuidle_driver_init(void)
+static int powerpc_cpuidle_driver_init(void)
 {
 	int idle_state;
-	struct cpuidle_driver *drv = &pseries_idle_driver;
+	struct cpuidle_driver *drv = &powerpc_idle_driver;
 
 	drv->state_count = 0;
 
@@ -266,38 +301,38 @@ static int pseries_cpuidle_driver_init(void)
 	return 0;
 }
 
-/* pseries_idle_devices_uninit(void)
+/* powerpc_idle_devices_uninit(void)
  * unregister cpuidle devices and de-allocate memory
  */
-static void pseries_idle_devices_uninit(void)
+static void powerpc_idle_devices_uninit(void)
 {
 	int i;
 	struct cpuidle_device *dev;
 
 	for_each_possible_cpu(i) {
-		dev = per_cpu_ptr(pseries_cpuidle_devices, i);
+		dev = per_cpu_ptr(powerpc_cpuidle_devices, i);
 		cpuidle_unregister_device(dev);
 	}
 
-	free_percpu(pseries_cpuidle_devices);
+	free_percpu(powerpc_cpuidle_devices);
 	return;
 }
 
-/* pseries_idle_devices_init()
+/* powerpc_idle_devices_init()
  * allocate, initialize and register cpuidle device
  */
-static int pseries_idle_devices_init(void)
+static int powerpc_idle_devices_init(void)
 {
 	int i;
-	struct cpuidle_driver *drv = &pseries_idle_driver;
+	struct cpuidle_driver *drv = &powerpc_idle_driver;
 	struct cpuidle_device *dev;
 
-	pseries_cpuidle_devices = alloc_percpu(struct cpuidle_device);
-	if (pseries_cpuidle_devices == NULL)
+	powerpc_cpuidle_devices = alloc_percpu(struct cpuidle_device);
+	if (powerpc_cpuidle_devices == NULL)
 		return -ENOMEM;
 
 	for_each_possible_cpu(i) {
-		dev = per_cpu_ptr(pseries_cpuidle_devices, i);
+		dev = per_cpu_ptr(powerpc_cpuidle_devices, i);
 		dev->state_count = drv->state_count;
 		dev->cpu = i;
 		if (cpuidle_register_device(dev)) {
@@ -311,74 +346,79 @@ static int pseries_idle_devices_init(void)
 }
 
 /*
- * pseries_idle_probe()
+ * powerpc_idle_probe()
  * Choose state table for shared versus dedicated partition
  */
-static int pseries_idle_probe(void)
+static int powerpc_idle_probe(void)
 {
 
+#ifndef PPC_POWERNV
 	if (!firmware_has_feature(FW_FEATURE_SPLPAR))
 		return -ENODEV;
+#endif
 
 	if (cpuidle_disable != IDLE_NO_OVERRIDE)
 		return -ENODEV;
 
 	if (max_idle_state == 0) {
-		printk(KERN_DEBUG "pseries processor idle disabled.\n");
+		printk(KERN_DEBUG "powerpc processor idle disabled.\n");
 		return -EPERM;
 	}
 
+#ifdef PPC_POWERNV
+	cpuidle_state_table = powernv_states;
+#else
 	if (get_lppaca()->shared_proc)
-		cpuidle_state_table = shared_states;
+		cpuidle_state_table = pseries_shared_states;
 	else
-		cpuidle_state_table = dedicated_states;
-
+		cpuidle_state_table = pseries_dedicated_states;
+#endif
 	return 0;
 }
 
-static int __init pseries_processor_idle_init(void)
+static int __init powerpc_processor_idle_init(void)
 {
 	int retval;
 
-	retval = pseries_idle_probe();
+	retval = powerpc_idle_probe();
 	if (retval)
 		return retval;
 
-	pseries_cpuidle_driver_init();
-	retval = cpuidle_register_driver(&pseries_idle_driver);
+	powerpc_cpuidle_driver_init();
+	retval = cpuidle_register_driver(&powerpc_idle_driver);
 	if (retval) {
-		printk(KERN_DEBUG "Registration of pseries driver failed.\n");
+		printk(KERN_DEBUG "Registration of powerpc driver failed.\n");
 		return retval;
 	}
 
 	update_smt_snooze_delay(-1, per_cpu(smt_snooze_delay, 0));
 
-	retval = pseries_idle_devices_init();
+	retval = powerpc_idle_devices_init();
 	if (retval) {
-		pseries_idle_devices_uninit();
-		cpuidle_unregister_driver(&pseries_idle_driver);
+		powerpc_idle_devices_uninit();
+		cpuidle_unregister_driver(&powerpc_idle_driver);
 		return retval;
 	}
 
 	register_cpu_notifier(&setup_hotplug_notifier);
-	printk(KERN_DEBUG "pseries_idle_driver registered\n");
+	printk(KERN_DEBUG "powerpc_idle_driver registered\n");
 
 	return 0;
 }
 
-static void __exit pseries_processor_idle_exit(void)
+static void __exit powerpc_processor_idle_exit(void)
 {
 
 	unregister_cpu_notifier(&setup_hotplug_notifier);
-	pseries_idle_devices_uninit();
-	cpuidle_unregister_driver(&pseries_idle_driver);
+	powerpc_idle_devices_uninit();
+	cpuidle_unregister_driver(&powerpc_idle_driver);
 
 	return;
 }
 
-module_init(pseries_processor_idle_init);
-module_exit(pseries_processor_idle_exit);
+module_init(powerpc_processor_idle_init);
+module_exit(powerpc_processor_idle_exit);
 
 MODULE_AUTHOR("Deepthi Dharwar <deepthi@linux.vnet.ibm.com>");
-MODULE_DESCRIPTION("Cpuidle driver for POWER");
+MODULE_DESCRIPTION("Cpuidle driver for POWERPC");
 MODULE_LICENSE("GPL");

