Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab3HWLeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 07:34:50 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:51078 "EHLO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab3HWLet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 07:34:49 -0400
Message-ID: <521748FC.10809@fold.natur.cuni.cz>
Date: Fri, 23 Aug 2013 13:35:24 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:23.0) Gecko/20100101 Firefox/23.0 SeaMonkey/2.20
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Theodore Tso <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
        mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [sched_delayed] sched: RT throttling activated
References: <521722EE.70209@fold.natur.cuni.cz> <20130823100913.GQ31370@twins.programming.kicks-ass.net> <52173BBD.3050803@fold.natur.cuni.cz> <20130823110254.GU31370@twins.programming.kicks-ass.net>
In-Reply-To: <20130823110254.GU31370@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Peter Zijlstra wrote:
> On Fri, Aug 23, 2013 at 12:38:53PM +0200, Martin Mokrejs wrote:
>>> It means you have (a) real-time task(s) that consume significant amount
>>
>> How can I find them? 
> 
> ps -deo pid,cls,cmd | grep -e RR -e FF

# ps -deo pid,cls,cmd | grep -e 'RR \[' -e 'FF \['
    7  FF [migration/0]
   10  FF [watchdog/0]
   11  FF [watchdog/1]
   12  FF [migration/1]
   17  FF [migration/2]
   22  FF [migration/3]
 2161  FF [irq/50-iwlwifi]
#

The shell/python tasks have 'TS' in place of the FF value in the second column
so I guess they are not requiring realtime responsiveness.

> 
> Should do I suppose
> 
>> I don't think I need the RT, I have two CPU-bound
>> processes and want to run them at max speed. Rest of the system is unimportant.
>>
>> I still don't understand what the $subj message actually says. Does it say
>> the RT-requiring task was slowed down? I am a bit lost here.
> 
> Yeah, they were forcibly stopped from running for a little while.
> 
>>> of time. At some point we throttle them in an attempt to keep the system
>>> from falling over.
>>
>> Will I get companion "[sched_delayed] sched: RT throttling deactivated"
>> at some point?
> 
> Nope, you get that message once to tell you that we throttle RT tasks.

I think the message could improved to explain this is a warn ONCE message and
that there is no "[sched_delayed] sched: RT throttling deactivated" counterpart
message to be anticipated.

> 
>> Are python-based apps requiring the realtime features?
> 
> I'm fairly sure python could use the relevant scheduling classes, but I
> don't speak snake so I really wouldn't know.
> 
>> I used to get the messages below which are now gone with my CPU cooler being replaced yesterday:
>>
>> [ 4172.717272] CPU1: Core temperature above threshold, cpu clock throttled (total events = 153727)
> 
>> mcelog report in such cases:
>>
>> Hardware event. This is not a software error.
>> MCE 0
>> CPU 1 THERMAL EVENT TSC 1bf82e2a146 
>> TIME 1375536062 Sat Aug  3 15:21:02 2013
>> Processor 1 heated above trip temperature. Throttling enabled.
>> Please check your system cooling. Performance will be impacted
>> STATUS 880003c3 MCGSTATUS 0
>> MCGCAP c07 APICID 2 SOCKETID 0 
>> CPUID Vendor Intel Family 6 Model 42
> 
> Right, those are thermal events throttling the speed of your CPU to keep
> the thing from heat damaging itself.
> 
>> While my CPU cooler got replaced even now I still get (hence this email thread):
>>
>> [39564.452795] blah.py[14396]: segfault at 7ff67af34a58 ip 00007ff67badff00 sp 00007fff771ce798 error 4 in libpython2.7.so.1.0[7ff67b9cf000+173000]
>> [44520.259205] [sched_delayed] sched: RT throttling activated
>> [48956.057816] blah.py[16623]: segfault at 2f ip 00007fd462e5d046 sp 00007fff638431e0 error 4 in libpython2.7.so.1.0[7fd462d7c000+173000]
>> [49288.388797] blah.py[28631]: segfault at 7fe254b6aa58 ip 00007fe255715f00 sp 00007fff6ddaaff8 error 4 in libpython2.7.so.1.0[7fe255605000+173000]
>> [49942.020084] blah.py[6950]: segfault at d0 ip 00007f3e8a9acf9c sp 00007fffa72288a0 error 4 in libpython2.7.so.1.0[7f3e8a904000+173000]
>> [66696.443342] blah.py[8015]: segfault at cf ip 00007f798f708f9c sp 00007fff420336e0 error 4 in libpython2.7.so.1.0[7f798f660000+173000]
>> [67561.587383] blah.py[7483]: segfault at 7f7b16e01540 ip 00007f7b17a85f00 sp 00007fffe663d9b8 error 4 in libpython2.7.so.1.0[7f7b17975000+173000]
>> [77262.490502] blah.py[29107]: segfault at 21e1458 ip 00007fc54cd17f00 sp 00007fff283c5c38 error 4 in libpython2.7.so.1.0[7fc54cc07000+173000]
>>
>>
>> So, what does this "[sched_delayed] sched: RT throttling activated" tell me?
> 
> That of the past 1s, 0.95s were spend running RR/FIFO tasks. It is a
> warning that comes only once per boot and should prompt you to
> investigate.

Could kernel log by itself some kind of equivalent of the
"ps -deo pid,cls,cmd | grep -e 'RR \[' -e 'FF \['" command?

> 
> You can turn the throttle off, but be advised that running a RR/FIFO
> task at 100% can (and generally does) negatively affect the running of
> your system (as in, these tasks can prevent system duties from taking
> place and eventually make the system come to a halt).

Provided I have in my .config:

# grep EMPT .config.current 
# CONFIG_PREEMPT_RCU is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set

does that mean that I can't do much about those kernel tasks reported by the ps
command above? Or could kernel be tuned to be even less demanding and not
interrupt my tasks "that often" (no idea how often that happens if the message is
logged only once and how much harm is causes).

> 
> 
> As to those faults, investigate if your python prog does something
> particualrly weird or your runtime is in order. Otherwise I would advise
> you to run memtest for a while to make sure your machine is in proper
> working order.

I will re-check the stacktraces but last time I did I did not come to a single
place where it crashes. OK, will re-test the memory again but I think it is fine.
It seemed those results of the overheated CPU and thermal throttling. Now when the
thermal throttling does not happen due to new cooler I wondered what the RT throttling
does and whether that could be causing the segfaults.

Thank you,
Martin
