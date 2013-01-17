Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab3ARDt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 22:49:59 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:31538 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab3ARDt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 22:49:57 -0500
Date: Thu, 17 Jan 2013 09:48:35 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        lenb@kernel.org, linux-acpi@vger.kernel.org, hpa@zytor.com,
        x86@kernel.org
Subject: Re: [PATCH 4/4] xen/acpi: Prep saved_context cr3 values.
Message-ID: <20130117144835.GC2552@phenom.dumpdata.com>
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com>
 <1350481786-4969-5-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350481786-4969-5-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 09:49:46AM -0400, Konrad Rzeszutek Wilk wrote:
> When save_processor_state is executed it executes a bunch of
> pvops calls to save the CPU state values. When it comes back
> from Xen's S3 (so acpi_enter_sleep_state, which ends up calling
> xen_acpi_notify_hypervisor_state), it ends up back in the
> assembler code in wakeup_[32|64].S. It skips the wakeup
> calls (so wakeup_pmode_return and wakeup_long64) as that has
> been done in the hypervisor. Instead it continues on in
> the resume_point (64-bit) or ret_point (32-bit). Most of the
> calls in there are safe to be executed except when it comes to
> reloading of cr3 (which it only does on 64-bit kernels). Since
> they are native assembler calls and Xen expects a PV kernel to
> prep those to use machine address for cr3 that is what
> we are going to do. Note: that it is not Machine Frame Numbers
> (those are used in the MMUEXT_NEW_BASEPTR hypercall for cr3
> installation) but the machine physical address.
> 
> When the assembler code executes this mov %ebx, cr3 it ends
> end up trapped in the hypervisor (traps.c) which properly now
> sets the cr3 value.

And then I found out that after this nice
	 mov %ebx,cr3

in the assembler code (resume_point), it ends up calling
__restore_processor_state later on which does:

	write_cr3(ctxt->cr3);

and since that is a pvops call which expects physical address and in
this patch we  modified the ctxt->cr3 to be a machine address value, we end
up giving the hypervisor the wrong value.

This workaround makes it work.. but it is the ugly green-puke spotted
duct-tape variant.

So I think this idea of modifying the ctxt->cr3 to without modifying
the resume_point is a no-go. Len suggested at some point doing this
in the resume point:

-- a/arch/x86/kernel/acpi/wakeup_64.S
+++ b/arch/x86/kernel/acpi/wakeup_64.S
@@ -83,12 +83,16 @@ resume_point:
        movq    $saved_context, %rax
        movq    saved_context_cr4(%rax), %rbx
        movq    %rbx, %cr4
+
+       cmp     $0x0, saved_context_skip(%rax)
+       jne     skip
        movq    saved_context_cr3(%rax), %rbx
        movq    %rbx, %cr3
        movq    saved_context_cr2(%rax), %rbx
        movq    %rbx, %cr2
        movq    saved_context_cr0(%rax), %rbx
        movq    %rbx, %cr0
+skip:
        pushq   pt_regs_flags(%rax)
        popfq
        movq    pt_regs_sp(%rax), %rsp

and that makes it work too. Surprisingly it also makes it work on
baremetal! (Note: Only tested right now on AMD).

anyhow, here is the duct-tape:

commit 09194f091d1eaef7b1aac0289f46acd7cc8c0845
Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date:   Fri Oct 19 13:41:10 2012 -0400

    xen/acpi: Workaround movq X, %cr3 and write_cr3 pvops call using same value.
    
    This is a quirk to work-around the discontinuity of the
    x86_lowlevel_suspend code on x86_64. In it, after calling
    acpi_suspend it calls resume_point, which restores the registers
    and one of them is a movq X, %cr3. The movq X in that case needs
    to be machine address. Later on it calls to  restore_processor_state()
    which uses the pvops variant (write_cr3) - which expects X to be
    physical address. This function restores the cr3 value to be a
    physical address to allow the pvops variant (write_cr3) to work.
    
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index fd1f3dd..dfe1332 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1082,7 +1082,20 @@ static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
 		if (smp_processor_id() == 0)
 			xen_set_pat(((u64)high << 32) | low);
 		break;
