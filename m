Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbbAOVWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:22:48 -0500
Received: from www.linutronix.de ([62.245.132.108]:58356 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbbAOVWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:22:45 -0500
Message-Id: <20150115211703.304126687@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 15 Jan 2015 21:22:29 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [patch 13/23] x86/smpboot: Move smpboot inlines to code
References: <20150115210458.625399149@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=x86-move-smpboot-inlines-to-code.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No point for a seperate header file.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/smpboot_hooks.h |   68 -----------------------------------
 arch/x86/kernel/smpboot.c            |   67 +++++++++++++++++++++++++++++++++-
 2 files changed, 66 insertions(+), 69 deletions(-)

Index: tip/arch/x86/include/asm/smpboot_hooks.h
===================================================================
--- tip.orig/arch/x86/include/asm/smpboot_hooks.h
+++ /dev/null
@@ -1,68 +0,0 @@
-/* two abstractions specific to kernel/smpboot.c, mainly to cater to visws
- * which needs to alter them. */
-
-static inline void smpboot_clear_io_apic_irqs(void)
-{
-#ifdef CONFIG_X86_IO_APIC
-	io_apic_irqs = 0;
-#endif
-}
-
-static inline void smpboot_setup_warm_reset_vector(unsigned long start_eip)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	CMOS_WRITE(0xa, 0xf);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	local_flush_tlb();
-	pr_debug("1.\n");
-	*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_HIGH)) =
-							start_eip >> 4;
-	pr_debug("2.\n");
-	*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) =
-							start_eip & 0xf;
-	pr_debug("3.\n");
-}
-
-static inline void smpboot_restore_warm_reset_vector(void)
-{
-	unsigned long flags;
-
-	/*
-	 * Install writable page 0 entry to set BIOS data area.
-	 */
-	local_flush_tlb();
-
-	/*
-	 * Paranoid:  Set warm reset code and vector here back
-	 * to default values.
-	 */
-	spin_lock_irqsave(&rtc_lock, flags);
-	CMOS_WRITE(0, 0xf);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-
-	*((volatile u32 *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) = 0;
-}
-
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
Index: tip/arch/x86/kernel/smpboot.c
===================================================================
--- tip.orig/arch/x86/kernel/smpboot.c
+++ tip/arch/x86/kernel/smpboot.c
@@ -73,7 +73,6 @@
 #include <asm/setup.h>
 #include <asm/uv/uv.h>
 #include <linux/mc146818rtc.h>
-#include <asm/smpboot_hooks.h>
 #include <asm/i8259.h>
 #include <asm/realmode.h>
 #include <asm/misc.h>
@@ -104,6 +103,72 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
 
 atomic_t init_deasserted;
 
+static inline void smpboot_clear_io_apic_irqs(void)
+{
+#ifdef CONFIG_X86_IO_APIC
+	io_apic_irqs = 0;
+#endif
+}
+
+static inline void smpboot_setup_warm_reset_vector(unsigned long start_eip)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	CMOS_WRITE(0xa, 0xf);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	local_flush_tlb();
+	pr_debug("1.\n");
+	*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_HIGH)) =
+							start_eip >> 4;
+	pr_debug("2.\n");
+	*((volatile unsigned short *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) =
+							start_eip & 0xf;
+	pr_debug("3.\n");
+}
+
+static inline void smpboot_restore_warm_reset_vector(void)
+{
+	unsigned long flags;
+
+	/*
+	 * Install writable page 0 entry to set BIOS data area.
+	 */
+	local_flush_tlb();
+
+	/*
+	 * Paranoid:  Set warm reset code and vector here back
+	 * to default values.
+	 */
+	spin_lock_irqsave(&rtc_lock, flags);
+	CMOS_WRITE(0, 0xf);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+
+	*((volatile u32 *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) = 0;
+}
+
+static inline void __init smpboot_setup_io_apic(void)
+{
+#ifdef CONFIG_X86_IO_APIC
+	/*
+	 * Here we can be sure that there is an IO-APIC in the system. Let's
+	 * go and set it up:
+	 */
+	if (!skip_ioapic_setup && nr_ioapics)
+		setup_IO_APIC();
+	else {
+		nr_ioapics = 0;
+	}
+#endif
+}
+
+static inline void smpboot_clear_io_apic(void)
+{
+#ifdef CONFIG_X86_IO_APIC
+	nr_ioapics = 0;
+#endif
+}
+
 /*
  * Report back to the Boot Processor during boot time or to the caller processor
  * during CPU online.


