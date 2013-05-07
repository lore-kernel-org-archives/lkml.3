Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab3EGHvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 03:51:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:60699 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756504Ab3EGHvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 03:51:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,627,1363158000"; 
   d="scan'208";a="333723339"
Message-ID: <5188B272.3010207@intel.com>
Date: Tue, 07 May 2013 15:51:14 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: Re: [PATCH v4 0/6] sched: use runnable load based balance
References: <1367040344-14485-1-git-send-email-alex.shi@intel.com> <20130501121421.GA19602@dyad.programming.kicks-ass.net> <5181B579.9000808@intel.com> <20130502103508.GA13196@dyad.programming.kicks-ass.net> <51836D74.2030409@intel.com>
In-Reply-To: <51836D74.2030409@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2013 03:55 PM, Alex Shi wrote:
> 
>> That should probably look like:
>>
>> 	preempt_disable();
>> 	raw_spin_unlock_irq();
>> 	preempt_enable_no_resched();
>> 	schedule();
>>
>> Otherwise you might find a performance regression on PREEMPT=y kernels.
> 
> Yes, right!
> Thanks a lot for reminder. The following patch will fix it.
>>

Peter, would you like to pick this patch?
> 
> ---
> 
> From 4c9b4b8a9b92bcbe6934637fd33c617e73dbda97 Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi@intel.com>
> Date: Fri, 3 May 2013 14:51:25 +0800
> Subject: [PATCH 8/8] rwsem: small optimizing rwsem_down_failed_common
> 
> Peter Zijlstra suggest adding a preempt_enable_no_resched() to prevent
> a unnecessary scheduler in raw_spin_unlock.
> And we also can pack 2 raw_spin_lock to save one. So has this patch.
> 
> Thanks Peter!
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  lib/rwsem.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/rwsem.c b/lib/rwsem.c
> index ad5e0df..9aacf81 100644
> --- a/lib/rwsem.c
> +++ b/lib/rwsem.c
> @@ -212,23 +212,25 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
>  		 adjustment == -RWSEM_ACTIVE_WRITE_BIAS)
>  		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READ_OWNED);
>  
> -	raw_spin_unlock_irq(&sem->wait_lock);
> -
>  	/* wait to be given the lock */
>  	for (;;) {
> -		if (!waiter.task)
> +		if (!waiter.task) {
> +			raw_spin_unlock_irq(&sem->wait_lock);
>  			break;
> +		}
>  
> -		raw_spin_lock_irq(&sem->wait_lock);
> -		/* Try to get the writer sem, may steal from the head writer: */
> +		/* Try to get the writer sem, may steal from the head writer */
>  		if (flags == RWSEM_WAITING_FOR_WRITE)
>  			if (try_get_writer_sem(sem, &waiter)) {
>  				raw_spin_unlock_irq(&sem->wait_lock);
>  				return sem;
>  			}
> +		preempt_disable();
>  		raw_spin_unlock_irq(&sem->wait_lock);
> +		preempt_enable_no_resched();
>  		schedule();
>  		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
> +		raw_spin_lock_irq(&sem->wait_lock);
>  	}
>  
>  	tsk->state = TASK_RUNNING;
> 


-- 
Thanks
    Alex
