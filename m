Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbaEPHP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 03:15:57 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:59249 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbaEPHP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 03:15:56 -0400
Date: Fri, 16 May 2014 09:11:41 +0200
From: Henrik Austad <henrik@austad.us>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: "xiaofeng.yan" <xiaofeng.yan@huawei.com>, Luca Abeni <luca.abeni@unitn.it>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        duzhiping.du@huawei.com, xiaofeng.yan2012@gmail.com, raistlin@linux.it,
        tkhai@yandex.ru, harald.gustafsson@ericsson.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFD] sched/deadline: EDF dynamic quota design
Message-ID: <20140516071141.GA28755@austad.us>
References: <537348DA.7080001@huawei.com>
 <20140514113245.GZ11096@twins.programming.kicks-ass.net>
 <53736CD9.90805@unitn.it>
 <5374A335.90705@huawei.com>
 <20140515143132.c3199bec4476065cc843277d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515143132.c3199bec4476065cc843277d@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 02:31:32PM +0200, Juri Lelli wrote:
> Hi,

Hi all,

> [Cc-ed lkml again to include Luca's reply]
> 
> and thanks to Luca for his reply!

Indeed! and several great references. My backlog just got 3 more items 
pushed :)

> On Thu, 15 May 2014 19:21:25 +0800
> "xiaofeng.yan" <xiaofeng.yan@huawei.com> wrote:
> 
> > On 2014/5/14 21:17, Luca Abeni wrote:
> > > Hi Peter,
> > >
> > > thanks for adding me in cc :)
> > > This dynamic quota design looks similar to some resource reclaiming 
> > > algorithm
> > > known in literature, and might be related to some feedback scheduling 
> > > ideas.
> > > More details below...
> > >
> > > On 05/14/2014 01:32 PM, Peter Zijlstra wrote:
> > > [...]
> > >>> * Example.
> > >>>    Three tasks: T1,T2,T3. Their initial status is as follows,
> > >>>    T1(200us,500us,500us)
> > >>>    T2(200us,500us,500us)
> > >>>    T3(200us,500us,500us)
> > >>>
> > >>>    At time t1, the tasks' running status is as follows,
> > >>>    T1(200us,500us,500us)
> > >>>    T2(100us,500us,500us)
> > >>>    T3(200us,500us,500us)
> > >>>    Busy tasks: T1,T3
> > >>>    Idle task:  T2
> > >>>    Bandwidth pool: 20%
> > >>>
> > >>>    Now, there are 20% quota in the bandwidth pool, T1 or T3 get 5% 
> > >>> quota
> > >>>    (adjustable) from the bandwidth pool when they enter run-queue.
> > >>>    Then, the status is as follows:
> > >>>    T1(225us,500us,500us)
> > >>>    T2(100us,500us,500us)
> > >>>    T3(225us,500us,500us)
> > >>>    Bandwidth pool: 10%
> > >>>
> > >>>    Busy tasks could get the quota when the bandwidth pool is not empty.

First off, the %-usage is a bit confusing. I get that you in -this- example 
use a standard 500us poolsize so that 20% means "20% of 500us = 100us". 

Secondly, you allocate 600us over a 500us period - I assume that you have 
more than 1 CPU? (a statement "On a system with X CPUs we run..." would be 
appreciated.

Once you start looking at better way to express available bandwidth, you 
realize that this is a road fraught with peril. You could say that you have 
'100us in the pool', but then you need the period as well. Then you realize 
that not all threads have the same period. Or same release-time. Further 
down the road.

- Does all the threads start at the same time, or is the initial 
  release-time independent of one another?
- when does extra BW expire?
- what if the period differs between the tasks
- on which CPU can you use this extra BW?

For instance, a somewhat similar setup like Yan's, but with slightly 
modified parameters to serve my point.

T: {C,D,R}, running on a 2 core system
C: WCET (worst-case execution time), required time on the CPU each period
D: Deadline (after release)
R: Release period (Task should have budget refill/wakeup every R us)

T1: {100us,  500us,  500us}
T2: {300us,  500us,  500us}
T3: {400us, 1000us, 1000us}
T4: {400us, 1000us, 1000us}

T1 and T2 run on core 0, T3 and T4 on core 1, both cores are 80% utilized. 
If T4 finish after 100, who should be given the extra 300us? You probably 
need to 'tag' the extra BW in the pool with both period _and_ cpu.

This is going to get complicated to get right. Or rather, you run the risk 
of running into strange bugs.

> > >> Yeah, not sure that's sound. But I'll leave that to others.
> > > The idea (donating to other tasks some of the runtime reserved to a task
> > > but actually unused because the task is busy) is sound, but it must be 
> > > done
> > > carefully, otherwise the guarantees about reserved runtimes risk to be 
> > > broken.
> > >
> > > This (CPU reclaiming) has been investigated in the past, and a lot of 
> > > possible
> > > algorithms have been proposed. For example, see:
> > > "Greedy reclamation of unused bandwidth in constant-bandwidth servers" by
> > > Lipari and others:
> > > http://scholar.google.com/scholar?cluster=3702635449685717385&hl=it&as_sdt=0,5 
> > >
> > > or
> > > "Capacity sharing for overrun control" by Caccamo and others:
> > > http://scholar.google.com/scholar?cluster=8595685180937180485&hl=it&as_sdt=0,5 
> > >
> > > and of course all of the related papers found by Scholar (I cited 
> > > these two
> > > papers because I can easily remember them, but there are many other).
> > > There is also a nice paper by Scott Brandt that compares the 
> > > implementations
> > > of multiple reclaiming algorithms, but I do not remember the title.
> > >
> > > All of these papers provide a more sound theoretical foundation for 
> > > runtime/budget
> > > donation/sharing.
> > >
> > > As a form of shameless self-advertisement, I have also to mention that 
> > > adaptive
> > > reservations (feedback scheduling based on CBS/SCHED_DEADLINE) can be 
> > > related,
> > > allowing to dynamically adapt the runtime to the actual tasks demands.
> > > For example, see "Analysis of a reservation-based feedback scheduler":
> > > http://scholar.google.com/scholar?cluster=2878648944333333913&hl=it&as_sdt=0,5 

Thanks! Great references :)

