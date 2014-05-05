Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbaEEHcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 03:32:08 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:55675 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754635AbaEEHcH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 03:32:07 -0400
X-IronPort-AV: E=Sophos;i="4.97,985,1389715200"; 
   d="scan'208";a="30072229"
Message-ID: <53673074.1040406@cn.fujitsu.com>
Date: Mon, 5 May 2014 15:32:20 +0900
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, <bsegall@google.com>,
        <rostedt@goodmis.org>
CC: <fweisbec@gmail.com>, <mingo@redhat.com>, <acme@ghostprotocols.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/8] sched/core: Skip wakeup when task is already running.
References: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com> <51238bf1648b1f4c66d3547a49cf949d1679d068.1397562542.git.yangds.fnst@cn.fujitsu.com> <20140415135326.GV11096@twins.programming.kicks-ass.net> <534E59FC.2090001@cn.fujitsu.com> <535658DB.2090801@cn.fujitsu.com> <xm26sip55lyb.fsf@sword-of-the-dawn.mtv.corp.google.com> <20140422181820.GT26782@laptop.programming.kicks-ass.net>
In-Reply-To: <20140422181820.GT26782@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all，
Thanx for your reply, and sorry for the late.

On 04/23/2014 03:18 AM, Peter Zijlstra wrote:
> On Tue, Apr 22, 2014 at 10:10:52AM -0700, bsegall@google.com wrote:
>> This is all expected behavior, and the somewhat less than useful trace
>> events are expected. A task setting p->state to TASK_RUNNING without
>> locks is fine if and only p == current. The standard deschedule loop is
>> basically:
>>
>> while (1) {
>>    set_current_state(TASK_(UN)INTERRUPTIBLE);
>>    if (should_still_sleep)
>>      schedule();
>> }
>> set_current_state(TASK_RUNNING);
>>
>> Which can produce this in a race.
>>
>> The only problem this causes is a wasted check_preempt_curr call in the
>> racing case, and a somewhat inaccurate sched:sched_wakeup trace event.
>> Note that even if you did recheck in ttwu_do_wakeup you could still race
>> and get an "inaccurate" trace event.

Yes, even I recheck it in ttwu_do_wakeup(), I could still race.

Now I can not catch up a good idea to avoid this race.
But I think it is not too expensive.

About the event of sched:sched_wakeup we can get the bug information
as I mentioned at the first mail of this thread:

[root@yds-PC linux]# perf sched latency|tail
bash:25186 | 0.410 ms | 1 | avg: 0.000 ms | max: 0.000 ms | max at: 
0.000000 s
bash:25174 | 0.407 ms | 1 | avg: 0.000 ms | max: 0.000 ms | max at: 
0.000000 s
bash:25268 | 0.367 ms | 1 | avg: 0.000 ms | max: 0.000 ms | max at: 
0.000000 s
bash:25279 | 0.358 ms | 1 | avg: 0.000 ms | max: 0.000 ms | max at: 
0.000000 s
bash:25238 | 0.286 ms | 1 | avg: 0.000 ms | max: 0.000 ms | max at: 
0.000000 s
-----------------------------------------------------------------------------------------
TOTAL: | 1344.539 ms | 9604 |
---------------------------------------------------
*INFO: 0.557% state machine bugs (51 out of 9161)*

It is caused by the issue we discussed in this thread, that ttwu_do_wakeup()
could be called to wakeup a task which is on run queue.

There are two solutions in my mind:
* Add a new trace event, such as sched:sched_enqueue. Then we can trace
the event of it and get the timestamp when a task enqueue and start waiting
cpu. In this way, we can calculate the latency time with
(sched_in_time - sched_enqueue_time) in `perf sched latency`.

* Move the current trace point from ttwu_do_wakeup() to
ttwu_activate(). Currently the sched:sched_wakeup can tell user very little.
When we get a sched:sched_wakeup:
a) We can not say a task is inserted into run queue, it is also used for 
task
which is on_rq and only change the task->state to TASK_RUNNING.
b) We can not say the task->state is changed from {UN}INTERRUPTABLE to
RUNNING, sometimes task->state is already changed to RUNNING by other cpu.

I prefer the second one, anyway, current sched_wakeup tells user none.

>> Heck, even if the ttwu is
>> _necessary_ because p is currently trying to take rq->lock to
>> deschedule, you won't get a matching sched_switch event, because the
>> ttwu is running before schedule is.
>>
>> You could sorta fix this I guess by tracking every write to p->state
>> with trace events, but that would be a somewhat different change, and
>> might be considered too expensive for all I know (and the trace events
>> could /still/ be resolved in a different order across cpus compared to
>> p->state's memory).
> Ah, you're saying that a second task could try a spurious wakeup between
> set_current_state() and schedule(). Yes, that'll trigger this indeed.
>
>
> .
>

