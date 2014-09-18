Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbaIRVZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 17:25:23 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:58350 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbaIRVZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 17:25:20 -0400
MIME-Version: 1.0
In-Reply-To: <1411025505-21628-2-git-send-email-zyw@rock-chips.com>
References: <1411025505-21628-1-git-send-email-zyw@rock-chips.com>
	<1411025505-21628-2-git-send-email-zyw@rock-chips.com>
Date: Thu, 18 Sep 2014 14:25:18 -0700
X-Google-Sender-Auth: Wd_xsIZUfrhkacST98fjRvE990c
Message-ID: <CAD=FV=VjnHFXL64Diua3-DmUjt29JujiS-oCpB5d9mj+cqLcSA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] regulator: st-pwm: get voltage and duty table from dts
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Tao Huang <huangtao@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        zhangqing <zhangqing@rock-chips.com>, Lee Jones <lee.jones@linaro.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Thu, Sep 18, 2014 at 12:31 AM, Chris Zhong <zyw@rock-chips.com> wrote:
> Get voltage & duty table from device tree might be better, other platforms can also use this
> driver without any modify.
>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>
> eries-changes: 2
> Adviced by Lee Jones
> - rename the file
> - remove all the prefix st_
> - add depend on PWM in Kconfig
> ---
>
> Changes in v2: None
>
>  drivers/regulator/Kconfig         |    8 +-
>  drivers/regulator/Makefile        |    2 +-
>  drivers/regulator/pwm-regulator.c |  195 +++++++++++++++++++++++++++++++++++++
>  drivers/regulator/st-pwm.c        |  190 ------------------------------------
>  4 files changed, 200 insertions(+), 195 deletions(-)
>  create mode 100644 drivers/regulator/pwm-regulator.c
>  delete mode 100644 drivers/regulator/st-pwm.c
>
> diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
> index fb32bab..4b17d75 100644
> --- a/drivers/regulator/Kconfig
> +++ b/drivers/regulator/Kconfig
> @@ -493,11 +493,11 @@ config REGULATOR_S5M8767
>          via I2C bus. S5M8767A have 9 Bucks and 28 LDOs output and
>          supports DVS mode with 8bits of output voltage control.
>
> -config REGULATOR_ST_PWM
> -       tristate "STMicroelectronics PWM voltage regulator"
> -       depends on ARCH_STI
> +config REGULATOR_PWM
> +       tristate "PWM voltage regulator"
> +       depends on PWM
>         help
> -        This driver supports ST's PWM controlled voltage regulators.
> +        This driver supports PWM controlled voltage regulators.

nit: with the rename you probably need to move this up so it's alphabetical.


>  config REGULATOR_TI_ABB
>         tristate "TI Adaptive Body Bias on-chip LDO"
> diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
> index 236fdbb..3954fbd 100644
> --- a/drivers/regulator/Makefile
> +++ b/drivers/regulator/Makefile
> @@ -66,7 +66,7 @@ obj-$(CONFIG_REGULATOR_RK808)   += rk808-regulator.o
>  obj-$(CONFIG_REGULATOR_S2MPA01) += s2mpa01.o
>  obj-$(CONFIG_REGULATOR_S2MPS11) += s2mps11.o
>  obj-$(CONFIG_REGULATOR_S5M8767) += s5m8767.o
> -obj-$(CONFIG_REGULATOR_ST_PWM) += st-pwm.o
> +obj-$(CONFIG_REGULATOR_PWM) += pwm-regulator.o

Same here.  Make it alphabetical.


