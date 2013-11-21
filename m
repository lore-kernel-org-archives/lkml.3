Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab3KUOmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:42:06 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:33147 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751609Ab3KUOmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:42:05 -0500
Date: Thu, 21 Nov 2013 09:41:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com
Subject: Re: [PATCH 04/14] sched: SCHED_DEADLINE SMP-related data structures
 & logic.
Message-ID: <20131121094150.26318fe9@gandalf.local.home>
In-Reply-To: <528E1508.7060305@gmail.com>
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>
	<1383831828-15501-5-git-send-email-juri.lelli@gmail.com>
	<20131120135134.4c57bcda@gandalf.local.home>
	<528E1508.7060305@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Nov 2013 15:13:28 +0100
Juri Lelli <juri.lelli@gmail.com> wrote:
;
> >> +
> >> +#ifdef CONFIG_SMP
> >> +	/* zero means no -deadline tasks */
> > 
> > I'm curious to why you add the '-' to -deadline.
> > 
> 
> I guess "deadline tasks" is too much generic; "SCHED_DEADLINE tasks" too long;
> "DL" or "-dl" can be associated to "download". Nothing special in the end, just
> tought it was a reasonable abbreviation.

Yeah, keep the -deadline, as that makes it more searchable.

> >> +static int latest_cpu_find(struct cpumask *span,
> >> +			   struct task_struct *task,
> >> +			   struct cpumask *later_mask)
> >> +{
> >> +	const struct sched_dl_entity *dl_se = &task->dl;
> >> +	int cpu, found = -1, best = 0;
> >> +	u64 max_dl = 0;
> >> +
> >> +	for_each_cpu(cpu, span) {
> >> +		struct rq *rq = cpu_rq(cpu);
> >> +		struct dl_rq *dl_rq = &rq->dl;
> >> +
> >> +		if (cpumask_test_cpu(cpu, &task->cpus_allowed) &&
> >> +		    (!dl_rq->dl_nr_running || dl_time_before(dl_se->deadline,
> >> +		     dl_rq->earliest_dl.curr))) {
> >> +			if (later_mask)
> >> +				cpumask_set_cpu(cpu, later_mask);
> >> +			if (!best && !dl_rq->dl_nr_running) {
> >> +				best = 1;
> >> +				found = cpu;
> >> +			} else if (!best &&
> >> +				   dl_time_before(max_dl,
> >> +						  dl_rq->earliest_dl.curr)) {
> > 
> > Ug, the above is hard to read. What about:
> > 
> > 	if (!best) {
> > 		if (!dl_rq->dl_nr_running) {
> > 			best = 1;
> > 			found = cpu;
> > 		} elsif (dl_time_before(...)) {
> > 			...
> > 		}
> > 	}
> > 
> 
> This is completely removed in 13/14. I don't like it either, but since we end
> up removing this mess, do you think we still have to fix this here?

OK, if it gets removed later (I haven't hit patch 13 yet), then it
should be fine.

> 
> > Also, I would think dl should be nice to rt as well. There may be a
> > idle CPU or a non rt task, and this could pick a CPU running an RT
> > task. Worse yet, that RT task may be pinned to that CPU.
> > 
> 
> Well, in 13/14 we introduce a free_cpus mask. A CPU is considered free if it
> doesn't have any -deadline task running. We can modify that excluding also CPUs
> running RT tasks, but I have to think a bit if we can do this also from -rt code.
> 
> > We should be able to incorporate cpuprio_find() to be dl aware too.
> > That is, work for both -rt and -dl.
> >
> 
> Like checking if a -dl task is running on the cpu chosen for pushing an -rt
> task, and continue searching in that case.

Yep, and also, it could perhaps be used for knowing where to push a
-dl task too.

-- Steve
