Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbaHAPzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 11:55:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbaHAPzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 11:55:50 -0400
Date: Fri, 1 Aug 2014 17:53:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v2 tip/core/rcu 01/10] rcu: Add call_rcu_tasks()
Message-ID: <20140801155310.GA2945@redhat.com>
References: <20140731003914.GA3872@linux.vnet.ibm.com> <1406767182-4356-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406767182-4356-1-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30, Paul E. McKenney wrote:
>
> +		rcu_read_lock();
> +		for_each_process_thread(g, t) {
> +			if (t != current && ACCESS_ONCE(t->on_rq) &&
> +			    !is_idle_task(t)) {
> +				t->rcu_tasks_nvcsw = ACCESS_ONCE(t->nvcsw);
> +				t->rcu_tasks_holdout = 1;
> +				list_add(&t->rcu_tasks_holdout_list,
> +					 &rcu_tasks_holdouts);
> +			}
> +		}
> +		rcu_read_unlock();

Wait, unless I missed something this can't work...

The problem is, once the exiting task passes exit_notify() it can
be removed from rcu lists.

Now suppose that (say) proc_exit_connector() has a probe, and this
task has jumped into trampoline and it was preempted there.

No?

Oleg.