>  obj-$(CONFIG_REGULATOR_STW481X_VMMC) += stw481x-vmmc.o
>  obj-$(CONFIG_REGULATOR_TI_ABB) += ti-abb-regulator.o
>  obj-$(CONFIG_REGULATOR_TPS6105X) += tps6105x-regulator.o
> diff --git a/drivers/regulator/pwm-regulator.c b/drivers/regulator/pwm-regulator.c
> new file mode 100644
> index 0000000..ea5b3d4
> --- /dev/null
> +++ b/drivers/regulator/pwm-regulator.c
> @@ -0,0 +1,195 @@
> +/*
> + * Regulator driver for PWM Regulators
> + *
> + * Copyright (C) 2014 - STMicroelectronics Inc.
> + *
> + * Author: Lee Jones <lee.jones@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/err.h>
> +#include <linux/regulator/driver.h>
> +#include <linux/regulator/machine.h>
> +#include <linux/regulator/of_regulator.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/pwm.h>
> +
> +struct pwm_regulator_data {
> +       struct regulator_desc *desc;
> +       struct pwm_voltages *duty_cycle_table;
> +       struct pwm_device *pwm;
> +       int pwm_reg_period;

pwm_reg_period is "unsigned int".

Technically you could probably leave this out of the structure and
just call pwm_get_period() whenever you need the period.


> +       bool enabled;
> +       int state;
> +};
> +
> +struct pwm_voltages {
> +       unsigned int uV;
> +       unsigned int dutycycle;
> +};
> +
> +static int pwm_regulator_get_voltage_sel(struct regulator_dev *dev)
> +{
> +       struct pwm_regulator_data *drvdata = rdev_get_drvdata(dev);
> +
> +       return drvdata->state;
> +}
> +
> +static int pwm_regulator_set_voltage_sel(struct regulator_dev *dev,
> +                                        unsigned selector)
> +{
> +       struct pwm_regulator_data *drvdata = rdev_get_drvdata(dev);
> +       int dutycycle;
> +       int ret;
> +
> +       dutycycle = (drvdata->pwm_reg_period / 100) *
> +                   drvdata->duty_cycle_table[selector].dutycycle;

Nit: this is not a new bug for you, but I'd suggest making the above:

(drvdata->pwm_reg_period * drvdata->duty_cycle_table[selector].dutycycle) / 100

Specifically:

(8448 / 100) * 50 = 4200
(8448 * 50) / 100 = 4224

Since the duty cycle was specified as "8448" and not "8400" I'm going
to assume that the second calculation is more accurate.

If you're worried about overflow you could add a cast.

> +
> +       ret = pwm_config(drvdata->pwm, dutycycle, drvdata->pwm_reg_period);
> +       if (ret) {
> +               dev_err(&dev->dev, "Failed to configure PWM\n");
> +               return ret;
> +       }
> +
> +       drvdata->state = selector;
> +
> +       if (!drvdata->enabled) {
> +               ret = pwm_enable(drvdata->pwm);
> +               if (ret) {
> +                       dev_err(&dev->dev, "Failed to enable PWM\n");
> +                       return ret;
> +               }
> +               drvdata->enabled = true;
> +       }
> +
> +       return 0;
> +}
> +
> +static int pwm_regulator_list_voltage(struct regulator_dev *dev,
> +                                     unsigned selector)
> +{
> +       struct pwm_regulator_data *drvdata = rdev_get_drvdata(dev);
> +
> +       if (selector >= dev->desc->n_voltages)
> +               return -EINVAL;
> +
> +       return drvdata->duty_cycle_table[selector].uV;
> +}
> +
> +static struct regulator_ops pwm_regulator_voltage_ops = {
> +       .set_voltage_sel = pwm_regulator_set_voltage_sel,
> +       .get_voltage_sel = pwm_regulator_get_voltage_sel,
> +       .list_voltage    = pwm_regulator_list_voltage,
> +       .map_voltage     = regulator_map_voltage_iterate,
> +};
> +
> +static struct regulator_desc pwm_regulator_desc = {
> +       .name           = "pwm-regulator",
> +       .ops            = &pwm_regulator_voltage_ops,
> +       .type           = REGULATOR_VOLTAGE,
> +       .owner          = THIS_MODULE,
> +       .supply_name    = "pwm",
> +};
> +
> +static int pwm_regulator_probe(struct platform_device *pdev)
> +{
> +       struct pwm_regulator_data *drvdata;
> +       struct property *prop;
> +       struct regulator_dev *regulator;
> +       struct regulator_config config = { };
> +       struct device_node *np = pdev->dev.of_node;
> +       int length, ret;
> +
> +       if (!np) {
> +               dev_err(&pdev->dev, "Device Tree node missing\n");
> +               return -EINVAL;
> +       }
> +
> +       drvdata = devm_kzalloc(&pdev->dev, sizeof(*drvdata), GFP_KERNEL);
> +       if (!drvdata)
> +               return -ENOMEM;
> +
> +       drvdata->desc = &pwm_regulator_desc;

I think you need to make a copy of pwm_regulator_desc, don't you?  You
set "n_voltages" below.  If you don't make a copy I think that will
cause problems if you have two PWM regulators in your system with a
different number of voltages, right?


> +
> +       /* determine the number of voltage-table */
> +       prop = of_find_property(np, "voltage-table", &length);
> +       if (!prop)

