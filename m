Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbaGKJ3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:29:35 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51848 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbaGKJ3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:29:33 -0400
Date: Fri, 11 Jul 2014 11:29:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, Waiman.Long@hp.com, davidlohr@hp.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, riel@redhat.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, hpa@zytor.com,
        tim.c.chen@linux.intel.com, konrad.wilk@oracle.com, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: Re: [PATCH 4/4] rwsem: Reduce the size of struct rw_semaphore
Message-ID: <20140711092922.GG20603@laptop.programming.kicks-ass.net>
References: <1404759019-4268-1-git-send-email-jason.low2@hp.com>
 <1404759019-4268-5-git-send-email-jason.low2@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404759019-4268-5-git-send-email-jason.low2@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 11:50:19AM -0700, Jason Low wrote:
> Recent optimistic spinning additions to rwsem provide significant performance
> benefits on many workloads on large machines. The cost of it was increasing
> the size of the rwsem structure by up to 128 bits.
> 
> However, now that the previous patches in this series bring the overhead of
> struct optimistic_spin_queue to 32 bits, this patch reorders some fields in
> struct rw_semaphore such that we can reduce the overhead of the rwsem structure
> by 64 bits (on 64 bit systems).
> 
> The extra overhead required for rwsem optimistic spinning would now be up
> to 8 additional bytes instead of up to 16 bytes. Additionally, the size of
> rwsem would now be more in line with mutexes.
> 
> Signed-off-by: Jason Low <jason.low2@hp.com>
> ---
>  include/linux/rwsem.h |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
> index 9fdcdd0..f6c54c0 100644
> --- a/include/linux/rwsem.h
> +++ b/include/linux/rwsem.h
> @@ -24,15 +24,15 @@ struct rw_semaphore;
>  /* All arch specific implementations share the same struct */
>  struct rw_semaphore {
>  	long count;
> -	raw_spinlock_t wait_lock;
>  	struct list_head wait_list;
> +	raw_spinlock_t wait_lock;
>  #ifdef CONFIG_SMP
> +	struct optimistic_spin_queue osq; /* spinner MCS lock */
>  	/*
>  	 * Write owner. Used as a speculative check to see
>  	 * if the owner is running on the cpu.
>  	 */
>  	struct task_struct *owner;
> -	struct optimistic_spin_queue osq; /* spinner MCS lock */
>  #endif
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  	struct lockdep_map	dep_map;
> @@ -66,10 +66,10 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
>  #if defined(CONFIG_SMP) && !defined(CONFIG_RWSEM_GENERIC_SPINLOCK)
>  #define __RWSEM_INITIALIZER(name)			\
>  	{ RWSEM_UNLOCKED_VALUE,				\
> -	  __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
>  	  LIST_HEAD_INIT((name).wait_list),		\
> +	  __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
> +	  { ATOMIC_INIT(OSQ_UNLOCKED_VAL) }, /* osq */	\
>  	  NULL, /* owner */				\
> -	  { ATOMIC_INIT(OSQ_UNLOCKED_VAL) } /* osq */   \
>  	  __RWSEM_DEP_MAP_INIT(name) }
>  #else
>  #define __RWSEM_INITIALIZER(name)			\


This gets me:

../init/init_task.c:14:44: error: expected expression before ‘,’ token

          { ATOMIC_INIT(OSQ_UNLOCKED_VAL) }, /* osq */  \
-         NULL, /* owner */                             \
+         NULL /* owner */                              \
          __RWSEM_DEP_MAP_INIT(name) }

Makes it work again.
