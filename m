Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaCaUM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 16:12:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbaCaULs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:11:48 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        imammedo@redhat.com, bp@suse.de, paul.gortmaker@windriver.com,
        JBeulich@suse.com, prarit@redhat.com, drjones@redhat.com,
        toshi.kani@hp.com, riel@redhat.com, gong.chen@linux.intel.com
Subject: [PATCH v2 2/5] x86: cleanup not needed cpu_initialized_mask
Date: Mon, 31 Mar 2014 22:09:22 +0200
Message-Id: <1396296565-19709-3-git-send-email-imammedo@redhat.com>
In-Reply-To: <1396296565-19709-1-git-send-email-imammedo@redhat.com>
References: <1396296565-19709-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_initialized_mask is used in cpu_init() for detecting
if AP has been already started. But now test could never
return true since master CPU doesn't give up waiting on
AP startup and native_cpu_up() checks for:

 physid_isset(apicid, phys_cpu_present_map) &&
 cpu_callin_mask

so that it would not attempt to call do_boot_cpu() on
already started AP.
And since cpu_initialized_mask isn't used for anything
else just remove it altogether.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/include/asm/cpumask.h |    1 -
 arch/x86/kernel/cpu/common.c   |   11 -----------
 arch/x86/kernel/smpboot.c      |    2 --
 3 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/cpumask.h b/arch/x86/include/asm/cpumask.h
index 61c852f..c64c5f5 100644
--- a/arch/x86/include/asm/cpumask.h
+++ b/arch/x86/include/asm/cpumask.h
@@ -5,7 +5,6 @@
 
 extern cpumask_var_t cpu_callin_mask;
 extern cpumask_var_t cpu_callout_mask;
-extern cpumask_var_t cpu_initialized_mask;
 extern cpumask_var_t cpu_sibling_setup_mask;
 
 extern void setup_cpu_local_masks(void);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 248161e..7dfac93 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -47,7 +47,6 @@
 #include "cpu.h"
 
 /* all of these masks are initialized in setup_cpu_local_masks() */
-cpumask_var_t cpu_initialized_mask;
 cpumask_var_t cpu_callout_mask;
 cpumask_var_t cpu_callin_mask;
 
@@ -57,7 +56,6 @@ cpumask_var_t cpu_sibling_setup_mask;
 /* correctly size the local cpu masks */
 void __init setup_cpu_local_masks(void)
 {
-	alloc_bootmem_cpumask_var(&cpu_initialized_mask);
 	alloc_bootmem_cpumask_var(&cpu_callin_mask);
 	alloc_bootmem_cpumask_var(&cpu_callout_mask);
 	alloc_bootmem_cpumask_var(&cpu_sibling_setup_mask);
@@ -1262,9 +1260,6 @@ void cpu_init(void)
 
 	me = current;
 
-	if (cpumask_test_and_set_cpu(cpu, cpu_initialized_mask))
-		panic("CPU#%d already initialized!\n", cpu);
-
 	pr_debug("Initializing CPU#%d\n", cpu);
 
 	clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
@@ -1350,12 +1345,6 @@ void cpu_init(void)
 
 	show_ucode_info_early();
 
-	if (cpumask_test_and_set_cpu(cpu, cpu_initialized_mask)) {
-		printk(KERN_WARNING "CPU#%d already initialized!\n", cpu);
-		for (;;)
-			local_irq_enable();
-	}
-
 	printk(KERN_INFO "Initializing CPU#%d\n", cpu);
 
 	if (cpu_has_vme || cpu_has_tsc || cpu_has_de)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 8bf67bd..803f658 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1237,8 +1237,6 @@ static void __ref remove_cpu_from_maps(int cpu)
 	set_cpu_online(cpu, false);
 	cpumask_clear_cpu(cpu, cpu_callout_mask);
 	cpumask_clear_cpu(cpu, cpu_callin_mask);
-	/* was set by cpu_init() */
-	cpumask_clear_cpu(cpu, cpu_initialized_mask);
 	numa_remove_cpu(cpu);
 }
 
-- 
1.7.1

