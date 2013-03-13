Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934253Ab3CMU2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 16:28:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56833 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933199Ab3CMU2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 16:28:35 -0400
Message-ID: <5140E16D.8060102@wwwdotorg.org>
Date: Wed, 13 Mar 2013 14:28:29 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ian Lartey <ian@slimlogic.co.uk>
CC: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-leds@vger.kernel.org,
        linux-watchdog@vger.kernel.org, grant.likely@secretlab.ca,
        broonie@opensource.wolfsonmicro.com, rob.herring@calxeda.com,
        rob@landley.net, mturquette@linaro.org, linus.walleij@linaro.org,
        cooloney@gmail.com, rpurdie@rpsys.net, sameo@linux.intel.com,
        wim@iguana.be, lgirdwood@gmail.com, gg@slimlogic.co.uk,
        j-keerthy@ti.com, ldewangan@nvidia.com, t-kristo@ti.com
Subject: Re: [PATCH v8 01/12] mfd: DT bindings for the palmas family MFD
References: <1362662276-20792-1-git-send-email-ian@slimlogic.co.uk>
In-Reply-To: <1362662276-20792-1-git-send-email-ian@slimlogic.co.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2013 06:17 AM, Ian Lartey wrote:
> From: Graeme Gregory <gg@slimlogic.co.uk>
> 
> Add the various binding files for the palmas family of chips. There is a
> top level MFD binding then a seperate binding for IP blocks on chips.

Sorry for the slow review. Thanks for the binding docs. I understand the
structure a bit better now.

> diff --git a/Documentation/devicetree/bindings/clock/palmas-clk.txt b/Documentation/devicetree/bindings/clock/palmas-clk.txt

> +* palmas and palmas-charger resource clock IP block devicetree bindings
> +
> +Required properties:
> +- compatible : Should be from the list
> +  ti,twl6035-clk
...
> +and also the generic series names
> +  ti,palmas-clk
> +  ti,palmas-charger-clk

(Most of these comments apply to all the binding files).

How do I know which one of those to pick; I guess you intend it to be
based on whether the top-level chip is a charger or not?

I don't see why the clock sub-module would care about that; isn't it
just an (the same) IP block that has been slapped inside some top-level
chip?

In other words, do we really need two separate compatible values here,
or should there just be a single generic "ti,palmas-clk"?

> +Optional properties:
> +- ti,clk32g-mode-sleep		- mode to adopt in pmic sleep 0 - off, 1 - on
> +- ti,clkg32kgaudio-mode-sleep	- see above

If this is a clock provider (i.e. the HW has clock output signals),
shouldn't it also have #clock-cells, and a description of the clock
specifier format?

If this is a clock consumer (i.e. the HW has clock input signals),
shouldn't it also have clocks/clock-names properties to describe what
the source of those clocks is?

Did you omit the reg property from this document just because it's so
standard you didn't think describing it was necessary? Certainly the
final DT file must have a reg property if the use of sub-nodes is to be
useful; the block could easily be instantiated at different addresses in
different top-level chips, so the base register address for this block
has to be defined in DT, I think.

> +Examples:
> +
> +clk {
> +    compatible = "ti,twl6035-clk", "ti,palmas-clk";
> +    ti,clk32kg-mode-sleep = <0>;
> +    ti,clk32kgaudio-mode-sleep = <0>;
> +};

It might be nice to show the sub-block examples within a parent
top-level Palmas node just to make it clear. But probably not a big deal.

> diff --git a/Documentation/devicetree/bindings/gpio/gpio-palmas.txt b/Documentation/devicetree/bindings/gpio/gpio-palmas.txt

This document needs to describe the #gpio-cells property, and the format
of the GPIO specifier.

Can the GPIOs be used for a purpose other than plain GPIO (i.e. dedicate
signals such as IRQ output?). If so, don't you need to describe that pin
setup here? Perhaps that'd be part of the top-level MFD node or a
separate pinctrl node though.

Can the GPIOs act as interrupt inputs i.e. generate interrupts on
change/level? In which case, the interrupt-controller and
#interrupt-cells properties must be present, and the format of the IRQ
specifier documented.

> diff --git a/Documentation/devicetree/bindings/input/palmas-pwrbutton.txt b/Documentation/devicetree/bindings/input/palmas-pwrbutton.txt
> new file mode 100644
> index 0000000..00739e9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/palmas-pwrbutton.txt
> @@ -0,0 +1,22 @@
> +* palmas and palmas-charger Button IP block devicetree bindings
> +
> +Required properties:
> +- compatible : Should be from the list
> +  ti,twl6035-pwrbutton
...
> +
> +Examples:

s/Examples/Example/. Same elsewhere.

> +pwrbutton {
> +    compatible = "ti,twl6035-pwrbutton", "ti,palmas-pwrbutton";
> +    interrupt-parent = <&palmas>;
> +    interrupts = <1 0>;
> +    interrupt-name = "pwron-irq";

Don't you need to describe the interrupt-related properties in the list
of required properties above? This is especially true since this example
implies that a particular interrupt-names (which incidentally should be
plural in the example above) value is required.

> diff --git a/Documentation/devicetree/bindings/leds/leds-palmas.txt b/Documentation/devicetree/bindings/leds/leds-palmas.txt

> +-ti,chrg-led-mode	- mode for led operation 0 - Charging indicator
> +				1 - controlled as a general purpose LED
> +-ti,chrg-led-vbat-low	- low battery blinking 0 - blinking is enabled,
> +				1 - blinking is disabled

Which LED(s) do those two properties apply to?

> diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt b/Documentation/devicetree/bindings/mfd/palmas.txt

> +- interrupt-controller : palmas has its own internal IRQs
> +- #interrupt-cells : should be set to 2 for IRQ number and flags

At least a mention of the valid IRQ flags (or pointer to another
document which defines this) should be included.

> +Optional properties:
> +  ti,mux_padX : set the pad register X (1-2) to the correct muxing for the hardware,
> +	        if not set will use muxing in OTP.

This doesn't really describe what value to put here. I assume it's the
raw value to write into the register?

Is there any need to expose a full pinctrl driver here, for dynamic pin
muxing?

Since this node is a bus which has child devices on it, you should
include either a ranges property (if the children fit directly into the
parent bus's address space), or more likely if the address space "starts
over" at this point, you need #address-cells and #size-cells to describe
the format of child nodes' reg properties.

> diff --git a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt

> +Optional properties:

"regulators" below isn't a property, it's a node.

> +- regulators : should contain the constrains and init information for the
> +	       regulators. It should contain a subnode per regulator from the
> +	       list.
> +	       For palmas - smps12, smps123, smps3 depending on OTP,
> +	       smps45, smps457, smps7 depending on varient, smps6, smps[8-10],
> +	       ldo[1-9], ldoln, ldousb
> +	       For palmas-charger - smps12, smps123, smps3 depending on OTP,
> +	       smps[6-9], boost, ldo[1-14], ldoln, ldousb

Rather than "For palmas" and "For palmas-charger", shouldn't that say
"For ti,palmas-pmic" and "For ti,palmas-charger-pmic", since the
internals of this node should be entirely self-contained and defined by
this one binding, rather than being influenced by the top-level chip
that contains this block.
