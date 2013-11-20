Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab3KTVdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 16:33:36 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:45695 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755322Ab3KTVdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 16:33:22 -0500
Date: Wed, 20 Nov 2013 16:33:18 -0500
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
Subject: Re: [PATCH 08/14] sched: add latency tracing for -deadline tasks.
Message-ID: <20131120163318.10253e43@gandalf.local.home>
In-Reply-To: <1383831828-15501-9-git-send-email-juri.lelli@gmail.com>
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>
	<1383831828-15501-9-git-send-email-juri.lelli@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  7 Nov 2013 14:43:42 +0100
Juri Lelli <juri.lelli@gmail.com> wrote:


> +	/*
> +	 * Semantic is like this:
> +	 *  - wakeup tracer handles all tasks in the system, independently
> +	 *    from their scheduling class;
> +	 *  - wakeup_rt tracer handles tasks belonging to sched_dl and
> +	 *    sched_rt class;
> +	 *  - wakeup_dl handles tasks belonging to sched_dl class only.
> +	 */
> +	if ((wakeup_dl && !dl_task(p)) ||
> +	    (wakeup_rt && !dl_task(p) && !rt_task(p)) ||
> +	    (p->prio >= wakeup_prio || p->prio >= current->prio))
>  		return;
>  
>  	pc = preempt_count();
> @@ -486,7 +495,7 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
>  	arch_spin_lock(&wakeup_lock);
>  
>  	/* check for races. */
> -	if (!tracer_enabled || p->prio >= wakeup_prio)
> +	if (!tracer_enabled || (!dl_task(p) && p->prio >= wakeup_prio))
>  		goto out_locked;

We probably want to add a "tracing_dl" variable, and do the test like
this:

	if (!tracer_enabled || tracing_dl ||
	    (!dl_task(p) && p->prio >= wakeup_prio))

and for the first if statement too. Otherwise if two dl tasks are
running on two different CPUs, the second will override the first. Once
you start tracing a dl_task, you shouldn't bother tracing another task
until that one wakes up.

	if (dl_task(p))
		tracing_dl = 1;
	else
		tracing_dl = 0;

-- Steve
