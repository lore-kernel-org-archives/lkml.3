Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722AbaFCPI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:08:26 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58214 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244AbaFCPIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:08:24 -0400
Date: Tue, 3 Jun 2014 17:08:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 3/5] irq_work: Implement remote queueing
Message-ID: <20140603150819.GC23860@localhost.localdomain>
References: <1401806420-31018-1-git-send-email-fweisbec@gmail.com>
 <1401806420-31018-4-git-send-email-fweisbec@gmail.com>
 <20140603150008.GT30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603150008.GT30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 05:00:08PM +0200, Peter Zijlstra wrote:
> On Tue, Jun 03, 2014 at 04:40:18PM +0200, Frederic Weisbecker wrote:
> > irq work currently only supports local callbacks. However its code
> > is mostly ready to run remote callbacks and we have some potential user.
> > 
> > The full nohz subsystem currently open codes its own remote irq work
> > on top of the scheduler ipi when it wants a CPU to reevaluate its next
> > tick. However this ad hoc solution bloats the scheduler IPI.
> > 
> > Lets just extend the irq work subsystem to support remote queuing on top
> > of the generic SMP IPI to handle this kind of user. This shouldn't add
> > noticeable overhead.
> > 
> > Suggested-by: Peter Zijlstra <peterz@infradead.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Kevin Hilman <khilman@linaro.org>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Acked-by: Peter Zijlstra <peterz@infradead.org>
> 
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Viresh Kumar <viresh.kumar@linaro.org>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  include/linux/irq_work.h |  2 ++
> >  kernel/irq_work.c        | 22 +++++++++++++++++++++-
> >  kernel/smp.c             |  4 ++++
> >  3 files changed, 27 insertions(+), 1 deletion(-)
> 
> > @@ -198,6 +199,9 @@ void generic_smp_call_function_single_interrupt(void)
> >  		csd->func(csd->info);
> >  		csd_unlock(csd);
> >  	}
> > +
> > +	/* Handle irq works queued remotely by irq_work_queue_on() */
> > +	irq_work_run();
> >  }
> 
> One could possibly extend that comment by stating that we explicitly run
> the irq_work bits after the function bits, because the function bits are
> typically synchronous and have people waiting on them, while not so for
> the irq_works.
> 

Good point! I'll expand the comment.
