Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715AbaFMMRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 08:17:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45412 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750817AbaFMMRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 08:17:19 -0400
Message-ID: <539AEBCB.8010605@free-electrons.com>
Date: Fri, 13 Jun 2014 14:17:15 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        David Airlie <airlied@linux.ie>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2 2/7] pwm: add support for atmel-hlcdc-pwm device
References: <1402329860-27520-1-git-send-email-boris.brezillon@free-electrons.com> <1402329860-27520-3-git-send-email-boris.brezillon@free-electrons.com> <20140613114318.GR3429@piout.net>
In-Reply-To: <20140613114318.GR3429@piout.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alexandre,

On 13/06/2014 13:43, Alexandre Belloni wrote:
> On 09/06/2014 at 18:04:15 +0200, Boris Brezillon wrote :
>> The HLCDC IP available in some Atmel SoCs (i.e. sam9x5i.e. at91sam9n12,
>> at91sam9x5 family or sama5d3 family) provide a PWM device.
>>
>> This driver add support for this PWM device.
>>
>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> ---
>>  .../devicetree/bindings/pwm/atmel-hlcdc-pwm.txt    |  40 ++++
> Please separate the DT bindings documentation from the driver code.

I'll do it.

>
>>  drivers/pwm/Kconfig                                |   9 +
>>  drivers/pwm/Makefile                               |   1 +
>>  drivers/pwm/pwm-atmel-hlcdc.c                      | 216 +++++++++++++++++++++
>>  4 files changed, 266 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt
>>  create mode 100644 drivers/pwm/pwm-atmel-hlcdc.c
>>
>> diff --git a/Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt b/Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt
>> new file mode 100644
>> index 0000000..5e2ba87
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt
>> @@ -0,0 +1,40 @@
>> +Device-Tree bindings for Atmel's HLCDC (High LCD Controller) PWM driver
>> +
>> +The Atmel HLCDC PWM is subdevice of the HLCDC MFD device.
>> +See Documentation/devicetree/bindings/mfd/atmel-hlcdc.txt for more details.
>> +
>> +Required properties:
>> + - compatible: value should be one of the following:
>> +   "atmel,hlcdc-pwm"
>> + - pinctr-names: the pin control state names. Should contain "default".
>> + - pinctrl-0: should contain the pinctrl states described by pinctrl
>> +   default.
>> + - #pwm-cells: should be set to 3.
>> +
>> +Example:
>> +
>> +	hlcdc: hlcdc@f0030000 {
>> +		compatible = "atmel,sama5d3-hlcdc";
>> +		reg = <0xf0030000 0x2000>;
>> +		clocks = <&lcdc_clk>, <&lcdck>, <&clk32k>;
>> +		clock-names = "periph_clk","sys_clk", "slow_clk";
>> +		status = "disabled";
>> +
>> +		hlcdc-display-controller {
>> +			compatible = "atmel,hlcdc-dc";
>> +			interrupts = <36 IRQ_TYPE_LEVEL_HIGH 0>;
>> +			pinctrl-names = "default", "rgb-444", "rgb-565", "rgb-666", "rgb-888";
>> +			pinctrl-0 = <&pinctrl_lcd_base>;
>> +			pinctrl-1 = <&pinctrl_lcd_base &pinctrl_lcd_rgb444>;
>> +			pinctrl-2 = <&pinctrl_lcd_base &pinctrl_lcd_rgb565>;
>> +			pinctrl-3 = <&pinctrl_lcd_base &pinctrl_lcd_rgb666>;
>> +			pinctrl-4 = <&pinctrl_lcd_base &pinctrl_lcd_rgb888>;
>> +		};
>> +
>> +		hlcdc_pwm: hlcdc-pwm {
>> +			compatible = "atmel,hlcdc-pwm";
>> +			pinctrl-names = "default";
>> +			pinctrl-0 = <&pinctrl_lcd_pwm>;
>> +			#pwm-cells = <3>;
>> +		};
>> +	};
>> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
>> index 5b34ff2..7186242 100644
>> --- a/drivers/pwm/Kconfig
>> +++ b/drivers/pwm/Kconfig
>> @@ -50,6 +50,15 @@ config PWM_ATMEL
>>  	  To compile this driver as a module, choose M here: the module
>>  	  will be called pwm-atmel.
>>  
>> +config PWM_ATMEL_HLCDC_PWM
>> +	tristate "Atmel HLCDC PWM support"
>> +	depends on MFD_ATMEL_HLCDC
>> +	help
>> +	  Generic PWM framework driver for Atmel HLCDC PWM.
>> +
>> +	  To compile this driver as a module, choose M here: the module
>> +	  will be called pwm-atmel.
>> +
>>  config PWM_ATMEL_TCB
>>  	tristate "Atmel TC Block PWM support"
>>  	depends on ATMEL_TCLIB && OF
>> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
>> index e57d2c3..a245519 100644
>> --- a/drivers/pwm/Makefile
>> +++ b/drivers/pwm/Makefile
>> @@ -2,6 +2,7 @@ obj-$(CONFIG_PWM)		+= core.o
>>  obj-$(CONFIG_PWM_SYSFS)		+= sysfs.o
>>  obj-$(CONFIG_PWM_AB8500)	+= pwm-ab8500.o
>>  obj-$(CONFIG_PWM_ATMEL)		+= pwm-atmel.o
>> +obj-$(CONFIG_PWM_ATMEL_HLCDC_PWM)	+= pwm-atmel-hlcdc.o
>>  obj-$(CONFIG_PWM_ATMEL_TCB)	+= pwm-atmel-tcb.o
>>  obj-$(CONFIG_PWM_BFIN)		+= pwm-bfin.o
>>  obj-$(CONFIG_PWM_CLPS711X)	+= pwm-clps711x.o
>> diff --git a/drivers/pwm/pwm-atmel-hlcdc.c b/drivers/pwm/pwm-atmel-hlcdc.c
>> new file mode 100644
>> index 0000000..080e43e
>> --- /dev/null
>> +++ b/drivers/pwm/pwm-atmel-hlcdc.c
>> @@ -0,0 +1,216 @@
>> +/*
>> + * Copyright (C) 2014 Free Electrons
>> + * Copyright (C) 2014 Atmel
>> + *
>> + * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2 as published by
>> + * the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License along with
>> + * this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include <linux/mfd/atmel-hlcdc.h>
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/pwm.h>
>> +
>> +#define ATMEL_HLCDC_PWMCVAL_MASK	(0xff << 8)
> Maybe you could use GENMASK()

IMHO this does not help in understanding the code (I even find it more
tricky to figure out what the mask is), but if other people think we
should use GENMASK, then I'll use to it.

>
>> +#define ATMEL_HLCDC_PWMCVAL(x)		(((x) & 0xff) << 8)
> Maybe use ATMEL_HLCDC_PWMCVAL_MASK here ?

Absolutely, I'll replace 0xff by ATMEL_HLCDC_PWMCVAL_MASK.

>
>> +#define ATMEL_HLCDC_PWMPOL		BIT(4)
>> +#define ATMEL_HLCDC_PWMPS_MASK		0x7
> ditto


>
>> +#define ATMEL_HLCDC_PWMPS_MAX		0x6
>> +#define ATMEL_HLCDC_PWMPS(x)		((x) & 0x7)
> Why not using ATMEL_HLCDC_PWMPS_MASK here ?
>
>> +
>> +struct atmel_hlcdc_pwm_chip {
>> +	struct pwm_chip chip;
>> +	struct atmel_hlcdc *hlcdc;
>> +	struct clk *cur_clk;
>> +};
>> +
>> +static inline struct atmel_hlcdc_pwm_chip *
>> +pwm_chip_to_atmel_hlcdc_pwm_chip(struct pwm_chip *chip)
>> +{
>> +	return container_of(chip, struct atmel_hlcdc_pwm_chip, chip);
>> +}
>> +
>> +static int atmel_hlcdc_pwm_config(struct pwm_chip *c,
>> +				  struct pwm_device *pwm,
>> +				  int duty_ns, int period_ns)
>> +{
>> +	struct atmel_hlcdc_pwm_chip *chip =
>> +				pwm_chip_to_atmel_hlcdc_pwm_chip(c);
>> +	struct atmel_hlcdc *hlcdc = chip->hlcdc;
>> +	struct clk *new_clk = hlcdc->slow_clk;
>> +	u64 pwmcval = duty_ns * 256;
>> +	unsigned long clk_freq;
>> +	u64 clk_period_ns;
>> +	u32 pwmcfg;
>> +	int pres;
>> +
>> +	clk_freq = clk_get_rate(new_clk);
>> +	clk_period_ns = 1000000000;
>> +	clk_period_ns *= 256;
>> +	do_div(clk_period_ns, clk_freq);
>> +
>> +	if (clk_period_ns > period_ns) {
>> +		new_clk = hlcdc->sys_clk;
>> +		clk_freq = clk_get_rate(new_clk);
>> +		clk_period_ns = 1000000000;
>> +		clk_period_ns *= 256;
>> +		do_div(clk_period_ns, clk_freq);
>> +	}
>> +
>> +	for (pres = ATMEL_HLCDC_PWMPS_MAX; pres >= 0; pres--) {
>> +		if ((clk_period_ns << pres) <= period_ns)
>> +			break;
>> +	}
>> +
>> +	if (pres > ATMEL_HLCDC_PWMPS_MAX)
>> +		return -EINVAL;
>> +
>> +	pwmcfg = ATMEL_HLCDC_PWMPS(pres);
>> +
>> +	if (new_clk != chip->cur_clk) {
>> +		u32 gencfg = 0;
>> +
>> +		clk_prepare_enable(new_clk);
>> +		clk_disable_unprepare(chip->cur_clk);
>> +		chip->cur_clk = new_clk;
>> +
>> +		if (new_clk != hlcdc->slow_clk)
>> +			gencfg = ATMEL_HLCDC_CLKPWMSEL;
>> +		regmap_update_bits(hlcdc->regmap, ATMEL_HLCDC_CFG(0),
>> +				   ATMEL_HLCDC_CLKPWMSEL, gencfg);
>> +	}
>> +
>> +	do_div(pwmcval, period_ns);
>> +	if (pwmcval > 255)
>> +		pwmcval = 255;
>> +
>> +	pwmcfg |= ATMEL_HLCDC_PWMCVAL(pwmcval);
>> +
>> +	regmap_update_bits(hlcdc->regmap, ATMEL_HLCDC_CFG(6),
>> +			   ATMEL_HLCDC_PWMCVAL_MASK | ATMEL_HLCDC_PWMPS_MASK,
>> +			   pwmcfg);
>> +
>> +	return 0;
>> +}
>> +
>> +static int atmel_hlcdc_pwm_set_polarity(struct pwm_chip *c,
>> +					struct pwm_device *pwm,
>> +					enum pwm_polarity polarity)
>> +{
>> +	struct atmel_hlcdc_pwm_chip *chip =
>> +				pwm_chip_to_atmel_hlcdc_pwm_chip(c);
>> +	struct atmel_hlcdc *hlcdc = chip->hlcdc;
>> +	u32 cfg = 0;
>> +
>> +	if (polarity == PWM_POLARITY_NORMAL)
>> +		cfg = ATMEL_HLCDC_PWMPOL;
>> +
>> +	regmap_update_bits(hlcdc->regmap, ATMEL_HLCDC_CFG(6),
>> +			   ATMEL_HLCDC_PWMPOL, cfg);
>> +
>> +	return 0;
>> +}
>> +
>> +static int atmel_hlcdc_pwm_enable(struct pwm_chip *c,
>> +				  struct pwm_device *pwm)
>> +{
>> +	struct atmel_hlcdc_pwm_chip *chip =
>> +				pwm_chip_to_atmel_hlcdc_pwm_chip(c);
>> +	struct atmel_hlcdc *hlcdc = chip->hlcdc;
>> +	u32 status;
>> +
>> +	regmap_write(hlcdc->regmap, ATMEL_HLCDC_EN, ATMEL_HLCDC_PWM);
>> +	while (!regmap_read(hlcdc->regmap, ATMEL_HLCDC_SR, &status) &&
>> +	       !(status & ATMEL_HLCDC_PWM))
>> +		cpu_relax();
>> +
> I'm not sure you have to wait here, it will be enabled at some point,
> that is enough.

Okay.

>
>> +	return 0;
>> +}
>> +
>> +static void atmel_hlcdc_pwm_disable(struct pwm_chip *c,
>> +				    struct pwm_device *pwm)
>> +{
>> +	struct atmel_hlcdc_pwm_chip *chip =
>> +				pwm_chip_to_atmel_hlcdc_pwm_chip(c);
>> +	struct atmel_hlcdc *hlcdc = chip->hlcdc;
>> +	u32 status;
>> +
>> +	regmap_write(hlcdc->regmap, ATMEL_HLCDC_DIS, ATMEL_HLCDC_PWM);
>> +	while (!regmap_read(hlcdc->regmap, ATMEL_HLCDC_SR, &status) &&
>> +	       (status & ATMEL_HLCDC_PWM))
>> +		cpu_relax();
> Ditto
>
>> +}
>> +
>> +static const struct pwm_ops atmel_hlcdc_pwm_ops = {
>> +	.config = atmel_hlcdc_pwm_config,

Thanks for your review.

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

