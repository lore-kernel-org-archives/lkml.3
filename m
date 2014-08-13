Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaHMSKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 14:10:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbaHMSKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 14:10:33 -0400
Date: Wed, 13 Aug 2014 20:08:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH RFC] time: drop do_sys_times spinlock
Message-ID: <20140813180807.GA8098@redhat.com>
References: <20140812142539.01851e52@annuminas.surriel.com> <20140812191218.GA15210@redhat.com> <53EA94DD.5040900@redhat.com> <20140813172230.GA6296@redhat.com> <20140813133526.1eb5526f@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813133526.1eb5526f@cuia.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13, Rik van Riel wrote:
>
> On Wed, 13 Aug 2014 19:22:30 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > On 08/12, Rik van Riel wrote:
> > >
> > > Any other ideas?
> >
> > To simplify, lets suppose that we only need sum_exec_runtime.
> >
> > Perhaps we can do something like this
>
> That would probably work, indeed.

OK, perhaps I'll try to make a patch tomorrow for review.

> However, it turns out that a seqcount doesn't look too badly either.

Well, I disagree. This is more complex, and this adds yet another lock
which only protects the stats...

> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -461,6 +461,7 @@ struct sighand_struct {
>  	atomic_t		count;
>  	struct k_sigaction	action[_NSIG];
>  	spinlock_t		siglock;
> +	seqcount_t		stats_seq; /* write nests inside spinlock */

No, no, at least it should go to signal_struct. Unlike ->sighand, ->signal
is stable as long as task_struct can't go away.

>  void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
>  {
>  	struct signal_struct *sig = tsk->signal;
> +	struct sighand_struct *sighand;
>  	cputime_t utime, stime;
>  	struct task_struct *t;
> -
> -	times->utime = sig->utime;
> -	times->stime = sig->stime;
> -	times->sum_exec_runtime = sig->sum_sched_runtime;
> +	int seq;
>  
>  	rcu_read_lock();
> -	/* make sure we can trust tsk->thread_group list */
> -	if (!likely(pid_alive(tsk)))
> +	sighand = rcu_dereference(tsk->sighand);
> +	if (unlikely(!sighand))
>  		goto out;
>  
> -	t = tsk;
>  	do {
> -		task_cputime(t, &utime, &stime);
> -		times->utime += utime;
> -		times->stime += stime;
> -		times->sum_exec_runtime += task_sched_runtime(t);
> -	} while_each_thread(tsk, t);
> +		seq = read_seqcount_begin(&sighand->stats_seq);
> +		times->utime = sig->utime;
> +		times->stime = sig->stime;
> +		times->sum_exec_runtime = sig->sum_sched_runtime;
> +
> +		/* make sure we can trust tsk->thread_group list */
> +		if (!likely(pid_alive(tsk)))
> +			goto out;

Whatever we do, we should convert thread_group_cputime() to use
for_each_thread() first().

> @@ -781,14 +781,14 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
>  		cpu_clock_sample(timer->it_clock, p, &now);
>  	} else {
>  		struct sighand_struct *sighand;
> -		unsigned long flags;
>
>  		/*
>  		 * Protect against sighand release/switch in exit/exec and
>  		 * also make timer sampling safe if it ends up calling
>  		 * thread_group_cputime().
>  		 */
> -		sighand = lock_task_sighand(p, &flags);
> +		rcu_read_lock();
> +		sighand = rcu_dereference(p->sighand);

This looks unneeded at first glance.

Oleg.

