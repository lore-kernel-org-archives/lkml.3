Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab3JYWZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 18:25:59 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35791 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab3JYWZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 18:25:58 -0400
Message-ID: <526AEFF3.3060609@linaro.org>
Date: Sat, 26 Oct 2013 00:25:55 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, shaojie.sun@linaro.org
Subject: Re: [PATCH V2] ARM: trace: Add tracepoint for the Inter Processor
 Interrupt
References: <1381839042-3533-1-git-send-email-daniel.lezcano@linaro.org>	 <526A145E.1010809@linaro.org> <1382688595.6143.5.camel@pippen.local.home>
In-Reply-To: <1382688595.6143.5.camel@pippen.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2013 10:09 AM, Steven Rostedt wrote:
> On Fri, 2013-10-25 at 08:49 +0200, Daniel Lezcano wrote:
>> On 10/15/2013 02:10 PM, Daniel Lezcano wrote:
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
>>>
>>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>>
>> Hi All,
>>
>> does this patch sound good for inclusion ?
>
> Ug, I never sent my email. It was half written and in my drafts folder.

That's just typical ! I think no one can say it never happened :)

> I'll reply below.
>

[ ... ]

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
>>> +	    __array(char, cpumask, NR_CPUS)
>>> +    ),
>>> +
>>> +    TP_fast_assign(
>>> +	    __entry->ipinr = ipinr;
>>> +	    cpumask_scnprintf(__entry->cpumask,
>>> +			      ARRAY_SIZE(__entry->cpumask), cpumask);
>
> Please do not do the scnprintf() in the TP_fast_assign(). It's heavy
> weight and this is done in the code path. Just copy the actual cpumask
> itself.

Ok.

> Now, how to do that exactly is the reason I never sent my original mail,
> because I never got around to looking how to do it, but it is possible.
> Unfortunately, I'm at Kernel Summit at the moment, and still don't have
> time to look at the best way to do it. But you can use dynamic arrays
> for the cpus_online.
>
>>> +    ),
>>> +
>>> +    TP_printk("ipi=%d, cpumask=0x%s, name=%s", __entry->ipinr, __entry->cpumask,
>>> +	      show_ipi_name(__entry->ipinr))
>
> Here is where you can convert the cpumask saved in the ring buffer to a
> snprintf() format. Now this may need some work too, and perhaps even a
> handler to help. I thought there was already some printk format that
> does cpumasks.
>
> If the helpers are not there, then I can work on adding some.

I don't find any helper in the code except cpumask_scnprintf. If you 
don't have the time, I can do the adequate changes with some advices.

Thanks
   -- Daniel

>>> +);
>>> +
>>> +#endif /* _TRACE_IPI_H */
>>> +
>>> +/* This part must be outside protection */
>>> +#include <trace/define_trace.h>
>>>
>>
>>
>
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

