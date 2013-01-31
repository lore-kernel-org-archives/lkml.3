Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab3AaML4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:11:56 -0500
Received: from www.linutronix.de ([62.245.132.108]:56101 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab3AaMLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:37 -0500
Message-Id: <20130131120743.526367214@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:36 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 30/40] x86: tboot: Convert to hotplug state machine
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=x86-tboot-convert.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/tboot.c    |   23 +++++++----------------
 include/linux/cpuhotplug.h |    1 +
 2 files changed, 8 insertions(+), 16 deletions(-)

Index: linux-2.6/arch/x86/kernel/tboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tboot.c
+++ linux-2.6/arch/x86/kernel/tboot.c
@@ -319,25 +319,16 @@ static int tboot_wait_for_aps(int num_ap
 	return !(atomic_read((atomic_t *)&tboot->num_in_wfs) == num_aps);
 }
 
-static int __cpuinit tboot_cpu_callback(struct notifier_block *nfb,
-			unsigned long action, void *hcpu)
+static int __cpuinit tboot_dying_cpu(unsigned int cpu)
 {
-	switch (action) {
-	case CPU_DYING:
-		atomic_inc(&ap_wfs_count);
-		if (num_online_cpus() == 1)
-			if (tboot_wait_for_aps(atomic_read(&ap_wfs_count)))
-				return NOTIFY_BAD;
-		break;
+	atomic_inc(&ap_wfs_count);
+	if (num_online_cpus() == 1) {
+		if (tboot_wait_for_aps(atomic_read(&ap_wfs_count)))
+			return -EBUSY;
 	}
-	return NOTIFY_OK;
+	return 0;
 }
 
-static struct notifier_block tboot_cpu_notifier __cpuinitdata =
-{
-	.notifier_call = tboot_cpu_callback,
-};
-
 static __init int tboot_late_init(void)
 {
 	if (!tboot_enabled())
@@ -346,7 +337,7 @@ static __init int tboot_late_init(void)
 	tboot_create_trampoline();
 
 	atomic_set(&ap_wfs_count, 0);
-	register_hotcpu_notifier(&tboot_cpu_notifier);
+	cpuhp_setup_state(CPUHP_AP_X86_TBOOT_DYING, NULL, tboot_dying_cpu);
 
 	acpi_os_set_prepare_sleep(&tboot_sleep);
 	return 0;
Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -27,6 +27,7 @@ enum cpuhp_states {
 	CPUHP_AP_ARM64_TIMER_STARTING,
 	CPUHP_AP_KVM_STARTING,
 	CPUHP_AP_NOTIFY_DYING,
+	CPUHP_AP_X86_TBOOT_DYING,
 	CPUHP_AP_S390_VTIME_DYING,
 	CPUHP_AP_SCHED_MIGRATE_DYING,
 	CPUHP_AP_MAX,


