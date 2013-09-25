Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab3IYP7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 11:59:50 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:50063 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab3IYP7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 11:59:48 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-c9-5243087209ed
Message-id: <52430871.6040003@samsung.com>
Date: Wed, 25 Sep 2013 17:59:45 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: m.chehab@samsung.com, t.figa@samsung.com, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, s.nawrocki@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/4] media: s5p-tv: Fix sdo driver to work with CCF
References: <1379775649-6331-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1379775649-6331-4-git-send-email-m.krawczuk@partner.samsung.com>
In-reply-to: <1379775649-6331-4-git-send-email-m.krawczuk@partner.samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t/xq7pFHM5BBv+nmVhsnLGe1eJs0xt2
	i02Pr7FaXN41h82iZ8NWVouL6+QtTq85xWxx+E07q8X6Ga9ZHDg9Ni+p9zj4bg+TR9+WVYwe
	nzfJBbBEcdmkpOZklqUW6dslcGVsb5vCVPBHomLCuWfsDYwnRLoYOTkkBEwklk6bwAJhi0lc
	uLeeDcQWEljKKHFqjnAXIxeQ/RnIntbNCpLgFdCSWHF4FTOIzSKgKrFy8VImEJsNaNCxJZ8Z
	QWxRgQiJP6f3QdULSvyYfA9sgYiAqcS7u9fYQIYyCzxglPjauAosISzgJXH9/lQWiG0TGSWW
	zHnPDpLgFPCTONi3C2wbs4COxP7WaWwQtrzE5jVvmScwCsxCsmQWkrJZSMoWMDKvYhRNLU0u
	KE5KzzXUK07MLS7NS9dLzs/dxAgJ9y87GBcfszrEKMDBqMTDq8nmHCTEmlhWXJl7iFGCg1lJ
	hPcsE1CINyWxsiq1KD++qDQntfgQIxMHp1QDo939IC3RYPOX1j29bIWHzkzf/yvG59CDJQFy
	DGqXtp3peLD1mMAv4Xni1dt1r4h/8NzQqruZYebNJ486FrDErrr0b1v1Jfn/u1onLvt67NoT
	p9vrZ5htCyr8d6HF8m2UY7B84Wbnk87lxk/Lgk+2Lz66YHfP+bPPp9bP/FpUVBi4+FgkQ1Rn
	/lwlluKMREMt5qLiRABt36KfVQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename to 'media: s5p-tv: sdo: integrate with CCF'

On 09/21/2013 05:00 PM, Mateusz Krawczuk wrote:
> Replace clk_enable by clock_enable_prepare and clk_disable with clk_disable_unprepare.
> Clock prepare is required by Clock Common Framework, and old clock driver didn`t support it.
> Without it Common Clock Framework prints a warning.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/platform/s5p-tv/sdo_drv.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
> index e49ac6c..17272e1 100644
> --- a/drivers/media/platform/s5p-tv/sdo_drv.c
> +++ b/drivers/media/platform/s5p-tv/sdo_drv.c
> @@ -208,9 +208,9 @@ static int sdo_streamon(struct sdo_device *sdev)
>  	clk_get_rate(sdev->fout_vpll));
>  	/* enable clock in SDO */
>  	sdo_write_mask(sdev, SDO_CLKCON, ~0, SDO_TVOUT_CLOCK_ON);
> -	ret = clk_enable(sdev->dacphy);
> +	ret = clk_prepare_enable(sdev->dacphy);
>  	if (ret < 0) {
> -		dev_err(sdev->dev, "clk_enable(dacphy) failed\n");
> +		dev_err(sdev->dev, "clk_prepare_enable(dacphy) failed\n");
>  		goto fail;
>  	}
>  	/* enable DAC */
> @@ -229,7 +229,7 @@ static int sdo_streamoff(struct sdo_device *sdev)
>  	int tries;
>  
>  	sdo_write_mask(sdev, SDO_DAC, 0, SDO_POWER_ON_DAC);
> -	clk_disable(sdev->dacphy);
> +	clk_disable_unprepare(sdev->dacphy);
>  	sdo_write_mask(sdev, SDO_CLKCON, 0, SDO_TVOUT_CLOCK_ON);
>  	for (tries = 100; tries; --tries) {
>  		if (sdo_read(sdev, SDO_CLKCON) & SDO_TVOUT_CLOCK_READY)
> @@ -273,7 +273,7 @@ static int sdo_runtime_suspend(struct device *dev)
>  	dev_info(dev, "suspend\n");
>  	regulator_disable(sdev->vdet);
>  	regulator_disable(sdev->vdac);
> -	clk_disable(sdev->sclk_dac);
> +	clk_disable_unprepare(sdev->sclk_dac);
>  	return 0;
>  }
>  
> @@ -285,7 +285,7 @@ static int sdo_runtime_resume(struct device *dev)
>  
>  	dev_info(dev, "resume\n");
>  
> -	ret = clk_enable(sdev->sclk_dac);
> +	ret = clk_prepare_enable(sdev->sclk_dac);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -318,7 +318,7 @@ static int sdo_runtime_resume(struct device *dev)
>  vdac_r_dis:
>  	regulator_disable(sdev->vdac);
>  dac_clk_dis:
> -	clk_disable(sdev->sclk_dac);
> +	clk_disable_unprepare(sdev->sclk_dac);
>  	return ret;
>  }
>  
> @@ -424,7 +424,11 @@ static int sdo_probe(struct platform_device *pdev)
>  	}
>  
>  	/* enable gate for dac clock, because mixer uses it */
> -	clk_enable(sdev->dac);
> +	ret = clk_prepare_enable(sdev->dac);
> +	if (ret < 0) {
> +		dev_err(dev, "clk_prepare_enable(dac) failed\n");
> +		goto fail_fout_vpll;
> +	}
>  
>  	/* configure power management */
>  	pm_runtime_enable(dev);
> @@ -463,7 +467,7 @@ static int sdo_remove(struct platform_device *pdev)
>  	struct sdo_device *sdev = sd_to_sdev(sd);
>  
>  	pm_runtime_disable(&pdev->dev);
> -	clk_disable(sdev->dac);
> +	clk_disable_unprepare(sdev->dac);
>  	clk_put(sdev->fout_vpll);
>  	clk_put(sdev->dacphy);
>  	clk_put(sdev->dac);
> 

