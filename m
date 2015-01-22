Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbbAVObn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:31:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58043 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbbAVObi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:31:38 -0500
Date: Thu, 22 Jan 2015 06:31:11 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-05f7e46d2aac359b6bcfc06b302bdd03ca0bcada@git.kernel.org>
Cc: hpa@zytor.com, bp@alien8.de, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, joro@8bytes.org,
        jiang.liu@linux.intel.com, tony.luck@intel.com, mingo@kernel.org
Reply-To: bp@alien8.de, hpa@zytor.com, tony.luck@intel.com, mingo@kernel.org,
        jiang.liu@linux.intel.com, joro@8bytes.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
In-Reply-To: <20150115211703.907616730@linutronix.de>
References: <20150115211703.907616730@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/smpboot: Move apic init code to apic.c
Git-Commit-ID: 05f7e46d2aac359b6bcfc06b302bdd03ca0bcada
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

Commit-ID:  05f7e46d2aac359b6bcfc06b302bdd03ca0bcada
Gitweb:     http://git.kernel.org/tip/05f7e46d2aac359b6bcfc06b302bdd03ca0bcada
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 15 Jan 2015 21:22:40 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 15:10:56 +0100

x86/smpboot: Move apic init code to apic.c

We better provide proper functions which implement the required code
flow in the apic code rather than letting the smpboot code open code
it. That allows to make more functions static and confines the APIC
functionality to apic.c where it belongs.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/20150115211703.907616730@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/apic.h |  6 +++---
 arch/x86/kernel/apic/apic.c | 51 ++++++++++++++++++++++++++++++++++++---------
 arch/x86/kernel/smpboot.c   | 27 +++---------------------
 3 files changed, 47 insertions(+), 37 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index ac60c60..92f3404 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -201,7 +201,6 @@ extern int get_physical_broadcast(void);
 
 extern int lapic_get_maxlvt(void);
 extern void clear_local_APIC(void);
-extern void connect_bsp_APIC(void);
 extern void disconnect_bsp_APIC(int virt_wire_setup);
 extern void disable_local_APIC(void);
 extern void lapic_shutdown(void);
@@ -209,8 +208,6 @@ extern int verify_local_APIC(void);
 extern void sync_Arb_IDs(void);
 extern void init_bsp_APIC(void);
 extern void setup_local_APIC(void);
-extern void end_local_APIC_setup(void);
-extern void bsp_end_local_APIC_setup(void);
 extern void init_apic_mappings(void);
 void register_lapic_address(unsigned long address);
 extern void setup_boot_APIC_clock(void);
@@ -218,6 +215,9 @@ extern void setup_secondary_APIC_clock(void);
 extern int APIC_init_uniprocessor(void);
 extern int apic_force_enable(unsigned long addr);
 
+extern int apic_bsp_setup(void);
+extern void apic_ap_setup(void);
+
 /*
  * On 32bit this is mach-xxx local
  */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 19f1bc7..0a41070 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
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
@@ -1958,7 +1955,7 @@ __visible void smp_trace_error_interrupt(struct pt_regs *regs)
 /**
  * connect_bsp_APIC - attach the APIC to the interrupt system
  */
-void __init connect_bsp_APIC(void)
+static void __init connect_bsp_APIC(void)
 {
 #ifdef CONFIG_X86_32
 	if (pic_mode) {
@@ -2205,6 +2202,40 @@ void __init apic_set_eoi_write(void (*eoi_write)(u32 reg, u32 v))
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
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index ca7f7b6..d538709 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -172,8 +172,7 @@ static void smp_callin(void)
 	 * CPU, first the APIC. (this is probably redundant on most
 	 * boards)
 	 */
-	setup_local_APIC();
-	end_local_APIC_setup();
+	apic_ap_setup();
 
 	/*
 	 * Need to setup vector mappings before we enable interrupts.
@@ -1078,7 +1077,6 @@ static int __init smp_sanity_check(unsigned max_cpus)
 				boot_cpu_physical_apicid);
 			pr_err("... forcing use of dummy APIC emulation (tell your hw vendor)\n");
 		}
-		disable_ioapic_support();
 		return -1;
 	}
 
@@ -1090,10 +1088,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
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
 
@@ -1151,23 +1146,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
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
