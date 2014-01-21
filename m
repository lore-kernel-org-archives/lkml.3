Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbaAUO5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 09:57:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57380 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856AbaAUO5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 09:57:32 -0500
Date: Tue, 21 Jan 2014 15:57:08 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@linaro.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: top-down balance purpose discussion -- resend
Message-ID: <20140121145708.GY31570@twins.programming.kicks-ass.net>
References: <52DE7E6A.90401@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DE7E6A.90401@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 10:04:26PM +0800, Alex Shi wrote:
> 
> Current scheduler load balance is bottom-up mode, each CPU need
> initiate the balance by self.
> 
> 1, Like in a integrate computer system, it has smt/core/cpu/numa, 4
> level scheduler domains. If there is just 2 tasks in whole system that
> both running on cpu0. Current load balance need to pull task to another
> smt in smt domain, then pull task to another core, then pull task to
> another cpu, finally pull task to another numa. Totally it is need 4
> times task moving to get system balance.

Except the idle load balancer, and esp. the newidle can totally by-pass
this.

If you do the packing right in the newidle pass, you'd get there in 1
step.

> Generally, the task moving complexity is
> 	O(nm log n),  n := nr_cpus, m := nr_tasks
> 
> There is a excellent summary and explanation for this in
> kernel/sched/fair.c:4605

Which is a perfectly fine scheme for a busy system.

> Another weakness of current LB is that every cpu need to get the other
> cpus' load info repeatedly and try to figure out busiest sched
> group/queue on every sched domain level. But it just waste time, since
> it may not conduct a task moving. One of reasons is that cpu can only
> pull task, not pushing.

This doesn't make sense.. and in fact, we do a limited amount of 3rd
party movements.

Whatever you do, you have to repeat the information gathering anyhow,
because it constantly changes.

Trying to serialize that doesn't make any kind of sense. The only thing
you want is that the system converges.

Skipped the rest because it seems build on a fundament I don't agree
with. That 4 move thing is just silly for an idle system, and we
shouldn't do that.

I also very much do not want a single CPU balancing the entire system,
that's the anti-thesis of scalable.
