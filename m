Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411Ab3FQO3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 10:29:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27053 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3FQO3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 10:29:04 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Qi5OvXUqa-MA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=NL3M0ti_pDsA:10 a=uSLg9ySp3fikFmZ17i0A:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371479342.18733.14.camel@gandalf.local.home>
Subject: Re: [PATCH] sched: schedule_raw_spin_unlock() and
 schedule_spin_unlock()
From: Steven Rostedt <rostedt@goodmis.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Date: Mon, 17 Jun 2013 10:29:02 -0400
In-Reply-To: <353211371220851@web23d.yandex.ru>
References: <353211371220851@web23d.yandex.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-14 at 18:40 +0400, Kirill Tkhai wrote:
>  
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 58453b8..381e493 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3125,6 +3125,30 @@ asmlinkage void __sched preempt_schedule_irq(void)
>  	exception_exit(prev_state);
>  }
>  
> +/*
> + * schedule_raw_spin_unlock - unlock raw_spinlock and call schedule()
> + * 
> + * Should be used instead of the constructions
> + *   1) raw_spin_unlock_irq(lock);
> + *      schedule();
> + *   or
> + *   2) raw_spin_unlock_irqrestore(lock, flags);
> + *      schedule();

Is there a place that does #2? If interrupts were disabled, the flags
would keep them disabled and that would not be good when calling
schedule.

> + * where they have to be.
> + *
> + * It helps to prevent excess preempt_schedule() during the unlocking,
> + * which can be called on preemptible kernel.
> + * Returns with irqs enabled.
> + */
> +void __sched schedule_raw_spin_unlock(raw_spinlock_t *lock)
> +{

I agree with the idea of adding this, but I don't like this
implementation. Also, if this is to enable interrupts, the name must
represent that:

  schedule_raw_spin_unlock_irq()

You can't just enable them if they were not disabled. That will break
things like lockdep.


> +	preempt_disable();
> +	raw_spin_unlock_irq(lock);
> +	sched_preempt_enable_no_resched();

This is the easy way of implementing this, but it does add a slight
overhead here. Adding and subtracting preempt count just to prevent the
disable does add a bit more computation. I've done this in the tracing
code, but its within the tracing and in an unlikely path. The overhead
is not common. But I can see this being in a fast path and not something
that we want to add overhead to.

The ideal solution is not the easy one. It is to introduce a real
schedule_raw_spin_unlock() that is a copy of raw_spin_unlock() that does
not call preempt_enable, but calls preempt_enable_no_resched() instead,
and then does the schedule.

-- Steve



> +	schedule();
> +}
> +EXPORT_SYMBOL(schedule_raw_spin_unlock);
> +
>  #endif /* CONFIG_PREEMPT */
>  
>  int default_wake_function(wait_queue_t *curr, unsigned mode, int wake_flags,


