Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234AbaKAAZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 20:25:11 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58799 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752545AbaKAAZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 20:25:08 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v8 3/5] amba: Don't unprepare the clocks if device driver wants IRQ safe runtime PM
Date: Sat, 01 Nov 2014 01:45:47 +0100
Message-ID: <1479283.dvHduzBoyf@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1413795888-18559-4-git-send-email-k.kozlowski@samsung.com>
References: <1413795888-18559-1-git-send-email-k.kozlowski@samsung.com> <1413795888-18559-4-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 20, 2014 11:04:46 AM Krzysztof Kozlowski wrote:
> The AMBA bus driver defines runtime Power Management functions which
> disable and unprepare AMBA bus clock. This is problematic for runtime PM
> because unpreparing a clock might sleep so it is not interrupt safe.
> 
> However some drivers may want to implement runtime PM functions in
> interrupt-safe way (see pm_runtime_irq_safe()). In such case the AMBA
> bus driver should only disable/enable the clock in runtime suspend and
> resume callbacks.
> 
> Detect the device driver behavior after calling its probe function and
> store it. During runtime suspend/resume deal with clocks according to
> stored value.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
> ---
>  drivers/amba/bus.c       | 29 +++++++++++++++++++++++++----
>  include/linux/amba/bus.h |  1 +
>  2 files changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
> index 47bbdc1b5be3..474434e1b1b9 100644
> --- a/drivers/amba/bus.c
> +++ b/drivers/amba/bus.c
> @@ -95,8 +95,18 @@ static int amba_pm_runtime_suspend(struct device *dev)
>  	struct amba_device *pcdev = to_amba_device(dev);
>  	int ret = pm_generic_runtime_suspend(dev);
>  
> -	if (ret == 0 && dev->driver)
> -		clk_disable_unprepare(pcdev->pclk);
> +	if (ret == 0 && dev->driver) {
> +		/*
> +		 * Drivers should not change pm_runtime_irq_safe()
> +		 * after probe.
> +		 */
> +		WARN_ON(pcdev->irq_safe != pm_runtime_is_irq_safe(dev));
> +
> +		if (pcdev->irq_safe)
> +			clk_disable(pcdev->pclk);
> +		else
> +			clk_disable_unprepare(pcdev->pclk);
> +	}
>  
>  	return ret;
>  }
> @@ -107,7 +117,16 @@ static int amba_pm_runtime_resume(struct device *dev)
>  	int ret;
>  
>  	if (dev->driver) {
> -		ret = clk_prepare_enable(pcdev->pclk);
> +		/*
> +		 * Drivers should not change pm_runtime_irq_safe()
> +		 * after probe.
> +		 */
> +		WARN_ON(pcdev->irq_safe != pm_runtime_is_irq_safe(dev));
> +
> +		if (pcdev->irq_safe)
> +			ret = clk_enable(pcdev->pclk);
> +		else
> +			ret = clk_prepare_enable(pcdev->pclk);
>  		/* Failure is probably fatal to the system, but... */
>  		if (ret)
>  			return ret;
> @@ -198,8 +217,10 @@ static int amba_probe(struct device *dev)
>  		pm_runtime_enable(dev);
>  
>  		ret = pcdrv->probe(pcdev, id);
> -		if (ret == 0)
> +		if (ret == 0) {
> +			pcdev->irq_safe = pm_runtime_is_irq_safe(dev);

This looks racy.

Is it guaranteed that runtime PM callbacks won't be run for the device
after pcdrv->probe() has returned and before setting pcdev->irq_safe?
If not, inconsistent behavior may ensue.

>  			break;
> +		}
>  
>  		pm_runtime_disable(dev);
>  		pm_runtime_set_suspended(dev);
> diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
> index ac02f9bd63dc..c4bae79851fb 100644
> --- a/include/linux/amba/bus.h
> +++ b/include/linux/amba/bus.h
> @@ -32,6 +32,7 @@ struct amba_device {
>  	struct clk		*pclk;
>  	unsigned int		periphid;
>  	unsigned int		irq[AMBA_NR_IRQS];
> +	unsigned int		irq_safe:1;
>  };
>  
>  struct amba_driver {
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
