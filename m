Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264AbaJIRdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 13:33:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:41445 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaJIRdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 13:33:00 -0400
Date: Thu, 9 Oct 2014 19:32:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kirill Tkhai <tkhai@yandex.ru>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] sched: schedule_tail() should disable preemption
Message-ID: <20141009173259.GC14547@worktop.programming.kicks-ass.net>
References: <20141007195046.GA28002@redhat.com>
 <20141008080016.GB10832@worktop.programming.kicks-ass.net>
 <20141008183302.GA17495@redhat.com>
 <20141008183326.GB17495@redhat.com>
 <20141008193644.GA32055@redhat.com>
 <1412804248.24248.1.camel@yandex.ru>
 <20141009145726.GA5604@redhat.com>
 <20141009151730.GW10832@worktop.programming.kicks-ass.net>
 <20141009165713.GA13118@redhat.com>
 <20141009172834.GZ10832@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009172834.GZ10832@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 07:28:34PM +0200, Peter Zijlstra wrote:
> On Thu, Oct 09, 2014 at 06:57:13PM +0200, Oleg Nesterov wrote:
> > > Your earlier proposal would penalize every
> > > !x86 arch by adding extra code to the scheduler core while they already
> > > automagically preserve their thread_info::preempt_count.
> > 
> > Sure, and it can't be even compiled on !x86.
> > 
> > But this is simple, just we need a new helper, preempt_count_restore(),
> > defined as nop in asm-generic/preempt.h. Well, perhaps another helper
> > makes sense, preempt_count_raw() which simply reads the counter, but
> > this is minor.
> > 
> > After the patch below we can remove ->saved_preempt_count. Including
> > init_task_preempt_count(), it is no longer needed after the change in
> > schedule_tail().
> 
> Ah, right, this makes more sense.
> 
> > @@ -2333,10 +2336,12 @@ context_switch(struct rq *rq, struct task_struct *prev,
> >  #endif
> >  
> >  	context_tracking_task_switch(prev, next);
> > +
> > +	pc = preempt_count();
> 
> The only problem here is that you can loose PREEMPT_NEED_RESCHED, I
> haven't thought about whether that is a problem here or not.

Also, if you make that preempt_count_save(), to mirror the restore, you
can both preserve PREEMPT_NEED_RESCHED and avoid emitting code on !x86.
