Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaEFShQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 14:37:16 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:60302 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaEFShL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 14:37:11 -0400
Message-ID: <53692BCA.4070601@gmail.com>
Date: Tue, 06 May 2014 20:36:58 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
CC: devicetree@vger.kernel.org, kgene.kim@samsung.com,
        Russell King <linux@arm.linux.org.uk>, arnd@arndb.de,
        Wolfram Sang <wsa@the-dreams.de>, t.figa@samsung.com,
        Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2 1/6] i2c: s3c2410: Moving I2C interrupt re-configuration
 code into i2c driver
References: <1399366282-4191-1-git-send-email-pankaj.dubey@samsung.com> <1399366282-4191-2-git-send-email-pankaj.dubey@samsung.com>
In-Reply-To: <1399366282-4191-2-git-send-email-pankaj.dubey@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 06.05.2014 10:51, Pankaj Dubey wrote:
> Let's move I2C interrupt re-configuration code from machine
> file exynos.c to I2C driver. Since only Exynos5250, and
> Exynos5420 need to do this, added syscon based phandle to
> i2c device nodes of respective SoC DT files.
>
> CC: Rob Herring <robh+dt@kernel.org>
> CC: Randy Dunlap <rdunlap@infradead.org>
> CC: Wolfram Sang <wsa@the-dreams.de>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: devicetree@vger.kernel.org
> CC: linux-doc@vger.kernel.org
> CC: linux-i2c@vger.kernel.org
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>   .../devicetree/bindings/arm/samsung/sysreg.txt     |    1 +
>   arch/arm/boot/dts/exynos5.dtsi                     |    5 ++++
>   arch/arm/boot/dts/exynos5250.dtsi                  |    4 +++
>   arch/arm/boot/dts/exynos5420.dtsi                  |    4 +++
>   arch/arm/mach-exynos/exynos.c                      |   26 -------------------
>   drivers/i2c/busses/i2c-s3c2410.c                   |   27 ++++++++++++++++++++
>   6 files changed, 41 insertions(+), 26 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/arm/samsung/sysreg.txt b/Documentation/devicetree/bindings/arm/samsung/sysreg.txt
> index 0ab3251..fd71581 100644
> --- a/Documentation/devicetree/bindings/arm/samsung/sysreg.txt
> +++ b/Documentation/devicetree/bindings/arm/samsung/sysreg.txt
> @@ -3,6 +3,7 @@ SAMSUNG S5P/Exynos SoC series System Registers (SYSREG)
>   Properties:
>    - compatible : should contain "samsung,<chip name>-sysreg", "syscon";
>      For Exynos4 SoC series it should be "samsung,exynos4-sysreg", "syscon";
> +   For Exynos5 SoC series it should be "samsung,exynos5-sysreg", "syscon";
>    - reg : offset and length of the register set.
>
>   Example:
> diff --git a/arch/arm/boot/dts/exynos5.dtsi b/arch/arm/boot/dts/exynos5.dtsi
> index 79d0608..3027e37 100644
> --- a/arch/arm/boot/dts/exynos5.dtsi
> +++ b/arch/arm/boot/dts/exynos5.dtsi
> @@ -99,4 +99,9 @@
>   		#size-cells = <0>;
>   		status = "disabled";
>   	};
> +
> +	sys_reg: syscon@10050000 {
> +		compatible = "samsung,exynos5-sysreg", "syscon";
> +		reg = <0x10050000 0x400>;
> +	};
>   };
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index 8d724d5..46f0233 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -285,6 +285,7 @@
>   		clock-names = "i2c";
>   		pinctrl-names = "default";
>   		pinctrl-0 = <&i2c0_bus>;
> +		samsung,syscon-phandle = <&sys_reg>;
>   		status = "disabled";
>   	};
>
> @@ -298,6 +299,7 @@
>   		clock-names = "i2c";
>   		pinctrl-names = "default";
>   		pinctrl-0 = <&i2c1_bus>;
> +		samsung,syscon-phandle = <&sys_reg>;
>   		status = "disabled";
>   	};
>
> @@ -311,6 +313,7 @@
>   		clock-names = "i2c";
>   		pinctrl-names = "default";
>   		pinctrl-0 = <&i2c2_bus>;
> +		samsung,syscon-phandle = <&sys_reg>;
>   		status = "disabled";
>   	};
>
> @@ -324,6 +327,7 @@
>   		clock-names = "i2c";
>   		pinctrl-names = "default";
>   		pinctrl-0 = <&i2c3_bus>;
> +		samsung,syscon-phandle = <&sys_reg>;
>   		status = "disabled";
>   	};
>
> diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
> index ff496ad..762128c 100644
> --- a/arch/arm/boot/dts/exynos5420.dtsi
> +++ b/arch/arm/boot/dts/exynos5420.dtsi
> @@ -517,6 +517,7 @@
>   		clock-names = "i2c";
>   		pinctrl-names = "default";
>   		pinctrl-0 = <&i2c0_bus>;
> +		samsung,syscon-phandle = <&sys_reg>;
>   		status = "disabled";
>   	};
>
> @@ -530,6 +531,7 @@
>   		clock-names = "i2c";
>   		pinctrl-names = "default";
>   		pinctrl-0 = <&i2c1_bus>;
> +		samsung,syscon-phandle = <&sys_reg>;
>   		status = "disabled";
>   	};
>
> @@ -543,6 +545,7 @@
>   		clock-names = "i2c";
>   		pinctrl-names = "default";
>   		pinctrl-0 = <&i2c2_bus>;
> +		samsung,syscon-phandle = <&sys_reg>;
>   		status = "disabled";
>   	};
>
> @@ -556,6 +559,7 @@
>   		clock-names = "i2c";
>   		pinctrl-names = "default";
>   		pinctrl-0 = <&i2c3_bus>;
> +		samsung,syscon-phandle = <&sys_reg>;
>   		status = "disabled";
>   	};
>
> diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
> index 59eb1f1..54ae2e1 100644
> --- a/arch/arm/mach-exynos/exynos.c
> +++ b/arch/arm/mach-exynos/exynos.c
> @@ -293,32 +293,6 @@ void __init exynos_map_pmu(void)
>
>   static void __init exynos_dt_machine_init(void)
>   {
> -	struct device_node *i2c_np;
> -	const char *i2c_compat = "samsung,s3c2440-i2c";
> -	unsigned int tmp;
> -	int id;
> -
> -	/*
> -	 * Exynos5's legacy i2c controller and new high speed i2c
> -	 * controller have muxed interrupt sources. By default the
> -	 * interrupts for 4-channel HS-I2C controller are enabled.
> -	 * If node for first four channels of legacy i2c controller
> -	 * are available then re-configure the interrupts via the
> -	 * system register.
> -	 */
> -	if (soc_is_exynos5()) {
> -		for_each_compatible_node(i2c_np, NULL, i2c_compat) {
> -			if (of_device_is_available(i2c_np)) {
> -				id = of_alias_get_id(i2c_np, "i2c");
> -				if (id < 4) {
> -					tmp = readl(EXYNOS5_SYS_I2C_CFG);
> -					writel(tmp & ~(0x1 << id),
> -							EXYNOS5_SYS_I2C_CFG);
> -				}
> -			}
> -		}
> -	}
> -
>   	exynos_map_pmu();
>
>   	if (!soc_is_exynos5440())
> diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
> index ae44910..0420150 100644
> --- a/drivers/i2c/busses/i2c-s3c2410.c
> +++ b/drivers/i2c/busses/i2c-s3c2410.c
> @@ -39,6 +39,8 @@
>   #include <linux/of.h>
>   #include <linux/of_gpio.h>
>   #include <linux/pinctrl/consumer.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/regmap.h>
>
>   #include <asm/irq.h>
>
> @@ -91,6 +93,9 @@
>   /* Max time to wait for bus to become idle after a xfer (in us) */
>   #define S3C2410_IDLE_TIMEOUT	5000
>
> +/* Exynos5 Sysreg offset */
> +#define EXYNOS5_SYS_I2C_CFG	0x0234
> +
>   /* i2c controller state */
>   enum s3c24xx_i2c_state {
>   	STATE_IDLE,
> @@ -127,6 +132,7 @@ struct s3c24xx_i2c {
>   #if defined(CONFIG_ARM_S3C24XX_CPUFREQ)
>   	struct notifier_block	freq_transition;
>   #endif
> +	struct regmap		*sysreg;
>   };
>
>   static struct platform_device_id s3c24xx_driver_ids[] = {
> @@ -1075,6 +1081,8 @@ static void
>   s3c24xx_i2c_parse_dt(struct device_node *np, struct s3c24xx_i2c *i2c)
>   {
>   	struct s3c2410_platform_i2c *pdata = i2c->pdata;
> +	unsigned int tmp;
> +	int id;
>
>   	if (!np)
>   		return;
> @@ -1084,6 +1092,25 @@ s3c24xx_i2c_parse_dt(struct device_node *np, struct s3c24xx_i2c *i2c)
>   	of_property_read_u32(np, "samsung,i2c-slave-addr", &pdata->slave_addr);
>   	of_property_read_u32(np, "samsung,i2c-max-bus-freq",
>   				(u32 *)&pdata->frequency);
> +	/*
> +	 * Exynos5's legacy i2c controller and new high speed i2c
> +	 * controller have muxed interrupt sources. By default the
> +	 * interrupts for 4-channel HS-I2C controller are enabled.
> +	 * If node for first four channels of legacy i2c controller
> +	 * are available then re-configure the interrupts via the
> +	 * system register.
> +	 */
> +	id = of_alias_get_id(np, "i2c");
> +	i2c->sysreg = syscon_regmap_lookup_by_phandle(np,
> +			"samsung,syscon-phandle");
> +	if (IS_ERR(i2c->sysreg)) {
> +		i2c->sysreg = NULL;

NULL shouldn't be considered for pointers using the ERR_PTR() 
convention, so you should just preserve the value returned by 
syscon_regmap_lookup_by_phandle() here.

Also, the driver seems to do this only once in probe, so maybe you 
should simply use a local variable here, without storing the regmap in 
i2c struct.

> +		/* As this is not compulsary do not return error */

Is it? Will the driver work normally without interrupts in this case?

Also, typo: s/compulsary/compulsory/

> +		pr_info("i2c-%d skipping re-configuration of interrutps\n", id);
> +		return;
> +	}
> +	regmap_read(i2c->sysreg, EXYNOS5_SYS_I2C_CFG, &tmp);
> +	regmap_write(i2c->sysreg, EXYNOS5_SYS_I2C_CFG, tmp & ~(0x1 << id));

You could use regmap_update_bits() [1] here instead, with mask set to 
BIT(id) and val set to 0.

[1] http://lxr.free-electrons.com/source/drivers/base/regmap/regmap.c#L1977

Best regards,
Tomasz
