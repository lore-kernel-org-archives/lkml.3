Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab3FJPQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 11:16:39 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:58295 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab3FJPQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 11:16:38 -0400
MIME-Version: 1.0
In-Reply-To: <20130603221210.GO18614@n2100.arm.linux.org.uk>
References: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org>
	<1370155183-31421-5-git-send-email-sboyd@codeaurora.org>
	<20130603093938.GG18614@n2100.arm.linux.org.uk>
	<51AD069F.1060308@codeaurora.org>
	<20130603221210.GO18614@n2100.arm.linux.org.uk>
Date: Mon, 10 Jun 2013 20:46:36 +0530
Message-ID: <CAK7N6vrVvYPP8_y9F3uC=vZpdkb7_9gdzG96xSiyr0ASe6iMCQ@mail.gmail.com>
Subject: Re: [PATCHv2 4/6] sched_clock: Add support for >32 bit sched_clock
From: anish singh <anish198519851985@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>, arm@kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 4, 2013 at 3:42 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Jun 03, 2013 at 02:11:59PM -0700, Stephen Boyd wrote:
>> On 06/03/13 02:39, Russell King - ARM Linux wrote:
>> > On Sat, Jun 01, 2013 at 11:39:41PM -0700, Stephen Boyd wrote:
>> >> +}
>> >> +
>> >> +void __init
>> >> +setup_sched_clock_64(u64 (*read)(void), int bits, unsigned long rate)
>> >> +{
>> >> +  if (cd.rate > rate)
>> >> +          return;
>> >> +
>> >> +  BUG_ON(bits <= 32);
>> >> +  WARN_ON(!irqs_disabled());
>> >> +  read_sched_clock_64 = read;
>> >> +  sched_clock_func = sched_clock_64;
>> >> +  cd.rate = rate;
>> >> +  cd.mult = NSEC_PER_SEC / rate;
>> > Here, you don't check that the (2^bits) * mult results in a wrap of the
>> > resulting 64-bit number, which is a _basic_ requirement for sched_clock
>> > (hence all the code for <=32bit clocks, otherwise we wouldn't need this
>> > complexity in the first place.)
>>
>> Ok I will use clocks_calc_mult_shift() here.
>
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

Probably a trivial question.I was wondering why this particular requirement
exists in the first place.I looked into this commit 112f38a4a3 but couldn't
gather the reason.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
