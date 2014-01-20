Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaATCfB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 21:35:01 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:42285 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbaATCe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 21:34:57 -0500
Date: Sun, 19 Jan 2014 18:34:48 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH v7 5/6] MCS Lock: allow architectures to hook in to
 contended paths
Message-ID: <20140120023448.GM10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1389890175.git.tim.c.chen@linux.intel.com>
 <1389917311.3138.15.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389917311.3138.15.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012002-8236-0000-0000-0000063CDA96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 04:08:31PM -0800, Tim Chen wrote:
> When contended, architectures may be able to reduce the polling overhead
> in ways which aren't expressible using a simple relax() primitive.
> 
> This patch allows architectures to hook into the mcs_{lock,unlock}
> functions for the contended cases only.
> 
> From: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/locking/mcs_spinlock.c | 47 +++++++++++++++++++++++++------------------
>  1 file changed, 27 insertions(+), 20 deletions(-)
> 
> diff --git a/kernel/locking/mcs_spinlock.c b/kernel/locking/mcs_spinlock.c
> index 6cdc730..66d8883 100644
> --- a/kernel/locking/mcs_spinlock.c
> +++ b/kernel/locking/mcs_spinlock.c
> @@ -7,19 +7,34 @@
>   * It avoids expensive cache bouncings that common test-and-set spin-lock
>   * implementations incur.
>   */
> -/*
> - * asm/processor.h may define arch_mutex_cpu_relax().
> - * If it is not defined, cpu_relax() will be used.
> - */
> +
>  #include <asm/barrier.h>
>  #include <asm/cmpxchg.h>
>  #include <asm/processor.h>
>  #include <linux/compiler.h>
>  #include <linux/mcs_spinlock.h>
> +#include <linux/mutex.h>
>  #include <linux/export.h>
> 
> -#ifndef arch_mutex_cpu_relax
> -# define arch_mutex_cpu_relax() cpu_relax()
> +#ifndef arch_mcs_spin_lock_contended
> +/*
> + * Using smp_load_acquire() provides a memory barrier that ensures
> + * subsequent operations happen after the lock is acquired.
> + */
> +#define arch_mcs_spin_lock_contended(l)					\
> +	while (!(smp_load_acquire(l))) {				\
> +		arch_mutex_cpu_relax();					\
> +	}
> +#endif
> +
> +#ifndef arch_mcs_spin_unlock_contended
> +/*
> + * smp_store_release() provides a memory barrier to ensure all
> + * operations in the critical section has been completed before
> + * unlocking.
> + */
> +#define arch_mcs_spin_unlock_contended(l)				\
> +	smp_store_release((l), 1)
>  #endif
> 
>  /*
> @@ -43,13 +58,9 @@ void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
>  		return;
>  	}
>  	ACCESS_ONCE(prev->next) = node;
> -	/*
> -	 * Wait until the lock holder passes the lock down.
> -	 * Using smp_load_acquire() provides a memory barrier that
> -	 * ensures subsequent operations happen after the lock is acquired.
> -	 */
> -	while (!(smp_load_acquire(&node->locked)))
> -		arch_mutex_cpu_relax();
> +
> +	/* Wait until the lock holder passes the lock down. */
> +	arch_mcs_spin_lock_contended(&node->locked);
>  }
>  EXPORT_SYMBOL_GPL(mcs_spin_lock);
> 
> @@ -71,12 +82,8 @@ void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
>  		while (!(next = ACCESS_ONCE(node->next)))
>  			arch_mutex_cpu_relax();
>  	}
> -	/*
> -	 * Pass lock to next waiter.
> -	 * smp_store_release() provides a memory barrier to ensure
> -	 * all operations in the critical section has been completed
> -	 * before unlocking.
> -	 */
> -	smp_store_release(&next->locked, 1);
> +
> +	/* Pass lock to next waiter. */
> +	arch_mcs_spin_unlock_contended(&next->locked);
>  }
>  EXPORT_SYMBOL_GPL(mcs_spin_unlock);
> -- 
> 1.7.11.7
> 
> 
> 

