Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964881AbaDIQOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:14:48 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33705 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933342AbaDIQOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:14:42 -0400
Message-ID: <534571F0.10706@free-electrons.com>
Date: Wed, 09 Apr 2014 18:14:40 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Chen-Yu Tsai <wens@csie.org>
CC: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 00/15] ARM: sunxi: add A31 PL pins support
References: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com> <CAGb2v66XCN2ar1wj+a1+ZwdcdJ3gzJ+nDiO9bu52OwK+mBB_Hg@mail.gmail.com>
In-Reply-To: <CAGb2v66XCN2ar1wj+a1+ZwdcdJ3gzJ+nDiO9bu52OwK+mBB_Hg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/04/2014 16:53, Chen-Yu Tsai wrote:
> Hi Boris,
>
> On Wed, Apr 9, 2014 at 9:51 PM, Boris BREZILLON
> <boris.brezillon@free-electrons.com> wrote:
>> Hello,
>>
>> This series rework the sunxi pinctrl driver to support the PLx pins
>> available on the A31 SoC.
> Thanks for working on this. I mentioned to Maxime on IRC yesterday that
> we have complete pinctrl drivers for both A31 and A23, based on our current
> pinctrl-sunxi driver, in the A23 SDK. These have the complete pin mapping.

Thanks for pointing this out, I'll take a look.

>
>> It also add missing A31 reset controller DT bindings documentation.
>>
>> I need those PL pins (actually I only need PL0 and PL1) to support
>> the P2WI bus, which in turn is used to communicate with the AXP221
>> PMIC.
> If you could, please add all the PL and PM pins.

Sure, I'll add pin macros for L and M ports.

> As I said, you can find complete definitions in the A23 SDK.
>
>> Let me know if these changes are too intrusive.
> I wonder if we should do a separate driver for the new PIO controller.
> Clearly it's a separate IP block, with it's own clock and reset controls.

This is what I had in mind in the first place, but then I encountered
several issues when doing so:

 1) the gpio chip is not dynamically allocated but is declared as a
static variable instead
 2) we have to tweak the pinctrl base field, otherwise the pin numbers
overlap
 3) other things I haven't noticed yet :-)

I'll try to rework the driver to be able to declare 2 separated pin
controllers.

> Allwinner sources list this block as "R_PIO". I suggest using this name.
> Clearly "pioL" does not cover all the functionality.

Fair enough. I'll modify it.

>
> I have started to document the PRCM block: http://linux-sunxi.org/PRCM
>
> Last, please send the patches to the linux-sunxi mailing list as well.
> At the very least, Hans will see them and add them to sunxi-devel branch.

Sure, this is an oversight, I'm using get_maintainer and just forgot to
add Hans and the linux-sunxi ML. But I'll take care to add you, hans and
the sunxi ML in Cc next time.

Thanks for your review.

Best Regards,

Boris

>
>
> Cheers,
> ChenYu
>
>> Best Regards,
>>
>> Boris
>>
>> Boris BREZILLON (15):
>>   ARM: sunxi: dt: list all pinctrl compatible strings
>>   ARM: sunxi: dt: document pinctrl clock related properties
>>   ARM: sunxi: dt: add pinctrl clock-names properties
>>   pinctrl: sunxi: specify clk name when retrieving pinctrl pio clk
>>   clk: sunxi: add A31 APB0 clk gate defintions
>>   clk: sunxi: add A31 APB0 gates compatible string to the documentation
>>   ARM: sunxi: dt: define A31's APB0 clk gates node
>>   reset: sunxi: document sunxi's reset controllers bindings
>>   clk: sunxi: add A31 APB0 reset line defintions
>>   pinctrl: sunxi: add PL pin definitions
>>   pinctrl: sunxi: add support for A31 PL pins
>>   pinctrl: sunxi: retrieve and enable PL clk gate for A31 SoC
>>   pinctrl: sunxi: retrieve and enable PL reset line for A31 SoC
>>   pinctrl: sunxi: define A31 PL0/PL1 pins
>>   ARM: sunxi: dt: add support for A31's PL pins
>>
>>  Documentation/devicetree/bindings/clock/sunxi.txt  |   1 +
>>  .../bindings/pinctrl/allwinner,sunxi-pinctrl.txt   |  13 +-
>>  .../bindings/reset/allwinner,sunxi-clock-reset.txt |  21 +++
>>  arch/arm/boot/dts/sun4i-a10.dtsi                   |   1 +
>>  arch/arm/boot/dts/sun5i-a10s.dtsi                  |   1 +
>>  arch/arm/boot/dts/sun5i-a13.dtsi                   |   1 +
>>  arch/arm/boot/dts/sun6i-a31.dtsi                   |  25 ++-
>>  arch/arm/boot/dts/sun7i-a20.dtsi                   |   1 +
>>  drivers/clk/sunxi/clk-sunxi.c                      |   5 +
>>  drivers/pinctrl/pinctrl-sunxi-pins.h               |   8 +
>>  drivers/pinctrl/pinctrl-sunxi.c                    | 205 +++++++++++++++------
>>  drivers/pinctrl/pinctrl-sunxi.h                    |  39 +++-
>>  12 files changed, 264 insertions(+), 57 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/reset/allwinner,sunxi-clock-reset.txt
>>
>> --
>> 1.8.3.2
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

