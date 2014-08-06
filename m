Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbaHFNYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 09:24:51 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:55793 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbaHFNYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 09:24:49 -0400
MIME-Version: 1.0
In-Reply-To: <1407309129-5562-1-git-send-email-b20788@freescale.com>
References: <1407309129-5562-1-git-send-email-b20788@freescale.com>
Date: Wed, 6 Aug 2014 09:24:46 -0400
Message-ID: <CAC-25o8BiKHYAD6=_5xAP5L310bH_GjwVQpqBYC7UydvbaxeqQ@mail.gmail.com>
Subject: Re: [PATCH V3] Thermal: imx: add i.mx6sx thermal support
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Anson Huang <b20788@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Zhang Rui <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Anson,

On Wed, Aug 6, 2014 at 3:12 AM, Anson Huang <b20788@freescale.com> wrote:
> i.MX6SX has some new features of thermal interrupt function,
> there are LOW, HIGH and PANIC irq for thermal sensor, so add
> platform data to separate different thermal version;
>
> The reset value of LOW ALARM is 0 which means the highest
> temp, so the LOW ALARM will be triggered once irq is enabled,
> so we need to correct it before enabling thermal irq;
>
> Enable PANIC ALARM as critical trip point, it will trigger
> system reset via SRC module once PANIC IRQ is triggered, it
> is pure hardware function, so use it instead of software
> reset by cooling device.

So far the patch is pretty much better now. Unfortunately, I do not
have a way to test it. Can you please check if some workmate of yours
can do a testing on both hardwares and send his/her tested-by?



