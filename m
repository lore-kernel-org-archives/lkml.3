Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbaFLB1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 21:27:39 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:12896 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaFLB1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 21:27:38 -0400
Message-ID: <539901FD.2020101@hp.com>
Date: Wed, 11 Jun 2014 21:27:25 -0400
From: "Long, Wai Man" <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>, mingo@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, tim.c.chen@linux.intel.com,
        paulmck@linux.vnet.ibm.com, rostedt@goodmis.org, davidlohr@hp.com,
        scott.norton@hp.com, aswin@hp.com
Subject: Re: [PATCH v2 2/4] mutex: Delete the MUTEX_SHOW_NO_WAITER macro
References: <1402511843-4721-1-git-send-email-jason.low2@hp.com> <1402511843-4721-3-git-send-email-jason.low2@hp.com>
In-Reply-To: <1402511843-4721-3-git-send-email-jason.low2@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 6/11/2014 2:37 PM, Jason Low wrote:
> v1->v2:
> - There were discussions in v1 about a possible mutex_has_waiters()
>    function. This patch didn't use that function because the places which
>    used MUTEX_SHOW_NO_WAITER requires checking for lock->count while an
>    actual mutex_has_waiters() should check for !list_empty(wait_list).
>    We'll just delete the macro and directly use atomic_read() + comments.
>
> MUTEX_SHOW_NO_WAITER() is a macro which checks for if there are
> "no waiters" on a mutex by checking if the lock count is non-negative.
> Based on feedback from the discussion in the earlier version of this
> patchset, the macro is not very readable.
>    
> Furthermore, checking lock->count isn't always the correct way to
> determine if there are "no waiters" on a mutex. For example, a negative
> count on a mutex really only means that there "potentially" are
> waiters. Likewise, there can be waiters on the mutex even if the count is
> non-negative. Thus, "MUTEX_SHOW_NO_WAITER" doesn't always do what the name
> of the macro suggests.
>   
> So this patch deletes the MUTEX_SHOW_NO_WAITERS() macro, directly
> use atomic_read() instead of the macro, and adds comments which
> elaborate on how the extra atomic_read() checks can help reduce
> unnecessary xchg() operations.
>
> Signed-off-by: Jason Low <jason.low2@hp.com>
> ---
>   kernel/locking/mutex.c |   18 ++++++++----------
>   1 files changed, 8 insertions(+), 10 deletions(-)
>
> diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> index dd26bf6..4bd9546 100644
> --- a/kernel/locking/mutex.c
> +++ b/kernel/locking/mutex.c
> @@ -46,12 +46,6 @@
>   # include <asm/mutex.h>
>   #endif
>   
> -/*
> - * A negative mutex count indicates that waiters are sleeping waiting for the
> - * mutex.
> - */
> -#define	MUTEX_SHOW_NO_WAITER(mutex)	(atomic_read(&(mutex)->count) >= 0)
> -
>   void
>   __mutex_init(struct mutex *lock, const char *name, struct lock_class_key *key)
>   {
> @@ -483,8 +477,11 @@ slowpath:
>   #endif
>   	spin_lock_mutex(&lock->wait_lock, flags);
>   
> -	/* once more, can we acquire the lock? */
> -	if (MUTEX_SHOW_NO_WAITER(lock) && (atomic_xchg(&lock->count, 0) == 1))
> +	/*
> +	 * Once more, try to acquire the lock. Only try-lock the mutex if
> +	 * lock->count >= 0 to reduce unnecessary xchg operations.
> +	 */
> +	if (atomic_read(&lock->count) >= 0 && (atomic_xchg(&lock->count, 0) == 1))
>   		goto skip_wait;
>   
>   	debug_mutex_lock_common(lock, &waiter);
> @@ -504,9 +501,10 @@ slowpath:
>   		 * it's unlocked. Later on, if we sleep, this is the
>   		 * operation that gives us the lock. We xchg it to -1, so
>   		 * that when we release the lock, we properly wake up the
> -		 * other waiters:
> +		 * other waiters. We only attempt the xchg if the count is
> +		 * non-negative in order to avoid unnecessary xchg operations:
>   		 */
> -		if (MUTEX_SHOW_NO_WAITER(lock) &&
> +		if (atomic_read(&lock->count) >= 0 &&
>   		    (atomic_xchg(&lock->count, -1) == 1))
>   			break;
>   

Acked-by: Waiman Long <Waiman.Long@hp.com>

