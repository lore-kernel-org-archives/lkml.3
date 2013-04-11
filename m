Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab3DKUr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:47:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:49001 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab3DKUrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:47:25 -0400
Date: Thu, 11 Apr 2013 22:47:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave@sr71.net>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        dhillf@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] kthread: Prevent unpark race which puts threads on the
 wrong cpu
In-Reply-To: <51670C17.8070608@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1304112158040.21884@ionos>
References: <515F457E.5050505@sr71.net> <515FCAC6.8090806@linux.vnet.ibm.com> <alpine.LFD.2.02.1304061019000.21884@ionos> <alpine.LFD.2.02.1304071119100.21884@ionos> <20130407095025.GA31307@pd.tnic> <alpine.LFD.2.02.1304081122040.21884@ionos>
 <20130408115553.GA4395@pd.tnic> <alpine.LFD.2.02.1304081415570.21884@ionos> <alpine.LFD.2.02.1304091635430.21884@ionos> <51670C17.8070608@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa,

On Fri, 12 Apr 2013, Srivatsa S. Bhat wrote:
> On 04/09/2013 08:08 PM, Thomas Gleixner wrote:
> > Add a new task state (TASK_PARKED) which prevents other wakeups and
> > use this state explicitely for the unpark wakeup.
> >
> 
> Again, I think this is unnecessary. We are good as long as no one other
> than the unpark code can kick the kthreads out of the loop in the park
> code. Now that I understand the race you explained above, why not just
> fix that race itself by reversing the ordering of clear(SHOULD_PARK)
> and bind_to(CPU2)? That way, even if someone else wakes up the per-cpu
> kthread, it will just remain confined to the park code, as intended.

In theory.
 
> A patch like below should do it IMHO. I guess I'm being a little too
> persistent, sorry!

No it's not about being persistent, you're JUST too much into voodoo
programming instead of going for the straight forward and robust
solutions.

Darn, I hate it as much as everyone else to introduce a new task
state, but that state allows us to make guarantees and gives us
semantical clarity. A parked thread is parked and can only be woken up
by the unpark code. That's clear semantics and not a magic construct
which will work in most cases and for the remaining ones (See below)
it will give us problems which are way harder to decode than the ones
we tried to fix with that magic.

> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index 691dc2e..9512fc5 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -308,6 +308,15 @@ struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
>  	to_kthread(p)->cpu = cpu;
>  	/* Park the thread to get it out of TASK_UNINTERRUPTIBLE state */
>  	kthread_park(p);
> +
> +	/*
> +	 * Wait for p->on_rq to be reset to 0, to ensure that the per-cpu
> +	 * migration thread (which belongs to the stop_task sched class)
> +	 * doesn't run until the cpu is actually onlined and the thread is
> +	 * unparked.
> +	 */
> +	if (!wait_task_inactive(p, TASK_INTERRUPTIBLE))
> +		WARN_ON(1);

Yay, we rely on TASK_INTERRUPTIBLE state with a task which already has
references outside the creation code. And then we _HOPE_ that nothing
wakes it up _BEFORE_ we do something else.

Aside of that, you are still insisting to enforce that for every per
cpu thread even if the only one which needs that at this point are
thos which have a create() callback (i.e. the migration thread). And
next week you figure out that this is a performance impact on bringing
up large machines....

>  /**
>   * kthread_unpark - unpark a thread created by kthread_create().
>   * @k:		thread created by kthread_create().
> @@ -337,18 +357,29 @@ void kthread_unpark(struct task_struct *k)
>  	struct kthread *kthread = task_get_live_kthread(k);
>  
>  	if (kthread) {
> +		/*
> +		 * Per-cpu kthreads such as ksoftirqd can get woken up by
> +		 * other events. So after binding the thread, ensure that
> +		 * it goes off the CPU atleast once, by parking it again.
> +		 * This way, we can ensure that it will run on the correct
> +		 * CPU on subsequent wakeup.
> +		 */
> +		if (test_bit(KTHREAD_IS_PER_CPU, &kthread->flags)) {
> +			__kthread_bind(k, kthread->cpu);
> +			clear_bit(KTHREAD_IS_PARKED, &kthread->flags);

And how is that f*cking different from the previous code?

CPU0	   		CPU1		       CPU2
				       	       wakeup(T) -> run on CPU1 (last cpu)

			switch_to(T)

__kthread_bind(T, CPU2)

clear(KTHREAD_IS_PARKED)

			leave loop due to !KTHREAD_IS_PARKED

			BUG(wrong cpu)  <--- VOODOO FAILURE

kthread_park(T) <-- VOODOO TOO LATE

You can turn around the order of clearing/setting the flags as much as
you want, I'm going to punch an hole in it.

TASK_PARKED is the very obvious and robust solution which fixes _ALL_
of the corner cases, at least as far as I can imagine them. And
robustness rules at least in my world.

Thanks,

	tglx
