Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbaEKPYY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 11:24:24 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:37421 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbaEKPYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 11:24:23 -0400
MIME-Version: 1.0
In-Reply-To: <536F90BE.2080806@gmail.com>
References: <53683B14.3060702@cn.fujitsu.com>
	<1399341154-11785-1-git-send-email-yangds.fnst@cn.fujitsu.com>
	<20140510152902.GW11096@twins.programming.kicks-ass.net>
	<536F90BE.2080806@gmail.com>
Date: Sun, 11 May 2014 23:24:22 +0800
Message-ID: <CA+qeAOr_PrBuo+qfjNoaZyHF21p=8UgQy1oZOjAxahhYTyrvLQ@mail.gmail.com>
Subject: Fwd: [PATCH] sched: Distinguish sched_wakeup event when wake up a
 task which did schedule out or not.
From: Dongsheng Yang <dongsheng081251@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "yangds.fnst" <yangds.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        bsegall@google.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2014 11:29 PM, Peter Zijlstra wrote:
>
> On Tue, May 06, 2014 at 10:52:34AM +0900, Dongsheng Yang wrote:
>>
>> ttwu_do_wakeup() is called when the task's state is switched back to
>> TASK_RUNNING, whether or not the task actually scheduled out. Tracing
>> the wakeup event when the task never scheduled out is quite confusing.
>>
>> This patch take the use of 'success' parameter in sched_wakeup tracepoint,
>> to indicate that the task we are waking up did schedule out or just
>> change its state to TASK_RUNNING.
>>
>> success is true:
>>         task was out of run queue and sleeping, we are really wake it up.
>> success is false:
>>         taks was on run queue all the time and we just change its state
>>         to TASK_RUNNING.
>
> No, I think this patch is crap and doesn't actually change anything
> much, at best it simply reduces the size of the race window.
>
> I also think you're trying to solve something that cannot be solved.


Actually, this patch does not attempt to solve the race condition.
It only want to avoid sched:sched_wakeup with success==true in
a fake wakeup, as explained below.

> So the fundamental wait loop is:
>
>    for (;;) {
>         set_current_state(TASK_UNINTERRUPTIBLE);
>         if (cond)
>                 break;
>         schedule();
>    }
>    __set_task_state(TASK_RUNNING);
>
> And the fundamental wakeup is:
>
>    cond = true;
>    wake_up_process(TASK_NORMAL);
>
> And this is very much on purpose a lock-free but strictly ordered
> scenario. It is a variation of:
>
>    X = Y = 0
>
>    (wait)       (wake)
>    [w] X = 1    [w] Y = 1
>    MB           MB
>    [r] Y                [r] X
>
> [ where: X := state, Y := cond ]
>
> And we all 'know' that the only provided guarantee is that:
>    X==0 && Y==0
> is impossible -- but only that, all 3 other states are observable.
>
> This guarantee means that its impossible to both miss the condition and
> the wakeup; iow. it guarantees fwd progress.
>
> OTOH its fundamentally racy, nothing guarantees we will not 'observe' both
> the condition and the wakeup.
>
> The setting of .success=false when ->on_rq is actively wrong, suppose
> the waiter has already observed cond==false but has not yet gotten to
> schedule(), at that point the wakeup happens and sees ->on_rq==1. The
> wakeup is still very much a real wakeup.


Yes, if a wakeup happens before schedule(), wakeup
sees ->on_rq==1. Then we can get an event with .success==false.
But I think it is not a real wakeup. :(

Yes, at this moment, maybe the task is already out of run queue.
But *this* wakeup did not move it back to run queue, it only
change the state of it to TASK_RUNNING. I believe the next
wakeup for this task will do the real wake up moving it back
to run queue.

And if scheduler really wake it up, we can get an event with success==true.

Anyway, what I want with this patch is to make scheduler raise accurate
events when waking up a task.

If a wakeup only change the state of task, raise a event with success==false.
If a wakeup move a task back to runqueue, .success==true.

It means, we do not need to care about the task is on_rq or not currently,
the value of .success is decided by the behavior we did in the function
of try_to_wake_up().

Wish I explain myself clearly.

Thanx :)

>
> If it were not for that wakeup the waiter would have gone to sleep and
> missed the update of condition.
>
> So no.. not going to happen. And certainly not with such a crappy
> Changelog.
>
> And a frozen seafood of choice lobbed at Steven for not seeing this :-)
>
