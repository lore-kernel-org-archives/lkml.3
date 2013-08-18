Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab3HRR5n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 13:57:43 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36823 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab3HRR5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 13:57:41 -0400
Date: Sun, 18 Aug 2013 10:57:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <bitbucket@online.de>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] per-cpu preempt_count
Message-ID: <20130818175702.GK29406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130812115113.GE27162@twins.programming.kicks-ass.net>
 <CA+55aFznj9WqGa_Qa0B4=5iTio2br54uJG7xkm6otN2sG2P=8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFznj9WqGa_Qa0B4=5iTio2br54uJG7xkm6otN2sG2P=8w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081817-7182-0000-0000-000008209214
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 10:35:48AM -0700, Linus Torvalds wrote:
> On Mon, Aug 12, 2013 at 4:51 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > The below boots to wanting to mount a root filesystem with
> > CONFIG_PREEMPT=y using kvm -smp 4.
> 
> But doesn't work in general? Or you just never tested?
> 
> I think that "thread_info->preempt_count" variable would need to be
> renamed to "saved_preempt_count" or similar to make sure we catch any
> users. But the patch certainly looks simple otherwise.
> 
> I'm pretty sure I had a discussion about this with Paul McKenney some
> time ago (because the RCU readlock is the most noticeable user of the
> preempt count - the others tend to be hidden inside the out-of-line
> spinlock functions etc), and I thought he had tried this and had some
> problems. Maybe we've fixed things since, or maybe he missed some
> case..

I was doing something a bit different -- trying to put preemptible RCU's
nesting counter into a per-CPU variable.  I considered putting this
counter into thread_info, but got flummoxed by the save/restore code.
If Peter's approach works out, I will look into a similar approach for
RCU's nesting counter.

For whatever it is worth, with the current Kconfigs, RCU only invokes
preempt_enable() and preempt_disable() when CONFIG_PREEMPT=n, in which
case these two functions are nops.  So RCU never exercises the
conditional function call in preempt_enable().

However, preemptible RCU has a situation similar to preempt_disable()
and preempt_enable(): simple increment and (not so simple) decrement in
the common case, and rare conditional function call from rcu_read_unlock()
that is invoked only if the read-side critical section was preempted or
ran for a long time.

							Thanx, Paul

> But if the patch really is this simple, then we should just do it. Of
> course, we should double-check that the percpu preempt count is in a
> cacheline that is already accessed (preferably already dirtied) by the
> context switching code.  And I think this should be an
> architecture-specific thing, because using a percpu variable might be
> good on some architectures but not others. So I get the feeling that
> it should be in the x86 __switch_to(), rather than in the generic
> code. I think it would fit very well with the per-cpu "old_rsp" and
> "current_task" updates that we already do.
> 
> > Adding TIF_NEED_RESCHED into the preempt count would allow a single test
> > in preempt_check_resched() instead of still needing the TI. Removing
> > PREEMPT_ACTIVE from preempt count should allow us to get rid of
> > ti::preempt_count altogether.
> >
> > The only problem with TIF_NEED_RESCHED is that its cross-cpu which would
> > make the entire thing atomic which would suck donkey balls so maybe we
> > need two separate per-cpu variables?
> 
> Agreed. Making it atomic would suck, and cancel all advantages of the
> better code generation to access it. Good point.
> 
> And yeah, it could be two variables in the same cacheline or something.
> 
>                  Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

