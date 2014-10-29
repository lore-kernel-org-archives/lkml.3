Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaJ2DU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 23:20:56 -0400
Received: from forward2l.mail.yandex.net ([84.201.143.145]:42575 "EHLO
	forward2l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaJ2DUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 23:20:54 -0400
X-Yandex-Uniq: 4d28fdbc-dd2a-4b35-9e4b-f68b640c9c88
Authentication-Results: smtp4h.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <54505D10.7050809@yandex.ru>
Date: Wed, 29 Oct 2014 06:20:48 +0300
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:33.0) Gecko/20100101 Icedove/33.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Kirill Tkhai <ktkhai@parallels.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Burke Libbey <burke.libbey@shopify.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH] sched: Fix race between task_group and sched_task_group
References: <1414405105.19914.169.camel@tkhai> <20141027230427.GA18454@redhat.com> <1414473874.8574.2.camel@tkhai> <20141028225250.GA8519@redhat.com>
In-Reply-To: <20141028225250.GA8519@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.10.2014 01:52, Oleg Nesterov wrote:
> On 10/28, Kirill Tkhai wrote:
>>
>> Shouldn't we do that in separate patch? How about this?
> 
> Up to Peter, but I think a separate patch is fine.
> 
>> [PATCH]sched: Remove lockdep check in sched_move_task()
>>
>> sched_move_task() is the only interface to change sched_task_group:
>> cpu_cgrp_subsys methods and autogroup_move_group() use it.
> 
> Yes, but...
> 
>> Everything is synchronized by task_rq_lock(), so cpu_cgroup_attach()
>> is ordered with other users of sched_move_task(). This means we do
>> no need RCU here: if we've dereferenced a tg here, the .attach method
>> hasn't been called for it yet.
>>
>> Thus, we should pass "true" to task_css_check() to silence lockdep
>> warnings.
> 
> In theory, I am not sure.
> 
> However, I never really understood this code and today I forgot everything,
> please correct me.
> 
>> @@ -7403,8 +7403,12 @@ void sched_move_task(struct task_struct *tsk)
>>  	if (unlikely(running))
>>  		put_prev_task(rq, tsk);
>>
>> -	tg = container_of(task_css_check(tsk, cpu_cgrp_id,
>> -				lockdep_is_held(&tsk->sighand->siglock)),
>> +	/*
>> +	 * All callers are synchronized by task_rq_lock(); we do not use RCU
>> +	 * which is pointless here. Thus, we pass "true" to task_css_check()
>> +	 * to prevent lockdep warnings.
>> +	 */
>> +	tg = container_of(task_css_check(tsk, cpu_cgrp_id, true),
>>  			  struct task_group, css);
> 
> Why this can't race with cgroup_task_migrate() if it is called by
> cgroup_post_fork() ?

It can race, but which problem is there? The only thing is
cgroup_post_fork()'s or ss->attach()'s call of sched_move_task() will be
NOOP.

cgroup_migrate_add_src()

  cgroup_task_migrate()
                                                    cgroup_post_fork();
    rcu_assign_pointer(tsk->cgroups, new_cset);
                                                      sched_move_task();
  css->ss->attach(css, &tset);

    sched_move_task();

cgroup_migrate_finish()

> And cgroup_task_migrate() can free ->cgroups via call_rcu(). Of course,
> in practice raw_spin_lock_irq() should also act as rcu_read_lock(), but
> we should not rely on implementation details.

Do you mean cgroup_task_migrate()->put_css_set_locked()? It's not
possible there, because old_cset->refcount is lager than 1. We increment
it in cgroup_migrate_add_src() and real freeing happens in
cgroup_migrate_finish(). These functions are around task_migrate(), they
are pair brackets.

> task_group = tsk->cgroups[cpu_cgrp_id] can't go away because yes, if we
> race with migrate then ->attach() was not called. But it seems that in
> theory it is not safe to dereference tsk->cgroups.

old_cset can't be freed in cgroup_task_migrate(), so we can safely
dereference it. If we've got old_cset in
cgroup_post_fork()->sched_move_task(), the right sched_task_group will
be installed by attach->sched_move_task().

Kirill
