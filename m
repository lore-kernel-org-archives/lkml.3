Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaG2IM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 04:12:27 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49722 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaG2IMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 04:12:25 -0400
Date: Tue, 29 Jul 2014 10:12:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140729081211.GP20603@laptop.programming.kicks-ass.net>
References: <20140728225556.GA19493@linux.vnet.ibm.com>
 <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 03:56:12PM -0700, Paul E. McKenney wrote:
> +		/*
> +		 * Each pass through the following loop scans the list
> +		 * of holdout tasks, removing any that are no longer
> +		 * holdouts.  When the list is empty, we are done.
> +		 */
> +		while (!list_empty(&rcu_tasks_holdouts)) {
> +			schedule_timeout_interruptible(HZ / 10);
> +			flush_signals(current);
> +			rcu_read_lock();
> +			list_for_each_entry_rcu(t, &rcu_tasks_holdouts,
> +						rcu_tasks_holdout_list) {
> +				if (smp_load_acquire(&t->rcu_tasks_holdout))
> +					continue;
> +				list_del_init(&t->rcu_tasks_holdout_list);
> +				/* @@@ need to check for usermode on CPU. */
> +			}
> +			rcu_read_unlock();
> +		}

That's a potential CPU runtime sink.. imagine having to scan 100k tasks
10 times a second. Polling O(nr_tasks) is not good.
