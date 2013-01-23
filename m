Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3AWMwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 07:52:11 -0500
Received: from smtp-out-073.synserver.de ([212.40.185.73]:1418 "EHLO
	smtp-out-073.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab3AWMwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 07:52:07 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 2339
Message-ID: <50FFDD2A.9040102@metafoo.de>
Date: Wed, 23 Jan 2013 13:52:58 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, dianders@chromium.org,
        gregkh@linuxfoundation.org, naveenkrishna.ch@gmail.com
Subject: Re: [PATCH] iio: adc: add exynos5 adc driver under iio framwork
References: <1358775470-21278-1-git-send-email-ch.naveen@samsung.com> <1358917086-4148-1-git-send-email-ch.naveen@samsung.com>
In-Reply-To: <1358917086-4148-1-git-send-email-ch.naveen@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2013 05:58 AM, Naveen Krishna Chatradhi wrote:
> This patch add an ADC IP found on EXYNOS5 series socs from Samsung.
> Also adds the Documentation for device tree bindings.
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

Hi,

The patch looks mostly good now. As for the mappings, the problem is that we
currently do not have any device tree bindings for IIO. So a proper solution
would be to add dt bindings for IIO.

[...]
> diff --git a/drivers/iio/adc/exynos5_adc.c b/drivers/iio/adc/exynos5_adc.c
> new file mode 100644
> index 0000000..8982675
> --- /dev/null
> +++ b/drivers/iio/adc/exynos5_adc.c
[...]
> +
> +/** ADC core in EXYNOS5410 has 10 channels,
> + * ADC core in EXYNOS5250 has 8 channels
> +*/

Minor nitpick, according to Documentation/Codingsytle multi-line comments
should look like this:

/*
 * Text
 * Text
 */

[...]
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

While devm_request_and_ioremap takes care of the printing and error you
still need to check whether regs is non NULL.

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
> +	init_completion(&info->completion);

Since the completion is used in the IRQ handler it should be initialized
before the IRQ is requested.

> +
> +	indio_dev->name = dev_name(&pdev->dev);
> +	indio_dev->dev.parent = &pdev->dev;
> +	indio_dev->dev.of_node = pdev->dev.of_node;
> +	indio_dev->info = &exynos5_adc_iio_info;
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +	indio_dev->channels = exynos5_adc_iio_channels;
> +	indio_dev->num_channels = ARRAY_SIZE(exynos5_adc_iio_channels);

Shouldn't the number of channels depend on the ADC version? E.g. 8 for v1
and 10 for v2?

> +
> +	info->map = exynos5_adc_iio_maps;
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

You never disable the regulator again. I think you need to do that before it
is freed.

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
[..]
