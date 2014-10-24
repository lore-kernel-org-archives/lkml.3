Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbaJXAyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 20:54:14 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54200 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaJXAyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 20:54:13 -0400
Message-ID: <5449A333.3050504@codeaurora.org>
Date: Thu, 23 Oct 2014 17:54:11 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 8/8] clk: Add floor and ceiling constraints to clock
 rates
References: <1412866903-6970-1-git-send-email-tomeu.vizoso@collabora.com> <1412866903-6970-9-git-send-email-tomeu.vizoso@collabora.com> <20141010235541.GH5493@codeaurora.org> <CAAObsKAsf9po2mUBTDSz9+OXdD8GZnBQBGQYhXcBSgDM3gmVBw@mail.gmail.com>
In-Reply-To: <CAAObsKAsf9po2mUBTDSz9+OXdD8GZnBQBGQYhXcBSgDM3gmVBw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2014 06:27 AM, Tomeu Vizoso wrote:
> On 11 October 2014 01:55, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> On 10/09, Tomeu Vizoso wrote:
>>> +{
>>> +     int ret;
>>> +
>>> +     clk_prepare_lock();
>>> +
>>> +     clk->floor_constraint = rate;
>> No check for ceiling being less than floor?
> No, otherwise the calling code would have to be very careful to set
> both constraints in the correct order based on the current and next
> values. In practice I expect a given consumer to either set a floor or
> a constraint, but not both.

I totally missed this. Why can't we set the ceiling to ULONG_MAX when
the clock is created? That way we can drop the if check in the
aggregation logic for a 0 valued ceiling and then we can add the ceiling
being less than floor check here too?

>
>
>>> +
>>> +     WARN(rate > 0 && rate < clk->floor_constraint,
>>> +          "clk %s dev %s con %s: new ceiling %lu lower than existing floor %lu\n",
>>> +          clk->core->name, clk->dev_id, clk->con_id, rate,
>>> +          clk->floor_constraint);
>>> +
>>> +     clk->ceiling_constraint = rate;
>>> +     ret = clk_set_rate(clk, clk_get_rate(clk));
>> Why not just pass 0 as the second argument? The same comment
>> applies in the floor function.
> Both behaviours seem equally correct to me, but wonder if it wouldn't
> be better to store the rate that was last set explicitly with set_rate
> and try to reapply that one after every update to the constraints,
> instead of the current rate, or 0/INT_MAX.
>
>
>> This leads to another question though. What does it means for a
>> per-user clock to be disabled and change it's floor or ceiling?
>> Should that count in the aggregation logic?
> Per-user clocks don't get disabled, the whole clock does (but we can
> use per-user clk information to provide better debug information about
> unbalanced calls to prepare and enable).

Ok.

>> So far we haven't required drivers to explicitly call
>> clk_set_rate() with 0 so they can "drop" their rate request
>> because there isn't any other user and disabling the clock is
>> pretty much the same. With multiple users it looks like we're
>> going to require them to set the floor or ceiling to 0 or INT_MAX
>> if they want to remove their request. Alternatively we could
>> track the prepare/unprepare state of the per-user clock and drop
>> the constraint when that instance is unprepared (or reapply it
>> when prepared). It's pretty much a semantic difference, but one
>> benefit would be that we don't have to make two (or three?) calls
>> to the clock framework if we want to drop the rate constraints
>> and disable the clock.
> In my mind this is not such an issue because I view clock constraints
> as attributes of the per-user clks, while the enable and prepare
> states and the actual rate are attributes of the global clock
> instance.
>
>

Alright, I just want to make sure we thought about it. I'll try to think
of any reason for this behavior and if I don't think of anything I'm
happy with the way things are.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

