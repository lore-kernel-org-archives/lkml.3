Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab3KLRTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:19:10 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:16727 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753776Ab3KLRTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:19:05 -0500
Date: Tue, 12 Nov 2013 12:19:00 -0500
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
Subject: Re: [PATCH 01/14] sched: add sched_class->task_dead.
Message-ID: <20131112121900.6dcfcb0a@gandalf.local.home>
In-Reply-To: <1383831828-15501-2-git-send-email-juri.lelli@gmail.com>
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>
	<1383831828-15501-2-git-send-email-juri.lelli@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  7 Nov 2013 14:43:35 +0100
Juri Lelli <juri.lelli@gmail.com> wrote:

> From: Dario Faggioli <raistlin@linux.it>
> 
> Add a new function to the scheduling class interface. It is called
> at the end of a context switch, if the prev task is in TASK_DEAD state.
> 
> It might be useful for the scheduling classes that want to be notified
> when one of their task dies, e.g. to perform some cleanup actions.

Nit.  s/task/tasks/

-- Steve

> 
> Signed-off-by: Dario Faggioli <raistlin@linux.it>
> Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
> ---
>  kernel/sched/core.c  |    3 +++
>  kernel/sched/sched.h |    1 +
>  2 files changed, 4 insertions(+)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 5ac63c9..850a02c 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1890,6 +1890,9 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
>  	if (mm)
>  		mmdrop(mm);
>  	if (unlikely(prev_state == TASK_DEAD)) {
> +		if (prev->sched_class->task_dead)
> +			prev->sched_class->task_dead(prev);
> +
>  		/*
>  		 * Remove function-return probe instances associated with this
>  		 * task and put them back on the free list.
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index b3c5653..64eda5c 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -992,6 +992,7 @@ struct sched_class {
>  	void (*set_curr_task) (struct rq *rq);
>  	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
>  	void (*task_fork) (struct task_struct *p);
> +	void (*task_dead) (struct task_struct *p);
>  
>  	void (*switched_from) (struct rq *this_rq, struct task_struct *task);
>  	void (*switched_to) (struct rq *this_rq, struct task_struct *task);

