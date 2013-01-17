Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab3ARDuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 22:50:17 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:31590 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab3ARDuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 22:50:11 -0500
Date: Thu, 17 Jan 2013 09:36:48 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        lenb@kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 2/4] xen/lowlevel: Implement pvop call for load_idt
 (sidt).
Message-ID: <20130117143648.GA2552@phenom.dumpdata.com>
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com>
 <1350481786-4969-3-git-send-email-konrad.wilk@oracle.com>
 <507F4475.80705@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507F4475.80705@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 04:51:17PM -0700, H. Peter Anvin wrote:
> On 10/17/2012 06:49 AM, Konrad Rzeszutek Wilk wrote:
> >In the past it used to point to 'sidt' (native_store_idt) operation
> >which is a non-privileged operation. This resulted in the
> >'struct desc_ptr' value containing the address of Xen's IDT table,
> >instead of the IDT table that Linux thinks its using. The end result
> >is that doing:
> >
> >   store_idt(&desc);
> >   load_idt(&desc);
> >
> >would blow up b/c xen_load_idt would try to parse the IDT contents
> >(desc) and de-reference a virtual address that is outside Linux's
> >__va (it is in Xen's virtual address).
> >
> >With this patch we are providing the last written IDT address.
> >
> 
> OK... this seems like another excellent set of pvops calls that
> should be nukable to Kingdom Come.  There is no reason, ever, to
> read the IDT and GDT from the kernel... the kernel already knows
> what they should be!

The code that uses these is "__save_processor_state" and 
"__restore_processor_state". To test the viability of removing
them, I did a very simple patch (see attached) and found
out that omitting those calls on AMD machines at least (hadn't
tried Intel yet) crashes the machine.

Interestingly enough, skipping the cr3, cr2, and cr0 loads in
arch/x86/kernel/acpi/wakeup_64.S worked fine!?


>From 7a7b1ea335f852f2a5ced1eb7f305fa329f7615a Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 16 Jan 2013 16:16:46 -0500
Subject: [PATCH] x86: ignore_idt, ignore_gdt, tss, cr3 knobs.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/suspend_64.h |  1 +
 arch/x86/kernel/acpi/sleep.c      | 19 +++++++++++++++-
 arch/x86/kernel/acpi/wakeup_64.S  |  4 ++++
 arch/x86/kernel/asm-offsets_64.c  |  1 +
 arch/x86/power/cpu.c              | 47 ++++++++++++++++++++++++++++++---------
 arch/x86/xen/enlighten.c          |  4 +++-
 drivers/xen/acpi.c                |  6 ++++-
 7 files changed, 69 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/suspend_64.h b/arch/x86/include/asm/suspend_64.h
index 09b0bf1..15603b1 100644
--- a/arch/x86/include/asm/suspend_64.h
+++ b/arch/x86/include/asm/suspend_64.h
@@ -36,6 +36,7 @@ struct saved_context {
 	unsigned long tr;
 	unsigned long safety;
 	unsigned long return_address;
+	u8 skip;
 } __attribute__((packed));
 
 #define loaddebug(thread,register) \
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index d5e0d71..13c71e6 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -24,6 +24,9 @@ unsigned long acpi_realmode_flags;
 #if defined(CONFIG_SMP) && defined(CONFIG_64BIT)
 static char temp_stack[4096];
 #endif
+#include <asm/suspend_64.h>
+bool skip_cr3;
+extern struct saved_context saved_context;
 
 /**
  * acpi_suspend_lowlevel - save kernel state
@@ -82,10 +85,16 @@ int acpi_suspend_lowlevel(void)
        saved_magic = 0x123456789abcdef0L;
 #endif /* CONFIG_64BIT */
 
+	if (skip_cr3) {
+		printk(KERN_INFO "Skipping cr3\n");
+		saved_context.skip = 1;
+	}
 	do_suspend_lowlevel();
 	return 0;
 }
