Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbaCJVhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 17:37:37 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:60038 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753503AbaCJVhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 17:37:33 -0400
Date: Mon, 10 Mar 2014 17:37:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Juri Lelli <juri.lelli@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2] sched: Fix broken setscheduler()
Message-ID: <20140310173731.06d41157@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.02.1403102206520.18573@ionos.tec.linutronix.de>
References: <20140305232931.449eef8c@gandalf.local.home>
	<20140306115825.GS27965@twins.programming.kicks-ass.net>
	<20140306132040.781dbf18c9385a6112fbab2b@gmail.com>
	<20140306120438.638bfe94@gandalf.local.home>
	<alpine.DEB.2.02.1403062143360.18573@ionos.tec.linutronix.de>
	<20140310132940.78e556c7@gandalf.local.home>
	<alpine.DEB.2.02.1403102206520.18573@ionos.tec.linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014 22:18:56 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:


> Lemme look at it tomorrow again with an awake brain. This seems to be
> some forward porting hickup which needs a closer look. Just look at

Yep, I talked with Sebastian on IRC and that seems to be the case.

> the 3.10-rt version of this:
> 
> @@ -3825,20 +3826,25 @@ static struct task_struct *find_process_by_pid(pid_t pid)
>  	return pid ? find_task_by_vpid(pid) : current;
>  }
>  
> -/* Actually do priority change: must hold rq lock. */
> -static void
> -__setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
> +static void __setscheduler_params(struct task_struct *p, int policy, int prio)
>  {
>  	p->policy = policy;
>  	p->rt_priority = prio;
>  	p->normal_prio = normal_prio(p);
> +	set_load_weight(p);
> +}
> 
> That code has changed significantly probably due to the EDF merge. We
> need to figure out whether there is more damage due to that.

Yeah, when I looked at the -rt version, it appeared to have my fix
already. But in reality, the forward port broke it. Here's the problem
part of the commit:

+       set_load_weight(p);
+}
 
-       p->normal_prio = normal_prio(p);
-       p->prio = rt_mutex_getprio(p);

Your patch never deleted the above two. And it kept them in the
locations that I placed them in, in my patch.

-- Steve


+/* Actually do priority change: must hold pi & rq lock. */
+static void __setscheduler(struct rq *rq, struct task_struct *p,
+                          const struct sched_attr *attr)
+{


