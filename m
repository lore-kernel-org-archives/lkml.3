Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454Ab3GRWmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:42:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59763 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759056Ab3GRWmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:42:37 -0400
Date: Thu, 18 Jul 2013 15:41:48 -0700
Message-Id: <201307182241.r6IMfmap003013@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for 3.11-rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Cc: christian.suenkenberg@student.kit.edu, dyoung@redhat.com,
        hpa@linux.intel.com, hpa@zytor.com, jencce.kernel@gmail.com,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        maarten.lankhorst@canonical.com, matt.fleming@intel.com,
        matthew.garrett@nebula.com, mingo@kernel.org,
        onny@project-insanity.org, pageexec@gmail.com, rjw@sisk.pl,
        seth.forshee@canonical.com, tglx@linutronix.de
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 18 Jul 2013 15:41:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Trying again to get the fixes queue, including the fixed IDT alignment
patch.

The UEFI patch is by far the biggest issue at hand: it is currently
causing quite a few machines to boot.  Which is sad, because the only
reason they would is because their BIOSes touch memory that has
already been freed.  The other major issue is that we finally have
tracked down the root cause of a significant number of machines
failing to suspend/resume.

Toivottavasti sinun ei tarvitse kutsua minua perkeleen vittupää tällä
kertaa.

The following changes since commit 6d128e1e72bf082542e85f72e6b7ddd704193588:

  Revert "Makefile: Fix install error with make -j option" (2013-07-10 19:02:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

for you to fetch changes up to 4df05f361937ee86e5a8c9ead8aeb6a19ea9b7d7:

  x86: Make sure IDT is page aligned (2013-07-16 15:14:48 -0700)

----------------------------------------------------------------
H. Peter Anvin (1):
      x86, suspend: Handle CPUs which fail to #GP on RDMSR

Kees Cook (1):
      x86: Make sure IDT is page aligned

Matt Fleming (2):
      efivars: check for EFI_RUNTIME_SERVICES
      Revert "UEFI: Don't pass boot services regions to SetVirtualAddressMap()"

Xiong Zhou (1):
      x86/platform/ce4100: Add header file for reboot type

 arch/x86/kernel/acpi/sleep.c      | 18 ++++++++++++++++--
 arch/x86/kernel/head_64.S         | 15 ---------------
 arch/x86/kernel/tracepoint.c      |  6 ++----
 arch/x86/kernel/traps.c           | 12 ++++++------
 arch/x86/platform/ce4100/ce4100.c |  1 +
 arch/x86/platform/efi/efi.c       |  7 -------
 drivers/firmware/efi/efivars.c    |  3 +++
 7 files changed, 28 insertions(+), 34 deletions(-)

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
index 5e4d8a8..e1aabdb 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -512,21 +512,6 @@ ENTRY(phys_base)
 
 #include "../../x86/xen/xen-head.S"
 	
-	.section .bss, "aw", @nobits
-	.align L1_CACHE_BYTES
-ENTRY(idt_table)
-	.skip IDT_ENTRIES * 16
-
-	.align L1_CACHE_BYTES
-ENTRY(debug_idt_table)
-	.skip IDT_ENTRIES * 16
-
-#ifdef CONFIG_TRACING
-	.align L1_CACHE_BYTES
-ENTRY(trace_idt_table)
-	.skip IDT_ENTRIES * 16
-#endif
-
 	__PAGE_ALIGNED_BSS
 NEXT_PAGE(empty_zero_page)
 	.skip PAGE_SIZE
diff --git a/arch/x86/kernel/tracepoint.c b/arch/x86/kernel/tracepoint.c
index 4e584a8..1c113db 100644
--- a/arch/x86/kernel/tracepoint.c
+++ b/arch/x86/kernel/tracepoint.c
@@ -12,10 +12,8 @@ atomic_t trace_idt_ctr = ATOMIC_INIT(0);
 struct desc_ptr trace_idt_descr = { NR_VECTORS * 16 - 1,
 				(unsigned long) trace_idt_table };
 
-#ifndef CONFIG_X86_64
-gate_desc trace_idt_table[NR_VECTORS] __page_aligned_data
-					= { { { { 0, 0 } } }, };
-#endif
+/* No need to be aligned, but done to keep all IDTs defined the same way. */
+gate_desc trace_idt_table[NR_VECTORS] __page_aligned_bss;
 
 static int trace_irq_vector_refcount;
 static DEFINE_MUTEX(irq_vector_mutex);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b0865e8..1b23a1c 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -63,19 +63,19 @@
 #include <asm/x86_init.h>
 #include <asm/pgalloc.h>
 #include <asm/proto.h>
+
+/* No need to be aligned, but done to keep all IDTs defined the same way. */
+gate_desc debug_idt_table[NR_VECTORS] __page_aligned_bss;
 #else
 #include <asm/processor-flags.h>
 #include <asm/setup.h>
 
 asmlinkage int system_call(void);
-
-/*
- * The IDT has to be page-aligned to simplify the Pentium
- * F0 0F bug workaround.
- */
-gate_desc idt_table[NR_VECTORS] __page_aligned_data = { { { { 0, 0 } } }, };
 #endif
 
+/* Must be page-aligned because the real IDT is used in a fixmap. */
+gate_desc idt_table[NR_VECTORS] __page_aligned_bss;
+
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
