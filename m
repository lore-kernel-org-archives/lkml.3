Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210AbaFOJRW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 05:17:22 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:58811 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaFOJRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 05:17:19 -0400
Message-ID: <539D6328.4020505@traphandler.com>
Date: Sun, 15 Jun 2014 11:11:04 +0200
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Reply-To: jjhiblot@traphandler.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        David Airlie <airlied@linux.ie>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
CC: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2 2/7] pwm: add support for atmel-hlcdc-pwm device
References: <1402329860-27520-1-git-send-email-boris.brezillon@free-electrons.com> <1402329860-27520-3-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1402329860-27520-3-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/09/2014 06:04 PM, Boris BREZILLON wrote:
> The HLCDC IP available in some Atmel SoCs (i.e. sam9x5i.e. at91sam9n12,
> at91sam9x5 family or sama5d3 family) provide a PWM device.
> 
> This driver add support for this PWM device.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  .../devicetree/bindings/pwm/atmel-hlcdc-pwm.txt    |  40 ++++
>  drivers/pwm/Kconfig                                |   9 +
>  drivers/pwm/Makefile                               |   1 +
>  drivers/pwm/pwm-atmel-hlcdc.c                      | 216 +++++++++++++++++++++
>  4 files changed, 266 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt
>  create mode 100644 drivers/pwm/pwm-atmel-hlcdc.c
> 
> diff --git a/Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt b/Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt
> new file mode 100644
> index 0000000..5e2ba87
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt
> @@ -0,0 +1,40 @@
> +Device-Tree bindings for Atmel's HLCDC (High LCD Controller) PWM driver
> +
> +The Atmel HLCDC PWM is subdevice of the HLCDC MFD device.
> +See Documentation/devicetree/bindings/mfd/atmel-hlcdc.txt for more details.
> +
> +Required properties:
> + - compatible: value should be one of the following:
> +   "atmel,hlcdc-pwm"
> + - pinctr-names: the pin control state names. Should contain "default".
> + - pinctrl-0: should contain the pinctrl states described by pinctrl
> +   default.
> + - #pwm-cells: should be set to 3.
> +
> +Example:
> +
> +	hlcdc: hlcdc@f0030000 {
> +		compatible = "atmel,sama5d3-hlcdc";
> +		reg = <0xf0030000 0x2000>;
> +		clocks = <&lcdc_clk>, <&lcdck>, <&clk32k>;
> +		clock-names = "periph_clk","sys_clk", "slow_clk";
> +		status = "disabled";
> +
> +		hlcdc-display-controller {
> +			compatible = "atmel,hlcdc-dc";
> +			interrupts = <36 IRQ_TYPE_LEVEL_HIGH 0>;
> +			pinctrl-names = "default", "rgb-444", "rgb-565", "rgb-666", "rgb-888";
> +			pinctrl-0 = <&pinctrl_lcd_base>;
> +			pinctrl-1 = <&pinctrl_lcd_base &pinctrl_lcd_rgb444>;
> +			pinctrl-2 = <&pinctrl_lcd_base &pinctrl_lcd_rgb565>;
> +			pinctrl-3 = <&pinctrl_lcd_base &pinctrl_lcd_rgb666>;
> +			pinctrl-4 = <&pinctrl_lcd_base &pinctrl_lcd_rgb888>;
> +		};
> +
> +		hlcdc_pwm: hlcdc-pwm {
> +			compatible = "atmel,hlcdc-pwm";
> +			pinctrl-names = "default";
> +			pinctrl-0 = <&pinctrl_lcd_pwm>;
> +			#pwm-cells = <3>;
> +		};
> +	};
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 5b34ff2..7186242 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -50,6 +50,15 @@ config PWM_ATMEL
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-atmel.
>  
> +config PWM_ATMEL_HLCDC_PWM
> +	tristate "Atmel HLCDC PWM support"
> +	depends on MFD_ATMEL_HLCDC
I'd personnaly prefer a 'select' instead of 'depends on' here. Or maybe
the MFD driver should enabled y defaut for platforms supporting the hlcdc.
> +	help
> +	  Generic PWM framework driver for Atmel HLCDC PWM.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called pwm-atmel.
> +
>  config PWM_ATMEL_TCB
>  	tristate "Atmel TC Block PWM support"
>  	depends on ATMEL_TCLIB && OF
> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
> index e57d2c3..a245519 100644
> --- a/drivers/pwm/Makefile
> +++ b/drivers/pwm/Makefile
> @@ -2,6 +2,7 @@ obj-$(CONFIG_PWM)		+= core.o
>  obj-$(CONFIG_PWM_SYSFS)		+= sysfs.o
>  obj-$(CONFIG_PWM_AB8500)	+= pwm-ab8500.o
>  obj-$(CONFIG_PWM_ATMEL)		+= pwm-atmel.o
> +obj-$(CONFIG_PWM_ATMEL_HLCDC_PWM)	+= pwm-atmel-hlcdc.o
>  obj-$(CONFIG_PWM_ATMEL_TCB)	+= pwm-atmel-tcb.o
>  obj-$(CONFIG_PWM_BFIN)		+= pwm-bfin.o
>  obj-$(CONFIG_PWM_CLPS711X)	+= pwm-clps711x.o
> diff --git a/drivers/pwm/pwm-atmel-hlcdc.c b/drivers/pwm/pwm-atmel-hlcdc.c
> new file mode 100644
> index 0000000..080e43e
> --- /dev/null
> +++ b/drivers/pwm/pwm-atmel-hlcdc.c
> @@ -0,0 +1,216 @@
> +/*
> + * Copyright (C) 2014 Free Electrons
> + * Copyright (C) 2014 Atmel
> + *
> + * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/mfd/atmel-hlcdc.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/pwm.h>
> +
> +#define ATMEL_HLCDC_PWMCVAL_MASK	(0xff << 8)
> +#define ATMEL_HLCDC_PWMCVAL(x)		(((x) & 0xff) << 8)
> +#define ATMEL_HLCDC_PWMPOL		BIT(4)
> +#define ATMEL_HLCDC_PWMPS_MASK		0x7
> +#define ATMEL_HLCDC_PWMPS_MAX		0x6
> +#define ATMEL_HLCDC_PWMPS(x)		((x) & 0x7)
> +
> +struct atmel_hlcdc_pwm_chip {
> +	struct pwm_chip chip;
> +	struct atmel_hlcdc *hlcdc;
> +	struct clk *cur_clk;
> +};
> +
> +static inline struct atmel_hlcdc_pwm_chip *
> +pwm_chip_to_atmel_hlcdc_pwm_chip(struct pwm_chip *chip)
> +{
> +	return container_of(chip, struct atmel_hlcdc_pwm_chip, chip);
> +}
> +
> +static int atmel_hlcdc_pwm_config(struct pwm_chip *c,
> +				  struct pwm_device *pwm,
> +				  int duty_ns, int period_ns)
> +{
> +	struct atmel_hlcdc_pwm_chip *chip =
> +				pwm_chip_to_atmel_hlcdc_pwm_chip(c);
> +	struct atmel_hlcdc *hlcdc = chip->hlcdc;
> +	struct clk *new_clk = hlcdc->slow_clk;
> +	u64 pwmcval = duty_ns * 256;
> +	unsigned long clk_freq;
> +	u64 clk_period_ns;
> +	u32 pwmcfg;
> +	int pres;
> +
> +	clk_freq = clk_get_rate(new_clk);
> +	clk_period_ns = 1000000000;
> +	clk_period_ns *= 256;
> +	do_div(clk_period_ns, clk_freq);
> +
> +	if (clk_period_ns > period_ns) {
> +		new_clk = hlcdc->sys_clk;
> +		clk_freq = clk_get_rate(new_clk);
> +		clk_period_ns = 1000000000;
> +		clk_period_ns *= 256;
> +		do_div(clk_period_ns, clk_freq);
> +	}
> +
> +	for (pres = ATMEL_HLCDC_PWMPS_MAX; pres >= 0; pres--) {
> +		if ((clk_period_ns << pres) <= period_ns)
> +			break;
> +	}
> +
> +	if (pres > ATMEL_HLCDC_PWMPS_MAX)
> +		return -EINVAL;
> +
> +	pwmcfg = ATMEL_HLCDC_PWMPS(pres);
> +
> +	if (new_clk != chip->cur_clk) {
> +		u32 gencfg = 0;
> +
> +		clk_prepare_enable(new_clk);
> +		clk_disable_unprepare(chip->cur_clk);
> +		chip->cur_clk = new_clk;
> +
> +		if (new_clk != hlcdc->slow_clk)
> +			gencfg = ATMEL_HLCDC_CLKPWMSEL;
> +		regmap_update_bits(hlcdc->regmap, ATMEL_HLCDC_CFG(0),
> +				   ATMEL_HLCDC_CLKPWMSEL, gencfg);
> +	}
> +
> +	do_div(pwmcval, period_ns);
> +	if (pwmcval > 255)
> +		pwmcval = 255;
> +
> +	pwmcfg |= ATMEL_HLCDC_PWMCVAL(pwmcval);
> +
> +	regmap_update_bits(hlcdc->regmap, ATMEL_HLCDC_CFG(6),
> +			   ATMEL_HLCDC_PWMCVAL_MASK | ATMEL_HLCDC_PWMPS_MASK,
> +			   pwmcfg);
> +
> +	return 0;
> +}
> +
> +static int atmel_hlcdc_pwm_set_polarity(struct pwm_chip *c,
> +					struct pwm_device *pwm,
> +					enum pwm_polarity polarity)
> +{
> +	struct atmel_hlcdc_pwm_chip *chip =
> +				pwm_chip_to_atmel_hlcdc_pwm_chip(c);
> +	struct atmel_hlcdc *hlcdc = chip->hlcdc;
> +	u32 cfg = 0;
> +
> +	if (polarity == PWM_POLARITY_NORMAL)
> +		cfg = ATMEL_HLCDC_PWMPOL;
> +
> +	regmap_update_bits(hlcdc->regmap, ATMEL_HLCDC_CFG(6),
> +			   ATMEL_HLCDC_PWMPOL, cfg);
> +
> +	return 0;
> +}
> +
> +static int atmel_hlcdc_pwm_enable(struct pwm_chip *c,
> +				  struct pwm_device *pwm)
> +{
> +	struct atmel_hlcdc_pwm_chip *chip =
> +				pwm_chip_to_atmel_hlcdc_pwm_chip(c);
> +	struct atmel_hlcdc *hlcdc = chip->hlcdc;
> +	u32 status;
> +
> +	regmap_write(hlcdc->regmap, ATMEL_HLCDC_EN, ATMEL_HLCDC_PWM);
> +	while (!regmap_read(hlcdc->regmap, ATMEL_HLCDC_SR, &status) &&
> +	       !(status & ATMEL_HLCDC_PWM))
> +		cpu_relax();
> +
> +	return 0;
> +}
> +
> +static void atmel_hlcdc_pwm_disable(struct pwm_chip *c,
> +				    struct pwm_device *pwm)
> +{
> +	struct atmel_hlcdc_pwm_chip *chip =
> +				pwm_chip_to_atmel_hlcdc_pwm_chip(c);
> +	struct atmel_hlcdc *hlcdc = chip->hlcdc;
> +	u32 status;
> +
> +	regmap_write(hlcdc->regmap, ATMEL_HLCDC_DIS, ATMEL_HLCDC_PWM);
> +	while (!regmap_read(hlcdc->regmap, ATMEL_HLCDC_SR, &status) &&
> +	       (status & ATMEL_HLCDC_PWM))
> +		cpu_relax();
> +}
> +
> +static const struct pwm_ops atmel_hlcdc_pwm_ops = {
> +	.config = atmel_hlcdc_pwm_config,
> +	.set_polarity = atmel_hlcdc_pwm_set_polarity,
> +	.enable = atmel_hlcdc_pwm_enable,
> +	.disable = atmel_hlcdc_pwm_disable,
> +	.owner = THIS_MODULE,
> +};
> +
> +static int atmel_hlcdc_pwm_probe(struct platform_device *pdev)
> +{
> +	struct atmel_hlcdc_pwm_chip *chip;
> +	struct device *dev = &pdev->dev;
> +	int ret;
> +
> +	chip = devm_kzalloc(dev, sizeof(*chip), GFP_KERNEL);
> +	if (!chip)
> +		return -ENOMEM;
> +
> +	chip->hlcdc = dev_get_drvdata(dev->parent);
> +	chip->chip.ops = &atmel_hlcdc_pwm_ops;
> +	chip->chip.dev = dev;
> +	chip->chip.base = -1;
> +	chip->chip.npwm = 1;
> +	chip->chip.of_xlate = of_pwm_xlate_with_flags;
> +	chip->chip.of_pwm_n_cells = 3;
> +	chip->chip.can_sleep = 1;
> +
> +	ret = pwmchip_add(&chip->chip);
> +	if (ret)
> +		return ret;
> +
> +	platform_set_drvdata(pdev, chip);
> +
> +	return 0;
> +}
> +
> +static int atmel_hlcdc_pwm_remove(struct platform_device *pdev)
> +{
> +	struct atmel_hlcdc_pwm_chip *chip = platform_get_drvdata(pdev);
> +
> +	return pwmchip_remove(&chip->chip);
> +}
> +
> +static const struct of_device_id atmel_hlcdc_pwm_dt_ids[] = {
> +	{ .compatible = "atmel,hlcdc-pwm" },
> +	{ /* sentinel */ },
> +};
> +
> +static struct platform_driver atmel_hlcdc_pwm_driver = {
> +	.driver = {
> +		.name = "atmel-hlcdc-pwm",
> +		.of_match_table = atmel_hlcdc_pwm_dt_ids,
> +	},
> +	.probe = atmel_hlcdc_pwm_probe,
> +	.remove = atmel_hlcdc_pwm_remove,
> +};
> +module_platform_driver(atmel_hlcdc_pwm_driver);
> +
> +MODULE_ALIAS("platform:atmel-hlcdc-pwm");
> +MODULE_AUTHOR("Boris Brezillon <boris.brezillon@free-electrons.com>");
> +MODULE_DESCRIPTION("Atmel HLCDC PWM driver");
> +MODULE_LICENSE("GPL");
> 
