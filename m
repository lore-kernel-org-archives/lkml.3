Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbbAWOa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:30:27 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:43279 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097AbbAWOaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:30:24 -0500
Date: Fri, 23 Jan 2015 15:30:06 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 08/12] time: Add warnings when overflows or underflows
 are observed
Message-ID: <20150123143006.GC23123@twins.programming.kicks-ass.net>
References: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
 <1421971767-17707-9-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421971767-17707-9-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 04:09:23PM -0800, John Stultz wrote:
>  #ifdef CONFIG_DEBUG_TIMEKEEPING
> +#define WARNINGFREQ (HZ*300) /* 5 minute rate-limiting */
> +/*
> + * These simple flag variables are managed
> + * without locks, which is racy, but ok since
> + * we don't really care about being super
> + * precise about how many events were seen,
> + * just that a problem was observed.
> + */
> +static int timekeeping_underflow_seen;
> +static int timekeeping_overflow_seen;
> +
>  static void timekeeping_check_update(struct timekeeper *tk, cycle_t offset)
>  {
>  
>  	cycle_t max_cycles = tk->tkr.clock->max_cycles;
>  	const char *name = tk->tkr.clock->name;
> +	static long last_warning; /* we always hold write on timekeeper lock */
>  
>  	if (offset > max_cycles)
>  		printk_deferred("ERROR: cycle offset (%lld) is larger then"
> @@ -133,28 +145,60 @@ static void timekeeping_check_update(struct timekeeper *tk, cycle_t offset)
>  		printk_deferred("WARNING: cycle offset (%lld) is past"
>  			" the %s 50%% safety margin (%lld)\n",
>  			offset, name, max_cycles>>1);
> +
> +	if (timekeeping_underflow_seen) {
> +		if (jiffies - last_warning > WARNINGFREQ) {
> +			printk_deferred("WARNING: Clocksource underflow observed\n");
> +			last_warning = jiffies;
> +		}
> +		timekeeping_underflow_seen = 0;
> +	}
> +	if (timekeeping_overflow_seen) {
> +		if (jiffies - last_warning > WARNINGFREQ) {
> +			printk_deferred("WARNING: Clocksource overflow observed\n");
> +			last_warning = jiffies;
> +		}
> +		timekeeping_overflow_seen = 0;
> +	}
> +
>  }

Ah, ignore my last comment. Excellent!
