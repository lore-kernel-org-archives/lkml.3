Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab3EBBx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 21:53:59 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31586 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115Ab3EBBx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 21:53:56 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, rjw@sisk.pl,
        pavel@ucw.cz, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] x86, x86-64, gdt, hibernate: Store/load GDT for hibernate path.
Date: Wed,  1 May 2013 21:53:30 -0400
Message-Id: <1367459610-9656-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367459610-9656-1-git-send-email-konrad.wilk@oracle.com>
References: <1367459610-9656-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The git commite7a5cd063c7b4c58417f674821d63f5eb6747e37
("x86-64, gdt: Store/load GDT for ACPI S3 or hibernate/resume path
is not needed.") assumes that for the hibernate path the booting
kernel and the resuming kernel MUST be the same. That is certainly
the case for a 32-bit kernel (see check_image_kernel and
CONFIG_ARCH_HIBERNATION_HEADER config option).

However for 64-bit kernels it is OK to have a different kernel
version (and size of the image) of the booting and resuming kernels.
Hence the above mentioned git commit introduces an regression.

This patch fixes it by introducing a 'struct desc_ptr gdt_desc'
back in the 'struct saved_context'. However instead of having in the
'save_processor_state' and 'restore_processor_state' the
store/load_gdt calls, we are only saving the GDT in the
save_processor_state.

For the restore path the lgdt operation is done in
hibernate_asm_[32|64].S in the 'restore_registers' path.

The apt reader of this description will recognize that only 64-bit
kernels need this treatment, not 32-bit. This patch adds the logic
in the 32-bit path to be more similar to 64-bit so that in the future
the unification process can take advantage of this.

Suggested-by: "H. Peter Anvin" <hpa@zytor.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/suspend_32.h |  1 +
 arch/x86/include/asm/suspend_64.h |  2 ++
 arch/x86/kernel/asm-offsets_32.c  |  3 +++
 arch/x86/kernel/asm-offsets_64.c  |  1 +
 arch/x86/power/cpu.c              | 15 ++++++++++-----
 arch/x86/power/hibernate_asm_32.S |  4 ++++
 arch/x86/power/hibernate_asm_64.S |  3 +++
 7 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/suspend_32.h b/arch/x86/include/asm/suspend_32.h
index f6064b7..552d6c9 100644
--- a/arch/x86/include/asm/suspend_32.h
+++ b/arch/x86/include/asm/suspend_32.h
@@ -15,6 +15,7 @@ struct saved_context {
 	unsigned long cr0, cr2, cr3, cr4;
 	u64 misc_enable;
 	bool misc_enable_saved;
+	struct desc_ptr gdt_desc;
 	struct desc_ptr idt;
 	u16 ldt;
 	u16 tss;
diff --git a/arch/x86/include/asm/suspend_64.h b/arch/x86/include/asm/suspend_64.h
index 97b84e0..bc62328 100644
--- a/arch/x86/include/asm/suspend_64.h
+++ b/arch/x86/include/asm/suspend_64.h
@@ -25,6 +25,8 @@ struct saved_context {
 	u64 misc_enable;
 	bool misc_enable_saved;
 	unsigned long efer;
+	u16 gdt_pad; /* Unused */
+	struct desc_ptr gdt_desc;
 	u16 idt_pad;
 	u16 idt_limit;
 	unsigned long idt_base;
diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index 85d98ab..0ef4bba 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -60,6 +60,9 @@ void foo(void)
 	OFFSET(IA32_RT_SIGFRAME_sigcontext, rt_sigframe, uc.uc_mcontext);
 	BLANK();
 
+	OFFSET(saved_context_gdt_desc, saved_context, gdt_desc);
+	BLANK();
+
 	/* Offset from the sysenter stack to tss.sp0 */
 	DEFINE(TSS_sysenter_sp0, offsetof(struct tss_struct, x86_tss.sp0) -
 		 sizeof(struct tss_struct));
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 1b4754f..e7c798b 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -73,6 +73,7 @@ int main(void)
 	ENTRY(cr3);
 	ENTRY(cr4);
 	ENTRY(cr8);
+	ENTRY(gdt_desc);
 	BLANK();
 #undef ENTRY
 
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 6d6e907..1cf5b30 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -25,16 +25,12 @@
 #include <asm/cpu.h>
 
 #ifdef CONFIG_X86_32
-static struct saved_context saved_context;
-
 unsigned long saved_context_ebx;
 unsigned long saved_context_esp, saved_context_ebp;
 unsigned long saved_context_esi, saved_context_edi;
 unsigned long saved_context_eflags;
-#else
-/* CONFIG_X86_64 */
-struct saved_context saved_context;
 #endif
+struct saved_context saved_context;
 
 /**
  *	__save_processor_state - save CPU registers before creating a
@@ -67,6 +63,15 @@ static void __save_processor_state(struct saved_context *ctxt)
 /* CONFIG_X86_64 */
 	store_idt((struct desc_ptr *)&ctxt->idt_limit);
 #endif
+	/*
+	 * We save it here, but restore it only in the hibernate case.
+	 * For ACPI S3 resume, this is loaded via 'early_gdt_desc' in 64-bit
+	 * mode in "secondary_startup_64". In 32-bit mode it is done via
+	 * 'pmode_gdt' in wakeup_start.
+	 */
+	ctxt->gdt_desc.size = GDT_SIZE - 1;
+	ctxt->gdt_desc.address = (unsigned long)get_cpu_gdt_table(smp_processor_id());
+
 	store_tr(ctxt->tr);
 
 	/* XMM0..XMM15 should be handled by kernel_fpu_begin(). */
diff --git a/arch/x86/power/hibernate_asm_32.S b/arch/x86/power/hibernate_asm_32.S
index ad47dae..1d0fa0e 100644
--- a/arch/x86/power/hibernate_asm_32.S
+++ b/arch/x86/power/hibernate_asm_32.S
@@ -75,6 +75,10 @@ done:
 	pushl saved_context_eflags
 	popfl
 
+	/* Saved in save_processor_state. */
+	movl $saved_context, %eax
+	lgdt saved_context_gdt_desc(%eax)
+
 	xorl	%eax, %eax
 
 	ret
diff --git a/arch/x86/power/hibernate_asm_64.S b/arch/x86/power/hibernate_asm_64.S
index 9356547..3c4469a 100644
--- a/arch/x86/power/hibernate_asm_64.S
+++ b/arch/x86/power/hibernate_asm_64.S
@@ -139,6 +139,9 @@ ENTRY(restore_registers)
 	pushq	pt_regs_flags(%rax)
 	popfq
 
+	/* Saved in save_processor_state. */
+	lgdt	saved_context_gdt_desc(%rax)
+
 	xorq	%rax, %rax
 
 	/* tell the hibernation core that we've just restored the memory */
-- 
1.8.1.4

