Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269Ab3BMTFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 14:05:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8075 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988Ab3BMTFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 14:05:40 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=amwdYq58fXoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Z7SmUxEbSGQA:10 a=WF69J8PlksK74UQOLoAA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360782338.23152.22.camel@gandalf.local.home>
Subject: Re: [PATCH 2/3] sched: Move idle_balance() to post_schedule
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>
Date: Wed, 13 Feb 2013 14:05:38 -0500
In-Reply-To: <1360780981.8957.3.camel@laptop>
References: <20130212225412.781044738@goodmis.org>
	 <20130212230017.625583020@goodmis.org> <1360780981.8957.3.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 19:43 +0100, Peter Zijlstra wrote:
> On Tue, 2013-02-12 at 17:54 -0500, Steven Rostedt wrote:
> > There's no real reason that the idle_balance() needs to be called in
> > the
> > middle of schedule anyway. The only benefit is that if a task is
> > pulled
> > to this CPU, it can be scheduled without the need to schedule the idle
> > task. 
> 
> Uhm, istr that extra schedule being an issue somewhere.. Make very sure
> you don't regress anything silly like sysbench or hackbench. Maybe ask
> Mike, he seems to have a better retention for benchmark weirdness than
> me.

I'm all for benchmarks :-)

> 
> > But load balancing and migrating the task makes a switch to idle
> > and back negligible.
> 
> How does that follow? We can have to-idle switches _far_ more often than
> we balance.

But we have the to-idle switch regardless in that case, don't we?

That is, the CPU is about to go idle, thus a load balance is done, and
perhaps a task is pulled to the current queue. To do this, rq locks and
such need to be grabbed across CPUs.

If it didn't balance the switch would happen anyways.

The current method is:

	if (!rq->nr_running)
		idle_balance();

	/* if something pulled, then run that instead,
	   if not, continue to switch to idle. */

What this change did was:

	pick_next_task_idle()
		rq->post_schedule = 1;

	post_schedule()
		idle_balance();

Now if a balance occurred, we would have to switch back from idle, to
what we just pulled.

Hence the change is that a switch to and from idle is done only in the
case that load balancing occurred, otherwise it just goes to idle like
it always has.

Or perhaps I need add another check to make sure rq->nr_running is still
0 before doing the balance, because the rq lock was released. That is:

	post_schedule()
		if (!rq->nr_running)
			idle_balance();

needs to be added.

-- Steve



