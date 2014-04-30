Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965142AbaD3UqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:46:08 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:59357 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbaD3UqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:46:05 -0400
Message-ID: <53616168.7010007@kernel.org>
Date: Wed, 30 Apr 2014 21:47:36 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de, cpgs@samsung.com,
        grundler@chromium.org, t.figa@samsung.com
Subject: Re: [PATCH 4/5 v3] iio: exynos_adc: do a soft reset in case of timeout
References: <1398850015-17761-1-git-send-email-ch.naveen@samsung.com> <1398850015-17761-5-git-send-email-ch.naveen@samsung.com>
In-Reply-To: <1398850015-17761-5-git-send-email-ch.naveen@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/04/14 10:26, Naveen Krishna Chatradhi wrote:
> Do a soft reset software if a timeout happens.
> This is applicable only for ADC_V2.
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
Applied to the togreg branch of iio.git

Thanks,
> ---
> Changes since v2:
> None
> Changes since v1:
> None
> v0:
> This change is a part of the patch reviewed at https://lkml.org/lkml/2013/11/5/92
>
>   drivers/iio/adc/exynos_adc.c |   50 ++++++++++++++++++++++--------------------
>   1 file changed, 26 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
> index 939aaf7..eddc58e 100644
> --- a/drivers/iio/adc/exynos_adc.c
> +++ b/drivers/iio/adc/exynos_adc.c
> @@ -112,6 +112,30 @@ static inline unsigned int exynos_adc_get_version(struct platform_device *pdev)
>   	return (unsigned int)match->data;
>   }
>
> +static void exynos_adc_hw_init(struct exynos_adc *info)
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
>   static int exynos_read_raw(struct iio_dev *indio_dev,
>   				struct iio_chan_spec const *chan,
>   				int *val,
> @@ -149,6 +173,8 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
>   	timeout = wait_for_completion_timeout
>   			(&info->completion, EXYNOS_ADC_TIMEOUT);
>   	if (timeout == 0) {
> +		dev_warn(&indio_dev->dev, "Conversion timed out! Resetting\n");
> +		exynos_adc_hw_init(info);
>   		ret = -ETIMEDOUT;
>   	} else {
>   		*val = info->value;
> @@ -230,30 +256,6 @@ static int exynos_adc_remove_devices(struct device *dev, void *c)
>   	return 0;
>   }
>
> -static void exynos_adc_hw_init(struct exynos_adc *info)
> -{
> -	u32 con1, con2;
> -
> -	if (info->version == ADC_V2) {
> -		con1 = ADC_V2_CON1_SOFT_RESET;
> -		writel(con1, ADC_V2_CON1(info->regs));
> -
> -		con2 = ADC_V2_CON2_OSEL | ADC_V2_CON2_ESEL |
> -			ADC_V2_CON2_HIGHF | ADC_V2_CON2_C_TIME(0);
> -		writel(con2, ADC_V2_CON2(info->regs));
> -
> -		/* Enable interrupts */
> -		writel(1, ADC_V2_INT_EN(info->regs));
> -	} else {
> -		/* set default prescaler values and Enable prescaler */
> -		con1 =  ADC_V1_CON_PRSCLV(49) | ADC_V1_CON_PRSCEN;
> -
> -		/* Enable 12-bit ADC resolution */
> -		con1 |= ADC_V1_CON_RES;
> -		writel(con1, ADC_V1_CON(info->regs));
> -	}
> -}
> -
>   static int exynos_adc_probe(struct platform_device *pdev)
>   {
>   	struct exynos_adc *info = NULL;
>

