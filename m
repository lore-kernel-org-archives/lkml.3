Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab3IKIZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 04:25:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39309 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3IKIZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 04:25:45 -0400
Date: Wed, 11 Sep 2013 10:25:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Peter Anvin <hpa@zytor.com>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 2/7] sched: Add NEED_RESCHED to the preempt_count
Message-ID: <20130911082530.GN31370@twins.programming.kicks-ass.net>
References: <20130910130811.507933095@infradead.org>
 <20130910132011.116593485@infradead.org>
 <522FCE9D.4010707@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522FCE9D.4010707@amacapital.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 06:59:57PM -0700, Andy Lutomirski wrote:
> On 09/10/2013 06:08 AM, Peter Zijlstra wrote:
> > In order to combine the preemption and need_resched test we need to
> > fold the need_resched information into the preempt_count value.
> > 
> > We keep the existing TIF_NEED_RESCHED infrastructure in place but at 3
> > sites test it and fold its value into preempt_count; namely:
> > 
> >  - resched_task() when setting TIF_NEED_RESCHED on the current task
> >  - scheduler_ipi() when resched_task() sets TIF_NEED_RESCHED on a
> >                    remote task it follows it up with a reschedule IPI
> >                    and we can modify the cpu local preempt_count from
> >                    there.
> >  - cpu_idle_loop() for when resched_task() found tsk_is_polling().
> 
> 
> It looks like the intel_idle code can get confused if TIF_NEED_RESCHED
> is set but the preempt resched bit is not -- the need_resched call
> between monitor and mwait won't notice TIF_NEED_RESCHED.
> 
> Is this condition possible?

Ah indeed, I'll have to go find all idle loops out there it seems. Now
if only they were easy to spot :/

I was hoping the generic idle thing was good enough, apparently not
quite. Thanks for spotting that.
