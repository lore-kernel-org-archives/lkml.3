Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbaFWKZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 06:25:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:46813 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaFWKZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 06:25:01 -0400
Date: Mon, 23 Jun 2014 12:24:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        tkhai@yandex.ru, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Konstantin Khorenko <khorenko@parallels.com>
Subject: Re: [PATCH 3/3] sched: Rework check_for_tasks()
Message-ID: <20140623102457.GW19860@laptop.programming.kicks-ass.net>
References: <20140617130442.29933.54945.stgit@tkhai>
 <1403011462.27674.46.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403011462.27674.46.camel@tkhai>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 05:24:22PM +0400, Kirill Tkhai wrote:
> 
> 1)Iterate throw all of threads in the system.

	thru

>   Check for all threads, not only for group leaders.
> 
> 2)Check for p->on_rq instead of p->state and cputime.
>   Preempted task in !TASK_RUNNING state  OR just
>   created task may be queued, that we want to be
>   reported too.
> 
> 3)Use read_lock() instead of write_lock().
>   This function does not change any structures, and
>   read_lock() is enough.
> 
> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
> CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> CC: Mike Galbraith <umgwanakikbuti@gmail.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@kernel.org>
> ---
>  kernel/cpu.c |   33 ++++++++++++++++++++-------------
>  1 file changed, 20 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index a343bde..81e2a38 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -274,21 +274,28 @@ void clear_tasks_mm_cpumask(int cpu)
>  	rcu_read_unlock();
>  }
>  
> -static inline void check_for_tasks(int cpu)
> +static inline void check_for_tasks(int dead_cpu)
>  {
> -	struct task_struct *p;
> -	cputime_t utime, stime;
> +	struct task_struct *g, *p;
>  
> -	write_lock_irq(&tasklist_lock);
> -	for_each_process(p) {
> -		task_cputime(p, &utime, &stime);
> -		if (task_cpu(p) == cpu && p->state == TASK_RUNNING &&
> -		    (utime || stime))
> -			pr_warn("Task %s (pid = %d) is on cpu %d (state = %ld, flags = %x)\n",
> -				p->comm, task_pid_nr(p), cpu,
> -				p->state, p->flags);
> -	}
> -	write_unlock_irq(&tasklist_lock);
> +	read_lock_irq(&tasklist_lock);
> +	do_each_thread(g, p) {
> +		if (!p->on_rq)
> +			continue;
> +		/*
> +		 * We do the check with unlocked task_rq(p)->lock.
> +		 * Order the reading to do not warn about a task,
> +		 * which was running on this cpu in the past, and
> +		 * it's just been woken on another cpu.
> +		 */
> +		rmb();

		smp_rmb();

> +		if (task_cpu(p) != dead_cpu)
> +			continue;

But because we don't have rq->lock held, we can be in the middle of a
wakeup and miss a task.

Then again, I suppose anything without rq->lock can and will miss tasks.

> +		pr_warn("Task %s (pid=%d) is on cpu %d (state=%ld, flags=%x)\n",
> +			p->comm, task_pid_nr(p), dead_cpu, p->state, p->flags);
> +	} while_each_thread(g, p);
> +	read_unlock_irq(&tasklist_lock);
>  }
>  
>  struct take_cpu_down_param {
> 
> 
> 
