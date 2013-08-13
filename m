Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab3HMH4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 03:56:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47684 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab3HMH4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 03:56:20 -0400
Date: Tue, 13 Aug 2013 09:55:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Long Gao <gaolong@kylinos.com.cn>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] sched: fix the theoretical signal_wake_up() vs
 schedule() race
Message-ID: <20130813075550.GS27162@twins.programming.kicks-ass.net>
References: <tencent_26310211398C21034BD3B2F9@qq.com>
 <CA+55aFwAnWZGkXbyLmL3RxQGW-dX_jjDBPfA5PjxeVWn==a6tA@mail.gmail.com>
 <20130808191749.GA12062@redhat.com>
 <CA+55aFw+vEp6+q+QUZm5rf+sKR9z76HWzEqWjoiLtataym5uwA@mail.gmail.com>
 <20130809130457.GA27493@redhat.com>
 <CA+55aFxh+4yK3AkPQWGq+hGhBgvDdWuPSfzko2aO76y7ej=Veg@mail.gmail.com>
 <20130812170257.GA32358@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130812170257.GA32358@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 07:02:57PM +0200, Oleg Nesterov wrote:
> This is only theoretical, but after try_to_wake_up(p) was changed
> to check p->state under p->pi_lock the code like
> 
> 	__set_current_state(TASK_INTERRUPTIBLE);
> 	schedule();
> 
> can miss a signal. This is the special case of wait-for-condition,
> it relies on try_to_wake_up/schedule interaction and thus it does
> not need mb() between __set_current_state() and if(signal_pending).
> 
> However, this __set_current_state() can move into the critical
> section protected by rq->lock, now that try_to_wake_up() takes
> another lock we need to ensure that it can't be reordered with
> "if (signal_pending(current))" check inside that section.
> 
> The patch is actually one-liner, it simply adds smp_wmb() before
> spin_lock_irq(rq->lock). This is what try_to_wake_up() already
> does by the same reason.
> 
> We turn this wmb() into the new helper, smp_mb__before_spinlock(),
> for better documentation and to allow the architectures to change
> the default implementation.
> 
> While at it, kill smp_mb__after_lock(), it has no callers.
> 
> Perhaps we can also add smp_mb__before/after_spinunlock() for
> prepare_to_wait().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Thanks!

> +/*
> + * Despite its name it doesn't necessarily has to be a full barrier.
> + * It should only guarantee that a STORE before the critical section
> + * can not be reordered with a LOAD inside this section.
> + * So the default implementation simply ensures that a STORE can not
> + * move into the critical section, smp_wmb() should serialize it with
> + * another STORE done by spin_lock().
> + */
> +#ifndef smp_mb__before_spinlock
> +#define smp_mb__before_spinlock()	smp_wmb()
>  #endif

I would have expected mention of the ACQUIRE of the lock keeping the
LOAD inside the locked section.


