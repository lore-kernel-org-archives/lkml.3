Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab3HWLDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 07:03:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47188 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974Ab3HWLDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 07:03:02 -0400
Date: Fri, 23 Aug 2013 13:02:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: Theodore Tso <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
        mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [sched_delayed] sched: RT throttling activated
Message-ID: <20130823110254.GU31370@twins.programming.kicks-ass.net>
References: <521722EE.70209@fold.natur.cuni.cz>
 <20130823100913.GQ31370@twins.programming.kicks-ass.net>
 <52173BBD.3050803@fold.natur.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52173BBD.3050803@fold.natur.cuni.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 12:38:53PM +0200, Martin Mokrejs wrote:
> > It means you have (a) real-time task(s) that consume significant amount
> 
> How can I find them? 

ps -deo pid,cls,cmd | grep -e RR -e FF

Should do I suppose

> I don't think I need the RT, I have two CPU-bound
> processes and want to run them at max speed. Rest of the system is unimportant.
> 
> I still don't understand what the $subj message actually says. Does it say
> the RT-requiring task was slowed down? I am a bit lost here.

Yeah, they were forcibly stopped from running for a little while.

> > of time. At some point we throttle them in an attempt to keep the system
> > from falling over.
> 
> Will I get companion "[sched_delayed] sched: RT throttling deactivated"
> at some point?

Nope, you get that message once to tell you that we throttle RT tasks.

> Are python-based apps requiring the realtime features?

I'm fairly sure python could use the relevant scheduling classes, but I
don't speak snake so I really wouldn't know.

> I used to get the messages below which are now gone with my CPU cooler being replaced yesterday:
> 
> [ 4172.717272] CPU1: Core temperature above threshold, cpu clock throttled (total events = 153727)

> mcelog report in such cases:
> 
> Hardware event. This is not a software error.
> MCE 0
> CPU 1 THERMAL EVENT TSC 1bf82e2a146 
> TIME 1375536062 Sat Aug  3 15:21:02 2013
> Processor 1 heated above trip temperature. Throttling enabled.
> Please check your system cooling. Performance will be impacted
> STATUS 880003c3 MCGSTATUS 0
> MCGCAP c07 APICID 2 SOCKETID 0 
> CPUID Vendor Intel Family 6 Model 42

Right, those are thermal events throttling the speed of your CPU to keep
the thing from heat damaging itself.

> While my CPU cooler got replaced even now I still get (hence this email thread):
> 
> [39564.452795] blah.py[14396]: segfault at 7ff67af34a58 ip 00007ff67badff00 sp 00007fff771ce798 error 4 in libpython2.7.so.1.0[7ff67b9cf000+173000]
> [44520.259205] [sched_delayed] sched: RT throttling activated
> [48956.057816] blah.py[16623]: segfault at 2f ip 00007fd462e5d046 sp 00007fff638431e0 error 4 in libpython2.7.so.1.0[7fd462d7c000+173000]
> [49288.388797] blah.py[28631]: segfault at 7fe254b6aa58 ip 00007fe255715f00 sp 00007fff6ddaaff8 error 4 in libpython2.7.so.1.0[7fe255605000+173000]
> [49942.020084] blah.py[6950]: segfault at d0 ip 00007f3e8a9acf9c sp 00007fffa72288a0 error 4 in libpython2.7.so.1.0[7f3e8a904000+173000]
> [66696.443342] blah.py[8015]: segfault at cf ip 00007f798f708f9c sp 00007fff420336e0 error 4 in libpython2.7.so.1.0[7f798f660000+173000]
> [67561.587383] blah.py[7483]: segfault at 7f7b16e01540 ip 00007f7b17a85f00 sp 00007fffe663d9b8 error 4 in libpython2.7.so.1.0[7f7b17975000+173000]
> [77262.490502] blah.py[29107]: segfault at 21e1458 ip 00007fc54cd17f00 sp 00007fff283c5c38 error 4 in libpython2.7.so.1.0[7fc54cc07000+173000]
> 
> 
> So, what does this "[sched_delayed] sched: RT throttling activated" tell me?

That of the past 1s, 0.95s were spend running RR/FIFO tasks. It is a
warning that comes only once per boot and should prompt you to
investigate.

You can turn the throttle off, but be advised that running a RR/FIFO
task at 100% can (and generally does) negatively affect the running of
your system (as in, these tasks can prevent system duties from taking
place and eventually make the system come to a halt).


As to those faults, investigate if your python prog does something
particualrly weird or your runtime is in order. Otherwise I would advise
you to run memtest for a while to make sure your machine is in proper
working order.
