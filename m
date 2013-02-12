Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab3BLBWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 20:22:15 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:48188 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930Ab3BLBWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 20:22:12 -0500
Date: Mon, 11 Feb 2013 17:22:14 -0800
From: Olof Johansson <olof@lixom.net>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, dianders@chromium.org,
        gregkh@linuxfoundation.org, naveenkrishna.ch@gmail.com,
        lars@metafoo.de
Subject: Re: [PATCH] iio: adc: add exynos5 adc driver under iio framwork
Message-ID: <20130212012214.GA13188@quad.lixom.net>
References: <1358775470-21278-1-git-send-email-ch.naveen@samsung.com>
 <1359003932-3306-1-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359003932-3306-1-git-send-email-ch.naveen@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It looks like the bindings here are still completely unsettled, or at least
unimplemented -- there seems to be a preference for an encoding similar to how
interrupts/gpios/clks work. I think that wouldn't be a bad idea.

For the case of this particular driver and connections, it'd just mean you
would need to do the binding slightly differently. You can still have some of
the sensors under the ADC node if they're not sitting on another bus where it
makes sense to locate them.


Some further comments below.


On Thu, Jan 24, 2013 at 10:35:32AM +0530, Naveen Krishna Chatradhi wrote:
> This patch add an ADC IP found on EXYNOS5250 and EXYNOS5410 SoCs
> from Samsung. Also adds the Documentation for device tree bindings.
> 
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
> Changes since v1:
> 
> 1. Fixed comments from Lars
> 2. Added support for ADC on EXYNOS5410
> 
> Changes since v2:
> 
> 1. Changed the instance name for (struct iio_dev *) to indio_dev
> 2. Changed devm_request_irq to request_irq
> 
> Few doubts regarding the mappings and child device handling.
> Kindly, suggest me better methods.
> 
> Changes since v3:
> 
> 1. Added clk_prepare_disable and regulator_disable calls in _remove()
> 2. Moved init_completion before irq_request
> 3. Added NULL pointer check for devm_request_and_ioremap() return value.
> 4. Use number of channels as per the ADC version 
> 5. Change the define ADC_V1_CHANNEL to ADC_CHANNEL
> 6. Update the Documentation to include EXYNOS5410 compatible
> 
> Changes since v4:
> 
> 1. if devm_request_and_ioremap() failes, free iio_device before returning 
> 
> Doug, i've used
> 	chan = iio_channel_get(dev_name(&pdev->dev), "adc3");
> in ntc thermistor driver during probe and
> 	iio_read_channel_raw(chan, &val);
> for read.
> 
> But, then the drivers become kind of coupled. Right.
> 
> Lars, Is there an other way.
> 
> Thanks for the comments
> 
>  .../bindings/arm/samsung/exynos5-adc.txt           |   38 ++
>  drivers/iio/adc/Kconfig                            |    7 +
>  drivers/iio/adc/Makefile                           |    1 +
>  drivers/iio/adc/exynos5_adc.c                      |  477 ++++++++++++++++++++
>  4 files changed, 523 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/samsung/exynos5-adc.txt
>  create mode 100644 drivers/iio/adc/exynos5_adc.c
> 
> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos5-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos5-adc.txt
> new file mode 100644
> index 0000000..0f281d9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/samsung/exynos5-adc.txt
> @@ -0,0 +1,38 @@
> +Samsung Exynos5 Analog to Digital Converter bindings
> +
> +Required properties:
> +- compatible:		Must be "samsung,exynos5250-adc" for exynos5250 controllers.
> +			Must be "samsung,exynos5410-adc" for exynos5410 controllers.

Looking at the out-of-tree patch we have that adds exynos5 support to
arch/arm/plat-samsung/adc.c, this looks like it should be:

samsung,exynos4412-adc should be the base case (this was the first chip with
the new "version 4" ADC hardware). Then for 5250 the chip-specific
prefixes should also be there for compatible in case there are SoC-specific
bugs or quirks or features that the driver in the future might need to care
about.

Based on the code below, it looks like 5410 isn't compatible with 4412, since
it needs special init sequences. So that means 5410 shouldn't be claimed to be
compatible.


