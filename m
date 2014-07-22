Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaGVKnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:43:09 -0400
Received: from gloria.sntech.de ([95.129.55.99]:34154 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbaGVKnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:43:07 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, jic23@kernel.org,
        ch.naveen@samsung.com, kgene.kim@samsung.com,
        kyungmin.park@samsung.com, t.figa@samsung.com,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/2] iio: adc: exynos_adc: Add support for S3C24xx ADC
Date: Tue, 22 Jul 2014 12:44:28 +0200
Message-ID: <175757227.TPQdXAQiJt@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <5200888.DXoC06U953@wuerfel>
References: <1405995074-3271-1-git-send-email-cw00.choi@samsung.com> <1405995074-3271-3-git-send-email-cw00.choi@samsung.com> <5200888.DXoC06U953@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 22. Juli 2014, 10:39:38 schrieb Arnd Bergmann:
> On Tuesday 22 July 2014 11:11:14 Chanwoo Choi wrote:
> > This patch add support for s3c2410/s3c2416/s3c2440/s3c2443 ADC. The
> > s3c24xx
> > is alomost same as ADCv1. But, There are a little difference as following:
> > - ADCMUX register address to select channel
> > - ADCDAT mask (10bit or 12bit ADC resolution according to SoC version)
> 
> Very good, thanks for doing this patch!
> 
> (adding Heiko to Cc, he's probably interested in seeing this as well.

indeed. Thanks for implementing this.

While trying to build a test setup for this, I noticed two points:

(1) I'm not sure what the second register (a "phy enable register" according
to the binding) is supposed to be.
According to binding and adc code it is mandatory, but I didn't find any
lone adc register in the s3c2416 manual.


(2) You might need something along the lines of:

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index 11b048a..088c99a 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -129,7 +129,7 @@ config AT91_ADC
 
 config EXYNOS_ADC
        tristate "Exynos ADC driver support"
-       depends on ARCH_EXYNOS || (OF && COMPILE_TEST)
+       depends on ARCH_EXYNOS || ARCH_S3C24XX || ARCH_S3C64XX || (OF && COMPILE_TEST)
        help
          Core support for the ADC block found in the Samsung EXYNOS series
          of SoCs for drivers such as the touchscreen and hwmon to use to share


Thanks
Heiko

> 
> One comment:
> > @@ -101,12 +107,14 @@ struct exynos_adc {
> > 
> >  	struct completion	completion;
> >  	
> >  	u32			value;
> > 
> > +	u32			value2;
> > 
> >  	unsigned int            version;
> >  
> >  };
> > 
> > ...
> > @@ -365,7 +448,7 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
> > 
> >  		ret = -ETIMEDOUT;
> >  	
> >  	} else {
> >  	
> >  		*val = info->value;
> > 
> > -		*val2 = 0;
> > +		*val2 = info->value2;
> > 
> >  		ret = IIO_VAL_INT;
> >  	
> >  	}
> > 
> > @@ -377,9 +460,11 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
> > 
> >  static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
> >  {
> >  
> >  	struct exynos_adc *info = (struct exynos_adc *)dev_id;
> > 
> > +	u32 mask = info->data->mask;
> > 
> >  	/* Read value */
> > 
> > -	info->value = readl(ADC_V1_DATX(info->regs)) & ADC_DATX_MASK;
> > +	info->value = readl(ADC_V1_DATX(info->regs)) & mask;
> > +	info->value2 = readl(ADC_V1_DATY(info->regs)) & mask;
> > 
> >  	/* clear irq */
> >  	if (info->data->clear_irq)
> 
> If I understand it right, this would only be necessary if we want
> to do the touchscreen driver as a separate iio client using the
> in-kernel interfaces. As Jonathan Cameron commented, we probably
> don't want to do that though. Even if we do, it should be a separate
> patch and not mixed in with the s3c24xx support.
> 
> Aside from this:
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> 	Arnd

