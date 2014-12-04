Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaLDJep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:34:45 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:36288 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbaLDJen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:34:43 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Thu, 04 Dec 2014 10:36:55 +0100
From: Stefan Agner <stefan@agner.ch>
To: Sanchayan Maity <maitysanchayan@gmail.com>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCHv2] drivers/rtc/rtc-snvs: Add clock support
In-Reply-To: <bf8571fc7474877be39a5a4e9d4705358e63d840.1417585458.git.maitysanchayan@gmail.com>
References: <cover.1417585458.git.maitysanchayan@gmail.com>
 <bf8571fc7474877be39a5a4e9d4705358e63d840.1417585458.git.maitysanchayan@gmail.com>
Message-ID: <c1bf5bc1ac719833ab108cdc3509d881@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Dec  4 10:34:04 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 54802a8c12811866636528
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-03 06:58, Sanchayan Maity wrote:
> This patch adds clock enable and disable support for
> the SNVS peripheral, which is required for using the
> RTC within the SNVS block.
> 
> The clock is not strictly enforced, as this would
> break the i.MX devices. The clocking for the i.MX
> devices seems to be enabled elsewhere and enabling
> RTC SNVS for Vybrid results in a crash. This patch
> adds the clock support but also makes it optional
> so Vybrid platform can use the clock if defined
> while making sure not to break i.MX .
> 
> Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
> ---
>  drivers/rtc/rtc-snvs.c |   34 ++++++++++++++++++++++++++++++++--
>  1 file changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-snvs.c b/drivers/rtc/rtc-snvs.c
> index fa384fe..d4a6512 100644
> --- a/drivers/rtc/rtc-snvs.c
> +++ b/drivers/rtc/rtc-snvs.c
> @@ -17,6 +17,7 @@
>  #include <linux/of_device.h>
>  #include <linux/platform_device.h>
>  #include <linux/rtc.h>
> +#include <linux/clk.h>
>  
>  /* These register offsets are relative to LP (Low Power) range */
>  #define SNVS_LPCR		0x04
> @@ -39,6 +40,7 @@ struct snvs_rtc_data {
>  	void __iomem *ioaddr;
>  	int irq;
>  	spinlock_t lock;
> +	struct clk *clk;
>  };
>  
>  static u32 rtc_read_lp_counter(void __iomem *ioaddr)
> @@ -260,6 +262,18 @@ static int snvs_rtc_probe(struct platform_device *pdev)
>  	if (data->irq < 0)
>  		return data->irq;
>  
> +	data->clk = devm_clk_get(&pdev->dev, "snvs-rtc");
> +	if (IS_ERR(data->clk)) {
> +		data->clk = NULL;
> +	} else {
> +		ret = clk_prepare_enable(data->clk);
> +		if (ret) {
> +			dev_err(&pdev->dev,
> +				"Could not prepare or enable the snvs clock\n");
> +			return ret;
> +		}
> +	}
> +
>  	platform_set_drvdata(pdev, data);
>  
>  	spin_lock_init(&data->lock);
> @@ -280,7 +294,7 @@ static int snvs_rtc_probe(struct platform_device *pdev)
>  	if (ret) {
>  		dev_err(&pdev->dev, "failed to request irq %d: %d\n",
>  			data->irq, ret);
> -		return ret;
> +		goto error_rtc_device_register;
>  	}
>  
>  	data->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
> @@ -288,10 +302,16 @@ static int snvs_rtc_probe(struct platform_device *pdev)
>  	if (IS_ERR(data->rtc)) {
>  		ret = PTR_ERR(data->rtc);
>  		dev_err(&pdev->dev, "failed to register rtc: %d\n", ret);
> -		return ret;
> +		goto error_rtc_device_register;
>  	}
>  
>  	return 0;
> +
> +error_rtc_device_register:
> +	if (data->clk)
> +		clk_disable_unprepare(data->clk);
> +
> +	return ret;
>  }
>  
>  #ifdef CONFIG_PM_SLEEP
> @@ -302,16 +322,26 @@ static int snvs_rtc_suspend(struct device *dev)
>  	if (device_may_wakeup(dev))
>  		enable_irq_wake(data->irq);
>  
> +	if (data->clk)
> +		clk_disable_unprepare(data->clk);
> +
>  	return 0;
>  }
>  
>  static int snvs_rtc_resume(struct device *dev)
>  {
>  	struct snvs_rtc_data *data = dev_get_drvdata(dev);
> +	int ret;
>  
>  	if (device_may_wakeup(dev))
>  		disable_irq_wake(data->irq);
>  
> +	if (data->clk) {
> +		ret = clk_prepare_enable(data->clk);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	return 0;
>  }
>  #endif


Acked-by: Stefan Agner <stefan@agner.ch>

--
Stefan

