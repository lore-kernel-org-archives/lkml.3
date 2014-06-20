Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaFTObW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 10:31:22 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20624 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbaFTObT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 10:31:19 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: bp@alien8.de, tony.luck@intel.com
Cc: linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        mattieu.souchaud@free.fr, boris.ostrovsky@oracle.com
Subject: [PATCH] x86/mce: Don't unregister CPU hotplug notifier in error path
Date: Fri, 20 Jun 2014 10:28:13 -0400
Message-Id: <1403274493-1371-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9c15a24b038f4d8da93a2bc2554731f8953a7c17 (x86/mce: Improve
mcheck_init_device() error handling) unregisters (or never registers)
MCE's hotplug notifier if an error is encountered.

Since unplugging a CPU would normally result in the notifier deleting
MCE timer we are now left with the timer running if a CPU is removed on
a system where mcheck_init_device() had failed.

If we later hotplug this CPU back we add this timer again in
mcheck_cpu_init()). Eventually the two timers start intefering with each
other, causing soft lockups or system hangs.

We should leave the notifier always on and, in fact, set it up early
during the boot.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 42 ++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index bb92f38..0d2828a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1677,6 +1677,11 @@ static void unexpected_machine_check(struct pt_regs *regs, long error_code)
 void (*machine_check_vector)(struct pt_regs *, long error_code) =
 						unexpected_machine_check;
 
+static int
+mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu);
+static struct notifier_block mce_cpu_notifier = {
+	.notifier_call = mce_cpu_callback,
+};
 /*
  * Called for each booted CPU to set up machine checks.
  * Must be called with preempt off:
@@ -1704,6 +1709,9 @@ void mcheck_cpu_init(struct cpuinfo_x86 *c)
 	__mcheck_cpu_init_timer();
 	INIT_WORK(&__get_cpu_var(mce_work), mce_process_work);
 	init_irq_work(&__get_cpu_var(mce_irq_work), &mce_irq_work_cb);
+
+	if (c == &boot_cpu_data)
+		register_cpu_notifier(&mce_cpu_notifier); /* pre-SMP */
 }
 
 /*
@@ -1951,6 +1959,7 @@ static struct miscdevice mce_chrdev_device = {
 	"mcelog",
 	&mce_chrdev_ops,
 };
+static bool is_mce_chrdev_set;
 
 static void __mce_disable_bank(void *arg)
 {
@@ -2376,14 +2385,18 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_ONLINE:
-		mce_device_create(cpu);
-		if (threshold_cpu_callback)
-			threshold_cpu_callback(action, cpu);
+		if (is_mce_chrdev_set) {
+			mce_device_create(cpu);
+			if (threshold_cpu_callback)
+				threshold_cpu_callback(action, cpu);
+		}
 		break;
 	case CPU_DEAD:
-		if (threshold_cpu_callback)
-			threshold_cpu_callback(action, cpu);
-		mce_device_remove(cpu);
+		if (is_mce_chrdev_set) {
+			if (threshold_cpu_callback)
+				threshold_cpu_callback(action, cpu);
+			mce_device_remove(cpu);
+		}
 		mce_intel_hcpu_update(cpu);
 		break;
 	case CPU_DOWN_PREPARE:
@@ -2404,10 +2417,6 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	return NOTIFY_OK;
 }
 
-static struct notifier_block mce_cpu_notifier = {
-	.notifier_call = mce_cpu_callback,
-};
-
 static __init void mce_init_banks(void)
 {
 	int i;
@@ -2447,18 +2456,12 @@ static __init int mcheck_init_device(void)
 	if (err)
 		goto err_out_mem;
 
-	cpu_notifier_register_begin();
 	for_each_online_cpu(i) {
 		err = mce_device_create(i);
-		if (err) {
-			cpu_notifier_register_done();
+		if (err)
 			goto err_device_create;
-		}
 	}
 
-	__register_hotcpu_notifier(&mce_cpu_notifier);
-	cpu_notifier_register_done();
-
 	register_syscore_ops(&mce_syscore_ops);
 
 	/* register character device /dev/mcelog */
@@ -2466,15 +2469,12 @@ static __init int mcheck_init_device(void)
 	if (err)
 		goto err_register;
 
+	is_mce_chrdev_set = true;
 	return 0;
 
 err_register:
 	unregister_syscore_ops(&mce_syscore_ops);
 
-	cpu_notifier_register_begin();
-	__unregister_hotcpu_notifier(&mce_cpu_notifier);
-	cpu_notifier_register_done();
-
 err_device_create:
 	/*
 	 * We didn't keep track of which devices were created above, but
-- 
1.8.1.4