-
+bool ignore_idt;
+bool ignore_gdt;
+bool alternative_tss;
 static int __init acpi_sleep_setup(char *str)
 {
 	while ((str != NULL) && (*str != '\0')) {
@@ -105,6 +114,14 @@ static int __init acpi_sleep_setup(char *str)
 			acpi_nvs_nosave_s3();
 		if (strncmp(str, "old_ordering", 12) == 0)
 			acpi_old_suspend_ordering();
+		if (strncmp(str, "ignore_idt", 10) == 0)
+			ignore_idt = true;
+		if (strncmp(str, "ignore_gdt", 10) == 0)
+			ignore_idt = true;
+		if (strncmp(str, "tss", 3) == 0)
+			alternative_tss = true;
+		if (strncmp(str, "cr3", 3) == 0)
+			skip_cr3 = true;
 		str = strchr(str, ',');
 		if (str != NULL)
 			str += strspn(str, ", \t");
diff --git a/arch/x86/kernel/acpi/wakeup_64.S b/arch/x86/kernel/acpi/wakeup_64.S
index 8ea5164..c7e41c5 100644
--- a/arch/x86/kernel/acpi/wakeup_64.S
+++ b/arch/x86/kernel/acpi/wakeup_64.S
@@ -83,12 +83,16 @@ resume_point:
 	movq	$saved_context, %rax
 	movq	saved_context_cr4(%rax), %rbx
 	movq	%rbx, %cr4
+
+	cmp	$0x0, saved_context_skip(%rax)
+	jne	skip
 	movq	saved_context_cr3(%rax), %rbx
 	movq	%rbx, %cr3
 	movq	saved_context_cr2(%rax), %rbx
 	movq	%rbx, %cr2
 	movq	saved_context_cr0(%rax), %rbx
 	movq	%rbx, %cr0
+skip:
 	pushq	pt_regs_flags(%rax)
 	popfq
 	movq	pt_regs_sp(%rax), %rsp
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 1b4754f..b7b7808 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -73,6 +73,7 @@ int main(void)
 	ENTRY(cr3);
 	ENTRY(cr4);
 	ENTRY(cr8);
+	ENTRY(skip);
 	BLANK();
 #undef ENTRY
 
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index c8ece7d..b4b2436 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -35,6 +35,10 @@ unsigned long saved_context_eflags;
 struct saved_context saved_context;
 #endif
 
+extern bool ignore_idt;
+extern bool ignore_gdt;
+extern bool alternative_tss;
+
 /**
  *	__save_processor_state - save CPU registers before creating a
  *		hibernation image and before restoring the memory state from it
@@ -61,12 +65,16 @@ static void __save_processor_state(struct saved_context *ctxt)
 	 * descriptor tables
 	 */
 #ifdef CONFIG_X86_32
-	store_gdt(&ctxt->gdt);
-	store_idt(&ctxt->idt);
+	if (!ignore_gdt)
+		store_gdt(&ctxt->gdt);
+	if (!ignore_idt)
+		store_idt(&ctxt->idt);
 #else
 /* CONFIG_X86_64 */
-	store_gdt((struct desc_ptr *)&ctxt->gdt_limit);
-	store_idt((struct desc_ptr *)&ctxt->idt_limit);
+	if (!ignore_gdt)
+		store_gdt((struct desc_ptr *)&ctxt->gdt_limit);
+	if (!ignore_idt)
+		store_idt((struct desc_ptr *)&ctxt->idt_limit);
 #endif
 	store_tr(ctxt->tr);
 
@@ -136,6 +144,7 @@ static void fix_processor_context(void)
 	struct tss_struct *t = &per_cpu(init_tss, cpu);
 #ifdef CONFIG_X86_64
 	struct desc_struct *desc = get_cpu_gdt_table(cpu);
+	tss_desc tss;
 #endif
 	set_tss_desc(cpu, t);	/*
 				 * This just modifies memory; should not be
@@ -145,13 +154,23 @@ static void fix_processor_context(void)
 				 */
 
 #ifdef CONFIG_X86_64
-	if (!desc_empty(&desc[GDT_ENTRY_TSS]))
-		desc[GDT_ENTRY_TSS].type = DESC_TSS;
+	if (alternative_tss) {
+ 		memcpy(&tss, &desc[GDT_ENTRY_TSS], sizeof(tss_desc));
+		tss.type = DESC_TSS;
+		write_gdt_entry(desc, GDT_ENTRY_TSS, &tss, DESC_TSS);
+	} else {
+		if (!desc_empty(&desc[GDT_ENTRY_TSS])) {
+			desc[GDT_ENTRY_TSS].type = DESC_TSS;
+		}
+	}
 
 	syscall_init();				/* This sets MSR_*STAR and related */
 #endif
+	outb('G', 0xe9);
 	load_TR_desc();				/* This does ltr */
+	outb('H', 0xe9);
 	load_LDT(&current->active_mm->context);	/* This does lldt */
+	outb('I', 0xe9);
 }
 
 /**
@@ -185,12 +204,16 @@ static void __restore_processor_state(struct saved_context *ctxt)
 	 * ltr is done i fix_processor_context().
 	 */
 #ifdef CONFIG_X86_32
-	load_gdt(&ctxt->gdt);
-	load_idt(&ctxt->idt);
+	if (!ignore_gdt)
+		load_gdt(&ctxt->gdt);
+	if (!ignore_idt)
+		load_idt(&ctxt->idt);
 #else
 /* CONFIG_X86_64 */
-	load_gdt((const struct desc_ptr *)&ctxt->gdt_limit);
-	load_idt((const struct desc_ptr *)&ctxt->idt_limit);
+	if (!ignore_gdt)
+		load_gdt((const struct desc_ptr *)&ctxt->gdt_limit);
+	if (!ignore_idt)
+		load_idt((const struct desc_ptr *)&ctxt->idt_limit);
 #endif
 
 	/*
@@ -228,9 +251,13 @@ static void __restore_processor_state(struct saved_context *ctxt)
 
 	fix_processor_context();
 
+	outb('P', 0xe9);
 	do_fpu_end();
+	outb('Q', 0xe9);
 	x86_platform.restore_sched_clock_state();
+	outb('R', 0xe9);
 	mtrr_bp_restore();
+	outb('S', 0xe9);
 }
 
 /* Needed by apm.c */
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index dfe1332..8be90ea 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1035,6 +1035,7 @@ static void xen_write_cr4(unsigned long cr4)
 	native_write_cr4(cr4);
 }
 #ifdef CONFIG_X86_64
