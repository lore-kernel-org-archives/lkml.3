Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbaDVVbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:31:49 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:44381 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaDVVbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:31:42 -0400
MIME-Version: 1.0
In-Reply-To: <8344066.GP0Bf5lvlE@wuerfel>
References: <cover.1397552154.git.anders.berg@lsi.com>
	<02c006a6fc64131df82981abbc1c71c7af52254e.1397552154.git.anders.berg@lsi.com>
	<8344066.GP0Bf5lvlE@wuerfel>
Date: Tue, 22 Apr 2014 23:31:41 +0200
Message-ID: <CACRpkdapwscc9tA830nJVHMsh4-sEVuv5GUvCEL5e1YH+b0Wvw@mail.gmail.com>
Subject: Re: [PATCH 2/5] ARM: dts: Device tree for AXM55xx.
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Anders Berg <anders.berg@lsi.com>, Olof Johansson <olof@lixom.net>,
        Mike Turquette <mturquette@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 2:45 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 15 April 2014 14:06:11 Anders Berg wrote:

>> +                     serial0: uart@2010080000 {
>> +                             compatible = "arm,pl011", "arm,primecell";
>> +                             reg = <0x20 0x10080000 0 0x1000>;
>> +                             interrupts = <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>;
>> +                             clocks = <&clk_per>, <&clk_per>;
>> +                             clock-names = "uartclk", "apb_pclk";
>> +                             status = "disabled";
>> +                     };
>
> "uartclk" is not a valid string for pl011, as per binding:
>
> | - clocks:  When present, must refer to exactly one clock named
> |           "apb_pclk"
>
> I do see that a lot of platforms do the same thing you have here, not
> sure who is wrong.

OK the PL011 is tricksier. It has two clocks, the APB clock driving
the logic and another clock input that is divided down to generate
the external data clock (baud rate).

The bus will do:
pcdev->pclk = clk_get(&pcdev->dev, "apb_pclk");

The driver will do:
uap->clk = devm_clk_get(&dev->dev, NULL);

So the driver relies on the anonymous clock being "first"
in a clock retrieveal operation, and it's a bit fragile indeed.
That leads to that either you give this clock a sensible
name or you list the empty string, as you have to have
clock-names there to name the last entry so the bus can
retrieve it.

This clock is *indeed* named "UARTCLK" (capital letters)
in the TRM for PL011. So I think this is perfectly reasonable.

The situation is the same as with the PL022 SPI driver we have
discussed before, it also retrieves the anonymous clock but we
consistently named it "SSPCLK" in commits:
dfc9832ca3f7a10d573e29e46d6ba03a54fbe580
80fbe30f63c9ba2ab62eb2c1f7ef607ce0721a95

As everyone else was using that. And it was the name from
the TRM.

Yours,
Linus Walleij
