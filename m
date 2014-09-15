Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaIOOZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:25:59 -0400
Received: from gloria.sntech.de ([95.129.55.99]:46249 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbaIOOZ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:25:57 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Hartmut Knaack <knaack.h@gmx.de>
Cc: Jonathan Cameron <jic23@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2] iio: adc: rockchip_saradc: add support for rk3066-tsadc variant
Date: Mon, 15 Sep 2014 16:28:11 +0200
Message-ID: <1853847.FBXYEe6Y9k@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <5414CB03.1000104@gmx.de>
References: <1629907.fyghANjlk9@diego> <5414CB03.1000104@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 14. September 2014, 00:53:55 schrieb Hartmut Knaack:
> Heiko Stübner schrieb, Am 11.09.2014 00:22:
> > Older Rockchip SoCs, at least the rk3066, used a slightly modified saradc
> > for temperature measurements. This so called tsadc does not contain any
> > active parts like temperature interrupts and only supports polling the
> > current temperature. The returned voltage can then be converted by a
> > suitable thermal driver to and actual temperature and used for thermal
> > handling.
> 
> Looking over it again, I have a two more comments inline.
> 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> > ---
> > changes since v1:
> > - use GENMASK instead of creating the mask manually
> > 
> >   as suggested by Hartmut Knaack
> > 
> > I've also opted for simply keeping the indent mismatch in
> > struct rockchip_saradc, as I don't think it's worth the churn
> > it produces
> > 
> >  .../bindings/iio/adc/rockchip-saradc.txt           |  2 +-
> >  drivers/iio/adc/rockchip_saradc.c                  | 62
> >  +++++++++++++++++----- 2 files changed, 50 insertions(+), 14
> >  deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/iio/adc/rockchip-saradc.txt
> > b/Documentation/devicetree/bindings/iio/adc/rockchip-saradc.txt index
> > 5d3ec1d..a9a5fe1 100644
> > --- a/Documentation/devicetree/bindings/iio/adc/rockchip-saradc.txt
> > +++ b/Documentation/devicetree/bindings/iio/adc/rockchip-saradc.txt
> > @@ -1,7 +1,7 @@
> > 
> >  Rockchip Successive Approximation Register (SAR) A/D Converter bindings
> > 
> >  Required properties:
> > -- compatible: Should be "rockchip,saradc"
> > +- compatible: Should be "rockchip,saradc" or "rockchip,rk3066-tsadc"
> > 
> >  - reg: physical base address of the controller and length of memory
> >  mapped
> >  
> >         region.
> >  
> >  - interrupts: The interrupt number to the cpu. The interrupt specifier
> >  format> 
> > diff --git a/drivers/iio/adc/rockchip_saradc.c
> > b/drivers/iio/adc/rockchip_saradc.c index e074a0b..99200b7 100644
> > --- a/drivers/iio/adc/rockchip_saradc.c
> > +++ b/drivers/iio/adc/rockchip_saradc.c
> > @@ -18,13 +18,13 @@
> > 
> >  #include <linux/interrupt.h>
> >  #include <linux/io.h>
> >  #include <linux/of.h>
> > 
> > +#include <linux/of_device.h>
> > 
> >  #include <linux/clk.h>
> >  #include <linux/completion.h>
> >  #include <linux/regulator/consumer.h>
> >  #include <linux/iio/iio.h>
> >  
> >  #define SARADC_DATA			0x00
> > 
> > -#define SARADC_DATA_MASK		0x3ff
> > 
> >  #define SARADC_STAS			0x04
> >  #define SARADC_STAS_BUSY		BIT(0)
> > 
> > @@ -38,15 +38,22 @@
> > 
> >  #define SARADC_DLY_PU_SOC		0x0c
> >  #define SARADC_DLY_PU_SOC_MASK		0x3f
> > 
> > -#define SARADC_BITS			10
> > 
> >  #define SARADC_TIMEOUT			msecs_to_jiffies(100)
> > 
> > +struct rockchip_saradc_data {
> > +	int				num_bits;
> > +	const struct iio_chan_spec	*channels;
> > +	int				num_channels;
> > +	unsigned long			clk_rate;
> > +};
> > +
> > 
> >  struct rockchip_saradc {
> >  
> >  	void __iomem		*regs;
> >  	struct clk		*pclk;
> >  	struct clk		*clk;
> >  	struct completion	completion;
> >  	struct regulator	*vref;
> > 
> > +	const struct rockchip_saradc_data *data;
> > 
> >  	u16			last_val;
> >  
> >  };
> > 
> > @@ -90,7 +97,7 @@ static int rockchip_saradc_read_raw(struct iio_dev
> > *indio_dev,> 
> >  		}
> >  		
> >  		*val = ret / 1000;
> > 
> > -		*val2 = SARADC_BITS;
> > +		*val2 = info->data->num_bits;
> > 
> >  		return IIO_VAL_FRACTIONAL_LOG2;
> >  	
> >  	default:
> >  		return -EINVAL;
> > 
> > @@ -103,7 +110,7 @@ static irqreturn_t rockchip_saradc_isr(int irq, void
> > *dev_id)> 
> >  	/* Read value */
> >  	info->last_val = readl_relaxed(info->regs + SARADC_DATA);
> > 
> > -	info->last_val &= SARADC_DATA_MASK;
> > +	info->last_val &= GENMASK(info->data->num_bits - 1, 0);
> > 
> >  	/* Clear irq & power down adc */
> >  	writel_relaxed(0, info->regs + SARADC_CTRL);
> > 
> > @@ -133,12 +140,44 @@ static const struct iio_chan_spec
> > rockchip_saradc_iio_channels[] = {> 
> >  	ADC_CHANNEL(2, "adc2"),
> >  
> >  };
> > 
> > +static const struct rockchip_saradc_data saradc_data = {
> > +	.num_bits = 10,
> > +	.channels = rockchip_saradc_iio_channels,
> > +	.num_channels = ARRAY_SIZE(rockchip_saradc_iio_channels),
> > +	.clk_rate = 1000000,
> > +};
> > +
> > +static const struct iio_chan_spec rockchip_rk3066_tsadc_iio_channels[] =
> > {
> > +	ADC_CHANNEL(0, "adc0"),
> > +	ADC_CHANNEL(1, "adc1"),
> > +};
> > +
> > +static const struct rockchip_saradc_data rk3066_tsadc_data = {
> > +	.num_bits = 12,
> > +	.channels = rockchip_rk3066_tsadc_iio_channels,
> > +	.num_channels = ARRAY_SIZE(rockchip_rk3066_tsadc_iio_channels),
> > +	.clk_rate = 50000,
> > +};
> > +
> > +static const struct of_device_id rockchip_saradc_match[] = {
> > +	{
> > +		.compatible = "rockchip,saradc",
> > +		.data = &saradc_data,
> > +	}, {
> > +		.compatible = "rockchip,rk3066-tsadc",
> > +		.data = &rk3066_tsadc_data,
> > +	},
> > +	{},
> > +};
> > +MODULE_DEVICE_TABLE(of, rockchip_saradc_match);
> > +
> > 
> >  static int rockchip_saradc_probe(struct platform_device *pdev)
> >  {
> >  
> >  	struct rockchip_saradc *info = NULL;
> >  	struct device_node *np = pdev->dev.of_node;
> >  	struct iio_dev *indio_dev = NULL;
> >  	struct resource	*mem;
> > 
> > +	const struct of_device_id *match;
> > 
> >  	int ret;
> >  	int irq;
> > 
> > @@ -152,6 +191,9 @@ static int rockchip_saradc_probe(struct
> > platform_device *pdev)> 
> >  	}
> >  	info = iio_priv(indio_dev);
> > 
> > +	match = of_match_device(rockchip_saradc_match, &pdev->dev);
> 
> Is it 100% safe to go on without checking match for validity?

