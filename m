Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab3IWQxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 12:53:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39444 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab3IWQxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 12:53:22 -0400
Message-ID: <524071FD.5060505@wwwdotorg.org>
Date: Mon, 23 Sep 2013 10:53:17 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: lee.jones@linaro.org, sameo@linux.intel.com, broonie@kernel.org,
        linus.walleij@linaro.org, akpm@linux-foundation.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        rtc-linux@googlegroups.com, rob.herring@calxeda.com,
        mark.rutland@arm.com, pawel.moll@arm.com, rob@landley.net,
        ijc+devicetree@hellion.org.uk, grant.likely@linaro.org,
        florian.lobmaier@ams.com
Subject: Re: [PATCH 2/4] gpio: add support for AMS AS3722 gpio driver
References: <1379400338-20704-1-git-send-email-ldewangan@nvidia.com> <1379400338-20704-3-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1379400338-20704-3-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2013 12:45 AM, Laxman Dewangan wrote:
> The AS3722 is a compact system PMU suitable for Mobile Phones, Tablet etc.
> 
> Add a driver to support accessing the 8 GPIOs found on the AMS AS3722
> PMIC using gpiolib.

> diff --git a/Documentation/devicetree/bindings/gpio/gpio-as3722.txt b/Documentation/devicetree/bindings/gpio/gpio-as3722.txt

> +AMS AS3722 GPIO bindings.
> +This describe the properties of the gpio sub-node of the AMS AS3722 device tree.

Oh, I see that you document each of the PMIC's sub-nodes separately.
That's something you should explicitly mention in the top-level PMIC
binding document. You should probably also mention the filenames of the
binding documents for the child nodes.

> +Required properties:
> +--------------------
> +- compatible: Must be "ams,as3722-gpio".
> +- #address-cells: Number of address of the sub node of this node. Must be 1.

This isn't the number of addresses in the child node, but rather the
number of cells in an (a single) address.

> +- #size-cells: Size of addess cells. Must be 1.

Similarly, this is the number of cells in a size specifier, nothing to
do with address, and not the size of a cell.

You should put the GPIO properties (gpio-controller, perhaps
interrupt-controller?) here instead of at the top level, since this HW
block is what implements the GPIO controller, and perhaps a
GPIO-interrupt controller.

> +Sub node:
> +--------
> +The sub nodes provides the configuration of each gpio pins. The properties of the
> +nodes are as follows:
> +Required subnode properties:

You need a blank line there.

> +---------------------------
> +reg: The GPIO number on which the properties need to be applied.
> +
> +Optional subnode properties:
> +---------------------------
> +bias-pull-up: The Pull-up for the pin to be enable.
> +bias-pull-down: Pull down of the pins to be enable.
> +bias-high-impedance: High impedance of the pin to be enable.
> +open-drain: Pin is Open drain type.
> +function: IO functionality of the pins. The valid options are:
> +	gpio, intrrupt-output, vsup-vbat-low-undeb, interrupt-input,

intrrupt? undeb?

> +	pwm-input, voltage-stby, oc-powergood-sd0, powergood-output,

stby might be better written out in full as standby.

> +	clk32k-output, watchdog-input, soft-reset-input, pwm-output,
> +	vsup-vbat-low-deb, oc-powergood-sd6

deb?

> +    Missing the function property will set the pin in GPIO mode.
> +
> +ams,enable-gpio-invert: Enable invert of the signal on GPIO pin.

This looks very much like pinctrl. If there's a real need to be as
verbose as pinctrl, perhaps this binding should actually be a full
pinctrl binding? If not, perhaps you can just use the raw HW register
values (with appropriate #defines to simplify setting up the
properties). Something like:

pin-configuration = <0xf7348 0x5783 0x92348 ...>;

or:

pin-configruation = <
    AMS3722_PULL_UP | AMS_GPIO_INVERT ...,
    ...
    >;

