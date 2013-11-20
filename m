Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab3KTUpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:45:30 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:46978 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab3KTUp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:45:27 -0500
MIME-Version: 1.0
In-Reply-To: <1384029451-16555-1-git-send-email-geert@linux-m68k.org>
References: <1384029451-16555-1-git-send-email-geert@linux-m68k.org>
Date: Wed, 20 Nov 2013 14:45:26 -0600
Message-ID: <CAL_JsqLuaOqw2X7dcwnJbnTvO30pbV4=5TLfEygEeB6gBw3G_A@mail.gmail.com>
Subject: Re: [PATCH] openrisc: Add DTS and defconfig for DE0-Nano
From: Rob Herring <robherring2@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jonas Bonn <jonas@southpole.se>, linux@openrisc.net,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Mehall <contact@kevinmehall.net>,
        Marek Czerski <ma.czerski@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 9, 2013 at 2:37 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Add a DTS and defconfig for the Terasic DE0-Nano Development and Education
> Board running ORPSoC.  This board contains an Altera Cyclone IV FPGA with
> support chips and I/O.
>
> The DTS was derived from published versions by Kevin Mehall and Marek
> Czerski.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Kevin Mehall <contact@kevinmehall.net>
> Cc: Marek Czerski <ma.czerski@gmail.com>
> ---
> Notable changes:
>   - Change flash0 to spansion,s25sl064p, due to kernel message
>     m25p80 spi32766.0: found s25sl064p, expected m25p10
>   - Use reg-shift instead of regstep for i2c0, due to kernel message
>     ocores-i2c a0000000.ocores: regstep property deprecated, use reg-shift
>
>  arch/openrisc/boot/dts/de0_nano.dts      |  158 ++++++++++++++++++++++++++++++
>  arch/openrisc/configs/de0_nano_defconfig |   86 ++++++++++++++++
>  2 files changed, 244 insertions(+)
>  create mode 100644 arch/openrisc/boot/dts/de0_nano.dts
>  create mode 100644 arch/openrisc/configs/de0_nano_defconfig
>
> diff --git a/arch/openrisc/boot/dts/de0_nano.dts b/arch/openrisc/boot/dts/de0_nano.dts
> new file mode 100644
> index 000000000000..42f91b5184d9
> --- /dev/null
> +++ b/arch/openrisc/boot/dts/de0_nano.dts
> @@ -0,0 +1,158 @@
> +/dts-v1/;
> +/ {
> +       compatible = "opencores,de0_nano";

This string needs to be documented.

> +       #address-cells = <1>;
> +       #size-cells = <1>;
> +       interrupt-parent = <&pic>;
> +
> +       chosen {
> +               bootargs = "console=uart,mmio,0x90000000,115200";
> +       };
> +
> +       memory@0 {
> +               device_type = "memory";
> +               reg = <0x00000000 0x02000000>;
> +       };
> +
> +       cpus {
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               cpu@0 {
> +                       compatible = "opencores,or1200-rtlsvn481";
> +                       reg = <0>;
> +                       clock-frequency = <50000000>;
> +               };
> +       };
> +
> +       /*
> +        * OR1K PIC is built into CPU and accessed via special purpose
> +        * registers.  It is not addressable and, hence, has no 'reg'
> +        * property.
> +        */
> +       pic: pic {
> +               compatible = "opencores,or1k-pic";
> +               #interrupt-cells = <1>;
> +               interrupt-controller;
> +       };
> +
> +       serial0: serial@90000000 {

These memory mapped devices should be under a bus node of some sort.
Typically a "simple-bus" node.

> +               compatible = "opencores,uart16550-rtlsvn105", "ns16550a";

This needs to be documented. Same comment applies to all compatible strings.

> +               reg = <0x90000000 0x100>;
> +               interrupts = <2>;
> +               clock-frequency = <50000000>;
> +       };
> +
> +       i2c0: ocores@a0000000 {
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               compatible = "opencores,i2c-ocores";
> +               reg = <0xa0000000 0x8>;
> +               interrupts = <10>;
> +               clock-frequency = <50000000>;
> +
> +               reg-shift = <0>;        /* 8 bit registers */
> +               reg-io-width = <1>;     /* 8 bit read/write */
> +
> +               adxl34x@1d {
> +                       compatible = "adxl34x";
> +                       reg = <0x1d>;
> +                       interrupts = <26>;
> +               };
> +               eeprom@50 {
> +                       compatible = "at24,24c02";
> +                       reg = <0x50>;
> +                       pagesize = <8>;
> +               };
> +       };
> +
> +       spi0: spi0@b0000000 {
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               compatible = "opencores,spi-simple";

Is this different than "opencores,tiny-spi-rtlsvn2"? Is "simple"
something I can correlate to a specific version of h/w?

Rob
