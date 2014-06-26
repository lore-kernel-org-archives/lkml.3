Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964779AbaFZCAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 22:00:30 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:36277 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932317AbaFZCAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 22:00:25 -0400
Date: Wed, 25 Jun 2014 22:00:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Subbaraman Narayanamurthy <subbaram@codeaurora.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kthread: Fix the race condition when kthread is parked
Message-ID: <20140626020022.GA25209@home.goodmis.org>
References: <53AB2643.8050901@codeaurora.org>
 <alpine.DEB.2.10.1406260004110.5170@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1406260004110.5170@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 02:43:56AM +0200, Thomas Gleixner wrote:
> 
> Subject: kthread: Plug park/ unplug race
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Thu, 26 Jun 2014 01:24:36 +0200
> 
> The kthread park/unpark logic has the following issue:
> 
> Task   CPU 0				CPU 1
> 
> T1     unplug cpu1
>        kthread_park(T2)
>        set_bit(KTHREAD_SHOULD_PARK);
> 	  wait_for_completion()
> T2					parkme(X)

But with your patch, isn't it possible for T1 to call thread_unpark here?

Then looking at the code I see this turn of events:

  if (test_bit(KTHREAD_IS_PER_CPU, &kthread->flags))
        __kthread_bind(k, kthread->cpu, TASK_PARKED);

Which in __kthread_bind() (state == TASK_PARKED)

	if (!wait_task_inactive(p, state)) {
		WARN_ON(1);
		return;
	}

Where wait_task_inactive() does:

		while (task_running(rq, p)) {
			if (match_state && unlikely(p->state != match_state))
				return 0;

As match_state is non zero and p->state != match_state because it hasn't been
set yet. The wait_task_inactive() returns zero, and then we hit the WARN_ON()
in __kthread_bind().

-- Steve



> 				   	  __set_current_state(TASK_PARKED);
> 				   	  while (test_bit(KTHREAD_SHOULD_PARK)) {
> 				     	    if (!test_and_set_bit(KTHREAD_IS_PARKED))
> 				              complete();
> 			             	    schedule();
> T1   plug cpu1
> 
> --> premature wakeup of T2, i.e. before unpark, so T2 gets scheduled on
>     CPU 0
> 
> T2    __set_current_state(TASK_PARKED);
> 
> --> Preemption by the plug thread
> 
> T1     thread_unpark(T2)
>          clear_bit(KTHREAD_SHOULD_PARK);
> 
> --> Preemption by the softirq thread which breaks out of the
>     while(test_bit(KTHREAD_SHOULD_PARK)) loop because
>     KTHREAD_SHOULD_PARK is not longer set.
> 
> T2   }
>     clear_bit(KTHREAD_IS_PARKED);
> 
> --> Now T2 happily continues to run on CPU0 which rightfully causes
>     the BUG_ON(T2->cpu != smp_processor_id()) to trigger.
> 
> T1
> 	__kthread_bind(T2)
> 
> --> Too late ....
> 
> Reorder the logic so that the unplug code binds the thread to the
> target cpu before clearing the KTHREAD_SHOULD_PARK bit.
> 
> Reported-by: Subbaraman Narayanamurthy <subbaram@codeaurora.org>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@vger.kernel.org
> 
> ---
>  kernel/kthread.c |   14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> Index: linux/kernel/kthread.c
> ===================================================================
> --- linux.orig/kernel/kthread.c
> +++ linux/kernel/kthread.c
> @@ -382,6 +382,15 @@ struct task_struct *kthread_create_on_cp
>  
>  static void __kthread_unpark(struct task_struct *k, struct kthread *kthread)
>  {
> +	/*
> +	 * Rebind the thread to the target cpu first if it is a per
> +	 * cpu thread unconditionally because it must be bound to the
> +	 * target cpu before it can observe the KTHREAD_SHOULD_PARK
> +	 * bit cleared.
> +	 */
> +	if (test_bit(KTHREAD_IS_PER_CPU, &kthread->flags))
> +		__kthread_bind(k, kthread->cpu, TASK_PARKED);
> +
>  	clear_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
>  	/*
>  	 * We clear the IS_PARKED bit here as we don't wait
> @@ -389,11 +398,8 @@ static void __kthread_unpark(struct task
>  	 * park before that happens we'd see the IS_PARKED bit
>  	 * which might be about to be cleared.
>  	 */
> -	if (test_and_clear_bit(KTHREAD_IS_PARKED, &kthread->flags)) {
> -		if (test_bit(KTHREAD_IS_PER_CPU, &kthread->flags))
> -			__kthread_bind(k, kthread->cpu, TASK_PARKED);
> +	if (test_and_clear_bit(KTHREAD_IS_PARKED, &kthread->flags))
>  		wake_up_state(k, TASK_PARKED);
> -	}
>  }
>  
>  /**
> 
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
