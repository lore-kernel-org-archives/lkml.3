Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaFZVbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 17:31:05 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35749 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaFZVbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 17:31:03 -0400
Message-ID: <53AC9114.9070106@codeaurora.org>
Date: Thu, 26 Jun 2014 14:31:00 -0700
From: Subbaraman Narayanamurthy <subbaram@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kthread: Fix the race condition when kthread is parked
References: <53AB2643.8050901@codeaurora.org> <alpine.DEB.2.10.1406260004110.5170@nanos>
In-Reply-To: <alpine.DEB.2.10.1406260004110.5170@nanos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/14 17:43, Thomas Gleixner wrote:
> The kthread park/unpark logic has the following issue:
>
> Task   CPU 0				CPU 1
>
> T1     unplug cpu1
>         kthread_park(T2)
>         set_bit(KTHREAD_SHOULD_PARK);
> 	  wait_for_completion()
> T2					parkme(X)
> 				   	  __set_current_state(TASK_PARKED);
> 				   	  while (test_bit(KTHREAD_SHOULD_PARK)) {
> 				     	    if (!test_and_set_bit(KTHREAD_IS_PARKED))
> 				              complete();
> 			             	    schedule();
> T1   plug cpu1
>
> --> premature wakeup of T2, i.e. before unpark, so T2 gets scheduled on
>      CPU 0
I understood the explanation above. But still I don't understand how 
this premature wakeup of T2 is happening/possible? Also, what will 
happen if the task state is not in TASK_PARKED when __kthread_unpark is 
called? __kthread_bind will fail silently causing the same problem.
> Reorder the logic so that the unplug code binds the thread to the
> target cpu before clearing the KTHREAD_SHOULD_PARK bit.
>
> Reported-by: Subbaraman Narayanamurthy<subbaram@codeaurora.org>
> Signed-off-by: Thomas Gleixner<tglx@linutronix.de>
> Cc:stable@vger.kernel.org
>
> ---
>   kernel/kthread.c |   14 ++++++++++----
>   1 file changed, 10 insertions(+), 4 deletions(-)
>
> Index: linux/kernel/kthread.c
> ===================================================================
> --- linux.orig/kernel/kthread.c
> +++ linux/kernel/kthread.c
> @@ -382,6 +382,15 @@ struct task_struct *kthread_create_on_cp
>   
>   static void __kthread_unpark(struct task_struct *k, struct kthread *kthread)
>   {
> +	/*
> +	 * Rebind the thread to the target cpu first if it is a per
> +	 * cpu thread unconditionally because it must be bound to the
> +	 * target cpu before it can observe the KTHREAD_SHOULD_PARK
> +	 * bit cleared.
> +	 */
> +	if (test_bit(KTHREAD_IS_PER_CPU, &kthread->flags))
> +		__kthread_bind(k, kthread->cpu, TASK_PARKED);
> +
>   	clear_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
>   	/*
>   	 * We clear the IS_PARKED bit here as we don't wait
> @@ -389,11 +398,8 @@ static void __kthread_unpark(struct task
>   	 * park before that happens we'd see the IS_PARKED bit
>   	 * which might be about to be cleared.
>   	 */
> -	if (test_and_clear_bit(KTHREAD_IS_PARKED, &kthread->flags)) {
> -		if (test_bit(KTHREAD_IS_PER_CPU, &kthread->flags))
> -			__kthread_bind(k, kthread->cpu, TASK_PARKED);
> +	if (test_and_clear_bit(KTHREAD_IS_PARKED, &kthread->flags))
>   		wake_up_state(k, TASK_PARKED);
> -	}
>   }
>   
>   /**
>
>
>
>
>
>
Thanks for the patch. I've tested (running hotplug tests) it for 
sometime and looks good so far. Can you please submit it?

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

