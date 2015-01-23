Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbbAWJOC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:14:02 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:46023 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbbAWJN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:13:59 -0500
Date: Fri, 23 Jan 2015 10:13:53 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] sched: Fix missing preemption opportunity
Message-ID: <20150123091353.GI2896@worktop.programming.kicks-ass.net>
References: <1421946484-9298-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421946484-9298-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I picked up the patch; will drop it if Ingo also does ;-)

On Thu, Jan 22, 2015 at 06:08:04PM +0100, Frederic Weisbecker wrote:
> +++ b/kernel/sched/core.c
> @@ -2877,6 +2877,21 @@ void __sched schedule_preempt_disabled(void)
>  	preempt_disable();
>  }
>  
> +static void preempt_schedule_common(void)
> +{
> +	do {
> +		__preempt_count_add(PREEMPT_ACTIVE);
> +		__schedule();
> +		__preempt_count_sub(PREEMPT_ACTIVE);
> +
> +		/*
> +		 * Check again in case we missed a preemption opportunity
> +		 * between schedule and now.
> +		 */
> +		barrier();

I do however wonder about this barrier() here; why do we think we need
it?

Is that because test_bit() it 'broken'? The bitops are typically atomic
ops and atomic reads should be through a volatile cast (x86
constant_test_bit doesn't seem to do this).

Should we go audit and fix that?

> +	} while (need_resched());
> +}
