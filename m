Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab3LTSsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 13:48:30 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:43332 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab3LTSs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 13:48:26 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-cc-52b490f8e716
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: rjw@rjwysocki.net
Cc: daniel.lezcano@linaro.org, lenb@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com
Subject: [PATCH v2 8/9] intel_idle: use the common cpuidle_[un]register()
 routines
Date: Fri, 20 Dec 2013 19:47:30 +0100
Message-id: <1387565251-7051-9-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1387565251-7051-1-git-send-email-b.zolnierkie@samsung.com>
References: <1387565251-7051-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrALMWRmVeSWpSXmKPExsVy+t9jQd0fE7YEGSzqtbHYOGM9q8W8z7IW
	Z5vesFvsfPiWzeLyrjlsFp97jzBazDi/j8ni9/d/rBZnTl9ideD02LSqk83jzrU9bB7nZyxk
	9NhytZ3Fo2/LKkaPz5vkAtiiuGxSUnMyy1KL9O0SuDKWfe9mLDilWzH3/hHGBsY3ql2MHBwS
	AiYSr5ZIdDFyApliEhfurWcDsYUEpjNK3O7R72LkArK7mCT27pzHApJgE7CSmNi+ihHEFhEQ
	lbi8ewILSBGzwGNGidlNU5hBEsICIRIrLq1nBbFZBFQljr38yAyyjFfAXWL2e0aIZYoS3c8m
	gC3jFPCQmP1qORPEYneJE12/mScw8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERxu
	z6R2MK5ssDjEKMDBqMTDWxC9JUiINbGsuDL3EKMEB7OSCO/NNqAQb0piZVVqUX58UWlOavEh
	RmkOFiVx3gOt1oFCAumJJanZqakFqUUwWSYOTqkGRrmalqNhzmWzja+s3X3YO/lt3OH2n7ll
	/We2vNRvu/hQlD+2lWPt7fbph3Zv0VC4qTu998qS7sCm/+Fs9yLmfIq2OaUb0rX0+ZbvCsvK
	/JT/C8ppbpw5+YDJ0tZiGf4ZBXt3XP/2xuv03FdLfE4lnjVLWLF3benZtem3lxxcfDRRgmMZ
	l5BMzVQlluKMREMt5qLiRABEalNkMwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is now possible to use the common cpuidle_[un]register() routines
(instead of open-coding them) so do it.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Len Brown <lenb@kernel.org>
---
 drivers/idle/intel_idle.c | 114 ++++++++++++----------------------------------
 1 file changed, 29 insertions(+), 85 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 524d07b..a1a4dbd 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -93,10 +93,8 @@ struct idle_cpu {
 };
 
 static const struct idle_cpu *icpu;
-static struct cpuidle_device __percpu *intel_idle_cpuidle_devices;
 static int intel_idle(struct cpuidle_device *dev,
 			struct cpuidle_driver *drv, int index);
-static int intel_idle_cpu_init(int cpu);
 
 static struct cpuidle_state *cpuidle_state_table;
 
@@ -400,11 +398,27 @@ static void __setup_broadcast_timer(void *arg)
 	clockevents_notify(reason, &cpu);
 }
 
