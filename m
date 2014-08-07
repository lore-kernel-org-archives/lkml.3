Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbaHGPdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 11:33:08 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:54364 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932134AbaHGPdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 11:33:06 -0400
Date: Thu, 7 Aug 2014 11:33:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 5/5] X86: add IPI tracepoints
Message-ID: <20140807113302.55aee779@gandalf.local.home>
In-Reply-To: <1406318733-26754-6-git-send-email-nicolas.pitre@linaro.org>
References: <1406318733-26754-1-git-send-email-nicolas.pitre@linaro.org>
	<1406318733-26754-6-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

I'm pulling in Nicolas's changes to trace and the arm architectures. He
has this x86 patch. Do you think this would be fine as well? Otherwise,
I'll just add the arm patches, and push that for this merge window
(these patches have been out on the mailing list for some time, with no
changes).

-- Steve


On Fri, 25 Jul 2014 16:05:33 -0400
Nicolas Pitre <nicolas.pitre@linaro.org> wrote:

> On X86 there are already tracepoints for IRQ vectors through which IPIs
> are handled.  However this is highly X86 specific, and the IPI signaling
> is not currently traced.
> 
> This is an attempt at adding generic IPI tracepoints to X86.
> 
> Signed-off-by: Nicolas Pitre <nico@linaro.org>
> ---
>  arch/x86/kernel/smp.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> index be8e1bde07..d193609bea 100644
> --- a/arch/x86/kernel/smp.c
> +++ b/arch/x86/kernel/smp.c
> @@ -31,6 +31,16 @@
>  #include <asm/apic.h>
>  #include <asm/nmi.h>
>  #include <asm/trace/irq_vectors.h>
> +
> +#define CREATE_TRACE_POINTS
> +/*
> + * Those were defined in <asm/trace/irq_vectors.h> and cause problems
> + * when including <trace/events/ipi.h>.
> + */
> +#undef TRACE_INCLUDE_PATH
> +#undef TRACE_INCLUDE_FILE
> +#include <trace/events/ipi.h>
> +
>  /*
>   *	Some notes on x86 processor bugs affecting SMP operation:
>   *
> @@ -124,11 +134,13 @@ static void native_smp_send_reschedule(int cpu)
>  		WARN_ON(1);
>  		return;
>  	}
> +	trace_ipi_raise(cpumask_of(cpu), tracepoint_string("RESCHEDULE"));
>  	apic->send_IPI_mask(cpumask_of(cpu), RESCHEDULE_VECTOR);
>  }
>  
>  void native_send_call_func_single_ipi(int cpu)
>  {
> +	trace_ipi_raise(cpumask_of(cpu), tracepoint_string("CALL_FUNCTION_SINGLE"));
>  	apic->send_IPI_mask(cpumask_of(cpu), CALL_FUNCTION_SINGLE_VECTOR);
>  }
>  
> @@ -136,6 +148,8 @@ void native_send_call_func_ipi(const struct cpumask *mask)
>  {
>  	cpumask_var_t allbutself;
>  
> +	trace_ipi_raise(mask, tracepoint_string("CALL_FUNCTION"));
> +
>  	if (!alloc_cpumask_var(&allbutself, GFP_ATOMIC)) {
>  		apic->send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
>  		return;
> @@ -252,8 +266,10 @@ finish:
>   */
>  static inline void __smp_reschedule_interrupt(void)
>  {
> +	trace_ipi_entry(tracepoint_string("RESCHEDULE"));
>  	inc_irq_stat(irq_resched_count);
>  	scheduler_ipi();
> +	trace_ipi_exit(tracepoint_string("RESCHEDULE"));
>  }
>  
>  __visible void smp_reschedule_interrupt(struct pt_regs *regs)
> @@ -291,8 +307,10 @@ __visible void smp_trace_reschedule_interrupt(struct pt_regs *regs)
>  
>  static inline void __smp_call_function_interrupt(void)
>  {
> +	trace_ipi_entry(tracepoint_string("CALL_FUNCTION"));
>  	generic_smp_call_function_interrupt();
>  	inc_irq_stat(irq_call_count);
> +	trace_ipi_exit(tracepoint_string("CALL_FUNCTION"));
>  }
>  
>  __visible void smp_call_function_interrupt(struct pt_regs *regs)
> @@ -313,8 +331,10 @@ __visible void smp_trace_call_function_interrupt(struct pt_regs *regs)
>  
>  static inline void __smp_call_function_single_interrupt(void)
>  {
> +	trace_ipi_entry(tracepoint_string("CALL_FUNCTION_SINGLE"));
>  	generic_smp_call_function_single_interrupt();
>  	inc_irq_stat(irq_call_count);
> +	trace_ipi_exit(tracepoint_string("CALL_FUNCTION_SINGLE"));
>  }
>  
>  __visible void smp_call_function_single_interrupt(struct pt_regs *regs)

