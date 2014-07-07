Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaGGUhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 16:37:20 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:63515 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaGGUhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 16:37:18 -0400
MIME-Version: 1.0
In-Reply-To: <lpetuq$bt8$1@ger.gmane.org>
References: <lpeofi$1fl$1@ger.gmane.org>
	<20140707191430.GA23004@roeck-us.net>
	<lpeseg$lip$1@ger.gmane.org>
	<20140707194223.GA29819@roeck-us.net>
	<lpetuq$bt8$1@ger.gmane.org>
Date: Mon, 7 Jul 2014 22:37:16 +0200
X-Google-Sender-Auth: rt3uDJXRuWl7MyyhIJYZX1ni48s
Message-ID: <CAMuHMdUaStRcef0X9MQy6kYOAhOX=D7CZNCnr_o4kL7FeeTrrw@mail.gmail.com>
Subject: Re: 3.15.4 runs *significantly* slower than 3.15.3 on iMX233 CPU
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2014 at 9:55 PM, Manuel Reimer
<Manuel.Spam@nurfuerspam.de> wrote:
> On 07/07/2014 09:42 PM, Guenter Roeck wrote:
>>>
>>> I tracked the problem down to the following patch:
>>>
>>>
>>> diff --git a/arch/arm/boot/dts/imx23-olinuxino.dts
>>> b/arch/arm/boot/dts/imx23-olinuxino.dts
>>> index d107c4a..993da2e 100644
>>> --- a/arch/arm/boot/dts/imx23-olinuxino.dts
>>> +++ b/arch/arm/boot/dts/imx23-olinuxino.dts
>>> @@ -64,7 +64,14 @@
>>>                                 compatible = "fsl,imx23-spi";
>>>                                 pinctrl-names = "default";
>>>                                 pinctrl-0 = <&spi2_pins_a>;
>>> +                               clock-frequency = <1000000>;
>>
>>
>> If I understand the code correctly, that means you reduce the access speed
>> for SPI flashes from 160 MHz down to 1 MHz.
>>
>> If so, and if your system loads anything from a SPI flash, I would not be
>> too
>> surprised that your system is now a bit on the slow side.
>
>
> The iMX233 has two separate SPI connections. The first one is used to
> connect to the SD card where the system boots from and the second one is the
> one I plan to use. The idea was to only set clock frequency for the SPI bus,
> I want to use to connect to external devices. The "SD SPI" has to run with
> "full speed". So where is the mistake...

drivers/spi/spi-mxs.c:mxs_spi_probe()

        ret = of_property_read_u32(np, "clock-frequency",
                                   &clk_freq);
        if (ret)
                clk_freq = clk_freq_default;

        ...

        ret = clk_prepare_enable(ssp->clk);

Any chance the clocks are shared, so this changes the rate for the
shared clock, affecting both SPI connections?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
