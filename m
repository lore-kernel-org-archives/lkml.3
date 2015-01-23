Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbbAWULN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 15:11:13 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:60048 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbbAWULL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 15:11:11 -0500
Date: Fri, 23 Jan 2015 21:11:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] sched, timer: Use atomics for thread_group_cputimer
 stats
Message-ID: <20150123201103.GF23123@twins.programming.kicks-ass.net>
References: <1421983913.4432.22.camel@j-VirtualBox>
 <20150123093341.GK2896@worktop.programming.kicks-ass.net>
 <1422036451.2436.10.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422036451.2436.10.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 10:07:31AM -0800, Jason Low wrote:
> On Fri, 2015-01-23 at 10:33 +0100, Peter Zijlstra wrote:
> > > +		.running = ATOMIC_INIT(0),                              \
> > > +	atomic_t running;
> > > +		atomic_set(&sig->cputimer.running, 1);
> > > @@ -174,7 +174,7 @@ static inline bool cputimer_running(struct task_struct *tsk)
> > > +	if (!atomic_read(&cputimer->running))
> > > +	if (!atomic_read(&cputimer->running)) {
> > > +		atomic_set(&cputimer->running, 1);
> > > +	if (atomic_read(&tsk->signal->cputimer.running))
> > > +	atomic_set(&cputimer->running, 0);
> > > +	if (atomic_read(&sig->cputimer.running)) {
> > > +	if (atomic_read(&tsk->signal->cputimer.running))
> > 
> > That doesn't really need an atomic_t.
> 
> Yeah, I was wondering about that, and made it atomic since we had:
> 
>     raw_spin_lock_irqsave(&cputimer->lock, flags);
>     cputimer->running = 0;
>     raw_spin_unlock_irqrestore(&cputimer->lock, flags);
> 
> in stop_process_timers().

Yeah, that could've been ACCESS_ONCE(cputimer->running) = 0. FWIW
atomic_set() seems to not actually include the needed volatile cast.