+static void auto_demotion_disable(void *dummy)
+{
+	unsigned long long msr_bits;
+
+	rdmsrl(MSR_NHM_SNB_PKG_CST_CFG_CTL, msr_bits);
+	msr_bits &= ~(icpu->auto_demotion_disable_flags);
+	wrmsrl(MSR_NHM_SNB_PKG_CST_CFG_CTL, msr_bits);
+}
+static void c1e_promotion_disable(void *dummy)
+{
+	unsigned long long msr_bits;
+
+	rdmsrl(MSR_IA32_POWER_CTL, msr_bits);
+	msr_bits &= ~0x2;
+	wrmsrl(MSR_IA32_POWER_CTL, msr_bits);
+}
+
 static int cpu_hotplug_notify(struct notifier_block *n,
 			      unsigned long action, void *hcpu)
 {
 	int hotcpu = (unsigned long)hcpu;
-	struct cpuidle_device *dev;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_ONLINE:
@@ -416,11 +430,15 @@ static int cpu_hotplug_notify(struct notifier_block *n,
 		/*
 		 * Some systems can hotplug a cpu at runtime after
 		 * the kernel has booted, we have to initialize the
-		 * driver in this case
+		 * hardware in this case.
 		 */
-		dev = per_cpu_ptr(intel_idle_cpuidle_devices, hotcpu);
-		if (!dev->registered)
-			intel_idle_cpu_init(hotcpu);
+		if (icpu->auto_demotion_disable_flags)
+			smp_call_function_single(hotcpu, auto_demotion_disable,
+						NULL, 1);
+
+		if (icpu->disable_promotion_to_c1e)
+			smp_call_function_single(hotcpu, c1e_promotion_disable,
+						NULL, 1);
 
 		break;
 	}
@@ -431,23 +449,6 @@ static struct notifier_block cpu_hotplug_notifier = {
 	.notifier_call = cpu_hotplug_notify,
 };
 
-static void auto_demotion_disable(void *dummy)
-{
-	unsigned long long msr_bits;
-
-	rdmsrl(MSR_NHM_SNB_PKG_CST_CFG_CTL, msr_bits);
-	msr_bits &= ~(icpu->auto_demotion_disable_flags);
-	wrmsrl(MSR_NHM_SNB_PKG_CST_CFG_CTL, msr_bits);
-}
-static void c1e_promotion_disable(void *dummy)
-{
-	unsigned long long msr_bits;
-
-	rdmsrl(MSR_IA32_POWER_CTL, msr_bits);
-	msr_bits &= ~0x2;
-	wrmsrl(MSR_IA32_POWER_CTL, msr_bits);
-}
-
 static const struct idle_cpu idle_cpu_nehalem = {
 	.state_table = nehalem_cstates,
 	.auto_demotion_disable_flags = NHM_C1_AUTO_DEMOTE | NHM_C3_AUTO_DEMOTE,
@@ -560,23 +561,6 @@ static int __init intel_idle_probe(void)
 }
 
 /*
- * intel_idle_cpuidle_devices_uninit()
- * unregister, free cpuidle_devices
- */
-static void intel_idle_cpuidle_devices_uninit(void)
-{
-	int i;
-	struct cpuidle_device *dev;
-
-	for_each_online_cpu(i) {
-		dev = per_cpu_ptr(intel_idle_cpuidle_devices, i);
-		cpuidle_unregister_device(dev);
-	}
-
-	free_percpu(intel_idle_cpuidle_devices);
-	return;
-}
-/*
  * intel_idle_cpuidle_driver_init()
  * allocate, initialize cpuidle_states
  */
@@ -632,37 +616,9 @@ static int __init intel_idle_cpuidle_driver_init(void)
 }
 
 
-/*
- * intel_idle_cpu_init()
- * allocate, initialize, register cpuidle_devices
- * @cpu: cpu/core to initialize
- */
-static int intel_idle_cpu_init(int cpu)
-{
-	struct cpuidle_device *dev;
-
-	dev = per_cpu_ptr(intel_idle_cpuidle_devices, cpu);
-
-	dev->cpu = cpu;
-
-	if (cpuidle_register_device(dev)) {
-		pr_debug(PREFIX "cpuidle_register_device %d failed!\n", cpu);
-		intel_idle_cpuidle_devices_uninit();
-		return -EIO;
-	}
-
-	if (icpu->auto_demotion_disable_flags)
-		smp_call_function_single(cpu, auto_demotion_disable, NULL, 1);
-
-	if (icpu->disable_promotion_to_c1e)
-		smp_call_function_single(cpu, c1e_promotion_disable, NULL, 1);
-
-	return 0;
-}
-
 static int __init intel_idle_init(void)
 {
-	int retval, i;
+	int retval;
 
 	/* Do not load intel_idle at all for now if idle= is passed */
 	if (boot_option_idle_override != IDLE_NO_OVERRIDE)
@@ -673,7 +629,8 @@ static int __init intel_idle_init(void)
 		return retval;
 
 	intel_idle_cpuidle_driver_init();
-	retval = cpuidle_register_driver(&intel_idle_driver);
+
+	retval = cpuidle_register(&intel_idle_driver, NULL);
 	if (retval) {
 		struct cpuidle_driver *drv = cpuidle_get_driver();
 		printk(KERN_DEBUG PREFIX "intel_idle yielding to %s",
@@ -681,17 +638,6 @@ static int __init intel_idle_init(void)
 		return retval;
 	}
 
-	intel_idle_cpuidle_devices = alloc_percpu(struct cpuidle_device);
-	if (intel_idle_cpuidle_devices == NULL)
-		return -ENOMEM;
-
-	for_each_online_cpu(i) {
-		retval = intel_idle_cpu_init(i);
-		if (retval) {
-			cpuidle_unregister_driver(&intel_idle_driver);
-			return retval;
-		}
-	}
 	register_cpu_notifier(&cpu_hotplug_notifier);
 
 	return 0;
@@ -699,9 +645,7 @@ static int __init intel_idle_init(void)
 
 static void __exit intel_idle_exit(void)
 {
-	intel_idle_cpuidle_devices_uninit();
-	cpuidle_unregister_driver(&intel_idle_driver);
-
+	cpuidle_unregister(&intel_idle_driver);
 
 	if (lapic_timer_reliable_states != LAPIC_TIMER_ALWAYS_RELIABLE)
 		on_each_cpu(__setup_broadcast_timer, (void *)false, 1);
-- 
1.8.2.3

