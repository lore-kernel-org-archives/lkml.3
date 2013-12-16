Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab3LPXxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 18:53:31 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:59810 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab3LPXx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 18:53:29 -0500
MIME-Version: 1.0
In-Reply-To: <CACmBeS1H96Scr+ycHa-Ar_t72Q2x=LH-2vrbQXiLiuYHyH3S-Q@mail.gmail.com>
References: <1386945188-8316-1-git-send-email-jonas.jensen@gmail.com>
	<1386945188-8316-3-git-send-email-jonas.jensen@gmail.com>
	<CAEgOgz7=xZ8N+vGuaQ6L3n5SYpS3bS+xN88WXDH+A7m7JNLrcw@mail.gmail.com>
	<CACmBeS1H96Scr+ycHa-Ar_t72Q2x=LH-2vrbQXiLiuYHyH3S-Q@mail.gmail.com>
Date: Tue, 17 Dec 2013 09:53:27 +1000
X-Google-Sender-Auth: mBNPsUWw_EKc2F5Y_avx7k_2CLE
Message-ID: <CAEgOgz6qz8ES_rQX8+UE-Ukh=G=_kHnAWJLQ-sUm6vkz=Xa7pg@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] ARM: mach-moxart: add MOXA ART SoC device tree files
From: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        devicetree@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 6:05 AM, Jonas Jensen <jonas.jensen@gmail.com> wrote:
> On 15 December 2013 05:27, Peter Crosthwaite
> <peter.crosthwaite@xilinx.com> wrote:
>>> +       sdhci: sdhci@98e00000 {
>>> +               compatible = "moxa,moxart-sdhci";
>>> +               reg = <0x98e00000 0x5C>;
>>> +               interrupts = <5 0>;
>>> +               clocks = <&clk_apb>;
>>> +               dmas =  <&dma 5>,
>>> +                       <&dma 5>;
>>> +               dma-names = "tx", "rx";
>>> +       };
>>
>> Is your SDHCI really implemented on the board level? The fact that its
>> reg property is within the same as the SoC range (for your dtsi)
>> suggests the SDHCI is part of the SoC and should perhaps be in the
>> dtsi?
>
>>> +       mac1: mac@92000000 {
>>> +               compatible = "moxa,moxart-mac";
>>> +               reg = <0x92000000 0x90>;
>>> +               interrupts = <27 0>;
>>> +               phy-handle = <&ethphy1>;
>>> +               phy-mode = "mii";
>>> +       };
>>
>> Same for MACs.
>
>>> +
>>> +       uart0: uart@98200000 {
>>> +               compatible = "ns16550a";
>>> +               reg = <0x98200000 0x20>;
>>> +               interrupts = <31 8>;
>>> +               reg-shift = <2>;
>>> +               reg-io-width = <4>;
>>> +               clock-frequency = <14745600>;
>>> +               status = "okay";
>>> +       };
>>> +
>>
>> And UARTs.
>>
>> Let me know if i'm misunderstanding dts/dtsi split but looking at some
>> of the other SoCs this seems inconsistent to me.
>
>
> It is likely to be true, that technically these are all part of the
> SoC. By examining the hardware, there are no external chips (on either
> base or main board) that looks capable of handling such functions:
>
> https://plus.google.com/photos/103371465418643926605/albums/5820634595801767953
>
> I made the split with some consideration to other MOXA ART machines,
> that they can be added as a separate file including the same dtsi:
>
> MOXA ART hardware examples:
>
> UC-7112/UC-7110: "SD slot (UC-7112, and UC-7112 Plus only)":
> http://www.moxa.com/product/UC-7112_UC-7110.htm
>
> IA241: "64 MB RAM":
> http://www.moxa.com/product/IA241_IA240.htm
>
> UC-7101-LX: "One 10/100 Mbps Ethernet port":
> http://www.moxa.com/product/UC-7101-LX.htm
>
>
> UC-7112-LX has 32 MB RAM and two ethernet ports. This is why I think
> MAC is good as is, RAM should move out from SoC?
>
> I don't know if they all have a debug UART (I only have access to
> UC-7112-LX), and it's not obvious in specifications. UART can possibly
> be moved into SoC as you say.
>

I think its going to all be in the SoC. Having it board level would
mean you have a system bus as copper which is not very SoC like (at
least for UART anyway).

> In cases where SD slot is missing but the register remains in the SoC,
> how is that normally handled?
>

Soren Brinkmann's recent addition of ethernet to the Zynq SoC
illustrates the concept for a MAC. The two MACs are added to the
shared dtsi but disabled. The board level dts then enables it for the
one which is board populated:

https://lkml.org/lkml/2013/12/11/434

I think its generally applicable to your SD MAC and UART cases. The
tegra20 dtsi illustrates the status = "disabled" concept specifically
for SDHCI.

Regards,
Peter

>
> Regards,
> Jonas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
