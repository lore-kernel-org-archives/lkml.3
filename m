Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934998Ab3BNUyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 15:54:19 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:33680 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758339Ab3BNUyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 15:54:17 -0500
Message-ID: <511D4F5F.6010200@metafoo.de>
Date: Thu, 14 Feb 2013 21:55:59 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
MIME-Version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, dianders@chromium.org,
        gregkh@linuxfoundation.org, naveenkrishna.ch@gmail.com
Subject: Re: [PATCH v6] iio: adc: add exynos adc driver under iio framwork
References: <1358775470-21278-1-git-send-email-ch.naveen@samsung.com> <1360843890-28466-1-git-send-email-ch.naveen@samsung.com>
In-Reply-To: <1360843890-28466-1-git-send-email-ch.naveen@samsung.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2013 01:11 PM, Naveen Krishna Chatradhi wrote:
> This patch adds New driver to support:
> 1. Supports ADC IF found on EXYNOS4412/EXYNOS5250
>    and future SoCs from Samsung
> 2. Add ADC driver under iio/adc framework
> 3. Also adds the Documentation for device tree bindings
> 
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>

Looks good to me. There is one bug left in debugfs_reg_access function though,
which should be fixed before the driver is merged.

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
> Changes since v5:
> 
> 1. Fixed comments from Olof (ADC hardware version handling)
> 2. Rebased on top of comming OF framework for IIO by "Guenter Roeck".
> 
>  .../bindings/arm/samsung/exynos5-adc.txt           |   42 ++
>  drivers/iio/adc/Kconfig                            |    7 +
>  drivers/iio/adc/Makefile                           |    1 +
>  drivers/iio/adc/exynos_adc.c                       |  438 ++++++++++++++++++++
>  4 files changed, 488 insertions(+)
>  .../devicetree/bindings/arm/samsung/exynos-adc.txt |   52 +++
>  drivers/iio/adc/Kconfig                            |    7 +
>  drivers/iio/adc/Makefile                           |    1 +
>  drivers/iio/adc/exynos_adc.c                       |  437 ++++++++++++++++++++
>  4 files changed, 497 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
>  create mode 100644 drivers/iio/adc/exynos_adc.c
> 
> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> new file mode 100644
> index 0000000..f686378
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> @@ -0,0 +1,52 @@
[...]
> diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
> index 2d5f100..fabac2c 100644
> --- a/drivers/iio/adc/Makefile
> +++ b/drivers/iio/adc/Makefile
> @@ -10,6 +10,7 @@ obj-$(CONFIG_AD7791) += ad7791.o
>  obj-$(CONFIG_AD7793) += ad7793.o
>  obj-$(CONFIG_AD7887) += ad7887.o
>  obj-$(CONFIG_AT91_ADC) += at91_adc.o
> +obj-$(CONFIG_EXYNOS_ADC) += exynos_adc.o
>  obj-$(CONFIG_LP8788_ADC) += lp8788_adc.o
>  obj-$(CONFIG_MAX1363) += max1363.o
>  obj-$(CONFIG_TI_ADC081C) += ti-adc081c.o
> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
> new file mode 100644
> index 0000000..144a9e2
> --- /dev/null
> +++ b/drivers/iio/adc/exynos_adc.c
> @@ -0,0 +1,437 @@
> [...]
> +static int exynos_read_raw(struct iio_dev *indio_dev,
> +				struct iio_chan_spec const *chan,
> +				int *val,
> +				int *val2,
> +				long mask)
> +{
> +	struct exynos_adc *info = iio_priv(indio_dev);
> +	u32 con1, con2;
> +
> +	if (mask == IIO_CHAN_INFO_RAW) {

How about rewriting this as:

	if (mask != IIO_CHAN_INFO_RAW)
		return -EINVAL;

	mutex_lock(...);
	...

keeps the indention level low.

> +		mutex_lock(&indio_dev->mlock);
> +
> +		/* Select the channel to be used and Trigger conversion */
> +		if (info->version == ADC_V2) {
> +			con2 = readl(ADC_V2_CON2(info->regs));
> +			con2 &= ~ADC_V2_CON2_ACH_MASK;
> +			con2 |= ADC_V2_CON2_ACH_SEL(chan->address);
> +			writel(con2, ADC_V2_CON2(info->regs));
> +
> +			con1 = readl(ADC_V2_CON1(info->regs));
> +			writel(con1 | ADC_CON_EN_START,
> +					ADC_V2_CON1(info->regs));
> +		} else {
> +			writel(chan->address, ADC_V1_MUX(info->regs));
> +
> +			con1 = readl(ADC_V1_CON(info->regs));
> +			writel(con1 | ADC_CON_EN_START,
> +					ADC_V1_CON(info->regs));
> +		}
> +
> +		wait_for_completion(&info->completion);

I'd add at least a timeout so you don't get stuck here forever if something
goes wrong.

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
[...]
> +static int exynos_adc_reg_access(struct iio_dev *indio_dev,
> +			      unsigned reg, unsigned writeval,
> +			      unsigned *readval)
> +{
> +	struct exynos_adc *info = iio_priv(indio_dev);
> +	u32 ret;
> +
> +	mutex_lock(&indio_dev->mlock);

I don't think the locking here is necessary.

> +
> +	if (readval != NULL) {
> +		ret = readl(info->regs + reg);
> +		*readval = ret;

At the end of the function you return the read value, you should return 0 on
success though.

> +	} else
> +		ret = -EINVAL;
> +
> +	mutex_unlock(&indio_dev->mlock);


How about rewriting the function as:

	if (readval == NULL)
		return -EINVAL;

	*readval = readl(info->regs + reg)

	return 0;

> +
> +	return ret;
> +}
[...]
> +
> +static int exynos_adc_remove(struct platform_device *pdev)
> +{
> +	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
> +	struct exynos_adc *info = iio_priv(indio_dev);
> +

Do you need to remove the child devices here as well?

> +	regulator_disable(info->vdd);
> +	clk_disable_unprepare(info->clk);
> +	iio_device_unregister(indio_dev);
> +	free_irq(info->irq, info);
> +	iio_device_free(indio_dev);
> +
> +	return 0;
> +}

