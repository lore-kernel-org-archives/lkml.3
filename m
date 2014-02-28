Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbaB1C5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 21:57:30 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:54832 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751680AbaB1C52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 21:57:28 -0500
Date: Thu, 27 Feb 2014 21:57:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
Message-ID: <20140227215726.7018c861@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.10.1402272032140.6271@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu>
	<530B841F.5050803@zytor.com>
	<alpine.DEB.2.10.1402241258590.20170@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402241302210.20560@vincent-weaver-1.um.maine.edu>
	<530B90A5.3090302@zytor.com>
	<20140224141329.1cd3bb52@gandalf.local.home>
	<20140224193043.GP6835@laptop.programming.kicks-ass.net>
	<530C12CA.6070308@zytor.com>
	<alpine.DEB.2.10.1402250904400.23234@vincent-weaver-1.um.maine.edu>
	<dde99a03-9f97-4cd9-aeef-cb0dcc62a7dc@email.android.com>
	<20140225094352.73e0e28c@gandalf.local.home>
	<alpine.DEB.2.10.1402251032230.23234@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402261003390.18730@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402271621000.2571@vincent-weaver-1.um.maine.edu>
	<20140227173150.4e5ed747@gandalf.local.home>
	<530FC1C6.5040209@zytor.com>
	<alpine.DEB.2.10.1402272032140.6271@vincent-weaver-1.um.maine.edu>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014 20:34:34 -0500 (EST)
Vince Weaver <vincent.weaver@maine.edu> wrote:


> > I would actually suggest we do the equivalent on i386 as well.
> > 
> > Vince, could you try this patch as an experiment?
> 
> OK with your patch applied it does not segfault.
> 

Vince, Great! Can you remove Peter's patch, and try this one. It
removes the crud to save the cr2 from entry_64.S and makes both i386
and x86_64 do the same thing in regards to cr2 handling.

-- Steve

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1e96c36..937cb8d 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1854,29 +1854,11 @@ end_repeat_nmi:
 	call save_paranoid
 	DEFAULT_FRAME 0
 
-	/*
-	 * Save off the CR2 register. If we take a page fault in the NMI then
-	 * it could corrupt the CR2 value. If the NMI preempts a page fault
-	 * handler before it was able to read the CR2 register, and then the
-	 * NMI itself takes a page fault, the page fault that was preempted
-	 * will read the information from the NMI page fault and not the
-	 * origin fault. Save it off and restore it if it changes.
-	 * Use the r12 callee-saved register.
-	 */
-	movq %cr2, %r12
-
 	/* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */
 	movq %rsp,%rdi
 	movq $-1,%rsi
 	call do_nmi
 
-	/* Did the NMI take a page fault? Restore cr2 if it did */
-	movq %cr2, %rcx
-	cmpq %rcx, %r12
-	je 1f
-	movq %r12, %cr2
-1:
-	
 	testl %ebx,%ebx				/* swapgs needed? */
 	jnz nmi_restore
 nmi_swapgs:
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 6fcb49c..f1a6294 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -443,7 +443,6 @@ enum nmi_states {
 	NMI_LATCHED,
 };
 static DEFINE_PER_CPU(enum nmi_states, nmi_state);
-static DEFINE_PER_CPU(unsigned long, nmi_cr2);
 
 #define nmi_nesting_preprocess(regs)					\
 	do {								\
@@ -452,14 +451,11 @@ static DEFINE_PER_CPU(unsigned long, nmi_cr2);
 			return;						\
 		}							\
 		this_cpu_write(nmi_state, NMI_EXECUTING);		\
-		this_cpu_write(nmi_cr2, read_cr2());			\
 	} while (0);							\
 	nmi_restart:
 
 #define nmi_nesting_postprocess()					\
 	do {								\
-		if (unlikely(this_cpu_read(nmi_cr2) != read_cr2()))	\
-			write_cr2(this_cpu_read(nmi_cr2));		\
 		if (this_cpu_dec_return(nmi_state))			\
 			goto nmi_restart;				\
 	} while (0)
@@ -512,8 +508,21 @@ static inline void nmi_nesting_postprocess(void)
 dotraplinkage notrace __kprobes void
 do_nmi(struct pt_regs *regs, long error_code)
 {
+	unsigned long cr2;
+	
 	nmi_nesting_preprocess(regs);
 
+	/*
+	 * Save off the CR2 register. If we take a page fault in the NMI then
+	 * it could corrupt the CR2 value. If the NMI preempts a page fault
+	 * handler before it was able to read the CR2 register, and then the
+	 * NMI itself takes a page fault, the page fault that was preempted
+	 * will read the information from the NMI page fault and not the
+	 * origin fault. Save it off and restore it if it changes.
+	 * Use the r12 callee-saved register.
+	 */
+	cr2 = read_cr2();
+
 	nmi_enter();
 
 	inc_irq_stat(__nmi_count);
@@ -523,6 +532,10 @@ do_nmi(struct pt_regs *regs, long error_code)
 
 	nmi_exit();
 
+	/* Reads are cheaper than writes */
+	if (unlikely(cr2 != read_cr2()))
+		write_cr2(cr2);
+
 	/* On i386, may loop back to preprocess */
 	nmi_nesting_postprocess();
 }
