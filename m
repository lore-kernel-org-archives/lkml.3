Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbaKTOdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 09:33:52 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:48096 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887AbaKTOdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:33:51 -0500
MIME-Version: 1.0
In-Reply-To: <1416490300-28865-2-git-send-email-jaewon02.kim@samsung.com>
References: <1416490300-28865-1-git-send-email-jaewon02.kim@samsung.com> <1416490300-28865-2-git-send-email-jaewon02.kim@samsung.com>
From: Pankaj Dubey <pankaj.dubey@samsung.com>
Date: Thu, 20 Nov 2014 20:03:29 +0530
X-Google-Sender-Auth: bfXuWbj4U9ylJ2jWeyT8fZ9CmFc
Message-ID: <CAGcde9HNGDbm8sNHjyJ-PW75o0eaH1w6KtsOsQx6kDjVqxch5Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] Input: add regulator haptic driver
To: Jaewon Kim <jaewon02.kim@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Hyunhee Kim <hyunhee.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaewon,

On 20 November 2014 19:01, Jaewon Kim <jaewon02.kim@samsung.com> wrote:
> This patch adds support for haptic driver controlled by
> voltage of regulator. And this driver support for
> Force Feedback interface from input framework
>
> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
> Signed-off-by: Hyunhee Kim <hyunhee.kim@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  .../devicetree/bindings/input/regulator-haptic.txt |   24 ++
>  drivers/input/misc/Kconfig                         |   11 +
>  drivers/input/misc/Makefile                        |    1 +
>  drivers/input/misc/regulator-haptic.c              |  241 ++++++++++++++++++++
>  4 files changed, 277 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/input/regulator-haptic.txt
>  create mode 100644 drivers/input/misc/regulator-haptic.c
>
> diff --git a/Documentation/devicetree/bindings/input/regulator-haptic.txt b/Documentation/devicetree/bindings/input/regulator-haptic.txt
> new file mode 100644
> index 0000000..9f60e17
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/regulator-haptic.txt
> @@ -0,0 +1,24 @@
> +* Requlator Haptic Device Tree Bindings
> +
> +The regulator haptic driver controlled by voltage of regulator.
> +This driver implemented via Force Feedback interface.
> +
> +Required Properties:
> + - compatible : Should be "regulator-haptic"
> + - haptic-supply : Power supply for the haptic motor.
> +       [*] refer Documentation/devicetree/bindings/regulator/regulator.txt
> +
> + - max-microvolt : The maximum voltage value supplied to haptic motor.
> +               [The unit of the voltage is a micro]
> +
> + - min-microvolt : The minimum voltage value in which haptic motor reacts.
> +               [The unit of the voltage is a micro]
> +
> +Example:
> +
> +       regulator-haptic {
> +               compatible = "regulator-haptic";
> +               haptic-supply = <&motor_regulator>;
> +               max-microvolt = <2700000>;
> +               min-microvolt = <1100000>;
> +       };
> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> index 23297ab..e5e556d 100644
> --- a/drivers/input/misc/Kconfig
> +++ b/drivers/input/misc/Kconfig
> @@ -394,6 +394,17 @@ config INPUT_CM109
>           To compile this driver as a module, choose M here: the module will be
>           called cm109.
>
> +config INPUT_REGULATOR_HAPTIC
> +       tristate "regulator haptics support"
> +       select INPUT_FF_MEMLESS
> +       help
> +         This option enables device driver support for the haptic controlled
> +         by regulator. This driver supports ff-memless interface
> +         from input framework.
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called regulator-haptic.
> +
>  config INPUT_RETU_PWRBUTTON
>         tristate "Retu Power button Driver"
>         depends on MFD_RETU
> diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
> index 19c7603..1f135af 100644
> --- a/drivers/input/misc/Makefile
> +++ b/drivers/input/misc/Makefile
> @@ -53,6 +53,7 @@ obj-$(CONFIG_INPUT_PMIC8XXX_PWRKEY)   += pmic8xxx-pwrkey.o
>  obj-$(CONFIG_INPUT_POWERMATE)          += powermate.o
>  obj-$(CONFIG_INPUT_PWM_BEEPER)         += pwm-beeper.o
>  obj-$(CONFIG_INPUT_RB532_BUTTON)       += rb532_button.o
> +obj-$(CONFIG_INPUT_REGULATOR_HAPTIC)   += regulator-haptic.o
>  obj-$(CONFIG_INPUT_RETU_PWRBUTTON)     += retu-pwrbutton.o
>  obj-$(CONFIG_INPUT_GPIO_ROTARY_ENCODER)        += rotary_encoder.o
>  obj-$(CONFIG_INPUT_SGI_BTNS)           += sgi_btns.o
> diff --git a/drivers/input/misc/regulator-haptic.c b/drivers/input/misc/regulator-haptic.c
> new file mode 100644
> index 0000000..1a83ecb
> --- /dev/null
> +++ b/drivers/input/misc/regulator-haptic.c
> @@ -0,0 +1,241 @@
> +/*
> + * Regulator haptic driver
> + *
> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
> + * Author: Jaewon Kim <jaewon02.kim@samsung.com>
> + * Author: Hyunhee Kim <hyunhee.kim@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/input.h>
> +#include <linux/slab.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/of.h>
> +
> +#define MAX_MAGNITUDE_SHIFT    16
> +
> +struct regulator_haptic {
> +       struct device *dev;
> +       struct input_dev *input_dev;
> +       struct regulator *regulator;
> +       struct work_struct work;
> +
> +       bool enabled;
> +       bool suspend_state;
> +       unsigned int max_volt;
> +       unsigned int min_volt;
> +       unsigned int intensity;
> +       unsigned int magnitude;
> +};
> +
> +static void regulator_haptic_enable(struct regulator_haptic *haptic)
> +{
> +       int error;
> +
> +       if (haptic->enabled)
> +               return;
> +
> +       error = regulator_enable(haptic->regulator);
> +       if (error) {
> +               dev_err(haptic->dev, "cannot enable regulator\n");
> +               return;
> +       }
> +
> +       haptic->enabled = true;
> +}
> +
> +static void regulator_haptic_disable(struct regulator_haptic *haptic)
> +{
> +       int error;
> +
> +       if (!haptic->enabled)
> +               return;
> +
> +       error = regulator_disable(haptic->regulator);
> +       if (error) {
> +               dev_err(haptic->dev, "cannot disable regulator\n");
> +               return;
> +       }
> +
> +       haptic->enabled = false;
> +}
> +
> +static void regulator_haptic_work(struct work_struct *work)
> +{
> +       struct regulator_haptic *haptic = container_of(work,
> +                                       struct regulator_haptic, work);
> +       int error;
> +
> +       error = regulator_set_voltage(haptic->regulator,
> +                       haptic->intensity + haptic->min_volt, haptic->max_volt);
> +       if (error) {
> +               dev_err(haptic->dev, "cannot set regulator voltage\n");
> +               return;
> +       }
> +
> +       if (haptic->magnitude)
> +               regulator_haptic_enable(haptic);
> +       else
> +               regulator_haptic_disable(haptic);
> +}
> +
> +static int regulator_haptic_play_effect(struct input_dev *input, void *data,
> +                                       struct ff_effect *effect)
> +{
> +       struct regulator_haptic *haptic = input_get_drvdata(input);
> +       u64 volt_mag_multi;
> +
> +       haptic->magnitude = effect->u.rumble.strong_magnitude;
> +       if (!haptic->magnitude)
> +               haptic->magnitude = effect->u.rumble.weak_magnitude;
> +
> +
> +       volt_mag_multi = (u64)(haptic->max_volt - haptic->min_volt) *
> +                                       haptic->magnitude;
> +       haptic->intensity = (unsigned int)(volt_mag_multi >>
> +                                       MAX_MAGNITUDE_SHIFT);
> +
> +       schedule_work(&haptic->work);
> +
> +       return 0;
> +}
> +
> +static void regulator_haptic_close(struct input_dev *input)
> +{
> +       struct regulator_haptic *haptic = input_get_drvdata(input);
> +
> +       cancel_work_sync(&haptic->work);
> +       regulator_haptic_disable(haptic);
> +}
> +
> +static int regulator_haptic_parse_dt(struct regulator_haptic *haptic)
> +{
> +       struct device_node *node = haptic->dev->of_node;
> +       int error;
> +
> +       error = of_property_read_u32(node, "max-microvolt", &haptic->max_volt);
> +       if (error) {
> +               dev_err(haptic->dev, "cannot parse max-microvolt\n");
> +               return error;
> +       }
> +
> +       error = of_property_read_u32(node, "min-microvolt", &haptic->min_volt);
> +       if (error) {
> +               dev_err(haptic->dev, "cannot parse min-microvolt\n");
> +               return error;
> +       }
> +
> +       return 0;
> +}
> +
> +static int regulator_haptic_probe(struct platform_device *pdev)
> +{
> +       struct regulator_haptic *haptic;
> +       struct input_dev *input_dev;
> +       int error;
> +
> +       haptic = devm_kzalloc(&pdev->dev, sizeof(*haptic), GFP_KERNEL);
> +       if (!haptic)
> +               return -ENOMEM;
> +
> +       haptic->dev = &pdev->dev;
> +       haptic->enabled = false;
> +       haptic->suspend_state = false;
> +       INIT_WORK(&haptic->work, regulator_haptic_work);
> +
> +       error = regulator_haptic_parse_dt(haptic);
> +       if (error) {
> +               dev_err(&pdev->dev, "failed to parse device tree\n");
> +               return error;
> +       }
> +
> +       haptic->regulator = devm_regulator_get(&pdev->dev, "haptic");
> +       if (IS_ERR(haptic->regulator)) {
> +               dev_err(&pdev->dev, "failed to get regulator\n");
> +               return PTR_ERR(haptic->regulator);
> +       }
> +
> +       input_dev = devm_input_allocate_device(&pdev->dev);
> +       if (!input_dev)
> +               return  -ENOMEM;
> +
> +       haptic->input_dev = input_dev;
> +       haptic->input_dev->name = "regulator-haptic";
> +       haptic->input_dev->dev.parent = &pdev->dev;
> +       haptic->input_dev->close = regulator_haptic_close;
> +       input_set_drvdata(haptic->input_dev, haptic);
> +       input_set_capability(haptic->input_dev, EV_FF, FF_RUMBLE);
> +
> +       error = input_ff_create_memless(input_dev, NULL,
> +                             regulator_haptic_play_effect);
> +       if (error) {
> +               dev_err(&pdev->dev, "failed to create force-feedback\n");
> +               return error;
> +       }
> +
> +       error = input_register_device(haptic->input_dev);
> +       if (error) {
> +               dev_err(&pdev->dev, "failed to register input device\n");
> +               return error;
> +       }
> +
> +       platform_set_drvdata(pdev, haptic);
> +
> +       return 0;
> +}
> +
> +static int __maybe_unused regulator_haptic_suspend(struct device *dev)
> +{
> +       struct platform_device *pdev = to_platform_device(dev);
> +       struct regulator_haptic *haptic = platform_get_drvdata(pdev);
> +
> +       if (haptic->enabled) {
> +               regulator_haptic_disable(haptic);
> +               haptic->suspend_state = true;
> +       }
> +
> +       return 0;
> +}
> +
> +static int __maybe_unused regulator_haptic_resume(struct device *dev)
> +{
> +       struct platform_device *pdev = to_platform_device(dev);
> +       struct regulator_haptic *haptic = platform_get_drvdata(pdev);
> +
> +       if (haptic->enabled) {
> +               regulator_haptic_enable(haptic);
> +               haptic->suspend_state = false;
> +       }
> +
> +       return 0;
> +}
> +
> +static SIMPLE_DEV_PM_OPS(regulator_haptic_pm_ops,
> +               regulator_haptic_suspend, regulator_haptic_resume);
> +
> +static struct of_device_id regulator_haptic_dt_match[] = {
> +       { .compatible = "regulator-haptic" },
> +       {},
> +};
> +
> +static struct platform_driver regulator_haptic_driver = {
> +       .probe          = regulator_haptic_probe,
> +       .driver         = {
> +               .name           = "regulator-haptic",
> +               .owner          = THIS_MODULE,

.owner is no more required for drivers using module_platform_driver()

Thanks,
Pankaj Dubey

> +               .of_match_table = regulator_haptic_dt_match,
> +               .pm             = &regulator_haptic_pm_ops,
> +       },
> +};
> +module_platform_driver(regulator_haptic_driver);
> +
> +MODULE_AUTHOR("Jaewon Kim <jaewon02.kim@samsung.com>");
> +MODULE_AUTHOR("Hyunhee Kim <hyunhee.kim@samsung.com>");
> +MODULE_ALIAS("platform:regulator-haptic");
> +MODULE_DESCRIPTION("Regulator haptic driver");
> +MODULE_LICENSE("GPL");
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
