Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbaD3I1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:27:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:34666 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbaD3I1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:27:19 -0400
Date: Wed, 30 Apr 2014 10:27:15 +0200
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
Message-ID: <20140430082715.GA11096@twins.programming.kicks-ass.net>
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
> +/*
> + * Try to acquire write lock before the writer has been put on wait queue.
> + */
> +static inline bool rwsem_try_write_lock_unqueued(struct rw_semaphore *sem)
> +{
> +	long count = ACCESS_ONCE(sem->count);
> +retry:
> +	if (count == RWSEM_WAITING_BIAS) {
> +		count = cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
> +			    RWSEM_ACTIVE_WRITE_BIAS + RWSEM_WAITING_BIAS);
> +		/* allow write lock stealing, try acquiring the write lock. */
> +		if (count == RWSEM_WAITING_BIAS)
> +			goto acquired;
> +		else if (count == 0)
> +			goto retry;
> +	} else if (count == 0) {
> +		count = cmpxchg(&sem->count, 0, RWSEM_ACTIVE_WRITE_BIAS);
> +		if (count == 0)
> +			goto acquired;
> +		else if (count == RWSEM_WAITING_BIAS)
> +			goto retry;
> +	}
> +	return false;
> +
> +acquired:
> +	return true;
> +}

Could we have written that like:

static inline bool rwsem_try_write_lock_unqueued(struct rw_semaphore *sem)
{
	long old, count = ACCESS_ONCE(sem->count);

	for (;;) {
		if (!(count == 0 || count == RWSEM_WAITING_BIAS))
			return false;

		old = cmpxchg(&sem->count, count, count + RWSEM_ACTIVE_BIAS);
		if (old == count)
			return true;

		count = old;
	}
}

?

Just checking my brain got all the branches untangled right :-)
