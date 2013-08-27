Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab3H0Sbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 14:31:53 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:55311 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab3H0Sbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 14:31:52 -0400
Subject: [PATCH V6 2/7] pseries/cpuidle: Use cpuidle_register() for
 initialisation.
To: linux-pm@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: b.zolnierkie@samsung.com, benh@kernel.crashing.org,
        daniel.lezcano@linaro.org, dongsheng.wang@freescale.com,
        michael@ellerman.id.au, scottwood@freescale.com,
        srivatsa.bhat@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com
Date: Wed, 28 Aug 2013 00:01:00 +0530
Message-ID: <20130827183056.18579.32934.stgit@deepthi.in.ibm.com>
In-Reply-To: <20130827183016.18579.16595.stgit@deepthi.in.ibm.com>
References: <20130827183016.18579.16595.stgit@deepthi.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082718-5490-0000-0000-0000040D2499
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the cpuidle driver and devices initialisation
calls with a single generic cpuidle_register() call
and also includes minor refactoring of the code around it.

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---
 drivers/cpuidle/cpuidle-ibm-power.c |   80 +++++------------------------------
 1 file changed, 12 insertions(+), 68 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-ibm-power.c b/drivers/cpuidle/cpuidle-ibm-power.c
index c905b99..b42b948 100644
--- a/drivers/cpuidle/cpuidle-ibm-power.c
+++ b/drivers/cpuidle/cpuidle-ibm-power.c
@@ -1,5 +1,5 @@
 /*
- *  processor_idle - idle state cpuidle driver.
+ *  cpuidle-ibm-power - idle state cpuidle driver.
  *  Adapted from drivers/idle/intel_idle.c and
  *  drivers/acpi/processor_idle.c
  *
@@ -28,7 +28,6 @@ struct cpuidle_driver pseries_idle_driver = {
 #define MAX_IDLE_STATE_COUNT	2
 
 static int max_idle_state = MAX_IDLE_STATE_COUNT - 1;
-static struct cpuidle_device __percpu *pseries_cpuidle_devices;
 static struct cpuidle_state *cpuidle_state_table;
 
 static inline void idle_loop_prolog(unsigned long *in_purr)
@@ -52,13 +51,12 @@ static int snooze_loop(struct cpuidle_device *dev,
 			int index)
 {
 	unsigned long in_purr;
-	int cpu = dev->cpu;
 
 	idle_loop_prolog(&in_purr);
 	local_irq_enable();
 	set_thread_flag(TIF_POLLING_NRFLAG);
 
-	while ((!need_resched()) && cpu_online(cpu)) {
+	while (!need_resched()) {
 		ppc64_runlatch_off();
 		HMT_low();
 		HMT_very_low();
@@ -187,7 +185,7 @@ static int pseries_cpuidle_add_cpu_notifier(struct notifier_block *n,
 {
 	int hotcpu = (unsigned long)hcpu;
 	struct cpuidle_device *dev =
-			per_cpu_ptr(pseries_cpuidle_devices, hotcpu);
+			per_cpu(cpuidle_devices, hotcpu);
 
 	if (dev && cpuidle_get_driver()) {
 		switch (action) {
@@ -244,50 +242,6 @@ static int pseries_cpuidle_driver_init(void)
 	return 0;
 }
 
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
 /*
  * pseries_idle_probe()
  * Choose state table for shared versus dedicated partition
@@ -295,9 +249,6 @@ static int pseries_idle_devices_init(void)
 static int pseries_idle_probe(void)
 {
 
-	if (!firmware_has_feature(FW_FEATURE_SPLPAR))
-		return -ENODEV;
-
 	if (cpuidle_disable != IDLE_NO_OVERRIDE)
 		return -ENODEV;
 
@@ -306,10 +257,13 @@ static int pseries_idle_probe(void)
 		return -EPERM;
 	}
 
-	if (get_lppaca()->shared_proc)
-		cpuidle_state_table = shared_states;
-	else
-		cpuidle_state_table = dedicated_states;
+	if (firmware_has_feature(FW_FEATURE_SPLPAR)) {
+		if (get_lppaca()->shared_proc)
+			cpuidle_state_table = shared_states;
+		else
+			cpuidle_state_table = dedicated_states;
+	} else
+		return -ENODEV;
 
 	return 0;
 }
@@ -323,22 +277,14 @@ static int __init pseries_processor_idle_init(void)
 		return retval;
 
 	pseries_cpuidle_driver_init();
-	retval = cpuidle_register_driver(&pseries_idle_driver);
+	retval = cpuidle_register(&pseries_idle_driver, NULL);
 	if (retval) {
 		printk(KERN_DEBUG "Registration of pseries driver failed.\n");
 		return retval;
 	}
 
-	retval = pseries_idle_devices_init();
-	if (retval) {
-		pseries_idle_devices_uninit();
-		cpuidle_unregister_driver(&pseries_idle_driver);
-		return retval;
-	}
-
 	register_cpu_notifier(&setup_hotplug_notifier);
 	printk(KERN_DEBUG "pseries_idle_driver registered\n");
-
 	return 0;
 }
 
@@ -346,9 +292,7 @@ static void __exit pseries_processor_idle_exit(void)
 {
 
 	unregister_cpu_notifier(&setup_hotplug_notifier);
-	pseries_idle_devices_uninit();
-	cpuidle_unregister_driver(&pseries_idle_driver);
-
+	cpuidle_unregister(&pseries_idle_driver);
 	return;
 }
 

