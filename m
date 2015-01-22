Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbbAVOai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:30:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58006 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbbAVOad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:30:33 -0500
Date: Thu, 22 Jan 2015 06:30:07 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-ef4c59a4b64c62f977187cae444aee25bebb02fe@git.kernel.org>
Cc: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, jiang.liu@linux.intel.com,
        joro@8bytes.org, tony.luck@intel.com, bp@alien8.de
Reply-To: mingo@kernel.org, tglx@linutronix.de, bp@alien8.de,
        tony.luck@intel.com, joro@8bytes.org, jiang.liu@linux.intel.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com
In-Reply-To: <20150115211703.650280684@linutronix.de>
References: <20150115211703.650280684@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/smpboot: Cleanup ioapic handling
Git-Commit-ID: ef4c59a4b64c62f977187cae444aee25bebb02fe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef4c59a4b64c62f977187cae444aee25bebb02fe
Gitweb:     http://git.kernel.org/tip/ef4c59a4b64c62f977187cae444aee25bebb02fe
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 15 Jan 2015 21:22:35 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 15:10:56 +0100

x86/smpboot: Cleanup ioapic handling

smpboot is very creative with the ways to disable ioapic.

smpboot_clear_io_apic() smpboot_clear_io_apic_irqs() and
disable_ioapic_support() serve a similar purpose.

smpboot_clear_io_apic_irqs() is the most useless of all
functions as it clears a variable which has not been setup yet.

Aside of that it has the same ifdef mess and conditionals around the
ioapic related code, which can now be removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/20150115211703.650280684@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/smpboot.c | 47 +++++++----------------------------------------
 1 file changed, 7 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 110ed11..ca7f7b6 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
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
@@ -147,27 +140,6 @@ static inline void smpboot_restore_warm_reset_vector(void)
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
-	else
-		nr_ioapics = 0;
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
@@ -1019,9 +991,10 @@ void arch_disable_smp_support(void)
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
@@ -1105,7 +1078,6 @@ static int __init smp_sanity_check(unsigned max_cpus)
 				boot_cpu_physical_apicid);
 			pr_err("... forcing use of dummy APIC emulation (tell your hw vendor)\n");
 		}
-		smpboot_clear_io_apic();
 		disable_ioapic_support();
 		return -1;
 	}
@@ -1117,7 +1089,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 	 */
 	if (!max_cpus) {
 		pr_info("SMP mode deactivated\n");
-		smpboot_clear_io_apic();
+		disable_ioapic_support();
 
 		connect_bsp_APIC();
 		setup_local_APIC();
@@ -1191,18 +1163,15 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
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
@@ -1241,9 +1210,7 @@ void __init native_smp_cpus_done(unsigned int max_cpus)
 
 	nmi_selftest();
 	impress_friends();
-#ifdef CONFIG_X86_IO_APIC
 	setup_ioapic_dest();
-#endif
 	mtrr_aps_init();
 }
 
