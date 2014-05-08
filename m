Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbaEHXpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 19:45:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:57798 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753298AbaEHXpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 19:45:12 -0400
Date: Thu, 8 May 2014 19:45:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: KVM_GUEST support breaks page fault tracing
Message-ID: <20140508194508.561ed220@gandalf.local.home>
In-Reply-To: <536C0DA8.4090608@intel.com>
References: <536C039A.5000204@intel.com>
	<alpine.DEB.2.02.1405090024050.6261@ionos.tec.linutronix.de>
	<536C0DA8.4090608@intel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 May 2014 16:05:12 -0700
Dave Hansen <dave.hansen@intel.com> wrote:

Added Seiji and hpa

> On 05/08/2014 03:24 PM, Thomas Gleixner wrote:
> >> > I noticed on some of my systems that page fault tracing doesn't work:
> >> > 
> >> > 	cd /sys/kernel/debug/tracing
> >> > 	echo 1 > events/exceptions/enable
> >> > 	cat trace;
> >> > 	# nothing shows up
> >> > 
> >> > I eventually traced it down to CONFIG_KVM_GUEST.  At least in a KVM VM,
> >> > enabling that option breaks page fault tracing, and disabling fixes it.
> >> >  I tried on some old kernels and this does not appear to be a
> >> > regression: it never worked.
> >> > 
> >> > Anybody have any theories about what is going on?

Has to do with the IDT tricks done to keep page faults from getting
zero overhead when tracing is disabled. It sets up two types of traps.
One that encompasses the other. When all of the trap tracepoints are
disabled, the traps are called directly. But when any of them are
enabled, the IDT gets switched to have the traps point to exceptions
that trace the entry and exit of the exception.

see commits 25c74b10bacead867478480170083f69cfc0db48 and
d34603b07c4255b2b00a546d34f297ccd50ae4c6

> 
> Looks like the KVM code calls do_page_fault() directly:
> 
> > dotraplinkage void __kprobes
> > do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
> > {
> >         enum ctx_state prev_state;
> > 
> >         switch (kvm_read_and_reset_pf_reason()) {
> >         default:
> >                 do_page_fault(regs, error_code);
> >                 break;
> >         case KVM_PV_REASON_PAGE_NOT_PRESENT:
> 
> That seems to explain my problems in a VM.  Any objections to doing
> something like the attached patch?

As your patch showed up as an attachment, I couldn't include it in my
reply. But sure, that may work. But you could also play tricks to keep
the overhead off when tracing is disabled like this one:

[ I booted this, but didn't test any kvm guests with it ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 58d66fe..835ba5b 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -39,6 +39,8 @@ asmlinkage void simd_coprocessor_error(void);
 
 #ifdef CONFIG_TRACING
 asmlinkage void trace_page_fault(void);
+asmlinkage void trace_async_page_fault(void);
+#define trace_async_page_fault async_page_fault
 #define trace_divide_error divide_error
 #define trace_bounds bounds
 #define trace_invalid_op invalid_op
@@ -51,7 +53,6 @@ asmlinkage void trace_page_fault(void);
 #define trace_coprocessor_error coprocessor_error
 #define trace_alignment_check alignment_check
 #define trace_simd_coprocessor_error simd_coprocessor_error
-#define trace_async_page_fault async_page_fault
 #endif
 
 dotraplinkage void do_divide_error(struct pt_regs *, long);
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index a2a4f46..26e370a 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1451,7 +1451,17 @@ ENTRY(async_page_fault)
 	jmp error_code
 	CFI_ENDPROC
 END(async_page_fault)
+
+#ifdef CONFIG_TRACING
+ENTRY(trace_async_page_fault)
+	RING0_EC_FRAME
+	ASM_CLAC
+	pushl_cfi $trace_do_async_page_fault
+	jmp error_code
+	CFI_ENDPROC
+END(async_page_fault)
 #endif
+#endif /* CONFIG_KVM_GUEST */
 
 /*
  * End of kprobes section
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 3db806d..e1f8926 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1289,7 +1289,7 @@ errorentry xen_stack_segment do_stack_segment
 errorentry general_protection do_general_protection
 trace_errorentry page_fault do_page_fault
 #ifdef CONFIG_KVM_GUEST
-errorentry async_page_fault do_async_page_fault
+trace_errorentry async_page_fault do_async_page_fault
 #endif
 #ifdef CONFIG_X86_MCE
 paranoidzeroentry machine_check *machine_check_vector(%rip)
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 0331cb3..baef30e 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -252,14 +252,18 @@ u32 kvm_read_and_reset_pf_reason(void)
 }
 EXPORT_SYMBOL_GPL(kvm_read_and_reset_pf_reason);
 
-dotraplinkage void __kprobes
-do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
+enum {
+	KVM_PV_DO_PAGE_FAULT,
+	KVM_PV_HANDLED,
+};
+
+static int kvm_pv_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	enum ctx_state prev_state;
 
 	switch (kvm_read_and_reset_pf_reason()) {
 	default:
-		do_page_fault(regs, error_code);
+		return KVM_PV_DO_PAGE_FAULT;
 		break;
 	case KVM_PV_REASON_PAGE_NOT_PRESENT:
 		/* page is swapped out by the host. */
@@ -275,7 +279,34 @@ do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
 		rcu_irq_exit();
 		break;
 	}
+	return KVM_PV_HANDLED;
+}
+
+dotraplinkage void __kprobes
+do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
+{
+	int ret;
+
+	ret = kvm_pv_page_fault(regs, error_code);
+	if (ret == KVM_PV_HANDLED)
+		return;
+
+	do_page_fault(regs, error_code);
+}
+
+#ifdef CONFIG_TRACING
+dotraplinkage void __kprobes notrace
+trace_do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
+{
+	int ret;
+
+	ret = kvm_pv_page_fault(regs, error_code);
+	if (ret == KVM_PV_HANDLED)
+		return;
+
+	trace_do_page_fault(regs, error_code);
 }
+#endif /* CONFIG_TRACING */
 
 static void __init paravirt_ops_setup(void)
 {
