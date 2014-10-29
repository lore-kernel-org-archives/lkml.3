Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487AbaJ2LNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 07:13:09 -0400
Received: from relay.parallels.com ([195.214.232.42]:35466 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbaJ2LNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 07:13:07 -0400
Message-ID: <1414581182.8574.66.camel@tkhai>
Subject: Re: [PATCH] sched: Fix race between task_group and sched_task_group
From: Kirill Tkhai <ktkhai@parallels.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Kirill Tkhai <tkhai@yandex.ru>, Oleg Nesterov <oleg@redhat.com>,
        <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Burke Libbey <burke.libbey@shopify.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Date: Wed, 29 Oct 2014 14:13:02 +0300
In-Reply-To: <20141029091640.GW3337@twins.programming.kicks-ass.net>
References: <1414405105.19914.169.camel@tkhai>
	 <20141027230427.GA18454@redhat.com> <1414473874.8574.2.camel@tkhai>
	 <20141028225250.GA8519@redhat.com> <54505D10.7050809@yandex.ru>
	 <20141029091640.GW3337@twins.programming.kicks-ass.net>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Ср, 29/10/2014 в 10:16 +0100, Peter Zijlstra пишет:
> On Wed, Oct 29, 2014 at 06:20:48AM +0300, Kirill Tkhai wrote:
> > > And cgroup_task_migrate() can free ->cgroups via call_rcu(). Of course,
> > > in practice raw_spin_lock_irq() should also act as rcu_read_lock(), but
> > > we should not rely on implementation details.
> > 
> > Do you mean cgroup_task_migrate()->put_css_set_locked()? It's not
> > possible there, because old_cset->refcount is lager than 1. We increment
> > it in cgroup_migrate_add_src() and real freeing happens in
> > cgroup_migrate_finish(). These functions are around task_migrate(), they
> > are pair brackets.
> > 
> > > task_group = tsk->cgroups[cpu_cgrp_id] can't go away because yes, if we
> > > race with migrate then ->attach() was not called. But it seems that in
> > > theory it is not safe to dereference tsk->cgroups.
> > 
> > old_cset can't be freed in cgroup_task_migrate(), so we can safely
> > dereference it. If we've got old_cset in
> > cgroup_post_fork()->sched_move_task(), the right sched_task_group will
> > be installed by attach->sched_move_task().
> 
> 
> Would it be fair to summarise your argument thusly:
> 
>  "Because sched_move_task() is only called from cgroup_subsys methods
>   the cgroup infrastructure itself holds reference on the relevant
>   css sets, and therefore their existence is guaranteed."
> 
> ?
> 
> The question then would be how do we guarantee/assert the assumption
> that sched_move_task() is indeed only ever called from such a method.

I mean the relationship between cgroup_task_migrate() and sched_move_task()
called from anywhere.

cgroup_task_migrate() is the only function which changes task_struct::cgroups.
This function is called only from cgroup_migrate().


         (A)                                                  (B)                                    (C)
          |                                                    |                                      | 
          v                                                    v                                      v


cgroup_migrate_add_src()
    get_css_set(src_cset)

cgroup_migrate()
    cgroup_task_migrate()
        old_cset = task_css_set(tsk)
        get_css_set(new_cset)
        rcu_assign_pointer(tsk->cgroups, new_cset)    
        /* old_cset.refcount > 1 here */
        put_css_set_locked(old_cset)
        /* not freed here */

    css->ss->attach                                   sched_move_task
        cpu_cgroup_attach()                                task_rq_lock()
            sched_move_task()
                ....                                       /* Possible use of old_cset */
                ....                                       task_rq_unlock()
                ....                                       ....              
                task_rq_lock()
                ...
                task_rq_unlock()

                                                                                                  sched_move_task()
                                                                                                      task_rq_lock()
                                                                                                      /* new_cset is used here */
                                                                                                      task_rq_unlock()

cgroup_migrate_finish()
    /* Possible freeing here */
    put_css_set_locked(src_cset)


Even if (B) uses old_cset and old sched_task_group,
(A) will overwrite it before it's freed.

In case of (A) and (C), (C) reads new_cset, because
task_rq_lock() provides all necessary memory barriers.


Of course, cgroup_migrate_add_src() is used more
complex than I've drawn. But the idea is the same.

