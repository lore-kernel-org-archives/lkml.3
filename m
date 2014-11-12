Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbaKLKsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 05:48:14 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36993 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbaKLKsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 05:48:12 -0500
Date: Wed, 12 Nov 2014 18:47:42 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Sanchayan Maity <maitysanchayan@gmail.com>
Cc: Stefan Agner <stefan@agner.ch>, rtc-linux@googlegroups.com,
        linux@arm.linux.org.uk, kernel@pengutronix.de, b35083@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [[PATCHv2] 3/3] drivers/rtc/rtc-snvs: Add clock support
Message-ID: <20141112104735.GK2704@dragon>
References: <cover.1415364391.git.maitysanchayan@gmail.com>
 <30e496ce2d6521e608df3b68b73b3e05caa1daef.1415364391.git.maitysanchayan@gmail.com>
 <7807253ec0fd349b5bb1489e0d3b1347@agner.ch>
 <546320D3.2030501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546320D3.2030501@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 02:26:51PM +0530, Sanchayan Maity wrote:
> On Wednesday 12 November 2014 02:57 AM, Stefan Agner wrote:
> > On 2014-11-07 14:04, Sanchayan Maity wrote:
> >> This patch adds clock enable and disable support for
> >> the SNVS peripheral, which is required for using the
> >> RTC within the SNVS block.
> > 
> > What happens if the device tree node is there while this patch is not
> > applied? I guess the driver would load, but since the clocks of the
> > peripheral are not enabled the first register access would lead to bus
> > error or similar. If this is the case, this would break bisectability.
> > You should move the device tree patch to the end.
> > 
> 
> If the DT node was present with this patch not applied, the driver would 
> still crash with a bus error, since the clocks for SNVS are not explicitly 
> enabled anywhere else. I had not thought about any problems which might 
> occur later with git bisect. Will move this to the end with v3.

Since changes on rtc-snvs.c will need to go through RTC subsystem tree,
that means I cannot apply DTS changes until the driver patch gets
mainlined and appears on my tree.

Shawn

> 
> Thanks.
> 
> Regards,
> Sanchayan.
> 
> > Other than that
> > Acked-by: Stefan Agner <stefan@agner.ch>
> > 
> > --
> > Stefan
> > 
> >>
> >> Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
> >> ---
> >>  drivers/rtc/rtc-snvs.c |   34 ++++++++++++++++++++++++++++++++--
> >>  1 file changed, 32 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/rtc/rtc-snvs.c b/drivers/rtc/rtc-snvs.c
> >> index fa384fe..d4a6512 100644
> >> --- a/drivers/rtc/rtc-snvs.c
> >> +++ b/drivers/rtc/rtc-snvs.c
> >> @@ -17,6 +17,7 @@
> >>  #include <linux/of_device.h>
> >>  #include <linux/platform_device.h>
> >>  #include <linux/rtc.h>
> >> +#include <linux/clk.h>
> >>  
> >>  /* These register offsets are relative to LP (Low Power) range */
> >>  #define SNVS_LPCR		0x04
> >> @@ -39,6 +40,7 @@ struct snvs_rtc_data {
> >>  	void __iomem *ioaddr;
> >>  	int irq;
> >>  	spinlock_t lock;
> >> +	struct clk *clk;
> >>  };
> >>  
> >>  static u32 rtc_read_lp_counter(void __iomem *ioaddr)
> >> @@ -260,6 +262,18 @@ static int snvs_rtc_probe(struct platform_device *pdev)
> >>  	if (data->irq < 0)
> >>  		return data->irq;
> >>  
> >> +	data->clk = devm_clk_get(&pdev->dev, "snvs-rtc");
> >> +	if (IS_ERR(data->clk)) {
> >> +		data->clk = NULL;
> >> +	} else {
> >> +		ret = clk_prepare_enable(data->clk);
> >> +		if (ret) {
> >> +			dev_err(&pdev->dev,
> >> +				"Could not prepare or enable the snvs clock\n");
> >> +			return ret;
> >> +		}
> >> +	}
> >> +
> >>  	platform_set_drvdata(pdev, data);
> >>  
> >>  	spin_lock_init(&data->lock);
> >> @@ -280,7 +294,7 @@ static int snvs_rtc_probe(struct platform_device *pdev)
> >>  	if (ret) {
> >>  		dev_err(&pdev->dev, "failed to request irq %d: %d\n",
> >>  			data->irq, ret);
> >> -		return ret;
> >> +		goto error_rtc_device_register;
> >>  	}
> >>  
> >>  	data->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
> >> @@ -288,10 +302,16 @@ static int snvs_rtc_probe(struct platform_device *pdev)
> >>  	if (IS_ERR(data->rtc)) {
> >>  		ret = PTR_ERR(data->rtc);
> >>  		dev_err(&pdev->dev, "failed to register rtc: %d\n", ret);
> >> -		return ret;
> >> +		goto error_rtc_device_register;
> >>  	}
> >>  
> >>  	return 0;
> >> +
> >> +error_rtc_device_register:
> >> +	if (data->clk)
> >> +		clk_disable_unprepare(data->clk);
> >> +
> >> +	return ret;
> >>  }
> >>  
> >>  #ifdef CONFIG_PM_SLEEP
> >> @@ -302,16 +322,26 @@ static int snvs_rtc_suspend(struct device *dev)
> >>  	if (device_may_wakeup(dev))
> >>  		enable_irq_wake(data->irq);
> >>  
> >> +	if (data->clk)
> >> +		clk_disable_unprepare(data->clk);
> >> +
> >>  	return 0;
> >>  }
> >>  
> >>  static int snvs_rtc_resume(struct device *dev)
> >>  {
> >>  	struct snvs_rtc_data *data = dev_get_drvdata(dev);
> >> +	int ret;
> >>  
> >>  	if (device_may_wakeup(dev))
> >>  		disable_irq_wake(data->irq);
> >>  
> >> +	if (data->clk) {
> >> +		ret = clk_prepare_enable(data->clk);
> >> +		if (ret)
> >> +			return ret;
> >> +	}
> >> +
> >>  	return 0;
> >>  }
> >>  #endif
> > 
