Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbaD3IB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:01:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:34558 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaD3IBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:01:55 -0400
Date: Wed, 30 Apr 2014 10:01:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rwsem: Support optimistic spinning
Message-ID: <20140430080148.GZ11096@twins.programming.kicks-ass.net>
References: <1398205166.6345.7.camel@buesod1.americas.hpqcorp.net>
 <1398722941.25549.16.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398722941.25549.16.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 03:09:01PM -0700, Davidlohr Bueso wrote:
> @@ -26,6 +27,10 @@ struct rw_semaphore {
>  	long			count;
>  	raw_spinlock_t		wait_lock;
>  	struct list_head	wait_list;
> +#ifdef CONFIG_SMP
> +	struct task_struct	     *owner; /* write owner */
> +	struct optimistic_spin_queue *osq;   /* spinner MCS lock */
> +#endif
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  	struct lockdep_map	dep_map;
>  #endif
> @@ -55,11 +60,21 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
>  # define __RWSEM_DEP_MAP_INIT(lockname)
>  #endif
>  
> +#ifdef CONFIG_SMP
> +#define __RWSEM_INITIALIZER(name)			\
> +	{ RWSEM_UNLOCKED_VALUE,				\
> +	  __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
> +	  LIST_HEAD_INIT((name).wait_list),		\
> +	  NULL, /* owner */				\
> +	  NULL /* mcs lock */                           \
> +	  __RWSEM_DEP_MAP_INIT(name) }
> +#else
>  #define __RWSEM_INITIALIZER(name)			\
>  	{ RWSEM_UNLOCKED_VALUE,				\
>  	  __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
>  	  LIST_HEAD_INIT((name).wait_list)		\
>  	  __RWSEM_DEP_MAP_INIT(name) }
> +#endif

I'm not saying you should change this; but something like:

#ifdef CONFIG_SMP
# define __RWSEM_SMP_INIT(name)	, .owner = NULL, .osq = NULL
#else
# define __RWSEM_SMP_INIT(name)
#endif

#define __RWSEM_INITIALIZER(name)	{			\
	.count = RWSEM_UNLOCKED_VALUE,				\
	.wait_lock = __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
	.wait_list = LIST_HEAD_INIT(name.wait_list)		\
	__RWSEM_SMP_INIT(name)					\
	__RWSEM_DEP_MAP_INIT(name)				\
}

might be more readable in general.
