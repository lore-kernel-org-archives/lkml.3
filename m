Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbaANK4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 05:56:01 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:40330 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbaANKz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 05:55:57 -0500
Subject: [PATCH v1 3/6] pseries/cpuidle: Use cpuidle_register() for
 initialisation.
To: linux-pm@vger.kernel.org, benh@kernel.crashing.org,
        daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Date: Tue, 14 Jan 2014 16:26:09 +0530
Message-ID: <20140114105607.3064.15745.stgit@deepthi.in.ibm.com>
In-Reply-To: <20140114105525.3064.52013.stgit@deepthi.in.ibm.com>
References: <20140114105525.3064.52013.stgit@deepthi.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011410-8878-0000-0000-00000A73F0A8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the cpuidle driver and devices initialisation
calls with a single generic cpuidle_register() call
and also includes minor refactoring of the code around it.

Remove the cpu online check in snooze loop, as this code can
only locally run on a cpu only if it is online. Therefore,
this check is not required.

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---
 drivers/cpuidle/cpuidle-pseries.c |   78 +++++--------------------------------
 1 file changed, 11 insertions(+), 67 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-pseries.c b/drivers/cpuidle/cpuidle-pseries.c
index 2115478..32d86bc 100644
--- a/drivers/cpuidle/cpuidle-pseries.c
+++ b/drivers/cpuidle/cpuidle-pseries.c
@@ -27,7 +27,6 @@ struct cpuidle_driver pseries_idle_driver = {
 #define MAX_IDLE_STATE_COUNT	2
 
 static int max_idle_state = MAX_IDLE_STATE_COUNT - 1;
-static struct cpuidle_device __percpu *pseries_cpuidle_devices;
 static struct cpuidle_state *cpuidle_state_table;
 
 static inline void idle_loop_prolog(unsigned long *in_purr)
@@ -55,13 +54,12 @@ static int snooze_loop(struct cpuidle_device *dev,
 			int index)
 {
 	unsigned long in_purr;
-	int cpu = dev->cpu;
 
 	idle_loop_prolog(&in_purr);
 	local_irq_enable();
 	set_thread_flag(TIF_POLLING_NRFLAG);
 
-	while ((!need_resched()) && cpu_online(cpu)) {
+	while (!need_resched()) {
 		HMT_low();
 		HMT_very_low();
 	}
@@ -188,7 +186,7 @@ static int pseries_cpuidle_add_cpu_notifier(struct notifier_block *n,
 {
 	int hotcpu = (unsigned long)hcpu;
 	struct cpuidle_device *dev =
-			per_cpu_ptr(pseries_cpuidle_devices, hotcpu);
+				per_cpu(cpuidle_devices, hotcpu);
 
 	if (dev && cpuidle_get_driver()) {
 		switch (action) {
@@ -245,50 +243,6 @@ static int pseries_cpuidle_driver_init(void)
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
@@ -296,9 +250,6 @@ static int pseries_idle_devices_init(void)
 static int pseries_idle_probe(void)
 {
 
-	if (!firmware_has_feature(FW_FEATURE_SPLPAR))
-		return -ENODEV;
-
 	if (cpuidle_disable != IDLE_NO_OVERRIDE)
 		return -ENODEV;
 
@@ -307,10 +258,13 @@ static int pseries_idle_probe(void)
 		return -EPERM;
 	}
 
-	if (lppaca_shared_proc(get_lppaca()))
-		cpuidle_state_table = shared_states;
-	else
-		cpuidle_state_table = dedicated_states;
+	if (firmware_has_feature(FW_FEATURE_SPLPAR)) {
+		if (lppaca_shared_proc(get_lppaca()))
+			cpuidle_state_table = shared_states;
+		else
+			cpuidle_state_table = dedicated_states;
+	} else
+		return -ENODEV;
 
 	return 0;
 }
@@ -324,22 +278,14 @@ static int __init pseries_processor_idle_init(void)
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
 
@@ -347,9 +293,7 @@ static void __exit pseries_processor_idle_exit(void)
 {
 
 	unregister_cpu_notifier(&setup_hotplug_notifier);
-	pseries_idle_devices_uninit();
-	cpuidle_unregister_driver(&pseries_idle_driver);
-
+	cpuidle_unregister(&pseries_idle_driver);
 	return;
 }
 

