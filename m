Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbaFQCp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 22:45:29 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:30787 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbaFQCp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 22:45:28 -0400
Message-ID: <539FAB4D.6000702@huawei.com>
Date: Tue, 17 Jun 2014 10:43:25 +0800
From: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Luca Abeni <luca.abeni@unitn.it>
CC: Henrik Austad <henrik@austad.us>, Juri Lelli <juri.lelli@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        <duzhiping.du@huawei.com>, <xiaofeng.yan2012@gmail.com>,
        <raistlin@linux.it>, <tkhai@yandex.ru>,
        <harald.gustafsson@ericsson.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] sched/deadline: EDF dynamic quota design
References: <537348DA.7080001@huawei.com> <20140514113245.GZ11096@twins.programming.kicks-ass.net> <53736CD9.90805@unitn.it> <5374A335.90705@huawei.com> <20140515143132.c3199bec4476065cc843277d@gmail.com> <20140516071141.GA28755@austad.us> <537C9FE1.8060603@unitn.it>
In-Reply-To: <537C9FE1.8060603@unitn.it>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.133]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/21 20:45, Luca Abeni wrote:
> Hi,
>
> first of all, sorry for the ultra-delayed reply: I've been busy,
> and I did not notice this email... Anyway, some comments are below
>
> On 05/16/2014 09:11 AM, Henrik Austad wrote:
> [...]
>>>>> This can also be implemented in user-space (without modifying the
>>>>> scheduler)
>>>>> by having a daemon that monitors the SCHED_DEADLINE tasks and changes
>>>>> their
>>>>> runtimes based on some kind of feedback (for example, difference
>>>>> between the
>>>>> scheduling deadline of a task and its actual deadline - if this
>>>>> information
>>>>> is made available by the scheduler). I developed a similar
>>>>> implementation in
>>>>> the past (not based on SCHED_DEADLINE, but on some previous
>>>>> implementation
>>>>> of the CBS algorithm).
>>
>> This sounds like a very slow approach. What if the extra BW given by 
>> T2 was
>> for one period only? There's no way you could create a userspace 
>> daemon to
>> handle that kind of budget-tweaking.
> Right. With "This can also be implemented in user-space..." I was 
> referring
> to the feedback scheduling (adaptive reservation) approach, which is 
> designed
> to "auto-tune" the reservation budget following slower variations (it 
> is like
> a low-pass filter, which can set the budget to something between the 
> average
> used budget and the largest one). Basically, it works on a larger time 
> scale.
> If you want a "per-period" runtime donation, you need a reclaiming 
> mechanism
> like GRUB, CASH, or similar, which needs to be implemented in the kernel.
>
>
>> Also, it sounds like a *really* dangerous idea to let some random (tm)
>> userspace daemon adjust the deadline-budget for other tasks in the 
>> system
>> based on an observation of spent budget for the last X seconds. It's not
>> military funding we're concerned with here.
>>
>> When you state your WCET, it is not because you need -exactly- that 
>> budget,
>> it is because you should *never* exceed that kind of rquired
>> computational time.
> Exact. But the idea of feedback scheduling was that sometimes you do 
> not know
> the WCET... You can guess it, or measure it over a large number of 
> runs (but
> the Murphy law ensures that you will miss the worst case anyway ;-).
> And there are situations in which you do not need to respect all of the
> deadlines... The daemon I was talking about just monitors the 
> difference between
> the scheduling deadline and the "real job deadline" for some tasks, in 
> order to
> understand if the runtime they have been assigned is enough or not... 
> If some
> task is not receiving enough runtime (that is, if the difference 
> between its
> scheduling deadline and the "real deadline" becomes too large), the 
> daemon
> tries to increase its runtime. When the system is overloaded (that is, 
> everyone
> of the monitored tasks wants too much runtime, and the admission 
> control fails),
> the daemon decreases the runtimes according to the weight of the tasks...
> Of course, the daemon does not have to monitor all of the 
> SCHED_DEADLINE tasks
> in the system, but only the ones for which adaptive reservations are 
> useful
> (tasks for which the WCET is not known for sure, and that can 
> tollerate some
> missed deadlines). The other SCHED_DEADLINE tasks can stay with their 
> fixed
> runtimes unchanged.
>
>
>> Blindly reducing allocated runtime is defeating that whole purpose.
> Of course, there could be a minimum guaranteed runtime per task.
>
>> Granted, if you use EDF for BW-control only, it could be done - but then
>> the thread itself should do that. Real-time is not about being fair. 
>> Heck,
>> it's not even about being optimal, it's about being predictable and
>> "dynamically adjusting" is not!
> Well, this could lead to a long discussion, in which everyone is right 
> and
> everyone is wrong... Let's say that it depends on the applications 
> requirements
> and constraints.
>
> [...]
>>>> Will EDF has dynamic quota in future?
>>>
>>> Well, as Luca said, you can already use SCHED_DEADLINE as the backend
>>> for feedback scheduling (that pertain mostly to user-space).
>>>
>>> And yes, there are already thoughts to modify it a bit to go towards
>>> Lipari's et al. GRUB algorithm. That would be probably helpful in
>>> situations like yours. But I can't give you any timing for it.
>>
>> Need to read up on GRUB before involving myself in this part of the
>> discussion, but I'm not sure how much I enjoy the idea of some part of
>> userspace (more or less) blindly adjusting deadline-params for other 
>> tasks.
> No, GRUB does not involve the user-space adjusting any scheduling 
> parameter.
> GRUB is a reclaiming algorithm, which works in a different way respect to
> the feedback scheduling approach I described, and requires 
> modifications in
> the scheduler.
> The basic ideas are (warning! This is an over-simplification of the 
> algorithm! :)
> - You assign runtime and period to each SCHED_DEADLINE task as usual
> - Each task is guaranteed to receive its runtime every period
> - You can also define a maximum fraction Umax of the CPU time that the
>   SCHED_DEADLINE tasks can use. Note that Umax _must_ be larger or equal
>   than sum_i runtime_i / period_i
>   (note: in the original GRUB paper, only one CPU is considered, and 
> Umax is
>   set equal to 1)
> - If the tasks are consuming less than Umax, then the scheduling 
> algorithm
>   allows them to use more runtime (but not less than the guaranteed 
> runtime_i)
>   in order to use up to Umax.
>   This is achieved by modifying the rule used to decrease the runtime: in
>   SCHED_DEADLINE, if a task executes for a time delta, its runtime is 
> decreased
>   by delta; using GRUB, it would be decreased by a smaller amount of time
>   (computed based on Umax, on the active SCHED_DEADLINE tasks, etc...).
>   This requires to implement some kind of state machine (the details 
> are in
>   the GRUB paper)
>
> I also had an implementation of the GRUB algorithm (based on a 
> modification
> of my old CBS scheduler for Linux), but the computational complexity 
> of the
> algorithm was too high. That's why I never proposed to merge it in 
> SCHED_DEADLINE.
> But maybe there can be some trade-off between the "exact compliance 
> with the
> GRUB algorithm" and implementation efficiency that can make it 
> acceptable...
>
>
Has these  codes been opened about the implementation in some community 
or not ?
Could you tell me where I should get the program from?
  I would like to test your solution in our scene.

Thanks
Yan
>> I think we need to be very careful about whether or not we're talking 
>> about
>> EDF as a "CPU BW"-enforcer or a "meet a deadline for a periodic
>> task"-enforcer. Those 2 will react quite differently from having their
>> runtime adjusted on the fly.
> Well, IMHO the nice thing about SCHED_DEADLINE is that it can be both :)
> It depends on how you configure the scheduling parameters.
>
>
>             Luca
>
> .
>


