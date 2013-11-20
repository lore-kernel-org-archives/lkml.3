Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab3KTVeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 16:34:16 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:49039 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab3KTVeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 16:34:13 -0500
Message-ID: <528D2AD7.8060104@linaro.org>
Date: Wed, 20 Nov 2013 22:34:15 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Dave Martin <Dave.Martin@arm.com>
CC: rostedt@goodmis.org, linaro-kernel@lists.linaro.org,
        shaojie.sun@linaro.org, patches@linaro.org, fweisbec@gmail.com,
        broonie@linaro.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3] ARM: trace: Add tracepoint for the Inter Processor
 Interrupt
References: <1383814887-15415-1-git-send-email-daniel.lezcano@linaro.org> <528B710E.2050505@linaro.org> <20131120175233.GB2582@e103592.cambridge.arm.com>
In-Reply-To: <20131120175233.GB2582@e103592.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 06:52 PM, Dave Martin wrote:
> On Tue, Nov 19, 2013 at 03:09:18PM +0100, Daniel Lezcano wrote:
>> On 11/07/2013 10:01 AM, Daniel Lezcano wrote:
>>> The Inter Processor Interrupt is used on ARM to tell another processor to do
>>> a specific action. This is mainly used to emulate a timer interrupt on an idle
>>> cpu, force a cpu to reschedule or run a function on another processor context.
>>>
>>> Add a tracepoint when raising an IPI and in the entry/exit handler functions.
>>>
>>> When a cpu raises an IPI, the targeted cpus is an interesting information, the
>>> cpumask conversion in hexa is added in the trace using the cpumask_scnprintf
>>> function.
>>>
>>> Tested-on Vexpress TC2 (5 processors).
>>> Tested-on u8500 (2 processors).
>>>
>>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>>
>> Hi guys,
>>
>> did you have time to look at this patch ?
>
> I just spotted this recently.
>
> It seems a potentially useful idea, and seems to work (on ARM Vexpress/
> TC2 anyway, which is what I have in front of me right now).
>
>> We are writing a tool [1] to do some statistics about the cpu's idle
>> times and giving the source of the wakeup. We hope it could be
>> useful for the community to do some measurements but we need the IPI
>> tracepoints to be more accurate.
>
> It's not obvious to me what already exists.  Are the new tracepoints
> giving genuinely more information?  Or otherwise, how/why is the
> information "more accurate" than what was available previously?

The tool gives several informations for each idle state:
  * number of hits
  * min, max, avg, total duration
  * source of wakeups
	* name / number
	* number of times it occured

Plus an additional information for the cluster idle time based on the 
topology. This information is deduced from the computation of the 
intersection of the idle duration for each core belonging to the cluster.

Without this patchset, the source of the wake up for all IPI is ignored 
because there is no trace for such events, so we can only catch hardware 
interrupt.

With the patchset, we can give more information about the source of the 
wake up. For example, it can help to spot the IPI timer interrupts, 
giving a clue about we are waking up a core to wake up another core, or 
we can check the rescheduling IPI number, etc ...

The main purpose of the tool is to diagnose the idle behavior of the 
system and track what, in proportion, did wake up the system. It is 
kindof powertop tool but focused only on the idle behavior.

>>
>> Thanks in advance
>>    -- Daniel
>>
>> [1] https://git.linaro.org/gitweb?p=tools/idlestat.git;a=summary
>>
>>> ---
>>>   arch/arm/include/asm/smp.h   |    9 ++++
>>>   arch/arm/kernel/smp.c        |   34 +++++++------
>>>   arch/arm64/include/asm/smp.h |    7 +++
>>>   arch/arm64/kernel/smp.c      |   21 ++++++--
>
> Is there any reason for this to be specific to ARM?
>
> Not all arches have that ipi_msg_type enum, so it would be worth
> thinking about what is common and how to make it more generic.
>
> Wiring up the tracepoint for other arches could be left to other
> people, but it's a good idea to have a framework that they can
> fit into.

Ok.

