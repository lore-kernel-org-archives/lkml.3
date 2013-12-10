Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab3LJQYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:24:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54306 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab3LJQYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:24:34 -0500
Date: Tue, 10 Dec 2013 17:24:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, dvhart@linux.intel.com,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, scott.norton@hp.com,
        tom.vaden@hp.com, aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com
Subject: Re: [PATCH v2 4/4] futex: Avoid taking hb lock if nothing to wakeup
Message-ID: <20131210162411.GM12849@twins.programming.kicks-ass.net>
References: <1386063927-6545-1-git-send-email-davidlohr@hp.com>
 <1386063927-6545-5-git-send-email-davidlohr@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386063927-6545-5-git-send-email-davidlohr@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 01:45:27AM -0800, Davidlohr Bueso wrote:
> @@ -203,6 +221,9 @@ static const struct futex_q futex_q_init = {
>   * waiting on a futex.
>   */
>  struct futex_hash_bucket {
> +#ifdef CONFIG_SMP
> +	atomic_t waiters;
> +#endif
>  	spinlock_t lock;
>  	struct plist_head chain;
>  } ____cacheline_aligned_in_smp;

> @@ -2805,6 +2906,9 @@ static int __init futex_init(void)
>  	for (i = 0; i < futex_hashsize; i++) {
>  		plist_head_init(&futex_queues[i].chain);
>  		spin_lock_init(&futex_queues[i].lock);
> +#ifdef CONFIG_SMP
> +		atomic_set(&futex_queues[i].waiters, 0);
> +#endif
>  	}
>  
>  	return 0;

Just remove those two #ifdefs, its not like the data structure size
matters at this point.
