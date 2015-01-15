Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144AbbAOVWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:22:35 -0500
Received: from www.linutronix.de ([62.245.132.108]:58286 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572AbbAOVWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:22:33 -0500
Message-Id: <20150115211702.702479404@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 15 Jan 2015 21:22:17 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [patch 06/23] x86/apic: Check x2apic early
References: <20150115210458.625399149@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=x86-check-x2apic-early.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No point in delaying the x2apic detection for the CONFIG_X86_X2APIC=n
case to enable_IR_x2apic(). We rather detect that in the early boot
code in check_x2apic().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/apic.h |    6 ++----
 arch/x86/kernel/apic/apic.c |   33 +++++++++++++++++++--------------
 2 files changed, 21 insertions(+), 18 deletions(-)

Index: tip/arch/x86/include/asm/apic.h
===================================================================
--- tip.orig/arch/x86/include/asm/apic.h
+++ tip/arch/x86/include/asm/apic.h
@@ -177,7 +177,6 @@ static inline u64 native_x2apic_icr_read
 
 extern int x2apic_mode;
 extern int x2apic_phys;
-extern void check_x2apic(void);
 extern void enable_x2apic(void);
 static inline int x2apic_enabled(void)
 {
@@ -193,9 +192,6 @@ static inline void x2apic_force_phys(voi
 static inline void disable_x2apic(void)
 {
 }
-static inline void check_x2apic(void)
-{
-}
 static inline void enable_x2apic(void)
 {
 }
@@ -429,6 +425,7 @@ static inline u32 safe_apic_wait_icr_idl
 }
 
 extern void __init apic_set_eoi_write(void (*eoi_write)(u32 reg, u32 v));
+extern void __init check_x2apic(void);
 
 #else /* CONFIG_X86_LOCAL_APIC */
 
@@ -440,6 +437,7 @@ static inline void apic_icr_write(u32 lo
 static inline void apic_wait_icr_idle(void) { }
 static inline u32 safe_apic_wait_icr_idle(void) { return 0; }
 static inline void apic_set_eoi_write(void (*eoi_write)(u32 reg, u32 v)) {}
+static inline void check_x2apic(void) { }
 
 #endif /* CONFIG_X86_LOCAL_APIC */
 
Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -1541,14 +1541,6 @@ static __init void disable_x2apic(void)
 	x2apic_disabled = 1;
 }
 
-void check_x2apic(void)
-{
-	if (x2apic_enabled()) {
-		pr_info("x2apic enabled by BIOS, switching to x2apic ops\n");
-		x2apic_mode = 1;
-	}
-}
-
 void enable_x2apic(void)
 {
 	u64 msr;
@@ -1568,7 +1560,25 @@ void enable_x2apic(void)
 		wrmsrl(MSR_IA32_APICBASE, msr | X2APIC_ENABLE);
 	}
 }
-#endif /* CONFIG_X86_X2APIC */
+
+void __init check_x2apic(void)
+{
+	if (x2apic_enabled()) {
+		pr_info("x2apic enabled by BIOS, switching to x2apic ops\n");
+		x2apic_mode = 1;
+	}
+}
+#else /* CONFIG_X86_X2APIC */
+void __init check_x2apic(void)
+{
+	if (!cpu_has_apic || !apic_is_x2apic_enabled())
+		return;
+	/*
+	 * Checkme: Can we simply turn off x2apic here instead of panic?
+	 */
+	panic("BIOS has enabled x2apic but kernel doesn't support x2apic, please disable x2apic in BIOS.\n");
+}
+#endif /* !CONFIG_X86_X2APIC */
 
 static int __init try_to_enable_IR(void)
 {
@@ -1620,11 +1630,6 @@ void __init enable_IR_x2apic(void)
 	unsigned long flags;
 	int ret, ir_stat;
 
-	if (!IS_ENABLED(CONFIG_X86_X2APIC)) {
-		if (apic_is_x2apic_enabled())
-			panic("BIOS has enabled x2apic but kernel doesn't support x2apic, please disable x2apic in BIOS.\n");
-	}
-
 	ir_stat = irq_remapping_prepare();
 	if (ir_stat < 0 && !x2apic_supported())
 		return;


