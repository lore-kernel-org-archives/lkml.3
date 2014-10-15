Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaJOToT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 15:44:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbaJOToS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 15:44:18 -0400
Date: Wed, 15 Oct 2014 21:40:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH RFC] sched: Revert delayed_put_task_struct() and fix
	use after free
Message-ID: <20141015194044.GA4557@redhat.com>
References: <1413376300.24793.55.camel@tkhai> <20141015150641.GA2755@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141015150641.GA2755@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15, Oleg Nesterov wrote:
>
> On 10/15, Kirill Tkhai wrote:
> >
> > Regarding to scheduler this may be a reason of use-after-free.
> >
> >     task_numa_compare()                    schedule()
> >         rcu_read_lock()                        ...
> >         cur = ACCESS_ONCE(dst_rq->curr)        ...
> >             ...                                rq->curr = next;
> >             ...                                    context_switch()
> >             ...                                        finish_task_switch()
> >             ...                                            put_task_struct()
> >             ...                                                __put_task_struct()
> >             ...                                                    free_task_struct()
> >             task_numa_assign()                                     ...
> >                 get_task_struct()                                  ...
>
> Agreed. I don't understand this code (will try to take another look later),
> but at first glance this looks wrong.
>
> At least the code like
>
> 	rcu_read_lock();
> 	get_task_struct(foreign_rq->curr);
> 	rcu_read_unlock();
>
> is certainly wrong. And _probably_ the problem should be fixed here. Perhaps
> we can add try_to_get_task_struct() which does atomic_inc_not_zero() ...

Yes, but perhaps in this particular case another simple fix makes more
sense. The patch below needs a comment to explain that we check PF_EXITING
because:

	1. It doesn't make sense to migrate the exiting task. Although perhaps
	   we could check ->mm == NULL instead.

	   But let me repeat that I do not understand this code, I am not sure
	   we can equally treat is_idle_task() and PF_EXITING here...

	2. If PF_EXITING is not set (or ->mm != NULL) then delayed_put_task_struct()
	   won't be called until we drop rcu_read_lock(), and thus get_task_struct()
	   is safe.

And. it seems that there is another problem? Can't task_h_load(cur) race
with itself if 2 CPU's call task_numa_migrate() and inspect the same rq
in parallel? Again, I don't understand this code, but update_cfs_rq_h_load()
doesn't look "atomic". In fact I am not even sure about task_h_load(env->p),
p == current but we do not disable preemption.

What do you think?

Oleg.

--- x/kernel/sched/fair.c
+++ x/kernel/sched/fair.c
@@ -1165,7 +1165,7 @@ static void task_numa_compare(struct tas
 
 	rcu_read_lock();
 	cur = ACCESS_ONCE(dst_rq->curr);
-	if (cur->pid == 0) /* idle */
+	if (is_idle_task(cur) || (curr->flags & PF_EXITING))
 		cur = NULL;
 
 	/*

