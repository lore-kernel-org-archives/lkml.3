Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaGJJqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:46:24 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:42393 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbaGJJqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:46:21 -0400
MIME-Version: 1.0
In-Reply-To: <1404505467-26526-9-git-send-email-javier.martinez@collabora.co.uk>
References: <1404505467-26526-1-git-send-email-javier.martinez@collabora.co.uk>
	<1404505467-26526-9-git-send-email-javier.martinez@collabora.co.uk>
Date: Thu, 10 Jul 2014 11:46:20 +0200
Message-ID: <CACRpkdYs93snBFYZMKN6kd==b9jZehnp1eHV5bHaBNsNRt62pQ@mail.gmail.com>
Subject: Re: [PATCH v7 08/24] mfd: max77686: Add Dynamic Voltage Scaling (DVS) support
From: Linus Walleij <linus.walleij@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Alessandro Zummo <a.zummo@towertech.it>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Tushar Behera <trblinux@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Andreas Farber <afaerber@suse.de>,
        Alexandre Courbot <gnurou@gmail.com>,
        Rob Jones <rob.jones@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 4, 2014 at 10:24 PM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:

> Some regulators on the MAX77686 PMIC have Dynamic Voltage Scaling
> (DVS) support that allows output voltage to change dynamically.
>
> For MAX77686, these regulators are Buck regulators 2, 3 and 4.
>
> Each Buck output voltage is selected using a set of external
> inputs: DVS1-3 and SELB2-4.
>
> DVS registers can be used to configure the output voltages for each
> Buck regulator and which one is active is controled by DVSx lines.
>
> SELBx lines are used to control if individual Buck lines are ON or OFF.
>
> This patch adds support to configure the DVSx and SELBx lines
> from DT and to setup and read the GPIO lines connected to them.
>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

(...)
> +#include <linux/gpio/consumer.h>

THANKS for using modern interfaces!

> +static void max77686_dt_parse_dvs_gpio(struct device *dev)
> +{
> +       struct max77686_platform_data *pd = dev_get_platdata(dev);
> +       int i;
> +
> +       /*
> +        * NOTE: we don't consider GPIO errors fatal; board may have some lines
> +        * directly pulled high or low and thus doesn't specify them.
> +        */
> +       for (i = 0; i < ARRAY_SIZE(pd->buck_gpio_dvs); i++)
> +               pd->buck_gpio_dvs[i] =
> +                       devm_gpiod_get_index(dev, "max77686,pmic-buck-dvs", i);
> +
> +       for (i = 0; i < ARRAY_SIZE(pd->buck_gpio_selb); i++)
> +               pd->buck_gpio_selb[i] =
> +                       devm_gpiod_get_index(dev, "max77686,pmic-buck-selb", i);
> +}

Rob Jones has a patch cooking that adds gpio_get_array() so this thing
merits also adding devm_gpiod_get_array() I think?

> +/**
> + * max77686_setup_gpios() - init DVS-related GPIOs
> + * @dev: device whose platform data contains the dvs GPIOs information
> + *
> + * This function claims / initalizations GPIOs related to DVS if they are
> + * defined. This may have the effect of switching voltages if the
> + * pdata->buck_default_idx does not match the boot time state of pins.
> + */
> +int max77686_setup_gpios(struct device *dev)
> +{
> +       struct max77686_platform_data *pd = dev_get_platdata(dev);
> +       int buck_default_idx = pd->buck_default_idx;
> +       int ret;
> +       int i;
> +
> +       /* Set all SELB high to avoid glitching while DVS is changing */
> +       for (i = 0; i < ARRAY_SIZE(pd->buck_gpio_selb); i++) {
> +               struct gpio_desc *gpio = pd->buck_gpio_selb[i];
> +
> +               /* OK if some GPIOs aren't defined */
> +               if (IS_ERR(gpio))
> +                       continue;
> +
> +               ret = gpiod_direction_output_raw(gpio, 1);

Why does this have to be raw? Usually that is not to be used.

Apart from this it looks OK.

Yours,
Linus Walleij
