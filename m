Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936405AbaH1JWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:22:01 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:57306 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932467AbaH1JV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:21:59 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-3b-53fef4b425b6
Message-id: <1409217715.20020.7.camel@AMDC1943>
Subject: Re: [PATCH v9 3/5] rtc: max77686: Fail to probe if no RTC regmap
 irqchip is set
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        rtc-linux@googlegroups.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 28 Aug 2014 11:21:55 +0200
In-reply-to: <1408350877-15921-4-git-send-email-javier.martinez@collabora.co.uk>
References: <1408350877-15921-1-git-send-email-javier.martinez@collabora.co.uk>
 <1408350877-15921-4-git-send-email-javier.martinez@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t/xa7pbvvwLNth00cxiycWr7BZnlx1k
	szj6u8Bi0+NrrBaXd81hs5hxfh+Txanrn9ks9nd2MDpweMxuuMji8ff5dRaPPRNPsnlsXlLv
	ceVEE6vH9Hk/mTw+b5ILYI/isklJzcksSy3St0vgytg3/zJ7wR6Bile3m5gbGFfwdjFyckgI
	mEisaZ/DBmGLSVy4tx7MFhJYyijRsMi1i5ELyP7MKPH9YANQgoODV0BfYtJuGZAaYYEoiW2v
	/rKA2GwCxhKbly8B6xURsJO4sfohM0gvs8AfRon1p+4wgyRYBFQlHn7+AGZzCgRIPHj/igVi
	wVRGiZ39M8AmMQuoS0yat4gZZJmEgLJEY78bSJhXQFDix+R7UCXyEpvXvGWewCgwC0nHLCRl
	s5CULWBkXsUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kREv5fdjAuPmZ1iFGAg1GJh3dD6b9g
	IdbEsuLK3EOMEhzMSiK8R48DhXhTEiurUovy44tKc1KLDzEycXBKNTBaXnx73F5v74K7/L52
	q3dvNP6tJzPROvPb1Y2H531I5LW8c2zyRTvu+8u/PrMzbFl0aleaxlOdQ8viQid999nyRq5p
	ksh1649ttg5m9/snu7N8c7IUrinbmzv52p3/Vncuhhv8iPvy8k+AoehCC/aDr9Xb/zC95D9x
	YMIbYRaR/MSDv5qqs49+VGIpzkg01GIuKk4EAOjj7YtdAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-08-18 at 10:34 +0200, Javier Martinez Canillas wrote:
> The max77686 mfd driver adds a regmap IRQ chip which creates an
> IRQ domain that is used to map the virtual RTC alarm1 interrupt.
> 
> The RTC driver assumes that this will always be true since the
> PMIC IRQ is a required property according to the max77686 DT
> binding doc. If an "interrupts" property is not defined for a
> max77686 PMIC, then the mfd probe function will fail and the
> RTC platform driver will never be probed. But even when it is
> not possible to probe the rtc-max77686 driver without a regmap
> IRQ chip, it's better to explicitly check if the IRQ chip data
> is not NULL and gracefully fail instead of getting an OOPS.

The OOPS was possible only with Bartlomiej's patch because he changed
the MFD driver probe function to skip IRQ setup on lack of interrupts.
In current state the OOPS should not happen so mentioning OOPS in commit
message may be misleading. Maybe just don't put the OOPS here?

Anyway the patch looks good and a check for non-null
regmap_irq_chip_data is still a valid precaution so:

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof


> 
> Reported-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
> 
> Fixes the issue reported by Krzystof in: https://lkml.org/lkml/2014/8/8/121
> ---
>  drivers/rtc/rtc-max77686.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
> index 7bb5433..55396bb 100644
> --- a/drivers/rtc/rtc-max77686.c
> +++ b/drivers/rtc/rtc-max77686.c
> @@ -466,6 +466,12 @@ static int max77686_rtc_probe(struct platform_device *pdev)
>  		goto err_rtc;
>  	}
>  
> +	if (!max77686->rtc_irq_data) {
> +		ret = -EINVAL;
> +		dev_err(&pdev->dev, "%s: no RTC regmap IRQ chip\n", __func__);
> +		goto err_rtc;
> +	}
> +
>  	info->virq = regmap_irq_get_virq(max77686->rtc_irq_data,
>  					 MAX77686_RTCIRQ_RTCA1);
>  	if (!info->virq) {

