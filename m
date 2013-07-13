Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925Ab3GMLVC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 07:21:02 -0400
Received: from www.linutronix.de ([62.245.132.108]:44379 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757711Ab3GMLVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 07:21:00 -0400
Date: Sat, 13 Jul 2013 13:21:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] x86 updates for 3.11
Message-ID: <alpine.DEB.2.02.1307131317350.11918@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-597968327-1373714462=:11918"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-597968327-1373714462=:11918
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

Linus,

please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   * Guarantee IDT page alignment
   * Revert an UEFI patch which caused a regression
   * Add a missing check for EFI runtime services
   * Fix for an x86 erratum where read access to nonexisting MSRs does
     not result in a fault.

Thanks,

	tglx

------------------>
H. Peter Anvin (1):
      x86, suspend: Handle CPUs which fail to #GP on RDMSR

Kees Cook (1):
      x86: Make sure IDT is page aligned

Matt Fleming (2):
      efivars: check for EFI_RUNTIME_SERVICES
      Revert "UEFI: Don't pass boot services regions to SetVirtualAddressMap()"

Xiong Zhou (1):
      x86/platform/ce4100: Add header file for reboot type


 arch/x86/kernel/acpi/sleep.c      |   18 ++++++++++++++++--
 arch/x86/kernel/head_64.S         |    4 ----
 arch/x86/kernel/traps.c           |    7 ++-----
 arch/x86/platform/ce4100/ce4100.c |    1 +
 arch/x86/platform/efi/efi.c       |    7 -------
 drivers/firmware/efi/efivars.c    |    3 +++
 6 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 2a34aaf..3312010 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -48,9 +48,20 @@ int x86_acpi_suspend_lowlevel(void)
 #ifndef CONFIG_64BIT
 	native_store_gdt((struct desc_ptr *)&header->pmode_gdt);
 
+	/*
+	 * We have to check that we can write back the value, and not
+	 * just read it.  At least on 90 nm Pentium M (Family 6, Model
+	 * 13), reading an invalid MSR is not guaranteed to trap, see
+	 * Erratum X4 in "Intel Pentium M Processor on 90 nm Process
+	 * with 2-MB L2 Cache and Intel® Processor A100 and A110 on 90
+	 * nm process with 512-KB L2 Cache Specification Update".
+	 */
 	if (!rdmsr_safe(MSR_EFER,
 			&header->pmode_efer_low,
-			&header->pmode_efer_high))
+			&header->pmode_efer_high) &&
+	    !wrmsr_safe(MSR_EFER,
+			header->pmode_efer_low,
+			header->pmode_efer_high))
 		header->pmode_behavior |= (1 << WAKEUP_BEHAVIOR_RESTORE_EFER);
 #endif /* !CONFIG_64BIT */
 
@@ -61,7 +72,10 @@ int x86_acpi_suspend_lowlevel(void)
 	}
 	if (!rdmsr_safe(MSR_IA32_MISC_ENABLE,
 			&header->pmode_misc_en_low,
-			&header->pmode_misc_en_high))
+			&header->pmode_misc_en_high) &&
+	    !wrmsr_safe(MSR_IA32_MISC_ENABLE,
+			header->pmode_misc_en_low,
+			header->pmode_misc_en_high))
 		header->pmode_behavior |=
 			(1 << WAKEUP_BEHAVIOR_RESTORE_MISC_ENABLE);
 	header->realmode_flags = acpi_realmode_flags;
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 5e4d8a8..317b8cc 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -514,10 +514,6 @@ ENTRY(phys_base)
 	
 	.section .bss, "aw", @nobits
 	.align L1_CACHE_BYTES
-ENTRY(idt_table)
-	.skip IDT_ENTRIES * 16
-
-	.align L1_CACHE_BYTES
 ENTRY(debug_idt_table)
 	.skip IDT_ENTRIES * 16
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b0865e8..0952614 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -68,13 +68,10 @@
 #include <asm/setup.h>
 
 asmlinkage int system_call(void);
+#endif
 
-/*
- * The IDT has to be page-aligned to simplify the Pentium
- * F0 0F bug workaround.
- */
+/* The IDT has to be page-aligned to keep it aligned with its fixmap. */
 gate_desc idt_table[NR_VECTORS] __page_aligned_data = { { { { 0, 0 } } }, };
-#endif
 
 DECLARE_BITMAP(used_vectors, NR_VECTORS);
 EXPORT_SYMBOL_GPL(used_vectors);
diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
index f8ab494..9962015 100644
--- a/arch/x86/platform/ce4100/ce4100.c
+++ b/arch/x86/platform/ce4100/ce4100.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/serial_reg.h>
 #include <linux/serial_8250.h>
+#include <linux/reboot.h>
 
 #include <asm/ce4100.h>
 #include <asm/prom.h>
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index c8d5577..90f6ed1 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -931,13 +931,6 @@ void __init efi_enter_virtual_mode(void)
 			va = efi_ioremap(md->phys_addr, size,
 					 md->type, md->attribute);
 
-		if (!(md->attribute & EFI_MEMORY_RUNTIME)) {
-			if (!va)
-				pr_err("ioremap of 0x%llX failed!\n",
-				       (unsigned long long)md->phys_addr);
-			continue;
-		}
-
 		md->virt_addr = (u64) (unsigned long) va;
 
 		if (!va) {
diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 8bd1bb6..8a7432a 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -583,6 +583,9 @@ int efivars_sysfs_init(void)
 	struct kobject *parent_kobj = efivars_kobject();
 	int error = 0;
 
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		return -ENODEV;
+
 	/* No efivars has been registered yet */
 	if (!parent_kobj)
 		return 0;
--8323329-597968327-1373714462=:11918--
