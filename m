Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab3DKW73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 18:59:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48291 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763205Ab3DKW71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 18:59:27 -0400
Date: Thu, 11 Apr 2013 15:59:11 -0700
From: tip-bot for Konrad Rzeszutek Wilk <tipbot@zytor.com>
Message-ID: <tip-e7a5cd063c7b4c58417f674821d63f5eb6747e37@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, tglx@linutronix.de, hpa@linux.intel.com,
        rjw@sisk.pl
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, tglx@linutronix.de, rjw@sisk.pl,
        hpa@linux.intel.com
In-Reply-To: <1365194544-14648-2-git-send-email-konrad.wilk@oracle.com>
References: <1365194544-14648-2-git-send-email-konrad.wilk@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/paravirt] x86-64, gdt: Store/
 load GDT for ACPI S3 or hibernate/resume path is not needed.
Git-Commit-ID: e7a5cd063c7b4c58417f674821d63f5eb6747e37
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 11 Apr 2013 15:59:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e7a5cd063c7b4c58417f674821d63f5eb6747e37
Gitweb:     http://git.kernel.org/tip/e7a5cd063c7b4c58417f674821d63f5eb6747e37
Author:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
AuthorDate: Fri, 5 Apr 2013 16:42:21 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 11 Apr 2013 15:39:38 -0700

x86-64, gdt: Store/load GDT for ACPI S3 or hibernate/resume path is not needed.

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
Link: http://lkml.kernel.org/r/1365194544-14648-2-git-send-email-konrad.wilk@oracle.com
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
index 120cee1..6bd9423 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -65,7 +65,6 @@ static void __save_processor_state(struct saved_context *ctxt)
 	store_idt(&ctxt->idt);
 #else
 /* CONFIG_X86_64 */
-	store_gdt((struct desc_ptr *)&ctxt->gdt_limit);
 	store_idt((struct desc_ptr *)&ctxt->idt_limit);
 #endif
 	store_tr(ctxt->tr);
@@ -186,7 +185,6 @@ static void __restore_processor_state(struct saved_context *ctxt)
 	load_idt(&ctxt->idt);
 #else
 /* CONFIG_X86_64 */
-	load_gdt((const struct desc_ptr *)&ctxt->gdt_limit);
 	load_idt((const struct desc_ptr *)&ctxt->idt_limit);
 #endif
 
