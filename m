Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbaD3JOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:14:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:34885 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758533AbaD3JO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:14:29 -0400
Date: Wed, 30 Apr 2014 11:14:25 +0200
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
Message-ID: <20140430091425.GC11096@twins.programming.kicks-ass.net>
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
> +static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
> +{
> +	int retval;
> +	struct task_struct *owner;
> +
> +	rcu_read_lock();
> +	owner = ACCESS_ONCE(sem->owner);
> +
> +	/* Spin only if active writer running */
> +	if (owner)
> +		retval = owner->on_cpu;
> +	else {
> +		/*
> +		 * When the owner is not set, the sem owner may have just
> +		 * acquired it and not set the owner yet, or the sem has
> +		 * been released, or reader active.
> +		 */
> +		retval = false;
> +	}
> +	rcu_read_unlock();
> +
> +	return retval;
> +}

Also, the mutex case has a need_resched() test in there; any particular
reason you didn't mirror that?

See 46af29e479cc0 ("locking/mutexes: Return false if task need_resched() in mutex_can_spin_on_owner()")
