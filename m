Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbaGAAxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 20:53:52 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:63500 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaGAAxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 20:53:51 -0400
MIME-Version: 1.0
In-Reply-To: <CANGgnMYcSoJa32CdGBxvj0c3NEnU=S=DD35YmZAtn8miCtK6kw@mail.gmail.com>
References: <CANGgnMbHckBQdKGN_N5Q6qEKc9n1CenxvMpeXog1NbSdL8UrTw@mail.gmail.com>
 <CANGgnMYDXerOUDOO9-RHMJKadKACA2KBGskZwoP-1ZwAhDEfVA@mail.gmail.com>
 <CAFLxGvxfBt7OvW=a2Kz08GLHSEiiOZsN-vB19CXnQiwqFxqMsA@mail.gmail.com>
 <CANGgnMYVoP-Z0Bv-VDEkJnvfa7Fi4-zY2F4A0PhMewGvwo3VVw@mail.gmail.com>
 <alpine.DEB.2.10.1406270027300.5170@nanos> <CANGgnMa+qtgJ3wwg_h5Rynw5vEvZpQZ6PvaUfXNQ8+Y3Yu5U0g@mail.gmail.com>
 <alpine.DEB.2.10.1406271249510.5170@nanos> <CANGgnMYcSoJa32CdGBxvj0c3NEnU=S=DD35YmZAtn8miCtK6kw@mail.gmail.com>
From: Austin Schuh <austin@peloton-tech.com>
Date: Mon, 30 Jun 2014 17:53:30 -0700
Message-ID: <CANGgnMbhYB4VY+4L7qrWvRomi6tRjK+7hs7qBXzsDLND_sjpFA@mail.gmail.com>
Subject: Re: Filesystem lockup with CONFIG_PREEMPT_RT
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 5:12 PM, Austin Schuh <austin@peloton-tech.com> wrote:
> On Fri, Jun 27, 2014 at 7:24 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> On Thu, 26 Jun 2014, Austin Schuh wrote:
>>> If I'm reading the rt patch correctly, wq_worker_sleeping was moved
>>> out of __schedule to sched_submit_work.  It looks like that changes
>>> the conditions under which wq_worker_sleeping is called.  It used to
>>> be called whenever a task was going to sleep (I think).  It looks like
>>> it is called now if the task is going to sleep, and if the task isn't
>>> blocked on a PI mutex (I think).
>>>
>>> If I try the following experiment
>>>
>>>  static inline void sched_submit_work(struct task_struct *tsk)
>>>  {
>>> +   if (tsk->state && tsk->flags & PF_WQ_WORKER) {
>>> +     wq_worker_sleeping(tsk);
>>> +     return;
>>> +   }
>>>
>>> and then remove the call later in the function, I am able to pass my test.
>>>
>>> Unfortunately, I then get a recursive pool spinlock BUG_ON after a
>>> while (as I would expect), and it all blows up.
>>
>> Well, that's why the check for !pi_blocked_on is there.
>>
>>> I'm not sure where to go from there.  Any changes to the workpool to
>>> try to fix that will be hard, or could affect latency significantly.
>>
>> Completely untested patch below.
>>
>> Thanks,
>>
>>         tglx
>>
>> --------------------->
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 8749d20..621329a 100644
>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>> index be0ef50..0ca9d97 100644
>> --- a/kernel/workqueue.c
>> +++ b/kernel/workqueue.c
>> @@ -849,25 +882,18 @@ void wq_worker_sleeping(struct task_struct *task)
>>                 return;
>>
>>         worker->sleeping = 1;
>> -       spin_lock_irq(&pool->lock);
>> +
>>         /*
>>          * The counterpart of the following dec_and_test, implied mb,
>>          * worklist not empty test sequence is in insert_work().
>>          * Please read comment there.
>> -        *
>> -        * NOT_RUNNING is clear.  This means that we're bound to and
>> -        * running on the local cpu w/ rq lock held and preemption
>> -        * disabled, which in turn means that none else could be
>> -        * manipulating idle_list, so dereferencing idle_list without pool
>> -        * lock is safe.
>>          */
>>         if (atomic_dec_and_test(&pool->nr_running) &&
>>             !list_empty(&pool->worklist)) {
>
> What guarantees that this pool->worklist access is safe?  Preemption
> isn't disabled.

I think I might have an answer for my own question, but I would
appreciate someone else to double check.  If list_empty erroneously
returns that there is work to do when there isn't work to do, we wake
up an extra worker which then goes back to sleep.  Not a big loss.  If
list_empty erroneously returns that there isn't work to do when there
is, this should only be because someone is modifying the work list.
When they finish, as far as I can tell, all callers then check to see
if a worker needs to be started up, and start one.

Austin
