Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199Ab3E1NcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:32:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17263 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934122Ab3E1NcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:32:21 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=bLkinOa9NZ4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=4Zhf73zsdbkA:10 a=D19gQVrFAAAA:8 a=plUYDTvtbJFg72TbnIAA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=i2hVZ_z1VCTEQS-_:21 a=52DE2KEiUtzvdxxR:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369747939.15552.11.camel@gandalf.local.home>
Subject: [PATCH (v2 - fixup)] x86: Have debug/nmi restore the IDT it replaced
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>
Date: Tue, 28 May 2013 09:32:19 -0400
In-Reply-To: <20130528075441.GA28601@gmail.com>
References: <1369360404.6828.219.camel@gandalf.local.home>
	 <20130528075441.GA28601@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been playing with Seiji's patches:

https://lkml.org/lkml/2013/1/21/573

Which add tracing to the x86 interrupt vectors. But to keep tracing
overhead down to zero when tracing is inactive, it uses a swap of the
IDT to replace the irq vectors with versions that have tracepoints in
them, when tracing is enabled. Even though tracepoints have "nops", we
do this to keep even that overhead eliminated.

These seemed to work, until I ran the following command with trace-cmd:

 trace-cmd start -p function_graph -g "smp_trace_apic_timer_interrupt" \
   -g "smp_apic_timer_interrupt" -e irq_vectors

What trace-cmd does above, is not only enables the irq_vectors, but also
produces the call graphs of the two interrupt vector functions:
smp_trace_apic_timer_interrupt and smp_apic_timer_interrupt

The result was rather surprising. It showed only
smp_apic_timer_interrupt being called, and not the trace version.
Obviously, the tracepoints for the vectors were also not there.

When starting without the function graph tracer, it worked fine, but I
wanted to see the trace versions being called to be sure, which required
one of the function tracers.

Investigating, I found the problem. It's with the NMI and breakpoint IDT
handling. I wont explain it too much here, but see:

commit f8988175f "x86: Allow nesting of the debug stack IDT setting"
commit 42181186a "x86: Add counter when debug stack is used with
interrupts enabled"
commit 228bdaa95 "x86: Keep current stack in NMI breakpoints"

The basic gist of the above commits is that on NMI or DEBUG trap
entering, it needs to modify the IDT so that the stack pointer doesn't
get reset to the top of the stack again. On boot up, two IDT tables are
created. One for normal operations and one for this NMI/DEBUG case.

The issue is that it just toggles between the two IDT tables. But if
this happens when Seiji's swap had already happened, it replaces the
trace IDT table back to the normal table, and tracing stops, which sorta
defeats the purpose.

To solve this, I've added a 'hold_idt_descr' per cpu variable that
stores the IDT that was loaded and will use that to replace it. If the
DEBUG/NMI came in when the IDT was normal, it would replace it back with
the normal IDT, and if it came in when it was the trace IDT, it would
put back the trace IDT.

I've run a few tests so far on this code, but I need to run more
stressful ones. Meanwhile, until I find any bugs, I'm posting this patch
for your enjoyment. I think I got all the cases, as NMIs causes the
store/restore functions to be re-entrent without any locks.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/cpu/common.c |   79 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 22018f7..1315367 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1149,10 +1149,54 @@ int is_debug_stack(unsigned long addr)
 }
 
 static DEFINE_PER_CPU(u32, debug_stack_use_ctr);
+static DEFINE_PER_CPU(struct desc_ptr, hold_idt_descr);
+static DEFINE_PER_CPU(struct desc_ptr, copy_idt_descr);
 
+/*
+ * Debug traps and NMIs will swap the IDT to have the debug
+ * trap not modify the stack (nmi_idt_descr). But as both the
+ * debug and NMIs share this, they need to be re-entrant. A debug
+ * trap could be doing the swap and after it incs the debug_stack_use_ctr,
+ * an NMI could come in. It too would need to do the swap, and it would
+ * need to swap every time.
+ *
+ * But, the IDT can be changed by other users, and this must restore
+ * that as well.
+ *
+ * Luckily, as interrupts are disabled from the set_zero to reset,
+ * we do not need to worry about the IDT changing underneath us
+ * from other users.
+ */
 void debug_stack_set_zero(void)
 {
+       /*
+        * Writing to the IDT is atomic. If an NMI were to come
+        * in after we did the compare but before the store_idt(),
+        * it too would see the address == 0 and do the store itself.
+        */
+       if (this_cpu_read(hold_idt_descr.address) == 0)
+               store_idt(this_cpu_ptr(&hold_idt_descr));
+
+       /*
+        * If an NMI were to come in now, it would not set hold_idt_descr,
+        * but on exit, it would restore the IDT because the counter is
+        * still zero here. Then it would set the .address back to zero too.
+        */
+
 	this_cpu_inc(debug_stack_use_ctr);
+
+       /*
+        * NMI's coming in now are not an issue as we set the .address
+        * and also incremented the ctr. But, if an NMI came in before
+        * the counter was incremented, and after the .address was set,
+        * the NMI would set the .address back to zero, and would have
+        * restored the IDT. We need to check if that happened.
+        * If it did, then the .address would be zero here again.
+        */
+       if (unlikely(this_cpu_read(hold_idt_descr.address) == 0))
+               store_idt(this_cpu_ptr(&hold_idt_descr));
+
+       /* On enter, we always want to use the nmi_idt_descr */
 	load_idt((const struct desc_ptr *)&nmi_idt_descr);
 }
 
@@ -1160,8 +1204,39 @@ void debug_stack_reset(void)
 {
 	if (WARN_ON(!this_cpu_read(debug_stack_use_ctr)))
 		return;
-	if (this_cpu_dec_return(debug_stack_use_ctr) == 0)
-		load_idt((const struct desc_ptr *)&idt_descr);
+
+       if (WARN_ON(!this_cpu_read(hold_idt_descr.address)))
+               return;
+
+       /*
+        * This is the tricky part. We need to restore the old
+        * IDT to what it was before we entered, but an NMI could
+        * come in at any point, and do the same.
+        *
+        * If the count is 1, then we are the first to enter and
+        * we need to update the IDT. But, we must do that after
+        * we decrement the counter, in which case, if an NMI
+        * comes in, it too will see the 1. To get around this,
+        * we update a copy first.
+        *
+        * The copy will always contain what we want to load the
+        * IDT with.
+        */
+       if (this_cpu_read(debug_stack_use_ctr) == 1)
+               *this_cpu_ptr(&copy_idt_descr) = *this_cpu_ptr(&hold_idt_descr);
+
+       if (this_cpu_dec_return(debug_stack_use_ctr) == 0) {
+               /*
+                * We use the copy to save to the IDT, as it will always contain
+                * what we want to restore the IDT to.
+                */
+               load_idt(this_cpu_ptr(&copy_idt_descr));
+               /*
+                * Now clear out the hold_idt_descr.address, to let all new
+                * users restore it from the IDT.
+                */
+               this_cpu_write(hold_idt_descr.address, 0);
+       }
 }
 
 #else	/* CONFIG_X86_64 */
-- 
1.7.3.4



