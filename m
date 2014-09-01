Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbaIASBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 14:01:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbaIASBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 14:01:42 -0400
Date: Mon, 1 Sep 2014 19:58:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kautuk Consul <consul.kautuk@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        Ionut Alexa <ionut.m.alexa@gmail.com>,
        Guillaume Morin <guillaume@morinfr.org>, linux-kernel@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH 1/1] do_exit(): Solve possibility of BUG() due to race
	with try_to_wake_up()
Message-ID: <20140901175851.GA15210@redhat.com>
References: <1408964064-21447-1-git-send-email-consul.kautuk@gmail.com> <20140825155738.GA5944@redhat.com> <20140901153935.GQ27892@worktop.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140901153935.GQ27892@worktop.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01, Peter Zijlstra wrote:
>
> On Mon, Aug 25, 2014 at 05:57:38PM +0200, Oleg Nesterov wrote:
> > Peter, do you remember another problem with TASK_DEAD we discussed recently?
> > (prev_state == TASK_DEAD detection in finish_task_switch() still looks racy).
>
> Uhm, right. That was somewhere on the todo list :-)
>
> > I am starting to think that perhaps we need something like below, what do
> > you all think?
>
> I'm thinking you lost the hunk that adds rq::dead :-), more comments
> below.

And "goto deactivate" should be moved down, after "switch_count"
initialization.

> > +	if (unlikely(rq->dead))
> > +		goto deactivate;
> > +
>
> Yeah, it would be best to not have to do that; ideally we would be able
> to maybe do both; set rq->dead and current->state == TASK_DEAD.

To avoid spin_unlock_wait() in do_exit(). But on a second thought this
can't work, please see below.

> > --- x/kernel/exit.c
> > +++ x/kernel/exit.c
> > @@ -815,25 +815,8 @@ void do_exit(long code)
> >  		__this_cpu_add(dirty_throttle_leaks, tsk->nr_dirtied);
> >  	exit_rcu();
> >
> > -	/*
> > -	 * The setting of TASK_RUNNING by try_to_wake_up() may be delayed
> > -	 * when the following two conditions become true.
> > -	 *   - There is race condition of mmap_sem (It is acquired by
> > -	 *     exit_mm()), and
> > -	 *   - SMI occurs before setting TASK_RUNINNG.
> > -	 *     (or hypervisor of virtual machine switches to other guest)
> > -	 *  As a result, we may become TASK_RUNNING after becoming TASK_DEAD
> > -	 *
> > -	 * To avoid it, we have to wait for releasing tsk->pi_lock which
> > -	 * is held by try_to_wake_up()
> > -	 */
> > -	smp_mb();
> > -	raw_spin_unlock_wait(&tsk->pi_lock);
> > -
> > -	/* causes final put_task_struct in finish_task_switch(). */
> > -	tsk->state = TASK_DEAD;
> >  	tsk->flags |= PF_NOFREEZE;	/* tell freezer to ignore us */
> > -	schedule();
> > +	exit_schedule();
> >  	BUG();
> >  	/* Avoid "noreturn function does return".  */
> >  	for (;;)
>
> Yes, something like this might work fine..

Not really :/ Yes, rq->dead (or just "bool prev_dead") should obviously
solve the problem with ttwu() after the last schedule(). But only in a
sense that the dying task won't be activated.

However, the very fact that another CPU can look at this task_struct
means that we still need spin_unlock_wait(). If nothing else to ensure
that try_to_wake_up()->spin_unlock(pi_lock) won't write into the memory
we are are going to free.

So I think the comment in do exit should be updated too, and smp_mb()
should be moved under raw_spin_unlock_wait() but ...

But. If am right, doesn't this mean we that have even more problems with
postmortem wakeups??? Why ttwu() can't _start_ after spin_unlock_wait ?

Oleg.