> +- reg:			Contains ADC register address range (base address and
> +			length).
> +- interrupts: 		Contains the interrupt information for the timer. The
> +			format is being dependent on which interrupt controller
> +			the Samsung device uses.
> +
> +Note: child nodes can be added for auto probing from device tree.
> +
> +Example: adding device info in dtsi file
> +
> +adc@12D10000 {
> +	compatible = "samsung,exynos5250-adc";
> +	reg = <0x12D10000 0x100>;
> +	interrupts = <0 106 0>;
> +	#address-cells = <1>;
> +	#size-cells = <1>;

This is where something like #channel-cells or something else would be needed
-- not address cells and size cells. And then (see below)...

> +	ranges;
> +};
> +
> +
> +Example: Adding child nodes in dts file
> +
> +adc@12D10000 {
> +
> +	/* NTC thermistor is a hwmon device */
> +	ncp15wb473@0 {
> +		compatible = "ntc,ncp15wb473";
> +		reg = <0x0>;
> +		pullup-uV = <1800000>;
> +		pullup-ohm = <47000>;
> +		pulldown-ohm = <0>;

So, here is where the reference to channel should be specified. Even for those
who are located as children to the adc node.

Something like (naming is up in the air):
io-channel = <&adc 0>;

> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
> index fe822a1..33ceabf 100644
> --- a/drivers/iio/adc/Kconfig
> +++ b/drivers/iio/adc/Kconfig
> @@ -91,6 +91,13 @@ config AT91_ADC
>  	help
>  	  Say yes here to build support for Atmel AT91 ADC.
>  
> +config EXYNOS5_ADC
> +	bool "Exynos5 ADC driver support"
> +	help
> +	  Core support for the ADC block found in the Samsung EXYNOS5 series
> +	  of SoCs for drivers such as the touchscreen and hwmon to use to share
> +	  this resource.

Given the out-of-tree patch that enables EXYNOS5250 (and 4412) support to
arch/arm/plat-samsung/adc.c, it seems shortsighted to name this driver exynos5.
The driver should be able to handle older versions of the Samsung chipsets
without too much work.

Initial versions could be contained to only support EXYNOS5 and 4412, that'd be
fine. But to avoid future renames, keep the name generic (exynos_adc)

> diff --git a/drivers/iio/adc/exynos5_adc.c b/drivers/iio/adc/exynos5_adc.c
> new file mode 100644
> index 0000000..197d622
> --- /dev/null
> +++ b/drivers/iio/adc/exynos5_adc.c
> @@ -0,0 +1,477 @@
> +/*
> + *  exynos5_adc.c - Support for ADC in EXYNOS5 SoCs

So all these kind of references would need to be changed too.

> + *
> + *  8 ~ 10 channel, 10/12-bit ADC
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
> +enum adc_version {
> +	ADC_V1,
> +	ADC_V2
> +};
> +
> +/* EXYNOS5250 ADC_V1 registers definitions */

Given that the arch/arm/plat-samsung/adc.c driver is already in the tree, and
it uses ADCV1..3 already for even older platforms, it seems awkward to reuse
the same numbering scheme but for other chips here. Maybe use 4412 as prefix
here, and 5410 for V2? Where does 5440 fall into this, is it compatible with
5250 or with 5410?

> +#define ADC_V1_CON(x)		((x) + 0x00)
> +#define ADC_V1_DLY(x)		((x) + 0x08)
> +#define ADC_V1_DATX(x)		((x) + 0x0C)
> +#define ADC_V1_INTCLR(x)	((x) + 0x18)
> +#define ADC_V1_MUX(x)		((x) + 0x1c)
> +
> +/* EXYNOS5410 ADC_V2 registers definitions */
> +#define ADC_V2_CON1(x)		((x) + 0x00)
> +#define ADC_V2_CON2(x)		((x) + 0x04)
> +#define ADC_V2_STAT(x)		((x) + 0x08)
> +#define ADC_V2_INT_EN(x)	((x) + 0x10)
> +#define ADC_V2_INT_ST(x)	((x) + 0x14)
> +#define ADC_V2_VER(x)		((x) + 0x20)
> +
> +/* Bit definitions for ADC_V1 */
> +#define ADC_V1_CON_RES		(1u << 16)
> +#define ADC_V1_CON_PRSCEN	(1u << 14)
> +#define ADC_V1_CON_PRSCLV(x)	(((x) & 0xFF) << 6)
> +#define ADC_V1_CON_STANDBY	(1u << 2)
> +
> +/* Bit definitions for ADC_V2 */
> +#define ADC_V2_CON1_SOFT_RESET	(1u << 2)
> +
> +#define ADC_V2_CON2_OSEL	(1u << 10)
> +#define ADC_V2_CON2_ESEL	(1u << 9)
> +#define ADC_V2_CON2_HIGHF	(1u << 8)
> +#define ADC_V2_CON2_C_TIME(x)	(((x) & 7) << 4)
> +#define ADC_V2_CON2_ACH_SEL(x)	(((x) & 0xF) << 0)
> +#define ADC_V2_CON2_ACH_MASK	0xF
> +
> +/* Bit definitions common for ADC_V1 and ADC_V2 */
> +#define ADC_V1_CON_EN_START		(1u << 0)
> +#define ADC_V1_DATX_MASK	0xFFF
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
> +	unsigned int            version;
> +};
> +
> +static const struct of_device_id exynos5_adc_match[] = {
> +	{ .compatible = "samsung,exynos5250-adc", .data = (void *)ADC_V1 },
> +	{ .compatible = "samsung,exynos5410-adc", .data = (void *)ADC_V2 },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, exynos5_adc_match);
> +
> +static inline unsigned int exynos5_adc_get_version(struct platform_device *pdev)
> +{
> +	const struct of_device_id *match;
> +
> +	match = of_match_node(exynos5_adc_match, pdev->dev.of_node);
> +	return (unsigned int)match->data;
> +}
> +
> +/* default maps used by iio consumer (ex: ntc-thermistor driver) */
> +static struct iio_map exynos5_adc_iio_map[] = {
> +	{
> +		.consumer_dev_name = "0.ncp15wb473",
> +		.consumer_channel = "adc3",
> +		.adc_channel_label = "adc3",
> +	},
> +	{
> +		.consumer_dev_name = "1.ncp15wb473",
> +		.consumer_channel = "adc4",
> +		.adc_channel_label = "adc4",
> +	},
> +	{
> +		.consumer_dev_name = "2.ncp15wb473",
> +		.consumer_channel = "adc5",
> +		.adc_channel_label = "adc5",
> +	},
> +	{
> +		.consumer_dev_name = "3.ncp15wb473",
> +		.consumer_channel = "adc6",
> +		.adc_channel_label = "adc6",
> +	},
> +	{},
> +};

Does it really make sense to have these default sensors here? How many boards
will have these vs those who will need something else? What happens if someone
enables the driver without specifying correctly what sensors they have on their
hardware? Seems suboptimal to provide a default that doesn't always match
reality.

> +static irqreturn_t exynos5_adc_isr(int irq, void *dev_id)
> +{
> +	struct exynos5_adc *info = (struct exynos5_adc *)dev_id;
> +
> +	/* Read value */
> +	info->value = readl(ADC_V1_DATX(info->regs)) &
> +						ADC_V1_DATX_MASK;

You read _V1 registers on both versions of hardware here (and some other
places). I guess register definitions (and offset) are compatible, but it's
a little confusing given that pretty much everything else seems to be
separate/different.

Either keep them completely separate, or rename the register something that's
not versioned.

> +	/* clear irq */
> +	if (info->version == ADC_V2)
> +		writel(1, ADC_V2_INT_ST(info->regs));
> +	else
> +		writel(1, ADC_V1_INTCLR(info->regs));
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
> +
> +	if (readval != NULL) {
> +		ret = readl(info->regs + reg);
> +		*readval = ret;
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
> +#define ADC_CHANNEL(_index, _id) {			\
> +	.type = IIO_VOLTAGE,				\
> +	.indexed = 1,					\
> +	.channel = _index,				\
> +	.address = _index,				\
> +	.info_mask = IIO_CHAN_INFO_RAW_SEPARATE_BIT,	\
> +	.datasheet_name = _id,				\
> +}
> +
> +static const struct iio_chan_spec exynos5_adc_iio_channels[] = {
> +	ADC_CHANNEL(0, "adc0"),
> +	ADC_CHANNEL(1, "adc1"),
> +	ADC_CHANNEL(2, "adc2"),
> +	ADC_CHANNEL(3, "adc3"),
> +	ADC_CHANNEL(4, "adc4"),
> +	ADC_CHANNEL(5, "adc5"),
> +	ADC_CHANNEL(6, "adc6"),
> +	ADC_CHANNEL(7, "adc7"),
> +	ADC_CHANNEL(8, "adc8"),
> +	ADC_CHANNEL(9, "adc9"),
> +};
> +
> +static int exynos5_adc_remove_devices(struct device *dev, void *c)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +
> +	platform_device_unregister(pdev);
> +
> +	return 0;
> +}
> +
> +static void exynos5_adc_hw_init(struct exynos5_adc *info)
> +{
> +	u32 con1, con2;
> +
> +	if (info->version == ADC_V2) {
> +		con1 = ADC_V2_CON1_SOFT_RESET;
> +		writel(con1, ADC_V2_CON1(info->regs));
> +
> +		con2 = ADC_V2_CON2_OSEL | ADC_V2_CON2_ESEL |
> +			ADC_V2_CON2_HIGHF | ADC_V2_CON2_C_TIME(0);
> +		writel(con2, ADC_V2_CON2(info->regs));
> +
> +		/* Enable interrupts */
> +		writel(1, ADC_V2_INT_EN(info->regs));
> +	} else {
> +		/* set default prescaler values and Enable prescaler */
> +		con1 =  ADC_V1_CON_PRSCLV(49) | ADC_V1_CON_PRSCEN;
> +
> +		/* Enable 12-bit ADC resolution */
> +		con1 |= ADC_V1_CON_RES;
> +		writel(con1, ADC_V1_CON(info->regs));
> +	}
> +}
> +
> +static int exynos5_adc_probe(struct platform_device *pdev)
> +{
> +	struct exynos5_adc *info = NULL;
> +	struct device_node *np = pdev->dev.of_node;
> +	struct iio_dev *indio_dev = NULL;
> +	struct resource	*mem;
> +	int ret = -ENODEV;
> +	int irq;
> +
> +	if (!np)
> +		return ret;
> +
> +	indio_dev = iio_device_alloc(sizeof(struct exynos5_adc));
> +	if (!indio_dev) {
> +		dev_err(&pdev->dev, "failed allocating iio device\n");
> +		return -ENOMEM;
> +	}
> +
> +	info = iio_priv(indio_dev);
> +
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +
> +	info->regs = devm_request_and_ioremap(&pdev->dev, mem);
> +	if (!info->regs) {
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
> +	init_completion(&info->completion);
> +
> +	ret = request_irq(info->irq, exynos5_adc_isr,
> +					0, dev_name(&pdev->dev), info);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "failed requesting irq, irq = %d\n",
> +							info->irq);
> +		goto err_iio;
> +	}
> +
> +	info->clk = devm_clk_get(&pdev->dev, "adc");
> +	if (IS_ERR(info->clk)) {
> +		dev_err(&pdev->dev, "failed getting clock, err = %ld\n",
> +							PTR_ERR(info->clk));
> +		ret = PTR_ERR(info->clk);
> +		goto err_irq;
> +	}
> +
> +	info->vdd = devm_regulator_get(&pdev->dev, "vdd");
> +	if (IS_ERR(info->vdd)) {
> +		dev_err(&pdev->dev, "failed getting regulator, err = %ld\n",
> +							PTR_ERR(info->vdd));
> +		ret = PTR_ERR(info->vdd);
> +		goto err_irq;
> +	}
> +
> +	info->version = exynos5_adc_get_version(pdev);
> +
> +	platform_set_drvdata(pdev, indio_dev);
> +
> +	indio_dev->name = dev_name(&pdev->dev);
> +	indio_dev->dev.parent = &pdev->dev;
> +	indio_dev->dev.of_node = pdev->dev.of_node;
> +	indio_dev->info = &exynos5_adc_iio_info;
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +	indio_dev->channels = exynos5_adc_iio_channels;
> +
> +	if (info->version == ADC_V1)
> +		/* ADC core in EXYNOS5250 has 8 channels */
> +		indio_dev->num_channels =
> +				ARRAY_SIZE(exynos5_adc_iio_channels) - 2;

This is fragile code, it'll break (or need changing) if V3 has even more
channels. Just set the value instead of doing a delta. Via a define if you
prefer.

> +	else
> +		/* ADC core in EXYNOS5410 has 10 channels */
> +		indio_dev->num_channels =
> +				ARRAY_SIZE(exynos5_adc_iio_channels);
> +
> +	info->map = exynos5_adc_iio_map;
> +
> +	ret = iio_map_array_register(indio_dev, info->map);
> +	if (ret) {
> +		dev_err(&indio_dev->dev, "failed mapping iio, err: %d\n", ret);
> +		goto err_irq;
> +	}
> +
> +	ret = iio_device_register(indio_dev);
> +	if (ret)
> +		goto err_map;
> +
> +	ret = regulator_enable(info->vdd);
> +	if (ret)
> +		goto err_iio_dev;
> +
> +	clk_prepare_enable(info->clk);
> +
> +	exynos5_adc_hw_init(info);
> +
> +	ret = of_platform_populate(np, exynos5_adc_match, NULL, &pdev->dev);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "failed adding child nodes\n");
> +		goto err_of_populate;
> +	}
> +
> +	return 0;
> +
> +err_of_populate:
> +	device_for_each_child(&pdev->dev, NULL, exynos5_adc_remove_devices);
> +	regulator_disable(info->vdd);
> +	clk_disable_unprepare(info->clk);
> +err_iio_dev:
> +	iio_device_unregister(indio_dev);
> +err_map:
> +	iio_map_array_unregister(indio_dev, info->map);
> +err_irq:
> +	free_irq(info->irq, info);
> +err_iio:
> +	iio_device_free(indio_dev);
> +	return ret;
> +}
> +
> +static int exynos5_adc_remove(struct platform_device *pdev)
> +{
> +	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
> +	struct exynos5_adc *info = iio_priv(indio_dev);
> +
> +	regulator_disable(info->vdd);
> +	clk_disable_unprepare(info->clk);
> +	iio_device_unregister(indio_dev);
> +	iio_map_array_unregister(indio_dev, info->map);
> +	free_irq(info->irq, info);
> +	iio_device_free(indio_dev);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int exynos5_adc_suspend(struct device *dev)
> +{
> +	struct exynos5_adc *info = dev_get_data(dev);
> +	u32 con;
> +
> +	if (info->version == ADC_V2) {
> +		con = readl(ADC_V2_CON1(info->regs));
> +		con &= ~ADC_V1_CON_EN_START;
> +		writel(con, ADC_V2_CON1(info->regs));
> +	} else {
> +		con = readl(ADC_V1_CON(info->regs));
> +		con |= ADC_V1_CON_STANDBY;
> +		writel(con, ADC_V1_CON(info->regs));
> +	}
> +
> +	clk_disable_unprepare(info->clk);
> +	regulator_disable(info->vdd);
> +
> +	return 0;
> +}
> +
> +static int exynos5_adc_resume(struct device *dev)
> +{
> +	struct exynos5_adc *info = dev_get_data(dev);
> +	int ret;
> +
> +	ret = regulator_enable(info->vdd);
> +	if (ret)
> +		return ret;
> +
> +	clk_prepare_enable(info->clk);
> +
> +	exynos5_adc_hw_init(info);
> +
> +	return 0;
> +}
> +
> +#else
> +#define exynos5_adc_suspend NULL
> +#define exynos5_adc_resume NULL
> +#endif

with SIMPLE_DEV_PM_OPS, you don't need the else case above.

> +
> +static SIMPLE_DEV_PM_OPS(exynos5_adc_pm_ops,
> +			exynos5_adc_suspend,
> +			exynos5_adc_resume);
> +
> +static struct platform_driver exynos5_adc_driver = {
> +	.probe		= exynos5_adc_probe,
> +	.remove		= exynos5_adc_remove,
> +	.driver		= {
> +		.name	= "exynos5-adc",
> +		.owner	= THIS_MODULE,
> +		.of_match_table = of_match_ptr(exynos5_adc_match),
> +		.pm	= &exynos5_adc_pm_ops,
> +	},
> +};
> +
> +module_platform_driver(exynos5_adc_driver);
> +
> +MODULE_AUTHOR("Naveen Krishna Chatradhi <ch.naveen@samsung.com>");
> +MODULE_DESCRIPTION("Samsung EXYNOS5 ADC driver");
> +MODULE_LICENSE("GPL");
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
