Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765Ab3FDBwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 21:52:04 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58331 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758666Ab3FDBwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 21:52:01 -0400
Message-ID: <51AD483F.2010206@codeaurora.org>
Date: Mon, 03 Jun 2013 18:51:59 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arm-msm@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 4/6] sched_clock: Add support for >32 bit sched_clock
References: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org> <1370155183-31421-5-git-send-email-sboyd@codeaurora.org> <20130603093938.GG18614@n2100.arm.linux.org.uk> <51AD069F.1060308@codeaurora.org> <20130603221210.GO18614@n2100.arm.linux.org.uk>
In-Reply-To: <20130603221210.GO18614@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/13 15:12, Russell King - ARM Linux wrote:
> On Mon, Jun 03, 2013 at 02:11:59PM -0700, Stephen Boyd wrote:
>> On 06/03/13 02:39, Russell King - ARM Linux wrote:
>>> On Sat, Jun 01, 2013 at 11:39:41PM -0700, Stephen Boyd wrote:
>>>> +}
>>>> +
>>>> +void __init
>>>> +setup_sched_clock_64(u64 (*read)(void), int bits, unsigned long rate)
>>>> +{
>>>> +	if (cd.rate > rate)
>>>> +		return;
>>>> +
>>>> +	BUG_ON(bits <= 32);
>>>> +	WARN_ON(!irqs_disabled());
>>>> +	read_sched_clock_64 = read;
>>>> +	sched_clock_func = sched_clock_64;
>>>> +	cd.rate = rate;
>>>> +	cd.mult = NSEC_PER_SEC / rate;
>>> Here, you don't check that the (2^bits) * mult results in a wrap of the
>>> resulting 64-bit number, which is a _basic_ requirement for sched_clock
>>> (hence all the code for <=32bit clocks, otherwise we wouldn't need this
>>> complexity in the first place.)
>> Ok I will use clocks_calc_mult_shift() here.
> No, that's not the problem.
>
> If you have a 56-bit clock which ticks at a period of 1ns, then
> cd.rate = 1, and your sched_clock() values will be truncated to 56-bits.
> The scheduler always _requires_ 64-bits from sched_clock.  That's why we
> have the complicated code to extend the 32-bits-or-less to a _full_
> 64-bit value.
>
> Let me make this clearer: sched_clock() return values _must_ without
> exception monotonically increment from zero to 2^64-1 and then wrap
> back to zero.  No other behaviour is acceptable for sched_clock().

Ok so you're saying if we have less than 64 bits of useable information
we _must_ do something to find where the wraparound will occur and
adjust for it so that epoch_ns is always incrementing until 2^64-1. Fair
enough. I was trying to avoid more work because on arm architected timer
platforms it takes many years for that to happen.

I'll see what I can do.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

