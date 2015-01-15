Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbbAOVXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:23:33 -0500
Received: from www.linutronix.de ([62.245.132.108]:58444 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178AbbAOVXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:23:00 -0500
Message-Id: <20150115211704.084765674@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 15 Jan 2015 21:22:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [patch 22/23] x86/apic: Reuse apic_bsp_setup() for UP APIC setup
References: <20150115210458.625399149@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=x86-apic-sanitize-up-init.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend apic_bsp_setup() so the same code flow can be used for
APIC_init_uniprocessor().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/apic.h |    2 -
 arch/x86/kernel/apic/apic.c |   54 ++++++++++++++++++--------------------------
 arch/x86/kernel/smpboot.c   |    4 +--
 3 files changed, 26 insertions(+), 34 deletions(-)

Index: tip/arch/x86/include/asm/apic.h
===================================================================
--- tip.orig/arch/x86/include/asm/apic.h
+++ tip/arch/x86/include/asm/apic.h
@@ -212,7 +212,7 @@ extern void setup_secondary_APIC_clock(v
 extern int APIC_init_uniprocessor(void);
 extern int apic_force_enable(unsigned long addr);
 
-extern int apic_bsp_setup(void);
+extern int apic_bsp_setup(bool upmode);
 extern void apic_ap_setup(void);
 
 /*
Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -2200,36 +2200,48 @@ void __init apic_set_eoi_write(void (*eo
 	}
 }
 
-static void __init bsp_end_local_APIC_setup(void)
+static void __init apic_bsp_up_setup(void)
 {
-	end_local_APIC_setup();
+#ifdef CONFIG_X86_64
+	apic_write(APIC_ID, SET_APIC_ID(boot_cpu_physical_apicid));
+#else
 	/*
-	 * Now that local APIC setup is completed for BP, configure the fault
-	 * handling for interrupt remapping.
+	 * Hack: In case of kdump, after a crash, kernel might be booting
+	 * on a cpu with non-zero lapic id. But boot_cpu_physical_apicid
+	 * might be zero if read from MP tables. Get it from LAPIC.
 	 */
-	irq_remap_enable_fault_handling();
+# ifdef CONFIG_CRASH_DUMP
+	boot_cpu_physical_apicid = read_apic_id();
+# endif
+#endif
+	physid_set_mask_of_physid(boot_cpu_physical_apicid, &phys_cpu_present_map);
 }
 
 /**
  * apic_bsp_setup - Setup function for local apic and io-apic
+ * @upmode:		Force UP mode (for APIC_init_uniprocessor)
  *
  * Returns:
  * apic_id of BSP APIC
  */
-int __init apic_bsp_setup(void)
+int __init apic_bsp_setup(bool upmode)
 {
 	int id;
 
 	connect_bsp_APIC();
 	setup_local_APIC();
 
+	if (upmode)
+		apic_bsp_up_setup();
+
 	if (x2apic_mode)
 		id = apic_read(APIC_LDR);
 	else
 		id = GET_APIC_LOGICAL_ID(apic_read(APIC_LDR));
 
 	enable_IO_APIC();
-	bsp_end_local_APIC_setup();
+	end_local_APIC_setup();
+	irq_remap_enable_fault_handling();
 	setup_IO_APIC();
 	return id;
 }
@@ -2265,32 +2277,12 @@ int __init APIC_init_uniprocessor(void)
 	}
 #endif
 
-	default_setup_apic_routing();
+	if (!smp_found_config)
+		disable_ioapic_support();
 
+	default_setup_apic_routing();
 	verify_local_APIC();
-	connect_bsp_APIC();
-
-#ifdef CONFIG_X86_64
-	apic_write(APIC_ID, SET_APIC_ID(boot_cpu_physical_apicid));
-#else
-	/*
-	 * Hack: In case of kdump, after a crash, kernel might be booting
-	 * on a cpu with non-zero lapic id. But boot_cpu_physical_apicid
-	 * might be zero if read from MP tables. Get it from LAPIC.
-	 */
-# ifdef CONFIG_CRASH_DUMP
-	boot_cpu_physical_apicid = read_apic_id();
-# endif
-#endif
-	physid_set_mask_of_physid(boot_cpu_physical_apicid, &phys_cpu_present_map);
-	setup_local_APIC();
-
-	if (smp_found_config)
-		enable_IO_APIC();
-
-	bsp_end_local_APIC_setup();
-
-	setup_IO_APIC();
+	apic_bsp_setup(true);
 
 	x86_init.timers.setup_percpu_clockev();
 	return 0;
Index: tip/arch/x86/kernel/smpboot.c
===================================================================
--- tip.orig/arch/x86/kernel/smpboot.c
+++ tip/arch/x86/kernel/smpboot.c
@@ -1147,7 +1147,7 @@ void __init native_smp_prepare_cpus(unsi
 		return;
 	case SMP_FORCE_UP:
 		disable_smp();
-		apic_bsp_setup();
+		apic_bsp_setup(false);
 		return;
 	case SMP_OK:
 		break;
@@ -1161,7 +1161,7 @@ void __init native_smp_prepare_cpus(unsi
 		/* Or can we switch back to PIC here? */
 	}
 
-	cpu0_logical_apicid = apic_bsp_setup();
+	cpu0_logical_apicid = apic_bsp_setup(false);
 
 	/*
 	 * Set up local APIC timer on boot CPU.


