Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3GAL4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 07:56:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48217 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab3GAL4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 07:56:37 -0400
Date: Mon, 1 Jul 2013 13:55:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [RFC PATCH 4/4] sched: Consolidate open coded preemptible()
 checks
Message-ID: <20130701115550.GA21726@dyad.programming.kicks-ass.net>
References: <1371761141-25386-1-git-send-email-fweisbec@gmail.com>
 <1371761141-25386-5-git-send-email-fweisbec@gmail.com>
 <20130626130511.GL28407@twins.programming.kicks-ass.net>
 <20130701112019.GB7246@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130701112019.GB7246@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 01:20:20PM +0200, Frederic Weisbecker wrote:
> On Wed, Jun 26, 2013 at 03:05:11PM +0200, Peter Zijlstra wrote:
> > On Thu, Jun 20, 2013 at 10:45:41PM +0200, Frederic Weisbecker wrote:
> > > preempt_schedule() and preempt_schedule_context() open
> > > code their preemptability checks.
> > > 
> > > Use the standard API instead for consolidation.
> > > 
> > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > Cc: Ingo Molnar <mingo@kernel.org>
> > > Cc: Li Zhong <zhong@linux.vnet.ibm.com>
> > > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > Cc: Steven Rostedt <rostedt@goodmis.org>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Borislav Petkov <bp@alien8.de>
> > > Cc: Alex Shi <alex.shi@intel.com>
> > > Cc: Paul Turner <pjt@google.com>
> > > Cc: Mike Galbraith <efault@gmx.de>
> > > Cc: Vincent Guittot <vincent.guittot@linaro.org>
> > > ---
> > >  kernel/context_tracking.c |    3 +--
> > >  kernel/sched/core.c       |    4 +---
> > >  2 files changed, 2 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
> > > index 6667700..08db730 100644
> > > --- a/kernel/context_tracking.c
> > > +++ b/kernel/context_tracking.c
> > > @@ -88,10 +88,9 @@ void user_enter(void)
> > >   */
> > >  void __sched notrace preempt_schedule_context(void)
> > >  {
> > > -	struct thread_info *ti = current_thread_info();
> > >  	enum ctx_state prev_ctx;
> > >  
> > > -	if (likely(ti->preempt_count || irqs_disabled()))
> > > +	if (likely(!preemptible()))
> > >  		return;
> > >  
> > 
> > #ifdef CONFIG_PREEMPT_COUNT
> > # define preemptible()  (preempt_count() == 0 && !irqs_disabled())
> > #else
> > # define preemptible()  0
> > #endif
> > 
> > 
> > Wouldn't that give a problem for !PREEMPT_COUNT?
> 
> preempt_schedule_context() depends on CONFIG_PREEMPT which depends on
> CONFIG_PREEMPT_COUNT, so that should work. Or I missed something?

Ah indeed. I just tripped over the fact that its weird to not test
irqs_disabled() even though we don't have the preempt count.


