Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaCVGsY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 02:48:24 -0400
Received: from mail.cs.hku.hk ([147.8.176.10]:64013 "EHLO mail.cs.hku.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbaCVGsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 02:48:21 -0400
Message-ID: <20140322144752.93371i3e3g500fgk@intranet.cs.hku.hk>
Date: Sat, 22 Mar 2014 14:47:52 +0800
From: lwcheng@cs.hku.hk
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Glauber Costa <glommer@gmail.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Paravirtual time accounting / IRQ time accounting
References: <20140319174222.213976eu8b54ujk0@intranet.cs.hku.hk>
 <CAA6-i6p-=4Dk9-ujvL36EVpm80MS-BiYjw+V9JQ8g4AypBJeZw@mail.gmail.com>
 <1395381008.6030.26.camel@marge.simpson.net>
In-Reply-To: <1395381008.6030.26.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Dynamic Internet Messaging Program (DIMP) H3 (1.1.4)
X-cs-MailScanner-Information: Please contact the ISP for more information
X-cs-MailScanner-ID: s2M6lsRr017061
X-cs-MailScanner: Found to be clean
X-cs-MailScanner-SpamCheck: not spam, SpamAssassin (not cached, score=-1.01,
	required 6, autolearn=disabled, ALL_TRUSTED -1.00,
	T_RP_MATCHES_RCVD -0.01)
X-cs-MailScanner-From: lwcheng@cs.hku.hk
X-cs-MailScanner-Watermark: 1396075681.21141@POAdlHRHe/Eqr0QfIK5AmA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Quoting Mike Galbraith <umgwanakikbuti@gmail.com>:

> On Thu, 2014-03-20 at 12:01 -0300, Glauber Costa wrote:
>> On Wed, Mar 19, 2014 at 6:42 AM,  <lwcheng@cs.hku.hk> wrote:
>> > In consolidated environments, when there are multiple virtual  
>> machines (VMs)
>> > running on one CPU core, timekeeping will be a problem to the guest OS.
>> > Here, I report my findings about Linux process scheduler.
>> >
>> >
>> > Description
>> > ------------
>> > Linux CFS relies on rq->clock_task to charge each task, determine  
>> vruntime,
>> > etc.
>> >
>> > When CONFIG_IRQ_TIME_ACCOUNTING is enabled, the time spent on serving IRQ
>> > will be excluded from updating rq->clock_task.
>> > When CONFIG_PARAVIRT_TIME_ACCOUNTING is enabled, the time stolen by the
>> > hypervisor
>> > will also be excluded from updating rq->clock_task.
>> >
>> > With "both" CONFIG_IRQ_TIME_ACCOUNTING and CONFIG_PARAVIRT_TIME_ACCOUNTING
>> > enabled,
>> > I put three KVM guests on one core and run hackbench in each guest. I find
>> > that
>> > in the guests, rq->clock_task stays *unchanged*. The malfunction  
>> embarrasses
>> > CFS.
>> > ------------
>> >
>> >
>> > Analysis
>> > ------------
>> > [src/kernel/sched/core.c]
>> > static void update_rq_clock_task(struct rq *rq, s64 delta)
>> > {
>> >     ... ...
>> > #ifdef CONFIG_IRQ_TIME_ACCOUNTING
>> >     irq_delta = irq_time_read(cpu_of(rq)) - rq->prev_irq_time;
>> >     ... ...
>> >     rq->prev_irq_time += irq_delta;
>> >     delta -= irq_delta;
>> > #endif
>> >
>> > #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
>> >     if (static_key_false((&paravirt_steal_rq_enabled))) {
>> >         steal = paravirt_steal_clock(cpu_of(rq));
>> >         steal -= rq->prev_steal_time_rq;
>> >         ... ...
>> >         rq->prev_steal_time_rq += steal;
>> >         delta -= steal;
>> >     }
>> > #endif
>> >
>> >     rq->clock_task += delta;
>> >     ... ...
>> > }
>> > --
>> > "delta" -> the intended increment to rq->clock_task
>> > "irq_delta" -> the time spent on serving IRQ (hard + soft)
>> > "steal" -> the time stolen by the underlying hypervisor
>> > --
>> > "irq_delta" is calculated based on sched_clock_cpu(), which is vulnerable
>> > to VM scheduling delays.
>>
>> This looks like a real problem indeed. The main problem in searching
>> for a solution, is that of course not all of the irq time is steal
>> time and vice versa. In this case, we could subtract irq_time from
>> steal, and add only the steal part time that is in excess. I don't
>> think this is 100 % guaranteed, but maybe it is a good approximation.
>>
>> Rik, do you have an opinion on this ?
>
> Hrm, on my little Q6600 box, I'm running 3 VMS all pinned to CPU3, all
> running hackbench -l zillion, one of them also running crash, staring at
> it's sole rq->clock_task as I write this, with kernels (3.11.10) on both
> host and guest configured as reported.
>
>   clock_task = 631322187004,
>   clock_task = 631387807452,
>   clock_task = 631474214294,
>   clock_task = 631523864893,
>   clock_task = 631604646268,
>   clock_task = 631643276025,
>
> Maybe 3 VMs isn't enough overload for such a beastly CPU.  Top reports
> some very funky utilization numbers, but other than that, the things
> seem to work fine here.  perf thinks scheduling work too.
>
> -Mike
>

I checked the source code again. I forgot to mention that I commented out
steal_ticks() in my experiments (sorry):
[kernel/sched/core.c]
-------------------------------
#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
     if (static_key_false((&paravirt_steal_rq_enabled))) {
         /*
         u64 st;
         */
         steal = paravirt_steal_clock(cpu_of(rq));
         steal -= rq->prev_steal_time_rq;

         if (unlikely(steal > delta))
             steal = delta;
         /*
         st = steal_ticks(steal);
         steal = st * TICK_NSEC;
         */
         rq->prev_steal_time_rq += steal;

         delta -= steal;
     }
#endif

     rq->clock_task += delta;
-------------------------------

I do it just for "accuracy", because I fully trust "steal" reported
by the hypervisor. I do not quite understand why it is trimmed again
using steal_ticks(). Please enlighten me.

Even when "steal == delta", as long as "steal" is not exactly
(N * TICK_NSEC), after steal_ticks(), it will be always smaller
than "delta".
So, rq->clock_task can still progress, but may not in the precise way.
Each time, the error is within the range (0, TICK_NSEC).

When CONFIG_IRQ_TIME_ACCOUNTING is disabled, deleting steal_ticks()
does not affect the update to rq->clock_task.

I tested both 3.10.0 and 3.13.5. The results are consistent.

-Luwei




