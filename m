Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbaG3NmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:42:00 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:44330 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaG3Nl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:41:59 -0400
Date: Wed, 30 Jul 2014 15:41:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140730134152.GB18158@localhost.localdomain>
References: <20140728225556.GA19493@linux.vnet.ibm.com>
 <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 03:56:12PM -0700, Paul E. McKenney wrote:
> +/* RCU-tasks kthread that detects grace periods and invokes callbacks. */
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
> +			continue;
> +		}
> +
> +		/*
> +		 * There were callbacks, so we need to wait for an
> +		 * RCU-tasks grace period.  Start off by scanning
> +		 * the task list for tasks that are not already
> +		 * voluntarily blocked.  Mark these tasks and make
> +		 * a list of them in rcu_tasks_holdouts.
> +		 */
> +		rcu_read_lock();
> +		do_each_thread(g, t) {
> +			if (t != current && ACCESS_ONCE(t->on_rq) &&
> +			    !is_idle_task(t)) {
> +				t->rcu_tasks_holdout = 1;
> +				list_add(&t->rcu_tasks_holdout_list,
> +					 &rcu_tasks_holdouts);
> +			}
> +		} while_each_thread(g, t);
> +		rcu_read_unlock();

I think you need for_each_process_thread() to be RCU-safe.
while_each_thread() has shown to be racy against exec even with rcu_read_lock().
