Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaJCOOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 10:14:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53713 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaJCOOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 10:14:11 -0400
Message-ID: <542EAF1B.4080809@ti.com>
Date: Fri, 3 Oct 2014 17:13:47 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [RFC] clk: Make clk API return per-user struct clk instances
References: <20140926232009.19023.15825@quantum> <1412014643-29099-1-git-send-email-tomeu.vizoso@collabora.com> <542A0A07.8040205@codeaurora.org> <20140930065432.19023.19492@quantum> <542A5E9F.2010006@ti.com> <20140930181658.GG3122@atomide.com>
In-Reply-To: <20140930181658.GG3122@atomide.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2014 09:16 PM, Tony Lindgren wrote:
> * Tero Kristo <t-kristo@ti.com> [140930 00:41]:
>> On 09/30/2014 09:54 AM, Mike Turquette wrote:
>>> Quoting Stephen Boyd (2014-09-29 18:40:23)
>>>> On 09/29/14 11:17, Tomeu Vizoso wrote:
>>>>> Also moves clock state to struct clk_core, but takes care to change as little
>>>>> API as possible.
>>>>>
>>>>> struct clk_hw still has a pointer to a struct clk, which is the
>>>>> implementation's per-user clk instance, for backwards compatibility.
>>>>>
>>>>> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>>>>>
>>>>> ---
>>>>>
>>>>> Hello,
>>>>>
>>>>> I'm sending this alternate implementation of the switch to per-user clocks,
>>>>> with the added goal of not requiring any substantial changes to existing users
>>>>> of the API.
>>>>>
>>>>> This is pretty much RFC-quality right now, having only tested that it builds on
>>>>> tegra_defconfig.
>>>>>
>>>>> My main question right now is what do we want to do with those drivers that
>>>>> statically declare clocks. State is now in struct clk_core, so updating the
>>>>> drivers accordingly will amount to a substantial amount of lines changed, which
>>>>> we are now trying to avoid.
>>>>
>>>> Who's actually using the static clocks? Isn't it just omap2? It looks
>>>> like all of those are behind the DEFINE_CLK define so changing it in
>>>> clk-private.h should "just work". I'm lost as to why static clocks are
>>>> being used there though. If it was a problem with allocating memory too
>>>> early it doesn't seem to be the case given that sometimes the .parents
>>>> field isn't set for a mux and __clk_init() will go and allocate an array
>>>> of pointers. Maybe I missed something though.
>>>
>>> Yeah, the old omap2+ static clocks were due to very very early init of
>>> things which required clocks
>>>
>>> If memory serves, that isn't a problem any more. I've talked to Tony and
>>> Tero about my desire to remove clk-private.h and the need to get rid of
>>> its use in the omap clock code.
>>>
>>> Tero, what is the status of DT conversion for OMAP2/OMAP3? Can we get
>>> get away with only defining clock data in DT for those platforms? Can we
>>> finally kill off clk-private.h?
>>
>> Clock data has been converted for all SoCs. The problem is currently that we
>> are missing some OMAP3 based DT board definitions and still require legacy
>> boot => thus requiring legacy clock data also => omap3 legacy clock data
>> can't be removed yet.
>>
>> Tony, whats the latest status with these missing omap3 boards? How many
>> board->dt conversions are still needed? Is there anything someone can do on
>> this front?
>
> Well things are looking good for device tree based booting for omap3
> in general. We just need to wait so people have enough time to update
> their boards and do the missing .dts files. I guess all we can say is
> we drop omap3 legacy booting when we can.
>
> Can we remove the depenency to the omap3 DT conversion for the clocks
> to remove the DT conversion dependency here?

Well, we can. But this basically requires converting the legacy clock 
data to some intermediate format, parsing this init time and registering 
the individual clocks.. something similar to what is done with DT clocks 
now. Kind of pointless exercise with data that is going to be removed 
eventually, no? I think converting the boards to DT files is easier and 
more fruitful also.

-Tero

