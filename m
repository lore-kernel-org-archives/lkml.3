Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbaBZVno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:43:44 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:62684 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaBZVnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:43:42 -0500
MIME-Version: 1.0
In-Reply-To: <1393375569-21751-2-git-send-email-sre@debian.org>
References: <1393375569-21751-1-git-send-email-sre@debian.org>
	<1393375569-21751-2-git-send-email-sre@debian.org>
Date: Wed, 26 Feb 2014 22:43:40 +0100
Message-ID: <CAAfyv37B=xn3AktnUxPDpuey+5S73vW0PJnuUZtorP4rajPKiw@mail.gmail.com>
Subject: Re: [PATCHv1 1/2] rx51_battery: convert to iio consumer
From: Belisko Marek <marek.belisko@gmail.com>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jonathan Cameron <jic23@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-iio@vger.kernel.org,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Wed, Feb 26, 2014 at 1:46 AM, Sebastian Reichel <sre@debian.org> wrote:
> Update rx51-battery driver to use the new IIO API of
> twl4030-madc and add DT support.
>
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> ---
>  drivers/power/rx51_battery.c | 68 +++++++++++++++++++++++++++++---------------
>  1 file changed, 45 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/power/rx51_battery.c b/drivers/power/rx51_battery.c
> index 1bc5857..f7cb58e 100644
> --- a/drivers/power/rx51_battery.c
> +++ b/drivers/power/rx51_battery.c
> @@ -24,34 +24,27 @@
>  #include <linux/power_supply.h>
>  #include <linux/slab.h>
>  #include <linux/i2c/twl4030-madc.h>
> -
> -/* RX51 specific channels */
> -#define TWL4030_MADC_BTEMP_RX51        TWL4030_MADC_ADCIN0
> -#define TWL4030_MADC_BCI_RX51  TWL4030_MADC_ADCIN4
> +#include <linux/iio/consumer.h>
> +#include <linux/of.h>
>
>  struct rx51_device_info {
>         struct device *dev;
>         struct power_supply bat;
> +       struct iio_channel *channel_temp;
> +       struct iio_channel *channel_bsi;
> +       struct iio_channel *channel_vbat;
>  };
>
>  /*
>   * Read ADCIN channel value, code copied from maemo kernel
>   */
> -static int rx51_battery_read_adc(int channel)
> +static int rx51_battery_read_adc(struct iio_channel *channel)
>  {
> -       struct twl4030_madc_request req;
> -
> -       req.channels = channel;
> -       req.do_avg = 1;
> -       req.method = TWL4030_MADC_SW1;
> -       req.func_cb = NULL;
> -       req.type = TWL4030_MADC_WAIT;
> -       req.raw = true;
> -
> -       if (twl4030_madc_conversion(&req) <= 0)
> -               return -ENODATA;
> -
> -       return req.rbuf[ffs(channel) - 1];
> +       int val, err;
> +       err = iio_read_channel_average_raw(channel, &val);
Where this function comes from? I cannot find it in current linux-next
(only iio_read_channel_raw()).
Am I missing some patches? Thx. BTW when I convert to iio consumer and
use DT some of values work
but some of them just report 0 :( (I don't have latest twl4030-madc
iio patches).
> +       if (err < 0)
> +               return err;
> +       return val;
>  }
>
>  /*
> @@ -60,10 +53,12 @@ static int rx51_battery_read_adc(int channel)
>   */
>  static int rx51_battery_read_voltage(struct rx51_device_info *di)
>  {
> -       int voltage = rx51_battery_read_adc(TWL4030_MADC_VBAT);
> +       int voltage = rx51_battery_read_adc(di->channel_vbat);
>
> -       if (voltage < 0)
> +       if (voltage < 0) {
> +               dev_err(di->dev, "Could not read ADC: %d\n", voltage);
>                 return voltage;
> +       }
>
>         return 1000 * (10000 * voltage / 1705);
>  }
> @@ -112,7 +107,10 @@ static int rx51_battery_read_temperature(struct rx51_device_info *di)
>  {
>         int min = 0;
>         int max = ARRAY_SIZE(rx51_temp_table2) - 1;
> -       int raw = rx51_battery_read_adc(TWL4030_MADC_BTEMP_RX51);
> +       int raw = rx51_battery_read_adc(di->channel_temp);
> +
> +       if (raw < 0)
> +               dev_err(di->dev, "Could not read ADC: %d\n", raw);
>
>         /* Zero and negative values are undefined */
>         if (raw <= 0)
> @@ -146,10 +144,12 @@ static int rx51_battery_read_temperature(struct rx51_device_info *di)
>   */
>  static int rx51_battery_read_capacity(struct rx51_device_info *di)
>  {
> -       int capacity = rx51_battery_read_adc(TWL4030_MADC_BCI_RX51);
> +       int capacity = rx51_battery_read_adc(di->channel_bsi);
>
> -       if (capacity < 0)
> +       if (capacity < 0) {
> +               dev_err(di->dev, "Could not read ADC: %d\n", capacity);
>                 return capacity;
> +       }
>
>         return 1280 * (1200 * capacity)/(1024 - capacity);
>  }
> @@ -213,12 +213,25 @@ static int rx51_battery_probe(struct platform_device *pdev)
>
>         platform_set_drvdata(pdev, di);
>
> +       di->dev = &pdev->dev;
>         di->bat.name = dev_name(&pdev->dev);
>         di->bat.type = POWER_SUPPLY_TYPE_BATTERY;
>         di->bat.properties = rx51_battery_props;
>         di->bat.num_properties = ARRAY_SIZE(rx51_battery_props);
>         di->bat.get_property = rx51_battery_get_property;
>
> +       di->channel_temp = iio_channel_get(di->dev, "temp");
> +       if (IS_ERR(di->channel_temp))
> +               return PTR_ERR(di->channel_temp);
> +
> +       di->channel_bsi  = iio_channel_get(di->dev, "bsi");
> +       if (IS_ERR(di->channel_bsi))
> +               return PTR_ERR(di->channel_bsi);
> +
> +       di->channel_vbat = iio_channel_get(di->dev, "vbat");
> +       if (IS_ERR(di->channel_vbat))
> +               return PTR_ERR(di->channel_vbat);
> +
>         ret = power_supply_register(di->dev, &di->bat);
>         if (ret)
>                 return ret;
> @@ -235,12 +248,21 @@ static int rx51_battery_remove(struct platform_device *pdev)
>         return 0;
>  }
>
> +#ifdef CONFIG_OF
> +static const struct of_device_id n900_battery_of_match[] = {
> +       {.compatible = "nokia,n900-battery", },
> +       { },
> +};
> +MODULE_DEVICE_TABLE(of, n900_battery_of_match);
> +#endif
> +
>  static struct platform_driver rx51_battery_driver = {
>         .probe = rx51_battery_probe,
>         .remove = rx51_battery_remove,
>         .driver = {
>                 .name = "rx51-battery",
>                 .owner = THIS_MODULE,
> +               .of_match_table = of_match_ptr(n900_battery_of_match),
>         },
>  };
>  module_platform_driver(rx51_battery_driver);
> --
> 1.8.5.3
>

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
