Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbaHFTwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:52:40 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:32990 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753502AbaHFTwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:52:39 -0400
Date: Wed, 6 Aug 2014 15:52:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 4/5] ARM64: add IPI tracepoints
Message-ID: <20140806155237.0a6d7d3c@gandalf.local.home>
In-Reply-To: <1406318733-26754-5-git-send-email-nicolas.pitre@linaro.org>
References: <1406318733-26754-1-git-send-email-nicolas.pitre@linaro.org>
	<1406318733-26754-5-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will and Russell,

Can you give me your Acked-by for this, and I can pull it through my
tree?

Thanks,

-- Steve


On Fri, 25 Jul 2014 16:05:32 -0400
Nicolas Pitre <nicolas.pitre@linaro.org> wrote:

> The strings used to list IPIs in /proc/interrupts are reused for tracing
> purposes.
> 
> While at it, the code is slightly cleaned up so the ipi_types array
> indices are no longer offset by IPI_RESCHEDULE whose value is 0 anyway.
> 
> Signed-off-by: Nicolas Pitre <nico@linaro.org>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm64/kernel/smp.c | 65 +++++++++++++++++++++++++++++--------------------
>  1 file changed, 39 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> index 40f38f46c8..a89c66f3b4 100644
> --- a/arch/arm64/kernel/smp.c
> +++ b/arch/arm64/kernel/smp.c
> @@ -50,6 +50,9 @@
>  #include <asm/tlbflush.h>
>  #include <asm/ptrace.h>
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/ipi.h>
> +
>  /*
>   * as from 2.5, kernels no longer have an init_tasks structure
>   * so we need some other way of telling a new secondary core
> @@ -307,8 +310,6 @@ void __init smp_prepare_boot_cpu(void)
>  	set_my_cpu_offset(per_cpu_offset(smp_processor_id()));
>  }
>  
> -static void (*smp_cross_call)(const struct cpumask *, unsigned int);
> -
>  /*
>   * Enumerate the possible CPU set from the device tree and build the
>   * cpu logical map array containing MPIDR values related to logical
> @@ -463,32 +464,15 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
>  	}
>  }
>  
> +static void (*__smp_cross_call)(const struct cpumask *, unsigned int);
>  
>  void __init set_smp_cross_call(void (*fn)(const struct cpumask *, unsigned int))
>  {
> -	smp_cross_call = fn;
> +	__smp_cross_call = fn;
>  }
>  
> -void arch_send_call_function_ipi_mask(const struct cpumask *mask)
> -{
> -	smp_cross_call(mask, IPI_CALL_FUNC);
> -}
> -
> -void arch_send_call_function_single_ipi(int cpu)
> -{
> -	smp_cross_call(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
> -}
> -
> -#ifdef CONFIG_IRQ_WORK
> -void arch_irq_work_raise(void)
> -{
> -	if (smp_cross_call)
> -		smp_cross_call(cpumask_of(smp_processor_id()), IPI_IRQ_WORK);
> -}
> -#endif
> -
> -static const char *ipi_types[NR_IPI] = {
> -#define S(x,s)	[x - IPI_RESCHEDULE] = s
> +static const char *ipi_types[NR_IPI] __tracepoint_string = {
> +#define S(x,s)	[x] = s
>  	S(IPI_RESCHEDULE, "Rescheduling interrupts"),
>  	S(IPI_CALL_FUNC, "Function call interrupts"),
>  	S(IPI_CALL_FUNC_SINGLE, "Single function call interrupts"),
> @@ -497,12 +481,18 @@ static const char *ipi_types[NR_IPI] = {
>  	S(IPI_IRQ_WORK, "IRQ work interrupts"),
>  };
>  
> +static void smp_cross_call(const struct cpumask *target, unsigned int ipinr)
> +{
> +	trace_ipi_raise(target, ipi_types[ipinr]);
> +	__smp_cross_call(target, ipinr);
> +}
> +
>  void show_ipi_list(struct seq_file *p, int prec)
>  {
>  	unsigned int cpu, i;
>  
>  	for (i = 0; i < NR_IPI; i++) {
> -		seq_printf(p, "%*s%u:%s", prec - 1, "IPI", i + IPI_RESCHEDULE,
> +		seq_printf(p, "%*s%u:%s", prec - 1, "IPI", i,
>  			   prec >= 4 ? " " : "");
>  		for_each_online_cpu(cpu)
>  			seq_printf(p, "%10u ",
> @@ -522,6 +512,24 @@ u64 smp_irq_stat_cpu(unsigned int cpu)
>  	return sum;
>  }
>  
> +void arch_send_call_function_ipi_mask(const struct cpumask *mask)
> +{
> +	smp_cross_call(mask, IPI_CALL_FUNC);
> +}
> +
> +void arch_send_call_function_single_ipi(int cpu)
> +{
> +	smp_cross_call(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
> +}
> +
> +#ifdef CONFIG_IRQ_WORK
> +void arch_irq_work_raise(void)
> +{
> +	if (__smp_cross_call)
> +		smp_cross_call(cpumask_of(smp_processor_id()), IPI_IRQ_WORK);
> +}
> +#endif
> +
>  static DEFINE_RAW_SPINLOCK(stop_lock);
>  
>  /*
> @@ -553,8 +561,10 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
>  	unsigned int cpu = smp_processor_id();
>  	struct pt_regs *old_regs = set_irq_regs(regs);
>  
> -	if (ipinr >= IPI_RESCHEDULE && ipinr < IPI_RESCHEDULE + NR_IPI)
> -		__inc_irq_stat(cpu, ipi_irqs[ipinr - IPI_RESCHEDULE]);
> +	if ((unsigned)ipinr < NR_IPI) {
> +		trace_ipi_entry(ipi_types[ipinr]);
> +		__inc_irq_stat(cpu, ipi_irqs[ipinr]);
> +	}
>  
>  	switch (ipinr) {
>  	case IPI_RESCHEDULE:
> @@ -599,6 +609,9 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
>  		pr_crit("CPU%u: Unknown IPI message 0x%x\n", cpu, ipinr);
>  		break;
>  	}
> +
> +	if ((unsigned)ipinr < NR_IPI)
> +		trace_ipi_exit(ipi_types[ipinr]);
>  	set_irq_regs(old_regs);
>  }
>  

