Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbaG3Pwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 11:52:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166AbaG3PwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:52:25 -0400
Date: Wed, 30 Jul 2014 17:49:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140730154949.GA26787@redhat.com>
References: <20140728225556.GA19493@linux.vnet.ibm.com> <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28, Paul E. McKenney wrote:
>
> This commit adds a new RCU-tasks flavor of RCU, which provides
> call_rcu_tasks().  This RCU flavor's quiescent states are voluntary
> context switch (not preemption!), userspace execution, and the idle loop.
> Note that unlike other RCU flavors, these quiescent states occur in tasks,
> not necessarily CPUs.  Includes fixes from Steven Rostedt.

I still hope I will read this series later. Not that I really hope I will
understand it ;)

Just one question for now,

> +static int __noreturn rcu_tasks_kthread(void *arg)
> +{
> +	unsigned long flags;
> +	struct task_struct *g, *t;
> +	struct rcu_head *list;
> +	struct rcu_head *next;
> +
> +	/* FIXME: Add housekeeping affinity. */
> +
> +	/*
> +	 * Each pass through the following loop makes one check for
> +	 * newly arrived callbacks, and, if there are some, waits for
> +	 * one RCU-tasks grace period and then invokes the callbacks.
> +	 * This loop is terminated by the system going down.  ;-)
> +	 */
> +	for (;;) {
> +
> +		/* Pick up any new callbacks. */
> +		raw_spin_lock_irqsave(&rcu_tasks_cbs_lock, flags);
> +		smp_mb__after_unlock_lock(); /* Enforce GP memory ordering. */
> +		list = rcu_tasks_cbs_head;
> +		rcu_tasks_cbs_head = NULL;
> +		rcu_tasks_cbs_tail = &rcu_tasks_cbs_head;
> +		raw_spin_unlock_irqrestore(&rcu_tasks_cbs_lock, flags);
> +
> +		/* If there were none, wait a bit and start over. */
> +		if (!list) {
> +			schedule_timeout_interruptible(HZ);
> +			flush_signals(current);

Why? And I see more flush_signals() in the current kernel/rcu/ code. Unless
a kthread does allow_signal() it can't have a pending signal?

Oleg.

