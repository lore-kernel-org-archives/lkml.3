Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab3AVJng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 04:43:36 -0500
Received: from smtp-out-072.synserver.de ([212.40.185.72]:1045 "EHLO
	smtp-out-072.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab3AVJn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:43:28 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 23817
Message-ID: <50FE5F76.7090803@metafoo.de>
Date: Tue, 22 Jan 2013 10:44:22 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, dianders@chromium.org,
        gregkh@linuxfoundation.org, naveenkrishna.ch@gmail.com
Subject: Re: [PATCH] iio: adc: add exynos5 adc driver under iio framwork
References: <1358775470-21278-1-git-send-email-ch.naveen@samsung.com>
In-Reply-To: <1358775470-21278-1-git-send-email-ch.naveen@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/21/2013 02:37 PM, Naveen Krishna Chatradhi wrote:
> This patch add an ADC IP found on EXYNOS5 series socs from Samsung.
> Also adds the Documentation for device tree bindings.
>[...]
> diff --git a/drivers/iio/adc/exynos5_adc.c b/drivers/iio/adc/exynos5_adc.c
> new file mode 100644
> index 0000000..cd33ea2
> --- /dev/null
> +++ b/drivers/iio/adc/exynos5_adc.c
> @@ -0,0 +1,412 @@
> +/*
> + *  exynos5_adc.c - Support for ADC in EXYNOS5 SoCs
> + *
> + *  8-channel, 10/12-bit ADC
> + *
> + *  Copyright (C) 2013 Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/io.h>
> +#include <linux/clk.h>
> +#include <linux/completion.h>
> +#include <linux/of.h>
> +#include <linux/of_irq.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/of_platform.h>
> +
> +#include <linux/iio/iio.h>
> +#include <linux/iio/machine.h>
> +#include <linux/iio/driver.h>
> +
> +/* Samsung ADC registers definitions */
> +#define EXYNOS_ADC_CON(x)	((x) + 0x00)
> +#define EXYNOS_ADC_DLY(x)	((x) + 0x08)
> +#define EXYNOS_ADC_DATX(x)	((x) + 0x0C)
> +#define EXYNOS_ADC_INTCLR(x)	((x) + 0x18)
> +#define EXYNOS_ADC_MUX(x)	((x) + 0x1c)
> +
> +/* Bit definitions for EXYNOS_ADC_MUX: */
> +#define ADC_RES		(1u << 16)
> +#define ADC_ECFLG	(1u << 15)
> +#define ADC_PRSCEN	(1u << 14)
> +#define ADC_PRSCLV(x)	(((x) & 0xFF) << 6)
> +#define ADC_PRSCVLMASK	(0xFF << 6)
> +#define ADC_STANDBY	(1u << 2)
> +#define ADC_READ_START	(1u << 1)
> +#define ADC_EN_START	(1u << 0)

You are a bit inconsistent with your prefixes, sometimes you use EXYNOS_ADC,
sometimes just ADC, it would be better to use the same prefix all the time.

> +
> +#define ADC_DATX_MASK	0xFFF
> +
> +struct exynos5_adc {
> +	void __iomem		*regs;
> +	struct clk		*clk;
> +	unsigned int		irq;
> +	struct regulator	*vdd;
> +
> +	struct completion	completion;
> +
> +	struct iio_map		*map;
> +	u32			value;
> +	u32			prescale;
> +};
> +
> +static const struct of_device_id exynos5_adc_match[] = {
> +	{ .compatible = "samsung,exynos5250-adc" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, exynos5_adc_match);
> +
> +/* default maps used by iio consumer (ex: ntc-thermistor driver) */
> +static struct iio_map exynos5_adc_iio_maps[] = {
> +	{
> +		.consumer_dev_name = "0.ncp15wb473",
> +		.consumer_channel = "adc_user3",
> +		.adc_channel_label = "adc3",
> +	},
> +	{},
> +};

Hm... this should not be in the driver itself.

> +
> +static int exynos5_read_raw(struct iio_dev *indio_dev,
> +				struct iio_chan_spec const *chan,
> +				int *val,
> +				int *val2,
> +				long mask)
> +{
> +	struct exynos5_adc *info = iio_priv(indio_dev);
> +	u32 con;
> +
> +	if (mask == IIO_CHAN_INFO_RAW) {
> +		mutex_lock(&indio_dev->mlock);
> +
> +		/* Select the channel to be used */
> +		writel(chan->address, EXYNOS_ADC_MUX(info->regs));
> +		/* Trigger conversion */
> +		con = readl(EXYNOS_ADC_CON(info->regs));
> +		writel(con | ADC_EN_START, EXYNOS_ADC_CON(info->regs));
> +
> +		wait_for_completion(&info->completion);
> +		*val = info->value;
> +
> +		mutex_unlock(&indio_dev->mlock);
> +
> +		return IIO_VAL_INT;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static irqreturn_t exynos5_adc_isr(int irq, void *dev_id)
> +{
> +	struct exynos5_adc *info = (struct exynos5_adc *)dev_id;
> +
> +	/* Read value and clear irq */
> +	info->value = readl(EXYNOS_ADC_DATX(info->regs)) &
> +				ADC_DATX_MASK;
> +	writel(0, EXYNOS_ADC_INTCLR(info->regs));
> +
> +	complete(&info->completion);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int exynos5_adc_reg_access(struct iio_dev *indio_dev,
> +			      unsigned reg, unsigned writeval,
> +			      unsigned *readval)
> +{
> +	struct exynos5_adc *info = iio_priv(indio_dev);
> +	u32 ret;
> +
> +	mutex_lock(&indio_dev->mlock);

Do we really need to take the lock here?

> +
> +	if (readval != NULL) {
> +		if (reg == 0x08)
> +			ret = readl(EXYNOS_ADC_DLY(info->regs));
> +		else if (reg == 0x0C)
> +			ret = readl(EXYNOS_ADC_DATX(info->regs));
> +		else if (reg == 0x1C)
> +			ret = readl(EXYNOS_ADC_MUX(info->regs));
> +		else
> +			ret = readl(EXYNOS_ADC_CON(info->regs));

How about
		ret = readl(info->regs + reg)

instead of the whole if ... else if ... else if ...

> +
> +		readval = &ret;

Uhm, I'm pretty sure that the line above does not work. At least it won't do
what you want it to do.

> +	} else
> +		ret = -EINVAL;
> +
> +	mutex_unlock(&indio_dev->mlock);
> +
> +	return ret;
> +}
> +
> +static const struct iio_info exynos5_adc_iio_info = {
> +	.read_raw = &exynos5_read_raw,
> +	.debugfs_reg_access = &exynos5_adc_reg_access,
> +	.driver_module = THIS_MODULE,
> +};
> +
> +#define EXYNOS_ADC_CHANNEL(_index, _id) {		\
> +	.type = IIO_VOLTAGE,				\
> +	.indexed = 1,					\
> +	.channel = _index,				\
> +	.address = _index,				\
> +	.info_mask = IIO_CHAN_INFO_RAW_SEPARATE_BIT,	\
> +	.datasheet_name = _id,				\
> +}
> +
> +static const struct iio_chan_spec exynos5_adc_iio_channels[] = {
> +	EXYNOS_ADC_CHANNEL(0, "adc0"),
> +	EXYNOS_ADC_CHANNEL(1, "adc1"),
> +	EXYNOS_ADC_CHANNEL(2, "adc2"),
> +	EXYNOS_ADC_CHANNEL(3, "adc3"),
> +	EXYNOS_ADC_CHANNEL(4, "adc4"),
> +	EXYNOS_ADC_CHANNEL(5, "adc5"),
> +	EXYNOS_ADC_CHANNEL(6, "adc6"),
> +	EXYNOS_ADC_CHANNEL(7, "adc7"),
> +};
> +
> +static int exynos5_adc_iio_map_register(struct iio_dev *indio_dev,
> +				struct exynos5_adc *adc)
> +{
> +	int ret;
> +
> +	adc->map = exynos5_adc_iio_maps;
> +
> +	ret = iio_map_array_register(indio_dev, adc->map);
> +	if (ret) {
> +		dev_err(&indio_dev->dev, "iio map err: %d\n", ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}

Just use iio_map_array_register instead of exynos5_adc_iio_map_register

> +
> +static inline void exynos5_adc_iio_map_unregister(struct iio_dev *indio_dev,
> +				struct exynos5_adc *adc)
> +{
> +	iio_map_array_unregister(indio_dev, adc->map);
> +}

Just use iio_map_array_unregister directly instead of
exynos5_adc_iio_map_unregister

> +
> +static int exynos5_adc_remove_devices(struct device *dev, void *c)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +
> +	platform_device_unregister(pdev);
> +
> +	return 0;
> +}

Again, a single line wrapper function...

> +
> +static int exynos5_adc_probe(struct platform_device *pdev)
> +{
> +	struct exynos5_adc *info = NULL;
> +	struct device_node *np = pdev->dev.of_node;
> +	struct iio_dev *iodev = NULL;

this is usually called indio_dev, would be good to be consistent across dirvers.

> +	struct resource	*mem;
> +	int ret = -ENODEV;
> +	int irq;
> +	u32 con;
> +
> +	iodev = iio_device_alloc(sizeof(struct exynos5_adc));
> +	if (!iodev) {
> +		dev_err(&pdev->dev, "failed allocating iio device\n");
> +		return -ENOMEM;
> +	}
> +
> +	info = iio_priv(iodev);
> +
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!mem) {

devm_request_and_ioremap will check if mem is NULL, so you don't need to do
this manually.

> +		dev_err(&pdev->dev, "no mem resource?\n");
> +		goto err_iio;
> +	}
> +
> +	info->regs = devm_request_and_ioremap(&pdev->dev, mem);
> +	if (!info->regs) {
> +		dev_err(&pdev->dev, "cannot map EXYNOS5 ADC registers\n");

devm_request_and_ioremap already prints an error message.

> +		ret = -ENOMEM;
> +		goto err_iio;
> +	}
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		dev_err(&pdev->dev, "no irq resource?\n");
> +		ret = irq;
> +		goto err_iio;
> +	}
> +
> +	info->irq = irq;
> +
> +	ret = devm_request_irq(&pdev->dev, info->irq, exynos5_adc_isr,
> +					0, dev_name(&pdev->dev), info);

Using devm_request_irq is racy in this case, since the IRQ will be freed
after the device has been freed, while it needs to be freed before the devie
has been freed.

> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "cannot request Samsung ADC IRQ %d\n",
> +							info->irq);
> +		goto err_iio;
> +	}
> +
> +	info->clk = devm_clk_get(&pdev->dev, "adc");
> +	if (IS_ERR(info->clk)) {
> +		dev_err(&pdev->dev, "failed getting clock\n");

I think it is a good idea to include the error code in the error message.

> +		ret = PTR_ERR(info->clk);
> +		goto err_iio;
> +	}
> +
> +	clk_enable(info->clk);
> +
> +	info->vdd = devm_regulator_get(&pdev->dev, "vdd");
> +	if (IS_ERR(info->vdd)) {
> +		dev_err(&pdev->dev, "operating without regulator \"vdd\" .\n");

Same here.

> +		ret = PTR_ERR(info->vdd);
> +		goto err_iio;
> +	}
> +
> +	platform_set_drvdata(pdev, iodev);
> +
> +	init_completion(&info->completion);
> +
> +	iodev->name = dev_name(&pdev->dev);
> +	iodev->dev.parent = &pdev->dev;
> +	iodev->dev.of_node = pdev->dev.of_node;
> +	iodev->info = &exynos5_adc_iio_info;
> +	iodev->modes = INDIO_DIRECT_MODE;
> +	iodev->channels = exynos5_adc_iio_channels;
> +	iodev->num_channels = ARRAY_SIZE(exynos5_adc_iio_channels);
> +
> +	/* Enable prescaler and set platform default */
> +	info->prescale = ADC_PRSCLV(49);
> +	con = info->prescale | ADC_PRSCEN;
> +
> +	/* Enable 12-bit ADC resolution */
> +	con |= ADC_RES;
> +
> +	writel(con, EXYNOS_ADC_CON(info->regs));
> +
> +	ret = exynos5_adc_iio_map_register(iodev, info);
> +	if (ret)
> +		goto err_iio;
> +
> +	ret = iio_device_register(iodev);
> +	if (ret)
> +		goto err_map;
> +
> +	ret = regulator_enable(info->vdd);
> +	if (ret)
> +		goto err_iio_dev;
> +
> +	ret = of_platform_populate(np, exynos5_adc_match, NULL, &pdev->dev);

Which kind of child nodes to you expect it to have? There is nothing about
this in your dt bindings documentation.

> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "failed to add child nodes\n");
> +		goto err_of_populate;
> +	}
> +
> +	dev_info(&pdev->dev, "EXYNOS5 ADC driver loaded.\n");

