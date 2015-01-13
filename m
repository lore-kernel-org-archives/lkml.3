Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbbAMLLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:11:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:51216 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbbAMLLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:11:50 -0500
Date: Tue, 13 Jan 2015 12:11:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 06/10] time: Cap clocksource reads to the clocksource
 max_cycles value
Message-ID: <20150113111146.GL23965@worktop.programming.kicks-ass.net>
References: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
 <1420850068-27828-7-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420850068-27828-7-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 04:34:24PM -0800, John Stultz wrote:
> When calculating the current delta since the last tick, we
> currently have no hard protections to prevent a multiplciation
> overflow from ocurring.
> 
> This patch introduces such a cap that limits the read delta
> value to the max_cycles value, which is where an overflow would
> occur.

> +++ b/kernel/time/timekeeping.c
> @@ -202,6 +202,9 @@ static inline s64 timekeeping_get_ns(struct tk_read_base *tkr)
>  	/* calculate the delta since the last update_wall_time: */
>  	delta = clocksource_delta(cycle_now, tkr->cycle_last, tkr->mask);
>  
> +	/* Cap delta value to the max_cycles values to avoid mult overflows */
> +	delta = min(delta, tkr->clock->max_cycles);
> +
>  	nsec = delta * tkr->mult + tkr->xtime_nsec;
>  	nsec >>= tkr->shift;
>  

So while I appreciate stuff can be broken, should we not at least keep
track of this brokenness? That is, we all agree bad things happened IF
we actually hit this, right? So should we then not inform people that
bad things did happen?
