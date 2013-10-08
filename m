Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab3JHVGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 17:06:06 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:40995 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab3JHVGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 17:06:01 -0400
MIME-Version: 1.0
In-Reply-To: <52546E85.3070407@wwwdotorg.org>
References: <1381238480-18852-1-git-send-email-ldewangan@nvidia.com>
	<525408B3.1000107@ti.com>
	<5254193A.70104@nvidia.com>
	<52542F69.30407@ti.com>
	<52543C1B.3000403@wwwdotorg.org>
	<525441DD.2090109@ti.com>
	<52546E85.3070407@wwwdotorg.org>
Date: Tue, 8 Oct 2013 16:05:59 -0500
X-Google-Sender-Auth: gI0plDmpCfyTuY7Q6UkrirKYKDg
Message-ID: <CAGo_u6p2uHf3f5qdSqfXqqKR4NaMvFyk02qTd7qK3jGOSeZ-Jw@mail.gmail.com>
Subject: Re: [PATCH V3] clk: palmas: add clock driver for palmas
From: Nishanth Menon <nm@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        J Keerthy <j-keerthy@ti.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 3:43 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 10/08/2013 11:33 AM, Nishanth Menon wrote:
>> On 10/08/2013 12:08 PM, Stephen Warren wrote:
>>> On 10/08/2013 10:14 AM, Nishanth Menon wrote:
>>>> On 10/08/2013 09:39 AM, Laxman Dewangan wrote:
>>>>> Thanks Nishanth for review.
>>>>>
>>>>> On Tuesday 08 October 2013 06:59 PM, Nishanth Menon wrote:
>>>>>> On 10/08/2013 08:21 AM, Laxman Dewangan wrote:
>>>>>>> Palmas devices has two clock output CLK32K_KG and CLK32K_KG_AUDIO
>>>>>> not all palmas devices have 2 clocks - example: tps659038
>>>>>
>>>>> This is for generic palmas and I have seen it for TPS65913, TPS65914,
>>>>> TPS80036. If the generic one is not compatible then it need to add
>>>>> device specific and at that time, it is require to update the binding
>>>>> document accordingly.
>>>>
>>>> ?? you do have two clocks inside the device they should be represented
>>>> as two compatible entities - that simplifies everyone's life.
>>>
>>> I think the terminology you're using here is quite confusing.
>>>
>>> Are you talking about having two different compatible values for two
>>> different HW designs, where those different designs implement different
>>> sets of clocks (which makes sense), or two different DT nodes for two
>>> different clocks (which IMHO doesn't always, unless those different
>>> clocks *truly* are separate IP blocks with completely independent
>>> register regions, and where those IP blocks are likely to be re-used
>>> as-is in other chips).
>>
>> clk32k and clk32k_audio are two different resources and since these
>> are two different resource instances - a "compatible" matching an
>> actual device is my suggestion.
>
> The fact that two clocks are two different resources isn't at all
> relevant to DT structure. HW module design is what's relevant.
>
>> clk32k and clk32k_audio are two different resources because they have
>> their specific set of controls registers and may even be independently
>> present in a Palmas variant.
>
> That's a better argument, assuming that: The registers for those two
> clocks aren't randomly interleaved with other registers within the HW
> module. That would imply that the clock registers aren't independant HW
> blocks.

You would be unpleasantly surprised if register offsets is a standard
to determine if IP blocks are independent instances or not. it is just
integration level decision, and unfortunately, not all h/w integration
guys care a lot about s/w :(.

>
>> To highlight this: The example of tps659038 where clk32k is not
>> present, but clk32k_audio is present (and happens to be disabled by
>> default - thanks to an OTP on the chip - on platform like DRA7-evm, it
>> is used to for 32k clk for wlan -currently hacked in u-boot using
>> plain i2c writes[1] - yes it is yucky).
>
> That can easily be handled by having separate compatible values for a
> monolithic overall Palmas or Palmas-clock node/HW-block. The fact that
> different chips are different doesn't, in and of itself, need to
> influence whether the different clocks are represented as different DT
> nodes.

So, the fact that a clock does not exist on a variation of palmas is
not sufficient proof that the blocks are independent.

I am not sure, given the lack of public documentation, short of
sharing rtl (which I cant ;) ), i might let this debate flame out..

>
>> Obviously, there are many ways to implement this. based on the current
>> implementation, it indicates that if i create a node with
>> "ti,palmas-clk" -i'd create two clocks - that is wrong for tps659038.
>>
>> Now (with the current approach), if I have to create a one clock for
>> tps659038, i have to fix the for adding clock providers, add up
>> "ti,tps659038-clk" etc.. it is doable - but IMHO, I dont need to do it
>> with only the relevant nodes in dts.
>>
>> Further, it has no way to indicate that device X uses clock Y using
>> clocks =<&xyz> either.
>
> Sorry, I just don't understand that.
>
> If a clock provider provides two clocks, it could number then e.g. 0 and
> 1. Clock consumers would reference those IDs. If a different chip that
> uses the same binding only supports one of those two clocks, just have
> the driver return an error if the DT attempts to use/reference the
> invalid clock ID; nothign could be simpler.

fair enough.

Regards,
Nishanth Menon
