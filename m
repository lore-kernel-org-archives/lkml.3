Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbaI3Hkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:40:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34310 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbaI3Hka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:40:30 -0400
Message-ID: <542A5E9F.2010006@ti.com>
Date: Tue, 30 Sep 2014 10:41:19 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Russell King <linux@arm.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        <tony@atomide.com>
Subject: Re: [RFC] clk: Make clk API return per-user struct clk instances
References: <20140926232009.19023.15825@quantum> <1412014643-29099-1-git-send-email-tomeu.vizoso@collabora.com> <542A0A07.8040205@codeaurora.org> <20140930065432.19023.19492@quantum>
In-Reply-To: <20140930065432.19023.19492@quantum>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2014 09:54 AM, Mike Turquette wrote:
> Quoting Stephen Boyd (2014-09-29 18:40:23)
>> On 09/29/14 11:17, Tomeu Vizoso wrote:
>>> Also moves clock state to struct clk_core, but takes care to change as little
>>> API as possible.
>>>
>>> struct clk_hw still has a pointer to a struct clk, which is the
>>> implementation's per-user clk instance, for backwards compatibility.
>>>
>>> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>>>
>>> ---
>>>
>>> Hello,
>>>
>>> I'm sending this alternate implementation of the switch to per-user clocks,
>>> with the added goal of not requiring any substantial changes to existing users
>>> of the API.
>>>
>>> This is pretty much RFC-quality right now, having only tested that it builds on
>>> tegra_defconfig.
>>>
>>> My main question right now is what do we want to do with those drivers that
>>> statically declare clocks. State is now in struct clk_core, so updating the
>>> drivers accordingly will amount to a substantial amount of lines changed, which
>>> we are now trying to avoid.
>>
>> Who's actually using the static clocks? Isn't it just omap2? It looks
>> like all of those are behind the DEFINE_CLK define so changing it in
>> clk-private.h should "just work". I'm lost as to why static clocks are
>> being used there though. If it was a problem with allocating memory too
>> early it doesn't seem to be the case given that sometimes the .parents
>> field isn't set for a mux and __clk_init() will go and allocate an array
>> of pointers. Maybe I missed something though.
>
> Yeah, the old omap2+ static clocks were due to very very early init of
> things which required clocks
>
> If memory serves, that isn't a problem any more. I've talked to Tony and
> Tero about my desire to remove clk-private.h and the need to get rid of
> its use in the omap clock code.
>
> Tero, what is the status of DT conversion for OMAP2/OMAP3? Can we get
> get away with only defining clock data in DT for those platforms? Can we
> finally kill off clk-private.h?

Clock data has been converted for all SoCs. The problem is currently 
that we are missing some OMAP3 based DT board definitions and still 
require legacy boot => thus requiring legacy clock data also => omap3 
legacy clock data can't be removed yet.

Tony, whats the latest status with these missing omap3 boards? How many 
board->dt conversions are still needed? Is there anything someone can do 
on this front?

-Tero

>
> Regards,
> Mike
>
>>
>>>
>>> Thanks,
>>>
>>> Tomeu
>>> ---
>>>   drivers/clk/clk-composite.c  |  12 +-
>>>   drivers/clk/clk.c            | 573 +++++++++++++++++++++++++++----------------
>>>   drivers/clk/clk.h            |   5 +
>>>   drivers/clk/clkdev.c         |  20 +-
>>>   drivers/clk/tegra/clk.c      |   2 +-
>>>   include/linux/clk-private.h  |  20 +-
>>>   include/linux/clk-provider.h |  22 +-
>>>   include/linux/clkdev.h       |   2 +-
>>>   8 files changed, 410 insertions(+), 246 deletions(-)
>>>
>>> diff --git a/drivers/clk/clk-composite.c b/drivers/clk/clk-composite.c
>>> index b9355da..cb4a09d 100644
>>> --- a/drivers/clk/clk-composite.c
>>> +++ b/drivers/clk/clk-composite.c
>>> @@ -57,14 +57,14 @@ static unsigned long clk_composite_recalc_rate(struct clk_hw *hw,
>>>
>>>   static long clk_composite_determine_rate(struct clk_hw *hw, unsigned long rate,
>>>                                        unsigned long *best_parent_rate,
>>> -                                     struct clk **best_parent_p)
>>> +                                     struct clk_core **best_parent_p)
>>
>>
>> We should avoid exposing clk_core to anything besides clk.c or users of
>> clk-private.h (the latter which should go away once we remove all static
>> clocks).
>>
>> --
>> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
>> hosted by The Linux Foundation
>>

