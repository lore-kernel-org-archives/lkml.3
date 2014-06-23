Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbaFWOVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:21:48 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49986 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbaFWOVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:21:47 -0400
Date: Mon, 23 Jun 2014 16:21:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        tkhai@yandex.ru, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Konstantin Khorenko <khorenko@parallels.com>
Subject: Re: [PATCH 3/3] sched: Rework check_for_tasks()
Message-ID: <20140623142139.GD19860@laptop.programming.kicks-ass.net>
References: <20140617130442.29933.54945.stgit@tkhai>
 <1403011462.27674.46.camel@tkhai>
 <20140623102457.GW19860@laptop.programming.kicks-ass.net>
 <1403520738.3462.11.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403520738.3462.11.camel@tkhai>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 02:52:18PM +0400, Kirill Tkhai wrote:
> > Then again, I suppose anything without rq->lock can and will miss tasks.
> 
> If we use rq->lock it's possible to move check_for_tasks() to kernel/sched/core.c.
> 
> And we can leave TASK_RUNNING check for waking tasks. Maybe something like this?
> 
> static inline void check_for_tasks(int dead_cpu)
> {
> 	struct task_struct *g, *p;
> 	struct rq *rq = cpu_rq(dead_cpu);
> 
> 	read_lock_irq(&tasklist_lock);
> 	raw_spin_lock(&rq->lock)
> 
> 	do_each_thread(g, p) {
> 		if (!p->on_rq && p->state != TASK_RUNNING)
> 			continue;
> 		if (task_cpu(p) != dead_cpu)
> 			continue;
> 
> 		pr_warn("Task %s (pid=%d) is on cpu %d (state=%ld, flags=%x)\n",
> 			p->comm, task_pid_nr(p), dead_cpu, p->state, p->flags);
> 	} while_each_thread(g, p);
> 
> 	raw_spin_unlock(&rq->lock)
> 	read_unlock_irq(&tasklist_lock);
> }
> 
> It still does not give a 100% guarantee... Should we take p->pi_lock for every task?

seeing how rq->lock nests inside of ->pi_lock that's going to be
somewhat icky.

I think we can live with a false negative, given how much people run
this nonsense it'll trigger eventually.

False positives would be bad though :-)

So I think we can keep your original (lock-free) proposal.