>>>   include/trace/events/ipi.h   |  112 ++++++++++++++++++++++++++++++++++++++++++
>>>   5 files changed, 164 insertions(+), 19 deletions(-)
>>>   create mode 100644 include/trace/events/ipi.h
>>>
>>> diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
>>> index a8cae71c..788706c 100644
>>> --- a/arch/arm/include/asm/smp.h
>>> +++ b/arch/arm/include/asm/smp.h
>>> @@ -18,6 +18,15 @@
>>>   # error "<asm/smp.h> included in non-SMP build"
>>>   #endif
>>>
>>> +enum ipi_msg_type {
>>> +	IPI_WAKEUP,
>>> +	IPI_TIMER,
>>> +	IPI_RESCHEDULE,
>>> +	IPI_CALL_FUNC,
>>> +	IPI_CALL_FUNC_SINGLE,
>>> +	IPI_CPU_STOP,
>>> +};
>>> +
>>>   #define raw_smp_processor_id() (current_thread_info()->cpu)
>>>
>>>   struct seq_file;
>>> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
>>> index 72024ea..9ca8ce8 100644
>>> --- a/arch/arm/kernel/smp.c
>>> +++ b/arch/arm/kernel/smp.c
>>> @@ -46,6 +46,9 @@
>>>   #include <asm/mach/arch.h>
>>>   #include <asm/mpu.h>
>>>
>>> +#define CREATE_TRACE_POINTS
>>> +#include <trace/events/ipi.h>
>>> +
>>>   /*
>>>    * as from 2.5, kernels no longer have an init_tasks structure
>>>    * so we need some other way of telling a new secondary core
>>> @@ -59,15 +62,6 @@ struct secondary_data secondary_data;
>>>    */
>>>   volatile int pen_release = -1;
>>>
>>> -enum ipi_msg_type {
>>> -	IPI_WAKEUP,
>>> -	IPI_TIMER,
>>> -	IPI_RESCHEDULE,
>>> -	IPI_CALL_FUNC,
>>> -	IPI_CALL_FUNC_SINGLE,
>>> -	IPI_CPU_STOP,
>
> There are a couple of new entries you'll need to add when rebasing.
> They'll also need adding in show_ipi_name().

Ok, thx for the head up.


[ ... ]

>>>   void smp_send_stop(void)
>>> @@ -549,7 +562,7 @@ void smp_send_stop(void)
>>>   		cpumask_copy(&mask, cpu_online_mask);
>>>   		cpu_clear(smp_processor_id(), mask);
>>>
>>> -		smp_cross_call(&mask, IPI_CPU_STOP);
>>> +		ipi_raise(&mask, IPI_CPU_STOP);
>>>   	}
>>>
>>>   	/* Wait up to one second for other CPUs to stop */
>>> diff --git a/include/trace/events/ipi.h b/include/trace/events/ipi.h
>>> new file mode 100644
>>> index 0000000..fa22d4f
>>> --- /dev/null
>>> +++ b/include/trace/events/ipi.h
>>> @@ -0,0 +1,112 @@
>>> +#undef TRACE_SYSTEM
>>> +#define TRACE_SYSTEM ipi
>
> Would it make sense to put these under irq instead?
>
> IPIs are a special kind of interrupt, but interrupts nonetheless.
>
> irq:ipi_ might make sense as a prefix ... the IRQ folks might have a
> view though.

Yes, I agree.

>>> +
>>> +#if !defined(_TRACE_IPI_H) || defined(TRACE_HEADER_MULTI_READ)
>>> +#define _TRACE_IPI_H
>>> +
>>> +#include <linux/tracepoint.h>
>>> +
>>> +#define ipi_name(ipinr) { IPI_##ipinr, #ipinr }
>>> +#define show_ipi_name(val)				\
>>> +	__print_symbolic(val,				\
>>> +			 ipi_name(WAKEUP),		\
>>> +			 ipi_name(TIMER),		\
>>> +			 ipi_name(RESCHEDULE),		\
>>> +			 ipi_name(CALL_FUNC),		\
>>> +			 ipi_name(CALL_FUNC_SINGLE),	\
>>> +			 ipi_name(CPU_STOP))
>
> I can see this being a bit of a pain to maintain.  How do we keep it in
> sync with the arch headers?
>
> One option would be for the arch to provide this, or find a way to
> define the common entries in one place and the arch-specific entries
> via the arch headers.

