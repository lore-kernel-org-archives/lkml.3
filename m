Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaIJJOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 05:14:07 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:38428 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaIJJOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 05:14:03 -0400
Date: Wed, 10 Sep 2014 10:13:54 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: IIO <linux-iio@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Carlo Caione <carlo@caione.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Hartmut Knaack <knaack.h@gmx.de>, Fugang Duan <B38611@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Philippe Reynes <tremyfr@yahoo.fr>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: Re: [PATCH v2 2/4] mfd/axp2xx: extend axp20x to support axp288 pmic
Message-ID: <20140910091354.GL30307@lee--X1>
References: <1410267775-4683-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1410267775-4683-3-git-send-email-jacob.jun.pan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410267775-4683-3-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Sep 2014, Jacob Pan wrote:

> XPower AXP288 is a customized PMIC for Intel Baytrail-CR platforms. Similar
> to AXP202/209, AXP288 comes with USB charger, more LDO and BUCK channels, and
> AD converter. It also provides extended status and interrupt reporting
> capabilities than the devices supported in axp20x.c.
> 
> In addition to feature extension, this patch also adds ACPI binding for
> enumeration and hooks for ACPI custom operational region handlers.
> 
> Files and common data structures have been renamed from axp20x to axp2xx
> in order to suit the extended scope of devices.
> 
> This consolidated driver should support more Xpower PMICs in both device
> tree and ACPI based platforms.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  drivers/mfd/axp2xx.c       | 426 +++++++++++++++++++++++++++++++++++----------
>  include/linux/mfd/axp2xx.h |  57 +++++-
>  2 files changed, 388 insertions(+), 95 deletions(-)
> 
> diff --git a/drivers/mfd/axp2xx.c b/drivers/mfd/axp2xx.c
> index c534443..4830bbe 100644
> --- a/drivers/mfd/axp2xx.c
> +++ b/drivers/mfd/axp2xx.c
> @@ -1,9 +1,9 @@
>  /*
> - * axp20x.c - MFD core driver for the X-Powers AXP202 and AXP209
> + * axp2xx.c - MFD core driver for the X-Powers AXP202, AXP209, and AXP288

Any renaming should be part of the renaming patch.

Please remove the supported devices from the description.

> - * AXP20x comprises an adaptive USB-Compatible PWM charger, 2 BUCK DC-DC
> - * converters, 5 LDOs, multiple 12-bit ADCs of voltage, current and temperature
> - * as well as 4 configurable GPIOs.
> + * AXP2xx typically comprises an adaptive USB-Compatible PWM charger, BUCK DC-DC
> + * converters, LDOs, multiple 12-bit ADCs of voltage, current and temperature
> + * as well as configurable GPIOs.
>   *
>   * Author: Carlo Caione <carlo@caione.org>
>   *
> @@ -25,9 +25,14 @@
>  #include <linux/mfd/core.h>
>  #include <linux/of_device.h>
>  #include <linux/of_irq.h>
> +#include <linux/acpi.h>
>  
>  #define AXP20X_OFF	0x80
>  
> +static struct mfd_cell *axp2xx_cells;
> +static int axp2xx_nr_cells;
> +static struct regmap_config *regmap_cfg;

Only use globals if you 'really' have to.

[...]

> +static int axp2xx_match_device(struct axp2xx_dev *axp2xx, struct device *dev)
>  {
> -	struct axp20x_dev *axp20x;
> +	const struct acpi_device_id *acpi_id;
>  	const struct of_device_id *of_id;
> -	int ret;
>  
> -	axp20x = devm_kzalloc(&i2c->dev, sizeof(*axp20x), GFP_KERNEL);
> -	if (!axp20x)
> -		return -ENOMEM;
> +	of_id = of_match_device(axp2xx_of_match, dev);
> +	if (of_id) {
> +		axp2xx->variant = (long) of_id->data;
> +		goto found_match;

Place the ACPI stuff in an else instead of using goto.

> +	}
>  
> -	of_id = of_match_device(axp20x_of_match, &i2c->dev);
> -	if (!of_id) {
> -		dev_err(&i2c->dev, "Unable to setup AXP20X data\n");
> +	acpi_id = acpi_match_device(dev->driver->acpi_match_table, dev);
> +	if (!acpi_id || !acpi_id->driver_data) {
> +		dev_err(dev, "Unable to setup AXP2XX ACPI data\n");
> +		return -ENODEV;
> +	}
> +	axp2xx->variant = (long) acpi_id->driver_data;

I think adding ACPI support should be in its own patch.

[...]

> +static int axp2xx_i2c_probe(struct i2c_client *i2c,
> +			const struct i2c_device_id *id)
> +{
> +	struct axp2xx_dev *axp2xx;
> +	int ret;
> +
> +	axp2xx = devm_kzalloc(&i2c->dev, sizeof(*axp2xx), GFP_KERNEL);
> +	if (!axp2xx)
> +		return -ENOMEM;
> +
> +	ret = axp2xx_match_device(axp2xx, &i2c->dev);
> +	if (ret)
> +		return ret;

'\n'.

> +	axp2xx->i2c_client = i2c;
> +	axp2xx->dev = &i2c->dev;
> +	dev_set_drvdata(axp2xx->dev, axp2xx);

I'll do a more thorough review once all of the patches are split up
and grouped nicely.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
