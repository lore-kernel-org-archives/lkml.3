Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab3DOGMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 02:12:00 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:53143 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751067Ab3DOGL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 02:11:59 -0400
Message-ID: <1366006312.29519.67.camel@Wailaba2>
Subject: Re: [PATCH] process cputimer is moving faster than its
 corresponding clock
From: Olivier Langlois <olivier@trillion01.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, tglx@linutronix.de, fweisbec@gmail.com,
        schwidefsky@de.ibm.com, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org
Date: Mon, 15 Apr 2013 02:11:52 -0400
In-Reply-To: <1365782115.17140.68.camel@laptop>
References: <1365184746.874.103.camel@Wailaba2>
	 <1365593710.30071.52.camel@laptop> <1365608911.707.65.camel@Wailaba2>
	 <1365763837.17140.52.camel@laptop> <1365782115.17140.68.camel@laptop>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:trillion01.com} {sentby:smtp auth 173.178.230.31 authed with olivier@trillion01.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2013-04-12 at 17:55 +0200, Peter Zijlstra wrote:
> On Fri, 2013-04-12 at 12:50 +0200, Peter Zijlstra wrote:
> 
> > I'll try and dig through the rest of your email later.. sorry for
> > being
> > a tad slow etc.
> 
> 
> So at thread_group_cputimer() we initialize the cputimer->cputime state
> by using thread_group_cputime() which iterates all tasks of the process
> and calls task_sched_runtime() upon them (which includes the current
> delta).
> 
> Upon subsequent account_group_exec_runtime() calls (from all schedule
> events and timer ticks) we add the current delta to cputimer->cputime.
> 
> However since we already added the first (or part thereof) delta to the
> initial state, we account this double. Thus we can be up to
> NR_CPUS*TICK_NSEC ahead.

Peter, I am thrilled to see that we are starting to understand each
other. So far, that is what I am saying!

There is one missing key concept to understand the issue. The initial
value of the cputimer is not really that important (at least for
relative timers). What is really important it is the pace that it will
move. The thread group deltas represent the minimum size of the step
that the cputimer will be incremented at any moment from now.

The timer expiration time computed must include the deltas or else it
will be fire ahead of its time. This will hold true for any initial
value given to the cputimer.

With that said, maybe this code snippet from my patch explaining the race
condition effect choosen by the statement order makes more sense:

+	} else {
+		/*
+		 * Ideally, you would expect to get:
+		 *
+		 * 1. delta = x, times->sum_exec_runtime = y or
+		 * 2. delta = 0, times->sum_exec_runtime = y+x
+		 *
+		 * but because of the race condition between this function and
+		 * update_curr(), it is possible to get:
+		 *
+		 * 3. delta = 0, times->sum_exec_runtime = y by fetching the
+		 *    cputimer before delta or
+		 * 4. delta = x, times->sum_exec_runtime = y+x by inverting the
+		 *    sequence.
+		 *
+		 * Situation #3 is to be avoided or else it will make a timer being
+		 * fired sooner than requested.
+		 *
+		 * Calling group_delta_exec() is required to guaranty accurate result
+		 */
+		if (delta && *delta == CPUTIMER_NEED_DELTA)
+			*delta = group_delta_exec(tsk);


Setting the initial value of the cputimer to thread_group_cputime()
minus deltas just ensure that its value will be exactly equal to the
corresponding process clock which is nice for absolute timers.

> 
> On every timer tick we evaluate the cputimer state using
> cpu_timer_sample_group() which adds the current tasks delta. This can
> thus be up to (NR_CPUS-1)*TICK_NSEC behind.
> 
> The combination of the timeline behind ahead and the sample being
> behind make it a virtual guarantee we'll hit early by almost
> 2*NR_CPUS*TICK_NSEC.

The second part is not quite what I have been saying.

On every timer tick in the function check_process_timers() raw cputimer
is evaluated and this looks fine to me find as it is staying on the
conservative side.

Please provide a quote from my e-mails that have led you to this
understanding. I will try to rectify it.
> 
> This is what you've been saying right?
> 
> 
> So how about we do not include the deltas into the initial sum, so that
> we're up to NR_CPUS*TICK_NSEC behind. That way, with the sample up to
> (NR_CPUS-1)*TICK_NSEC behind, we're in the order of TICK_NSEC late with
> firing.
> 
> Hmm?

For the reasons listed above, I think that with these proposed changes a
timer could still fire too early. However, this is making the cputimer less
far ahead to its corresponding process clock.

How about if you let me rework my original patch?

Stopping/restarting the cputimer is important for performance.
What else is important to you?
Some new function names to rework?
I could get rid completely of the new function group_delta_exec() and use
thread_group_cputime_nodelta().

The other thing that makes the cputimer moving faster than the process clock,
it is the last call to update_curr() from the last context switch performed
after the call to release_task() for autoreaped tasks.

Nobody commented on that so I am assuming that everyone understand that one. Is
this correct?

I am not totally satisfied with the solution that I am proposing in sched/fair.c
I was hoping for improvement suggestions on that one.

Greetings,
Olivier