Ok, I will look at providing a common framework.

Thanks for the review and the comments.

   -- Daniel



> Cheers
> ---Dave
>
>>> +
>>> +#define show_cpumask(srcp)				\
>>> +	({						\
>>> +		char *buf = __get_dynamic_array(buf);	\
>>> +		cpumask_scnprintf(buf, NR_CPUS, srcp);	\
>>> +		buf;					\
>>> +	})
>>> +
>>> +DECLARE_EVENT_CLASS(ipi,
>>> +
>>> +    TP_PROTO(int ipinr),
>>> +
>>> +    TP_ARGS(ipinr),
>>> +
>>> +    TP_STRUCT__entry(
>>> +	    __field(int, ipinr)
>>> +    ),
>>> +
>>> +    TP_fast_assign(
>>> +	    __entry->ipinr = ipinr;
>>> +    ),
>>> +
>>> +    TP_printk("ipi=%d, name=%s", __entry->ipinr,
>>> +	      show_ipi_name(__entry->ipinr))
>>> +);
>>> +
>>> +/**
>>> + * ipi_handle_entry - called right before the IPI handler
>>> + * @ipinr: the IPI number
>>> + *
>>> + * The @ipinr value must be valid and the action name associated with
>>> + * the IPI value is given in the trace.
>>> + */
>>> +DEFINE_EVENT_CONDITION(ipi, ipi_handler_entry,
>>> +
>>> +    TP_PROTO(int ipinr),
>>> +
>>> +    TP_ARGS(ipinr),
>>> +
>>> +    TP_CONDITION(ipinr < NR_IPI && ipinr >= 0)
>>> +);
>>> +
>>> +/**
>>> + * ipi_handle_exit - called right after the IPI handler
>>> + * @ipinr: the IPI number
>>> + *
>>> + * The @ipinr value must be valid and the action name associated with
>>> + * the IPI value is given in the trace.
>>> + */
>>> +DEFINE_EVENT_CONDITION(ipi, ipi_handler_exit,
>>> +
>>> +    TP_PROTO(int ipinr),
>>> +
>>> +    TP_ARGS(ipinr),
>>> +
>>> +    TP_CONDITION(ipinr < NR_IPI && ipinr >= 0)
>>> +);
>>> +
>>> +/**
>>> + * ipi_raise - called when a smp cross call is made
>>> + * @ipinr: the IPI number
>>> + * @cpumask: the recipients for the IPI
>>> + *
>>> + * The @ipinr value must be valid and the action name associated with
>>> + * the IPI value is given in the trace as well as the cpumask of the
>>> + * targeted cpus.
>>> + */
>>> +TRACE_EVENT_CONDITION(ipi_raise,
>>> +
>>> +    TP_PROTO(const struct cpumask *cpumask, int ipinr),
>>> +
>>> +    TP_ARGS(cpumask, ipinr),
>>> +
>>> +    TP_CONDITION(ipinr < NR_IPI && ipinr >= 0),
>>> +
>>> +    TP_STRUCT__entry(
>>> +	    __field(int, ipinr)
>>> +	    __field(const struct cpumask *, cpumask)
>>> +	    __dynamic_array(char, buf, NR_CPUS)
>>> +    ),
>>> +
>>> +    TP_fast_assign(
>>> +	    __entry->ipinr = ipinr;
>>> +	    __entry->cpumask = cpumask;
>>> +    ),
>>> +
>>> +    TP_printk("ipi=%d, cpumask=0x%s, name=%s", __entry->ipinr,
>>> +	      show_cpumask(__entry->cpumask),
>>> +	      show_ipi_name(__entry->ipinr))
>>> +);
>>> +
>>> +#endif /* _TRACE_IPI_H */
>>> +
>>> +/* This part must be outside protection */
>>> +#include <trace/define_trace.h>
>>>
>>
>>
>> --
>>   <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs
>>
>> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
>> <http://twitter.com/#!/linaroorg> Twitter |
>> <http://www.linaro.org/linaro-blog/> Blog
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

