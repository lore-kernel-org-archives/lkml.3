Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbbAOVWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:22:41 -0500
Received: from www.linutronix.de ([62.245.132.108]:58298 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090AbbAOVWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:22:35 -0500
Message-Id: <20150115211702.795388613@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 15 Jan 2015 21:22:19 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [patch 07/23] x86/x2apic: Move code in conditional region
References: <20150115210458.625399149@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=x86-x2apic-move-code-in-conditional-region.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No point in having try_to_enable_x2apic() outside of the
CONFIG_X86_X2APIC section and having inline functions and more ifdefs
to deal with it. Move the code into the existing ifdef section and
remove the inline cruft.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/apic.h |   20 ++-----------
 arch/x86/kernel/apic/apic.c |   65 +++++++++++++++++++++-----------------------
 2 files changed, 35 insertions(+), 50 deletions(-)

Index: tip/arch/x86/include/asm/apic.h
===================================================================
--- tip.orig/arch/x86/include/asm/apic.h
+++ tip/arch/x86/include/asm/apic.h
@@ -184,24 +184,10 @@ static inline int x2apic_enabled(void)
 }
 
 #define x2apic_supported()	(cpu_has_x2apic)
-static inline void x2apic_force_phys(void)
-{
-	x2apic_phys = 1;
-}
 #else
-static inline void disable_x2apic(void)
-{
-}
-static inline void enable_x2apic(void)
-{
-}
-static inline int x2apic_enabled(void)
-{
-	return 0;
-}
-static inline void x2apic_force_phys(void)
-{
-}
+static inline void disable_x2apic(void) { }
+static inline void enable_x2apic(void) { }
+static inline int x2apic_enabled(void) { return 0; }
 
 #define x2apic_mode		(0)
 #define	x2apic_supported()	(0)
Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -1561,40 +1561,8 @@ void enable_x2apic(void)
 	}
 }
 
-void __init check_x2apic(void)
-{
-	if (x2apic_enabled()) {
-		pr_info("x2apic enabled by BIOS, switching to x2apic ops\n");
-		x2apic_mode = 1;
-	}
-}
-#else /* CONFIG_X86_X2APIC */
-void __init check_x2apic(void)
-{
-	if (!cpu_has_apic || !apic_is_x2apic_enabled())
-		return;
-	/*
-	 * Checkme: Can we simply turn off x2apic here instead of panic?
-	 */
-	panic("BIOS has enabled x2apic but kernel doesn't support x2apic, please disable x2apic in BIOS.\n");
-}
-#endif /* !CONFIG_X86_X2APIC */
-
-static int __init try_to_enable_IR(void)
-{
-#ifdef CONFIG_X86_IO_APIC
-	if (!x2apic_enabled() && skip_ioapic_setup) {
-		pr_info("Skipped enabling intr-remap because of skipping "
-			"io-apic setup\n");
-		return -1;
-	}
-#endif
-	return irq_remapping_enable();
-}
-
 static __init void try_to_enable_x2apic(int ir_stat)
 {
-#ifdef CONFIG_X86_X2APIC
 	if (!x2apic_supported())
 		return;
 
@@ -1614,7 +1582,7 @@ static __init void try_to_enable_x2apic(
 		 * without IR all CPUs can be addressed by IOAPIC/MSI
 		 * only in physical mode
 		 */
-		x2apic_force_phys();
+		x2apic_phys = 1;
 	}
 
 	if (!x2apic_mode) {
@@ -1622,7 +1590,38 @@ static __init void try_to_enable_x2apic(
 		enable_x2apic();
 		pr_info("Enabled x2apic\n");
 	}
+}
+
+void __init check_x2apic(void)
+{
+	if (x2apic_enabled()) {
+		pr_info("x2apic: enabled by BIOS, switching to x2apic ops\n");
+		x2apic_mode = 1;
+	}
+}
+#else /* CONFIG_X86_X2APIC */
+void __init check_x2apic(void)
+{
+	if (!cpu_has_apic || !apic_is_x2apic_enabled())
+		return;
+	/*
+	 * CHECKME: Can we simply turn off x2apic here instead of panic?
+	 */
+	panic("BIOS has enabled x2apic but kernel doesn't support x2apic, please disable x2apic in BIOS.\n");
+}
+static inline void try_to_enable_x2apic(int ir_stat) { }
+#endif /* !CONFIG_X86_X2APIC */
+
+static int __init try_to_enable_IR(void)
+{
+#ifdef CONFIG_X86_IO_APIC
+	if (!x2apic_enabled() && skip_ioapic_setup) {
+		pr_info("Skipped enabling intr-remap because of skipping "
+			"io-apic setup\n");
+		return -1;
+	}
 #endif
+	return irq_remapping_enable();
 }
 
 void __init enable_IR_x2apic(void)


