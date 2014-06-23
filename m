Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbaFWHJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:09:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:45940 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaFWHJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:09:15 -0400
Date: Mon, 23 Jun 2014 09:09:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v3] lockdep: restrict the use of recursive read_lock with
 qrwlock
Message-ID: <20140623070912.GG19860@laptop.programming.kicks-ass.net>
References: <1403292166-35530-1-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403292166-35530-1-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 03:22:46PM -0400, Waiman Long wrote:
> v2->v3:
>  - Add a new read mode (3) for rwlock (used in
>    lock_acquire_shared_cond_recursive()) to avoid conflict with other
>    use cases of lock_acquire_shared_recursive().
> 
> v1->v2:
>  - Use less conditional & make it easier to read
> 
> Unlike the original unfair rwlock implementation, queued rwlock
> will grant lock according to the chronological sequence of the lock
> requests except when the lock requester is in the interrupt context.
> As a result, recursive read_lock calls will hang the process if there
> is a write_lock call somewhere in between the read_lock calls.
> 
> This patch updates the lockdep implementation to look for recursive
> read_lock calls when queued rwlock is being used.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>

So this Changelog really won't do. This vn->vn+1 nonsense should not be
part of the Changelog proper.

Also, you failed to mention what prompted you to write this patch; did
you find an offending site that now triggers a lockdep warning?

You also fail to mention that the new read state fits, but exhausts, the
storage in held_lock::read.

> ---
>  2 files changed, 19 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
> index 008388f..0a53d88 100644
> --- a/include/linux/lockdep.h
> +++ b/include/linux/lockdep.h
> @@ -481,13 +481,15 @@ static inline void print_irqtrace_events(struct task_struct *curr)
>  #define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 1, n, i)
>  #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 1, n, i)
>  #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 1, n, i)
> +#define lock_acquire_shared_cond_recursive(l, s, t, n, i)	\
> +	lock_acquire(l, s, t, 3, 1, n, i)
>  #define spin_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
>  #define spin_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)
>  #define spin_release(l, n, i)			lock_release(l, n, i)
>  
>  #define rwlock_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
> -#define rwlock_acquire_read(l, s, t, i)		lock_acquire_shared_recursive(l, s, t, NULL, i)
> +#define rwlock_acquire_read(l, s, t, i)		lock_acquire_shared_cond_recursive(l, s, t, NULL, i)

Yeah, no. Only the qrwlock has the new cond_recursive thing.

>  #define rwlock_release(l, n, i)			lock_release(l, n, i)
>  
>  #define seqcount_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
> diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
> index d24e433..7d90ebc 100644
> --- a/kernel/locking/lockdep.c
> +++ b/kernel/locking/lockdep.c
> @@ -67,6 +67,16 @@ module_param(lock_stat, int, 0644);
>  #define lock_stat 0
>  #endif
>  
> +#ifdef CONFIG_QUEUE_RWLOCK
> +/*
> +* Queue rwlock only allows read-after-read recursion of the same lock class
> +* when the latter read is in an interrupt context.
> +*/
> +#define allow_recursive_read	in_interrupt()
> +#else
> +#define allow_recursive_read	true
> +#endif

That #ifdef is entirely inappropriate, the lockdep implementation should
not depend on this. Furthermore you now added a new read state with
variable semantics, that's crap.

>  /*
>   * lockdep_lock: protects the lockdep graph, the hashes and the
>   *               class/list/hash allocators.
> @@ -1774,6 +1784,12 @@ check_deadlock(struct task_struct *curr, struct held_lock *next,
>  			return 2;
>  
>  		/*
> +		 * Conditionally recursive read-lock check
> +		 */
> +		if ((read == 3) && prev->read && allow_recursive_read)
> +			return 2;
> +
> +		/*
>  		 * We're holding the nest_lock, which serializes this lock's
>  		 * nesting behaviour.
>  		 */
> -- 
> 1.7.1
> 
