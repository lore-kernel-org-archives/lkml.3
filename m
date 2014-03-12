Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbaCLPXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 11:23:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32902 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbaCLPXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 11:23:07 -0400
Date: Wed, 12 Mar 2014 16:22:49 +0100
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 4/4] devfreq: exynos4: Use SET_SYSTEM_SLEEP_PM_OPS macro
 instead of legacy method
In-reply-to: <1394624882-2989-5-git-send-email-cw00.choi@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, nm@ti.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@vger.kernel.org
Message-id: <1869652.x5hcu1bJcu@amdc1032>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7Bit
X-AuditID: cbfee61b-b7f456d000006dfd-01-53207bd9e6d4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t9jAd2b1QrBBvtf8Vpc//Kc1eJs0xt2
	i+4f2RaXd81hs/jce4TR4nbjCjaLNz/OMlk8XvGW3YHDY/Gel0wefVtWMXocv7GdyePzJrkA
	ligum5TUnMyy1CJ9uwSujIsdh9gKHgtWrL22haWBcQdfFyMHh4SAicSxafxdjJxAppjEhXvr
	2boYuTiEBBYxSix+fooZwmlhkji8YAYzSBWbgJXExPZVjCC2iICGxMy/VxhBipgF9jBKTO37
	xQqSEBZIl5j+bRNYEYuAqkTX468sIDavgKbEvWtXwWpEBTwldmxfyQZicwq4SnS2vQGLCwnU
	S6yYepYJol5Q4sfke2C9zALyEvv2T2WFsHUk9rdOY5vAKDALSdksJGWzkJQtYGRexSiaWpBc
	UJyUnmukV5yYW1yal66XnJ+7iREc5M+kdzCuarA4xCjAwajEw7tQUz5YiDWxrLgy9xCjBAez
	kgjv00KFYCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1utA4UE0hNLUrNTUwtSi2CyTBycUg2M
	vbLW9b6zf3XLn5TLeS/2hXHf/SOTNh6r+xR0Yp7yDB638j/LTbMYmBYphe5y/uu5T8w+KP+V
	xsOS7buu/dtvk7BUiCOwOL0k7S0j76EQ/3dPPL4cYvQ7oLROsWz9zK/RHUl+CY1dCWc/J3BW
	X1xp+uhS7cfph1vV2FZ6nteYybjYSObhD6WvSizFGYmGWsxFxYkAFQO17W4CAAA=
References: <1394624882-2989-1-git-send-email-cw00.choi@samsung.com>
 <1394624882-2989-5-git-send-email-cw00.choi@samsung.com>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday, March 12, 2014 08:48:02 PM Chanwoo Choi wrote:
> This patch use SET_SYSTEM_SLEEP_PM_OPS macro instead of legacy method. Also,
> Before entering suspend state, disable ppmu's clock to remove power-leakage
> in suspend state.

The main thing that this patch does is adding ->suspend method and PPMU
clocks handling and this should be reflected in the patch summary (i.e.
"devfreq: exynos4: fix PM suspend/resume handling for PPMU clocks") and in
the patch description. The fact that the patch also converts code to use
SET_SYSTEM_SLEEP_PM_OPS() macro is secondary.

> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/devfreq/exynos/exynos4_bus.c | 26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
> index 0c5b99e..7e1540a 100644
> --- a/drivers/devfreq/exynos/exynos4_bus.c
> +++ b/drivers/devfreq/exynos/exynos4_bus.c
> @@ -1229,16 +1229,40 @@ static int exynos4_busfreq_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PM_SLEEP
>  static int exynos4_busfreq_resume(struct device *dev)
>  {
>  	struct busfreq_data *data = dev_get_drvdata(dev);
> +	int i;
> +
> +	/* Enable clock after wake-up from suspend state */
> +	for (i = 0; i < PPMU_END; i++)
> +		clk_prepare_enable(data->clk_ppmu[i]);
>  
> +	/* Reset PPMU to check utilization again */
>  	busfreq_mon_reset(data);
> +
> +	return 0;
> +}
> +
> +static int exynos4_busfreq_suspend(struct device *dev)
> +{
> +	struct busfreq_data *data = dev_get_drvdata(dev);
> +	int i;
> +
> +	/*
> +	 * Disable clock before entering suspend state
> +	 * to reduce leakage power on suspend state.
> +	 */
> +	for (i = 0; i < PPMU_END; i++)
> +		clk_disable_unprepare(data->clk_ppmu[i]);
> +
>  	return 0;
>  }
> +#endif
>  
>  static const struct dev_pm_ops exynos4_busfreq_pm = {
> -	.resume	= exynos4_busfreq_resume,
> +	SET_SYSTEM_SLEEP_PM_OPS(exynos4_busfreq_suspend, exynos4_busfreq_resume)
>  };
>  
>  static const struct platform_device_id exynos4_busfreq_id[] = {

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

