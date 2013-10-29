Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab3J2LCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:02:15 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:55143 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab3J2LCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:02:13 -0400
Subject: [PATCH V7 5/7] POWER/cpuidle: Generic POWER CPUIDLE driver
 supporting PSERIES.
To: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: daniel.lezcano@linaro.org, michael@ellerman.id.au, scottwood@freescale.com,
        srivatsa.bhat@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com,
        linux-pm@lists.linux-foundation.org, svaidy@linux.vnet.ibm.com
Date: Tue, 29 Oct 2013 16:31:49 +0530
Message-ID: <20131029110148.31547.8944.stgit@deepthi.in.ibm.com>
In-Reply-To: <20131029110052.31547.82682.stgit@deepthi.in.ibm.com>
References: <20131029110052.31547.82682.stgit@deepthi.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102911-5816-0000-0000-00000AA10ED5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes cleanup and refactoring of the
existing code to make the driver POWER generic.
* Re-naming the functions from pseries to generic power.
* Re-naming the backend driver from pseries_idle to
  ibm-power-idle.

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---
 drivers/cpuidle/cpuidle-ibm-power.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-ibm-power.c b/drivers/cpuidle/cpuidle-ibm-power.c
index e81c207..5b92242 100644
--- a/drivers/cpuidle/cpuidle-ibm-power.c
+++ b/drivers/cpuidle/cpuidle-ibm-power.c
@@ -20,8 +20,8 @@
 #include <asm/runlatch.h>
 #include <asm/plpar_wrappers.h>
 
-struct cpuidle_driver pseries_idle_driver = {
-	.name             = "pseries_idle",
+struct cpuidle_driver power_idle_driver = {
+	.name             = "ibm_power_idle",
 	.owner            = THIS_MODULE,
 };
 
@@ -182,7 +182,7 @@ void update_smt_snooze_delay(int cpu, int residency)
 			drv->states[1].target_residency = residency;
 }
 
-static int pseries_cpuidle_add_cpu_notifier(struct notifier_block *n,
+static int power_cpuidle_add_cpu_notifier(struct notifier_block *n,
 			unsigned long action, void *hcpu)
 {
 	int hotcpu = (unsigned long)hcpu;
@@ -213,16 +213,16 @@ static int pseries_cpuidle_add_cpu_notifier(struct notifier_block *n,
 }
 
 static struct notifier_block setup_hotplug_notifier = {
-	.notifier_call = pseries_cpuidle_add_cpu_notifier,
+	.notifier_call = power_cpuidle_add_cpu_notifier,
 };
 
 /*
- * pseries_cpuidle_driver_init()
+ * power_cpuidle_driver_init()
  */
-static int pseries_cpuidle_driver_init(void)
+static int power_cpuidle_driver_init(void)
 {
 	int idle_state;
-	struct cpuidle_driver *drv = &pseries_idle_driver;
+	struct cpuidle_driver *drv = &power_idle_driver;
 
 	drv->state_count = 0;
 	for (idle_state = 0; idle_state < max_idle_state; ++idle_state) {
@@ -241,10 +241,10 @@ static int pseries_cpuidle_driver_init(void)
 }
 
 /*
- * pseries_idle_probe()
+ * power_idle_probe()
  * Choose state table for shared versus dedicated partition
  */
-static int pseries_idle_probe(void)
+static int power_idle_probe(void)
 {
 
 	if (cpuidle_disable != IDLE_NO_OVERRIDE)
@@ -264,24 +264,24 @@ static int pseries_idle_probe(void)
 	return 0;
 }
 
-static int __init pseries_processor_idle_init(void)
+static int __init power_processor_idle_init(void)
 {
 	int retval;
 
-	retval = pseries_idle_probe();
+	retval = power_idle_probe();
 	if (retval)
 		return retval;
 
-	pseries_cpuidle_driver_init();
-	retval = cpuidle_register(&pseries_idle_driver, NULL);
+	power_cpuidle_driver_init();
+	retval = cpuidle_register(&power_idle_driver, NULL);
 	if (retval) {
-		printk(KERN_DEBUG "Registration of pseries driver failed.\n");
+		printk(KERN_DEBUG "Registration of ibm_power_idle driver failed.\n");
 		return retval;
 	}
 
 	register_cpu_notifier(&setup_hotplug_notifier);
-	printk(KERN_DEBUG "pseries_idle_driver registered\n");
+	printk(KERN_DEBUG "ibm_power_idle registered\n");
 	return 0;
 }
 
-device_initcall(pseries_processor_idle_init);
+device_initcall(power_processor_idle_init);

