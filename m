Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab3EGKW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 06:22:57 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59346 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756497Ab3EGKW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 06:22:56 -0400
Date: Tue, 7 May 2013 02:18:01 -0700
From: Michel Lespinasse <walken@google.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>
Subject: Re: [PATCH v2 00/13] rwsem fast-path write lock stealing
Message-ID: <20130507091801.GA26193@google.com>
References: <1363344869-15732-1-git-send-email-walken@google.com>
 <1367097352.1782.14.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367097352.1782.14.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 27, 2013 at 02:15:52PM -0700, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <davidlohr.bueso@hp.com>
> Subject: [PATCH] rwsem: check counter to avoid cmpxchg calls
> 
> This patch tries to reduce the amount of cmpxchg calls in the
> writer failed path by checking the counter value first before
> issuing the instruction. If ->count is not set to RWSEM_WAITING_BIAS
> then there is no point wasting a cmpxchg call.
> 
> Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
> ---
>  lib/rwsem.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/rwsem.c b/lib/rwsem.c
> index 50fdd89..a79dc95 100644
> --- a/lib/rwsem.c
> +++ b/lib/rwsem.c
> @@ -222,9 +222,10 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
>  			count = RWSEM_ACTIVE_WRITE_BIAS;
>  			if (!list_is_singular(&sem->wait_list))
>  				count += RWSEM_WAITING_BIAS;
> -			if (cmpxchg(&sem->count, RWSEM_WAITING_BIAS, count) ==
> -							RWSEM_WAITING_BIAS)
> -				break;
> +			if ((*(volatile long *)&(sem)->count) == RWSEM_WAITING_BIAS)
> +				if (cmpxchg(&sem->count, RWSEM_WAITING_BIAS, count) ==
> +				    RWSEM_WAITING_BIAS)
> +					break;
>  		}
>  
>  		raw_spin_unlock_irq(&sem->wait_lock);

Quite impressed that this makes as much of a difference - this code block
already checks that the active count was 0 (which implies the sem->count
must be RWSEM_WAITING_BIAS, since the writer thread is known to be waiting)
not long before. But I suppose it helps due to the case where someone else
steals the lock while we're trying to acquire sem->wait_lock.

Regarding style: I would prefer if the sem->count read didn't use the
volatile cast. The compiler will already be forced to reload the value
due to the barriers in set_task_state() and raw_spin_lock_irq(). And if
you absolutely need to have that volatile, I would prefer you use
ACCESS_ONCE() rather than the hand written equivalent.

I'm going to try pushing this to Linus tomorrow; I feel I shouldn't change
your patch without putting it through tests again; are you OK with sending
this as a followup to the series rather than me including it ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
