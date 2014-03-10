Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbaCJVSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 17:18:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:54043 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbaCJVSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 17:18:52 -0400
Date: Mon, 10 Mar 2014 22:18:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Juri Lelli <juri.lelli@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2] sched: Fix broken setscheduler()
In-Reply-To: <20140310132940.78e556c7@gandalf.local.home>
Message-ID: <alpine.DEB.2.02.1403102206520.18573@ionos.tec.linutronix.de>
References: <20140305232931.449eef8c@gandalf.local.home> <20140306115825.GS27965@twins.programming.kicks-ass.net> <20140306132040.781dbf18c9385a6112fbab2b@gmail.com> <20140306120438.638bfe94@gandalf.local.home> <alpine.DEB.2.02.1403062143360.18573@ionos.tec.linutronix.de>
 <20140310132940.78e556c7@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014, Steven Rostedt wrote:

> On Thu, 6 Mar 2014 21:43:50 +0100 (CET)
> Thomas Gleixner <tglx@linutronix.de> wrote:
>  
> > > Reading what the commit is suppose to do, I realize that the p->prio
> > > can't be set if the task is boosted with a higher prio, but the
> > > p->normal_prio still needs to be set regardless, otherwise, when the
> > > task is deboosted, it wont get the new priority.
> > 
> > Indeed.
> 
> Is this an Acked-by?
> 
> Peter, can you pull this patch please, it is still broken in tip/master.

Lemme look at it tomorrow again with an awake brain. This seems to be
some forward porting hickup which needs a closer look. Just look at
the 3.10-rt version of this:

@@ -3825,20 +3826,25 @@ static struct task_struct *find_process_by_pid(pid_t pid)
 	return pid ? find_task_by_vpid(pid) : current;
 }
 
-/* Actually do priority change: must hold rq lock. */
-static void
-__setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
+static void __setscheduler_params(struct task_struct *p, int policy, int prio)
 {
 	p->policy = policy;
 	p->rt_priority = prio;
 	p->normal_prio = normal_prio(p);
+	set_load_weight(p);
+}

That code has changed significantly probably due to the EDF merge. We
need to figure out whether there is more damage due to that.

Thanks,

	tglx
