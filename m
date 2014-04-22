Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429AbaDVRK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 13:10:57 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:44858 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933025AbaDVRKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 13:10:54 -0400
From: bsegall@google.com
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, <rostedt@goodmis.org>,
        <fweisbec@gmail.com>, <mingo@redhat.com>, <acme@ghostprotocols.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/8] sched/core: Skip wakeup when task is already running.
References: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com>
	<51238bf1648b1f4c66d3547a49cf949d1679d068.1397562542.git.yangds.fnst@cn.fujitsu.com>
	<20140415135326.GV11096@twins.programming.kicks-ass.net>
	<534E59FC.2090001@cn.fujitsu.com> <535658DB.2090801@cn.fujitsu.com>
Date: Tue, 22 Apr 2014 10:10:52 -0700
In-Reply-To: <535658DB.2090801@cn.fujitsu.com> (Dongsheng Yang's message of
	"Tue, 22 Apr 2014 20:56:11 +0900")
Message-ID: <xm26sip55lyb.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dongsheng Yang <yangds.fnst@cn.fujitsu.com> writes:

> On 04/16/2014 07:22 PM, Dongsheng Yang wrote:
>> On 04/15/2014 10:53 PM, Peter Zijlstra wrote:
>>> On Tue, Apr 15, 2014 at 09:32:53PM +0900, Dongsheng Yang wrote:
>>>
>>> How can you get there with ->state == RUNNING? try_to_wake_up*() bail
>>> when !(->state & state).
>> Yes, try_to_wake_up() did this check. But other callers would miss it.
>>
>> With the following code ,I can get the actual message of waking up
>> a running task
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 9f63275..1369cae 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -1418,8 +1418,10 @@ static void ttwu_activate(struct rq *rq, struct
>> task_stru
>>  static void
>>  ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
>>  {
>> -       if (p->state == TASK_RUNNING)
>> +       if (p->state == TASK_RUNNING) {
>> +               printk("Wakeup a running task.");
>>                 return;
>> +       }
>>
>>         check_preempt_curr(rq, p, wake_flags);
>>         trace_sched_wakeup(p, true);
>>
>>
>> # grep "Wakeup" /var/log/messages
>> Apr 15 20:16:21 localhost kernel: [    5.436505] Wakeup a running task.
>> Apr 15 20:16:21 localhost kernel: [    7.776042] Wakeup a running task.
>> Apr 15 20:16:21 localhost kernel: [    9.324274] Wakeup a running task.
>
> Hi Peter, after some more investigation, I think I got the problem, which is
> that
> some other task set p->state to TASK_RUNNING without holding p->pi_lock.
>
> Scenario as attached graph shown, if some other task set p->state to
> TASK_RUNNING after the check  if (! (p->state & state)), then we are
> wasting time to wake up a running task in try_to_wake_up().
>
> If the analyse is right, I think there are two methods to solve this problem:
>     * Skip in ttwu_do_wakeup() when p->state is running, as what my patch
> did.
>     * Add a locking when we set p->state, lots of work to do and I am afraid
> it will hurt the performance of kernel.

This is all expected behavior, and the somewhat less than useful trace
events are expected. A task setting p->state to TASK_RUNNING without
locks is fine if and only p == current. The standard deschedule loop is
basically:

while (1) {
  set_current_state(TASK_(UN)INTERRUPTIBLE);
  if (should_still_sleep)
    schedule();
}
set_current_state(TASK_RUNNING);

Which can produce this in a race.

The only problem this causes is a wasted check_preempt_curr call in the
racing case, and a somewhat inaccurate sched:sched_wakeup trace event.
Note that even if you did recheck in ttwu_do_wakeup you could still race
and get an "inaccurate" trace event. Heck, even if the ttwu is
_necessary_ because p is currently trying to take rq->lock to
deschedule, you won't get a matching sched_switch event, because the
ttwu is running before schedule is.

You could sorta fix this I guess by tracking every write to p->state
with trace events, but that would be a somewhat different change, and
might be considered too expensive for all I know (and the trace events
could /still/ be resolved in a different order across cpus compared to
p->state's memory).
