Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760885Ab3GaWUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:20:01 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:39642 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757714Ab3GaWT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:19:59 -0400
Message-ID: <51F98D92.3010607@cogentembedded.com>
Date: Thu, 01 Aug 2013 02:20:02 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: Re: [PATCH 2/2] ARM: dts: USB for Tegra114 Dalmore
References: <1375292543-7896-1-git-send-email-ttynkkynen@nvidia.com> <1375292543-7896-3-git-send-email-ttynkkynen@nvidia.com> <51F9550F.3080503@cogentembedded.com> <51F9660C.6090604@iki.fi> <51F96B48.10209@cogentembedded.com> <51F98A78.9060309@wwwdotorg.org>
In-Reply-To: <51F98A78.9060309@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 02:06 AM, Stephen Warren wrote:

>>>>> Device tree entries for the three EHCI controllers on Tegra114.
>>>>> Enables the the third controller (USB host) on Dalmore.

>>>>> diff --git a/arch/arm/boot/dts/tegra114.dtsi
>>>>> b/arch/arm/boot/dts/tegra114.dtsi
>>>>> index abf6c40..2905145 100644
>>>>> --- a/arch/arm/boot/dts/tegra114.dtsi
>>>>> +++ b/arch/arm/boot/dts/tegra114.dtsi
>>>>> @@ -430,6 +430,68 @@
>>>>>            status = "disable";
>>>>>        };
>>>>>
>>>>> +    usb@7d000000 {
>>>>> +        compatible = "nvidia,tegra30-ehci", "usb-ehci";
>>>>> +        reg = <0x7d000000 0x4000>;
>>>>> +        interrupts = <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
>>>>> +        phy_type = "utmi";
>>>>> +        clocks = <&tegra_car TEGRA114_CLK_USBD>;
>>>>> +        nvidia,phy = <&phy1>;
>>>>> +        status = "disabled";
>>>>> +    };
>>>>> +
>>>>> +    phy1: usb-phy@7d000000 {

>>>>      At the same address as the previous node?

>>> Yes. The first node is for the EHCI driver and the second for the PHY
>>> driver.
>>> There is some overlap in the exact registers used, so both drives map the
>>> whole USB controller block.

>>     That's really horrible design.

> Yup. Both USB PHY and EHCI controller registers really are interleaved
> in one range.

    But the standard EHCI register space has no holes IIRC, so they can't be 
really that much interleaved as you're describing (unless you have some 
non-standard registers of course)...
    We just had a case of misinterpreting the EHCI/PHY register spaces as 
interleaved (while in fact they weren't) on Renesas R-Car which I had to 
resolve for 3.11.

>>>>> +        compatible = "nvidia,tegra30-usb-phy";
>>>>> +        reg = <0x7d000000 0x4000 0x7d000000 0x4000>;

>>>>      Hm, there must be some mistake: two similar register ranges.

>>> The second range is used to configure the UTMI pad registers. All the
>>> UTMI pad
>>> registers are located in the first USB controller's range.

>>     Which second range? This is one and the same range.

> Some registers in the USB1 register range actually are "global" and
> relevant to all USB controllers. So:

> There are two 2-cell entries in that reg property. The first entry
> defines the registers for this USB PHY, and hence is unique for each USB
> PHY node. The second defines the registers for whichever USB PHY
> contains various shared registers across multiple PHYs, so is expected
> to be identical across all USB PHY DT nodes.

    Hm, couldn't you have those shared registers as a separate device?

> Yes, the HW design really is this screwy.

    Ugh...

>>     Don't they cause numerous resource conflicts while device nodes being
>> instantiated as the platform devices?

> No; the driver knows that the HW is screwy and there's lots of
> register-range sharing going on, so it simply maps the registers, rather
> than reserving the physical address range and mapping it.

    Yes, it's clear that the driver should take special measures, I was asking 
about the platform device creation phase. What do you see in /proc/iomem?

WBR, Sergei

