Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab3BSH3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 02:29:18 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:57126 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458Ab3BSH3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 02:29:17 -0500
Message-ID: <512329C3.207@linux.vnet.ibm.com>
Date: Tue, 19 Feb 2013 15:29:07 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Clark Williams <clark@redhat.com>,
        Andrew Theurer <habanero@us.ibm.com>
Subject: Re: [RFC] sched: The removal of idle_balance()
References: <1360908819.23152.97.camel@gandalf.local.home> <20130218081345.GA4157@linux.vnet.ibm.com> <1361201142.23152.152.camel@gandalf.local.home> <CADZ9YHhhkaqqCKsfJ09M_NHeeT+gSR2ZYeCpXcYZ46_39U=Crg@mail.gmail.com>
In-Reply-To: <CADZ9YHhhkaqqCKsfJ09M_NHeeT+gSR2ZYeCpXcYZ46_39U=Crg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021907-2000-0000-0000-00000B003F25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 12:13 PM, Rakib Mullick wrote:
> On Mon, Feb 18, 2013 at 9:25 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> On Mon, 2013-02-18 at 13:43 +0530, Srikar Dronamraju wrote:
>>>> The cache misses dropped by ~23% and migrations dropped by ~28%. I
>>>> really believe that the idle_balance() hurts performance, and not just
>>>> for something like hackbench, but the aggressive nature for migration
>>>> that idle_balance() causes takes a large hit on a process' cache.
>>>>
>>>> Think about it some more, just because we go idle isn't enough reason to
>>>> pull a runable task over. CPUs go idle all the time, and tasks are woken
>>>> up all the time. There's no reason that we can't just wait for the sched
>>>> tick to decide its time to do a bit of balancing. Sure, it would be nice
>>>> if the idle CPU did the work. But I think that frame of mind was an
>>>> incorrect notion from back in the early 2000s and does not apply to
>>>> today's hardware, or perhaps it doesn't apply to the (relatively) new
>>>> CFS scheduler. If you want aggressive scheduling, make the task rt, and
>>>> it will do aggressive scheduling.
>>>>
>>>
>>> How is it that the normal tick based load balancing gets it correctly while
>>> the idle_balance gets is wrong?  Can it because of the different
>>> cpu_idle_type?
>>>
>>
>> Currently looks to be a fluke in my box, as this performance increase
>> can't be duplicated elsewhere (yet). But from looking at my traces, it
>> seems that my box does the idle balance at just the wrong time, and
>> causes these issues.
>>
> A default hackbench run creates 400 tasks (10 * 40), on a i7 system (4
> core, HT), idle_balance() shouldn't be in action, cause on a 8 cpu
> system we're assigning 400 tasks. If idle_balance() comes in, that
> means - we've done something wrong while distributing tasks among the
> CPUs, that indicates a problem during fork/exec/wake balancing?

Hmm...I think, unless we have the promise that all those threads, at any
moment, they have the same behaviour, otherwise, even each cpu has the
same load, there are still the chance that some cpu will finish the work
more faster when it own more 'sleepy' tasks at some moment.

So if idle_balance() happen, I will say that the workload is not heavy
enough to keep all the cpu busy all the time, but I won't say it's
imbalanced.

Regards,
Michael Wang

> 
> Thanks,
> Rakib.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

