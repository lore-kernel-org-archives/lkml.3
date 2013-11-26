Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab3KZAVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 19:21:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:9483 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab3KZAVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 19:21:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,771,1378882800"; 
   d="scan'208";a="441720102"
Message-ID: <1385425248.12342.80.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: [RFC patch 4/5] futex: Enqueue waiter before user space check
From: Darren Hart <dvhart@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Jeff Mahoney <jeffm@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Scott Norton <scott.norton@hp.com>, Tom Vaden <tom.vaden@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 25 Nov 2013 16:20:48 -0800
In-Reply-To: <20131125203526.001421959@linutronix.de>
References: <20131125203358.156292370@linutronix.de>
	 <20131125203526.001421959@linutronix.de>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-25 at 20:58 +0000, Thomas Gleixner wrote:


This changes the queue ordering on the waiter side from 
> 
>      lock(hash_bucket);
>      validate user space value();
>      queue();
>      unlock(hash_bucket);
> 
> to
>      lock(hash_bucket);
>      queue();
>      validate user space value();
>      unlock(hash_bucket);
> 
> This is a preparatory patch for a lockless empty check of the hash
> bucket plist.
> 
> No functional implication. All futex operations are still serialized
> via the hasb bucket lock.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 

Reviewed-by: Darren Hart <dvhart@linux.intel.com>

...

> + *
> + * The futex_lock_pi ordering is similar to that, but it has the
queue
> + * operation right before unlocking hash bucket lock and scheduling.
> 

There is also futex_wait_requeue_pi(), as you mentioned earlier.

I spent some time looking into this as I thought I had something in
place to prevent futex_wake from waking pending requeue_pi futex_qs.

futex_wait_requeue_pi() sets up a q.rt_waiter pointer which
distinguishes requeue_pi waiters from other waiters.

futex_wake() will abort if it detects the rt_waiter, returning EINVAL as
it is an invalid op pairing.

In this case, the spin_lock is adequate for futex_wait_requeue_pi()
because the wake wouldn't be performed regardless, so while the race
still exists, it isn't relevant. Worst case, the futex_wake returns 0,
indicating the list was empty and it didn't wake anything, rather than
-EINVAL, indicating the invalid op pairing. This is a delta from today's
behavior, but it is in a rare error path, and the result is no more
damaging than the existing behavior.


The approach appears sound to me. Now I'll get to looking at testing.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel

