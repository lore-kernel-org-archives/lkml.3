Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162891Ab3DEUnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:43:03 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42110 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162804Ab3DEUme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:42:34 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        x86@kernel.org, hpa@zytor.com, konrad@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/4] x86/gdt/64-bit: store/load GDT for ACPI S3 or hibernate/resume path is not needed.
Date: Fri,  5 Apr 2013 16:42:21 -0400
Message-Id: <1365194544-14648-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365194544-14648-1-git-send-email-konrad.wilk@oracle.com>
References: <1365194544-14648-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the ACPI S3 resume path the trampoline code handles it already.

During the ACPI S3 suspend phase (acpi_suspend_lowlevel) we set:
early_gdt_descr.address = (..)get_cpu_gdt_table(smp_processor_id());

which is then used during the resume path and has the same exact
value as what the store/load_gdt do with the saved_context
(which is saved/restored via save/restore_processor_state()).

The flow during resume is complex and for 64-bit kernels we use three GDTs
- one early bootstrap GDT (wakeup_igdt) that we load to workaround
broken BIOSes, an early Protected Mode to Long Mode transition one
(tr_gdt), and the final one - early_gdt_descr (which points to the real GDT).

The early ('wakeup_gdt') is loaded in 'trampoline_start' for working
around broken BIOSes, and then when we end up in Protected Mode in the
startup_32 (in trampoline_64.s, not head_32.s) we use the 'tr_gdt'
(still in trampoline_64.s). This 'tr_gdt' has a a 32-bit code segment,
64-bit code segment with L=1, and a 32-bit data segment.

Once we have transitioned from Protected Mode to Long Mode we then
set the GDT to 'early_gdt_desc' and then via an iretq emerge in
wakeup_long64 (set via 'initial_code' variable in acpi_suspend_lowlevel).

In the wakeup_long64 we end up restoring the %rip (which is set to
'resume_point') and jump there.

In 'resume_point' we call 'restore_processor_state' which does
the load_gdt on the saved context. This load_gdt is redundant as the
GDT loaded via early_gdt_desc is the same.

Here is the call-chain:
 wakeup_start
   |- lgdtl wakeup_gdt [the work-around broken BIOSes]
   |
   \-- trampoline_start (trampoline_64.S)
         |- lgdtl tr_gdt
         |
         \-- startup_32 (trampoline_64.S)
               |
               \-- startup_64 (trampoline_64.S)
                      |
                      \-- secondary_startup_64
                               |- lgdtl early_gdt_desc
                               | ...
                               |- movq initial_code(%rip), %eax
                               |-.. lretq
                               \-- wakeup_64
                                     |-- other registers are reloaded
                                     |-- call restore_processor_state

The hibernate path is much simpler. During the saving of the hibernation
image we call save_processor_state() and save the contents of that along
with the rest of the kernel in the hibernation image destination.
We save the EIP of 'restore_registers' (restore_jump_address) and cr3
(restore_cr3).

During hibernate resume, the 'restore_registers' (via the
'restore_jump_address) in hibernate_asm_64.S is invoked which restores
the contents of most registers. Naturally the resume path benefits from
already being in 64-bit mode, so it does not have to load the GDT.

It only reloads the cr3 (from restore_cr3) and continues on. Note that
the restoration of the restore image page-tables is done prior to this.

After the 'restore_registers' it returns and we end up called
restore_processor_state() - where we reload the GDT. The reload of
the GDT is not needed as bootup kernel has already loaded the GDT which
is at the same physical location as the the restored kernel.

Note that the hibernation path assumes the GDT is correct during its
'restore_registers'. The assumption in the code is that the restored
image is the same as saved - meaning we are not trying to restore
an different kernel in the virtual address space of a new kernel.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/suspend_64.h | 3 ---
 arch/x86/power/cpu.c              | 2 --
 2 files changed, 5 deletions(-)

diff --git a/arch/x86/include/asm/suspend_64.h b/arch/x86/include/asm/suspend_64.h
index 09b0bf1..97b84e0 100644
--- a/arch/x86/include/asm/suspend_64.h
+++ b/arch/x86/include/asm/suspend_64.h
@@ -25,9 +25,6 @@ struct saved_context {
 	u64 misc_enable;
 	bool misc_enable_saved;
 	unsigned long efer;
-	u16 gdt_pad;
-	u16 gdt_limit;
-	unsigned long gdt_base;
 	u16 idt_pad;
 	u16 idt_limit;
 	unsigned long idt_base;
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 3c68768..fdca260 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -66,7 +66,6 @@ static void __save_processor_state(struct saved_context *ctxt)
 	store_idt(&ctxt->idt);
 #else
 /* CONFIG_X86_64 */
-	store_gdt((struct desc_ptr *)&ctxt->gdt_limit);
 	store_idt((struct desc_ptr *)&ctxt->idt_limit);
 #endif
 	store_tr(ctxt->tr);
@@ -187,7 +186,6 @@ static void __restore_processor_state(struct saved_context *ctxt)
 	load_idt(&ctxt->idt);
 #else
 /* CONFIG_X86_64 */
-	load_gdt((const struct desc_ptr *)&ctxt->gdt_limit);
 	load_idt((const struct desc_ptr *)&ctxt->idt_limit);
 #endif
 
-- 
1.8.1.4

