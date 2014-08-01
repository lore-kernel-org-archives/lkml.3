Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbaHATAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 15:00:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaHATAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 15:00:50 -0400
Date: Fri, 1 Aug 2014 20:57:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140801185753.GC10718@redhat.com>
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
> +		rcu_read_lock();
> +		for_each_process_thread(g, t) {
> +			if (t != current && ACCESS_ONCE(t->on_rq) &&
> +			    !is_idle_task(t)) {
> +				get_task_struct(t);
> +				t->rcu_tasks_nvcsw = ACCESS_ONCE(t->nvcsw);
> +				ACCESS_ONCE(t->rcu_tasks_holdout) = 1;
> +				list_add(&t->rcu_tasks_holdout_list,
> +					 &rcu_tasks_holdouts);
> +			}
> +		}
> +		rcu_read_unlock();

So let me repeat. for_each_process_thread() above can not (in general) see
the exiting tasks which have already called exit_notify(), because such a
task can be removed from rcu lists at any time.

Now suppose that proc_exit_connector() is probed. Or another function which
can be called after exit_notify(), this doesn't matter.

An exiting task T jumps into trampoline and gets the preemption. It can be
already (auto)reaped and removed from rcu lists.

synchronize_rcu_tasks() can not see this task, so it can return before T gets
a chance to resume.

Oleg.

