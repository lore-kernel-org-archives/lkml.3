Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbaAOHtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 02:49:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57006 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaAOHtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 02:49:07 -0500
Date: Wed, 15 Jan 2014 08:48:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@redhat.com, paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        aswin@hp.com, scott.norton@hp.com
Subject: Re: [RFC 1/3] mutex: In mutex_can_spin_on_owner(), return false if
 task need_resched()
Message-ID: <20140115074844.GA3694@twins.programming.kicks-ass.net>
References: <1389745990-7069-1-git-send-email-jason.low2@hp.com>
 <1389745990-7069-2-git-send-email-jason.low2@hp.com>
 <20140115074420.GV31570@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115074420.GV31570@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 08:44:20AM +0100, Peter Zijlstra wrote:
> On Tue, Jan 14, 2014 at 04:33:08PM -0800, Jason Low wrote:
> > The mutex_can_spin_on_owner() function should also return false if the
> > task needs to be rescheduled.
> > 
> 
> While I was staring at mutex_can_spin_on_owner(); don't we need this?
> 
>  kernel/locking/mutex.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> index 4dd6e4c219de..480d2f437964 100644
> --- a/kernel/locking/mutex.c
> +++ b/kernel/locking/mutex.c
> @@ -214,8 +214,10 @@ static inline int mutex_can_spin_on_owner(struct mutex *lock)
>  
>  	rcu_read_lock();
>  	owner = ACCESS_ONCE(lock->owner);
> -	if (owner)
> +	if (owner) {

That is, its an unmatched barrier, as mutex_set_owner() doesn't include
a barrier, and I don't think i needs to; but on alpha we still need this
read barrier to ensure we do not mess up this related load afaik.

Paul? can you explain an unpaired read_barrier_depends?

> +		smp_read_barrier_depends();
>  		retval = owner->on_cpu;
> +	}
>  	rcu_read_unlock();
>  	/*
>  	 * if lock->owner is not set, the mutex owner may have just acquired
