Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbbAWSHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:07:36 -0500
Received: from g4t3425.houston.hp.com ([15.201.208.53]:59026 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008AbbAWSHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:07:35 -0500
Message-ID: <1422036451.2436.10.camel@j-VirtualBox>
Subject: Re: [RFC PATCH] sched, timer: Use atomics for thread_group_cputimer
 stats
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org,
        jason.low2@hp.com
Date: Fri, 23 Jan 2015 10:07:31 -0800
In-Reply-To: <20150123093341.GK2896@worktop.programming.kicks-ass.net>
References: <1421983913.4432.22.camel@j-VirtualBox>
	 <20150123093341.GK2896@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-23 at 10:33 +0100, Peter Zijlstra wrote:
> > +		.running = ATOMIC_INIT(0),                              \
> > +	atomic_t running;
> > +		atomic_set(&sig->cputimer.running, 1);
> > @@ -174,7 +174,7 @@ static inline bool cputimer_running(struct task_struct *tsk)
> > +	if (!atomic_read(&cputimer->running))
> > +	if (!atomic_read(&cputimer->running)) {
> > +		atomic_set(&cputimer->running, 1);
> > +	if (atomic_read(&tsk->signal->cputimer.running))
> > +	atomic_set(&cputimer->running, 0);
> > +	if (atomic_read(&sig->cputimer.running)) {
> > +	if (atomic_read(&tsk->signal->cputimer.running))
> 
> That doesn't really need an atomic_t.

Yeah, I was wondering about that, and made it atomic since we had:

    raw_spin_lock_irqsave(&cputimer->lock, flags);
    cputimer->running = 0;
    raw_spin_unlock_irqrestore(&cputimer->lock, flags);

in stop_process_timers().