Check for length < sizeof(*drvdata->duty_cycle_table) too?  And maybe
put an error message here?

...could also double check that length %
sizeof(*drvdata->duty_cycle_table) is 0?


> +               return -EINVAL;
> +
> +       drvdata->desc->n_voltages = length / sizeof(*drvdata->duty_cycle_table);
> +
> +       /* read voltage table from DT property */
> +       if (length > 0) {

Remove check for length here (since I suggested putting it above)


> +               size_t size = sizeof(*drvdata->duty_cycle_table) *
> +                             drvdata->desc->n_voltages;

Isn't "size" exactly equal to "length" (well, assuming we check that
length % sizeof(*drvdata->duty_cycle_table) is 0 above)?  No need to
calculate it again.

> +
> +               drvdata->duty_cycle_table = devm_kzalloc(&pdev->dev,
> +                                                        size, GFP_KERNEL);
> +               if (!drvdata->duty_cycle_table)
> +                       return -ENOMEM;
> +
> +               ret = of_property_read_u32_array(np, "voltage-table",
> +                               (u32 *)drvdata->duty_cycle_table,
> +                               length / sizeof(u32));
> +               if (ret < 0)
> +                       return ret;

Error message?

> +       }
> +
> +       config.init_data = of_get_regulator_init_data(&pdev->dev, np);
> +       if (!config.init_data)
> +               return -ENOMEM;
> +
> +       config.of_node = np;
> +       config.dev = &pdev->dev;
> +       config.driver_data = drvdata;
> +
> +       drvdata->pwm = devm_pwm_get(&pdev->dev, NULL);
> +       if (IS_ERR(drvdata->pwm)) {
> +               dev_err(&pdev->dev, "Failed to get PWM\n");
> +               return PTR_ERR(drvdata->pwm);
> +       }
> +
> +       drvdata->pwm_reg_period = pwm_get_period(drvdata->pwm);
> +       if (!drvdata->pwm_reg_period) {
> +               dev_err(&pdev->dev, "get pwm peeriod failed\n");

nit: s/peeriod/period

...actually, I'd personally just skip error checking here.  This is a
simple accessor function.  If the period is 0 it means someone
specified 0 in the device tree.  That will be caught in pwm_config()
and the error there is just as obvious (I think).


> +               return -EINVAL;
> +       }
> +
> +       regulator = devm_regulator_register(&pdev->dev,
> +                                           drvdata->desc, &config);
> +       if (IS_ERR(regulator)) {
> +               dev_err(&pdev->dev, "Failed to register regulator %s\n",
> +                       drvdata->desc->name);
> +               return PTR_ERR(regulator);
> +       }
> +
> +       return 0;
> +}
> +
> +static const struct of_device_id pwm_of_match[] = {
> +       { .compatible = "pwm-regulator" },
> +       { },
> +};
> +MODULE_DEVICE_TABLE(of, pwm_of_match);
> +
> +static struct platform_driver pwm_regulator_driver = {
> +       .driver = {
> +               .name           = "pwm-regulator",
> +               .owner          = THIS_MODULE,
> +               .of_match_table = of_match_ptr(pwm_of_match),
> +       },
> +       .probe = pwm_regulator_probe,
> +};
> +
> +module_platform_driver(pwm_regulator_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Lee Jones <lee.jones@linaro.org>");
> +MODULE_DESCRIPTION("PWM Regulator Driver");
> +MODULE_ALIAS("platform:pwm-regulator");

-Doug
