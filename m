Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab3EVPSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 11:18:40 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:55432 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab3EVPSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 11:18:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAK7N6vqcP+fcR0NYUzGDYT6q62KePTrg8yhQkuBq_zetkwUmUw@mail.gmail.com>
References: <1369065716-22801-1-git-send-email-fweisbec@gmail.com>
	<1369065716-22801-7-git-send-email-fweisbec@gmail.com>
	<CAK7N6voNjWrDJNzAaVAndt8cGWR+AAERs_C-oCWe0rRO=XuutQ@mail.gmail.com>
	<519B26FD.9080404@linux.vnet.ibm.com>
	<CAK7N6vqcP+fcR0NYUzGDYT6q62KePTrg8yhQkuBq_zetkwUmUw@mail.gmail.com>
Date: Wed, 22 May 2013 17:18:37 +0200
Message-ID: <CAFTL4hwCQEr+aD8LG2QG13Jwxk+J2GOkU+Y9k179TnL7V+50AA@mail.gmail.com>
Subject: Re: [RFC PATCH 6/8] kthread: Enable parking requests from setup() and
 unpark() callbacks
From: Frederic Weisbecker <fweisbec@gmail.com>
To: anish singh <anish198519851985@gmail.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Don Zickus <dzickus@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/21, anish singh <anish198519851985@gmail.com>:
> On Tue, May 21, 2013 at 1:19 PM, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> On 05/21/2013 11:04 AM, anish singh wrote:
>>> On Mon, May 20, 2013 at 9:31 PM, Frederic Weisbecker <fweisbec@gmail.com>
>>> wrote:
>>>> When the watchdog code is boot-disabled by the user, for example
>>>> through the 'nmi_watchdog=0' boot option, the setup() callback of
>>>> the watchdog kthread requests to park the task, and that until the
>>>> user later re-enables the watchdog through sysctl or procfs.
>>>>
>>>> However the parking request is not well handled when done from
>>>> the setup() callback. After ->setup() is called, the generic smpboot
>>>> kthread loop directly tries to call the thread function or wait
>>>> for some event if ->thread_should_run() is false.
>>>>
>>>> In the case of the watchdog kthread, ->thread_should_run() returns
>>>> false and the kthread goes to sleep and wait for the watchdog timer
>>>> to wake it up. But the timer is not enabled since the user requested
>>>> to disable the watchdog. We want the kthread to park instead of waiting
>>>> for events that can't happen.
>>>>
>>>> As a result, later unpark requests after sysctl write through
>>>> 'sysctl -w kernel.watchdog=1' won't wake up/unpark the task as
>>>> expected, since it's not parked anyway, leaving the value modified
>>>> without triggering any action.
>>> Out of curiosity, this can happen only for short period of time
>>> right?After
>>> some time this will work right as the thread get back in action
>>> after the schedule call.Then sysctl and procfs will work I think.
>>
>> kthread_unpark() can wake up a task only if the task is in TASK_PARKED
>> state. But since the above task would be in TASK_INTERRUPTIBLE state
>> (since it is not parked), kthread_unpark() will be powerless to do
>> anything.
> Yes but this will happen only for a short period of time right?
> After the schdule() call the below code gets executed in while() loop.
>
> if (kthread_should_park()) {
> __set_current_state(TASK_RUNNING);
> preempt_enable();
> if (ht->park && td->status == HP_THREAD_ACTIVE) {
> BUG_ON(td->cpu != smp_processor_id());
> ht->park(td->cpu);
> td->status = HP_THREAD_PARKED;
> }
> kthread_parkme();
> /* We might have been woken for stop */
> continue;
> }
>
> As we have already called kthread_park this above if() condition gets true
> and
> it will park the thread wouldn't it?But this will happen after the schedule
> call which is not right as mentioned by fredrick.
>

But we are scheduling in TASK_INTERRUPTIBLE mode so we are going to
sleep until some other thread wake us. But we are
unparked instead of being awoken. This just have no effect because
kthread_unpark() is a no-op on non-parked kthreads.
