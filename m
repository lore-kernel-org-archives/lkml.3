Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab3JHRdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 13:33:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45691 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab3JHRdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 13:33:52 -0400
Message-ID: <525441DD.2090109@ti.com>
Date: Tue, 8 Oct 2013 12:33:17 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        J Keerthy <j-keerthy@ti.com>
Subject: Re: [PATCH V3] clk: palmas: add clock driver for palmas
References: <1381238480-18852-1-git-send-email-ldewangan@nvidia.com> <525408B3.1000107@ti.com> <5254193A.70104@nvidia.com> <52542F69.30407@ti.com> <52543C1B.3000403@wwwdotorg.org>
In-Reply-To: <52543C1B.3000403@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2013 12:08 PM, Stephen Warren wrote:
> On 10/08/2013 10:14 AM, Nishanth Menon wrote:
>> On 10/08/2013 09:39 AM, Laxman Dewangan wrote:
>>> Thanks Nishanth for review.
>>>
>>> On Tuesday 08 October 2013 06:59 PM, Nishanth Menon wrote:
>>>> On 10/08/2013 08:21 AM, Laxman Dewangan wrote:
>>>>> Palmas devices has two clock output CLK32K_KG and CLK32K_KG_AUDIO
>>>> not all palmas devices have 2 clocks - example: tps659038
>>>
>>> This is for generic palmas and I have seen it for TPS65913, TPS65914, 
>>> TPS80036. If the generic one is not compatible then it need to add  
>>> device specific and at that time, it is require to update the binding 
>>> document accordingly.
>>
>> ?? you do have two clocks inside the device they should be represented
>> as two compatible entities - that simplifies everyone's life.
> 
> I think the terminology you're using here is quite confusing.
> 
> Are you talking about having two different compatible values for two
> different HW designs, where those different designs implement different
> sets of clocks (which makes sense), or two different DT nodes for two
> different clocks (which IMHO doesn't always, unless those different
> clocks *truly* are separate IP blocks with completely independent
> register regions, and where those IP blocks are likely to be re-used
> as-is in other chips).
> 
clk32k and clk32k_audio are two different resources and since these
are two different resource instances - a "compatible" matching an
actual device is my suggestion.

clk32k and clk32k_audio are two different resources because they have
their specific set of controls registers and may even be independently
present in a Palmas variant.

To highlight this: The example of tps659038 where clk32k is not
present, but clk32k_audio is present (and happens to be disabled by
default - thanks to an OTP on the chip - on platform like DRA7-evm, it
is used to for 32k clk for wlan -currently hacked in u-boot using
plain i2c writes[1] - yes it is yucky).

Obviously, there are many ways to implement this. based on the current
implementation, it indicates that if i create a node with
"ti,palmas-clk" -i'd create two clocks - that is wrong for tps659038.

Now (with the current approach), if I have to create a one clock for
tps659038, i have to fix the for adding clock providers, add up
"ti,tps659038-clk" etc.. it is doable - but IMHO, I dont need to do it
with only the relevant nodes in dts.

Further, it has no way to indicate that device X uses clock Y using
clocks =<&xyz> either.

[1] DRA7-evm u-boot hack.
i2c dev 0
i2c probe
i2c mw 0x58 0xfb 0x2b (select secondary function for GPIO_5)
i2c mw 0x58 0xd5 0x01 (enable audio clock)

-- 
Regards,
Nishanth Menon
