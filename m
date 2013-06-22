Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423684Ab3FVHVq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 03:21:46 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:51782 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751152Ab3FVHVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 03:21:45 -0400
Message-ID: <51C55082.5040500@hurleysoftware.com>
Date: Sat, 22 Jun 2013 03:21:38 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>, Alex Shi <alex.shi@intel.com>,
        Michel Lespinasse <walken@google.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] rwsem: check the lock before cpmxchg in down_write_trylock
 and rwsem_do_wake
References: <cover.1371855277.git.tim.c.chen@linux.intel.com> <1371858695.22432.4.camel@schen9-DESK>
In-Reply-To: <1371858695.22432.4.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 07:51 PM, Tim Chen wrote:
> Doing cmpxchg will cause cache bouncing when checking
> sem->count. This could cause scalability issue
> in a large machine (e.g. a 80 cores box).
>
> A pre-read of sem->count can mitigate this.
>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---
>   include/asm-generic/rwsem.h |    8 ++++----
>   lib/rwsem.c                 |   21 +++++++++++++--------
>   2 files changed, 17 insertions(+), 12 deletions(-)
>
> diff --git a/include/asm-generic/rwsem.h b/include/asm-generic/rwsem.h
> index bb1e2cd..052d973 100644
> --- a/include/asm-generic/rwsem.h
> +++ b/include/asm-generic/rwsem.h
> @@ -70,11 +70,11 @@ static inline void __down_write(struct rw_semaphore *sem)
>
>   static inline int __down_write_trylock(struct rw_semaphore *sem)
>   {
> -	long tmp;
> +	if (unlikely(&sem->count != RWSEM_UNLOCKED_VALUE))
                      ^^^^^^^^^^^

This is probably not what you want.


> +		return 0;
>
> -	tmp = cmpxchg(&sem->count, RWSEM_UNLOCKED_VALUE,
> -		      RWSEM_ACTIVE_WRITE_BIAS);
> -	return tmp == RWSEM_UNLOCKED_VALUE;
> +	return cmpxchg(&sem->count, RWSEM_UNLOCKED_VALUE,
> +		RWSEM_ACTIVE_WRITE_BIAS) == RWSEM_UNLOCKED_VALUE;
>   }
>
>   /*
> diff --git a/lib/rwsem.c b/lib/rwsem.c
> index 19c5fa9..2072af5 100644
> --- a/lib/rwsem.c
> +++ b/lib/rwsem.c
> @@ -75,7 +75,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, enum rwsem_wake_type wake_type)
>   			 * will block as they will notice the queued writer.
>   			 */
>   			wake_up_process(waiter->task);
> -		goto out;
> +		return sem;

Please put these flow control changes in a separate patch.


>   	}
>
>   	/* Writers might steal the lock before we grant it to the next reader.
> @@ -85,15 +85,21 @@ __rwsem_do_wake(struct rw_semaphore *sem, enum rwsem_wake_type wake_type)
>   	adjustment = 0;
>   	if (wake_type != RWSEM_WAKE_READ_OWNED) {
>   		adjustment = RWSEM_ACTIVE_READ_BIAS;
> - try_reader_grant:
> -		oldcount = rwsem_atomic_update(adjustment, sem) - adjustment;
> -		if (unlikely(oldcount < RWSEM_WAITING_BIAS)) {
> -			/* A writer stole the lock. Undo our reader grant. */
> +		while (1) {
> +			/* A writer stole the lock. */
> +			if (sem->count < RWSEM_WAITING_BIAS)
> +				return sem;

I'm all for structured looping instead of goto labels but this optimization
is only useful on the 1st iteration. IOW, on the second iteration you already
know that you need to try for reclaiming the lock.


> +
> +			oldcount = rwsem_atomic_update(adjustment, sem)
> +								- adjustment;
> +			if (likely(oldcount >= RWSEM_WAITING_BIAS))
> +				break;
> +
> +			 /* A writer stole the lock.  Undo our reader grant. */
>   			if (rwsem_atomic_update(-adjustment, sem) &
>   						RWSEM_ACTIVE_MASK)
> -				goto out;
> +				return sem;
>   			/* Last active locker left. Retry waking readers. */
> -			goto try_reader_grant;
>   		}
>   	}
>
> @@ -136,7 +142,6 @@ __rwsem_do_wake(struct rw_semaphore *sem, enum rwsem_wake_type wake_type)
>   	sem->wait_list.next = next;
>   	next->prev = &sem->wait_list;
>
> - out:
>   	return sem;
>   }


Alex and Tim,

Was there a v1 of this series; ie., is this v2 (or higher)?

How are you validating lock correctness/behavior with this series?

Regards,
Peter Hurley

