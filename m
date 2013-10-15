Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab3JOG0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 02:26:21 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:62204 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab3JOG0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 02:26:19 -0400
Message-ID: <525CE007.6070101@linaro.org>
Date: Tue, 15 Oct 2013 08:26:15 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, shaojie.sun@linaro.org
Subject: Re: [PATCH] ARM: trace: Add tracepoint for the Inter Processor Interrupt
References: <1381758807-31139-1-git-send-email-daniel.lezcano@linaro.org> <20131014232004.5cbedbb8@gandalf.local.home>
In-Reply-To: <20131014232004.5cbedbb8@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 05:20 AM, Steven Rostedt wrote:
> On Mon, 14 Oct 2013 15:53:27 +0200
> Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>
>> The Inter Processor Interrupt is used on ARM to tell another processor to do
>> a specific action. This is mainly used to emulate a timer interrupt on an idle
>> cpu, force a cpu to reschedule or run a function on another processor context.
>>
>> Add a tracepoint when raising an IPI and in the entry/exit handler function.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>> ---
>>   arch/arm/include/asm/smp.h   |    9 ++++
>>   arch/arm/kernel/smp.c        |   34 ++++++++------
>>   arch/arm64/include/asm/smp.h |    7 +++
>>   arch/arm64/kernel/smp.c      |   21 +++++++--
>>   include/trace/events/ipi.h   |  106 ++++++++++++++++++++++++++++++++++++++++++
>>   5 files changed, 158 insertions(+), 19 deletions(-)
>>   create mode 100644 include/trace/events/ipi.h
>>
>> diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
>> index a8cae71c..788706c 100644
>> --- a/arch/arm/include/asm/smp.h
>> +++ b/arch/arm/include/asm/smp.h
>> @@ -18,6 +18,15 @@
>>   # error "<asm/smp.h> included in non-SMP build"
>>   #endif
>>
>> +enum ipi_msg_type {
>> +	IPI_WAKEUP,
>> +	IPI_TIMER,
>> +	IPI_RESCHEDULE,
>> +	IPI_CALL_FUNC,
>> +	IPI_CALL_FUNC_SINGLE,
>> +	IPI_CPU_STOP,
>> +};
>> +
>>   #define raw_smp_processor_id() (current_thread_info()->cpu)
>>
>>   struct seq_file;
>> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
>> index 72024ea..9ca8ce8 100644
>> --- a/arch/arm/kernel/smp.c
>> +++ b/arch/arm/kernel/smp.c
>> @@ -46,6 +46,9 @@
>>   #include <asm/mach/arch.h>
>>   #include <asm/mpu.h>
>>
>> +#define CREATE_TRACE_POINTS
>> +#include <trace/events/ipi.h>
>> +
>>   /*
>>    * as from 2.5, kernels no longer have an init_tasks structure
>>    * so we need some other way of telling a new secondary core
>> @@ -59,15 +62,6 @@ struct secondary_data secondary_data;
>>    */
>>   volatile int pen_release = -1;
>>
>> -enum ipi_msg_type {
>> -	IPI_WAKEUP,
>> -	IPI_TIMER,
>> -	IPI_RESCHEDULE,
>> -	IPI_CALL_FUNC,
>> -	IPI_CALL_FUNC_SINGLE,
>> -	IPI_CPU_STOP,
>> -};
>> -
>>   static DECLARE_COMPLETION(cpu_running);
>>
>>   static struct smp_operations smp_ops;
>> @@ -433,19 +427,25 @@ void __init set_smp_cross_call(void (*fn)(const struct cpumask *, unsigned int))
>>   		smp_cross_call = fn;
>>   }
>>
>> +static void ipi_raise(const struct cpumask *mask, int ipinr)
>> +{
>> +	trace_ipi_raise(mask, ipinr);
>> +	smp_cross_call(mask, ipinr);
>> +}
>> +
>>   void arch_send_call_function_ipi_mask(const struct cpumask *mask)
>>   {
>> -	smp_cross_call(mask, IPI_CALL_FUNC);
>> +	ipi_raise(mask, IPI_CALL_FUNC);
>>   }
>>
>>   void arch_send_wakeup_ipi_mask(const struct cpumask *mask)
>>   {
>> -	smp_cross_call(mask, IPI_WAKEUP);
>> +	ipi_raise(mask, IPI_WAKEUP);
>>   }
>>
>>   void arch_send_call_function_single_ipi(int cpu)
>>   {
>> -	smp_cross_call(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
>> +	ipi_raise(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
>>   }
>>
>>   static const char *ipi_types[NR_IPI] = {
>> @@ -487,7 +487,7 @@ u64 smp_irq_stat_cpu(unsigned int cpu)
>>   #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
>>   void tick_broadcast(const struct cpumask *mask)
>>   {
>> -	smp_cross_call(mask, IPI_TIMER);
>> +	ipi_raise(mask, IPI_TIMER);
>>   }
>>   #endif
>>
>> @@ -528,6 +528,8 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
>>   	unsigned int cpu = smp_processor_id();
>>   	struct pt_regs *old_regs = set_irq_regs(regs);
>>
>> +	trace_ipi_handler_entry(ipinr);
>> +
>>   	if (ipinr < NR_IPI)
>>   		__inc_irq_stat(cpu, ipi_irqs[ipinr]);
>>
>> @@ -571,11 +573,13 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
>>   		break;
>>   	}
>>   	set_irq_regs(old_regs);
>> +
>> +	trace_ipi_handler_exit(ipinr);
>>   }
>>
>>   void smp_send_reschedule(int cpu)
>>   {
>> -	smp_cross_call(cpumask_of(cpu), IPI_RESCHEDULE);
>> +	ipi_raise(cpumask_of(cpu), IPI_RESCHEDULE);
>>   }
>>
>>   void smp_send_stop(void)
>> @@ -586,7 +590,7 @@ void smp_send_stop(void)
>>   	cpumask_copy(&mask, cpu_online_mask);
>>   	cpumask_clear_cpu(smp_processor_id(), &mask);
>>   	if (!cpumask_empty(&mask))
>> -		smp_cross_call(&mask, IPI_CPU_STOP);
>> +		ipi_raise(&mask, IPI_CPU_STOP);
>>
>>   	/* Wait up to one second for other CPUs to stop */
>>   	timeout = USEC_PER_SEC;
>> diff --git a/arch/arm64/include/asm/smp.h b/arch/arm64/include/asm/smp.h
>> index 4b8023c..7ebaa3a 100644
>> --- a/arch/arm64/include/asm/smp.h
>> +++ b/arch/arm64/include/asm/smp.h
>> @@ -24,6 +24,13 @@
>>   # error "<asm/smp.h> included in non-SMP build"
>>   #endif
>>
>> +enum ipi_msg_type {
>> +	IPI_RESCHEDULE,
>> +	IPI_CALL_FUNC,
>> +	IPI_CALL_FUNC_SINGLE,
>> +	IPI_CPU_STOP,
>> +};
>> +
>>   #define raw_smp_processor_id() (current_thread_info()->cpu)
>>
>>   struct seq_file;

[ ... ]

>> diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
>> +/**
>> + * ipi_handle_entry - called right before the IPI handler
>> + * @ipinr: the IPI number
>> + *
>> + * The @ipinr value must be valid and the action name associated with
>> + * the IPI value is given in the trace.
>> + */
>> +TRACE_EVENT_CONDITION(ipi_handler_entry,
>> +
>> +    TP_PROTO(int ipinr),
>> +
>> +    TP_ARGS(ipinr),
>> +
>> +    TP_CONDITION(ipinr < NR_IPI && ipinr >= 0),
>> +
>> +    TP_STRUCT__entry(
>> +        __field(unsigned int, ipinr)
>> +    ),
>> +
>> +    TP_fast_assign(
>> +        __entry->ipinr = ipinr;
>> +    ),
>> +
>> +    TP_printk("ipi=%d, name=%s", __entry->ipinr,
>> +	      show_ipi_name(__entry->ipinr))
>> +);
>> +
>> +/**
>> + * ipi_handle_exit - called right after the IPI handler
>> + * @ipinr: the IPI number
>> + *
>> + * The @ipinr value must be valid and the action name associated with
>> + * the IPI value is given in the trace.
>> + */
>> +TRACE_EVENT_CONDITION(ipi_handler_exit,
>> +
>> +    TP_PROTO(int ipinr),
>> +
>> +    TP_ARGS(ipinr),
>> +
>> +    TP_CONDITION(ipinr < NR_IPI && ipinr >= 0),
>> +
>> +    TP_STRUCT__entry(
>> +        __field(int, ipinr)
>
> Here you have "int" and above for the "*_entry" you have unsigned int.
> Is there a difference?

No, actually it is a typo.

> If not, you should combine these two into a DECLARE_EVENT_CLASS() and
> then use DEFINE_EVENT_CONDITION() for the two tracepoints.

Ok.

>> +    ),
>> +
>> +    TP_fast_assign(
>> +        __entry->ipinr = ipinr;
>> +    ),
>> +
>> +    TP_printk("ipi=%d, name=%s", __entry->ipinr,
>> +	      show_ipi_name(__entry->ipinr))
>> +);
>> +
>> +/**
>> + * ipi_raise - called when a smp cross call is made
>> + * @ipinr: the IPI number
>> + * @cpumask: the recipients for the IPI
>> + *
>> + * The @ipinr value must be valid and the action name associated with
>> + * the IPI value is given in the trace.
>> + */
>> +TRACE_EVENT_CONDITION(ipi_raise,
>> +
>> +    TP_PROTO(const struct cpumask *cpumask, int ipinr),
>> +
>> +    TP_ARGS(cpumask, ipinr),
>
> Why pass in the cpumask if it isn't used? Do you expect to hook
> something else to the tracepoint?

Mmh, I have a doubt here about the trace. I can remove the cpumask 
because it is not used but in the other hand, it would be interesting to 
have in the trace the cpumask of the recipient cpus for the IPI. 
Unfortunately, I don't know how to convert this cpumask to a string 
without using the cpumask_scnprintf which imply a more complex print trace.

Do you have some advices for that ?

Thanks for the review.

   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

