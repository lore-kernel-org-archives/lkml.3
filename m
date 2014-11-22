Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbaKVCgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 21:36:05 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33196 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaKVCgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 21:36:03 -0500
Message-ID: <546FF68E.8000707@codeaurora.org>
Date: Fri, 21 Nov 2014 18:35:58 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 7/7] clk: Add floor and ceiling constraints to clock
 rates
References: <1414666135-14313-1-git-send-email-tomeu.vizoso@collabora.com> <1414666135-14313-8-git-send-email-tomeu.vizoso@collabora.com> <20141114075007.GB11808@codeaurora.org> <CAAObsKAKGGoBFuic3_YcO0qcWDEvecUETpcycUa=FAXro12b+Q@mail.gmail.com>
In-Reply-To: <CAAObsKAKGGoBFuic3_YcO0qcWDEvecUETpcycUa=FAXro12b+Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2014 08:31 AM, Tomeu Vizoso wrote:
> On 14 November 2014 08:50, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> It's
>> possible that whatever is constrained at this user level goes
>> down to the hardware driver and then is rounded up or down to a
>> value that is outside of the constraints, in which case the
>> constraints did nothing besides control the value that the
>> hardware driver sees in the .round_rate() op. I doubt that was
>> intended.
> Indeed. Wonder what can be done about it with the least impact on
> existing code. I see the situation as clk implementations being able
> to apply arbitrary constraints in determine_rate() and round_rate(),
> and they would need to take into account the per-user constraints so
> they can all be applied consistently.

I was thinking that we put the loop over .round_rate() in the clock
framework, but you're right, we should provide the limits to the
hardware drivers via the ops so that they can figure out the acceptable
rate within whatever bounds the framework is maintaining. Given that
we're changing the signature of determine_rate() in this series perhaps
we should also add the floor/ceiling rates in there too. Then we can
hope that we've finally gotten that new op right and set it in stone and
migrate everyone over to .determine_rate() instead of .round_rate().

>
>> I also wonder what we should do about clocks that are in the
>> middle of the tree (i.e. not a leaf) and have constraints set on
>> them. It looks like if a child of that clock can propagate rates
>> up to the parent that we've constrained with the per-user
>> constraints, those constraints won't be respected at all, leading
>> to a hole in the constraints.
> True. Do we want to support per-user constraints on non-leaf clocks?

I have an mmc clock rate where it would be helpful.

>> I'm all for having a clk_set_rate_range() API (and floor/ceiling
>> too), but it needs to be done much deeper in the core framework
>> to actually work properly. Having a range API would make all the
>> confusion about how a particular clock driver decides to round a
>> rate go away and just leave an API that sanely says the rate will
>> be within these bounds or an error will be returned stating it
>> can't be satisfied.
> This sounds like a good way forward, but TBH I don't understand what
> you are proposing. Would you care to elaborate on how the API that you
> propose would look like?
>

clk_set_rate_range(struct clk *clk, unsigned long min, unsigned long max);

clk_set_floor(struct clk *clk, unsigned long floor)
{
    return clk_set_rate_range(clk, floor, ULONG_MAX);
}

clk_set_ceiling(struct clk *clk, unsigned long ceiling)
{
    return clk_set_rate_range(clk, 0, ceiling);
}

Unfortunately we can't make clk_set_rate() a thin wrapper on top that
says min/max is the same as the requested rate because that would
horribly break current users of the API. I suppose we could call
clk_round_rate() and then clk_set_rate_range() with the floor as the
rounded rate and the ceiling as ULONG_MAX? Or maybe floor is 0 and
ceiling is rounded rate, not sure it actually matters.

clk_set_rate(struct clk *clk, unsigned long rate)
{
    unsigned long rounded;
   
    rounded = clk_round_rate(clk, rate);
    return clk_set_rate_range(rounded, ULONG_MAX);
}

Now we can get down to the real work. __clk_round_rate() will apply the
constraints. It will also send down the constraints to .determine_rate()
ops and throw errors if things don't work out (ugh we may need to return
the rate by reference so we can return unsigned long rates here or use
IS_ERR_VALUE() on the return value). In the case that clk_round_rate()
is calling this function it will need to know that we don't want any
constraints applied, so it will need to take min, max, and rate and
clk_round_rate() will just pass 0, ULONG_MAX, and rate respectfully.

Next clk_set_rate() will be renamed to clk_set_rate_range() (in clk.c)
and then it will pass the constraints to clk_calc_new_rates(). We can
also try to bail out early here by checking the constraints against the
current rate to make sure it's within bounds. We can probably redo
clk_calc_new_rates() to be similar to __clk_round_rate() and apply any
constraints that are passed into the function along with any per-user
constraints that already exist.

Did I miss anything?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