> > > This can also be implemented in user-space (without modifying the 
> > > scheduler)
> > > by having a daemon that monitors the SCHED_DEADLINE tasks and changes 
> > > their
> > > runtimes based on some kind of feedback (for example, difference 
> > > between the
> > > scheduling deadline of a task and its actual deadline - if this 
> > > information
> > > is made available by the scheduler). I developed a similar 
> > > implementation in
> > > the past (not based on SCHED_DEADLINE, but on some previous 
> > > implementation
> > > of the CBS algorithm).

This sounds like a very slow approach. What if the extra BW given by T2 was 
for one period only? There's no way you could create a userspace daemon to 
handle that kind of budget-tweaking.

Also, it sounds like a *really* dangerous idea to let some random (tm) 
userspace daemon adjust the deadline-budget for other tasks in the system 
based on an observation of spent budget for the last X seconds. It's not 
military funding we're concerned with here.

When you state your WCET, it is not because you need -exactly- that budget, 
it is because you should *never* exceed that kind of rquired 
computational time.

Blindly reducing allocated runtime is defeating that whole purpose. 
Granted, if you use EDF for BW-control only, it could be done - but then 
the thread itself should do that. Real-time is not about being fair. Heck, 
it's not even about being optimal, it's about being predictable and 
"dynamically adjusting" is not!

> > > Hope these references can help someone... :)
> > >
> > Thanks very much for your reply in time.  I will read the above paper 
> > you referred to.
> > We just implemented simple dynamic quota according to our product 
> > requirement without many theories.
> 
> And this is quite a big "without", I fear. The timeliness guarantees
> you can give to users are based on the theory behind the algorithms we
> implement. If you change the implementation, without any proof of
> theoretical soundness, you risk to break them all.

To me, it sounds like the approach Yan is taking, is using EDF for granting 
an explicit BW of a system with guaranteed progress, so basically a small 
subset of what EDF can offer.

But if this is the case, why not let T1 and T3 grab BW from !SCHED_DEADLINE 
tasks? You already allocate 600us every 500us, so _at_minimum_ there should 
be 400us available. (yes, yes, starving out other parts of the system is 
bad, I know, especially rcuc is going to go nuts ;)
 
> But, this doesn't mean that what you did is wrong. We'd just have to
> see if can be proved to be right (in theory :)).
> 
> > In our scene some tasks are continuous for busy or idle state more than 
> > alternating busy tasks and idle task between periods.
> > So our method can get good performance during date package forwarding.
> 
> Not sure I understand this. But see below..
> 
> > Thanks for the authors to implement EDF based on linux. This schedule 
> > class has been applied in product.
> 
> And this is great news! :)
> 
> Any way you can share more information on the use-case? That would be
> helpful to also understand your solution better.
> 
> > Will EDF has dynamic quota in future?
> 
> Well, as Luca said, you can already use SCHED_DEADLINE as the backend
> for feedback scheduling (that pertain mostly to user-space).
> 
> And yes, there are already thoughts to modify it a bit to go towards
> Lipari's et al. GRUB algorithm. That would be probably helpful in
> situations like yours. But I can't give you any timing for it.

Need to read up on GRUB before involving myself in this part of the 
discussion, but I'm not sure how much I enjoy the idea of some part of 
userspace (more or less) blindly adjusting deadline-params for other tasks.


I think we need to be very careful about whether or not we're talking about 
EDF as a "CPU BW"-enforcer or a "meet a deadline for a periodic 
task"-enforcer. Those 2 will react quite differently from having their 
runtime adjusted on the fly.

Just my NOK 0.12

> > It is already having real-world impacts.
> 
> Great news again ;).

\o/

-- 
Henrik Austad
