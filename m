Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbbAVO3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:29:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57943 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbbAVO3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:29:11 -0500
Date: Thu, 22 Jan 2015 06:28:46 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-f77aa308e5a6144a47311ad6905a1a72bc0014f9@git.kernel.org>
Cc: hpa@zytor.com, tony.luck@intel.com, jiang.liu@linux.intel.com,
        bp@alien8.de, tglx@linutronix.de, joro@8bytes.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org
Reply-To: mingo@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        joro@8bytes.org, tglx@linutronix.de, jiang.liu@linux.intel.com,
        tony.luck@intel.com, bp@alien8.de
In-Reply-To: <20150115211703.304126687@linutronix.de>
References: <20150115211703.304126687@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/smpboot: Move smpboot inlines to code
Git-Commit-ID: f77aa308e5a6144a47311ad6905a1a72bc0014f9
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

Commit-ID:  f77aa308e5a6144a47311ad6905a1a72bc0014f9
Gitweb:     http://git.kernel.org/tip/f77aa308e5a6144a47311ad6905a1a72bc0014f9
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 15 Jan 2015 21:22:29 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 15:10:55 +0100

x86/smpboot: Move smpboot inlines to code

No point for a separate header file.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/20150115211703.304126687@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/smpboot_hooks.h | 68 ------------------------------------
 arch/x86/kernel/smpboot.c            | 66 +++++++++++++++++++++++++++++++++-
 2 files changed, 65 insertions(+), 69 deletions(-)

diff --git a/arch/x86/include/asm/smpboot_hooks.h b/arch/x86/include/asm/smpboot_hooks.h
deleted file mode 100644
index 0da7409..0000000
--- a/arch/x86/include/asm/smpboot_hooks.h
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
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6d7022c..110ed11 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -73,7 +73,6 @@
 #include <asm/setup.h>
 #include <asm/uv/uv.h>
 #include <linux/mc146818rtc.h>
-#include <asm/smpboot_hooks.h>
 #include <asm/i8259.h>
 #include <asm/realmode.h>
 #include <asm/misc.h>
@@ -104,6 +103,71 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
 
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
+	else
+		nr_ioapics = 0;
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