-
+#if defined(CONFIG_X86_64)
+	case MSR_EFER:
+		/* Piggyback on the fact that in powers/cpu.c we do
+ 		 * a wrmsr before the paravirt write_cr3. The cr3 value at that
+ 		 * stage in saved_context.cr3 is a machine address instead of
+ 		 * the physical address (this is done in drivers/xen/acpi.c to
+ 		 * compensate for 'return_point' in wakeup_64.S doing an:
+ 		 * movw %ebx, cr3). Anyhow, we piggy back here to reload the
+ 		 * cr3 value of the saved_context. This is done b/c otherwise
+ 		 * xen_read_cr3 will try to find the cr3 for the user-space
+ 		 * case - and feed it to the hypercall (which would fail).
+ 		 */
+		xen_acpi_reload_cr3_value();
+#endif
 	default:
 		ret = native_write_msr_safe(msr, low, high);
 	}
diff --git a/drivers/xen/acpi.c b/drivers/xen/acpi.c
index 25e612c..a97414d 100644
--- a/drivers/xen/acpi.c
+++ b/drivers/xen/acpi.c
@@ -40,8 +40,22 @@
 #ifdef CONFIG_X86_64
 #include <asm/suspend_64.h>
 extern struct saved_context saved_context;
-#endif
 
+/*
+ * This is a quirk to work-around the discontinuity of the
+ * x86_lowlevel_suspend code on x86_64. In it, after calling
+ * acpi_suspend it calls resume_point, which restores the registers
+ * and one of them is a movq X, %cr3. The movq X in that case needs
+ * to be machine address. Later on it calls to  restore_processor_state()
+ * which uses the pvops variant (write_cr3) - which expects X to be
+ * physical address. This function restores the cr3 value to be a
+ * physical address to allow the pvops variant (write_cr3) to work.
+ */
+void xen_acpi_reload_cr3_value(void)
+{
+	saved_context.cr3 = read_cr3();
+}
+#endif
 int xen_acpi_notify_hypervisor_state(u8 sleep_state,
 				     u32 pm1a_cnt, u32 pm1b_cnt)
 {
@@ -71,6 +85,11 @@ int xen_acpi_notify_hypervisor_state(u8 sleep_state,
 	{
 		unsigned long mfn;
 
+		/* Flushes out any multi-calls. */
+		arch_flush_lazy_mmu_mode();
+
+		/* Re-reads the CR3 in case of pending multicalls */
+		saved_context.cr3 = read_cr3();
 		/* resume_point in wakeup_64.s barrels through and does:
 		 * movq    saved_context_cr3(%rax), %rbx
 		 * movq    %rbx, %cr3
@@ -80,6 +99,14 @@ int xen_acpi_notify_hypervisor_state(u8 sleep_state,
 		/* and back to a physical address */
 		mfn = PFN_PHYS(mfn);
 		saved_context.cr3 = mfn;
+
+		/* Sadly, this has the end result that if we the resume code
+ 		 * does the movq X, %cr3 and then later uses the X value to do
+ 		 * an pvops call (write_cr3), we have a discontinuity.
+ 		 * The movq expects a machine frame address while the pvops call
+ 		 * expects a physical frame address. We fix this up with
+ 		 * xen_acpi_reload_cr3_quirk which we put in wrmsr code.
+ 		 */
 	}
 #endif
 	HYPERVISOR_dom0_op(&op);
diff --git a/include/xen/acpi.h b/include/xen/acpi.h
index 48a9c01..ccf26f1 100644
--- a/include/xen/acpi.h
+++ b/include/xen/acpi.h
@@ -42,7 +42,9 @@
 
 int xen_acpi_notify_hypervisor_state(u8 sleep_state,
 				     u32 pm1a_cnt, u32 pm1b_cnd);
-
+#ifdef CONFIG_X86_64
+void xen_acpi_reload_cr3_value(void);
+#endif
 static inline void xen_acpi_sleep_register(void)
 {
 	if (xen_initial_domain())
@@ -53,6 +55,11 @@ static inline void xen_acpi_sleep_register(void)
 static inline void xen_acpi_sleep_register(void)
 {
 }
+#ifdef CONFIG_X86_64
+static inline void xen_acpi_reload_cr3_value(void)
+{
+}
+#endif
 #endif
 
 #endif	/* _XEN_ACPI_H */
