Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab3KUKR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 05:17:27 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42488 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3KUKR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 05:17:26 -0500
Date: Thu, 21 Nov 2013 11:17:19 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lockdep: Simplify a bit hardirq <-> softirq transitions
Message-ID: <20131121101719.GY10022@twins.programming.kicks-ass.net>
References: <1384906054-30676-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384906054-30676-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 01:07:34AM +0100, Frederic Weisbecker wrote:
> Instead of saving the hardirq state on a per CPU variable, which require
> an explicit call before the softirq handling and some complication,
> just save and restore the hardirq tracing state through functions
> return values and parameters.
> 
> It simplifies a bit the black magic that works around the fact that
> softirqs can be called from hardirqs while hardirqs can nest on softirqs
> but those two cases have very different semantics and only the latter
> case assume both states.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  kernel/softirq.c | 37 ++++++++++++++++---------------------
>  1 file changed, 16 insertions(+), 21 deletions(-)
> 
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index eb0acf4..dc43ee8 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -215,40 +215,35 @@ EXPORT_SYMBOL(local_bh_enable_ip);
>  
>  #ifdef CONFIG_TRACE_IRQFLAGS
>  /*
>   * When we run softirqs from irq_exit() and thus on the hardirq stack we need
>   * to keep the lockdep irq context tracking as tight as possible in order to
>   * not miss-qualify lock contexts and miss possible deadlocks.
>   */
>  
> +static inline bool lockdep_softirq_start(void)
>  {
> +	bool in_hardirq = false;
>  
> +	if (trace_hardirq_context(current)) {
> +		in_hardirq = true;
>  		trace_hardirq_exit();
> +	}
> +
>  	lockdep_softirq_enter();
> +
> +	return in_hardirq;
>  }
>  
> +static inline void lockdep_softirq_end(bool in_hardirq)
>  {
>  	lockdep_softirq_exit();
> +
> +	if (in_hardirq)
>  		trace_hardirq_enter();
>  }

Yeah, I suppose that works. Thanks!