>
> Signed-off-by: Anson Huang <b20788@freescale.com>
> ---
>  .../devicetree/bindings/thermal/imx-thermal.txt    |    5 +-
>  drivers/thermal/imx_thermal.c                      |   91 +++++++++++++++++---
>  2 files changed, 82 insertions(+), 14 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/thermal/imx-thermal.txt b/Documentation/devicetree/bindings/thermal/imx-thermal.txt
> index 1f0f672..3c67bd5 100644
> --- a/Documentation/devicetree/bindings/thermal/imx-thermal.txt
> +++ b/Documentation/devicetree/bindings/thermal/imx-thermal.txt
> @@ -1,7 +1,10 @@
>  * Temperature Monitor (TEMPMON) on Freescale i.MX SoCs
>
>  Required properties:
> -- compatible : "fsl,imx6q-thermal"
> +- compatible : "fsl,imx6q-tempmon" for i.MX6Q, "fsl,imx6sx-tempmon" for i.MX6SX.
> +  i.MX6SX has two more IRQs than i.MX6Q, one is IRQ_LOW and the other is IRQ_PANIC,
> +  when temperature is below than low threshold, IRQ_LOW will be triggered, when temperature
> +  is higher than panic threshold, system will auto reboot by SRC module.
>  - fsl,tempmon : phandle pointer to system controller that contains TEMPMON
>    control registers, e.g. ANATOP on imx6q.
>  - fsl,tempmon-data : phandle pointer to fuse controller that contains TEMPMON
> diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
> index 2c516f2..461bf3d 100644
> --- a/drivers/thermal/imx_thermal.c
> +++ b/drivers/thermal/imx_thermal.c
> @@ -19,6 +19,7 @@
>  #include <linux/mfd/syscon.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> +#include <linux/of_device.h>
>  #include <linux/platform_device.h>
>  #include <linux/regmap.h>
>  #include <linux/slab.h>
> @@ -31,6 +32,11 @@
>
>  #define MISC0                          0x0150
>  #define MISC0_REFTOP_SELBIASOFF                (1 << 3)
> +#define MISC1                          0x0160
> +#define MISC1_IRQ_TEMPHIGH             (1 << 29)
> +/* Below LOW and PANIC bits are only for TEMPMON_IMX6SX */
> +#define MISC1_IRQ_TEMPLOW              (1 << 28)
> +#define MISC1_IRQ_TEMPPANIC            (1 << 27)
>
>  #define TEMPSENSE0                     0x0180
>  #define TEMPSENSE0_ALARM_VALUE_SHIFT   20
> @@ -43,6 +49,12 @@
>
>  #define TEMPSENSE1                     0x0190
>  #define TEMPSENSE1_MEASURE_FREQ                0xffff
> +/* Below TEMPSENSE2 is only for TEMPMON_IMX6SX */
> +#define TEMPSENSE2                     0x0290
> +#define TEMPSENSE2_LOW_VALUE_SHIFT     0
> +#define TEMPSENSE2_LOW_VALUE_MASK      0xfff
> +#define TEMPSENSE2_PANIC_VALUE_SHIFT   16
> +#define TEMPSENSE2_PANIC_VALUE_MASK    0xfff0000
>
>  #define OCOTP_ANA1                     0x04e0
>
> @@ -66,6 +78,21 @@ enum imx_thermal_trip {
>  #define FACTOR1                                15976
>  #define FACTOR2                                4297157
>
> +#define TEMPMON_IMX6Q                  1
> +#define TEMPMON_IMX6SX                 2
> +
> +struct thermal_soc_data {
> +       u32 version;
> +};
> +
> +static struct thermal_soc_data thermal_imx6q_data = {
> +       .version = TEMPMON_IMX6Q,
> +};
> +
> +static struct thermal_soc_data thermal_imx6sx_data = {
> +       .version = TEMPMON_IMX6SX,
> +};
> +
>  struct imx_thermal_data {
>         struct thermal_zone_device *tz;
>         struct thermal_cooling_device *cdev;
> @@ -79,8 +106,21 @@ struct imx_thermal_data {
>         bool irq_enabled;
>         int irq;
>         struct clk *thermal_clk;
> +       const struct thermal_soc_data *socdata;
>  };
>
> +static void imx_set_panic_temp(struct imx_thermal_data *data,
> +                              signed long panic_temp)
> +{
> +       struct regmap *map = data->tempmon;
> +       int critical_value;
> +
> +       critical_value = (data->c2 - panic_temp) / data->c1;
> +       regmap_write(map, TEMPSENSE2 + REG_CLR, TEMPSENSE2_PANIC_VALUE_MASK);
> +       regmap_write(map, TEMPSENSE2 + REG_SET, critical_value <<
> +                       TEMPSENSE2_PANIC_VALUE_SHIFT);
> +}
> +
>  static void imx_set_alarm_temp(struct imx_thermal_data *data,
>                                signed long alarm_temp)
>  {
> @@ -142,13 +182,17 @@ static int imx_get_temp(struct thermal_zone_device *tz, unsigned long *temp)
>         /* See imx_get_sensor_data() for formula derivation */
>         *temp = data->c2 - n_meas * data->c1;
>
> -       /* Update alarm value to next higher trip point */
> -       if (data->alarm_temp == data->temp_passive && *temp >= data->temp_passive)
> -               imx_set_alarm_temp(data, data->temp_critical);
> -       if (data->alarm_temp == data->temp_critical && *temp < data->temp_passive) {
> -               imx_set_alarm_temp(data, data->temp_passive);
> -               dev_dbg(&tz->device, "thermal alarm off: T < %lu\n",
> -                       data->alarm_temp / 1000);
> +       /* Update alarm value to next higher trip point for TEMPMON_IMX6Q */
> +       if (data->socdata->version == TEMPMON_IMX6Q) {
> +               if (data->alarm_temp == data->temp_passive &&
> +                       *temp >= data->temp_passive)
> +                       imx_set_alarm_temp(data, data->temp_critical);
> +               if (data->alarm_temp == data->temp_critical &&
> +                       *temp < data->temp_passive) {
> +                       imx_set_alarm_temp(data, data->temp_passive);
> +                       dev_dbg(&tz->device, "thermal alarm off: T < %lu\n",
> +                               data->alarm_temp / 1000);
> +               }
>         }
>
>         if (*temp != data->last_temp) {
> @@ -398,8 +442,17 @@ static irqreturn_t imx_thermal_alarm_irq_thread(int irq, void *dev)
>         return IRQ_HANDLED;
>  }
>
> +static const struct of_device_id of_imx_thermal_match[] = {
> +       { .compatible = "fsl,imx6q-tempmon", .data = &thermal_imx6q_data, },
> +       { .compatible = "fsl,imx6sx-tempmon", .data = &thermal_imx6sx_data, },
> +       { /* end */ }
> +};
> +MODULE_DEVICE_TABLE(of, of_imx_thermal_match);
> +
>  static int imx_thermal_probe(struct platform_device *pdev)
>  {
> +       const struct of_device_id *of_id =
> +               of_match_device(of_imx_thermal_match, &pdev->dev);
>         struct imx_thermal_data *data;
>         struct cpumask clip_cpus;
>         struct regmap *map;
> @@ -418,6 +471,20 @@ static int imx_thermal_probe(struct platform_device *pdev)
>         }
>         data->tempmon = map;
>
> +       data->socdata = of_id->data;
> +
> +       /* make sure the IRQ flag is clear before enabling irq on i.MX6SX */
> +       if (data->socdata->version == TEMPMON_IMX6SX) {

A general question on the patch strategy. You have chosen to split the
features per chip version. While this strategy is straight forward,
and one would even say very natural, I would say it is not very
scalable. In case your next chip versions have an overlap in features
with the existing ones, you will make your code a nightmare of ifs per
chip version. One suggestion is, that I have experienced to work with
TI and Samsung chips, to split the code per feature, not per chip
version.

In chis case, you will have a .supports or .features bitfield instead
of a .version. Then you would check if particular feature is present
in the chip you are dealing with, instead of asking for chip version.
What do you think?

> +               regmap_write(map, MISC1 + REG_CLR, MISC1_IRQ_TEMPHIGH |
> +                       MISC1_IRQ_TEMPLOW | MISC1_IRQ_TEMPPANIC);
> +               /*
> +                * reset value of LOW ALARM is incorrect, set it to lowest
> +                * value to avoid false trigger of low alarm.
> +                */
> +               regmap_write(map, TEMPSENSE2 + REG_SET,
> +                       TEMPSENSE2_LOW_VALUE_MASK);
> +       }
> +
>         data->irq = platform_get_irq(pdev, 0);
>         if (data->irq < 0)
>                 return data->irq;
> @@ -489,6 +556,10 @@ static int imx_thermal_probe(struct platform_device *pdev)
>         measure_freq = DIV_ROUND_UP(32768, 10); /* 10 Hz */
>         regmap_write(map, TEMPSENSE1 + REG_SET, measure_freq);
>         imx_set_alarm_temp(data, data->temp_passive);
> +
> +       if (data->socdata->version == TEMPMON_IMX6SX)
> +               imx_set_panic_temp(data, data->temp_critical);
> +
>         regmap_write(map, TEMPSENSE0 + REG_CLR, TEMPSENSE0_POWER_DOWN);
>         regmap_write(map, TEMPSENSE0 + REG_SET, TEMPSENSE0_MEASURE_TEMP);
>
> @@ -550,12 +621,6 @@ static int imx_thermal_resume(struct device *dev)
>  static SIMPLE_DEV_PM_OPS(imx_thermal_pm_ops,
>                          imx_thermal_suspend, imx_thermal_resume);
>
> -static const struct of_device_id of_imx_thermal_match[] = {
> -       { .compatible = "fsl,imx6q-tempmon", },
> -       { /* end */ }
> -};
> -MODULE_DEVICE_TABLE(of, of_imx_thermal_match);
> -
>  static struct platform_driver imx_thermal = {
>         .driver = {
>                 .name   = "imx_thermal",
> --
> 1.7.9.5
>



-- 
Eduardo Bezerra Valentin
