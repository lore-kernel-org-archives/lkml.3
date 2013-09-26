Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab3IZGqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:46:34 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:59395 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab3IZGqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:46:33 -0400
Date: Thu, 26 Sep 2013 08:46:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH v6 5/6] MCS Lock: Restructure the MCS lock defines and
 locking code into its own file
Message-ID: <20130926064629.GB19090@gmail.com>
References: <cover.1380144003.git.tim.c.chen@linux.intel.com>
 <1380147049.3467.67.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380147049.3467.67.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tim Chen <tim.c.chen@linux.intel.com> wrote:

> We will need the MCS lock code for doing optimistic spinning for rwsem.
> Extracting the MCS code from mutex.c and put into its own file allow us
> to reuse this code easily for rwsem.
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> ---
>  include/linux/mcslock.h |   58 +++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/mutex.c          |   58 +++++-----------------------------------------
>  2 files changed, 65 insertions(+), 51 deletions(-)
>  create mode 100644 include/linux/mcslock.h
> 
> diff --git a/include/linux/mcslock.h b/include/linux/mcslock.h
> new file mode 100644
> index 0000000..20fd3f0
> --- /dev/null
> +++ b/include/linux/mcslock.h
> @@ -0,0 +1,58 @@
> +/*
> + * MCS lock defines
> + *
> + * This file contains the main data structure and API definitions of MCS lock.

A (very) short blurb about what an MCS lock is would be nice here.

> + */
> +#ifndef __LINUX_MCSLOCK_H
> +#define __LINUX_MCSLOCK_H
> +
> +struct mcs_spin_node {
> +	struct mcs_spin_node *next;
> +	int		  locked;	/* 1 if lock acquired */
> +};

The vertical alignment looks broken here.

> +
> +/*
> + * We don't inline mcs_spin_lock() so that perf can correctly account for the
> + * time spent in this lock function.
> + */
> +static noinline
> +void mcs_spin_lock(struct mcs_spin_node **lock, struct mcs_spin_node *node)
> +{
> +	struct mcs_spin_node *prev;
> +
> +	/* Init node */
> +	node->locked = 0;
> +	node->next   = NULL;
> +
> +	prev = xchg(lock, node);
> +	if (likely(prev == NULL)) {
> +		/* Lock acquired */
> +		node->locked = 1;
> +		return;
> +	}
> +	ACCESS_ONCE(prev->next) = node;
> +	smp_wmb();
> +	/* Wait until the lock holder passes the lock down */
> +	while (!ACCESS_ONCE(node->locked))
> +		arch_mutex_cpu_relax();
> +}
> +
> +static void mcs_spin_unlock(struct mcs_spin_node **lock, struct mcs_spin_node *node)
> +{
> +	struct mcs_spin_node *next = ACCESS_ONCE(node->next);
> +
> +	if (likely(!next)) {
> +		/*
> +		 * Release the lock by setting it to NULL
> +		 */
> +		if (cmpxchg(lock, node, NULL) == node)
> +			return;
> +		/* Wait until the next pointer is set */
> +		while (!(next = ACCESS_ONCE(node->next)))
> +			arch_mutex_cpu_relax();
> +	}
> +	ACCESS_ONCE(next->locked) = 1;
> +	smp_wmb();
> +}
> +
> +#endif

We typically close header guards not via a plain #endif but like this:

#endif /* __LINUX_SPINLOCK_H */

#endif /* __LINUX_SPINLOCK_TYPES_H */

etc.

Thanks,

	Ingo
