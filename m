Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab3BGJvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 04:51:50 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60390 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086Ab3BGJvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 04:51:46 -0500
Message-ID: <51137911.8080303@ti.com>
Date: Thu, 7 Feb 2013 15:21:13 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
CC: <linux-i2c@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <khilman@deeprootsystems.com>, <hs@denx.de>, <linux@arm.linux.org.uk>
Subject: Re: [PATCH] ARM: davinci: da850: add DT node for I2C0
References: <1360143382-24607-1-git-send-email-manishv.b@ti.com>
In-Reply-To: <1360143382-24607-1-git-send-email-manishv.b@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/6/2013 3:06 PM, Vishwanathrao Badarkhe, Manish wrote:
> Add I2C0 device tree and pin muxing information to da850-evm.
> Also, add OF_DEV_AUXDATA for I2C0 controller driver in da850
> board dt file to use I2C0 clock.
> Verified i2c0 node gets created in sys class interface as
> "/sys/class/i2c-dev/i2c-0/subsystem/i2c-0".

That's not enough testing! (I know this would have gotten more testing
as part of the bigger series you posted earlier). I tested on da850 evm
with i2cdetect and i2cdump and it works fine.

> 
> Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
> ---
> Applies on top of v3.8-rc6 of linus tree.
> Depends on
>  - drivers/pinctrl: grab default handles from device core
>    http://www.gossamer-threads.com/lists/linux/kernel/1665411
>  - ARM: davinci: da850: add interrupt-parent property in soc node
>    https://patchwork.kernel.org/patch/2044101/
>  - ARM: davinci: da850: add pinctrl support
>    http://comments.gmane.org/gmane.linux.davinci/25993
> 
> :100644 100644 433027f... 738d5d4... M	arch/arm/boot/dts/da850-evm.dts
> :100644 100644 4b02167... a0072aa... M	arch/arm/boot/dts/da850.dtsi
> :100644 100644 37c27af... 95ca4e9... M	arch/arm/mach-davinci/da8xx-dt.c
>  arch/arm/boot/dts/da850-evm.dts  |    6 ++++++
>  arch/arm/boot/dts/da850.dtsi     |   14 ++++++++++++++
>  arch/arm/mach-davinci/da8xx-dt.c |    8 +++++++-
>  3 files changed, 27 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
> index 433027f..738d5d4 100644
> --- a/arch/arm/boot/dts/da850-evm.dts
> +++ b/arch/arm/boot/dts/da850-evm.dts
> @@ -27,6 +27,12 @@
>  		serial2: serial@1d0d000 {
>  			status = "okay";
>  		};
> +		i2c0: i2c@1c22000 {
> +			status = "okay";
> +			clock-frequency = <100000>;
> +			pinctrl-names = "default";
> +			pinctrl-0 = <&i2c0_pins>;
> +		};
>  	};
>  	nand_cs3@62000000 {
>  		status = "okay";
> diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
> index 4b02167..a0072aa 100644
> --- a/arch/arm/boot/dts/da850.dtsi
> +++ b/arch/arm/boot/dts/da850.dtsi
> @@ -56,6 +56,12 @@
>  					0x30 0x01100000  0x0ff00000
>  				>;
>  			};
> +			i2c0_pins: pinmux_i2c0_pins {
> +				pinctrl-single,bits = <
> +					/* I2C0_SDA,I2C0_SCL */
> +					0x10 0x00002200 0x0000ff00
> +				>;
> +			};
>  		};
>  		serial0: serial@1c42000 {
>  			compatible = "ns16550a";
> @@ -81,6 +87,14 @@
>  			interrupts = <61>;
>  			status = "disabled";
>  		};
> +		i2c0: i2c@1c22000 {
> +			compatible = "ti,davinci-i2c";
> +			reg = <0x22000 0x1000>;
> +			interrupts = <15>;
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			status = "disabled";
> +		};
>  	};
>  	nand_cs3@62000000 {
>  		compatible = "ti,davinci-nand";
> diff --git a/arch/arm/mach-davinci/da8xx-dt.c b/arch/arm/mach-davinci/da8xx-dt.c
> index 37c27af..95ca4e9 100644
> --- a/arch/arm/mach-davinci/da8xx-dt.c
> +++ b/arch/arm/mach-davinci/da8xx-dt.c
> @@ -37,11 +37,17 @@ static void __init da8xx_init_irq(void)
>  	of_irq_init(da8xx_irq_match);
>  }
>  
> +struct of_dev_auxdata da850_auxdata_lookup[] __initdata = {
> +	OF_DEV_AUXDATA("ti,davinci-i2c", 0x01c22000, "i2c_davinci.1", NULL),
> +	{}
> +};
> +
>  #ifdef CONFIG_ARCH_DAVINCI_DA850
>  
>  static void __init da850_init_machine(void)
>  {
> -	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> +	of_platform_populate(NULL, of_default_bus_match_table,
> +				da850_auxdata_lookup, NULL);

'checkpatch --strict' complains here of improper alignment. I fixed it
locally. I am planning to send this to upstreams and see if this can
make it for v3.9, but its pretty late already and it depends..

Thanks,
Sekhar
