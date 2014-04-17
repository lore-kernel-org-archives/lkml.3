Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbaDQPmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:42:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58101 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbaDQPma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:42:30 -0400
Date: Thu, 17 Apr 2014 17:42:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v9 03/19] qspinlock: Add pending bit
Message-ID: <20140417154200.GN11096@twins.programming.kicks-ass.net>
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
 <1397747051-15401-4-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397747051-15401-4-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 11:03:55AM -0400, Waiman Long wrote:
> +/**
> + * trylock_pending - try to acquire queue spinlock using the pending bit
> + * @lock : Pointer to queue spinlock structure
> + * @pval : Pointer to value of the queue spinlock 32-bit word
> + * Return: 1 if lock acquired, 0 otherwise
> + */
> +static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
> +{
> +	u32 old, new, val = *pval;

I'm not thrilled about you breaking this into a separate function; the
compiler will put it right back and now you get to have that ugly
pointer stuff.

It also makes the function control flow not match the state diagram
anymore.

> +
> +	/*
> +	 * trylock || pending
> +	 *
> +	 * 0,0,0 -> 0,0,1 ; trylock
> +	 * 0,0,1 -> 0,1,1 ; pending
> +	 */
> +	for (;;) {
> +		/*
> +		 * If we observe any contention; queue.
> +		 */
> +		if (val & ~_Q_LOCKED_MASK)
> +			return 0;
> +
> +		new = _Q_LOCKED_VAL;
> +		if (val == new)
> +			new |= _Q_PENDING_VAL;
> +
> +		old = atomic_cmpxchg(&lock->val, val, new);
> +		if (old == val)
> +			break;
> +
> +		*pval = val = old;
> +	}
> +
> +	/*
> +	 * we won the trylock
> +	 */
> +	if (new == _Q_LOCKED_VAL)
> +		return 1;
> +
> +	/*
> +	 * we're pending, wait for the owner to go away.
> +	 *
> +	 * *,1,1 -> *,1,0
> +	 */
> +	while ((val = atomic_read(&lock->val)) & _Q_LOCKED_MASK)
> +		arch_mutex_cpu_relax();

That was a cpu_relax().

> +
> +	/*
> +	 * take ownership and clear the pending bit.
> +	 *
> +	 * *,1,0 -> *,0,1
> +	 */
> +	for (;;) {
> +		new = (val & ~_Q_PENDING_MASK) | _Q_LOCKED_VAL;
> +
> +		old = atomic_cmpxchg(&lock->val, val, new);
> +		if (old == val)
> +			break;
> +
> +		val = old;
> +	}
> +	return 1;
> +}
