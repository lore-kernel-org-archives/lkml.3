Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaGTLYH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 07:24:07 -0400
Received: from smtp-out-201.synserver.de ([212.40.185.201]:1074 "EHLO
	smtp-out-201.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbaGTLYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 07:24:05 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 27003
Message-ID: <53CBA6CB.501@metafoo.de>
Date: Sun, 20 Jul 2014 13:23:55 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Jonathan Cameron <jic23@kernel.org>
CC: Peter Meerwald <pmeerw@pmeerw.net>, Hartmut Knaack <knaack.h@gmx.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        =?UTF-8?B?ImVkZGllKOiUoeaeqyki?= <cf@rock-chips.com>,
        huangtao@rock-chips.com
Subject: Re: [PATCH v5 1/2] iio: adc: add driver for Rockchip saradc
References: <3234956.d4q5ZB3IB8@diego> <2386463.CW7L8vIufx@diego>
In-Reply-To: <2386463.CW7L8vIufx@diego>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 10:43 PM, Heiko Stübner wrote:

Looks really good overall.

[...]
> +static int rockchip_saradc_read_raw(struct iio_dev *indio_dev,
> +				    struct iio_chan_spec const *chan,
> +				    int *val, int *val2, long mask)
> +{
> +	struct rockchip_saradc *info = iio_priv(indio_dev);
> +	int ret;
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_RAW:
> +		mutex_lock(&indio_dev->mlock);
> +
> +		/* 8 clock periods as delay between power up and start cmd */
> +		writel_relaxed(8, info->regs + SARADC_DLY_PU_SOC);
> +

It makes sense to call reinit_completion() here.

> +		/* Select the channel to be used and trigger conversion */
> +		writel(SARADC_CTRL_POWER_CTRL
> +				| (chan->channel & SARADC_CTRL_CHN_MASK)
> +				| SARADC_CTRL_IRQ_ENABLE,
> +		       info->regs + SARADC_CTRL);
> +
> +		if (!wait_for_completion_timeout(&info->completion,
> +						 SARADC_TIMEOUT)) {
> +			writel_relaxed(0, info->regs + SARADC_CTRL);
> +			mutex_unlock(&indio_dev->mlock);
> +			return -ETIMEDOUT;
> +		}
> +
> +		*val = info->last_val;
> +		mutex_unlock(&indio_dev->mlock);
> +		return IIO_VAL_INT;
[...]
> +static int rockchip_saradc_probe(struct platform_device *pdev)
> +{
> +	struct rockchip_saradc *info = NULL;
> +	struct device_node *np = pdev->dev.of_node;
> +	struct iio_dev *indio_dev = NULL;
> +	struct resource	*mem;
> +	int ret;
> +	int irq;
> +	u32 rate;
> +
> +	if (!np)
> +		return -ENODEV;
> +
> +	indio_dev = devm_iio_device_alloc(&pdev->dev, sizeof(*info));
> +	if (!indio_dev) {
> +		dev_err(&pdev->dev, "failed allocating iio device\n");
> +		return -ENOMEM;
> +	}
> +	info = iio_priv(indio_dev);
> +
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	info->regs = devm_request_and_ioremap(&pdev->dev, mem);

devm_request_and_ioremap() is deprecated an will be removed in the next 
release[1]. Use devm_ioremap_resource(), note that devm_ioremap_resource() 
returns a ERR_PTR instead of NULL on error.

[1] https://lkml.org/lkml/2014/6/11/26

> +	if (!info->regs)
> +		return -ENOMEM;
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		dev_err(&pdev->dev, "no irq resource?\n");
> +		return irq;
> +	}
> +
> +	ret = devm_request_irq(&pdev->dev, irq, rockchip_saradc_isr,
> +			       0, dev_name(&pdev->dev), info);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "failed requesting irq %d\n", irq);
> +		return ret;
> +	}
> +
> +	init_completion(&info->completion);

Since the completion is used in the interrupt callback it must be 
initialized before the interrupt is requested.

> +
[...]
> +	/* use a default of 1MHz for the converter clock */
> +	ret = of_property_read_u32(np, "clock-frequency", &rate);
> +	if (ret < 0)
> +		rate = 1000000;

Should this really be in the devicetree or shouldn't this be user 
configurable at runtime?

[...]
