Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab3JKSc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 14:32:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab3JKSc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 14:32:27 -0400
Date: Fri, 11 Oct 2013 20:25:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Message-ID: <20131011182507.GA31625@redhat.com>
References: <20131010152612.GA13375@redhat.com> <20131010090044.7f12ddaf.akpm@linux-foundation.org> <20131010123631.1be60315@gandalf.local.home> <20131010094355.6f75e5a2.akpm@linux-foundation.org> <20131010165337.GT3081@twins.programming.kicks-ass.net> <20131010131305.58558079@gandalf.local.home> <20131010104856.8f042977112d5ac2693973ae@linux-foundation.org> <20131010183409.GP13848@laptop.programming.kicks-ass.net> <CA+55aFyoP5KFUg44Xenp_Jz0_5ssosn-KF6LDsa0qsmCjyJ56g@mail.gmail.com> <20131011123820.GV3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011123820.GV3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11, Peter Zijlstra wrote:
>
> As a penance I'll start by removing all get_online_cpus() usage from the
> scheduler.

I only looked at the change in setaffinity,

> @@ -3706,7 +3707,6 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
>  	struct task_struct *p;
>  	int retval;
>
> -	get_online_cpus();
>  	rcu_read_lock();

Hmm. In theory task_rq_lock() doesn't imply rcu-lock, so
set_cpus_allowed_ptr() can miss the change in cpu_active_mask. But this
is probably fine, CPU_DYING does __migrate_task().

However. This means that sched_setaffinity() can fail if it races with
the failing cpu_down() (say, __cpu_notify(CPU_DOWN_PREPARE) fails).
Probably we do not really care, just this looks a bit confusing.

> @@ -3814,7 +3813,6 @@ long sched_getaffinity(pid_t pid, struct cpumask *mask)
>  	unsigned long flags;
>  	int retval;
>
> -	get_online_cpus();

This change is probably fine in any case?

>  	rcu_read_lock();
>
>  	retval = -ESRCH;
> @@ -3827,12 +3825,11 @@ long sched_getaffinity(pid_t pid, struct cpumask *mask)
>  		goto out_unlock;
>
>  	raw_spin_lock_irqsave(&p->pi_lock, flags);
> -	cpumask_and(mask, &p->cpus_allowed, cpu_online_mask);
> +	cpumask_and(mask, &p->cpus_allowed, cpu_active_mask);

But I am just curious, is this change is strictly needed?

Afaics we do not care if we race with set_cpu_online(true/false).

Oleg.

