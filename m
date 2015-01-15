Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175AbbAOVWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:22:54 -0500
Received: from www.linutronix.de ([62.245.132.108]:58395 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811AbbAOVWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:22:52 -0500
Message-Id: <20150115211703.650280684@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 15 Jan 2015 21:22:35 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [patch 17/23] x86/smpboot: Cleanup ioapic handling
References: <20150115210458.625399149@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=x86-smpboot-cleanup-io-apic-handling.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smpboot is very creative with the ways to disable ioapic.

smpboot_clear_io_apic() smpboot_clear_io_apic_irqs() and
disable_ioapic_support() serve a similar purpose.

smpboot_clear_io_apic_irqs() is the most useless of all
functions as it clears a variable which has not been setup yet.

Aside of that it has the same ifdef mess and conditionals around the
ioapic related code, which can now be removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/smpboot.c |   48 ++++++----------------------------------------
 1 file changed, 7 insertions(+), 41 deletions(-)

Index: tip/arch/x86/kernel/smpboot.c
===================================================================
--- tip.orig/arch/x86/kernel/smpboot.c
+++ tip/arch/x86/kernel/smpboot.c
@@ -103,13 +103,6 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
 
 atomic_t init_deasserted;
 
-static inline void smpboot_clear_io_apic_irqs(void)
-{
-#ifdef CONFIG_X86_IO_APIC
-	io_apic_irqs = 0;
-#endif
-}
-
 static inline void smpboot_setup_warm_reset_vector(unsigned long start_eip)
 {
 	unsigned long flags;
@@ -147,28 +140,6 @@ static inline void smpboot_restore_warm_
 	*((volatile u32 *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) = 0;
 }
 
-static inline void __init smpboot_setup_io_apic(void)
-{
-#ifdef CONFIG_X86_IO_APIC
-	/*
-	 * Here we can be sure that there is an IO-APIC in the system. Let's
-	 * go and set it up:
-	 */
-	if (!skip_ioapic_setup && nr_ioapics)
-		setup_IO_APIC();
-	else {
-		nr_ioapics = 0;
-	}
-#endif
-}
-
-static inline void smpboot_clear_io_apic(void)
-{
-#ifdef CONFIG_X86_IO_APIC
-	nr_ioapics = 0;
-#endif
-}
-
 /*
  * Report back to the Boot Processor during boot time or to the caller processor
  * during CPU online.
@@ -1020,9 +991,10 @@ void arch_disable_smp_support(void)
  */
 static __init void disable_smp(void)
 {
+	disable_ioapic_support();
+
 	init_cpu_present(cpumask_of(0));
 	init_cpu_possible(cpumask_of(0));
-	smpboot_clear_io_apic_irqs();
 
 	if (smp_found_config)
 		physid_set_mask_of_physid(boot_cpu_physical_apicid, &phys_cpu_present_map);
@@ -1106,7 +1078,6 @@ static int __init smp_sanity_check(unsig
 				boot_cpu_physical_apicid);
 			pr_err("... forcing use of dummy APIC emulation (tell your hw vendor)\n");
 		}
-		smpboot_clear_io_apic();
 		disable_ioapic_support();
 		return -1;
 	}
@@ -1118,7 +1089,7 @@ static int __init smp_sanity_check(unsig
 	 */
 	if (!max_cpus) {
 		pr_info("SMP mode deactivated\n");
-		smpboot_clear_io_apic();
+		disable_ioapic_support();
 
 		connect_bsp_APIC();
 		setup_local_APIC();
@@ -1192,18 +1163,15 @@ void __init native_smp_prepare_cpus(unsi
 	else
 		cpu0_logical_apicid = GET_APIC_LOGICAL_ID(apic_read(APIC_LDR));
 
-	/*
-	 * Enable IO APIC before setting up error vector
-	 */
-	if (!skip_ioapic_setup && nr_ioapics)
-		enable_IO_APIC();
+	/* Enable IO APIC before setting up error vector */
+	enable_IO_APIC();
 
 	bsp_end_local_APIC_setup();
-	smpboot_setup_io_apic();
+	setup_IO_APIC();
+
 	/*
 	 * Set up local APIC timer on boot CPU.
 	 */
-
 	pr_info("CPU%d: ", 0);
 	print_cpu_info(&cpu_data(0));
 	x86_init.timers.setup_percpu_clockev();
@@ -1242,9 +1210,7 @@ void __init native_smp_cpus_done(unsigne
 
 	nmi_selftest();
 	impress_friends();
-#ifdef CONFIG_X86_IO_APIC
 	setup_ioapic_dest();
-#endif
 	mtrr_aps_init();
 }
 


