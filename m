Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbaEHS7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 14:59:07 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34379 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbaEHS7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 14:59:03 -0400
Date: Thu, 8 May 2014 20:58:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v10 06/19] qspinlock: prolong the stay in the pending bit
 path
Message-ID: <20140508185854.GN2844@laptop.programming.kicks-ass.net>
References: <1399474907-22206-1-git-send-email-Waiman.Long@hp.com>
 <1399474907-22206-7-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399474907-22206-7-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 11:01:34AM -0400, Waiman Long wrote:
> @@ -221,11 +222,37 @@ static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
>  	 */
>  	for (;;) {
>  		/*
> -		 * If we observe any contention; queue.
> +		 * If we observe that the queue is not empty,
> +		 * return and be queued.
>  		 */
> -		if (val & ~_Q_LOCKED_MASK)
> +		if (val & _Q_TAIL_MASK)
>  			return 0;
>  
> +		if (val == (_Q_LOCKED_VAL|_Q_PENDING_VAL)) {
> +			/*
> +			 * If both the lock and pending bits are set, we wait
> +			 * a while to see if that either bit will be cleared.
> +			 * If that is no change, we return and be queued.
> +			 */
> +			if (!retry)
> +				return 0;
> +			retry--;
> +			cpu_relax();
> +			cpu_relax();
> +			*pval = val = atomic_read(&lock->val);
> +			continue;
> +		} else if (val == _Q_PENDING_VAL) {
> +			/*
> +			 * Pending bit is set, but not the lock bit.
> +			 * Assuming that the pending bit holder is going to
> +			 * set the lock bit and clear the pending bit soon,
> +			 * it is better to wait than to exit at this point.
> +			 */
> +			cpu_relax();
> +			*pval = val = atomic_read(&lock->val);
> +			continue;
> +		}

Didn't I give a much saner alternative to this mess last time?
