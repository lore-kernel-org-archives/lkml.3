Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbaAFS70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 13:59:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:43674 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755470AbaAFS7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:59:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,614,1384329600"; 
   d="scan'208";a="462444686"
Message-ID: <1389034693.30730.33.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: [PATCH v5 3/4] futex: Document ordering guarantees
From: Darren Hart <dvhart@linux.intel.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, jason.low2@hp.com,
        Waiman.Long@hp.com, tom.vaden@hp.com, scott.norton@hp.com,
        aswin@hp.com, Randy Dunlap <rdunlap@infradead.org>
Date: Mon, 06 Jan 2014 10:58:13 -0800
In-Reply-To: <1388675120-8017-4-git-send-email-davidlohr@hp.com>
References: <1388675120-8017-1-git-send-email-davidlohr@hp.com>
	 <1388675120-8017-4-git-send-email-davidlohr@hp.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-02 at 07:05 -0800, Davidlohr Bueso wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> That's essential, if you want to hack on futexes.
> 
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Darren Hart <dvhart@linux.intel.com>

Reviewed-by: Darren Hart <dvhart@linux.intel.com>

> Acked-by: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Jeff Mahoney <jeffm@suse.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Scott Norton <scott.norton@hp.com>
> Cc: Tom Vaden <tom.vaden@hp.com>
> Cc: Aswin Chandramouleeswaran <aswin@hp.com>
> Cc: Waiman Long <Waiman.Long@hp.com>
> Cc: Jason Low <jason.low2@hp.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> ---
>  kernel/futex.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 57 insertions(+)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 577481d..fcc6850 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -69,6 +69,63 @@
>  
>  #include "locking/rtmutex_common.h"
>  
> +/*
> + * Basic futex operation and ordering guarantees:
> + *
> + * The waiter reads the futex value in user space and calls
> + * futex_wait(). This function computes the hash bucket and acquires
> + * the hash bucket lock. After that it reads the futex user space value
> + * again and verifies that the data has not changed. If it has not
> + * changed it enqueues itself into the hash bucket, releases the hash
> + * bucket lock and schedules.
> + *
> + * The waker side modifies the user space value of the futex and calls
> + * futex_wake(). This functions computes the hash bucket and acquires
> + * the hash bucket lock. Then it looks for waiters on that futex in the
> + * hash bucket and wakes them.
> + *
> + * Note that the spin_lock serializes waiters and wakers, so that the
> + * following scenario is avoided:
> + *
> + * CPU 0                               CPU 1
> + * val = *futex;
> + * sys_futex(WAIT, futex, val);
> + *   futex_wait(futex, val);
> + *   uval = *futex;
> + *                                     *futex = newval;
> + *                                     sys_futex(WAKE, futex);
> + *                                       futex_wake(futex);
> + *                                       if (queue_empty())
> + *                                         return;
> + *   if (uval == val)
> + *      lock(hash_bucket(futex));
> + *      queue();
> + *     unlock(hash_bucket(futex));
> + *     schedule();
> + *
> + * This would cause the waiter on CPU 0 to wait forever because it
> + * missed the transition of the user space value from val to newval
> + * and the waker did not find the waiter in the hash bucket queue.
> + * The spinlock serializes that:
> + *
> + * CPU 0                               CPU 1
> + * val = *futex;
> + * sys_futex(WAIT, futex, val);
> + *   futex_wait(futex, val);
> + *   lock(hash_bucket(futex));
> + *   uval = *futex;
> + *                                     *futex = newval;
> + *                                     sys_futex(WAKE, futex);
> + *                                       futex_wake(futex);
> + *                                       lock(hash_bucket(futex));
> + *   if (uval == val)
> + *      queue();
> + *     unlock(hash_bucket(futex));
> + *     schedule();                       if (!queue_empty())
> + *                                         wake_waiters(futex);
> + *                                       unlock(hash_bucket(futex));
> + */
> +
>  int __read_mostly futex_cmpxchg_enabled;
>  
>  /*

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


