Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab3HWTHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:07:35 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:53586 "EHLO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab3HWTHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:07:33 -0400
Message-ID: <5217B2FC.3040103@fold.natur.cuni.cz>
Date: Fri, 23 Aug 2013 21:07:40 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:23.0) Gecko/20100101 Firefox/23.0 SeaMonkey/2.20
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
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

While you are probably thinking about the iwlwifi issue causing RT throttling
I have one more interesting followup below.

Peter Zijlstra wrote:
> On Fri, Aug 23, 2013 at 12:38:53PM +0200, Martin Mokrejs wrote:
>>> It means you have (a) real-time task(s) that consume significant amount
>>
>> How can I find them? 
> 
> ps -deo pid,cls,cmd | grep -e RR -e FF
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
> 
> You can turn the throttle off, but be advised that running a RR/FIFO
> task at 100% can (and generally does) negatively affect the running of
> your system (as in, these tasks can prevent system duties from taking
> place and eventually make the system come to a halt).
> 
> 
> As to those faults, investigate if your python prog does something
> particualrly weird or your runtime is in order. Otherwise I would advise
> you to run memtest for a while to make sure your machine is in proper
> working order.

Hmm, meanwhile the core dumps filled up my /var/dumps/ directory of / filesystem.
I do not have timing information what was the time since bootup. I deleted some
files on the disk and thought I am done. Now, few hours later I realized:

[85451.247130] traps: blah.py[30787] general protection ip:7faf7b57a046 sp:7fffd9f7b1d0 error:0 in libpython2.7.so.1.0[7faf7b499000+173000]
[87125.493730] nr_pdflush_threads exported in /proc is scheduled for removal
[87125.494238] sysctl: The scan_unevictable_pages sysctl/node-interface has been disabled for lack of a legitimate use case.  If you have one, please send an email to linux-mm@kvack.org.
[97959.812943] blah.py[13069]: segfault at 7f1f2cfdca58 ip 00007f1f2db87f00 sp 00007fffade41768 error 4 in libpython2.7.so.1.0[7f1f2da77000+173000]


I bet at about the time 87125 the disk was full. The laptop has 16GB of RAM
and the coredump files are really big, 300MB to 8GB. However, the nr_pdflush_threads
message sounds scary. Does linux 3.10.9 want to delete /proc on the fly? ;-)


Martin
