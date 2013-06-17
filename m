Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377Ab3FQQSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:18:48 -0400
Received: from forward2h.mail.yandex.net ([84.201.187.147]:46376 "EHLO
	forward2h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab3FQQSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:18:46 -0400
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Jun 2013 12:18:46 EDT
From: Kirill Tkhai <tkhai@yandex.ru>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1371479342.18733.14.camel@gandalf.local.home>
References: <353211371220851@web23d.yandex.ru> <1371479342.18733.14.camel@gandalf.local.home>
Subject: Re: [PATCH] sched: schedule_raw_spin_unlock() and schedule_spin_unlock()
MIME-Version: 1.0
Message-Id: <575111371485546@web20h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 17 Jun 2013 20:12:26 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



17.06.2013, 18:29, "Steven Rostedt" <rostedt@goodmis.org>:
> On Fri, 2013-06-14 at 18:40 +0400, Kirill Tkhai wrote:
>
>> šdiff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> šindex 58453b8..381e493 100644
>> š--- a/kernel/sched/core.c
>> š+++ b/kernel/sched/core.c
>> š@@ -3125,6 +3125,30 @@ asmlinkage void __sched preempt_schedule_irq(void)
>> ššššššššššexception_exit(prev_state);
>> šš}
>>
>> š+/*
>> š+ * schedule_raw_spin_unlock - unlock raw_spinlock and call schedule()
>> š+ *
>> š+ * Should be used instead of the constructions
>> š+ * šš1) raw_spin_unlock_irq(lock);
>> š+ * šššššschedule();
>> š+ * ššor
>> š+ * šš2) raw_spin_unlock_irqrestore(lock, flags);
>> š+ * šššššschedule();
>
> Is there a place that does #2? If interrupts were disabled, the flags
> would keep them disabled and that would not be good when calling
> schedule.

Some drivers use _irqsave even if they are certainly enabled, I was thinking
about them. This is mistake, but people use.

Now I'm agree with you, I'll remove advice #2 to not multiply this errors.

>> š+ * where they have to be.
>> š+ *
>> š+ * It helps to prevent excess preempt_schedule() during the unlocking,
>> š+ * which can be called on preemptible kernel.
>> š+ * Returns with irqs enabled.
>> š+ */
>> š+void __sched schedule_raw_spin_unlock(raw_spinlock_t *lock)
>> š+{
>
> I agree with the idea of adding this, but I don't like this
> implementation. Also, if this is to enable interrupts, the name must
> represent that:
>
> ššschedule_raw_spin_unlock_irq()
>
> You can't just enable them if they were not disabled. That will break
> things like lockdep.

Ok, and in addition may be useful schedule_raw_spin_unlock() for
use in cases like this happens in fs/*

>> š+ preempt_disable();
>> š+ raw_spin_unlock_irq(lock);
>> š+ sched_preempt_enable_no_resched();
>
> This is the easy way of implementing this, but it does add a slight
> overhead here. Adding and subtracting preempt count just to prevent the
> disable does add a bit more computation. I've done this in the tracing
> code, but its within the tracing and in an unlikely path. The overhead
> is not common. But I can see this being in a fast path and not something
> that we want to add overhead to.
>
> The ideal solution is not the easy one. It is to introduce a real
> schedule_raw_spin_unlock() that is a copy of raw_spin_unlock() that does
> not call preempt_enable, but calls preempt_enable_no_resched() instead,
> and then does the schedule.

Ok

> -- Steve
>
>> š+ schedule();
>> š+}
>> š+EXPORT_SYMBOL(schedule_raw_spin_unlock);
>> š+
>> šš#endif /* CONFIG_PREEMPT */
>>
>> ššint default_wake_function(wait_queue_t *curr, unsigned mode, int wake_flags,
