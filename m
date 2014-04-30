Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945958AbaD3UnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:43:18 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:59333 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759042AbaD3UnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:43:16 -0400
Message-ID: <536160C0.6040004@kernel.org>
Date: Wed, 30 Apr 2014 21:44:48 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de, cpgs@samsung.com,
        grundler@chromium.org, t.figa@samsung.com
Subject: Re: [PATCH 3/5 v3] iio: exynos_adc: reduce timeout and use wait_for_completion_timeout
References: <1398850015-17761-1-git-send-email-ch.naveen@samsung.com> <1398850015-17761-4-git-send-email-ch.naveen@samsung.com>
In-Reply-To: <1398850015-17761-4-git-send-email-ch.naveen@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/04/14 10:26, Naveen Krishna Chatradhi wrote:
> ADC module on Exynos5 SoCs runs at 600KSPS. At this conversion rate,
> waiting for 1000 msecs is wasteful (incase of h/w failure).
>
> Hence, reduce the time out to 100msecs and use
> wait_for_completion_timeout() instead of
> wait_for_completion_interruptible_timeout()
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
Applied to the togreg branch of iio.git

Thanks
> ---
> Changes since v2:
> None
> Changes since v1:
> None
> v0:
> This change is a part of the patch reviewd at https://lkml.org/lkml/2013/11/5/92
>
>   drivers/iio/adc/exynos_adc.c |   18 +++++++++++-------
>   1 file changed, 11 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
> index ff98c5d..939aaf7 100644
> --- a/drivers/iio/adc/exynos_adc.c
> +++ b/drivers/iio/adc/exynos_adc.c
> @@ -82,7 +82,7 @@ enum adc_version {
>   #define ADC_CON_EN_START	(1u << 0)
>   #define ADC_DATX_MASK		0xFFF
>
> -#define EXYNOS_ADC_TIMEOUT	(msecs_to_jiffies(1000))
> +#define EXYNOS_ADC_TIMEOUT	(msecs_to_jiffies(100))
>
>   struct exynos_adc {
>   	void __iomem		*regs;
> @@ -121,6 +121,7 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
>   	struct exynos_adc *info = iio_priv(indio_dev);
>   	unsigned long timeout;
>   	u32 con1, con2;
> +	int ret;
>
>   	if (mask != IIO_CHAN_INFO_RAW)
>   		return -EINVAL;
> @@ -145,16 +146,19 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
>   				ADC_V1_CON(info->regs));
>   	}
>
> -	timeout = wait_for_completion_interruptible_timeout
> +	timeout = wait_for_completion_timeout
>   			(&info->completion, EXYNOS_ADC_TIMEOUT);
> -	*val = info->value;
> +	if (timeout == 0) {
> +		ret = -ETIMEDOUT;
> +	} else {
> +		*val = info->value;
> +		*val2 = 0;
> +		ret = IIO_VAL_INT;
> +	}
>
>   	mutex_unlock(&indio_dev->mlock);
>
> -	if (timeout == 0)
> -		return -ETIMEDOUT;
> -
> -	return IIO_VAL_INT;
> +	return ret;
>   }
>
>   static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
>

