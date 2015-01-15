Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbbAOVX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:23:57 -0500
Received: from www.linutronix.de ([62.245.132.108]:58425 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbbAOVW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:22:57 -0500
Message-Id: <20150115211703.907616730@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 15 Jan 2015 21:22:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [patch 20/23] x86/smpboot: Move apic init code to apic.c
References: <20150115210458.625399149@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=x86-move-apic-init-to-apic.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We better provide proper functions which implement the required code
flow in the apic code rather than letting the smpboot code open code
it. That allows to make more functions static and confines the APIC
functionality to apic.c where it belongs.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/apic.h |    6 ++---
 arch/x86/kernel/apic/apic.c |   51 +++++++++++++++++++++++++++++++++++---------
 arch/x86/kernel/smpboot.c   |   27 ++---------------------
 3 files changed, 47 insertions(+), 37 deletions(-)

Index: tip/arch/x86/include/asm/apic.h
===================================================================
--- tip.orig/arch/x86/include/asm/apic.h
+++ tip/arch/x86/include/asm/apic.h
@@ -198,7 +198,6 @@ extern int get_physical_broadcast(void);
 
 extern int lapic_get_maxlvt(void);
 extern void clear_local_APIC(void);
-extern void connect_bsp_APIC(void);
 extern void disconnect_bsp_APIC(int virt_wire_setup);
 extern void disable_local_APIC(void);
 extern void lapic_shutdown(void);
@@ -206,8 +205,6 @@ extern int verify_local_APIC(void);
 extern void sync_Arb_IDs(void);
 extern void init_bsp_APIC(void);
 extern void setup_local_APIC(void);
-extern void end_local_APIC_setup(void);
-extern void bsp_end_local_APIC_setup(void);
 extern void init_apic_mappings(void);
 void register_lapic_address(unsigned long address);
 extern void setup_boot_APIC_clock(void);
@@ -215,6 +212,9 @@ extern void setup_secondary_APIC_clock(v
 extern int APIC_init_uniprocessor(void);
 extern int apic_force_enable(unsigned long addr);
 
+extern int apic_bsp_setup(void);
+extern void apic_ap_setup(void);
+
 /*
  * On 32bit this is mach-xxx local
  */
Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -1445,7 +1445,7 @@ void setup_local_APIC(void)
 #endif
 }
 
-void end_local_APIC_setup(void)
+static void end_local_APIC_setup(void)
 {
 	lapic_setup_esr();
 
@@ -1462,16 +1462,13 @@ void end_local_APIC_setup(void)
 	apic_pm_activate();
 }
 
-void __init bsp_end_local_APIC_setup(void)
+/*
+ * APIC setup function for application processors. Called from smpboot.c
+ */
+void apic_ap_setup(void)
 {
+	setup_local_APIC();
 	end_local_APIC_setup();
-
-	/*
-	 * Now that local APIC setup is completed for BP, configure the fault
-	 * handling for interrupt remapping.
-	 */
-	irq_remap_enable_fault_handling();
-
 }
 
 #ifdef CONFIG_X86_X2APIC
@@ -1956,7 +1953,7 @@ __visible void smp_trace_error_interrupt
 /**
  * connect_bsp_APIC - attach the APIC to the interrupt system
  */
-void __init connect_bsp_APIC(void)
+static void __init connect_bsp_APIC(void)
 {
 #ifdef CONFIG_X86_32
 	if (pic_mode) {
@@ -2203,6 +2200,40 @@ void __init apic_set_eoi_write(void (*eo
 	}
 }
 
+static void __init bsp_end_local_APIC_setup(void)
+{
+	end_local_APIC_setup();
+	/*
+	 * Now that local APIC setup is completed for BP, configure the fault
+	 * handling for interrupt remapping.
+	 */
+	irq_remap_enable_fault_handling();
+}
+
+/**
+ * apic_bsp_setup - Setup function for local apic and io-apic
+ *
+ * Returns:
+ * apic_id of BSP APIC
+ */
+int __init apic_bsp_setup(void)
+{
+	int id;
+
+	connect_bsp_APIC();
+	setup_local_APIC();
+
+	if (x2apic_mode)
+		id = apic_read(APIC_LDR);
+	else
+		id = GET_APIC_LOGICAL_ID(apic_read(APIC_LDR));
+
+	enable_IO_APIC();
+	bsp_end_local_APIC_setup();
+	setup_IO_APIC();
+	return id;
+}
+
 /*
  * This initializes the IO-APIC and APIC hardware if this is
  * a UP kernel.
Index: tip/arch/x86/kernel/smpboot.c
===================================================================
--- tip.orig/arch/x86/kernel/smpboot.c
+++ tip/arch/x86/kernel/smpboot.c
@@ -172,8 +172,7 @@ static void smp_callin(void)
 	 * CPU, first the APIC. (this is probably redundant on most
 	 * boards)
 	 */
-	setup_local_APIC();
-	end_local_APIC_setup();
+	apic_ap_setup();
 
 	/*
 	 * Need to setup vector mappings before we enable interrupts.
@@ -1078,7 +1077,6 @@ static int __init smp_sanity_check(unsig
 				boot_cpu_physical_apicid);
 			pr_err("... forcing use of dummy APIC emulation (tell your hw vendor)\n");
 		}
-		disable_ioapic_support();
 		return -1;
 	}
 
@@ -1090,10 +1088,7 @@ static int __init smp_sanity_check(unsig
 	if (!max_cpus) {
 		pr_info("SMP mode deactivated\n");
 		disable_ioapic_support();
-
-		connect_bsp_APIC();
-		setup_local_APIC();
-		bsp_end_local_APIC_setup();
+		apic_bsp_setup();
 		return -1;
 	}
 
@@ -1151,23 +1146,7 @@ void __init native_smp_prepare_cpus(unsi
 		/* Or can we switch back to PIC here? */
 	}
 
-	connect_bsp_APIC();
-
-	/*
-	 * Switch from PIC to APIC mode.
-	 */
-	setup_local_APIC();
-
-	if (x2apic_mode)
-		cpu0_logical_apicid = apic_read(APIC_LDR);
-	else
-		cpu0_logical_apicid = GET_APIC_LOGICAL_ID(apic_read(APIC_LDR));
-
-	/* Enable IO APIC before setting up error vector */
-	enable_IO_APIC();
-
-	bsp_end_local_APIC_setup();
-	setup_IO_APIC();
+	cpu0_logical_apicid = apic_bsp_setup();
 
 	/*
 	 * Set up local APIC timer on boot CPU.


