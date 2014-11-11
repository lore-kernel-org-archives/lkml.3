Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaKKV0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:26:47 -0500
Received: from mail2.kmu-office.ch ([178.209.48.109]:49210 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaKKV0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:26:45 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Tue, 11 Nov 2014 22:27:53 +0100
From: Stefan Agner <stefan@agner.ch>
To: Sanchayan Maity <maitysanchayan@gmail.com>
Cc: rtc-linux@googlegroups.com, shawn.guo@linaro.org, linux@arm.linux.org.uk,
        kernel@pengutronix.de, b35083@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [[PATCHv2] 3/3] drivers/rtc/rtc-snvs: Add clock support
In-Reply-To: <30e496ce2d6521e608df3b68b73b3e05caa1daef.1415364391.git.maitysanchayan@gmail.com>
References: <cover.1415364391.git.maitysanchayan@gmail.com>
 <30e496ce2d6521e608df3b68b73b3e05caa1daef.1415364391.git.maitysanchayan@gmail.com>
Message-ID: <7807253ec0fd349b5bb1489e0d3b1347@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue Nov 11 22:26:42 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 54627f1212813454319614
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-07 14:04, Sanchayan Maity wrote:
> This patch adds clock enable and disable support for
> the SNVS peripheral, which is required for using the
> RTC within the SNVS block.

What happens if the device tree node is there while this patch is not
applied? I guess the driver would load, but since the clocks of the
peripheral are not enabled the first register access would lead to bus
error or similar. If this is the case, this would break bisectability.
You should move the device tree patch to the end.

Other than that
Acked-by: Stefan Agner <stefan@agner.ch>

--
Stefan

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

