Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760683Ab3B0Scu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 13:32:50 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:57295 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760251Ab3B0Scs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 13:32:48 -0500
Message-ID: <512E5144.9020105@wwwdotorg.org>
Date: Wed, 27 Feb 2013 11:32:36 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: J Keerthy <j-keerthy@ti.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, b-cousson@ti.com, gg@slimlogic.co.uk
Subject: Re: [PATCH 1/4] documentation: add palmas dts definition
References: <1361164283-3133-1-git-send-email-j-keerthy@ti.com>
In-Reply-To: <1361164283-3133-1-git-send-email-j-keerthy@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2013 10:11 PM, J Keerthy wrote:
> Add the DTS definition for the palmas device including the MFD children.
...
> diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt b/Documentation/devicetree/bindings/mfd/palmas.txt
...
> +Texas Instruments Palmas family
> +
> +The Palmas familly are Integrated Power Management Chips.
> +These chips are connected to an i2c bus.

s/familly/family.

> +
> +Required properties:
> +- compatible : Must be "ti,palmas";

Do you need a version number there; will there be Palmas v1 HW, then
later Palmas v2 HW, and so on?

> +  For Integrated power-management in the palmas series, twl6035, twl6037,
> +  tps65913

If this binding represents multiple different chips, compatible should
contain both the most chip-specific value (e.g. ti,twl6035 I guess given
the above) /and/ the more generic "ti,palmas" value. This will allow any
device-specific quirks to be implemented if needed in the future,
without having to retrofit the device-specific compatible value into
.dts files after the fact.

> +- interrupts : This i2c device has an IRQ line connected to the main SoC
> +- interrupt-controller : Since the palmas support several interrupts internally,
> +  it is considered as an interrupt controller cascaded to the SoC one.
> +- #interrupt-cells = <1>;

Why not 2; can't any IRQ flags be represented in DT? 1 seems limiting
here unless the HW truly can't support configuration of IRQ input
polarity of edge-vs-level sensitivity.

> +- interrupt-parent : The parent interrupt controller.
> +
> +Optional node:
> +- Child nodes contain in the palmas. The palmas family is made of several
> +  variants that support a different number of features.
> +  The child nodes will thus depend of the capability of the variant.

Are there DT bindings for those child nodes anywhere?

Representing each internal component as a separate DT node feels a
little like designing the DT bindings to model the Linux-internal MFD
structure. DT bindings should be driven by the HW design and OS-agnostic.

>From a DT perspective, is there any need at all to create a separate DT
node for each component? This would only be needed or useful if the
child IP blocks (and hence DT bindings for those blocks) could be
re-used in other top-level devices that aren't represented by this
top-level ti,palmas DT binding. Are the HW IP blocks here re-used
anywhere, or will they be?

...
> +Example:
> +/*
> + * Integrated Power Management Chip Palmas
> + */
> +palmas@48 {

There's a considerable mix of TAB and space indentation in this example.

> +    compatible = "ti,palmas";
> +    reg = <0x48>;
> +    interrupts = <39>; /* IRQ_SYS_1N cascaded to gic */

If that's routed to a regular ARM GIC, then I think you need extra cells
there; #interrupt-cells=<3> for the ARM GIC.

> +    interrupt-controller;
> +    #interrupt-cells = <1>;
> +    interrupt-parent = <&gic>;
> +    #address-cells = <1>;
> +    #size-cells = <0>;
> +
> +	ti,mux-pad1 = <0x00>;
> +	ti,mux-pad2 = <0x00>;
> +	ti,power-ctrl = <0x03>;
> +
> +	palmas_pmic {

Just "pmic" seems simpler, although I dare say the node name isn't
really used for anything.

> +		compatible = "ti,palmas_pmic";

Using _ in compatible values isn't common. "ti,palmas-pmic" instead?

> +		regulators {
> +			smps12_reg: smps12 {

As I mentioned elsewhere, this binding (or a separate binding doc for
"ti,palmas_pmic") should contain a list of valid values for these node
names.

> +				regulator-min-microvolt = < 600000>;
> +                regulator-max-microvolt = <1500000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +                ti,warm-sleep = <0>;
> +                ti,roof-floor = <0>;
> +                ti,mode-sleep = <0>;
> +                ti,warm-reset = <0>;
> +                ti,tstep = <0>;
> +                ti,vsel = <0>;
> +			};
> +		};
> +		ti,ldo6-vibrator = <0>;
> +	};
> +
> +    palmas_rtc {
> +        compatible = "ti,palmas_rtc";
> +        interrupts = <8 9>;

Are the interrupt outputs of the RTC fed directly to the GIC interrupt
mentioned in the top-level Palmas node, or do these interrupts feed into
a top-level IRQ controller in the Palmas device, which then feeds into
the external IRQ controller?

If these feed into an on-chip IRQ controller, then you'd need an
interrupt-parent property here to indicate that.

If these feed directly into an external IRQ controller, it's almost
certain that IRQ controller's binding uses #interrupt-cells = <3> it
is's the ARM GIC, and hence you need some extra cells here.

> +        reg = <0>;
> +    };
> +};

