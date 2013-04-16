Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab3DPEYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 00:24:43 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:1744 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3DPEYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 00:24:41 -0400
Message-ID: <1366086275.22463.25.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2 2/3] mutex: Queue mutex spinners with MCS lock to
 reduce cacheline contention
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-arch@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Rik van Riel <riel@redhat.com>
Date: Mon, 15 Apr 2013 21:24:35 -0700
In-Reply-To: <1366036679-9702-3-git-send-email-Waiman.Long@hp.com>
References: <1366036679-9702-1-git-send-email-Waiman.Long@hp.com>
	 <1366036679-9702-3-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-15 at 10:37 -0400, Waiman Long wrote:
[...]
> +typedef struct mspin_node {
> +	struct mspin_node *next;
> +	int		   locked;	/* 1 if lock acquired */
> +} mspin_node_t;
> +
> +typedef mspin_node_t	*mspin_lock_t;

I think we could do without the typedefs, specially mspin_lock_t.

> +
> +#define	MLOCK(mutex)	((mspin_lock_t *)&((mutex)->spin_mlock))
> +
> +static noinline void mspin_lock(mspin_lock_t *lock,  mspin_node_t *node)
> +{
> +	mspin_node_t *prev;
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
> +static void mspin_unlock(mspin_lock_t *lock,  mspin_node_t *node)
> +{
> +	mspin_node_t *next = ACCESS_ONCE(node->next);
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
> +	barrier();
> +	ACCESS_ONCE(next->locked) = 1;
> +	smp_wmb();

Do we really need the compiler barrier call? The CPUs can reorder
anyway. I assume the smp_wbm() call makes sure no there's no funny
business before the next lock is acquired, might be worth commenting.

Thanks,
Davidlohr

