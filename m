Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbaATC35 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 21:29:57 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:34079 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbaATC3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 21:29:55 -0500
Date: Sun, 19 Jan 2014 18:29:47 -0800
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
Subject: Re: [PATCH v7 2/6] MCS Lock: optimizations and extra comments
Message-ID: <20140120022947.GJ10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1389890175.git.tim.c.chen@linux.intel.com>
 <1389917300.3138.12.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389917300.3138.12.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012002-6688-0000-0000-000005B1A816
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 04:08:20PM -0800, Tim Chen wrote:
> Remove unnecessary operation and make the cmpxchg(lock, node, NULL) == node
> check in mcs_spin_unlock() likely() as it is likely that a race did not occur
> most of the time.
> 
> Also add in more comments describing how the local node is used in MCS locks.
> 
> From: Jason Low <jason.low2@hp.com>
> Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
> Signed-off-by: Jason Low <jason.low2@hp.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  include/linux/mcs_spinlock.h | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mcs_spinlock.h b/include/linux/mcs_spinlock.h
> index b5de3b0..96f14299 100644
> --- a/include/linux/mcs_spinlock.h
> +++ b/include/linux/mcs_spinlock.h
> @@ -18,6 +18,12 @@ struct mcs_spinlock {
>  };
> 
>  /*
> + * In order to acquire the lock, the caller should declare a local node and
> + * pass a reference of the node to this function in addition to the lock.
> + * If the lock has already been acquired, then this will proceed to spin
> + * on this node->locked until the previous lock holder sets the node->locked
> + * in mcs_spin_unlock().
> + *
>   * We don't inline mcs_spin_lock() so that perf can correctly account for the
>   * time spent in this lock function.
>   */
> @@ -33,7 +39,6 @@ void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
>  	prev = xchg(lock, node);
>  	if (likely(prev == NULL)) {
>  		/* Lock acquired */
> -		node->locked = 1;
>  		return;
>  	}
>  	ACCESS_ONCE(prev->next) = node;
> @@ -43,6 +48,10 @@ void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
>  		arch_mutex_cpu_relax();
>  }
> 
> +/*
> + * Releases the lock. The caller should pass in the corresponding node that
> + * was used to acquire the lock.
> + */
>  static void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
>  {
>  	struct mcs_spinlock *next = ACCESS_ONCE(node->next);
> @@ -51,7 +60,7 @@ static void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *nod
>  		/*
>  		 * Release the lock by setting it to NULL
>  		 */
> -		if (cmpxchg(lock, node, NULL) == node)
> +		if (likely(cmpxchg(lock, node, NULL) == node))
>  			return;
>  		/* Wait until the next pointer is set */
>  		while (!(next = ACCESS_ONCE(node->next)))
> -- 
> 1.7.11.7
> 
> 
> 

