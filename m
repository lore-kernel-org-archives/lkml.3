Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbaFWQf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:35:28 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41578 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375AbaFWQf0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:35:26 -0400
Date: Mon, 23 Jun 2014 18:35:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Waiman.Long@hp.com, tglx@linutronix.de, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, boris.ostrovsky@oracle.com,
        paulmck@linux.vnet.ibm.com, riel@redhat.com,
        torvalds@linux-foundation.org, raghavendra.kt@linux.vnet.ibm.com,
        david.vrabel@citrix.com, oleg@redhat.com, gleb@redhat.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: Re: [PATCH 03/11] qspinlock: Add pending bit
Message-ID: <20140623163514.GI19860@laptop.programming.kicks-ass.net>
References: <20140615124657.264658593@chello.nl>
 <20140615130153.196728583@chello.nl>
 <20140617203615.GA29634@laptop.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140617203615.GA29634@laptop.dumpdata.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 04:36:15PM -0400, Konrad Rzeszutek Wilk wrote:
> On Sun, Jun 15, 2014 at 02:47:00PM +0200, Peter Zijlstra wrote:
> > Because the qspinlock needs to touch a second cacheline; add a pending
> > bit and allow a single in-word spinner before we punt to the second
> > cacheline.
> 
> Could you add this in the description please:
> 
> And by second cacheline we mean the local 'node'. That is the:
> mcs_nodes[0] and mcs_nodes[idx]

Those should be the very same cacheline :), but yes, I can add something
like that.

> Perhaps it might be better then to split this in the header file
> as this is trying to not be a slowpath code - but rather - a
> pre-slow-path-lets-try-if-we can do another cmpxchg in case
> the unlocker has just unlocked itself.
> 
> So something like:
> 
> diff --git a/include/asm-generic/qspinlock.h b/include/asm-generic/qspinlock.h
> index e8a7ae8..29cc9c7 100644
> --- a/include/asm-generic/qspinlock.h
> +++ b/include/asm-generic/qspinlock.h
> @@ -75,11 +75,21 @@ extern void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val);
>   */
>  static __always_inline void queue_spin_lock(struct qspinlock *lock)
>  {
> -	u32 val;
> +	u32 val, new;
>  
>  	val = atomic_cmpxchg(&lock->val, 0, _Q_LOCKED_VAL);
>  	if (likely(val == 0))
>  		return;
> +
> +	/* One more attempt - but if we fail mark it as pending. */
> +	if (val == _Q_LOCKED_VAL) {
> +		new = Q_LOCKED_VAL |_Q_PENDING_VAL;
> +
> +		old = atomic_cmpxchg(&lock->val, val, new);
> +		if (old == _Q_LOCKED_VAL) /* YEEY! */
> +			return;
> +		val = old;
> +	}
>  	queue_spin_lock_slowpath(lock, val);
>  }

I think that's too big for an inline function.
