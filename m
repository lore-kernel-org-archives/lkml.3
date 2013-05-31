Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab3EaPS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:18:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9648 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab3EaPSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:18:50 -0400
X-Authority-Analysis: v=2.0 cv=H9pZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=FEvprJy6j1wA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=U_bRVmVwb2QA:10 a=gHVwzikRIvfN3lRMVIkA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370013528.26799.49.camel@gandalf.local.home>
Subject: Re: [PATCH][RFC] tracing/context-tracking: Add
 preempt_schedule_context() for tracing
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Fri, 31 May 2013 11:18:48 -0400
In-Reply-To: <20130531134319.GE5932@somewhere>
References: <1369943981.26799.43.camel@gandalf.local.home>
	 <20130531134319.GE5932@somewhere>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-31 at 15:43 +0200, Frederic Weisbecker wrote:

> > +void __sched notrace preempt_schedule_context(void)
> > +{
> > +	struct thread_info *ti = current_thread_info();
> > +	enum ctx_state prev_ctx;
> > +
> > +	if (likely(ti->preempt_count || irqs_disabled()))
> > +		return;
> > +
> > +	/*
> > +	 * Need to disable preemption in case user_exit() is traced
> > +	 * and the tracer calls preempt_enable_notrace() causing
> > +	 * an infinite recursion.
> > +	 */
> > +	preempt_disable_notrace();
> > +	prev_ctx = this_cpu_read(context_tracking.state);
> > +	user_exit();
> 
> You can reuse exception_enter()

I originally did use that, but then noticed that everything else in
context_tracking.c used context_tracking.state directly. I have no
problems doing it this way again.

> 
> > +	preempt_enable_no_resched_notrace();
> > +
> > +	preempt_schedule();
> > +
> > +	preempt_disable_notrace();
> > +	if (prev_ctx == IN_USER)
> > +		user_enter();
> 
> And then exception_exit() here.
> 
> I guess this replaces your fix with schedule_preempt_user(). I liked
> it because it seems that:
> 
>    if (need_resched()) {
>       user_exit();
>       local_irq_enable();
>       schedule();
>       local_irq_enable();
>       user_enter();
>    }
> 
> is a common pattern of arch user resume preemption that we can consolidate.
> 
> But your new patch probably makes it more widely safe for the function tracer
> for any function that can be called and traced in IN_USER mode. Not only user preemption.
> Think about do_notify_resume() for example if it is called after syscall_trace_leave().
> 
> Independantly, schedule_preempt_user() is still interesting for consolidation.

And I think that patch is still valid from just a clean up point of
view. It just didn't cover all the cases needed for tracing.

I'll rewrite the patch and send it out for another review.

Thanks!

-- Steve


