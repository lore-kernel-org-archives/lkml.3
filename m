Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162905Ab3DEUnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:43:05 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20094 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162808Ab3DEUme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:42:34 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        x86@kernel.org, hpa@zytor.com, konrad@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/4] x86/gdt/i386: store/load GDT for ACPI S3 or hibernation/resume path is not needed
Date: Fri,  5 Apr 2013 16:42:22 -0400
Message-Id: <1365194544-14648-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365194544-14648-1-git-send-email-konrad.wilk@oracle.com>
References: <1365194544-14648-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the ACPI S3 suspend, we store the GDT in the wakup_header (see
wakeup_asm.s) field called 'pmode_gdt'.

Which is then used during the resume path and has the same exact
value as what the store/load_gdt do with the saved_context
(which is saved/restored via save/restore_processor_state()).

The flow during resume from ACPI S3 is simpler than the 64-bit
counterpart. We only use the early bootstrap once (wakeup_gdt) and
do various checks in real mode.

After the checks are completed, we load the saved GDT ('pmode_gdt') and
continue on with the resume (by heading to startup_32 in trampoline_32.S) -
which quickly jumps to what was saved in 'pmode_entry'
aka 'wakeup_pmode_return'.

The 'wakeup_pmode_return' restores the GDT (saved_gdt) again (which was
saved in do_suspend_lowlevel initially). After that it ends up calling
the 'ret_point' which calls 'restore_processor_state()'.

We have two opportunities to remove code where we restore the same GDT
twice.

Here is the call chain:
 wakeup_start
       |- lgdtl wakeup_gdt [the work-around broken BIOSes]
       |
       | - lgdtl pmode_gdt [the real one]
       |
       \-- startup_32 (in trampoline_32.S)
              \-- wakeup_pmode_return (in wakeup_32.S)
                       |- lgdtl saved_gdt [the real one]
                       \-- ret_point
                             |..
                             |- call restore_processor_state

The hibernate path is much simpler. During the saving of the hibernation
image we call save_processor_state() and save the contents of that
along with the rest of the kernel in the hibernation image destination.
We save the EIP of 'restore_registers' (restore_jump_address) and
cr3 (restore_cr3).

During hibernate resume, the 'restore_registers' (via the
'restore_jump_address) in hibernate_asm_32.S is invoked which
restores the contents of most registers. Naturally the resume path benefits
from already being in 32-bit mode, so it does not have to reload the GDT.

It only reloads the cr3 (from restore_cr3) and continues on. Note
that the restoration of the restore image page-tables is done prior to
this.

After the 'restore_registers' it returns and we end up called
restore_processor_state() - where we reload the GDT. The reload of
the GDT is not needed as bootup kernel has already loaded the GDT
which is at the same physical location as the the restored kernel.

Note that the hibernation path assumes the GDT is correct during its
'restore_registers'. The assumption in the code is that the restored
image is the same as saved - meaning we are not trying to restore
an different kernel in the virtual address space of a new kernel.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/suspend_32.h | 1 -
 arch/x86/kernel/acpi/wakeup_32.S  | 3 ---
 arch/x86/power/cpu.c              | 2 --
 3 files changed, 6 deletions(-)

diff --git a/arch/x86/include/asm/suspend_32.h b/arch/x86/include/asm/suspend_32.h
index 487055c..f6064b7 100644
--- a/arch/x86/include/asm/suspend_32.h
+++ b/arch/x86/include/asm/suspend_32.h
@@ -15,7 +15,6 @@ struct saved_context {
 	unsigned long cr0, cr2, cr3, cr4;
 	u64 misc_enable;
 	bool misc_enable_saved;
-	struct desc_ptr gdt;
 	struct desc_ptr idt;
 	u16 ldt;
 	u16 tss;
diff --git a/arch/x86/kernel/acpi/wakeup_32.S b/arch/x86/kernel/acpi/wakeup_32.S
index 13ab720..91adb1b 100644
--- a/arch/x86/kernel/acpi/wakeup_32.S
+++ b/arch/x86/kernel/acpi/wakeup_32.S
@@ -18,7 +18,6 @@ wakeup_pmode_return:
 	movw	%ax, %gs
 
 	# reload the gdt, as we need the full 32 bit address
-	lgdt	saved_gdt
 	lidt	saved_idt
 	lldt	saved_ldt
 	ljmp	$(__KERNEL_CS), $1f
@@ -44,7 +43,6 @@ bogus_magic:
 
 
 save_registers:
-	sgdt	saved_gdt
 	sidt	saved_idt
 	sldt	saved_ldt
 	str	saved_tss
@@ -93,7 +91,6 @@ ENTRY(saved_magic)	.long	0
 ENTRY(saved_eip)	.long	0
 
 # saved registers
-saved_gdt:	.long	0,0
 saved_idt:	.long	0,0
 saved_ldt:	.long	0
 saved_tss:	.long	0
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index fdca260..571176f 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -62,7 +62,6 @@ static void __save_processor_state(struct saved_context *ctxt)
 	 * descriptor tables
 	 */
 #ifdef CONFIG_X86_32
-	store_gdt(&ctxt->gdt);
 	store_idt(&ctxt->idt);
 #else
 /* CONFIG_X86_64 */
@@ -182,7 +181,6 @@ static void __restore_processor_state(struct saved_context *ctxt)
 	 * ltr is done i fix_processor_context().
 	 */
 #ifdef CONFIG_X86_32
-	load_gdt(&ctxt->gdt);
 	load_idt(&ctxt->idt);
 #else
 /* CONFIG_X86_64 */
-- 
1.8.1.4

