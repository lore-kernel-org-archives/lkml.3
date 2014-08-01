Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbaHAOO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:14:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbaHAOO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:14:26 -0400
Date: Fri, 1 Aug 2014 16:11:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140801141144.GA30293@redhat.com>
References: <20140731215445.GA21933@linux.vnet.ibm.com> <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Paul E. McKenney wrote:
>
> +/* Lists of tasks that we are still waiting for during this grace period. */
> +static LIST_HEAD(rcu_tasks_holdouts);

This can be local var in rcu_tasks_kthread()

> +		while (!list_empty(&rcu_tasks_holdouts)) {
> +			schedule_timeout_interruptible(HZ / 10);
> +			flush_signals(current);

Still can't undestand why your paranoia wants flush_signals ;)
This is unneeded and confusing. If you think we can have a bug here,
then we should ot hide it, WARN_ON(signal_pending) would be better.
And if you think signal_pending(current) is possible, why do you
check this only after schedule_interruptible() ?

> +		synchronize_sched();
> +
> +		/* Invoke the callbacks. */
> +		while (list) {
> +			next = list->next;
> +			local_bh_disable();
> +			list->func(list);
> +			local_bh_enable();
> +			list = next;
> +			cond_resched();
> +		}

Not sure this makes any sense, but perhaps we can check for the new
callbacks and start the next gp. IOW, the main loop roughly does

	for (;;) {
		list = rcu_tasks_cbs_head;
		rcu_tasks_cbs_head = NULL;

		if (!list)
			sleep();

		synchronize_sched();

		wait_for_rcu_tasks_holdout();

		synchronize_sched();

		process_callbacks(list);
	}

we can "join" 2 synchronize_sched's and do

	ready_list = NULL;
	for (;;) {
		list = rcu_tasks_cbs_head;
		rcu_tasks_cbs_head = NULL;

		if (!list && !ready_list)
			sleep();

		synchronize_sched();

		if (ready_list) {
			process_callbacks(ready_list);
			ready_list = NULL;
		}

		if (!list)
			continue;

		wait_for_rcu_tasks_holdout();
		ready_list = list;
	}

Oleg.

