Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaJRVAU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 17:00:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbaJRU7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 16:59:54 -0400
Date: Sat, 18 Oct 2014 22:56:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Kirill Tkhai <ktkhai@parallels.com>, Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH] sched/numa: fix unsafe get_task_struct() in
	task_numa_assign()
Message-ID: <20141018205614.GA15934@redhat.com>
References: <1413376300.24793.55.camel@tkhai> <20141017213641.GB32576@redhat.com> <4323181413620101@web21o.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4323181413620101@web21o.yandex.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18, Kirill Tkhai wrote:
>
> 18.10.2014, 01:40, "Oleg Nesterov" <oleg@redhat.com>:
> > ...
> > The
> > task_struct itself can't go away,
> > ...
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -1158,7 +1158,13 @@ static void task_numa_compare(struct task_numa_env *env,
> >
> >          rcu_read_lock();
> >          cur = ACCESS_ONCE(dst_rq->curr);
> > - if (cur->pid == 0) /* idle */
> > + /*
> > + * No need to move the exiting task, and this ensures that ->curr
> > + * wasn't reaped and thus get_task_struct() in task_numa_assign()
> > + * is safe; note that rcu_read_lock() can't protect from the final
> > + * put_task_struct() after the last schedule().
> > + */
> > + if (is_idle_task(cur) || (cur->flags & PF_EXITING))
> >                  cur = NULL;
> >
> >          /*
>
> Oleg, I've looked once again, and now it's not good for me.

Ah. Thanks a lot Kirill for correcting me!

I was looking at this rcu_read_lock() and I didn't even try to think
what it can actually protect. Nothing.

> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1165,7 +1165,21 @@ static void task_numa_compare(struct task_numa_env *env,
>^^
>       rcu_read_lock();
>       cur = ACCESS_ONCE(dst_rq->curr);
> -     if (cur->pid == 0) /* idle */
> +     /*
> +      * No need to move the exiting task, and this ensures that ->curr
> +      * wasn't reaped and thus get_task_struct() in task_numa_assign()
> +      * is safe; note that rcu_read_lock() can't protect from the final
> +      * put_task_struct() after the last schedule().
> +      */
> +     if (is_idle_task(cur) || (cur->flags & PF_EXITING))
> +             cur = NULL;
> +     /*
> +      * Check once again to be sure curr is still on dst_rq. Even if
> +      * it points on a new task, which is using the memory of freed
> +      * cur, it's OK, because we've locked RCU before
> +      * delayed_put_task_struct() callback is called to put its struct.
> +      */
> +     if (cur != ACCESS_ONCE(dst_rq->curr))

No, I don't think this can work. Let's look at the current code:

	rcu_read_lock();
	cur = ACCESS_ONCE(dst_rq->curr);
	if (cur->pid == 0) /* idle */

And any dereference, even reading ->pid is not safe. This memory can be
freed, unmapped, reused, etc.

Looks like, task_numa_compare() needs to take dst_rq->lock and get the
refernce first.

Or, perhaps, we need to change the rules to ensure that any "task_struct *"
pointer is rcu-safe. Perhaps we have more similar problems... I'd like to
avoid this if possible.

Hmm. I'll try to think more.

Thanks!

Oleg.

