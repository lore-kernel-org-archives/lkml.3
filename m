Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbaLKQuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 11:50:37 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:38895 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217AbaLKQuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 11:50:35 -0500
Date: Thu, 11 Dec 2014 17:50:31 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] tracing/sched: Check preempt_count() for current when
 reading task->state
Message-ID: <20141211165031.GA29411@gmail.com>
References: <20141210174428.3cb7542a@gandalf.local.home>
 <20141211063811.GD5059@gmail.com>
 <20141211063712.5cf4d240@gandalf.local.home>
 <20141211123121.GB18538@gmail.com>
 <20141211091747.6cecf1ef@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141211091747.6cecf1ef@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 11 Dec 2014 13:31:21 +0100
> Ingo Molnar <mingo@kernel.org> wrote:
> 
>  
> > > What overhead are you worried about? Note, this is in the 
> > > schedule tracepoint and does not affect the scheduler itself 
> > > (as long as the tracepoint is not enabled).
> > 
> > Scheduler tracepoints are pretty popular, so I'm worried about 
> > their complexity when they are activated.
> 
> Understood.
> 
> > 
> > > I'm also thinking that as long as "prev" is always guaranteed 
> > > to be "current" we can remove the check and just use 
> > > preempt_count() always. But I'm worried that we can't 
> > > guaranteed that.
> > 
> > You could add a WARN_ON_ONCE() or so to double check that 
> > assumption?
> 
> I actually thought about that, but that gives us the same overhead as
> the branch we want to remove.
> 
> But if you are going for simpler, then that would make sense.
> 
> > 
> > > What other ideas do you have? Because wrong data is worse than 
> > > the overhead of the above code. If Thomas taught me anything, 
> > > it's that!
> > 
> > My idea is to have simpler, yet correct code. And ponies!
> 
> 
> So something like this instead?
> 
> -- Steve
> 
> 
> diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
> index 0a68d5ae584e..782018b135ff 100644
> --- a/include/trace/events/sched.h
> +++ b/include/trace/events/sched.h
> @@ -97,10 +97,12 @@ static inline long __trace_sched_switch_state(struct task_struct *p)
>  	long state = p->state;
>  
>  #ifdef CONFIG_PREEMPT
> +	WARN_ON_ONCE(p != current);
> +
>  	/*
>  	 * For all intents and purposes a preempted task is a running task.
>  	 */
> -	if (task_preempt_count(p) & PREEMPT_ACTIVE)
> +	if (preempt_count() & PREEMPT_ACTIVE)
>  		state = TASK_RUNNING | TASK_STATE_MAX;

Yeah, that looks a lot better IMHO, 'p' is supposed to be the 
current task, at least on a booted up system with a working 
scheduler. Not sure about transient initialization states such as 
very early boot and idle thread initialization - but it might 
work out for them as well.

If the WARN_ON_ONCE() remains silent on your testbox then I'd 
suggest removing the WARN_ON_ONCE(), the change looks good to me:

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
