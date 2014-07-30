Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbaG3RH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 13:07:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755296AbaG3RH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 13:07:56 -0400
Date: Wed, 30 Jul 2014 19:04:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 8/9] rcu: Make RCU-tasks track exiting
	tasks
Message-ID: <20140730170442.GA29577@redhat.com>
References: <20140728225556.GA19493@linux.vnet.ibm.com> <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com> <1406588180-21933-8-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406588180-21933-8-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28, Paul E. McKenney wrote:
>
> This commit adds synchronization with exiting tasks, so that RCU-tasks
> avoids waiting on tasks that no longer exist.

I don't understand this patch yet, but it seems that it adds more than
just synchronization with exiting tasks?

> +		ACCESS_ONCE(t->rcu_tasks_holdout) = 1;
> +		spin_unlock(&t->rcu_tasks_lock);
> +		smp_mb();  /* Order ->rcu_tasks_holdout store before "if". */
> +		if (t == current || !ACCESS_ONCE(t->on_rq) || is_idle_task(t)) {
> +			smp_store_release(&t->rcu_tasks_holdout, 0);
> +			goto next_thread;
> +		}

This should avoid the race with schedule()->rcu_note_voluntary_context_switch(),
right?

> -		rcu_read_lock();
> -		do_each_thread(g, t) {
> -			if (t != current && ACCESS_ONCE(t->on_rq) &&
> -			    !is_idle_task(t)) {
> -				t->rcu_tasks_holdout = 1;

Because before this patch the code looks obviously racy, a task can do
sleep(FOREVER) and block rcu_tasks_kthread() if it reads ->on_rq == 1
after rcu_note_voluntary_context_switch() was already called.

However, I am not sure this race is actually closed even after this
change... why rcu_note_voluntary_context_switch() can not miss
->rcu_tasks_holdout != 0 ?

OK, it seems that you are going to send the next version anyway, so
please ignore.

Oleg.

