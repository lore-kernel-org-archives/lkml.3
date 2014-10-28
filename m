Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbaJ1V4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:56:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581AbaJ1V4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:56:36 -0400
Date: Tue, 28 Oct 2014 23:52:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Burke Libbey <burke.libbey@shopify.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH] sched: Fix race between task_group and sched_task_group
Message-ID: <20141028225250.GA8519@redhat.com>
References: <1414405105.19914.169.camel@tkhai> <20141027230427.GA18454@redhat.com> <1414473874.8574.2.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414473874.8574.2.camel@tkhai>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28, Kirill Tkhai wrote:
>
> Shouldn't we do that in separate patch? How about this?

Up to Peter, but I think a separate patch is fine.

> [PATCH]sched: Remove lockdep check in sched_move_task()
>
> sched_move_task() is the only interface to change sched_task_group:
> cpu_cgrp_subsys methods and autogroup_move_group() use it.

Yes, but...

> Everything is synchronized by task_rq_lock(), so cpu_cgroup_attach()
> is ordered with other users of sched_move_task(). This means we do
> no need RCU here: if we've dereferenced a tg here, the .attach method
> hasn't been called for it yet.
>
> Thus, we should pass "true" to task_css_check() to silence lockdep
> warnings.

In theory, I am not sure.

However, I never really understood this code and today I forgot everything,
please correct me.

> @@ -7403,8 +7403,12 @@ void sched_move_task(struct task_struct *tsk)
>  	if (unlikely(running))
>  		put_prev_task(rq, tsk);
>
> -	tg = container_of(task_css_check(tsk, cpu_cgrp_id,
> -				lockdep_is_held(&tsk->sighand->siglock)),
> +	/*
> +	 * All callers are synchronized by task_rq_lock(); we do not use RCU
> +	 * which is pointless here. Thus, we pass "true" to task_css_check()
> +	 * to prevent lockdep warnings.
> +	 */
> +	tg = container_of(task_css_check(tsk, cpu_cgrp_id, true),
>  			  struct task_group, css);

Why this can't race with cgroup_task_migrate() if it is called by
cgroup_post_fork() ?

And cgroup_task_migrate() can free ->cgroups via call_rcu(). Of course,
in practice raw_spin_lock_irq() should also act as rcu_read_lock(), but
we should not rely on implementation details.

task_group = tsk->cgroups[cpu_cgrp_id] can't go away because yes, if we
race with migrate then ->attach() was not called. But it seems that in
theory it is not safe to dereference tsk->cgroups.

Oleg.

