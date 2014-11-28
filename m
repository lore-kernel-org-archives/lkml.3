Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751279AbaK1NX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:23:59 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:44722 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaK1NX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:23:57 -0500
MIME-Version: 1.0
In-Reply-To: <546FF68E.8000707@codeaurora.org>
References: <1414666135-14313-1-git-send-email-tomeu.vizoso@collabora.com>
 <1414666135-14313-8-git-send-email-tomeu.vizoso@collabora.com>
 <20141114075007.GB11808@codeaurora.org> <CAAObsKAKGGoBFuic3_YcO0qcWDEvecUETpcycUa=FAXro12b+Q@mail.gmail.com>
 <546FF68E.8000707@codeaurora.org>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Fri, 28 Nov 2014 14:23:36 +0100
X-Google-Sender-Auth: m4rDKuV-DbSbwqvqTFYGY2I6YeY
Message-ID: <CAAObsKAoqXkxtHhfbeVZGciYUnSjYPuL7gYhWYZpQokOOsm+8w@mail.gmail.com>
Subject: Re: [PATCH v5 7/7] clk: Add floor and ceiling constraints to clock rates
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 November 2014 at 03:35, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 11/18/2014 08:31 AM, Tomeu Vizoso wrote:
>> On 14 November 2014 08:50, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>> It's
>>> possible that whatever is constrained at this user level goes
>>> down to the hardware driver and then is rounded up or down to a
>>> value that is outside of the constraints, in which case the
>>> constraints did nothing besides control the value that the
>>> hardware driver sees in the .round_rate() op. I doubt that was
>>> intended.
>> Indeed. Wonder what can be done about it with the least impact on
>> existing code. I see the situation as clk implementations being able
>> to apply arbitrary constraints in determine_rate() and round_rate(),
>> and they would need to take into account the per-user constraints so
>> they can all be applied consistently.
>
> I was thinking that we put the loop over .round_rate() in the clock
> framework, but you're right, we should provide the limits to the
> hardware drivers via the ops so that they can figure out the acceptable
> rate within whatever bounds the framework is maintaining. Given that
> we're changing the signature of determine_rate() in this series perhaps
> we should also add the floor/ceiling rates in there too. Then we can
> hope that we've finally gotten that new op right and set it in stone and
> migrate everyone over to .determine_rate() instead of .round_rate().

Sounds good, I'm implementing this in the CCF but leaving the
determine_rate implementations as they are for now.

>>> I also wonder what we should do about clocks that are in the
>>> middle of the tree (i.e. not a leaf) and have constraints set on
>>> them. It looks like if a child of that clock can propagate rates
>>> up to the parent that we've constrained with the per-user
>>> constraints, those constraints won't be respected at all, leading
>>> to a hole in the constraints.
>> True. Do we want to support per-user constraints on non-leaf clocks?
>
> I have an mmc clock rate where it would be helpful.

Ok, I have done some testing and the next revision should support this.

>>> I'm all for having a clk_set_rate_range() API (and floor/ceiling
>>> too), but it needs to be done much deeper in the core framework
>>> to actually work properly. Having a range API would make all the
>>> confusion about how a particular clock driver decides to round a
>>> rate go away and just leave an API that sanely says the rate will
>>> be within these bounds or an error will be returned stating it
>>> can't be satisfied.
>> This sounds like a good way forward, but TBH I don't understand what
>> you are proposing. Would you care to elaborate on how the API that you
>> propose would look like?
>>
>
> clk_set_rate_range(struct clk *clk, unsigned long min, unsigned long max);
>
> clk_set_floor(struct clk *clk, unsigned long floor)
> {
>     return clk_set_rate_range(clk, floor, ULONG_MAX);
> }

I have actually gone with:

    return clk_set_rate_range(clk, rate, clk->ceiling_constraint);

Because I think that setting a floor shouldn't remove the existing
ceiling as a side effect.

> clk_set_ceiling(struct clk *clk, unsigned long ceiling)
> {
>     return clk_set_rate_range(clk, 0, ceiling);
> }

Ditto.

> Unfortunately we can't make clk_set_rate() a thin wrapper on top that
> says min/max is the same as the requested rate because that would
> horribly break current users of the API. I suppose we could call
> clk_round_rate() and then clk_set_rate_range() with the floor as the
> rounded rate and the ceiling as ULONG_MAX? Or maybe floor is 0 and
> ceiling is rounded rate, not sure it actually matters.
>
> clk_set_rate(struct clk *clk, unsigned long rate)
> {
>     unsigned long rounded;
>
>     rounded = clk_round_rate(clk, rate);
>     return clk_set_rate_range(rounded, ULONG_MAX);
> }

I'm not fond of this because the rate is a quality of the clk_core
while constraints are per-user.

> Now we can get down to the real work. __clk_round_rate() will apply the
> constraints. It will also send down the constraints to .determine_rate()
> ops

Cool, this works quite well here.

> and throw errors if things don't work out (ugh we may need to return
> the rate by reference so we can return unsigned long rates here or use
> IS_ERR_VALUE() on the return value).

What errors were you thinking of? I was thinking that we are just
adding two more constraints to the existing set, so we aren't adding
any new error conditions.

> In the case that clk_round_rate()
> is calling this function it will need to know that we don't want any
> constraints applied, so it will need to take min, max, and rate and
> clk_round_rate() will just pass 0, ULONG_MAX, and rate respectfully.

Ok.

> Next clk_set_rate() will be renamed to clk_set_rate_range() (in clk.c)
> and then it will pass the constraints to clk_calc_new_rates(). We can
> also try to bail out early here by checking the constraints against the
> current rate to make sure it's within bounds.

As mentioned before, I haven't gone with this. A use case I have in
mind is a thermal driver throttling the external memory bus by
applying a ceiling. Once we get out of the condition that caused the
limit, the effective rate should go back to the older value (we should
reevaluate the constraints on top of the last requested rate).

I will be sending a new version in a bit that works this way.

> We can probably redo
> clk_calc_new_rates() to be similar to __clk_round_rate() and apply any
> constraints that are passed into the function along with any per-user
> constraints that already exist.

Sorry, didn't quite get this, but hopefully the new version addresses it.

Thanks,

Tomeu

> Did I miss anything?
>
> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> a Linux Foundation Collaborative Project
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
