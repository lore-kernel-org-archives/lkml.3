Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab3CFNP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:15:27 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:44850 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3CFNPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:15:23 -0500
MIME-Version: 1.0
In-Reply-To: <513701FF.3000805@metafoo.de>
References: <1362543092-6446-1-git-send-email-ch.naveen@samsung.com> <513701FF.3000805@metafoo.de>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Wed, 6 Mar 2013 22:15:02 +0900
Message-ID: <CAHfPSqBhAM7aSugC0nAmPnnBOycDOicTd81ZfgPg7YtRNuYkHA@mail.gmail.com>
Subject: Re: [PATCH] iio: adc: exynos5_adc: fix compilation warnings
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        gregkh@linuxfoundation.org, dan.carpenter@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 March 2013 17:44, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 03/06/2013 05:11 AM, Naveen Krishna Chatradhi wrote:
>> From: Naveen Krishna Ch <ch.naveen@samsung.com>
>>
>> Fixes the compilation warnings and potential NULL pointer
>> dereferencing pointed out by "Dan Carpenter".
>>
>
> I'd say that's a rather un-potential NULL pointer dereferencing, but if it
> makes the static checkers happy, why not. Since the same match table is used to
> match the device, probe won't be called unless there is a match, so
> of_match_node() will never return NULL in this case.
Right, i was thinking how it is such a potential error.
Anyway, Dan's suggestion of Kconfig change holds very good.
I will submit v2, with the appropriate changes.

>
>> Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
>> ---
>>  drivers/iio/adc/exynos_adc.c |   24 +++++++++++++++++-------
>>  1 file changed, 17 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
>> index ed6fdd7..67d07aa 100644
>> --- a/drivers/iio/adc/exynos_adc.c
>> +++ b/drivers/iio/adc/exynos_adc.c
>> @@ -92,7 +92,7 @@ struct exynos_adc {
>>       struct completion       completion;
>>
>>       u32                     value;
>> -     unsigned int            version;
>> +     unsigned int            version;
>>  };
>>
>>  static const struct of_device_id exynos_adc_match[] = {
>> @@ -102,12 +102,15 @@ static const struct of_device_id exynos_adc_match[] = {
>>  };
>>  MODULE_DEVICE_TABLE(of, exynos_adc_match);
>>
>> -static inline unsigned int exynos_adc_get_version(struct platform_device *pdev)
>> +static inline int exynos_adc_get_version(struct platform_device *pdev)
>>  {
>>       const struct of_device_id *match;
>>
>>       match = of_match_node(exynos_adc_match, pdev->dev.of_node);
>> -     return (unsigned int)match->data;
>> +     if (!match)
>> +             return -ENODEV;
>> +
>> +     return (int)match->data;
>>  }
>>
>>  static int exynos_read_raw(struct iio_dev *indio_dev,
>> @@ -117,7 +120,7 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
>>                               long mask)
>>  {
>>       struct exynos_adc *info = iio_priv(indio_dev);
>> -     unsigned long timeout;
>> +     int timeout;
>>       u32 con1, con2;
>>
>>       if (mask != IIO_CHAN_INFO_RAW)
>> @@ -255,7 +258,7 @@ static int exynos_adc_probe(struct platform_device *pdev)
>>       struct iio_dev *indio_dev = NULL;
>>       struct resource *mem;
>>       int ret = -ENODEV;
>> -     int irq;
>> +     int irq, version;
>>
>>       if (!np)
>>               return ret;
>> @@ -268,6 +271,15 @@ static int exynos_adc_probe(struct platform_device *pdev)
>>
>>       info = iio_priv(indio_dev);
>>
>> +     version = exynos_adc_get_version(pdev);
>> +     if (version < 0) {
>> +             dev_err(&pdev->dev, "no matching of_node, err = %d\n", version);
>> +             ret = version;
>> +             goto err_iio;
>> +     }
>> +
>> +     info->version = version;
>> +
>>       mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>
>>       info->regs = devm_request_and_ioremap(&pdev->dev, mem);
>> @@ -311,8 +323,6 @@ static int exynos_adc_probe(struct platform_device *pdev)
>>               goto err_irq;
>>       }
>>
>> -     info->version = exynos_adc_get_version(pdev);
>> -
>>       platform_set_drvdata(pdev, indio_dev);
>>
>>       indio_dev->name = dev_name(&pdev->dev);
>



-- 
Shine bright,
(: Nav :)
