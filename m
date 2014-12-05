Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472AbaLEAMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 19:12:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42816 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933454AbaLEAMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 19:12:09 -0500
Date: Thu, 4 Dec 2014 16:12:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sanchayan Maity <maitysanchayan@gmail.com>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com, stefan@agner.ch,
        shawn.guo@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCHv2] drivers/rtc/rtc-snvs: Add clock support
Message-Id: <20141204161207.0753031dc675793e9534c1de@linux-foundation.org>
In-Reply-To: <bf8571fc7474877be39a5a4e9d4705358e63d840.1417585458.git.maitysanchayan@gmail.com>
References: <cover.1417585458.git.maitysanchayan@gmail.com>
	<bf8571fc7474877be39a5a4e9d4705358e63d840.1417585458.git.maitysanchayan@gmail.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  3 Dec 2014 11:28:55 +0530 Sanchayan Maity <maitysanchayan@gmail.com> wrote:

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
> ...

I assume this hasn't been tested with CONFIG_HAVE_CLK=n.  It all
*looks* OK, but the clk API does its tests for clk==NULL in some very
deep places.

> --- a/drivers/rtc/rtc-snvs.c
> +++ b/drivers/rtc/rtc-snvs.c
.
> ...
>
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

>From my reading, there's no need to test data->clk here -
clk_disable_unprepare() handles that.

It doesn't hurt to test it - a reasonable approach would be to look
around at what other users of the clk API are doing, and do that.


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

Ditto.

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

It could be omitted here also.

>  	return 0;
>  }
>  #endif

