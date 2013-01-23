Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab3AWKPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:15:55 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:61483 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab3AWKPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:15:50 -0500
MIME-Version: 1.0
In-Reply-To: <1358591420-7790-3-git-send-email-acourbot@nvidia.com>
References: <1358591420-7790-1-git-send-email-acourbot@nvidia.com> <1358591420-7790-3-git-send-email-acourbot@nvidia.com>
From: Leela Krishna Amudala <leelakrishna.a@gmail.com>
Date: Wed, 23 Jan 2013 15:45:30 +0530
Message-ID: <CAL1wa8d2BS3RxdsdUyCqF20ZKe46jUZcfUKitnpP9Lgb9aB5hw@mail.gmail.com>
Subject: Re: [PATCH 2/3] tegra: pwm-backlight: add tegra pwm-bl driver
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Mark Zhang <markz@nvidia.com>, gnurou@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alex,

On Sat, Jan 19, 2013 at 4:00 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>
> Add a PWM-backlight subdriver for Tegra boards, with support for
> Ventana.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  arch/arm/boot/dts/tegra20-ventana.dts  |  18 +++-
>  arch/arm/configs/tegra_defconfig       |   1 +
>  drivers/video/backlight/Kconfig        |   7 ++
>  drivers/video/backlight/pwm_bl.c       |   3 +
>  drivers/video/backlight/pwm_bl_tegra.c | 159
> +++++++++++++++++++++++++++++++++
>  5 files changed, 186 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/video/backlight/pwm_bl_tegra.c
>
> diff --git a/arch/arm/boot/dts/tegra20-ventana.dts
> b/arch/arm/boot/dts/tegra20-ventana.dts
> index adc4754..a77b529 100644
> --- a/arch/arm/boot/dts/tegra20-ventana.dts
> +++ b/arch/arm/boot/dts/tegra20-ventana.dts
> @@ -516,6 +516,20 @@
>                 bus-width = <8>;
>         };
>
> +       backlight {
> +               compatible = "pwm-backlight-ventana";
> +               brightness-levels = <0 16 32 48 64 80 96 112 128 144 160
> 176 192 208 224 240 255>;
> +               default-brightness-level = <12>;
> +
> +               pwms = <&pwm 2 5000000>;
> +               pwm-names = "backlight";
> +
> +               power-supply = <&vdd_bl_reg>;
> +               panel-supply = <&vdd_pnl_reg>;
> +               bl-gpio = <&gpio 28 0>;
> +               bl-panel = <&gpio 10 0>;
> +       };
> +
>         regulators {
>                 compatible = "simple-bus";
>                 #address-cells = <1>;
> @@ -549,7 +563,7 @@
>                         enable-active-high;
>                 };
>
> -               regulator@3 {
> +               vdd_pnl_reg: regulator@3 {
>                         compatible = "regulator-fixed";
>                         reg = <3>;
>                         regulator-name = "vdd_pnl";
> @@ -559,7 +573,7 @@
>                         enable-active-high;
>                 };
>
> -               regulator@4 {
> +               vdd_bl_reg: regulator@4 {
>                         compatible = "regulator-fixed";
>                         reg = <4>;
>                         regulator-name = "vdd_bl";
> diff --git a/arch/arm/configs/tegra_defconfig
> b/arch/arm/configs/tegra_defconfig
> index a7827fd..1c46602 100644
> --- a/arch/arm/configs/tegra_defconfig
> +++ b/arch/arm/configs/tegra_defconfig
> @@ -150,6 +150,7 @@ CONFIG_BACKLIGHT_LCD_SUPPORT=y
>  CONFIG_BACKLIGHT_CLASS_DEVICE=y
>  # CONFIG_BACKLIGHT_GENERIC is not set
>  CONFIG_BACKLIGHT_PWM=y
> +CONFIG_BACKLIGHT_PWM_TEGRA=y
>  CONFIG_FRAMEBUFFER_CONSOLE=y
>  CONFIG_LOGO=y
>  CONFIG_SOUND=y
> diff --git a/drivers/video/backlight/Kconfig
> b/drivers/video/backlight/Kconfig
> index 765a945..377a409 100644
> --- a/drivers/video/backlight/Kconfig
> +++ b/drivers/video/backlight/Kconfig
> @@ -244,6 +244,13 @@ config BACKLIGHT_PWM
>           If you have a LCD backlight adjustable by PWM, say Y to enable
>           this driver.
>
> +config BACKLIGHT_PWM_TEGRA
> +       bool "PWM Backlight Driver for Tegra boards"
> +       depends on BACKLIGHT_PWM && ARCH_TEGRA
> +       help
> +         Support backlight power sequencing for Tegra boards.
> +         Supported boards: Ventana.
> +
>  config BACKLIGHT_DA903X
>         tristate "Backlight Driver for DA9030/DA9034 using WLED"
>         depends on PMIC_DA903X
> diff --git a/drivers/video/backlight/pwm_bl.c
> b/drivers/video/backlight/pwm_bl.c
> index b65a797..1a4a9a3 100644
> --- a/drivers/video/backlight/pwm_bl.c
> +++ b/drivers/video/backlight/pwm_bl.c
> @@ -217,6 +217,9 @@ static int pwm_backlight_parse_dt(struct device *dev,
>
>  static struct of_device_id pwm_backlight_of_match[] = {
>         { .compatible = "pwm-backlight" },
> +#ifdef CONFIG_BACKLIGHT_PWM_TEGRA
> +       { .compatible = "pwm-backlight-ventana" },
> +#endif
>         { }
>  };
>
> diff --git a/drivers/video/backlight/pwm_bl_tegra.c
> b/drivers/video/backlight/pwm_bl_tegra.c
> new file mode 100644
> index 0000000..8f2195b
> --- /dev/null
> +++ b/drivers/video/backlight/pwm_bl_tegra.c
> @@ -0,0 +1,159 @@
> +/*
> + * pwm-backlight subdriver for Tegra.
> + *
> + * Copyright (c) 2013 NVIDIA CORPORATION.  All rights reserved.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +#include <linux/err.h>
> +#include <linux/module.h>
> +#include <linux/pwm_backlight.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/gpio.h>
> +#include <linux/of_gpio.h>
> +#include <linux/list.h>
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +
> +struct ventana_bl_data {
> +       struct regulator *vdd_power;
> +       struct regulator *vdd_panel;
> +       int bl_gpio;
> +       int panel_gpio;
> +       bool is_on;
> +};
> +
> +static int init_ventana(struct device *dev)
> +{
> +       struct ventana_bl_data *data;
> +       int ret;
> +
> +       data = devm_kzalloc(dev, sizeof(struct ventana_bl_data),
> GFP_KERNEL);
> +       if (!data)
> +               return -ENOMEM;
> +
> +       data->vdd_power = devm_regulator_get(dev, "power");
> +       if (IS_ERR(data->vdd_power)) {
> +               dev_err(dev, "cannot get power regulator!\n");
> +               return PTR_ERR(data->vdd_power);
> +       }
> +
> +       data->vdd_panel = devm_regulator_get(dev, "panel");
> +       if (IS_ERR(data->vdd_panel)) {
> +               dev_err(dev, "cannot get panel regulator!\n");
> +               return PTR_ERR(data->vdd_panel);
> +       }
> +
> +       ret = of_get_named_gpio(dev->of_node, "bl-gpio", 0);
> +       if (ret < 0) {
> +               dev_err(dev, "cannot find backlight GPIO!\n");
> +               return ret;
> +       }
> +       data->bl_gpio = ret;
> +
> +       ret = of_get_named_gpio(dev->of_node, "bl-panel", 0);
> +       if (ret < 0) {
> +               dev_err(dev, "cannot find panel GPIO!\n");
> +               return ret;
> +       }
> +       data->panel_gpio = ret;
> +
> +       ret = devm_gpio_request_one(dev, data->bl_gpio,
> +                                   GPIOF_DIR_OUT | GPIOF_OUT_INIT_LOW,
> +                                   "backlight");
> +       if (ret < 0) {
> +               dev_err(dev, "cannot request backlight GPIO!\n");
> +               return ret;
> +       }
> +
> +       ret = devm_gpio_request_one(dev, data->panel_gpio,
> +                                   GPIOF_DIR_OUT | GPIOF_OUT_INIT_LOW,
> +                                   "panel");
> +       if (ret < 0) {
> +               dev_err(dev, "cannot request panel GPIO!\n");
> +               return ret;
> +       }
> +
> +       pwm_backlight_set_subdriver_data(dev, data);

Here you are passing ventana_bl_data pointer as input and in the
pwm_backlight_get_subdriver_data() function you are assigning the
received driver data to backlight_device pointer. As both are two
different structures with different structure fields in it. There can
be a chance for a crash.

Please correct me if I'm wrong.

Best Wishes,
Leela Krishna Amudala.

> +
> +       return 0;
> +}
> +
> +static void exit_ventana(struct device *dev)
> +{
> +       struct ventana_bl_data *data =
> pwm_backlight_get_subdriver_data(dev);
> +
> +       devm_gpio_free(dev, data->panel_gpio);
> +       devm_gpio_free(dev, data->bl_gpio);
> +       devm_regulator_put(data->vdd_panel);
> +       devm_regulator_put(data->vdd_power);
> +       devm_kfree(dev, data);
> +}
> +
> +static int notify_ventana(struct device *dev, int brightness)
> +{
> +       struct ventana_bl_data *data =
> pwm_backlight_get_subdriver_data(dev);
> +       if (brightness && !data->is_on) {
> +               regulator_enable(data->vdd_panel);
> +               gpio_set_value(data->panel_gpio, 1);
> +               usleep_range(200000, 200000);
> +               regulator_enable(data->vdd_power);
> +               usleep_range(10000, 10000);
> +       } else if (!brightness && data->is_on) {
> +               gpio_set_value(data->bl_gpio, 0);
> +       }
> +
> +       return brightness;
> +}
> +
> +static void notify_after_ventana(struct device *dev, int brightness)
> +{
> +       struct ventana_bl_data *data =
> pwm_backlight_get_subdriver_data(dev);
> +       if (brightness && !data->is_on) {
> +               gpio_set_value(data->bl_gpio, 1);
> +               data->is_on = true;
> +       } else if (!brightness && data->is_on) {
> +               usleep_range(10000, 10000);
> +               regulator_disable(data->vdd_power);
> +               usleep_range(200000, 200000);
> +               gpio_set_value(data->panel_gpio, 0);
> +               regulator_disable(data->vdd_panel);
> +               data->is_on = false;
> +       }
> +}
> +
> +static struct pwm_backlight_subdriver pwm_backlight_ventana_subdriver = {
> +       .name = "pwm-backlight-ventana",
> +       .init = init_ventana,
> +       .exit = exit_ventana,
> +       .notify = notify_ventana,
> +       .notify_after = notify_after_ventana,
> +};
> +
> +static int __init pwm_backlight_tegra_init(void)
> +{
> +       pwm_backlight_add_subdriver(&pwm_backlight_ventana_subdriver);
> +       return 0;
> +}
> +
> +static void __exit pwm_backlight_tegra_exit(void)
> +{
> +       pwm_backlight_remove_subdriver(&pwm_backlight_ventana_subdriver);
> +}
> +
> +module_init(pwm_backlight_tegra_init);
> +module_exit(pwm_backlight_tegra_exit);
> +
> +MODULE_DESCRIPTION("Backlight Driver for Tegra boards");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:pwm-tegra-backlight");
> +
> +
> --
> 1.8.1.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
