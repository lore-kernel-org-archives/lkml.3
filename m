Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaBZE7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 23:59:00 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16163 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaBZE66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 23:58:58 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 25 Feb 2014 20:56:20 -0800
Message-ID: <530D748D.6010802@nvidia.com>
Date: Wed, 26 Feb 2014 13:58:53 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra: add device tree for SHIELD
References: <1393237593-28121-1-git-send-email-acourbot@nvidia.com> <530B952D.2000006@wwwdotorg.org> <530BFC58.6020003@nvidia.com> <530D1B7A.9070209@wwwdotorg.org>
In-Reply-To: <530D1B7A.9070209@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 07:38 AM, Stephen Warren wrote:
> On 02/24/2014 07:13 PM, Alexandre Courbot wrote:
>> On 02/25/2014 03:53 AM, Stephen Warren wrote:
>>> On 02/24/2014 03:26 AM, Alexandre Courbot wrote:
>>>> Add a device tree for NVIDIA SHIELD. The set of enabled features is
>>>> still minimal with no display option (although HDMI should be easy
>>>> to get to work) and USB requiring external power.
>
>>>> diff --git a/arch/arm/boot/dts/tegra114-roth.dts
>>>> b/arch/arm/boot/dts/tegra114-roth.dts
>>>
>>>> +    memory {
>>>> +        reg = <0x80000000 0x79600000>;
>>>
>>> It might be worth a comment here pointing out that the rest of RAM is
>>> reserved for some carveouts/..., or at least that these values are set
>>> this way in order to match what the bootloader usually passes to
>>> downstream kernels in the command-line?
>>
>> Yes, absolutely right. On a more general note I feel like DTs could gain
>> clarity if they had more comments (e.g. for pinmuxing which are a quite
>> heavy block otherwise), do you have any objection to this? (I guess not,
>> but so far the rule seems to be "no comment in DT" :P )
>
> I have no objection in particular. Specifically for pinmux, the values
> seem pretty obvious, so I'm not sure what extra the comment could
> convey, but I'll take a look at any proposed patch:-)

It would just make grouping of related pins according more visible than 
having to look at the "nvidia,function" property currently does - just a 
little added comfort.

>>>> +    /* Wifi */
>>>> +    sdhci@78000000 {
>>>> +        status = "okay";
>>>> +        bus-width = <4>;
>>>> +        broken-cd;
>>>> +        keep-power-in-suspend;
>>>> +        cap-sdio-irq;
>>>
>>> Is non-removable better than broken-cd, or are they entirely unrelated?
>>
>> They are unrelated actually. With non-removable the driver expects the
>> device to always be there since boot, and does not check for the card to
>> be removed/added after boot. broken-cd indicates there is no CD line and
>> the device should be polled regularly.
>
> It doesn't sound like that's what we want either; we should know exactly
> when the device is added/removed, based on when the relevant
> clocks/supplies/... are turned on/off.

Yes, I guess this will require a proper DT binding like what Arend proposed.

>> For the Wifi chip, non-removable would be the correct setting
>> hardware-wise, but there is a trap: the chip has its reset line asserted
>> at boot-time, and you need to set GPIO 229 to de-assert it. Only after
>> that will the device be detected on the SDIO bus. Since it lacks a CD
>> line, it must be polled, hence the broken-cd property.
>
> How does that GPIO get manipulated right now? I assume you must be
> manually configuring it via sysfs after boot or something? If so,
> perhaps it's best to just leave out the WiFi node until it works
> automatically.

The GPIO needs to be set from user-space, yes. But if we leave the Wifi 
node out, I'm concerned that wireless will not be usable at all, 
wouldn't it?

>> This also raises another, redundant problem with DT bindings: AFAIK we
>> currently have no way to let the system know the device will only appear
>> after a given GPIO is set. It would also be nice to be able to give some
>> parameters to the Wifi driver through the DT (like the OOB interrupt).
>> Right now the Wifi chip is brought up by exporting the GPIO and writing
>> to it from user-space, and the OOB interrupt is not used.
>
> There was a thread on this topic on LAKML recently. I didn't really
> follow it, so I don't know if there was a useful resolution. I think it
> was "mmc: add support for power-on sequencing through DT", although
> there may have been other related threads. It was possibly tangentially
> related to power-sequences-in-DT...
>
> ...
>> I'm not sure about cap-sdio-irq, it doesn't seem to make a difference
>> for SHIELD Wifi.
>
> I'd tend to leave it out then.

I will check whether it helps with the latency issues I have noticed and 
remove it if it doesn't.

Thanks,
Alex.

