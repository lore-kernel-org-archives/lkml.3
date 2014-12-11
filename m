Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911AbaLKLhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 06:37:17 -0500
Received: from smtprelay0134.hostedemail.com ([216.40.44.134]:58516 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932200AbaLKLhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 06:37:15 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6261:7875:9040:10004:10400:10848:10967:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12663:12740:13069:13071:13255:13311:13357:13870:14096:14097:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: key03_795305752e208
X-Filterd-Recvd-Size: 2598
Date: Thu, 11 Dec 2014 06:37:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] tracing/sched: Check preempt_count() for current when
 reading task->state
Message-ID: <20141211063712.5cf4d240@gandalf.local.home>
In-Reply-To: <20141211063811.GD5059@gmail.com>
References: <20141210174428.3cb7542a@gandalf.local.home>
	<20141211063811.GD5059@gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2014 07:38:11 +0100
Ingo Molnar <mingo@kernel.org> wrote:

> > Cc: stable@vger.kernel.org # 3.13+
> > Fixes: 01028747559a "sched: Create more preempt_count accessors"
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  include/trace/events/sched.h | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
> > index 0a68d5ae584e..13fbadcc172b 100644
> > --- a/include/trace/events/sched.h
> > +++ b/include/trace/events/sched.h
> > @@ -97,10 +97,14 @@ static inline long __trace_sched_switch_state(struct task_struct *p)
> >  	long state = p->state;
> >  
> >  #ifdef CONFIG_PREEMPT
> > +	unsigned long pc;
> > +
> > +	pc = (p == current) ? preempt_count() : task_preempt_count(p);
> > +
> >  	/*
> >  	 * For all intents and purposes a preempted task is a running task.
> >  	 */
> > -	if (task_preempt_count(p) & PREEMPT_ACTIVE)
> > +	if (pc & PREEMPT_ACTIVE)
> >  		state = TASK_RUNNING | TASK_STATE_MAX;
> 
> I really don't like the overhead around here.

Hi Ingo!

What overhead are you worried about? Note, this is in the schedule
tracepoint and does not affect the scheduler itself (as long as the
tracepoint is not enabled).

I'm also thinking that as long as "prev" is always guaranteed to be
"current" we can remove the check and just use preempt_count() always.
But I'm worried that we can't guaranteed that.

What other ideas do you have? Because wrong data is worse than the
overhead of the above code. If Thomas taught me anything, it's that!

-- Steve
