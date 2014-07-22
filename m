Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaGVIj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 04:39:57 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:53265 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaGVIjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 04:39:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: jic23@kernel.org, ch.naveen@samsung.com, kgene.kim@samsung.com,
        kyungmin.park@samsung.com, t.figa@samsung.com,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        heiko.stuebner@bq.com
Subject: Re: [PATCH 2/2] iio: adc: exynos_adc: Add support for S3C24xx ADC
Date: Tue, 22 Jul 2014 10:39:38 +0200
Message-ID: <5200888.DXoC06U953@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1405995074-3271-3-git-send-email-cw00.choi@samsung.com>
References: <1405995074-3271-1-git-send-email-cw00.choi@samsung.com> <1405995074-3271-3-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:W47rk9YUQ/ub4GzBLPO33wx75ymbD/M4317Tpwvp0NK
 DJws9nsmOJTkgsDNTPE1D62WLUCLUhGKnZNTHbi1QPcZbBCaQg
 d3wI/tcfW3JHTi1/G7n5xnzbjV9ch2uHXus/ZKk8C2LUJViYpK
 hLs50lnhGxHU5vglfvz2mujDjb9NsW7oN8gcH39ZdNJ5L2JXTA
 L339igCRC4/Z6qjwgHHVmLIQ9c34dHOmmSb05lnTolAOEIbnnJ
 CH6gXNaAcFwtbKteSPzaR4uQ2KpALj1Qa/O8atW3/6mmoQXRRj
 qBKIaqFcpEbgRD9niMC172dKODqjI3y4kiA1wKB+NAyh7isPjB
 j3ArpZ4vg4OHVdWliee4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2014 11:11:14 Chanwoo Choi wrote:
> This patch add support for s3c2410/s3c2416/s3c2440/s3c2443 ADC. The s3c24xx
> is alomost same as ADCv1. But, There are a little difference as following:
> - ADCMUX register address to select channel
> - ADCDAT mask (10bit or 12bit ADC resolution according to SoC version)

Very good, thanks for doing this patch!

(adding Heiko to Cc, he's probably interested in seeing this as well.

One comment:
 
> @@ -101,12 +107,14 @@ struct exynos_adc {
>  	struct completion	completion;
>  
>  	u32			value;
> +	u32			value2;
>  	unsigned int            version;
>  };
> ...
> @@ -365,7 +448,7 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
>  		ret = -ETIMEDOUT;
>  	} else {
>  		*val = info->value;
> -		*val2 = 0;
> +		*val2 = info->value2;
>  		ret = IIO_VAL_INT;
>  	}
>  
> @@ -377,9 +460,11 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
>  static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
>  {
>  	struct exynos_adc *info = (struct exynos_adc *)dev_id;
> +	u32 mask = info->data->mask;
>  
>  	/* Read value */
> -	info->value = readl(ADC_V1_DATX(info->regs)) & ADC_DATX_MASK;
> +	info->value = readl(ADC_V1_DATX(info->regs)) & mask;
> +	info->value2 = readl(ADC_V1_DATY(info->regs)) & mask;
>  
>  	/* clear irq */
>  	if (info->data->clear_irq)

If I understand it right, this would only be necessary if we want
to do the touchscreen driver as a separate iio client using the
in-kernel interfaces. As Jonathan Cameron commented, we probably
don't want to do that though. Even if we do, it should be a separate
patch and not mixed in with the s3c24xx support.

Aside from this:

Acked-by: Arnd Bergmann <arnd@arndb.de>

	Arnd
