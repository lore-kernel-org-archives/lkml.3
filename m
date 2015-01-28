Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbbA2BlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:41:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:51061 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275AbbA2BlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:41:21 -0500
Date: Wed, 28 Jan 2015 16:50:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/4] sched: Pull preemption disablement to __schedule()
 caller
Message-ID: <20150128155044.GJ23038@twins.programming.kicks-ass.net>
References: <1422404652-29067-1-git-send-email-fweisbec@gmail.com>
 <1422404652-29067-4-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422404652-29067-4-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 01:24:11AM +0100, Frederic Weisbecker wrote:
> +++ b/kernel/sched/core.c
> @@ -2760,7 +2760,6 @@ static void __sched __schedule(void)
>  	struct rq *rq;
>  	int cpu;
>  
> -	preempt_disable();

Implies barrier();

>  	cpu = smp_processor_id();
>  	rq = cpu_rq(cpu);
>  	rcu_note_context_switch();
> @@ -2822,8 +2821,6 @@ static void __sched __schedule(void)
>  		raw_spin_unlock_irq(&rq->lock);
>  
>  	post_schedule(rq);

implies barrier();

> -
> -	sched_preempt_enable_no_resched();
>  }
>  
>  static inline void sched_submit_work(struct task_struct *tsk)

> @@ -2883,9 +2882,9 @@ void __sched schedule_preempt_disabled(void)
>  static void preempt_schedule_common(void)
>  {
>  	do {
> -		preempt_count_add(PREEMPT_ACTIVE);
> +		preempt_count_add(PREEMPT_ACTIVE + PREEMPT_CHECK_OFFSET);

Does _NOT_ imply barrier();

>  		__schedule();
> -		preempt_count_sub(PREEMPT_ACTIVE);

idem.

> +		preempt_count_sub(PREEMPT_ACTIVE + PREEMPT_CHECK_OFFSET);
>  
>  		/*
>  		 * Check again in case we missed a preemption opportunity
