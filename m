Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751042Ab3HSQXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:23:30 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:3597 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab3HSQX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:23:27 -0400
Message-ID: <52124692.4080905@atmel.com>
Date: Mon, 19 Aug 2013 18:23:46 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: boris brezillon <b.brezillon@overkiz.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91/dt: split sam9x5 peripheral definitions
References: <1375870466-1093-1-git-send-email-b.brezillon@overkiz.com> <20130808140722.GA18627@ns203013.ovh.net> <5203B7DA.8030706@overkiz.com>
In-Reply-To: <5203B7DA.8030706@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 17:23, boris brezillon :
> Hello Jean-Christophe,
>
> On 08/08/2013 16:07, Jean-Christophe PLAGNIOL-VILLARD wrote:
>> On 12:14 Wed 07 Aug     , Boris BREZILLON wrote:
>>> This patch splits the sam9x5 peripheral definitions into:
>>> - a common base for all sam9x5 SoCs (at91sam9x5.dtsi)
>>> - several optional peripheral definitions which will be included by specific
>>>     sam9x5 SoCs (at91sam9x5_'periph name'.dtsi)
>>>
>>> This provides a better representation of the real hardware (drop unneeded
>>> dt nodes) and avoids future peripheral id conflict (lcdc and isi both use
>>> peripheral id 25).
>> I really don't like this
>>
>> the mapping is soc specific (here familly) so I does not see any advantage
>> except move files so NO for me
> Let me explain in detail why I did that.
>
> This separation was part of the "at91 common clk" series and was here to
> avoid the
> definition of unavailable clocks or definition of clocks with the same
> id (which may result
> in bad clk registration).
> If we keep all the definitions in one .dtsi file (even the one which are
> not really available),
> I may need to add a new property to each peripheral (and system) clk
> node to specify the
> availabilty of the clock (something similar to 'status="disabled"' in
> device nodes).

This is indeed a pretty good argument.
I do think that we have to ask Mike Turquette to see if he already has 
encountered such a case.

I must say that I was not in favor for this split because of readability 
and dts/dtsi file organization (you know, the usual question: where the 
hell this peripheral property is finally setup?).

But, if we really have to implement a new kind of property to tell if a 
clock is actually present or not, I am in favor for reconsidering this 
solution as it seems quite simple and self-explanatory...

> As explained to Thomas, I thought device tree was here to give a real
> description of the
> hardware parts (in case of sam9x5.dtsi the description of the common
> parts of sam9x5 SoC
> family).
> If you define peripherals that are not present in a SoC (lets say macb0
> for sam9g15) you break
> this rule.

Well, on the other hand, the status says "disabled", so we can imagine 
that it has been disabled, from its birth, in hardware...

