Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbaFBQ0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:26:49 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39947 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937AbaFBQ0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:26:47 -0400
Message-ID: <538CA5C3.5050709@wwwdotorg.org>
Date: Mon, 02 Jun 2014 10:26:43 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marcel Ziswiler <marcel@ziswiler.com>, thierry.reding@gmail.com
CC: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch
Subject: Re: [PATCH 3/3] arm: tegra: initial support for apalis t30
References: <c5522b0efcbfc7690dcde6aaf78b9dd568f99604.1401665237.git.marcel@ziswiler.com> <b470c9c8631a6ef021d140192eb07006de3cfd93.1401665237.git.marcel@ziswiler.com>
In-Reply-To: <b470c9c8631a6ef021d140192eb07006de3cfd93.1401665237.git.marcel@ziswiler.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2014 05:37 PM, Marcel Ziswiler wrote:
> This patch adds the device tree to support Toradex Apalis T30, a
> computer on module which can be used on different carrier boards.
> 
> The module consists of a Tegra 3 SoC, two PMICs, 1 or 2 GB of DDR3L
> RAM, eMMC, an LM95245 temperature sensor chip, an i210 resp. i211
> gigabit Ethernet controller, an STMPE811 ADC/touch controller as well
> as two MCP2515 CAN controllers. Furthermore, there is an SGTL5000 audio
> codec which is not yet supported. Anything that is not self contained
> on the module is disabled by default.
> 
> The device tree for the Evaluation Board includes the modules device
> tree and enables the supported peripherals of the carrier board (the
> Evaluation Board supports almost all of them).
> 
> While at it also add the device tree binding documentation for Apalis
> T30 as well as the previously missing one for the recently added
> Colibri T30.

> diff --git a/Documentation/devicetree/bindings/arm/tegra.txt b/Documentation/devicetree/bindings/arm/tegra.txt

> +  toradex,colibri_t30
> +  toradex,colibri_t30-eval-v3

Those don't seem to be related to Apalis support.

> diff --git a/arch/arm/boot/dts/tegra30-apalis-eval.dts b/arch/arm/boot/dts/tegra30-apalis-eval.dts
> +	host1x@50000000 {
> +		dc@54200000 {
> +			rgb {
> +				status = "okay";
> +				nvidia,panel = <&panel>;
> +			};
> +		};
> +		hdmi@54280000 {

Nit: Add a blank line between the nodes. Check elsewhere too.

> +	serial@70006040 {
> +		compatible = "nvidia,tegra30-hsuart";
> +		status = "okay";
> +	};

Nit: Put the status property first followed by new/overridden
properties, to be consistent with other Tegra DTs. Check elsewhere too.

> +	/* SPI1: Apalis SPI1 */
> +	spi@7000d400 {
> +		status = "okay";
> +		spi-max-frequency = <25000000>;
> +		spidev0: spidev@1 {

Nit: Add a blank line between properties and nodes. Check elsewhere too.

> +	sd1: sdhci@78000000 {
...
> +	mmc1: sdhci@78000400 {

Do those nodes really need labels? Nothing appears to reference them,
and I can't see why anything would.

Should the mmc1 node be non-removable? It seems a bit odd for a
removable device to have an 8-bit data bus.

> +	backlight: backlight {
> +		compatible = "pwm-backlight";
> +
> +		/* PWM0 */

Nit: No need for a blank line between a bunch of related properties.
Check elsewhere too.

> +	pwmleds {
> +		compatible = "pwm-leds";
> +
> +		pwm3 {
> +			label = "PWM3";
> +			pwms = <&pwm 1 19600>;
> +			max-brightness = <255>;
> +		};
> +		pwm2 {
> +			label = "PWM2";
> +			pwms = <&pwm 2 19600>;
> +			max-brightness = <255>;
> +		};
> +		pwm1 {
> +			label = "PWM1";
> +			pwms = <&pwm 3 19600>;
> +			max-brightness = <255>;
> +		};

Nit: Why not sort those nodes in numerical order?

> +	regulators {
> +		sys_5v0_reg: regulator@1 {

Nit: Why not start the numbering at 0?

> diff --git a/arch/arm/boot/dts/tegra30-apalis.dtsi b/arch/arm/boot/dts/tegra30-apalis.dtsi

> +	pinmux@70000868 {
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&state_default>;
> +
> +		state_default: pinmux {

It might make sense to add all the pinmux data to
https://github.com/NVIDIA/tegra-pinmux-scripts, so that both the kernel
and U-Boot pinmux initialization tables can be auto-generated from a
single data-structure. I think that'll get a small amount of
error-/consistency-checking of the data too.
