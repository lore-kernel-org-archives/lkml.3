Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320Ab3FCTpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 15:45:18 -0400
Received: from usindpps04.hds.com ([207.126.252.17]:44308 "EHLO
	usindpps04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332Ab3FCTpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 15:45:15 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>
Subject: RE: [PATCH (v2 - fixup)] x86: Have debug/nmi restore the IDT it
 replaced
Thread-Topic: [PATCH (v2 - fixup)] x86: Have debug/nmi restore the IDT it
 replaced
Thread-Index: AQHOW6fIQUxlKcK70kqDHOqs65bt0JkkbIew
Date: Mon, 3 Jun 2013 19:44:44 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41B00EA43@USINDEM103.corp.hds.com>
References: <1369360404.6828.219.camel@gandalf.local.home>
	 <20130528075441.GA28601@gmail.com>
 <1369747939.15552.11.camel@gandalf.local.home>
In-Reply-To: <1369747939.15552.11.camel@gandalf.local.home>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-06-03_05:2013-06-03,2013-06-03,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 ipscore=0
 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1306030171
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r53JjTZ3010212

Steven,

I think we can solve this problem simply by checking "current IDT"
rather than using a  holding/restoring way.

Please see a patch set below.
	[PATCH v13 0/3]trace,x86: irq vector tracepoint support
	[PATCH v13 1/3] tracing: Add DEFINE_EVENT_FN() macro
	[PATCH v13 2/3] trace,x86: Introduce entering/exiting_irq()
	[PATCH v13 3/3] trace,x86: Add irq vector tracepoints

Seiji

> -----Original Message-----
> From: Steven Rostedt [mailto:rostedt@goodmis.org]
> Sent: Tuesday, May 28, 2013 9:32 AM
> To: Ingo Molnar
> Cc: H. Peter Anvin; LKML; Thomas Gleixner; Frederic Weisbecker; Andrew Morton; Seiji Aguchi; Borislav Petkov (bp@alien8.de)
> Subject: [PATCH (v2 - fixup)] x86: Have debug/nmi restore the IDT it replaced
> 
> I've been playing with Seiji's patches:
> 
> https://lkml.org/lkml/2013/1/21/573
> 
> Which add tracing to the x86 interrupt vectors. But to keep tracing
> overhead down to zero when tracing is inactive, it uses a swap of the
> IDT to replace the irq vectors with versions that have tracepoints in
> them, when tracing is enabled. Even though tracepoints have "nops", we
> do this to keep even that overhead eliminated.
> 
> These seemed to work, until I ran the following command with trace-cmd:
> 
>  trace-cmd start -p function_graph -g "smp_trace_apic_timer_interrupt" \
>    -g "smp_apic_timer_interrupt" -e irq_vectors
> 
> What trace-cmd does above, is not only enables the irq_vectors, but also
> produces the call graphs of the two interrupt vector functions:
> smp_trace_apic_timer_interrupt and smp_apic_timer_interrupt
> 
> The result was rather surprising. It showed only
> smp_apic_timer_interrupt being called, and not the trace version.
> Obviously, the tracepoints for the vectors were also not there.
> 
> When starting without the function graph tracer, it worked fine, but I
> wanted to see the trace versions being called to be sure, which required
> one of the function tracers.
> 
> Investigating, I found the problem. It's with the NMI and breakpoint IDT
> handling. I wont explain it too much here, but see:
> 
> commit f8988175f "x86: Allow nesting of the debug stack IDT setting"
> commit 42181186a "x86: Add counter when debug stack is used with
> interrupts enabled"
> commit 228bdaa95 "x86: Keep current stack in NMI breakpoints"
> 
> The basic gist of the above commits is that on NMI or DEBUG trap
> entering, it needs to modify the IDT so that the stack pointer doesn't
> get reset to the top of the stack again. On boot up, two IDT tables are
> created. One for normal operations and one for this NMI/DEBUG case.
> 
> The issue is that it just toggles between the two IDT tables. But if
> this happens when Seiji's swap had already happened, it replaces the
> trace IDT table back to the normal table, and tracing stops, which sorta
> defeats the purpose.
> 
> To solve this, I've added a 'hold_idt_descr' per cpu variable that
> stores the IDT that was loaded and will use that to replace it. If the
> DEBUG/NMI came in when the IDT was normal, it would replace it back with
> the normal IDT, and if it came in when it was the trace IDT, it would
> put back the trace IDT.
> 
> I've run a few tests so far on this code, but I need to run more
> stressful ones. Meanwhile, until I find any bugs, I'm posting this patch
> for your enjoyment. I think I got all the cases, as NMIs causes the
> store/restore functions to be re-entrent without any locks.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/x86/kernel/cpu/common.c |   79 ++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 77 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 22018f7..1315367 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1149,10 +1149,54 @@ int is_debug_stack(unsigned long addr)
>  }
> 
>  static DEFINE_PER_CPU(u32, debug_stack_use_ctr);
> +static DEFINE_PER_CPU(struct desc_ptr, hold_idt_descr);
> +static DEFINE_PER_CPU(struct desc_ptr, copy_idt_descr);
> 
> +/*
> + * Debug traps and NMIs will swap the IDT to have the debug
> + * trap not modify the stack (nmi_idt_descr). But as both the
> + * debug and NMIs share this, they need to be re-entrant. A debug
> + * trap could be doing the swap and after it incs the debug_stack_use_ctr,
> + * an NMI could come in. It too would need to do the swap, and it would
> + * need to swap every time.
> + *
> + * But, the IDT can be changed by other users, and this must restore
> + * that as well.
> + *
> + * Luckily, as interrupts are disabled from the set_zero to reset,
> + * we do not need to worry about the IDT changing underneath us
> + * from other users.
> + */
>  void debug_stack_set_zero(void)
>  {
> +       /*
> +        * Writing to the IDT is atomic. If an NMI were to come
> +        * in after we did the compare but before the store_idt(),
> +        * it too would see the address == 0 and do the store itself.
> +        */
> +       if (this_cpu_read(hold_idt_descr.address) == 0)
> +               store_idt(this_cpu_ptr(&hold_idt_descr));
> +
> +       /*
> +        * If an NMI were to come in now, it would not set hold_idt_descr,
> +        * but on exit, it would restore the IDT because the counter is
> +        * still zero here. Then it would set the .address back to zero too.
> +        */
> +
>  	this_cpu_inc(debug_stack_use_ctr);
> +
> +       /*
> +        * NMI's coming in now are not an issue as we set the .address
> +        * and also incremented the ctr. But, if an NMI came in before
> +        * the counter was incremented, and after the .address was set,
> +        * the NMI would set the .address back to zero, and would have
> +        * restored the IDT. We need to check if that happened.
> +        * If it did, then the .address would be zero here again.
> +        */
> +       if (unlikely(this_cpu_read(hold_idt_descr.address) == 0))
> +               store_idt(this_cpu_ptr(&hold_idt_descr));
> +
> +       /* On enter, we always want to use the nmi_idt_descr */
>  	load_idt((const struct desc_ptr *)&nmi_idt_descr);
>  }
> 
> @@ -1160,8 +1204,39 @@ void debug_stack_reset(void)
>  {
>  	if (WARN_ON(!this_cpu_read(debug_stack_use_ctr)))
>  		return;
> -	if (this_cpu_dec_return(debug_stack_use_ctr) == 0)
> -		load_idt((const struct desc_ptr *)&idt_descr);
> +
> +       if (WARN_ON(!this_cpu_read(hold_idt_descr.address)))
> +               return;
> +
> +       /*
> +        * This is the tricky part. We need to restore the old
> +        * IDT to what it was before we entered, but an NMI could
> +        * come in at any point, and do the same.
> +        *
> +        * If the count is 1, then we are the first to enter and
> +        * we need to update the IDT. But, we must do that after
> +        * we decrement the counter, in which case, if an NMI
> +        * comes in, it too will see the 1. To get around this,
> +        * we update a copy first.
> +        *
> +        * The copy will always contain what we want to load the
> +        * IDT with.
> +        */
> +       if (this_cpu_read(debug_stack_use_ctr) == 1)
> +               *this_cpu_ptr(&copy_idt_descr) = *this_cpu_ptr(&hold_idt_descr);
> +
> +       if (this_cpu_dec_return(debug_stack_use_ctr) == 0) {
> +               /*
> +                * We use the copy to save to the IDT, as it will always contain
> +                * what we want to restore the IDT to.
> +                */
> +               load_idt(this_cpu_ptr(&copy_idt_descr));
> +               /*
> +                * Now clear out the hold_idt_descr.address, to let all new
> +                * users restore it from the IDT.
> +                */
> +               this_cpu_write(hold_idt_descr.address, 0);
> +       }
>  }
> 
>  #else	/* CONFIG_X86_64 */
> --
> 1.7.3.4
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
