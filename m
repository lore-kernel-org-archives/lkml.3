Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264AbaLaFFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 00:05:00 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48133 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbaLaFE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 00:04:59 -0500
Message-ID: <54A383E5.8020605@linux.vnet.ibm.com>
Date: Wed, 31 Dec 2014 10:34:37 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "peterz@infradead.org" <peterz@infradead.org>
CC: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Eduardo Valentin <edubezval@gmail.com>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Subject: Re: [PATCH] tick/powerclamp: Remove tick_nohz_idle abuse
References: <alpine.DEB.2.11.1412181110110.17382@nanos> <54930EB1.9080309@linux.vnet.ibm.com> <DD415AA12F8FF042BF4EA69DF123C1478AF91730@ORSMSX101.amr.corp.intel.com> <20141218115239.53d17e39@jacob-VirtualBox> <alpine.DEB.2.11.1412182209010.17382@nanos> <20141219103900.101f6c6d@jacob-VirtualBox> <alpine.DEB.2.11.1412192054130.17382@nanos> <5494D160.8060808@linux.vnet.ibm.com> <20141222185708.15bbdd17@jacob-VirtualBox>
In-Reply-To: <20141222185708.15bbdd17@jacob-VirtualBox>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14123105-0037-0000-0000-0000003D0CAD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacob,

On 12/23/2014 08:27 AM, Jacob Pan wrote:
> On Sat, 20 Dec 2014 07:01:12 +0530
> Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> 
>> On 12/20/2014 01:26 AM, Thomas Gleixner wrote:
>>> On Fri, 19 Dec 2014, Jacob Pan wrote:
>>>
>>>> On Thu, 18 Dec 2014 22:12:57 +0100 (CET)
>>>> Thomas Gleixner <tglx@linutronix.de> wrote:
>>>>
>>>>> On Thu, 18 Dec 2014, Jacob Pan wrote:
>>>>>> OK I agree, also as I mentioned earlier, Peter already has a
>>>>>> patch for consolidated idle loop and remove
>>>>>> tick_nohz_idle_enter/exit call from powerclamp driver. I have
>>>>>> been working on a few tweaks to maintain the functionality and
>>>>>> efficiency with the consolidated idle loop. We can apply the
>>>>>> patches on top of yours.
>>>>>
>>>>> No. This is equally wrong as I pointed out before. The 'unified'
>>>>> idle loop is still fake and just pretending to be idle.
>>>>>
>>>> In terms of efficiency, the consolidated idle loop will allow
>>>> turning off sched tick during idle injection period. If we just
>>>> take out the tick_nohz_idle_xxx call, the effectiveness of
>>>> powerclamp is going down significantly. I am not arguing the
>>>> design but from fixing regression perspective or short term
>>>> solution.
>>>
>>> There is no perspective. Period.
>>>
>>> Its violates every rightful assumption of the nohz_IDLE_* code and
>>> just ever worked by chance. There is so much subtle wreckage lurking
>>> there that the only sane solution is to forbid it. End of story.
>>>
>>> Thanks,
>>>
>>> 	tglx
>>>
>> Hi Jacob,
>>
>> Like Thomas pointed out, we can design a sane solution for powerclamp.
>> Idle injection is nothing but throttling of runqueue. If the runqueue
>> is throttled, no fair tasks will be selected and the natural choice
>> in the absence of tasks from any other sched class is the idle task.
>>
>> The idle loop will automatically be called and the nohz state will
>> also fall in place. The cpu is really idle now: the runqueue has no
>> tasks and the task running on the cpu is the idle thread. The
>> throttled tasks are on a separate list.
>>
>> When the period of idle injection is over, we unthrottle the runqueue.
>> All this being taken care of my a non-deferrable timer. This design
>> ensures that the intention of powerclamp is not hampered while at the
>> same time maintaining a sane state for nohz; you will get the
>> efficiency you want.
>>
>> Of course there may be corner cases and challenges around
>> synchronization of package idle, which I am sure we can work around
>> with a better design such as the above. I am working on that patchset
>> and will post out in a day. You can take a look and let us know the
>> pieces we are missing.
>>
>> I find that implementing the above design is not too hard.
>>
> Hi Preeti,
> Yeah, it seems to be a good approach. looking forward to work with you
> on this. Timer may scale better for larger systems. One question, will
> timer irq gets unpredictable delays if run by ksoftirqd?

I am sorry I could not respond earlier; I was on vacation as well. Yes,
we may have a problem here. Let alone synchronization between cpus in
performing clamping, there are two other functionality issues that I see.

1. Since periodic timers get executed in the softirq context,
scheduler_tick() would have passed by by then. i.e.
hrtimer_interrupt()
|__tick_sched_handle()
   |__scheduler_tick()
   |__raise_softirq(TIMER_SOFTIRQ)
ksoftirqd runs on local_bh_enable()-->powerclamp_timer handler runs

Although runqueues are throttled in the powerclamp timer handler, it has
to wait till the next scheduler tick to select an idle task to run.
A precious 4-10ms depending on the config would have passed by then.

2. For the same reason as 1, when the ksoftirqd has to run on the cpus
during the tick after the one in which throttling is enabled, cpus are
unavailable to run the daemon because they are throttled. However there
is no other way to unthrottle the runqueues now except by running the
ksoftirqd; a chicken and egg problem.

I think both the above problems could be solved by using hrtimers
instead of periodic timers to perform clamping/unclamping, since
hrtimers are serviced in the interrupt context. But we cannot
initialize/start/modify hrtimers on a remote cpu. We will end up using
IPIs for handling the hrtimers during start/end of powerclamp or
modification of the idle duration of clamping, which is not a tempting
option either.

So I am currently stuck at this point. I would be glad to have some
suggestions.

Thanks

Regards
Preeti U Murthy

> BTW, I may not be able to respond quickly during the holidays. If
> things workout, it may benefit ACPI PAD driver as well.
> 
> 
> Thanks,
> 
> Jacob
>> Regards
>> Preeti U Murthy
>>
> 
> [Jacob Pan]
> 

