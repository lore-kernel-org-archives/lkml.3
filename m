Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbaAFRNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 12:13:33 -0500
Received: from mga14.intel.com ([143.182.124.37]:36537 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbaAFRNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 12:13:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,614,1384329600"; 
   d="scan'208";a="332360669"
Message-ID: <52CAE43A.9070509@linux.intel.com>
Date: Mon, 06 Jan 2014 09:13:30 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, pjt@google.com,
        Morten.Rasmussen@arm.com, cmetcalf@tilera.com, tony.luck@intel.com,
        alex.shi@linaro.org, linaro-kernel@lists.linaro.org, rjw@sisk.pl,
        paulmck@linux.vnet.ibm.com, corbet@lwn.net, tglx@linutronix.de,
        len.brown@intel.com, amit.kucheria@linaro.org, james.hogan@imgtec.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        Dietmar.Eggemann@arm.com
Subject: Re: [RFC] sched: CPU topology try
References: <20131105222752.GD16117@laptop.programming.kicks-ass.net> <1387372431-2644-1-git-send-email-vincent.guittot@linaro.org> <52C3A0F1.3040803@linux.vnet.ibm.com> <20140106163341.GO31570@twins.programming.kicks-ass.net> <52CADBB9.1010704@linux.intel.com> <20140106164838.GR31570@twins.programming.kicks-ass.net> <20140106165458.GV3694@twins.programming.kicks-ass.net>
In-Reply-To: <20140106165458.GV3694@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> AFAICT this is a chicken-egg problem, the OS never did anything useful
>> with it so the hardware guys are now trying to do something with it, but
>> this also means that if we cannot predict what the hardware will do
>> under certain circumstances the OS really cannot do anything smart
>> anymore.
>>
>> So yes, for certain hardware we'll just have to give up and not do
>> anything.
>>
>> That said, some hardware still does allow us to do something and for
>> those we do need some of this.
>>
>> Maybe if the OS becomes smart enough the hardware guys will give us some
>> control again, who knows.
>>
>> So yes, I'm entirely fine saying that some chips are fucked and we can't
>> do anything sane with them.. Fine they get to sort things themselves.
>
> That is; you're entirely unhelpful and I'm tempting to stop listening
> to whatever you have to say on the subject.
>
> Most of your emails are about how stuff cannot possibly work; without
> saying how things can work.
>
> The entire point of adding P and C state information to the scheduler is
> so that we CAN do cross cpu decisions, but if you're saying we shouldn't
> attempt because you can't say how the hardware will react anyway; fine
> we'll ignore Intel hardware from now on.

that's not what I'm trying to say.

if we as OS want to help make such decisions, we also need to face reality of what it means,
and see how we can get there.

let me give a simple but common example case, of a 2 core system where the cores share P state.
one task (A) is high priority/high utilization/whatever
	(e.g. causes the OS to ask for high performance from the CPU if by itself)
the other task (B), on the 2nd core, is not that high priority/utilization/etc
	(e.g. would cause the OS to ask for max power savings from the CPU if by itself)


time	core 0			core 1				what the combined probably should be
0	task A			idle				max performance
1	task A			task B				max performance
2	idle (disk IO)		task B				least power
3	task A			task B				max performance

e.g. a simple case of task A running, and task B coming in... but then task A blocks briefly,
on say disk IO or some mutex or whatever.

we as OS will need to figure out how to get to the combined result, in a way that's relatively race free,
with two common races to take care of:
  * knowing if another core is idle at any time is inherently racey.. it may wake up or go idle the next cycle
  * in hardware modes where the OS controls all, the P state registers tend to be "the last one to write on any
    core controls them all" way; we need to make sure we don't fight ourselves here and assign a core to do
    this decision/communication to hardware on behalf of the whole domain (even if the core that's
    assigned may move around when the assigned core goes idle) rather than the various cores doing it themselves async.
    This tends to be harder than it seems if you also don't want to lose efficiency (e.g. no significant extra
    wakeups from idle and also not missing opportunities to go to "least power" in the "time 2" scenario above)


x86 and modern ARM (snapdragon at least) do this kind of coordination in hardware/microcontroller (with an opt in for the OS to
do it itself on x86 and likely snapdragon) which means the race conditions are not really there.


