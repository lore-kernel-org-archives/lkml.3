Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab3EGFlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 01:41:46 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:35942 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3EGFlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 01:41:44 -0400
MIME-Version: 1.0
In-Reply-To: <1367665951-29848-2-git-send-email-manishv.b@ti.com>
References: <1367665951-29848-1-git-send-email-manishv.b@ti.com> <1367665951-29848-2-git-send-email-manishv.b@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 7 May 2013 11:11:21 +0530
Message-ID: <CA+V-a8ty3CEz5QZKkphD=_Hyjet31Ya59H9nW1nDd1Y1asRbmw@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] tps6507x-ts: Add DT support
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-input@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        grant.likely@secretlab.ca, dmitry.torokhov@gmail.com, rob@landley.net,
        rob.herring@calxeda.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manish,

Thanks for the patch, below are few nits.

On Sat, May 4, 2013 at 4:42 PM, Vishwanathrao Badarkhe, Manish
<manishv.b@ti.com> wrote:
> Add device tree based support for TI's tps6507x touchscreen.
[Snip]

> +- tsc: This node specifies touch screen data.
> +       ti,poll_period : Time at which touch input is getting sampled in ms.
> +       ti,min_pressure: Minimum pressure value to trigger touch.
For devicetree properties '-' is preferred over '_'.

> +       ti,vref        : voltage reference for ADC.
> +                     0: Reference voltage for ADC is disabled.
> +                     1: Reference voltage for ADC is enabled.
>
>  Regulator Optional properties:
>  - defdcdc_default: It's property of DCDC2 and DCDC3 regulators.
> @@ -30,6 +40,14 @@ Regulator Optional properties:
>                         1: If defdcdc pin of DCDC2/DCDC3 is driven HIGH.
>    If this property is not defined, it defaults to 0 (not enabled).
>
> +Touchscreen Optional properties:
> +- ti,vendor : Touchscreen vendor id to poppulate
> +             in sysclass interface.
> +- ti,product: Touchscreen product id to poppulate
> +             in sysclass interface.
> +- ti,version: Touchscreen version id to poppulate
> +             in sysclass interface.
> +
s/poppulate/populate

>  Example:
>
>         pmu: tps6507x@48 {
> @@ -88,4 +106,12 @@ Example:
>                         };
>                 };
>
> +               tsc {
> +                       ti,poll_period = <30>;
> +                       ti,min_pressure = <0x30>;
> +                       ti,vref = <0>;
> +                       ti,vendor = <0>;
> +                       ti,product = <65070>;
> +                       ti,version = <0x100>;
> +               };
>         };
> diff --git a/drivers/input/touchscreen/tps6507x-ts.c b/drivers/input/touchscreen/tps6507x-ts.c
> index 65e0f9a..d5433d0 100644
> --- a/drivers/input/touchscreen/tps6507x-ts.c
> +++ b/drivers/input/touchscreen/tps6507x-ts.c
> @@ -21,6 +21,8 @@
>  #include <linux/mfd/tps6507x.h>
>  #include <linux/input/tps6507x-ts.h>
>  #include <linux/delay.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
>
>  #define TSC_DEFAULT_POLL_PERIOD 30 /* ms */
>  #define TPS_DEFAULT_MIN_PRESSURE 0x30
> @@ -231,36 +233,83 @@ done:
>         ret = tps6507x_adc_standby(tsc);
>  }
>
> +static int tsc_init_data(struct tps6507x_dev *tps6507x_dev,
> +               struct input_dev *input_dev)
> +{
> +       struct device_node *node = tps6507x_dev->dev->of_node;
> +       struct tps6507x_board *tps_board =
> +               (struct tps6507x_board *)tps6507x_dev->dev->platform_data;
> +       struct touchscreen_init_data *init_data = NULL;
> +       u32 val32;
> +       int err;
> +
> +       if (node)
> +               node = of_find_node_by_name(node, "tsc");
> +       if (tps_board)
> +               init_data = tps_board->tps6507x_ts_init_data;
> +
> +       if (init_data) {
> +               tps6507x_dev->ts->poll_period = init_data->poll_period;
> +               tps6507x_dev->ts->min_pressure = init_data->min_pressure;
> +               tps6507x_dev->ts->vref = init_data->vref;
> +               input_dev->id.vendor = init_data->vendor;
> +               input_dev->id.product = init_data->product;
> +               input_dev->id.version = init_data->version;
> +       } else if (node) {
> +               err = of_property_read_u32(node, "ti,poll_period", &val32);
why not pass tps6507x_dev->ts->poll_period instead of val32 and similarly
below that would avoid else case.

> +               if (err < 0)
> +                       goto error_ret;
> +               else
> +                       tps6507x_dev->ts->poll_period = val32;
> +
> +               err = of_property_read_u32(node, "ti,min_pressure", &val32);
> +               if (err < 0)
> +                       goto error_ret;
> +               else
> +                       tps6507x_dev->ts->min_pressure = val32;
> +
> +               err = of_property_read_u32(node, "ti,vref", &val32);
> +               if (err < 0)
> +                       goto error_ret;
> +               else
> +                       tps6507x_dev->ts->vref = val32;
> +
> +               err = of_property_read_u32(node, "ti,vendor", &val32);
> +               if (err < 0)
> +                       goto error_ret;
> +               else
> +                       input_dev->id.vendor = val32;
> +
> +               err = of_property_read_u32(node, "ti,product", &val32);
> +               if (err < 0)
> +                       goto error_ret;
> +               else
> +                       input_dev->id.product = val32;
> +
> +               err = of_property_read_u32(node, "ti,version", &val32);
> +               if (err < 0)
> +                       goto error_ret;
> +               else
> +                       input_dev->id.version = val32;
> +       } else {
> +               err = -EINVAL;
> +               goto error_ret;
> +       }
you can move this check at the top when both are NULL.

Regards,
--Prabhakar Lad
