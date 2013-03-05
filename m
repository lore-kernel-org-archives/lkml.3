Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3CEPRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:17:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:45426 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab3CEPRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:17:21 -0500
X-IronPort-AV: E=Sophos;i="4.84,788,1355068800"; 
   d="scan'208";a="6818394"
Message-ID: <51360CFC.7040807@cn.fujitsu.com>
Date: Tue, 05 Mar 2013 23:19:24 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        paulmck@linux.vnet.ibm.com, Rusty Russell <rusty@rustcorp.com.au>,
        rostedt@goodmis.org, tglx@linutronix.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] lockdep: introduce lock_acquire_exclusive/shared
 helper macros
References: <1362449845-7492-1-git-send-email-walken@google.com> <1362449845-7492-2-git-send-email-walken@google.com>
In-Reply-To: <1362449845-7492-2-git-send-email-walken@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/05 23:16:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/05 23:16:17,
	Serialize complete at 2013/03/05 23:16:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/03/13 10:17, Michel Lespinasse wrote:
> In lockdep.h, the spinlock/mutex/rwsem/rwlock/lock_map acquire macros
> have different definitions based on the value of CONFIG_PROVE_LOCKING.
> We have separate ifdefs for each of these definitions, which seems
> redundant.
> 
> Introduce lock_acquire_{exclusive,shared,shared_recursive} helpers
> which will have different definitions based on CONFIG_PROVE_LOCKING.
> Then all other helper macros can be defined based on the above ones,
> which reduces the amount of ifdefined code.
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>
> 
> ---
>  include/linux/lockdep.h | 92 +++++++++++++------------------------------------
>  1 file changed, 23 insertions(+), 69 deletions(-)
> 
> diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
> index f1e877b79ed8..cfc2f119779a 100644
> --- a/include/linux/lockdep.h
> +++ b/include/linux/lockdep.h
> @@ -365,7 +365,7 @@ extern void lockdep_trace_alloc(gfp_t mask);
>  
>  #define lockdep_recursing(tsk)	((tsk)->lockdep_recursion)
>  
> -#else /* !LOCKDEP */
> +#else /* !CONFIG_LOCKDEP */
>  
>  static inline void lockdep_off(void)
>  {
> @@ -479,82 +479,36 @@ static inline void print_irqtrace_events(struct task_struct *curr)
>   * on the per lock-class debug mode:
>   */
>  
> -#ifdef CONFIG_DEBUG_LOCK_ALLOC
> -# ifdef CONFIG_PROVE_LOCKING
> -#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
> -#  define spin_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
> -# else
> -#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
> -#  define spin_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 1, NULL, i)
> -# endif
> -# define spin_release(l, n, i)			lock_release(l, n, i)
> +#ifdef CONFIG_PROVE_LOCKING
> + #define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 2, n, i)
> + #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 2, n, i)
> + #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 2, n, i)

Hi, Michel

I don't like the name lock_acquire_shared_recursive().
(I mean the name is wrong, ......)

In the lockdep design, lock_acquire(l, s, t, 2, 2, n, i) is used for
read-preference locks(rwlock) and all types of RCU. not for "recursive"
read-preference implies "recursive".

But the name lock_acquire_shared_recursive() don't tell us it is
read-preference.

Example if we do have a lock which is write-preference but allow read_lock recursive,
it will be still deadlock in this way, "recursive" does not help:

cpu0: spin_lock(a);				recursiveable_read_lock(b)
cpu1: recursiveable_read_lock(b); 		spin_lock(a);
cpu2:				write_lock(b);


I also noticed the lockdep annotations problem of lglock. and patch2 is good,
so for patch2: Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com> 


Thanks,
Lai

>  #else
> -# define spin_acquire(l, s, t, i)		do { } while (0)
> -# define spin_release(l, n, i)			do { } while (0)
> + #define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 1, n, i)
> + #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 1, n, i)
> + #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 1, n, i)
>  #endif
>  
> -#ifdef CONFIG_DEBUG_LOCK_ALLOC
> -# ifdef CONFIG_PROVE_LOCKING
> -#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
> -#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 2, NULL, i)
> -# else
> -#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
> -#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 1, NULL, i)
> -# endif
> -# define rwlock_release(l, n, i)		lock_release(l, n, i)
> -#else
> -# define rwlock_acquire(l, s, t, i)		do { } while (0)
> -# define rwlock_acquire_read(l, s, t, i)	do { } while (0)
> -# define rwlock_release(l, n, i)		do { } while (0)
> -#endif
> +#define spin_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
> +#define spin_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)
> +#define spin_release(l, n, i)			lock_release(l, n, i)
>  
> -#ifdef CONFIG_DEBUG_LOCK_ALLOC
> -# ifdef CONFIG_PROVE_LOCKING
> -#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
> -#  define mutex_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
> -# else
> -#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
> -#  define mutex_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 1, n, i)
> -# endif
> -# define mutex_release(l, n, i)			lock_release(l, n, i)
> -#else
> -# define mutex_acquire(l, s, t, i)		do { } while (0)
> -# define mutex_acquire_nest(l, s, t, n, i)	do { } while (0)
> -# define mutex_release(l, n, i)			do { } while (0)
> -#endif
> +#define rwlock_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
> +#define rwlock_acquire_read(l, s, t, i)		lock_acquire_shared_recursive(l, s, t, NULL, i)
> +#define rwlock_release(l, n, i)			lock_release(l, n, i)
>  
> -#ifdef CONFIG_DEBUG_LOCK_ALLOC
> -# ifdef CONFIG_PROVE_LOCKING
> -#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
> -#  define rwsem_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
> -#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 2, NULL, i)
> -# else
> -#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
> -#  define rwsem_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 1, n, i)
> -#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 1, NULL, i)
> -# endif
> +#define mutex_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
> +#define mutex_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)
> +#define mutex_release(l, n, i)			lock_release(l, n, i)
> +
> +#define rwsem_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
> +#define rwsem_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)
> +#define rwsem_acquire_read(l, s, t, i)		lock_acquire_shared(l, s, t, NULL, i)
>  # define rwsem_release(l, n, i)			lock_release(l, n, i)
> -#else
> -# define rwsem_acquire(l, s, t, i)		do { } while (0)
> -# define rwsem_acquire_nest(l, s, t, n, i)	do { } while (0)
> -# define rwsem_acquire_read(l, s, t, i)		do { } while (0)
> -# define rwsem_release(l, n, i)			do { } while (0)
> -#endif
>  
> -#ifdef CONFIG_DEBUG_LOCK_ALLOC
> -# ifdef CONFIG_PROVE_LOCKING
> -#  define lock_map_acquire(l)		lock_acquire(l, 0, 0, 0, 2, NULL, _THIS_IP_)
> -#  define lock_map_acquire_read(l)	lock_acquire(l, 0, 0, 2, 2, NULL, _THIS_IP_)
> -# else
> -#  define lock_map_acquire(l)		lock_acquire(l, 0, 0, 0, 1, NULL, _THIS_IP_)
> -#  define lock_map_acquire_read(l)	lock_acquire(l, 0, 0, 2, 1, NULL, _THIS_IP_)
> -# endif
> +#define lock_map_acquire(l)			lock_acquire_exclusive(l, 0, 0, NULL, _THIS_IP_)
> +#define lock_map_acquire_read(l)		lock_acquire_shared_recursive(l, 0, 0, NULL, _THIS_IP_)
>  # define lock_map_release(l)			lock_release(l, 1, _THIS_IP_)
> -#else
> -# define lock_map_acquire(l)			do { } while (0)
> -# define lock_map_acquire_read(l)		do { } while (0)
> -# define lock_map_release(l)			do { } while (0)
> -#endif
>  
>  #ifdef CONFIG_PROVE_LOCKING
>  # define might_lock(lock) 						\

