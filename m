Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab3IXIHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:07:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40758 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab3IXIHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:07:41 -0400
Date: Tue, 24 Sep 2013 10:07:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Peter Anvin <hpa@zytor.com>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [PATCH 02/11] sched, rcu: Make RCU use resched_cpu()
Message-ID: <20130924080706.GI9326@twins.programming.kicks-ass.net>
References: <20130917082838.218329307@infradead.org>
 <20130917091143.449530904@infradead.org>
 <20130917144012.GC29354@twins.programming.kicks-ass.net>
 <20130923165540.GP9093@linux.vnet.ibm.com>
 <20130923211827.GA7032@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130923211827.GA7032@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 02:18:27PM -0700, Paul E. McKenney wrote:
> Passes light testing, but I am confused about why the change to
> resched_task() when only resched_cpu() is invoked elsewhere in the patch.
> Enlightenment?
> > > -#ifdef CONFIG_SMP
> > >  void resched_task(struct task_struct *p)
> > >  {
> > >  	int cpu;
> > > 
> > > -	assert_raw_spin_locked(&task_rq(p)->lock);
> > > +	lockdep_assert_held(&task_rq(p)->lock);
> > > 
> > >  	if (test_tsk_need_resched(p))
> > >  		return;

That one? Fly by fixup I suppose.. the lockdep check is cheaper as it
compiles away for !lockdep kernels, also its more correct.
