Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab3HTGRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:17:13 -0400
Received: from 2.mo6.mail-out.ovh.net ([46.105.76.65]:49800 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751926Ab3HTGRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:17:12 -0400
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Aug 2013 02:17:11 EDT
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Tue, 20 Aug 2013 08:00:32 +0200
From: <b.brezillon@overkiz.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
X-Ovh-Mailout: 178.32.228.6 (mo6.mail-out.ovh.net)
Subject: Re: [PATCH] ARM: at91/dt: split sam9x5 peripheral definitions
In-Reply-To: <20130819223714.4443.95698@quantum>
References: <1375870466-1093-1-git-send-email-b.brezillon@overkiz.com>
 <20130808140722.GA18627@ns203013.ovh.net> <5203B7DA.8030706@overkiz.com>
 <52124692.4080905@atmel.com> <20130819223714.4443.95698@quantum>
Message-ID: <b43a43a80c69ec0f51dc7ae37f0d6b50@localhost>
User-Agent: RoundCube Webmail/0.4
X-Ovh-Tracer-Id: 432627039616530460
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrfeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mike,

On Mon, 19 Aug 2013 15:37:14 -0700, Mike Turquette
<mturquette@linaro.org> wrote:
> Quoting Nicolas Ferre (2013-08-19 09:23:46)
>> On 08/08/2013 17:23, boris brezillon :
>> > Hello Jean-Christophe,
>> >
>> > On 08/08/2013 16:07, Jean-Christophe PLAGNIOL-VILLARD wrote:
>> >> On 12:14 Wed 07 Aug     , Boris BREZILLON wrote:
>> >>> This patch splits the sam9x5 peripheral definitions into:
>> >>> - a common base for all sam9x5 SoCs (at91sam9x5.dtsi)
>> >>> - several optional peripheral definitions which will be included by specific
>> >>>     sam9x5 SoCs (at91sam9x5_'periph name'.dtsi)
>> >>>
>> >>> This provides a better representation of the real hardware (drop unneeded
>> >>> dt nodes) and avoids future peripheral id conflict (lcdc and isi both use
>> >>> peripheral id 25).
>> >> I really don't like this
>> >>
>> >> the mapping is soc specific (here familly) so I does not see any advantage
>> >> except move files so NO for me
>> > Let me explain in detail why I did that.
>> >
>> > This separation was part of the "at91 common clk" series and was here to
>> > avoid the
>> > definition of unavailable clocks or definition of clocks with the same
>> > id (which may result
>> > in bad clk registration).
>> > If we keep all the definitions in one .dtsi file (even the one which are
>> > not really available),
>> > I may need to add a new property to each peripheral (and system) clk
>> > node to specify the
>> > availabilty of the clock (something similar to 'status="disabled"' in
>> > device nodes).
>>
>> This is indeed a pretty good argument.
>> I do think that we have to ask Mike Turquette to see if he already has
>> encountered such a case.
> 
> It is correct to place chip-specific clocks into a chip-specific dts.
> Having clocks marked as "disabled" in a big dtsi is not the right way to
> go.
> 

I agree. As I said earlier, I think unavailable peripherals (and
associated clocks)
should not be part of the dts definition because it may lead to
misinterpretation of
the real hardware parts.
There is a difference between unused IP block (defined with
status="disabled") because
external I/Os are not connected on a specific board and unavailable IP
block (IP block
not available on a given SoC).

This beeing said, I understand the readability concern, and I won't
force this split if
we find a way to declare a clk as "unavailable" or "disabled"  

> Regarding naming conflicts, is your issue with string name collisions
> during calls to __clk_lookup?
> 

No, there is no collision in clk names, because each optional clock has
a unique name.
But there may be conflicts on clk ids (peripheral ids):

LCDC (LCD Controller) and ISI (Image Sensor Interface) peripherals have
the same id (25)
in sam9x5 SoC family but are never both available in a given SoC.

If you declare LCDC clk before ISI clock, the former will always be
returned when you
reference the ISI clk in ISI peripheral node (clocks=<&periph 25>).

This will work, as the method for enabling/disabling periph clk are the
same for all clks.
But when you print the clk tree (using debugfs) you will see lcdc_clk
with prepare/enable
count incremented and isi_clk always unused, even if the SoC does not
have an LCDC block.

Moreover, isi_clk will be allocated for nothing, because it cannot be
retrieved.

And what happens if an unavailable clock is referenced (I did not test
that, but I guess
the is_enabled callback will always return false)?
This case should not happen if the dts is correctly defined, but still,
I think unavailable
clocks should not be registered in the clk framework.

Please, feel free to share your thoughts.

Best Regards,

Boris

> Thanks,
> Mike
> 
>>
>> I must say that I was not in favor for this split because of readability
>> and dts/dtsi file organization (you know, the usual question: where the
>> hell this peripheral property is finally setup?).
>>
>> But, if we really have to implement a new kind of property to tell if a
>> clock is actually present or not, I am in favor for reconsidering this
>> solution as it seems quite simple and self-explanatory...
>>
>> > As explained to Thomas, I thought device tree was here to give a real
>> > description of the
>> > hardware parts (in case of sam9x5.dtsi the description of the common
>> > parts of sam9x5 SoC
>> > family).
>> > If you define peripherals that are not present in a SoC (lets say macb0
>> > for sam9g15) you break
>> > this rule.
>>
>> Well, on the other hand, the status says "disabled", so we can imagine
>> that it has been disabled, from its birth, in hardware...
>>
>> > I'm not telling I have the right approach here, I'm just trying to
>> > understand what should be done and
>> > what should not.
>> >
>> > Finally, I'd like to point that the memory footprint of the dtb file
>> > generated after this patch has been
>> > applied is bit smaller (even if it won't make a real difference):
>> >
>> > with this patch:
>> >
>> > 15937 arch/arm/boot/dts/at91-ariag25.dtb
>> > 15860 arch/arm/boot/dts/at91sam9g15ek.dtb
>> > 16905 arch/arm/boot/dts/at91sam9g25ek.dtb
>> > 16473 arch/arm/boot/dts/at91sam9g35ek.dtb
>> > 17341 arch/arm/boot/dts/at91sam9x25ek.dtb
>> > 16473 arch/arm/boot/dts/at91sam9x35ek.dtb
>> >
>> > without this patch:
>> >
>> > 16077 arch/arm/boot/dts/at91-ariag25.dtb
>> > 16824 arch/arm/boot/dts/at91sam9g15ek.dtb
>> > 16849 arch/arm/boot/dts/at91sam9g25ek.dtb
>> > 16849 arch/arm/boot/dts/at91sam9g35ek.dtb
>> > 15017 arch/arm/boot/dts/at91sam9m10g45ek.dtb
>> > 17145 arch/arm/boot/dts/at91sam9x25ek.dtb
>> > 16849 arch/arm/boot/dts/at91sam9x35ek.dtb
>>
>> okay, but difference in size are not impressive. But it is true that:
>> - it can grow a little if we switch LCD to full DT
>> - each bit saved can have an influence on boot time
>> but it will not be a decisive factor.
>>
>>
>> >> Best Regards,
>> >> J.
>> >>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> >>> ---
>> >>>    arch/arm/boot/dts/at91sam9g25.dtsi       |    2 +
>> >>>    arch/arm/boot/dts/at91sam9g35.dtsi       |    1 +
>> >>>    arch/arm/boot/dts/at91sam9x25.dtsi       |   24 ++---------
>> >>>    arch/arm/boot/dts/at91sam9x35.dtsi       |    1 +
>> >>>    arch/arm/boot/dts/at91sam9x5.dtsi        |   67 ------------------------------
>> >>>    arch/arm/boot/dts/at91sam9x5_macb0.dtsi  |   56 +++++++++++++++++++++++++
>> >>>    arch/arm/boot/dts/at91sam9x5_macb1.dtsi  |   44 ++++++++++++++++++++
>> >>>    arch/arm/boot/dts/at91sam9x5_usart3.dtsi |   51 +++++++++++++++++++++++
>> >>>    8 files changed, 158 insertions(+), 88 deletions(-)
>> >>>    create mode 100644 arch/arm/boot/dts/at91sam9x5_macb0.dtsi
>> >>>    create mode 100644 arch/arm/boot/dts/at91sam9x5_macb1.dtsi
>> >>>    create mode 100644 arch/arm/boot/dts/at91sam9x5_usart3.dtsi
>> >>>
>> >>> diff --git a/arch/arm/boot/dts/at91sam9g25.dtsi b/arch/arm/boot/dts/at91sam9g25.dtsi
>> >>> index b4ec6fe..17b8799 100644
>> >>> --- a/arch/arm/boot/dts/at91sam9g25.dtsi
>> >>> +++ b/arch/arm/boot/dts/at91sam9g25.dtsi
>> >>> @@ -7,6 +7,8 @@
>> >>>     */
>> >>>
>> >>>    #include "at91sam9x5.dtsi"
>> >>> +#include "at91sam9x5_usart3.dtsi"
>> >>> +#include "at91sam9x5_macb0.dtsi"
>> >>>
>> >>>    / {
>> >>>     model = "Atmel AT91SAM9G25 SoC";
>> >>> diff --git a/arch/arm/boot/dts/at91sam9g35.dtsi b/arch/arm/boot/dts/at91sam9g35.dtsi
>> >>> index bebf9f5..e35c2fc 100644
>> >>> --- a/arch/arm/boot/dts/at91sam9g35.dtsi
>> >>> +++ b/arch/arm/boot/dts/at91sam9g35.dtsi
>> >>> @@ -7,6 +7,7 @@
>> >>>     */
>> >>>
>> >>>    #include "at91sam9x5.dtsi"
>> >>> +#include "at91sam9x5_macb0.dtsi"
>> >>>
>> >>>    / {
>> >>>     model = "Atmel AT91SAM9G35 SoC";
>> >>> diff --git a/arch/arm/boot/dts/at91sam9x25.dtsi b/arch/arm/boot/dts/at91sam9x25.dtsi
>> >>> index 49e94ab..c255421 100644
>> >>> --- a/arch/arm/boot/dts/at91sam9x25.dtsi
>> >>> +++ b/arch/arm/boot/dts/at91sam9x25.dtsi
>> >>> @@ -7,6 +7,9 @@
>> >>>     */
>> >>>
>> >>>    #include "at91sam9x5.dtsi"
>> >>> +#include "at91sam9x5_usart3.dtsi"
>> >>> +#include "at91sam9x5_macb0.dtsi"
>> >>> +#include "at91sam9x5_macb1.dtsi"
>> >>>
>> >>>    / {
>> >>>     model = "Atmel AT91SAM9X25 SoC";
>> >>> @@ -22,27 +25,6 @@
>> >>>                                    0x80000000 0xfffd0000 0xb83fffff  /* pioC */
>> >>>                                    0x003fffff 0x003f8000 0x00000000  /* pioD */
>> >>>                                   >;
>> >>> -
>> >>> -                           macb1 {
>> >>> -                                   pinctrl_macb1_rmii: macb1_rmii-0 {
>> >>> -                                           atmel,pins =
>> >>> -                                                   <AT91_PIOC 16 AT91_PERIPH_B AT91_PINCTRL_NONE   /* PC16 periph B */
>> >>> -                                                    AT91_PIOC 18 AT91_PERIPH_B AT91_PINCTRL_NONE   /* PC18 periph B */
>> >>> -                                                    AT91_PIOC 19 AT91_PERIPH_B AT91_PINCTRL_NONE   /* PC19 periph B */
>> >>> -                                                    AT91_PIOC 20 AT91_PERIPH_B AT91_PINCTRL_NONE   /* PC20 periph B */
>> >>> -                                                    AT91_PIOC 21 AT91_PERIPH_B AT91_PINCTRL_NONE   /* PC21 periph B */
>> >>> -                                                    AT91_PIOC 27 AT91_PERIPH_B AT91_PINCTRL_NONE   /* PC27 periph B */
>> >>> -                                                    AT91_PIOC 28 AT91_PERIPH_B AT91_PINCTRL_NONE   /* PC28 periph B */
>> >>> -                                                    AT91_PIOC 29 AT91_PERIPH_B AT91_PINCTRL_NONE   /* PC29 periph B */
>> >>> -                                                    AT91_PIOC 30 AT91_PERIPH_B AT91_PINCTRL_NONE   /* PC30 periph B */
>> >>> -                                                    AT91_PIOC 31 AT91_PERIPH_B AT91_PINCTRL_NONE>; /* PC31 periph B */
>> >>> -                                   };
>> >>> -                           };
>> >>> -                   };
>> >>> -
>> >>> -                   macb1: ethernet@f8030000 {
>> >>> -                           pinctrl-names = "default";
>> >>> -                           pinctrl-0 = <&pinctrl_macb1_rmii>;
>> >>>                     };
>> >>>             };
>> >>>     };
>> >>> diff --git a/arch/arm/boot/dts/at91sam9x35.dtsi b/arch/arm/boot/dts/at91sam9x35.dtsi
>> >>> index 1a3d525..8eac66c 100644
>> >>> --- a/arch/arm/boot/dts/at91sam9x35.dtsi
>> >>> +++ b/arch/arm/boot/dts/at91sam9x35.dtsi
>> >>> @@ -7,6 +7,7 @@
>> >>>     */
>> >>>
>> >>>    #include "at91sam9x5.dtsi"
>> >>> +#include "at91sam9x5_macb0.dtsi"
>> >>>
>> >>>    / {
>> >>>     model = "Atmel AT91SAM9X35 SoC";
>> >>> diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
>> >>> index 57d45f5..05f4c74 100644
>> >>> --- a/arch/arm/boot/dts/at91sam9x5.dtsi
>> >>> +++ b/arch/arm/boot/dts/at91sam9x5.dtsi
>> >>> @@ -206,29 +206,6 @@
>> >>>                                     };
>> >>>                             };
>> >>>
>> >>> -                           usart3 {
>> >>> -                                   pinctrl_usart3: usart3-0 {
>> >>> -                                           atmel,pins =
>> >>> -                                                   <AT91_PIOC 22 AT91_PERIPH_B AT91_PINCTRL_PULL_UP        /* PC22 periph B with pullup */
>> >>> -                                                    AT91_PIOC 23 AT91_PERIPH_B AT91_PINCTRL_NONE>; /* PC23 periph B */
>> >>> -                                   };
>> >>> -
>> >>> -                                   pinctrl_usart3_rts: usart3_rts-0 {
>> >>> -                                           atmel,pins =
>> >>> -                                                   <AT91_PIOC 24 AT91_PERIPH_B AT91_PINCTRL_NONE>; /* PC24 periph B */
>> >>> -                                   };
>> >>> -
>> >>> -                                   pinctrl_usart3_cts: usart3_cts-0 {
>> >>> -                                           atmel,pins =
>> >>> -                                                   <AT91_PIOC 25 AT91_PERIPH_B AT91_PINCTRL_NONE>; /* PC25 periph B */
>> >>> -                                   };
>> >>> -
>> >>> -                                   pinctrl_usart3_sck: usart3_sck-0 {
>> >>> -                                           atmel,pins =
>> >>> -                                                   <AT91_PIOC 26 AT91_PERIPH_B AT91_PINCTRL_NONE>; /* PC26 periph B */
>> >>> -                                   };
>> >>> -                           };
>> >>> -
>> >>>                             uart0 {
>> >>>                                     pinctrl_uart0: uart0-0 {
>> >>>                                             atmel,pins =
>> >>> @@ -277,34 +254,6 @@
>> >>>                                     };
>> >>>                             };
>> >>>
>> >>> -                           macb0 {
>> >>> -                                   pinctrl_macb0_rmii: macb0_rmii-0 {
>> >>> -                                           atmel,pins =
>> >>> -                                                   <AT91_PIOB 0 AT91_PERIPH_A AT91_PINCTRL_NONE    /* PB0 periph A */
>> >>> -                                                    AT91_PIOB 1 AT91_PERIPH_A AT91_PINCTRL_NONE    /* PB1 periph A */
>> >>> -                                                    AT91_PIOB 2 AT91_PERIPH_A AT91_PINCTRL_NONE    /* PB2 periph A */
>> >>> -                                                    AT91_PIOB 3 AT91_PERIPH_A AT91_PINCTRL_NONE    /* PB3 periph A */
>> >>> -                                                    AT91_PIOB 4 AT91_PERIPH_A AT91_PINCTRL_NONE    /* PB4 periph A */
>> >>> -                                                    AT91_PIOB 5 AT91_PERIPH_A AT91_PINCTRL_NONE    /* PB5 periph A */
>> >>> -                                                    AT91_PIOB 6 AT91_PERIPH_A AT91_PINCTRL_NONE    /* PB6 periph A */
>> >>> -                                                    AT91_PIOB 7 AT91_PERIPH_A AT91_PINCTRL_NONE    /* PB7 periph A */
>> >>> -                                                    AT91_PIOB 9 AT91_PERIPH_A AT91_PINCTRL_NONE    /* PB9 periph A */
>> >>> -                                                    AT91_PIOB 10 AT91_PERIPH_A AT91_PINCTRL_NONE>; /* PB10 periph A */
>> >>> -                                   };
>> >>> -
>> >>> -                                   pinctrl_macb0_rmii_mii: macb0_rmii_mii-0 {
>> >>> -                                           atmel,pins =
>> >>> -                                                   <AT91_PIOB 8 AT91_PERIPH_A AT91_PINCTRL_NONE    /* PB8 periph A */
>> >>> -                                                    AT91_PIOB 11 AT91_PERIPH_A AT91_PINCTRL_NONE   /* PB11 periph A */
>> >>> -                                                    AT91_PIOB 12 AT91_PERIPH_A AT91_PINCTRL_NONE   /* PB12 periph A */
>> >>> -                                                    AT91_PIOB 13 AT91_PERIPH_A AT91_PINCTRL_NONE   /* PB13 periph A */
>> >>> -                                                    AT91_PIOB 14 AT91_PERIPH_A AT91_PINCTRL_NONE   /* PB14 periph A */
>> >>> -                                                    AT91_PIOB 15 AT91_PERIPH_A AT91_PINCTRL_NONE   /* PB15 periph A */
>> >>> -                                                    AT91_PIOB 16 AT91_PERIPH_A AT91_PINCTRL_NONE   /* PB16 periph A */
>> >>> -                                                    AT91_PIOB 17 AT91_PERIPH_A AT91_PINCTRL_NONE>; /* PB17 periph A */
>> >>> -                                   };
>> >>> -                           };
>> >>> -
>> >>>                             mmc0 {
>> >>>                                     pinctrl_mmc0_slot0_clk_cmd_dat0: mmc0_slot0_clk_cmd_dat0-0 {
>> >>>                                             atmel,pins =
>> >>> @@ -605,22 +554,6 @@
>> >>>                             status = "disabled";
>> >>>                     };
>> >>>
>> >>> -                   macb0: ethernet@f802c000 {
>> >>> -                           compatible = "cdns,at32ap7000-macb", "cdns,macb";
>> >>> -                           reg = <0xf802c000 0x100>;
>> >>> -                           interrupts = <24 IRQ_TYPE_LEVEL_HIGH 3>;
>> >>> -                           pinctrl-names = "default";
>> >>> -                           pinctrl-0 = <&pinctrl_macb0_rmii>;
>> >>> -                           status = "disabled";
>> >>> -                   };
>> >>> -
>> >>> -                   macb1: ethernet@f8030000 {
>> >>> -                           compatible = "cdns,at32ap7000-macb", "cdns,macb";
>> >>> -                           reg = <0xf8030000 0x100>;
>> >>> -                           interrupts = <27 IRQ_TYPE_LEVEL_HIGH 3>;
>> >>> -                           status = "disabled";
>> >>> -                   };
>> >>> -
>> >>>                     i2c0: i2c@f8010000 {
>> >>>                             compatible = "atmel,at91sam9x5-i2c";
>> >>>                             reg = <0xf8010000 0x100>;
>> >>> diff --git a/arch/arm/boot/dts/at91sam9x5_macb0.dtsi b/arch/arm/boot/dts/at91sam9x5_macb0.dtsi
>> >>> new file mode 100644
>> >>> index 0000000..55731ff
>> >>> --- /dev/null
>> >>> +++ b/arch/arm/boot/dts/at91sam9x5_macb0.dtsi
>> >>> @@ -0,0 +1,56 @@
>> >>> +/*
>> >>> + * at91sam9x5_macb0.dtsi - Device Tree Include file for AT91SAM9x5 SoC with 1
>> >>> + * Ethernet interface.
>> >>> + *
>> >>> + * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
>> >>> + *
>> >>> + * Licensed under GPLv2.
>> >>> + */
>> >>> +
>> >>> +#include <dt-bindings/pinctrl/at91.h>
>> >>> +#include <dt-bindings/interrupt-controller/irq.h>
>> >>> +
>> >>> +/ {
>> >>> +   ahb {
>> >>> +           apb {
>> >>> +                   pinctrl@fffff400 {
>> >>> +                           macb0 {
>> >>> +                                   pinctrl_macb0_rmii: macb0_rmii-0 {
>> >>> +                                           atmel,pins =
>> >>> +                                                   <AT91_PIOB 0 AT91_PERIPH_A AT91_PINCTRL_NONE    /* PB0 periph A */
>> >>> +                                                    AT91_PIOB 1 AT91_PERIPH_A AT91_PINCTRL_NONE    /* PB1 periph A */
>> >>> +                                                    AT91_PIOB 2 AT91_PERIPH_A AT91_PINCTRL_NONE    /* PB2 periph A */
>> >>> +                                                    AT91_PIOB 3 AT91_PERIPH_A AT91_PINCTRL_NONE    /* PB3 periph A */
>> >>> +                                                    AT91_PIOB 4 AT91_PERIPH_A AT91_PINCTRL_NONE    /* PB4 periph A */
>> >>> +                                                    AT91_PIOB 5 AT91_PERIPH_A AT91_PINCTRL_NONE    /* PB5 periph A */
>> >>> +                                                    AT91_PIOB 6 AT91_PERIPH_A AT91_PINCTRL_NONE    /* PB6 periph A */
>> >>> +                                                    AT91_PIOB 7 AT91_PERIPH_A AT91_PINCTRL_NONE    /* PB7 periph A */
>> >>> +                                                    AT91_PIOB 9 AT91_PERIPH_A AT91_PINCTRL_NONE    /* PB9 periph A */
>> >>> +                                                    AT91_PIOB 10 AT91_PERIPH_A AT91_PINCTRL_NONE>; /* PB10 periph A */
>> >>> +                                   };
>> >>> +
>> >>> +                                   pinctrl_macb0_rmii_mii: macb0_rmii_mii-0 {
>> >>> +                                           atmel,pins =
>> >>> +                                                   <AT91_PIOB 8 AT91_PERIPH_A AT91_PINCTRL_NONE    /* PB8 periph A */
>> >>> +                                                    AT91_PIOB 11 AT91_PERIPH_A AT91_PINCTRL_NONE   /* PB11 periph A */
>> >>> +                                                    AT91_PIOB 12 AT91_PERIPH_A AT91_PINCTRL_NONE   /* PB12 periph A */
>> >>> +                                                    AT91_PIOB 13 AT91_PERIPH_A AT91_PINCTRL_NONE   /* PB13 periph A */
>> >>> +                                                    AT91_PIOB 14 AT91_PERIPH_A AT91_PINCTRL_NONE   /* PB14 periph A */
>> >>> +                                                    AT91_PIOB 15 AT91_PERIPH_A AT91_PINCTRL_NONE   /* PB15 periph A */
>> >>> +                                                    AT91_PIOB 16 AT91_PERIPH_A AT91_PINCTRL_NONE   /* PB16 periph A */
>> >>> +                                                    AT91_PIOB 17 AT91_PERIPH_A AT91_PINCTRL_NONE>; /* PB17 periph A */
>> >>> +                                   };
>> >>> +                           };
>> >>> +                   };
>> >>> +
>> >>> +                   macb0: ethernet@f802c000 {
>> >>> +                           compatible = "cdns,at32ap7000-macb", "cdns,macb";
>> >>> +                           reg = <0xf802c000 0x100>;
>> >>> +                           interrupts = <24 IRQ_TYPE_LEVEL_HIGH 3>;
>> >>> +                           pinctrl-names = "default";
>> >>> +                           pinctrl-0 = <&pinctrl_macb0_rmii>;
>> >>> +                           status = "disabled";
>> >>> +                   };
>> >>> +           };
>> >>> +   };
>> >>> +};
>> >>> diff --git a/arch/arm/boot/dts/at91sam9x5_macb1.dtsi b/arch/arm/boot/dts/at91sam9x5_macb1.dtsi
>> >>> new file mode 100644
>> >>> index 0000000..77425a6
>> >>> --- /dev/null
>> >>> +++ b/arch/arm/boot/dts/at91sam9x5_macb1.dtsi
>> >>> @@ -0,0 +1,44 @@
>> >>> +/*
>> >>> + * at91sam9x5_macb1.dtsi - Device Tree Include file for AT91SAM9x5 SoC with 2
>> >>> + * Ethernet interfaces.
>> >>> + *
>> >>> + * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
>> >>> + *
>> >>> + * Licensed under GPLv2.
>> >>> + */
>> >>> +
>> >>> +#include <dt-bindings/pinctrl/at91.h>
>> >>> +#include <dt-bindings/interrupt-controller/irq.h>
>> >>> +
>> >>> +/ {
>> >>> +   ahb {
>> >>> +           apb {
>> >>> +                   pinctrl@fffff400 {
>> >>> +                           macb1 {
>> >>> +                                   pinctrl_macb1_rmii: macb1_rmii-0 {
>> >>> +                                           atmel,pins =
>> >>> +                                                   <AT91_PIOC 16 AT91_PERIPH_B AT91_PINCTRL_NONE   /* PC16 periph B */
>> >>> +                                                    AT91_PIOC 18 AT91_PERIPH_B AT91_PINCTRL_NONE   /* PC18 periph B */
>> >>> +                                                    AT91_PIOC 19 AT91_PERIPH_B AT91_PINCTRL_NONE   /* PC19 periph B */
>> >>> +                                                    AT91_PIOC 20 AT91_PERIPH_B AT91_PINCTRL_NONE   /* PC20 periph B */
>> >>> +                                                    AT91_PIOC 21 AT91_PERIPH_B AT91_PINCTRL_NONE   /* PC21 periph B */
>> >>> +                                                    AT91_PIOC 27 AT91_PERIPH_B AT91_PINCTRL_NONE   /* PC27 periph B */
>> >>> +                                                    AT91_PIOC 28 AT91_PERIPH_B AT91_PINCTRL_NONE   /* PC28 periph B */
>> >>> +                                                    AT91_PIOC 29 AT91_PERIPH_B AT91_PINCTRL_NONE   /* PC29 periph B */
>> >>> +                                                    AT91_PIOC 30 AT91_PERIPH_B AT91_PINCTRL_NONE   /* PC30 periph B */
>> >>> +                                                    AT91_PIOC 31 AT91_PERIPH_B AT91_PINCTRL_NONE>; /* PC31 periph B */
>> >>> +                                   };
>> >>> +                           };
>> >>> +                   };
>> >>> +
>> >>> +                   macb1: ethernet@f8030000 {
>> >>> +                           compatible = "cdns,at32ap7000-macb", "cdns,macb";
>> >>> +                           reg = <0xf8030000 0x100>;
>> >>> +                           interrupts = <27 IRQ_TYPE_LEVEL_HIGH 3>;
>> >>> +                           pinctrl-names = "default";
>> >>> +                           pinctrl-0 = <&pinctrl_macb1_rmii>;
>> >>> +                           status = "disabled";
>> >>> +                   };
>> >>> +           };
>> >>> +   };
>> >>> +};
>> >>> diff --git a/arch/arm/boot/dts/at91sam9x5_usart3.dtsi b/arch/arm/boot/dts/at91sam9x5_usart3.dtsi
>> >>> new file mode 100644
>> >>> index 0000000..5589579
>> >>> --- /dev/null
>> >>> +++ b/arch/arm/boot/dts/at91sam9x5_usart3.dtsi
>> >>> @@ -0,0 +1,51 @@
>> >>> +/*
>> >>> + * at91sam9x5_lcdc.dtsi - Device Tree Include file for AT91SAM9x5 SoC with
>> >>> + * 4 USART.
>> >>> + *
>> >>> + * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
>> >>> + *
>> >>> + * Licensed under GPLv2.
>> >>> + */
>> >>> +
>> >>> +#include <dt-bindings/pinctrl/at91.h>
>> >>> +#include <dt-bindings/interrupt-controller/irq.h>
>> >>> +
>> >>> +/ {
>> >>> +   ahb {
>> >>> +           apb {
>> >>> +                   pinctrl@fffff400 {
>> >>> +                           usart3 {
>> >>> +                                   pinctrl_usart3: usart3-0 {
>> >>> +                                           atmel,pins =
>> >>> +                                                   <AT91_PIOC 22 AT91_PERIPH_B AT91_PINCTRL_PULL_UP        /* PC22 periph B with pullup */
>> >>> +                                                    AT91_PIOC 23 AT91_PERIPH_B AT91_PINCTRL_NONE>;         /* PC23 periph B */
>> >>> +                                   };
>> >>> +
>> >>> +                                   pinctrl_usart3_rts: usart3_rts-0 {
>> >>> +                                           atmel,pins =
>> >>> +                                                   <AT91_PIOC 24 AT91_PERIPH_B AT91_PINCTRL_NONE>;         /* PC24 periph B */
>> >>> +                                   };
>> >>> +
>> >>> +                                   pinctrl_usart3_cts: usart3_cts-0 {
>> >>> +                                           atmel,pins =
>> >>> +                                                   <AT91_PIOC 25 AT91_PERIPH_B AT91_PINCTRL_NONE>;         /* PC25 periph B */
>> >>> +                                   };
>> >>> +
>> >>> +                                   pinctrl_usart3_sck: usart3_sck-0 {
>> >>> +                                           atmel,pins =
>> >>> +                                                   <AT91_PIOC 26 AT91_PERIPH_B AT91_PINCTRL_NONE>;         /* PC26 periph B */
>> >>> +                                   };
>> >>> +                           };
>> >>> +                   };
>> >>> +
>> >>> +                   usart3: serial@f8028000 {
>> >>> +                           compatible = "atmel,at91sam9260-usart";
>> >>> +                           reg = <0xf8028000 0x200>;
>> >>> +                           interrupts = <8 IRQ_TYPE_LEVEL_HIGH 5>;
>> >>> +                           pinctrl-names = "default";
>> >>> +                           pinctrl-0 = <&pinctrl_usart3>;
>> >>> +                           status = "disabled";
>> >>> +                   };
>> >>> +           };
>> >>> +   };
>> >>> +};
>> >>> --
>> >>> 1.7.9.5
>> >>>
>> >
>> >
>>
>>
>> --
>> Nicolas Ferre

