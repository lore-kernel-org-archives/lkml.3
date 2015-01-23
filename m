Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbbAWO2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:28:41 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:38700 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886AbbAWO2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:28:37 -0500
Date: Fri, 23 Jan 2015 15:28:25 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 06/12] time: Add infrastructure to cap clocksource reads
 to the max_cycles value
Message-ID: <20150123142825.GB23123@twins.programming.kicks-ass.net>
References: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
 <1421971767-17707-7-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421971767-17707-7-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 04:09:21PM -0800, John Stultz wrote:
> +static inline cycle_t timekeeping_get_delta(struct tk_read_base *tkr)
> +{
> +	cycle_t cycle_now, delta;
> +
> +	/* read clocksource */
> +	cycle_now = tkr->read(tkr->clock);
> +
> +	/* calculate the delta since the last update_wall_time */
> +	delta = clocksource_delta(cycle_now, tkr->cycle_last, tkr->mask);
> +
> +	/* Cap delta value to the max_cycles values to avoid mult overflows */
> +	if (unlikely(delta > tkr->clock->max_cycles))
> +		delta = tkr->clock->max_cycles;


Should we not raise _something_ here? I know we cannot printk() here,
but bad (TM) things happened if this ever triggers.

> +
> +	return delta;
> +}
