Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbaEOMal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 08:30:41 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:56550 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbaEOMaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 08:30:39 -0400
Date: Thu, 15 May 2014 14:31:32 +0200
From: Juri Lelli <juri.lelli@gmail.com>
To: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
Cc: Luca Abeni <luca.abeni@unitn.it>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, <duzhiping.du@huawei.com>,
        <xiaofeng.yan2012@gmail.com>, <raistlin@linux.it>, <henrik@austad.us>,
        <tkhai@yandex.ru>, <harald.gustafsson@ericsson.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFD] sched/deadline: EDF dynamic quota design
Message-Id: <20140515143132.c3199bec4476065cc843277d@gmail.com>
In-Reply-To: <5374A335.90705@huawei.com>
References: <537348DA.7080001@huawei.com>
	<20140514113245.GZ11096@twins.programming.kicks-ass.net>
	<53736CD9.90805@unitn.it>
	<5374A335.90705@huawei.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[Cc-ed lkml again to include Luca's reply]

and thanks to Luca for his reply!

On Thu, 15 May 2014 19:21:25 +0800
"xiaofeng.yan" <xiaofeng.yan@huawei.com> wrote:

> On 2014/5/14 21:17, Luca Abeni wrote:
> > Hi Peter,
> >
> > thanks for adding me in cc :)
> > This dynamic quota design looks similar to some resource reclaiming 
> > algorithm
> > known in literature, and might be related to some feedback scheduling 
> > ideas.
> > More details below...
> >
> > On 05/14/2014 01:32 PM, Peter Zijlstra wrote:
> > [...]
> >>> * Example.
> >>>    Three tasks: T1,T2,T3. Their initial status is as follows,
> >>>    T1(200us,500us,500us)
> >>>    T2(200us,500us,500us)
> >>>    T3(200us,500us,500us)
> >>>
> >>>    At time t1, the tasks' running status is as follows,
> >>>    T1(200us,500us,500us)
> >>>    T2(100us,500us,500us)
> >>>    T3(200us,500us,500us)
> >>>    Busy tasks: T1,T3
> >>>    Idle task:  T2
> >>>    Bandwidth pool: 20%
> >>>
> >>>    Now, there are 20% quota in the bandwidth pool, T1 or T3 get 5% 
> >>> quota
> >>>    (adjustable) from the bandwidth pool when they enter run-queue.
> >>>    Then, the status is as follows:
> >>>    T1(225us,500us,500us)
> >>>    T2(100us,500us,500us)
> >>>    T3(225us,500us,500us)
> >>>    Bandwidth pool: 10%
> >>>
> >>>    Busy tasks could get the quota when the bandwidth pool is not empty.
> >>>
> >>> ---------------------------------------------------------------------------------------- 
> >>>
> >>
> >> Yeah, not sure that's sound. But I'll leave that to others.
> > The idea (donating to other tasks some of the runtime reserved to a task
> > but actually unused because the task is busy) is sound, but it must be 
> > done
> > carefully, otherwise the guarantees about reserved runtimes risk to be 
> > broken.
> >
> > This (CPU reclaiming) has been investigated in the past, and a lot of 
> > possible
> > algorithms have been proposed. For example, see:
> > "Greedy reclamation of unused bandwidth in constant-bandwidth servers" by
> > Lipari and others:
> > http://scholar.google.com/scholar?cluster=3702635449685717385&hl=it&as_sdt=0,5 
> >
> > or
> > "Capacity sharing for overrun control" by Caccamo and others:
> > http://scholar.google.com/scholar?cluster=8595685180937180485&hl=it&as_sdt=0,5 
> >
> > and of course all of the related papers found by Scholar (I cited 
> > these two
> > papers because I can easily remember them, but there are many other).
> > There is also a nice paper by Scott Brandt that compares the 
> > implementations
> > of multiple reclaiming algorithms, but I do not remember the title.
> >
> > All of these papers provide a more sound theoretical foundation for 
> > runtime/budget
> > donation/sharing.
> >
> > As a form of shameless self-advertisement, I have also to mention that 
> > adaptive
> > reservations (feedback scheduling based on CBS/SCHED_DEADLINE) can be 
> > related,
> > allowing to dynamically adapt the runtime to the actual tasks demands.
> > For example, see "Analysis of a reservation-based feedback scheduler":
> > http://scholar.google.com/scholar?cluster=2878648944333333913&hl=it&as_sdt=0,5 
> >
> >
> > This can also be implemented in user-space (without modifying the 
> > scheduler)
> > by having a daemon that monitors the SCHED_DEADLINE tasks and changes 
> > their
> > runtimes based on some kind of feedback (for example, difference 
> > between the
> > scheduling deadline of a task and its actual deadline - if this 
> > information
> > is made available by the scheduler). I developed a similar 
> > implementation in
> > the past (not based on SCHED_DEADLINE, but on some previous 
> > implementation
> > of the CBS algorithm).
> >
> >
> > Hope these references can help someone... :)
> >
> Thanks very much for your reply in time.  I will read the above paper 
> you referred to.
> We just implemented simple dynamic quota according to our product 
> requirement without many theories.

And this is quite a big "without", I fear. The timeliness guarantees
you can give to users are based on the theory behind the algorithms we
implement. If you change the implementation, without any proof of
theoretical soundness, you risk to break them all.

But, this doesn't mean that what you did is wrong. We'd just have to
see if can be proved to be right (in theory :)).

> In our scene some tasks are continuous for busy or idle state more than 
> alternating busy tasks and idle task between periods.
> So our method can get good performance during date package forwarding.

Not sure I understand this. But see below..

> Thanks for the authors to implement EDF based on linux. This schedule 
> class has been applied in product.

And this is great news! :)

Any way you can share more information on the use-case? That would be
helpful to also understand your solution better.

> Will EDF has dynamic quota in future?

Well, as Luca said, you can already use SCHED_DEADLINE as the backend
for feedback scheduling (that pertain mostly to user-space).

And yes, there are already thoughts to modify it a bit to go towards
Lipari's et al. GRUB algorithm. That would be probably helpful in
situations like yours. But I can't give you any timing for it.

> It is already having real-world impacts.

Great news again ;).

Thanks,

- Juri

> Thanks
> Yan
> >
> >
> >                 Luca
> >
> > .
> >
> 
> 
