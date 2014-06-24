Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaFXFtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 01:49:45 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43601 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaFXFtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 01:49:43 -0400
Message-ID: <1403588980.29711.11.camel@marge.simpson.net>
Subject: Re: [patch] sched: Fix
 clock_gettime(CLOCK_[PROCESS/THREAD]_CPUTIME_ID) monotonicity
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        pjt@google.com, kosaki.motohiro@jp.fujitsu.com
Date: Tue, 24 Jun 2014 07:49:40 +0200
In-Reply-To: <1403543240.5850.23.camel@marge.simpson.net>
References: <1402910212.16584.4.camel@marge.simpson.net>
	 <20140623151430.GE19860@laptop.programming.kicks-ass.net>
	 <1403543240.5850.23.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 19:07 +0200, Mike Galbraith wrote: 
> On Mon, 2014-06-23 at 17:14 +0200, Peter Zijlstra wrote: 
> > On Mon, Jun 16, 2014 at 11:16:52AM +0200, Mike Galbraith wrote:
> > > (disregard patch of same name from that enterprise weenie;)
> > > 
> > > If a task has been dequeued, it has been accounted.  Do not project
> > > cycles that may or may not ever be accounted to a dequeued task, as
> > > that may make clock_gettime() both inaccurate and non-monotonic.
> > > 
> > > Protect update_rq_clock() from slight TSC skew while at it.
> > > 
> > > Signed-off-by: 	Mike Galbraith <umgwanakikbuti@gmail.com>
> > > ---
> > >  kernel/sched/core.c |   13 +++++++++++--
> > >  1 file changed, 11 insertions(+), 2 deletions(-)
> > > 
> > > --- a/kernel/sched/core.c
> > > +++ b/kernel/sched/core.c
> > > @@ -144,6 +144,8 @@ void update_rq_clock(struct rq *rq)
> > >  		return;
> > >  
> > >  	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
> > > +	if (delta < 0)
> > > +		return;
> > >  	rq->clock += delta;
> > >  	update_rq_clock_task(rq, delta);
> > >  }
> > 
> > Have you actually observed this? If TSC is stable this should not
> > happen, if TSC is not stable we should be using kernel/sched/clock.c
> > which should also avoid this, because while sched_clock_cpu(x) -
> > sched_clock_cpu(y) < 0 is possible, sched_clock_cpu(x) -
> > sched_clock_cpu(x) should always be >= 0.
> > 
> > I suppose it can happen when the TSC gets screwed and we haven't
> > switched to the slow path yet.
> 
> Seen, no.

s/no/yes.. 8 socket 64 core box:

vogelweide:/sys/kernel/debug/tracing/:[0]# cat trace
# tracer: nop
#
# entries-in-buffer/entries-written: 7/7   #P:64
#
#                              _-------=> irqs-off          
#                            /  _------=> need-resched      
#                            |/  _-----=> need-resched_lazy 
#                            ||/  _----=> hardirq/softirq   
#                            |||/  _---=> preempt-depth     
#                            ||||/  _--=> preempt-lazy-depth
#                            ||||| / _-=> migrate-disable   
#                            |||||| /     delay
#           TASK-PID   CPU#  ||||||  TIMESTAMP  FUNCTION
#              | |       |   ||||||     |         |
        modprobe-1656  [051] d...313    12.711729: update_rq_clock: CPU25 negative delta -38
      tbench_srv-8091  [054] d...314   129.845174: update_rq_clock: CPU30 negative delta -12
      tbench_srv-8048  [062] d...314   129.861227: update_rq_clock: CPU34 negative delta -74
      tbench_srv-8054  [046] d...316   132.713941: update_rq_clock: CPU58 negative delta -187
      tbench_srv-8077  [047] d...316   133.779680: update_rq_clock: CPU0 negative delta -54
      tbench_srv-8048  [058] d...316   137.490513: update_rq_clock: CPU19 negative delta -19
          tbench-8087  [004] d...313   139.001686: update_rq_clock: CPU5 negative delta -176


> Damn, I had a reason for leaving that, but seems no now.

As expected, testing verified that my imagination works great :)

sched: Fix clock_gettime(CLOCK_[PROCESS/THREAD]_CPUTIME_ID) monotonicity

If a task has been dequeued, it has been accounted.  Do not project
cycles that may or may not ever be accounted to a dequeued task, as
that may make clock_gettime() both inaccurate and non-monotonic.

Protect update_rq_clock() from slight TSC skew while at it.

Signed-off-by: 	Mike Galbraith <umgwanakikbuti@gmail.com>
---
 kernel/sched/core.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -144,6 +144,8 @@ void update_rq_clock(struct rq *rq)
 		return;
 
 	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
+	if (delta < 0)
+		return;
 	rq->clock += delta;
 	update_rq_clock_task(rq, delta);
 }
@@ -2533,7 +2535,12 @@ static u64 do_task_delta_exec(struct tas
 {
 	u64 ns = 0;
 
-	if (task_current(rq, p)) {
+	/*
+	 * Must be ->curr _and_ ->on_rq.  If dequeued, we would
+	 * project cycles that may never be accounted to this
+	 * thread, breaking clock_gettime().
+	 */
+	if (task_current(rq, p) && p->on_rq) {
 		update_rq_clock(rq);
 		ns = rq_clock_task(rq) - p->se.exec_start;
 		if ((s64)ns < 0)
@@ -2576,8 +2583,10 @@ unsigned long long task_sched_runtime(st
 	 * If we race with it leaving cpu, we'll take a lock. So we're correct.
 	 * If we race with it entering cpu, unaccounted time is 0. This is
 	 * indistinguishable from the read occurring a few cycles earlier.
+	 * If we see ->on_cpu without ->on_rq, the task is leaving, and has
+	 * been accounted, so we're correct here as well.
 	 */
-	if (!p->on_cpu)
+	if (!p->on_cpu || !p->on_rq)
 		return p->se.sum_exec_runtime;
 #endif
 





