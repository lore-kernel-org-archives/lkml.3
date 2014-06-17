Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965060AbaFQUwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 16:52:08 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:5276 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933275AbaFQUwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 16:52:04 -0400
Message-ID: <53A0AA6D.1070708@hp.com>
Date: Tue, 17 Jun 2014 16:51:57 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, tglx@linutronix.de,
        mingo@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, boris.ostrovsky@oracle.com,
        paulmck@linux.vnet.ibm.com, riel@redhat.com,
        torvalds@linux-foundation.org, raghavendra.kt@linux.vnet.ibm.com,
        david.vrabel@citrix.com, oleg@redhat.com, gleb@redhat.com,
        scott.norton@hp.com, chegu_vinod@hp.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 03/11] qspinlock: Add pending bit
References: <20140615124657.264658593@chello.nl> <20140615130153.196728583@chello.nl> <20140617203615.GA29634@laptop.dumpdata.com>
In-Reply-To: <20140617203615.GA29634@laptop.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 04:36 PM, Konrad Rzeszutek Wilk wrote:
> On Sun, Jun 15, 2014 at 02:47:00PM +0200, Peter Zijlstra wrote:
>> Because the qspinlock needs to touch a second cacheline; add a pending
>> bit and allow a single in-word spinner before we punt to the second
>> cacheline.
> Could you add this in the description please:
>
> And by second cacheline we mean the local 'node'. That is the:
> mcs_nodes[0] and mcs_nodes[idx]
>
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
>    */
>   static __always_inline void queue_spin_lock(struct qspinlock *lock)
>   {
> -	u32 val;
> +	u32 val, new;
>
>   	val = atomic_cmpxchg(&lock->val, 0, _Q_LOCKED_VAL);
>   	if (likely(val == 0))
>   		return;
> +
> +	/* One more attempt - but if we fail mark it as pending. */
> +	if (val == _Q_LOCKED_VAL) {
> +		new = Q_LOCKED_VAL |_Q_PENDING_VAL;
> +
> +		old = atomic_cmpxchg(&lock->val, val, new);
> +		if (old == _Q_LOCKED_VAL) /* YEEY! */
> +			return;

No, it can leave like that. The unlock path will not clear the pending 
bit. We are trying to make the fastpath as simple as possible as it may 
be inlined. The complexity of the queue spinlock is in the slowpath.

Moreover, an cmpxchg followed immediately followed by another cmpxchg 
will just increase the level of memory contention when a lock is fairly 
contended. The chance of second cmpxchg() succeeding will be pretty low.

-Longman


