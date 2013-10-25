Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab3JYWvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 18:51:38 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63419 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab3JYWvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 18:51:11 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH V5 REPOST] mfd: add support for ams AS3722 PMIC
To: Laxman Dewangan <ldewangan@nvidia.com>, lee.jones@linaro.org
Cc: sameo@linux.intel.com, broonie@kernel.org, linus.walleij@linaro.org,
        akpm@linux-foundation.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, rtc-linux@googlegroups.com,
        rob.herring@calxeda.com, mark.rutland@arm.com, pawel.moll@arm.com,
        swarren@wwwdotorg.org, rob@landley.net, ijc+devicetree@hellion.org.uk,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Florian Lobmaier <florian.lobmaier@ams.com>
In-Reply-To: <1382427526-2390-1-git-send-email-ldewangan@nvidia.com>
References: <1382427526-2390-1-git-send-email-ldewangan@nvidia.com>
Date: Fri, 25 Oct 2013 21:07:54 +0100
Message-Id: <20131025200754.D222AC4058E@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Oct 2013 13:08:46 +0530, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> The ams AS3722 is a compact system PMU suitable for mobile phones,
> tablets etc. It has 4 DC/DC step-down regulators, 3 DC/DC step-down
> controller, 11 LDOs, RTC, automatic battery, temperature and
> over-current monitoring, 8 GPIOs, ADC and a watchdog.
> 
> Add MFD core driver for the AS3722 to support core functionality.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Signed-off-by: Florian Lobmaier <florian.lobmaier@ams.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Acked-by: Stephen Warren <swarren@nvidia.com>
> ---
> Changes from V1:
> - Remove compatible string from DT for subnode.
> - Nit cleanups in driver and use module_i2c_driver
> 
> Changes from V2:
> - Change DT file to reflect the changes in gpio/pincntrl driver.
>   Now there is no extra subnode.
> 
> Changes from V3:
> - Combine DT of pincontrol and regulator to mfd.
> - Nits cleanups.
> - AMS to ams.
> 
> Changes from V4:
> - Rephrased the dt binding documents.
> - Added dt-binding header for DTS file.
> - Fix some of indention issue in dt documents.
> 
> Reposting V5 as per Lee's.
> 
>  Documentation/devicetree/bindings/mfd/as3722.txt |  194 ++++++++++
>  drivers/mfd/Kconfig                              |   12 +
>  drivers/mfd/Makefile                             |    1 +
>  drivers/mfd/as3722.c                             |  449 ++++++++++++++++++++++
>  include/dt-bindings/mfd/as3722.h                 |   52 +++
>  include/linux/mfd/as3722.h                       |  423 ++++++++++++++++++++
>  6 files changed, 1131 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/as3722.txt
>  create mode 100644 drivers/mfd/as3722.c
>  create mode 100644 include/dt-bindings/mfd/as3722.h
>  create mode 100644 include/linux/mfd/as3722.h
> 
> diff --git a/Documentation/devicetree/bindings/mfd/as3722.txt b/Documentation/devicetree/bindings/mfd/as3722.txt
> new file mode 100644
> index 0000000..fc2191e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/as3722.txt
> @@ -0,0 +1,194 @@
> +* ams AS3722 Power management IC.
> +
> +Required properties:
> +-------------------
> +- compatible: Must be "ams,as3722".
> +- reg: I2C device address.
> +- interrupt-controller: AS3722 has internal interrupt controller which takes the
> +  interrupt request from internal sub-blocks like RTC, regulators, GPIOs as well
> +  as external input.
> +- #interrupt-cells: Should be set to 2 for IRQ number and flags.
> +  The first cell is the IRQ number. IRQ numbers for different interrupt source
> +  of AS3722 are defined at dt-bindings/mfd/as3722.h
> +  The second cell is the flags, encoded as the trigger masks from binding document
> +	interrupts.txt, using dt-bindings/irq.
> +
> +Optional submodule and their properties:
> +=======================================
> +
> +Pinmux and GPIO:
> +===============
> +Device has 8 GPIO pins which can be configured as GPIO as well as the special IO
> +functions.
> +
> +Please refer to pinctrl-bindings.txt in this directory for details of the
> +common pinctrl bindings used by client devices, including the meaning of the
> +phrase "pin configuration node".
> +
> +Following are properties which is needed if GPIO and pinmux functionality
> +is required:
> +    Required properties:
> +    -------------------
> +	- gpio-controller: Marks the device node as a GPIO controller.
> +	- #gpio-cells: Number of GPIO cells. Refer to binding document
> +			gpio/gpio.txt
> +
> +    Optional properties:
> +    --------------------
> +	Following properties are require if pin control setting is required
> +	at boot.
> +	- pinctrl-names: A pinctrl state named "default" be defined, using the
> +		bindings in pinctrl/pinctrl-binding.txt.
> +	- pinctrl[0...n]: Properties to contain the phandle that refer to
> +		different nodes of pin control settings. These nodes represents
> +		the pin control setting of state 0 to state n. Each of these
> +		nodes contains different subnodes to represents some desired
> +		configuration for a list of pins. This configuration can
> +		include the mux function to select on those pin(s), and
> +		various pin configuration parameters, such as pull-up,
> +		open drain.
> +
> +		Each subnode have following properties:
> +		Required properties:
> +		    - pins: List of pins. Valid values of pins properties are:
> +				gpio0, gpio1, gpio2, gpio3, gpio4, gpio5,
> +				gpio6, gpio7
> +
> +		Optional properties:
> +			function, bias-disable, bias-pull-up, bias-pull-down,
> +			bias-high-impedance, drive-open-drain.
> +
> +			Valid values for function properties are:
> +				gpio, interrupt-out, gpio-in-interrupt,
> +				vsup-vbat-low-undebounce-out,
> +				vsup-vbat-low-debounce-out,
> +				voltage-in-standby, oc-pg-sd0, oc-pg-sd6,
> +				powergood-out, pwm-in, pwm-out, clk32k-out,
> +				watchdog-in, soft-reset-in
> +
> +Regulators:
> +===========
> +Device has multiple DCDC and LDOs. The node "regulators" is require if regulator
> +functionality is needed.
> +
> +Following are properties of regulator subnode.
> +
> +    Optional properties:
> +    -------------------
> +	The input supply of regulators are the optional properties on the
> +	regulator node. The input supply of these regulators are provided
> +	through following properties:
> +		vsup-sd2-supply: Input supply for SD2.
> +		vsup-sd3-supply: Input supply for SD3.
> +		vsup-sd4-supply: Input supply for SD4.
> +		vsup-sd5-supply: Input supply for SD5.
> +		vin-ldo0-supply: Input supply for LDO0.
> +		vin-ldo1-6-supply: Input supply for LDO1 and LDO6.
> +		vin-ldo2-5-7-supply: Input supply for LDO2, LDO5 and LDO7.
> +		vin-ldo3-4-supply: Input supply for LDO3 and LDO4.
> +		vin-ldo9-10-supply: Input supply for LDO9 and LDO10.
> +		vin-ldo11-supply: Input supply for LDO11.

What is the data in these properties? The documentation isn't clear.

In principle, the binding looks okay to me.

g.

