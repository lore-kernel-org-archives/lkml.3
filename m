Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab3KOJtg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 04:49:36 -0500
Received: from mail.southpole.se ([37.247.8.11]:45660 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab3KOJt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 04:49:28 -0500
Message-ID: <5285EE5A.1070202@southpole.se>
Date: Fri, 15 Nov 2013 10:50:18 +0100
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux@openrisc.net, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Mehall <contact@kevinmehall.net>,
        Marek Czerski <ma.czerski@gmail.com>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Subject: Re: [PATCH] openrisc: Add DTS and defconfig for DE0-Nano
References: <1384029451-16555-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1384029451-16555-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.3.3(13276) on assp.southpole.se
X-Assp-ID: assp.southpole.se 08963-11071
X-Assp-Session: 7F739AA40B30 (mail 1)
X-Assp-Client-TLS: yes
X-Assp-Server-TLS: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

I'll pull this into my OpenRISC tree now as-is, but there's a couple of 
things that need sorting out before this can be upstreamed... see below.

Thanks,
Jonas

On 11/09/2013 09:37 PM, Geert Uytterhoeven wrote:
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
>    - Change flash0 to spansion,s25sl064p, due to kernel message
>      m25p80 spi32766.0: found s25sl064p, expected m25p10
>    - Use reg-shift instead of regstep for i2c0, due to kernel message
>      ocores-i2c a0000000.ocores: regstep property deprecated, use reg-shift
>
>   arch/openrisc/boot/dts/de0_nano.dts      |  158 ++++++++++++++++++++++++++++++
>   arch/openrisc/configs/de0_nano_defconfig |   86 ++++++++++++++++
>   2 files changed, 244 insertions(+)
>   create mode 100644 arch/openrisc/boot/dts/de0_nano.dts
>   create mode 100644 arch/openrisc/configs/de0_nano_defconfig
>
> diff --git a/arch/openrisc/boot/dts/de0_nano.dts b/arch/openrisc/boot/dts/de0_nano.dts
> new file mode 100644
> index 000000000000..42f91b5184d9
> --- /dev/null
> +++ b/arch/openrisc/boot/dts/de0_nano.dts
> @@ -0,0 +1,158 @@
> +/dts-v1/;
> +/ {
> +	compatible = "opencores,de0_nano";

This should probably be "altera,de0_nano".  We also need to put a 
version number of some kind on this thing.  How are the de0_nano boards 
versioned?


> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +	interrupt-parent = <&pic>;
> +
> +	chosen {
> +		bootargs = "console=uart,mmio,0x90000000,115200";
> +	};
> +
> +	memory@0 {
> +		device_type = "memory";
> +		reg = <0x00000000 0x02000000>;
> +	};
> +
> +	cpus {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		cpu@0 {
> +			compatible = "opencores,or1200-rtlsvn481";
> +			reg = <0>;
> +			clock-frequency = <50000000>;
> +		};
> +	};
> +
> +	/*
> +	 * OR1K PIC is built into CPU and accessed via special purpose
> +	 * registers.  It is not addressable and, hence, has no 'reg'
> +	 * property.
> +	 */
> +	pic: pic {
> +		compatible = "opencores,or1k-pic";
> +		#interrupt-cells = <1>;
> +		interrupt-controller;
> +	};
> +
> +	serial0: serial@90000000 {
> +		compatible = "opencores,uart16550-rtlsvn105", "ns16550a";
> +		reg = <0x90000000 0x100>;
> +		interrupts = <2>;
> +		clock-frequency = <50000000>;
> +	};
> +
> +	i2c0: ocores@a0000000 {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible = "opencores,i2c-ocores";

Version number needed.  OpenCores wanted "projectname-rtlsvn###" where 
### is the SVN commit number of the RTL directory in the project's 
source repository.

> +		reg = <0xa0000000 0x8>;
> +		interrupts = <10>;
> +		clock-frequency = <50000000>;
> +
> +		reg-shift = <0>;	/* 8 bit registers */
> +		reg-io-width = <1>;	/* 8 bit read/write */
> +
> +		adxl34x@1d {
> +			compatible = "adxl34x";
> +			reg = <0x1d>;
> +			interrupts = <26>;
> +		};
> +		eeprom@50 {
> +			compatible = "at24,24c02";
> +			reg = <0x50>;
> +			pagesize = <8>;
> +		};
> +	};
> +
> +	spi0: spi0@b0000000 {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible = "opencores,spi-simple";

Version number.

> +		reg = <0xb0000000 0x5>;
> +
> +		flash0: mtd@0 {
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			compatible = "spansion,s25sl064p";
> +			reg = <0>;
> +			spi-max-frequency = <40000000>;
> +			m25p,fast-read;
> +
> +			partition@0 {
> +				label = "FPGA image";
> +				reg = <0x00000000 0x000b0000>;
> +				read-only;
> +			};
> +			partition@b0000 {
> +				label = "bootloader";
> +				reg = <0x000b0000 0x00050000>;
> +				read-only;
> +			};
> +			partition@100000 {
> +				label = "free space";
> +				reg = <0x00100000 0x00700000>;
> +			};
> +		};
> +	};
> +
> +	spi1: spi1@b1000000 {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible = "opencores,spi-simple";

Version number needed.  OpenCores wanted "projectname-rtlsvn###" where 
### is the SVN commit number of the RTL directory in the project's 
source repository.

> +		reg = <0xb1000000 0x5>;
> +
> +		adc@0 {
> +			compatible = "adcxx,adcxx8s";
> +			reg = <0>;
> +			spi-max-frequency = <1000000>;
> +		};
> +	};
> +
> +	gpio0: gpio@91000000 {
> +		compatible = "opencores,jbtrivial";

There's no project called 'jbtrivial' at OpenCores.  Should this be 
"linux,jbtrivial" to indicate that this refers to a Linux driver?

> +		reg = <0x91000000 0x2>;
> +		#gpio-cells = <2>;
> +		gpio-controller;
> +		xlnx,data-offset = <0>;
> +		xlnx,tri-offset = <1>;
> +		xlnx,gpio-width = <8>;

Yuck... I wrote this driver with a similar driver for a Xilinx part as a 
starting point.  Apparently I left the Xilenx (xlnx) tags in there for 
the device properties.  We can't really have it like this, though.

Like I mentioned earlier, I'd like to see this thing disappear 
altogether and be replaced with gpio-generic.

/Jonas