+extern bool skip_cr3;
 static inline unsigned long xen_read_cr8(void)
 {
 	return 0;
@@ -1094,7 +1095,8 @@ static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
  		 * xen_read_cr3 will try to find the cr3 for the user-space
  		 * case - and feed it to the hypercall (which would fail).
  		 */
-		xen_acpi_reload_cr3_value();
+		if (!skip_cr3)
+			xen_acpi_reload_cr3_value();
 #endif
 	default:
 		ret = native_write_msr_safe(msr, low, high);
diff --git a/drivers/xen/acpi.c b/drivers/xen/acpi.c
index a97414d..2ac4aac 100644
--- a/drivers/xen/acpi.c
+++ b/drivers/xen/acpi.c
@@ -56,6 +56,8 @@ void xen_acpi_reload_cr3_value(void)
 	saved_context.cr3 = read_cr3();
 }
 #endif
+extern bool skip_cr3;
+
 int xen_acpi_notify_hypervisor_state(u8 sleep_state,
 				     u32 pm1a_cnt, u32 pm1b_cnt)
 {
@@ -98,7 +100,9 @@ int xen_acpi_notify_hypervisor_state(u8 sleep_state,
 		mfn = pfn_to_mfn(PFN_DOWN(saved_context.cr3));
 		/* and back to a physical address */
 		mfn = PFN_PHYS(mfn);
-		saved_context.cr3 = mfn;
+
+		if (!skip_cr3)
+			saved_context.cr3 = mfn;
 
 		/* Sadly, this has the end result that if we the resume code
  		 * does the movq X, %cr3 and then later uses the X value to do
-- 
1.8.0.2

> 
> 	-hpa
> 
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
