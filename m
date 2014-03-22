Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750900AbaCVHQH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 03:16:07 -0400
Received: from mail.cs.hku.hk ([147.8.176.10]:64554 "EHLO mail.cs.hku.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbaCVHQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 03:16:03 -0400
Message-ID: <20140322151540.9740576amzy5tdwk@intranet.cs.hku.hk>
Date: Sat, 22 Mar 2014 15:15:40 +0800
From: lwcheng@cs.hku.hk
To: Rik van Riel <riel@redhat.com>
Cc: Glauber Costa <glommer@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Paravirtual time accounting / IRQ time accounting
References: <20140319174222.213976eu8b54ujk0@intranet.cs.hku.hk>
 <CAA6-i6p-=4Dk9-ujvL36EVpm80MS-BiYjw+V9JQ8g4AypBJeZw@mail.gmail.com>
 <532C232E.5000607@redhat.com>
In-Reply-To: <532C232E.5000607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Dynamic Internet Messaging Program (DIMP) H3 (1.1.4)
X-cs-MailScanner-Information: Please contact the ISP for more information
X-cs-MailScanner-ID: s2M7FhnI018130
X-cs-MailScanner: Found to be clean
X-cs-MailScanner-SpamCheck: not spam, SpamAssassin (not cached, score=-1.01,
	required 6, autolearn=disabled, ALL_TRUSTED -1.00,
	T_RP_MATCHES_RCVD -0.01)
X-cs-MailScanner-From: lwcheng@cs.hku.hk
X-cs-MailScanner-Watermark: 1396077347.23149@qtq8H++zp7kdCjYhcHsV5g
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Quoting Rik van Riel <riel@redhat.com>:

> On 03/20/2014 11:01 AM, Glauber Costa wrote:
>> On Wed, Mar 19, 2014 at 6:42 AM,  <lwcheng@cs.hku.hk> wrote:
>
>>> ------------
>>> [src/kernel/sched/core.c]
>>> static void update_rq_clock_task(struct rq *rq, s64 delta)
>>> {
>>>     ... ...
>>> #ifdef CONFIG_IRQ_TIME_ACCOUNTING
>>>     irq_delta = irq_time_read(cpu_of(rq)) - rq->prev_irq_time;
>>>     ... ...
>>>     rq->prev_irq_time += irq_delta;
>>>     delta -= irq_delta;
>>> #endif
>>>
>>> #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
>>>     if (static_key_false((&paravirt_steal_rq_enabled))) {
>>>         steal = paravirt_steal_clock(cpu_of(rq));
>>>         steal -= rq->prev_steal_time_rq;
>>>         ... ...
>>>         rq->prev_steal_time_rq += steal;
>>>         delta -= steal;
>>>     }
>>> #endif
>>>
>>>     rq->clock_task += delta;
>>>     ... ...
>>> }
>>> --
>>> "delta" -> the intended increment to rq->clock_task
>>> "irq_delta" -> the time spent on serving IRQ (hard + soft)
>>> "steal" -> the time stolen by the underlying hypervisor
>>> --
>>> "irq_delta" is calculated based on sched_clock_cpu(), which is vulnerable
>>> to VM scheduling delays.
>>
>> This looks like a real problem indeed. The main problem in searching
>> for a solution, is that of course not all of the irq time is steal
>> time and vice versa. In this case, we could subtract irq_time from
>> steal, and add only the steal part time that is in excess. I don't
>> think this is 100 % guaranteed, but maybe it is a good approximation.
>>
>> Rik, do you have an opinion on this ?
>
> The other way around may be better, since steal time (when it
> happens) is likely to be of "time slice" magnitude, while irq
> time will happen more frequently, and in dozens-of-microseconds
> intervals.
>
> Furthermore, we have no way to measure what the irq time is,
> except by looking at how much real time elapsed. For steal time,
> however, the hypervisor tells us exactly how much time was stolen.
>
> That means when steal time and irq time happen simultaneously,
> the amount of steal time should always be smaller than the
> calculated irq time for that period.
>
> actual irq_time = calculated irq time - reported steal time;
>
> --
> All rights reversed
>

I observe that sometimes irq_time only includes "part" of steal_time.

Like you said, irq_time is in dozens-of-microseconds. In VMs, as all
devices seen are virtual ones, irq_time seems to be not as desired
as it is in physical hosts.

A quick (but not radical) solution may be:
disable CONFIG_IRQ_TIME_ACCOUNTING if CONFIG_PARAVIRT is selected.
Just adopt tick-based accounting: CONFIG_TICK_CPU_ACCOUNTING

I am thinking what irq_time really *means* in VMs.

-Luwei


