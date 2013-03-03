Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab3CCAHS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 19:07:18 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:58053 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab3CCAHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 19:07:16 -0500
Date: Sat, 2 Mar 2013 16:03:25 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 4/4] power: tps65090: Add support for tps65090-charger
Message-ID: <20130303000325.GA29046@lizard.sbx05280.losalca.wayport.net>
References: <1362006450-4979-1-git-send-email-rklein@nvidia.com>
 <1362006450-4979-5-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1362006450-4979-5-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rhyland,

Thanks for the driver! A few comments down below...

On Wed, Feb 27, 2013 at 06:07:30PM -0500, Rhyland Klein wrote:
> This patch adds support for the tps65090 charger driver.

Would be nice to get a few more words about the hardware and the driver.
Why it is cool, main features, what is missing (if any), what is planned.

> Based on work by:
> Syed Rafiuddin <srafiuddin@nvidia.com>
> Laxman Dewangan <ldewangan@nvidia.com>
> 
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> ---
>  drivers/power/Kconfig            |    7 +
>  drivers/power/Makefile           |    1 +
>  drivers/power/tps65090-charger.c |  310 ++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/tps65090.h     |    5 +
>  4 files changed, 323 insertions(+)
>  create mode 100644 drivers/power/tps65090-charger.c
> 
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index 9f45e2f..6dcc3bd 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -340,6 +340,13 @@ config CHARGER_SMB347
>  	  Say Y to include support for Summit Microelectronics SMB347
>  	  Battery Charger.
>  
> +config CHARGER_TPS65090
> +	tristate "TPS65090 battery charger driver"
> +	depends on MFD_TPS65090
> +	help
> +	 Say Y here to enable support for battery charging with TPS65090
> +	 PMIC chips.
> +
>  config AB8500_BM
>  	bool "AB8500 Battery Management Driver"
>  	depends on AB8500_CORE && AB8500_GPADC
> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> index 22c8913..9523f81 100644
> --- a/drivers/power/Makefile
> +++ b/drivers/power/Makefile
> @@ -51,4 +51,5 @@ obj-$(CONFIG_CHARGER_MAX8998)	+= max8998_charger.o
>  obj-$(CONFIG_CHARGER_BQ2415X)	+= bq2415x_charger.o
>  obj-$(CONFIG_POWER_AVS)		+= avs/
>  obj-$(CONFIG_CHARGER_SMB347)	+= smb347-charger.o
> +obj-$(CONFIG_CHARGER_TPS65090)	+= tps65090-charger.o
>  obj-$(CONFIG_POWER_RESET)	+= reset/
> diff --git a/drivers/power/tps65090-charger.c b/drivers/power/tps65090-charger.c
> new file mode 100644
> index 0000000..1234b81
> --- /dev/null
> +++ b/drivers/power/tps65090-charger.c
> @@ -0,0 +1,310 @@
> +/*
> + * Battery charger driver for TI's tps65090
> + *
> + * Copyright (c) 2013, NVIDIA CORPORATION.  All rights reserved.
> +
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> +
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> +
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +#include <linux/platform_device.h>
> +#include <linux/power_supply.h>
> +#include <linux/mfd/tps65090.h>
> +
> +#define TPS65090_REG_INTR_STS	0x00
> +#define TPS65090_REG_CG_CTRL0	0x04
> +#define TPS65090_REG_CG_CTRL1	0x05
> +#define TPS65090_REG_CG_CTRL2	0x06
> +#define TPS65090_REG_CG_CTRL3	0x07
> +#define TPS65090_REG_CG_CTRL4	0x08
> +#define TPS65090_REG_CG_CTRL5	0x09
> +#define TPS65090_REG_CG_STATUS1	0x0a
> +#define TPS65090_REG_CG_STATUS2	0x0b
> +
> +#define TPS65090_CHARGER_ENABLE	BIT(0)
> +#define TPS65090_VACG		BIT(1)
> +#define TPS65090_NOITERM	BIT(5)
> +
> +struct tps65090_charger {
> +	struct	device	*dev;
> +	int	ac_online;
> +	int	prev_ac_online;
> +	struct power_supply	ac;
> +	struct tps65090_platform_data *pdata;
> +};
> +
> +static enum power_supply_property tps65090_ac_props[] = {
> +	POWER_SUPPLY_PROP_ONLINE,
> +};
> +
> +static int tps65090_low_chrg_current(struct tps65090_charger *charger)
> +{
> +	int ret;
> +
> +	ret = tps65090_write(charger->dev->parent, TPS65090_REG_CG_CTRL5,
> +			TPS65090_NOITERM);
> +	if (ret < 0) {
> +		dev_err(charger->dev, "%s(): error reading in register 0x%x\n",
> +			__func__, TPS65090_REG_CG_CTRL5);
> +		return ret;
> +	}
> +	return 0;
> +}
> +
> +static int tps65090_enable_charging(struct tps65090_charger *charger,
> +	uint8_t enable)
> +{
> +	int ret;
> +	uint8_t retval = 0;

maybe 'ctrl0' instead of retval?

> +
> +	ret = tps65090_read(charger->dev->parent, TPS65090_REG_CG_CTRL0,
> +			    &retval);
> +	if (ret < 0) {
> +		dev_err(charger->dev, "%s(): error reading in register 0x%x\n",
> +				__func__, TPS65090_REG_CG_CTRL0);
> +		return ret;
> +	}
> +
> +	ret = tps65090_write(charger->dev->parent, TPS65090_REG_CG_CTRL0,
> +				(retval | TPS65090_CHARGER_ENABLE));
> +	if (ret < 0) {
> +		dev_err(charger->dev, "%s(): error reading in register 0x%x\n",
> +				__func__, TPS65090_REG_CG_CTRL0);
> +		return ret;
> +	}
> +	return 0;
> +}
> +
> +static int tps65090_config_charger(struct tps65090_charger *charger)
> +{
> +	int ret;
> +
> +	if (charger->pdata->enable_low_current_chrg) {
> +		ret = tps65090_low_chrg_current(charger);
> +		if (ret < 0) {
> +			dev_err(charger->dev,
> +				"error configuring low charge current\n");
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int tps65090_ac_get_property(struct power_supply *psy,
> +			enum power_supply_property psp,
> +			union power_supply_propval *val)
> +{
> +	struct tps65090_charger *charger = container_of(psy,
> +					struct tps65090_charger, ac);
> +
> +	if (psp == POWER_SUPPLY_PROP_ONLINE) {
> +		val->intval = charger->ac_online;
> +		charger->prev_ac_online = charger->ac_online;
> +		return 0;
> +	}
> +	return -EINVAL;
> +}
> +
> +static irqreturn_t tps65090_charger_isr(int irq, void *dev_id)
> +{
> +	struct tps65090_charger *charger = dev_id;
> +	int ret;
> +	uint8_t retval = 0;
> +	uint8_t retval2 = 0;

... status1 = 0;
... intrsts = 0;

> +	ret = tps65090_read(charger->dev->parent, TPS65090_REG_CG_STATUS1,
> +			    &retval);
> +	if (ret < 0) {
> +		dev_err(charger->dev, "%s(): Error in reading reg 0x%x\n",
> +				__func__, TPS65090_REG_CG_STATUS1);
> +		goto error;

You don't need the error label, can just 'return ...;'

> +	}
> +	msleep(75);
> +	ret = tps65090_read(charger->dev->parent, TPS65090_REG_INTR_STS,
> +			    &retval2);
> +	if (ret < 0) {
> +		dev_err(charger->dev, "%s(): Error in reading reg 0x%x\n",
> +				__func__, TPS65090_REG_INTR_STS);
> +		goto error;
> +	}
> +
> +
> +	if (retval2 & TPS65090_VACG) {
> +		ret = tps65090_enable_charging(charger, 1);
> +		if (ret < 0)
> +			goto error;
> +		charger->ac_online = 1;
> +	} else {
> +		charger->ac_online = 0;
> +	}
> +
> +	if (charger->prev_ac_online != charger->ac_online)
> +		power_supply_changed(&charger->ac);
> +error:
> +	return IRQ_HANDLED;
> +}
> +
> +#if defined(CONFIG_OF)
> +
> +#include <linux/of_device.h>
> +
> +static struct tps65090_platform_data *tps65090_parse_dt_charger_data(
> +	struct platform_device *pdev)

One more tab is needed. Plus I'd wrap the line after '*', to no leave the
hanging parenthesis.

> +{
> +	struct tps65090_platform_data *pdata;
> +	struct device_node *np = pdev->dev.parent->of_node;
> +	unsigned int prop;
> +
> +	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> +

No need for this empty space.

> +	if (!pdata) {
> +		dev_err(&pdev->dev, "Memory alloc for tps65090_pdata failed\n");
> +		return NULL;
> +	}
> +
> +	prop = of_property_read_bool(np, "ti,enable-low-current-chrg");
> +	pdata->enable_low_current_chrg = prop;
> +
> +	pdata->irq_base = -1;
> +
> +	return pdata;
> +}

Need an empty space here, for consistency.

> +#else
> +static struct tps65090_platform_data *tps65090_parse_dt_charger_data(
> +	struct platform_device *pdev)

Same comment wrt. wrapping.

> +{
> +	return NULL;
> +}
> +#endif
> +
> +static int tps65090_charger_probe(struct platform_device *pdev)
> +{
> +	struct tps65090 *tps65090_mfd = dev_get_drvdata(pdev->dev.parent);
> +	struct tps65090_charger *charger_data;

Could be shorter 'cdata'?

> +	struct tps65090_platform_data *pdata;
> +	uint8_t retval = 0;

... status1 = 0;

> +	int ret;
> +	int irq;
> +
> +	pdata = dev_get_platdata(pdev->dev.parent);
> +
> +	if (!pdata && tps65090_mfd->dev->of_node)
> +		pdata = tps65090_parse_dt_charger_data(pdev);
> +
> +	if (!pdata) {
> +		dev_err(&pdev->dev, "%s():no platform data available\n",
> +				__func__);
> +		return -ENODEV;
> +	}
> +
> +	charger_data = devm_kzalloc(&pdev->dev, sizeof(*charger_data),
> +			GFP_KERNEL);
> +	if (!charger_data) {
> +		dev_err(&pdev->dev, "failed to allocate memory status\n");
> +		return -ENOMEM;
> +	}
> +
> +	dev_set_drvdata(&pdev->dev, charger_data);
> +
> +	charger_data->dev = &pdev->dev;
> +	charger_data->pdata = pdata;
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq <= 0) {
> +		dev_warn(&pdev->dev, "Unable to get charger irq = %d\n", irq);
> +		return irq;
> +	}
> +
> +	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
> +		tps65090_charger_isr, 0, "tps65090-charger", charger_data);

You should request irq after power_supply object (and charger_data) are
fully usable. Otherwise, if irq suddenly comes midway in the registration
process, we'll get an oops.

> +	if (ret) {
> +		dev_err(charger_data->dev, "Unable to register irq %d err %d\n",
> +				irq, ret);
> +		return ret;
> +	}
> +
> +	charger_data->ac.name		= "tps65090-ac";
> +	charger_data->ac.type		= POWER_SUPPLY_TYPE_MAINS;
> +	charger_data->ac.get_property	= tps65090_ac_get_property;
> +	charger_data->ac.properties	= tps65090_ac_props;
> +	charger_data->ac.num_properties	= ARRAY_SIZE(tps65090_ac_props);
> +	charger_data->ac.supplied_to	= pdata->supplied_to;
> +	charger_data->ac.num_supplicants = pdata->num_supplicants;
> +
> +	ret = power_supply_register(&pdev->dev, &charger_data->ac);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed: power supply register\n");
> +		goto fail_suppy_reg;
> +	}
> +
> +	ret = tps65090_config_charger(charger_data);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "charger config failed, err %d\n", ret);
> +		goto fail_config;
> +	}
> +
> +	/* Check for charger presence */
> +	ret = tps65090_read(charger_data->dev->parent, TPS65090_REG_CG_STATUS1,
> +			&retval);
> +	if (ret < 0) {
> +		dev_err(charger_data->dev, "%s(): Error in reading reg 0x%x",
> +			__func__, TPS65090_REG_CG_STATUS1);
> +		goto fail_config;
> +	}
> +
> +	if (retval != 0) {
> +		ret = tps65090_enable_charging(charger_data, 1);
> +		if (ret < 0) {
> +			dev_err(charger_data->dev, "error enabling charger\n");
> +			return ret;
> +		}
> +		charger_data->ac_online = 1;
> +		power_supply_changed(&charger_data->ac);
> +	}
> +
> +	return 0;
> +fail_config:
> +	power_supply_unregister(&charger_data->ac);
> +
> +fail_suppy_reg:
> +	return ret;
> +}
> +
> +static int tps65090_charger_remove(struct platform_device *pdev)
> +{
> +	struct tps65090_charger *charger = dev_get_drvdata(&pdev->dev);
> +
> +	power_supply_unregister(&charger->ac);

You have to unregister irq before unregistering power_supply object.
Otherwise irq routine might try to use the already unregistered object.

> +	return 0;
> +}
> +
> +static struct platform_driver tps65090_charger_driver = {
> +	.driver	= {
> +		.name	= "tps65090-charger",
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe	= tps65090_charger_probe,
> +	.remove = tps65090_charger_remove,
> +};
> +

No need for this empty line.

> +module_platform_driver(tps65090_charger_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Syed Rafiuddin <srafiuddin@nvidia.com>");
> +MODULE_DESCRIPTION("tps65090 battery charger driver");
