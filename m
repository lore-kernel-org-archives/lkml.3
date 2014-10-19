Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaJSTlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 15:41:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbaJSTlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 15:41:18 -0400
Date: Sun, 19 Oct 2014 21:37:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Kirill Tkhai <ktkhai@parallels.com>, Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH] sched/numa: fix unsafe get_task_struct() in
	task_numa_assign()
Message-ID: <20141019193744.GA3097@redhat.com>
References: <1413376300.24793.55.camel@tkhai> <20141017213641.GB32576@redhat.com> <4323181413620101@web21o.yandex.ru> <20141018205614.GA15934@redhat.com> <33631413674011@web7o.yandex.ru> <20141019192437.GA842@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141019192437.GA842@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19, Oleg Nesterov wrote:
>
> On 10/19, Kirill Tkhai wrote:
> >
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -1165,7 +1165,30 @@ static void task_numa_compare(struct task_numa_env *env,
> >
> >  	rcu_read_lock();
> >  	cur = ACCESS_ONCE(dst_rq->curr);
> > -	if (cur->pid == 0) /* idle */
> > +	/*
> > +	 * No need to move the exiting task, and this ensures that ->curr
> > +	 * wasn't reaped and thus get_task_struct() in task_numa_assign()
> > +	 * is safe; note that rcu_read_lock() can't protect from the final
> > +	 * put_task_struct() after the last schedule().
> > +	 */
> > +	if (cur->flags & PF_EXITING)
> > +		cur = NULL;
>
> so this needs probe_kernel_read(&cur->flags).
>
> > +	if (cur != ACCESS_ONCE(dst_rq->curr))
> > +		cur = NULL;
>
> Yes, if this task_struct was freed in between we do not care if this memory
> was reused (except PF_EXITING can be false positive). If it was freed and
> now the same memory is ->curr again we know that delayed_put_task_struct()
> can't be called until we drop rcu lock, even if PF_EXITING is already set
> again.
>
> I won't argue, but you need to convince Peter to accept this hack ;)
>
> > >  Or, perhaps, we need to change the rules to ensure that any "task_struct *"
> > >  pointer is rcu-safe. Perhaps we have more similar problems... I'd like to
> > >  avoid this if possible.
> >
> > RT tree has:
> >
> > https://git.kernel.org/cgit/linux/kernel/git/paulg/3.10-rt-patches.git/
> > tree/patches/sched-delay-put-task.patch
>
> Yes, and this obviously implies more rcu callbacks in flight, and another
> gp before __put_task_struct(). but may be we will need to do this anyway...

Forgot to mention... Or we can make task_struct_cachep SLAB_DESTROY_BY_RCU,
in this case ->curr (or any other "task_struct *" ponter) can not go away
under rcu_read_lock(). task_numa_compare() still needs the PF_EXITING check,
but we do not need to recheck ->curr or probe_kernel_read().

Oleg.

