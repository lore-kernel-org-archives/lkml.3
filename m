Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030354Ab3DSMrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:47:06 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:56370 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968316Ab3DSMrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:47:04 -0400
MIME-Version: 1.0
In-Reply-To: <1366345802.2855.38.camel@Wailaba2>
References: <1366305822-5499-1-git-send-email-fweisbec@gmail.com>
	<1366305822-5499-3-git-send-email-fweisbec@gmail.com>
	<1366345802.2855.38.camel@Wailaba2>
Date: Fri, 19 Apr 2013 14:47:02 +0200
Message-ID: <CAFTL4hzTbko=jArO+kFF3icDbXmZzamDr1FJL3Vx+11Q54NABg@mail.gmail.com>
Subject: Re: [PATCH 2/3] posix_timers: Defer per process timer stop after
 timers processing
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Olivier Langlois <olivier@trillion01.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/19 Olivier Langlois <olivier@trillion01.com>:
> Hi Frederic,
>>  /*
>> @@ -1279,6 +1277,7 @@ void run_posix_cpu_timers(struct task_struct *tsk)
>>       LIST_HEAD(firing);
>>       struct k_itimer *timer, *next;
>>       unsigned long flags;
>> +     struct signal_struct *sig;
>>
>>       BUG_ON(!irqs_disabled());
>>
>> @@ -1336,6 +1335,10 @@ void run_posix_cpu_timers(struct task_struct *tsk)
>>                       cpu_timer_fire(timer);
>>               spin_unlock(&timer->it_lock);
>>       }
>> +
>> +     sig = tsk->signal;
>> +     if (task_cputime_zero(&sig->cputime_expires))
>> +             stop_process_timers(sig);
>>  }
>>
>>  /*
> I have proposed a different modification for the same problem yesterday:
>
> https://lkml.org/lkml/2013/4/17/351

Hmm, that's not exactly the same problem.

>
> I might be mistaken but I believe that firing timers are not rescheduled
> in the current interrupt context. They are going to be rescheduled later
> from the task context handling the timer generated signal.

No, when the timer fires, it might generate a signal. But it won't
execute that signal right away in the same code path. Instead, after
signal generation, it may reschedule the timer if necessary then look
at the next firing timer in the list. This is all made from the same
timer interrupt context from the same call to run_posix_cpu_timers().
The signal itself is executed asynchronously. Either by interrupting a
syscall, or from the irq return path.

> Also, if the cputimer is started by posix_cpu_timer_set() without arming
> any timer, the stop_process_timers() function will never be reached.

It should. On the next timer tick that interrupt the task(s) that has
the timer, run_posix_cpu_timers() will run check_process_timers() that
may conclude with stop_process_timer() if none is running.

But then this makes me realize my patch is buggy. The fact I move
stop_process_timers() in the very end of the processing doesn't change
much the issue: another CPU may tick and cancel the
sig->cputimer.running. And if it is eventually rearmed by a
rescheduled timer, we still have a possible tiny race window against
full dynticks CPUs. Ok I need to drop that patch.

>
> My methodology to test the modifications that I have proposed is by
> adding a printk() statement inside thread_group_cputimer() where the
> cputimer is initialized and run
>
> glibc-2.17/rt/tst-cputimer1 unittest.
>
> Before the changes, the cputimer is initialized 4 times!
> I was expecting with the proposed changes to see that number reduced to
> 2 but it ended up to be even better and be only 1 because the second
> waves of posix cpu timers is set within 1 tick.
>
> If you do the same test with your changes, I think that there is a
> chance that it will not get the same positive result for the reason that
> I have stated above.
>
> To conclude, I would be very interested to get your input in posix cpu
> timer modification proposal that I did last week. My proposal is either
> too complex or I am very bad explaining it so since your knowledgable in
> the area, your input would be very helpful.
>
> https://lkml.org/lkml/2013/4/5/370

Ok I'm looking at it.

Thanks.
