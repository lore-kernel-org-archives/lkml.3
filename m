Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab3AaMLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:11:55 -0500
Received: from www.linutronix.de ([62.245.132.108]:56071 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab3AaMLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:35 -0500
Message-Id: <20130131120743.322589840@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:33 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 27/40] virt: Convert kvm hotplug to state machine
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=virt-kvm-convert.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/cpuhotplug.h |    1 +
 virt/kvm/kvm_main.c        |   42 ++++++++++++++++--------------------------
 2 files changed, 17 insertions(+), 26 deletions(-)

Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -25,6 +25,7 @@ enum cpuhp_states {
 	CPUHP_AP_PERF_ARM_STARTING,
 	CPUHP_AP_ARM_VFP_STARTING,
 	CPUHP_AP_ARM64_TIMER_STARTING,
+	CPUHP_AP_KVM_STARTING,
 	CPUHP_AP_NOTIFY_STARTING,
 	CPUHP_AP_NOTIFY_DYING,
 	CPUHP_AP_SCHED_MIGRATE_DYING,
Index: linux-2.6/virt/kvm/kvm_main.c
===================================================================
--- linux-2.6.orig/virt/kvm/kvm_main.c
+++ linux-2.6/virt/kvm/kvm_main.c
@@ -2496,30 +2496,23 @@ static int hardware_enable_all(void)
 	return r;
 }
 
-static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
-			   void *v)
+static int kvm_starting_cpu(unsigned int cpu)
 {
-	int cpu = (long)v;
-
-	if (!kvm_usage_count)
-		return NOTIFY_OK;
-
-	val &= ~CPU_TASKS_FROZEN;
-	switch (val) {
-	case CPU_DYING:
-		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
-		       cpu);
-		hardware_disable(NULL);
-		break;
-	case CPU_STARTING:
-		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
-		       cpu);
+	if (kvm_usage_count) {
+		pr_info("kvm: enabling virtualization on CPU%u\n", cpu);
 		hardware_enable(NULL);
-		break;
 	}
-	return NOTIFY_OK;
+	return 0;
 }
 
+static int kvm_dying_cpu(unsigned int cpu)
+{
+	if (kvm_usage_count) {
+		pr_info("kvm: disabling virtualization on CPU%u\n", cpu);
+		hardware_disable(NULL);
+	}
+	return 0;
+}
 
 asmlinkage void kvm_spurious_fault(void)
 {
@@ -2725,10 +2718,6 @@ int kvm_io_bus_unregister_dev(struct kvm
 	return r;
 }
 
-static struct notifier_block kvm_cpu_notifier = {
-	.notifier_call = kvm_cpu_hotplug,
-};
-
 static int vm_stat_get(void *_offset, u64 *val)
 {
 	unsigned offset = (long)_offset;
@@ -2870,7 +2859,8 @@ int kvm_init(void *opaque, unsigned vcpu
 			goto out_free_1;
 	}
 
-	r = register_cpu_notifier(&kvm_cpu_notifier);
+	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_STARTING, kvm_starting_cpu,
+				      kvm_dying_cpu);
 	if (r)
 		goto out_free_2;
 	register_reboot_notifier(&kvm_reboot_notifier);
@@ -2920,7 +2910,7 @@ out_free:
 	kmem_cache_destroy(kvm_vcpu_cache);
 out_free_3:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
-	unregister_cpu_notifier(&kvm_cpu_notifier);
+	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
 out_free_2:
 out_free_1:
 	kvm_arch_hardware_unsetup();
@@ -2941,7 +2931,7 @@ void kvm_exit(void)
 	kvm_async_pf_deinit();
 	unregister_syscore_ops(&kvm_syscore_ops);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
-	unregister_cpu_notifier(&kvm_cpu_notifier);
+	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
 	on_each_cpu(hardware_disable_nolock, NULL, 1);
 	kvm_arch_hardware_unsetup();
 	kvm_arch_exit();


