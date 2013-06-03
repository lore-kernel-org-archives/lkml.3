Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab3FCJj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:39:57 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33888 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab3FCJjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:39:55 -0400
Date: Mon, 3 Jun 2013 10:39:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv2 4/6] sched_clock: Add support for >32 bit sched_clock
Message-ID: <20130603093938.GG18614@n2100.arm.linux.org.uk>
References: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org> <1370155183-31421-5-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370155183-31421-5-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 01, 2013 at 11:39:41PM -0700, Stephen Boyd wrote:
> The ARM architected system counter has at least 56 useable bits.
> Add support for counters with more than 32 bits to the generic
> sched_clock implementation so we can avoid the complexity of
> dealing with wrap-around on these devices while benefiting from
> the irqtime accounting and suspend/resume handling that the
> generic sched_clock code already has.

This looks like a horrid hack to me.

> +static unsigned long long notrace sched_clock_64(void)
> +{
> +	u64 cyc = read_sched_clock_64() - cd.epoch_ns;
> +	return cyc * cd.mult;

So, the use of cd.mult implies that the return value from
read_sched_clock_64() is not nanoseconds but something else.  But then
we subtract it from the nanoseconds epoch - which has to be nanoseconds
because you simply return that when suspended.

> +}
> +
> +void __init
> +setup_sched_clock_64(u64 (*read)(void), int bits, unsigned long rate)
> +{
> +	if (cd.rate > rate)
> +		return;
> +
> +	BUG_ON(bits <= 32);
> +	WARN_ON(!irqs_disabled());
> +	read_sched_clock_64 = read;
> +	sched_clock_func = sched_clock_64;
> +	cd.rate = rate;
> +	cd.mult = NSEC_PER_SEC / rate;

Here, you don't check that the (2^bits) * mult results in a wrap of the
resulting 64-bit number, which is a _basic_ requirement for sched_clock
(hence all the code for <=32bit clocks, otherwise we wouldn't need this
complexity in the first place.)

So, I think this whole approach is broken.
