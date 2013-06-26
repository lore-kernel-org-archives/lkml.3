Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab3FZXGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 19:06:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:37858 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab3FZXG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 19:06:29 -0400
Date: Thu, 27 Jun 2013 01:06:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Waiman Long <Waiman.Long@hp.com>
cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 1/2] spinlock: New spinlock_refcount.h for lockless
 update of refcount
In-Reply-To: <1372268603-46748-2-git-send-email-Waiman.Long@hp.com>
Message-ID: <alpine.DEB.2.02.1306262307020.4013@ionos.tec.linutronix.de>
References: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com> <1372268603-46748-2-git-send-email-Waiman.Long@hp.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jun 2013, Waiman Long wrote:

It would have been nice if you'd had cc'ed people who spent a massive
amount of time working on the spinlock code. Did that now.

> +#ifndef CONFIG_SMP
> +#define __LOCK_WITH_REFCOUNT(lock, count, u_name)	\
> +	unsigned int count;				\
> +	spinlock_t   lock
> +
> +#elif defined(__SPINLOCK_HAS_REFCOUNT)
> +#define __LOCK_WITH_REFCOUNT(lock, count, u_name)	\
> +	union u_name {					\
> +		u64		__lock_count;		\
> +		spinlock_t	lock;			\
> +		struct {				\
> +			arch_spinlock_t __raw_lock;	\
> +			unsigned int	count;		\
> +		};					\
> +	}
> +
> +#else /* __SPINLOCK_HAS_REFCOUNT */
> +#define __LOCK_WITH_REFCOUNT(lock, count, u_name)	\
> +	union u_name {					\
> +		u64		__lock_count;		\
> +		struct {				\
> +			unsigned int	count;		\
> +			spinlock_t	lock;		\
> +		};					\
> +	}
> +
> +#endif /* __SPINLOCK_HAS_REFCOUNT */

This is a complete design disaster. You are violating every single
rule of proper layering. The differentiation of spinlock, raw_spinlock
and arch_spinlock is there for a reason and you just take the current
implementation and map your desired function to it. If we take this,
then we fundamentally ruled out a change to the mappings of spinlock,
raw_spinlock and arch_spinlock. This layering is on purpose and it
took a lot of effort to make it as clean as it is now. Your proposed
change undoes that and completely wreckages preempt-rt.

What's even worse is that you go and fiddle with the basic data
structures:

> diff --git a/include/linux/spinlock_types.h b/include/linux/spinlock_types.h
> index 73548eb..cc107ad 100644
> --- a/include/linux/spinlock_types.h
> +++ b/include/linux/spinlock_types.h
> @@ -17,8 +17,27 @@
>  
>  #include <linux/lockdep.h>
>  
> +/*
> + * The presence of either one of the CONFIG_DEBUG_SPINLOCK or
> + * CONFIG_DEBUG_LOCK_ALLOC configuration parameter will force the
> + * spinlock_t structure to be 8-byte aligned.
> + *
> + * To support the spinlock/reference count combo data type for 64-bit SMP
> + * environment with spinlock debugging turned on, the reference count has
> + * to be integrated into the spinlock_t data structure in this special case.
> + * The spinlock_t data type will be 8 bytes larger if CONFIG_GENERIC_LOCKBREAK
> + * is also defined.
> + */
> +#if defined(CONFIG_64BIT) && (defined(CONFIG_DEBUG_SPINLOCK) ||\
> +			      defined(CONFIG_DEBUG_LOCK_ALLOC))
> +#define	__SPINLOCK_HAS_REFCOUNT	1
> +#endif
> +
>  typedef struct raw_spinlock {
>  	arch_spinlock_t raw_lock;
> +#ifdef __SPINLOCK_HAS_REFCOUNT
> +	unsigned int count;
> +#endif
>  #ifdef CONFIG_GENERIC_LOCKBREAK
>  	unsigned int break_lock;
>  #endif

You need to do that, because you blindly bolt your spinlock extension
into the existing code without taking the time to think about the
design implications.

Do not misunderstand me, I'm impressed by the improvement numbers, but
we need to find a way how this can be done sanely. You really have to
understand that there is a world aside of x86 and big machines. 

Let's have a look at your UP implementation. It's completely broken:

> +/*
> + * Just add the value as the spinlock is a no-op

So what protects that from being preempted? Nothing AFAICT.

What's even worse is that you break all architectures, which have an
arch_spinlock type != sizeof(unsigned int), e.g. SPARC

So what you really want is a new data structure, e.g. something like
struct spinlock_refcount() and a proper set of new accessor functions
instead of an adhoc interface which is designed solely for the needs
of dcache improvements.

The first step to achieve your goal is to consolidate all the
identical copies of arch_spinlock_t and talk to the maintainers of the
architectures which have a different (i.e. !32bit) notion of the arch
specific spinlock implementation, whether it's possible to move over
to a common data struct. Once you have achieved this, you can build
your spinlock + refcount construct upon that.

Thanks,

	tglx