In this case yes :-)

The very first check in _probe is against (!np), so at this point we're sure we 
were already matched against one of the entries in the match-table.


> 
> > +	info->data = match->data;
> > +
> > 
> >  	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >  	info->regs = devm_ioremap_resource(&pdev->dev, mem);
> >  	if (IS_ERR(info->regs))
> > 
> > @@ -195,7 +237,7 @@ static int rockchip_saradc_probe(struct
> > platform_device *pdev)> 
> >  	 * Use a default of 1MHz for the converter clock.
> >  	 * This may become user-configurable in the future.
> >  	 */
> 
> This comment becomes invalid and should be adjusted or droped.

I'll adapt it and send a v3


Heiko


> 
> > -	ret = clk_set_rate(info->clk, 1000000);
> > +	ret = clk_set_rate(info->clk, info->data->clk_rate);
> > 
> >  	if (ret < 0) {
> >  	
> >  		dev_err(&pdev->dev, "failed to set adc clk rate, %d\n", ret);
> >  		return ret;
> > 
> > @@ -227,8 +269,8 @@ static int rockchip_saradc_probe(struct
> > platform_device *pdev)> 
> >  	indio_dev->info = &rockchip_saradc_iio_info;
> >  	indio_dev->modes = INDIO_DIRECT_MODE;
> > 
> > -	indio_dev->channels = rockchip_saradc_iio_channels;
> > -	indio_dev->num_channels = ARRAY_SIZE(rockchip_saradc_iio_channels);
> > +	indio_dev->channels = info->data->channels;
> > +	indio_dev->num_channels = info->data->num_channels;
> > 
> >  	ret = iio_device_register(indio_dev);
> >  	if (ret)
> > 
> > @@ -296,12 +338,6 @@ static int rockchip_saradc_resume(struct device *dev)
> > 
> >  static SIMPLE_DEV_PM_OPS(rockchip_saradc_pm_ops,
> >  
> >  			 rockchip_saradc_suspend, rockchip_saradc_resume);
> > 
> > -static const struct of_device_id rockchip_saradc_match[] = {
> > -	{ .compatible = "rockchip,saradc" },
> > -	{},
> > -};
> > -MODULE_DEVICE_TABLE(of, rockchip_saradc_match);
> > -
> > 
> >  static struct platform_driver rockchip_saradc_driver = {
> >  
> >  	.probe		= rockchip_saradc_probe,
> >  	.remove		= rockchip_saradc_remove,