That's just noise, please remove it.

> +
> +	return 0;
> +
> +err_of_populate:
> +	device_for_each_child(&pdev->dev, NULL, exynos5_adc_remove_devices);
> +err_iio_dev:
> +	iio_device_unregister(iodev);
> +err_map:
> +	exynos5_adc_iio_map_unregister(iodev, info);
> +err_iio:
> +	iio_device_free(iodev);
> +	return ret;
> +}
> +
> +static int exynos5_adc_remove(struct platform_device *pdev)
> +{
> +	struct iio_dev *iodev = platform_get_drvdata(pdev);
> +	struct exynos5_adc *info = iio_priv(iodev);
> +
> +	platform_set_drvdata(pdev, NULL);

The line above should not be needed

> +	iio_device_unregister(iodev);
> +	exynos5_adc_iio_map_unregister(iodev, info);
> +	iio_device_free(iodev);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM

CONFIG_PM_SLEEP

> +static int exynos5_adc_suspend(struct device *dev)
> +{
> +	struct platform_device *pdev = container_of(dev,
> +			struct platform_device, dev);

to_platform_device

> +	struct exynos5_adc *info = platform_get_drvdata(pdev);

Although using dev_get_data(dev) here would also be ok I guess.

> +	u32 con;
> +
> +	con = readl(EXYNOS_ADC_CON(info->regs));
> +	con |= ADC_STANDBY;
> +	writel(con, EXYNOS_ADC_CON(info->regs));
> +
> +	clk_disable(info->clk);

clk_unprepare_disable

> +	regulator_disable(info->vdd);
> +
> +	return 0;
> +}
> +
> +static int exynos5_adc_resume(struct device *dev)
> +{
> +	struct platform_device *pdev = container_of(dev,
> +			struct platform_device, dev);

Same as above.

> +	struct exynos5_adc *info = platform_get_drvdata(pdev);
> +	unsigned int con;
> +	int ret;
> +
> +	ret = regulator_enable(info->vdd);
> +	if (ret)
> +		return ret;
> +
> +	clk_enable(info->clk);

clk_prepare_enable

> +
> +	/* TODO: Enable prescalar */
> +	con = info->prescale | ADC_PRSCEN;

I guess you need to enable the prescaler here ;) (or removed the TODO comment)

> +	writel(con | ADC_RES, EXYNOS_ADC_CON(info->regs));
> +
> +	return 0;
> +}
> +
> +#else
> +#define s3c_adc_suspend NULL
> +#define s3c_adc_resume NULL
> +#endif
> +
> +static const struct dev_pm_ops adc_pm_ops = {
> +	.suspend	= exynos5_adc_suspend,
> +	.resume		= exynos5_adc_resume,
> +};

static SIMPLE_DEV_PM_OPS(exynos5_adc_pm_ops, exynos5_adc_suspend,
	exynos5_adc_resume);

> +
> +static struct platform_driver exynos5_adc_driver = {
> +	.probe		= exynos5_adc_probe,
> +	.remove		= exynos5_adc_remove,
> +	.driver		= {
> +		.name	= "exynos5-adc",
> +		.owner	= THIS_MODULE,
> +		.of_match_table = of_match_ptr(exynos5_adc_match),
> +		.pm	= &adc_pm_ops,
> +	},
> +};
> +
> +module_platform_driver(exynos5_adc_driver);
> +
> +MODULE_AUTHOR("Naveen Krishna Chatradhi <ch.naveen@samsung.com>");
> +MODULE_DESCRIPTION("Samsung EXYNOS5 ADC driver");
> +MODULE_LICENSE("GPL");

