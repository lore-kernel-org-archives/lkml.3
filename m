Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbaK1K4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:56:35 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:41218 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaK1K4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:56:31 -0500
Message-ID: <547854D0.1020506@arm.com>
Date: Fri, 28 Nov 2014 10:56:16 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Liviu Dudau <Liviu.Dudau@arm.com>, Jisheng Zhang <jszhang@marvell.com>
CC: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] arm64: ARM: Fix the Generic Timers interrupt active
 level description
References: <1417105283-19575-1-git-send-email-Liviu.Dudau@arm.com> <54776FE0.8030600@arm.com> <20141128111252.4a6e8892@xhacker> <20141128103843.GW828@e106497-lin.cambridge.arm.com>
In-Reply-To: <20141128103843.GW828@e106497-lin.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/11/14 10:38, Liviu Dudau wrote:
> On Fri, Nov 28, 2014 at 03:12:52AM +0000, Jisheng Zhang wrote:
>> Dear Marc and Liviu,
>>
>> On Thu, 27 Nov 2014 10:39:28 -0800
>> Marc Zyngier <marc.zyngier@arm.com> wrote:
>>
>>> On 27/11/14 16:21, Liviu Dudau wrote:
>>>> The Cortex-A5x TRM states in paragraph "9.2 Generic Timer functional
>>>> description" that generic timers provide a level not edge interrupt
>>>> output. Fix the device trees to correctly describe this.
>>>>
>>>> While doing this update the CPU mask to match the number of described
>>>> CPUs as well as the DT bindings documentation for Generic Timers.
>>>>
>>>> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
>>>
>>> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
>>>
>>> 	M.
>>>
>>>> ---
>>>>
>>>> Arnd, Olof: This is on top of linux-next/master as it patches Juno's
>>>> as well as all the other ARM DTs.
>>>>
>>>> --
>>>>
>>>>  Documentation/devicetree/bindings/arm/arch_timer.txt | 8 ++++----
>>>>  arch/arm64/boot/dts/arm/foundation-v8.dts            | 8 ++++----
>>>>  arch/arm64/boot/dts/arm/juno.dts                     | 8 ++++----
>>>>  arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts           | 8 ++++----
>>>>  4 files changed, 16 insertions(+), 16 deletions(-)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/arm/arch_timer.txt
>>>> b/Documentation/devicetree/bindings/arm/arch_timer.txt index
>>>> 37b2caf..6d2aa87 100644 ---
>>>> a/Documentation/devicetree/bindings/arm/arch_timer.txt +++
>>>> b/Documentation/devicetree/bindings/arm/arch_timer.txt @@ -27,10 +27,10
>>>> @@ Example: timer {
>>>>  		compatible = "arm,cortex-a15-timer",
>>>>  			     "arm,armv7-timer";
>>>> -		interrupts = <1 13 0xf08>,
>>>> -			     <1 14 0xf08>,
>>>> -			     <1 11 0xf08>,
>>>> -			     <1 10 0xf08>;
>>>> +		interrupts = <1 13 0xf04>,
>>>> +			     <1 14 0xf04>,
>>>> +			     <1 11 0xf04>,
>>>> +			     <1 10 0xf04>;
>>>>  		clock-frequency = <100000000>;
>>>>  	};
>>>>  
>>
>> Does it mean we also need to fix the interrupt level description under
>> arch/arm/boot/dts? I found they are also wrong or I misunderstand something?
> 
> Hi Jisheng,
> 
> It looks like Marc and I managed to confuse ourselves. The TRM for GIC-500 and
> GIC-400 (basically covering most of GICv1 and > GICv2) clearly says that for *PPIs*
> the level triggered interrupts are active-LOW.
> 
> So, this patch is invalid and my v1 version is correct, but Marc tells that in
> that case the GIC driver needs patching (which I'm going to look into).

Yeah, we have a pathological case of confusion of config information
between PPIs and SPIs:
- SPIs are always rising-edge or active-high
- PPIs are implementation defined, and even their configurability is
implementation defined

The fact that on all ARM implementations, the PPI are not configurable
is the saving grace. No matter how wrong the DTs are, we'll do the right
thing, and all the existing code actually relies on the defaults values
anyway.

Well, until someone tries and configure a PPI (at least Qualcomm's
implementations are actually programmable), and asks for an active-low
value, which will get rejected.

Basically, all can we do at the GIC level is to accept all combinations
of edge/level for PPIs, reduce that to the single bit of config we have,
and check that it sticks. The result may not be what the driver asked
for, but we have no way to know.

GIC bindings will have to be updated too.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
