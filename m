Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbbAOVWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:22:44 -0500
Received: from www.linutronix.de ([62.245.132.108]:58336 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681AbbAOVWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:22:42 -0500
Message-Id: <20150115211703.129287153@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 15 Jan 2015 21:22:26 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [patch 11/23] x86/x2apic: Split enable and setup function
References: <20150115210458.625399149@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=x86-x2apic-split-enable-and-setup.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

enable_x2apic() is a convoluted unreadable mess because it is used for
both enablement in early boot and for setup in cpu_init().

Split the code into x2apic_enable() for enablement and x2apic_setup()
for setup of (secondary cpus). Make use of the new state tracking to
simplify the logic.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/apic.h  |    4 +--
 arch/x86/kernel/apic/apic.c  |   55 +++++++++++++++++++++++++------------------
 arch/x86/kernel/cpu/common.c |    2 -
 3 files changed, 36 insertions(+), 25 deletions(-)

Index: tip/arch/x86/include/asm/apic.h
===================================================================
--- tip.orig/arch/x86/include/asm/apic.h
+++ tip/arch/x86/include/asm/apic.h
@@ -177,7 +177,7 @@ static inline u64 native_x2apic_icr_read
 
 extern int x2apic_mode;
 extern int x2apic_phys;
-extern void enable_x2apic(void);
+extern void x2apic_setup(void);
 static inline int x2apic_enabled(void)
 {
 	return cpu_has_x2apic && apic_is_x2apic_enabled();
@@ -185,7 +185,7 @@ static inline int x2apic_enabled(void)
 
 #define x2apic_supported()	(cpu_has_x2apic)
 #else
-static inline void enable_x2apic(void) { }
+static inline void x2apic_setup(void) { }
 static inline int x2apic_enabled(void) { return 0; }
 
 #define x2apic_mode		(0)
Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -1497,6 +1497,17 @@ static inline void disable_x2apic(void)
 	printk_once(KERN_INFO "x2apic disabled\n");
 }
 
+static inline void enable_x2apic(void)
+{
+	u64 msr;
+
+	rdmsrl(MSR_IA32_APICBASE, msr);
+	if (msr & X2APIC_ENABLE)
+		return;
+	wrmsrl(MSR_IA32_APICBASE, msr | X2APIC_ENABLE);
+	printk_once(KERN_INFO "x2apic enabled\n");
+}
+
 static int __init setup_nox2apic(char *str)
 {
 	if (x2apic_enabled()) {
@@ -1517,6 +1528,21 @@ static int __init setup_nox2apic(char *s
 }
 early_param("nox2apic", setup_nox2apic);
 
+/* Called from cpu_init() to enable x2apic on (secondary) cpus */
+void x2apic_setup(void)
+{
+	/*
+	 * If x2apic is not in ON state, disable it if already enabled
+	 * from BIOS.
+	 */
+	if (x2apic_state != X2APIC_ON) {
+		if (cpu_has_apic)
+			disable_x2apic();
+		return;
+	}
+	enable_x2apic();
+}
+
 static __init void x2apic_disable(void)
 {
 	u64 msr;
@@ -1541,30 +1567,19 @@ static __init void x2apic_disable(void)
 	x2apic_state = X2APIC_DISABLED;
 }
 
-void enable_x2apic(void)
+static __init void x2apic_enable(void)
 {
-	u64 msr;
-
-	if (x2apic_state == X2APIC_DISABLED) {
-		disable_x2apic();
-		x2apic_mode = 0;
+	if (x2apic_state != X2APIC_OFF)
 		return;
-	}
 
-	if (!x2apic_mode)
-		return;
-
-	rdmsrl(MSR_IA32_APICBASE, msr);
-	if (!(msr & X2APIC_ENABLE)) {
-		printk_once(KERN_INFO "Enabling x2apic\n");
-		wrmsrl(MSR_IA32_APICBASE, msr | X2APIC_ENABLE);
-	}
+	x2apic_mode = 1;
 	x2apic_state = X2APIC_ON;
+	enable_x2apic();
 }
 
 static __init void try_to_enable_x2apic(int remap_mode)
 {
-	if (!x2apic_supported())
+	if (x2apic_state == X2APIC_DISABLED)
 		return;
 
 	if (remap_mode != IRQ_REMAP_X2APIC_MODE) {
@@ -1585,12 +1600,7 @@ static __init void try_to_enable_x2apic(
 		 */
 		x2apic_phys = 1;
 	}
-
-	if (!x2apic_mode) {
-		x2apic_mode = 1;
-		enable_x2apic();
-		pr_info("Enabled x2apic\n");
-	}
+	x2apic_enable();
 }
 
 void __init check_x2apic(void)
@@ -1614,6 +1624,7 @@ void __init check_x2apic(void)
 	panic("BIOS has enabled x2apic but kernel doesn't support x2apic, please disable x2apic in BIOS.\n");
 }
 static inline void try_to_enable_x2apic(int remap_mode) { }
+static inline void enable_x2apic(void) { }
 #endif /* !CONFIG_X86_X2APIC */
 
 static int __init try_to_enable_IR(void)
Index: tip/arch/x86/kernel/cpu/common.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/common.c
+++ tip/arch/x86/kernel/cpu/common.c
@@ -1332,7 +1332,7 @@ void cpu_init(void)
 	barrier();
 
 	x86_configure_nx();
-	enable_x2apic();
+	x2apic_setup();
 
 	/*
 	 * set up and load the per-CPU TSS


