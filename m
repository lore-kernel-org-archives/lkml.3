Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbaIPUIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:08:55 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:34505 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751691AbaIPUIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:08:54 -0400
Message-ID: <541898C7.6070508@hurleysoftware.com>
Date: Tue, 16 Sep 2014 16:08:39 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Tim Chen <tim.c.chen@linux.intel.com>,
        Davidlohr Bueso <dbueso@suse.de>
CC: linux-kernel@vger.kernel.org, Aswin Chandramouleeswaran <aswin@hp.com>,
        Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v2] locking/rwsem: Avoid double checking before try acquiring
 write lock
References: <1410894118.2447.4.camel@j-VirtualBox>
In-Reply-To: <1410894118.2447.4.camel@j-VirtualBox>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On 09/16/2014 03:01 PM, Jason Low wrote:
> Commit 9b0fc9c09f1b checks for if there are known active lockers in
> order to avoid write trylocking using expensive cmpxchg() when it
> likely wouldn't get the lock.
> 
> However, a subsequent patch was added such that we directly check for
> sem->count == RWSEM_WAITING_BIAS right before trying that cmpxchg().
> Thus, commit 9b0fc9c09f1b now just adds extra overhead. This patch
> deletes it.

It would be better to just not reload sem->count, and check the parameter
count == RWSEM_WAITING_BIAS instead. The count parameter is a very recent
load of sem->count (one of which is the latest exclusive read from an
atomic operation), so likely to be just as accurate as a reload of
sem->count without causing more cache line contention.

Regards,
Peter Hurley

> Also, add a comment on why we do an "extra check" of sem->count before
> the cmpxchg().
> 
> Signed-off-by: Jason Low <jason.low2@hp.com>
> ---
>  kernel/locking/rwsem-xadd.c |   24 +++++++++++++-----------
>  1 files changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
> index d6203fa..63d3ef2 100644
> --- a/kernel/locking/rwsem-xadd.c
> +++ b/kernel/locking/rwsem-xadd.c
> @@ -247,18 +247,20 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
>  	return sem;
>  }
>  
> -static inline bool rwsem_try_write_lock(long count, struct rw_semaphore *sem)
> +static inline bool rwsem_try_write_lock(struct rw_semaphore *sem)
>  {
> -	if (!(count & RWSEM_ACTIVE_MASK)) {
> -		/* try acquiring the write lock */
> -		if (sem->count == RWSEM_WAITING_BIAS &&
> -		    cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
> -			    RWSEM_ACTIVE_WRITE_BIAS) == RWSEM_WAITING_BIAS) {
> -			if (!list_is_singular(&sem->wait_list))
> -				rwsem_atomic_update(RWSEM_WAITING_BIAS, sem);
> -			return true;
> -		}
> +	/*
> +	 * Try acquiring the write lock. Check sem->count first
> +	 * in order to reduce unnecessary expensive cmpxchg() operations.
> +	 */
> +	if (sem->count == RWSEM_WAITING_BIAS &&
> +	    cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
> +		    RWSEM_ACTIVE_WRITE_BIAS) == RWSEM_WAITING_BIAS) {
> +		if (!list_is_singular(&sem->wait_list))
> +			rwsem_atomic_update(RWSEM_WAITING_BIAS, sem);
> +		return true;
>  	}
> +
>  	return false;
>  }
>  
> @@ -446,7 +448,7 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
>  	/* wait until we successfully acquire the lock */
>  	set_current_state(TASK_UNINTERRUPTIBLE);
>  	while (true) {
> -		if (rwsem_try_write_lock(count, sem))
> +		if (rwsem_try_write_lock(sem))
>  			break;
>  		raw_spin_unlock_irq(&sem->wait_lock);
>  
> 

