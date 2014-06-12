Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbaFLB2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 21:28:36 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:13559 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaFLB2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 21:28:35 -0400
Message-ID: <53990241.5040508@hp.com>
Date: Wed, 11 Jun 2014 21:28:33 -0400
From: "Long, Wai Man" <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>, mingo@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, tim.c.chen@linux.intel.com,
        paulmck@linux.vnet.ibm.com, rostedt@goodmis.org, davidlohr@hp.com,
        scott.norton@hp.com, aswin@hp.com
Subject: Re: [PATCH v2 3/4] mutex: Try to acquire mutex only if it is unlocked
References: <1402511843-4721-1-git-send-email-jason.low2@hp.com> <1402511843-4721-4-git-send-email-jason.low2@hp.com>
In-Reply-To: <1402511843-4721-4-git-send-email-jason.low2@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 6/11/2014 2:37 PM, Jason Low wrote:
> Upon entering the slowpath in __mutex_lock_common(), we try once more to
> acquire the mutex. We only try to acquire if (lock->count >= 0). However,
> what we actually want here is to try to acquire if the mutex is unlocked
> (lock->count == 1).
>    
> This patch changes it so that we only try-acquire the mutex upon entering
> the slowpath if it is unlocked, rather than if the lock count is non-negative.
> This helps further reduce unnecessary atomic xchg() operations.
>
> Furthermore, this patch uses !mutex_is_locked(lock) to do the initial
> checks for if the lock is free rather than directly calling atomic_read()
> on the lock->count, in order to improve readability.
>
> Signed-off-by: Jason Low <jason.low2@hp.com>
> ---
>   kernel/locking/mutex.c |    7 ++++---
>   1 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> index 4bd9546..e4d997b 100644
> --- a/kernel/locking/mutex.c
> +++ b/kernel/locking/mutex.c
> @@ -432,7 +432,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>   		if (owner && !mutex_spin_on_owner(lock, owner))
>   			break;
>   
> -		if ((atomic_read(&lock->count) == 1) &&
> +		/* Try to acquire the mutex if it is unlocked. */
> +		if (!mutex_is_locked(lock) &&
>   		    (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {
>   			lock_acquired(&lock->dep_map, ip);
>   			if (use_ww_ctx) {
> @@ -479,9 +480,9 @@ slowpath:
>   
>   	/*
>   	 * Once more, try to acquire the lock. Only try-lock the mutex if
> -	 * lock->count >= 0 to reduce unnecessary xchg operations.
> +	 * it is unlocked to reduce unnecessary xchg() operations.
>   	 */
> -	if (atomic_read(&lock->count) >= 0 && (atomic_xchg(&lock->count, 0) == 1))
> +	if (!mutex_is_locked(lock) && (atomic_xchg(&lock->count, 0) == 1))
>   		goto skip_wait;
>   
>   	debug_mutex_lock_common(lock, &waiter);

Acked-by: Waiman Long <Waiman.Long@hp.com>