> I'm not telling I have the right approach here, I'm just trying to
> understand what should be done and
> what should not.
>
> Finally, I'd like to point that the memory footprint of the dtb file
> generated after this patch has been
> applied is bit smaller (even if it won't make a real difference):
>
> with this patch:
>
> 15937 arch/arm/boot/dts/at91-ariag25.dtb
> 15860 arch/arm/boot/dts/at91sam9g15ek.dtb
> 16905 arch/arm/boot/dts/at91sam9g25ek.dtb
> 16473 arch/arm/boot/dts/at91sam9g35ek.dtb
> 17341 arch/arm/boot/dts/at91sam9x25ek.dtb
> 16473 arch/arm/boot/dts/at91sam9x35ek.dtb
>
> without this patch:
>
> 16077 arch/arm/boot/dts/at91-ariag25.dtb
> 16824 arch/arm/boot/dts/at91sam9g15ek.dtb
> 16849 arch/arm/boot/dts/at91sam9g25ek.dtb
> 16849 arch/arm/boot/dts/at91sam9g35ek.dtb
> 15017 arch/arm/boot/dts/at91sam9m10g45ek.dtb
> 17145 arch/arm/boot/dts/at91sam9x25ek.dtb
> 16849 arch/arm/boot/dts/at91sam9x35ek.dtb

okay, but difference in size are not impressive. But it is true that:
- it can grow a little if we switch LCD to full DT
- each bit saved can have an influence on boot time
but it will not be a decisive factor.


>> Best Regards,
>> J.
>>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>>> ---
>>>    arch/arm/boot/dts/at91sam9g25.dtsi       |    2 +
>>>    arch/arm/boot/dts/at91sam9g35.dtsi       |    1 +
>>>    arch/arm/boot/dts/at91sam9x25.dtsi       |   24 ++---------
>>>    arch/arm/boot/dts/at91sam9x35.dtsi       |    1 +
>>>    arch/arm/boot/dts/at91sam9x5.dtsi        |   67 ------------------------------
>>>    arch/arm/boot/dts/at91sam9x5_macb0.dtsi  |   56 +++++++++++++++++++++++++
>>>    arch/arm/boot/dts/at91sam9x5_macb1.dtsi  |   44 ++++++++++++++++++++
>>>    arch/arm/boot/dts/at91sam9x5_usart3.dtsi |   51 +++++++++++++++++++++++
>>>    8 files changed, 158 insertions(+), 88 deletions(-)
>>>    create mode 100644 arch/arm/boot/dts/at91sam9x5_macb0.dtsi
>>>    create mode 100644 arch/arm/boot/dts/at91sam9x5_macb1.dtsi
>>>    create mode 100644 arch/arm/boot/dts/at91sam9x5_usart3.dtsi
>>>
>>> diff --git a/arch/arm/boot/dts/at91sam9g25.dtsi b/arch/arm/boot/dts/at91sam9g25.dtsi
>>> index b4ec6fe..17b8799 100644
>>> --- a/arch/arm/boot/dts/at91sam9g25.dtsi
>>> +++ b/arch/arm/boot/dts/at91sam9g25.dtsi
>>> @@ -7,6 +7,8 @@
>>>     */
>>>
>>>    #include "at91sam9x5.dtsi"
>>> +#include "at91sam9x5_usart3.dtsi"
>>> +#include "at91sam9x5_macb0.dtsi"
>>>
>>>    / {
>>>    	model = "Atmel AT91SAM9G25 SoC";
>>> diff --git a/arch/arm/boot/dts/at91sam9g35.dtsi b/arch/arm/boot/dts/at91sam9g35.dtsi
>>> index bebf9f5..e35c2fc 100644
>>> --- a/arch/arm/boot/dts/at91sam9g35.dtsi
>>> +++ b/arch/arm/boot/dts/at91sam9g35.dtsi
>>> @@ -7,6 +7,7 @@
>>>     */
>>>
>>>    #include "at91sam9x5.dtsi"
>>> +#include "at91sam9x5_macb0.dtsi"
>>>
>>>    / {
>>>    	model = "Atmel AT91SAM9G35 SoC";
>>> diff --git a/arch/arm/boot/dts/at91sam9x25.dtsi b/arch/arm/boot/dts/at91sam9x25.dtsi
>>> index 49e94ab..c255421 100644
>>> --- a/arch/arm/boot/dts/at91sam9x25.dtsi
>>> +++ b/arch/arm/boot/dts/at91sam9x25.dtsi
>>> @@ -7,6 +7,9 @@
>>>     */
>>>
>>>    #include "at91sam9x5.dtsi"
>>> +#include "at91sam9x5_usart3.dtsi"
>>> +#include "at91sam9x5_macb0.dtsi"
>>> +#include "at91sam9x5_macb1.dtsi"
>>>
>>>    / {
>>>    	model = "Atmel AT91SAM9X25 SoC";
>>> @@ -22,27 +25,6 @@
>>>    				       0x80000000 0xfffd0000 0xb83fffff  /* pioC */
>>>    				       0x003fffff 0x003f8000 0x00000000  /* pioD */
>>>    				      >;
>>> -
>>> -				macb1 {
>>> -					pinctrl_macb1_rmii: macb1_rmii-0 {
>>> -						atmel,pins =
>>> -							<AT91_PIOC 16 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC16 periph B */
>>> -							 AT91_PIOC 18 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC18 periph B */
>>> -							 AT91_PIOC 19 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC19 periph B */
>>> -							 AT91_PIOC 20 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC20 periph B */
>>> -							 AT91_PIOC 21 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC21 periph B */
>>> -							 AT91_PIOC 27 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC27 periph B */
>>> -							 AT91_PIOC 28 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC28 periph B */
>>> -							 AT91_PIOC 29 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC29 periph B */
>>> -							 AT91_PIOC 30 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC30 periph B */
>>> -							 AT91_PIOC 31 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PC31 periph B */
>>> -					};
>>> -				};
>>> -			};
>>> -
>>> -			macb1: ethernet@f8030000 {
>>> -				pinctrl-names = "default";
>>> -				pinctrl-0 = <&pinctrl_macb1_rmii>;
>>>    			};
>>>    		};
>>>    	};
>>> diff --git a/arch/arm/boot/dts/at91sam9x35.dtsi b/arch/arm/boot/dts/at91sam9x35.dtsi
>>> index 1a3d525..8eac66c 100644
>>> --- a/arch/arm/boot/dts/at91sam9x35.dtsi
>>> +++ b/arch/arm/boot/dts/at91sam9x35.dtsi
>>> @@ -7,6 +7,7 @@
>>>     */
>>>
>>>    #include "at91sam9x5.dtsi"
>>> +#include "at91sam9x5_macb0.dtsi"
>>>
>>>    / {
>>>    	model = "Atmel AT91SAM9X35 SoC";
>>> diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
>>> index 57d45f5..05f4c74 100644
>>> --- a/arch/arm/boot/dts/at91sam9x5.dtsi
>>> +++ b/arch/arm/boot/dts/at91sam9x5.dtsi
>>> @@ -206,29 +206,6 @@
>>>    					};
>>>    				};
>>>
>>> -				usart3 {
>>> -					pinctrl_usart3: usart3-0 {
>>> -						atmel,pins =
>>> -							<AT91_PIOC 22 AT91_PERIPH_B AT91_PINCTRL_PULL_UP	/* PC22 periph B with pullup */
>>> -							 AT91_PIOC 23 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PC23 periph B */
>>> -					};
>>> -
>>> -					pinctrl_usart3_rts: usart3_rts-0 {
>>> -						atmel,pins =
>>> -							<AT91_PIOC 24 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PC24 periph B */
>>> -					};
>>> -
>>> -					pinctrl_usart3_cts: usart3_cts-0 {
>>> -						atmel,pins =
>>> -							<AT91_PIOC 25 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PC25 periph B */
>>> -					};
>>> -
>>> -					pinctrl_usart3_sck: usart3_sck-0 {
>>> -						atmel,pins =
>>> -							<AT91_PIOC 26 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PC26 periph B */
>>> -					};
>>> -				};
>>> -
>>>    				uart0 {
>>>    					pinctrl_uart0: uart0-0 {
>>>    						atmel,pins =
>>> @@ -277,34 +254,6 @@
>>>    					};
>>>    				};
>>>
>>> -				macb0 {
>>> -					pinctrl_macb0_rmii: macb0_rmii-0 {
>>> -						atmel,pins =
>>> -							<AT91_PIOB 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB0 periph A */
>>> -							 AT91_PIOB 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB1 periph A */
>>> -							 AT91_PIOB 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB2 periph A */
>>> -							 AT91_PIOB 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB3 periph A */
>>> -							 AT91_PIOB 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB4 periph A */
>>> -							 AT91_PIOB 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB5 periph A */
>>> -							 AT91_PIOB 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB6 periph A */
>>> -							 AT91_PIOB 7 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB7 periph A */
>>> -							 AT91_PIOB 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB9 periph A */
>>> -							 AT91_PIOB 10 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PB10 periph A */
>>> -					};
>>> -
>>> -					pinctrl_macb0_rmii_mii: macb0_rmii_mii-0 {
>>> -						atmel,pins =
>>> -							<AT91_PIOB 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB8 periph A */
>>> -							 AT91_PIOB 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB11 periph A */
>>> -							 AT91_PIOB 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB12 periph A */
>>> -							 AT91_PIOB 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB13 periph A */
>>> -							 AT91_PIOB 14 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB14 periph A */
>>> -							 AT91_PIOB 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB15 periph A */
>>> -							 AT91_PIOB 16 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB16 periph A */
>>> -							 AT91_PIOB 17 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PB17 periph A */
>>> -					};
>>> -				};
>>> -
>>>    				mmc0 {
>>>    					pinctrl_mmc0_slot0_clk_cmd_dat0: mmc0_slot0_clk_cmd_dat0-0 {
>>>    						atmel,pins =
>>> @@ -605,22 +554,6 @@
>>>    				status = "disabled";
>>>    			};
>>>
>>> -			macb0: ethernet@f802c000 {
>>> -				compatible = "cdns,at32ap7000-macb", "cdns,macb";
>>> -				reg = <0xf802c000 0x100>;
>>> -				interrupts = <24 IRQ_TYPE_LEVEL_HIGH 3>;
>>> -				pinctrl-names = "default";
>>> -				pinctrl-0 = <&pinctrl_macb0_rmii>;
>>> -				status = "disabled";
>>> -			};
>>> -
>>> -			macb1: ethernet@f8030000 {
>>> -				compatible = "cdns,at32ap7000-macb", "cdns,macb";
>>> -				reg = <0xf8030000 0x100>;
>>> -				interrupts = <27 IRQ_TYPE_LEVEL_HIGH 3>;
>>> -				status = "disabled";
>>> -			};
>>> -
>>>    			i2c0: i2c@f8010000 {
>>>    				compatible = "atmel,at91sam9x5-i2c";
>>>    				reg = <0xf8010000 0x100>;
>>> diff --git a/arch/arm/boot/dts/at91sam9x5_macb0.dtsi b/arch/arm/boot/dts/at91sam9x5_macb0.dtsi
>>> new file mode 100644
>>> index 0000000..55731ff
>>> --- /dev/null
>>> +++ b/arch/arm/boot/dts/at91sam9x5_macb0.dtsi
>>> @@ -0,0 +1,56 @@
>>> +/*
>>> + * at91sam9x5_macb0.dtsi - Device Tree Include file for AT91SAM9x5 SoC with 1
>>> + * Ethernet interface.
>>> + *
>>> + * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
>>> + *
>>> + * Licensed under GPLv2.
>>> + */
>>> +
>>> +#include <dt-bindings/pinctrl/at91.h>
>>> +#include <dt-bindings/interrupt-controller/irq.h>
>>> +
>>> +/ {
>>> +	ahb {
>>> +		apb {
>>> +			pinctrl@fffff400 {
>>> +				macb0 {
>>> +					pinctrl_macb0_rmii: macb0_rmii-0 {
>>> +						atmel,pins =
>>> +							<AT91_PIOB 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB0 periph A */
>>> +							 AT91_PIOB 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB1 periph A */
>>> +							 AT91_PIOB 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB2 periph A */
>>> +							 AT91_PIOB 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB3 periph A */
>>> +							 AT91_PIOB 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB4 periph A */
>>> +							 AT91_PIOB 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB5 periph A */
>>> +							 AT91_PIOB 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB6 periph A */
>>> +							 AT91_PIOB 7 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB7 periph A */
>>> +							 AT91_PIOB 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB9 periph A */
>>> +							 AT91_PIOB 10 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PB10 periph A */
>>> +					};
>>> +
>>> +					pinctrl_macb0_rmii_mii: macb0_rmii_mii-0 {
>>> +						atmel,pins =
>>> +							<AT91_PIOB 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB8 periph A */
>>> +							 AT91_PIOB 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB11 periph A */
>>> +							 AT91_PIOB 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB12 periph A */
>>> +							 AT91_PIOB 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB13 periph A */
>>> +							 AT91_PIOB 14 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB14 periph A */
>>> +							 AT91_PIOB 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB15 periph A */
>>> +							 AT91_PIOB 16 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB16 periph A */
>>> +							 AT91_PIOB 17 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PB17 periph A */
>>> +					};
>>> +				};
>>> +			};
>>> +
>>> +			macb0: ethernet@f802c000 {
>>> +				compatible = "cdns,at32ap7000-macb", "cdns,macb";
>>> +				reg = <0xf802c000 0x100>;
>>> +				interrupts = <24 IRQ_TYPE_LEVEL_HIGH 3>;
>>> +				pinctrl-names = "default";
>>> +				pinctrl-0 = <&pinctrl_macb0_rmii>;
>>> +				status = "disabled";
>>> +			};
>>> +		};
>>> +	};
>>> +};
>>> diff --git a/arch/arm/boot/dts/at91sam9x5_macb1.dtsi b/arch/arm/boot/dts/at91sam9x5_macb1.dtsi
>>> new file mode 100644
>>> index 0000000..77425a6
>>> --- /dev/null
>>> +++ b/arch/arm/boot/dts/at91sam9x5_macb1.dtsi
>>> @@ -0,0 +1,44 @@
>>> +/*
>>> + * at91sam9x5_macb1.dtsi - Device Tree Include file for AT91SAM9x5 SoC with 2
>>> + * Ethernet interfaces.
>>> + *
>>> + * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
>>> + *
>>> + * Licensed under GPLv2.
>>> + */
>>> +
>>> +#include <dt-bindings/pinctrl/at91.h>
>>> +#include <dt-bindings/interrupt-controller/irq.h>
>>> +
>>> +/ {
>>> +	ahb {
>>> +		apb {
>>> +			pinctrl@fffff400 {
>>> +				macb1 {
>>> +					pinctrl_macb1_rmii: macb1_rmii-0 {
>>> +						atmel,pins =
>>> +							<AT91_PIOC 16 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC16 periph B */
>>> +							 AT91_PIOC 18 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC18 periph B */
>>> +							 AT91_PIOC 19 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC19 periph B */
>>> +							 AT91_PIOC 20 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC20 periph B */
>>> +							 AT91_PIOC 21 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC21 periph B */
>>> +							 AT91_PIOC 27 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC27 periph B */
>>> +							 AT91_PIOC 28 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC28 periph B */
>>> +							 AT91_PIOC 29 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC29 periph B */
>>> +							 AT91_PIOC 30 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC30 periph B */
>>> +							 AT91_PIOC 31 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PC31 periph B */
>>> +					};
>>> +				};
>>> +			};
>>> +
>>> +			macb1: ethernet@f8030000 {
>>> +				compatible = "cdns,at32ap7000-macb", "cdns,macb";
>>> +				reg = <0xf8030000 0x100>;
>>> +				interrupts = <27 IRQ_TYPE_LEVEL_HIGH 3>;
>>> +				pinctrl-names = "default";
>>> +				pinctrl-0 = <&pinctrl_macb1_rmii>;
>>> +				status = "disabled";
>>> +			};
>>> +		};
>>> +	};
>>> +};
>>> diff --git a/arch/arm/boot/dts/at91sam9x5_usart3.dtsi b/arch/arm/boot/dts/at91sam9x5_usart3.dtsi
>>> new file mode 100644
>>> index 0000000..5589579
>>> --- /dev/null
>>> +++ b/arch/arm/boot/dts/at91sam9x5_usart3.dtsi
>>> @@ -0,0 +1,51 @@
>>> +/*
>>> + * at91sam9x5_lcdc.dtsi - Device Tree Include file for AT91SAM9x5 SoC with
>>> + * 4 USART.
>>> + *
>>> + * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
>>> + *
>>> + * Licensed under GPLv2.
>>> + */
>>> +
>>> +#include <dt-bindings/pinctrl/at91.h>
>>> +#include <dt-bindings/interrupt-controller/irq.h>
>>> +
>>> +/ {
>>> +	ahb {
>>> +		apb {
>>> +			pinctrl@fffff400 {
>>> +				usart3 {
>>> +					pinctrl_usart3: usart3-0 {
>>> +						atmel,pins =
>>> +							<AT91_PIOC 22 AT91_PERIPH_B AT91_PINCTRL_PULL_UP	/* PC22 periph B with pullup */
>>> +							 AT91_PIOC 23 AT91_PERIPH_B AT91_PINCTRL_NONE>;		/* PC23 periph B */
>>> +					};
>>> +
>>> +					pinctrl_usart3_rts: usart3_rts-0 {
>>> +						atmel,pins =
>>> +							<AT91_PIOC 24 AT91_PERIPH_B AT91_PINCTRL_NONE>;		/* PC24 periph B */
>>> +					};
>>> +
>>> +					pinctrl_usart3_cts: usart3_cts-0 {
>>> +						atmel,pins =
>>> +							<AT91_PIOC 25 AT91_PERIPH_B AT91_PINCTRL_NONE>;		/* PC25 periph B */
>>> +					};
>>> +
>>> +					pinctrl_usart3_sck: usart3_sck-0 {
>>> +						atmel,pins =
>>> +							<AT91_PIOC 26 AT91_PERIPH_B AT91_PINCTRL_NONE>;		/* PC26 periph B */
>>> +					};
>>> +				};
>>> +			};
>>> +
>>> +			usart3: serial@f8028000 {
>>> +				compatible = "atmel,at91sam9260-usart";
>>> +				reg = <0xf8028000 0x200>;
>>> +				interrupts = <8 IRQ_TYPE_LEVEL_HIGH 5>;
>>> +				pinctrl-names = "default";
>>> +				pinctrl-0 = <&pinctrl_usart3>;
>>> +				status = "disabled";
>>> +			};
>>> +		};
>>> +	};
>>> +};
>>> --
>>> 1.7.9.5
>>>
>
>


-- 
Nicolas Ferre
