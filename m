Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaKDTGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:06:20 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:44907 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaKDTGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:06:18 -0500
MIME-Version: 1.0
In-Reply-To: <1415105570-7871-3-git-send-email-k.kozlowski@samsung.com>
References: <1415105570-7871-1-git-send-email-k.kozlowski@samsung.com>
	<1415105570-7871-3-git-send-email-k.kozlowski@samsung.com>
Date: Tue, 4 Nov 2014 20:06:17 +0100
Message-ID: <CAPDyKFo6o8v9u6+MdGSRMmHeMcODqCcdToHXoJqVGcsRVgQwdA@mail.gmail.com>
Subject: Re: [PATCH v9 2/4] amba: Don't unprepare the clocks if device driver
 wants IRQ safe runtime PM
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 November 2014 13:52, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> The AMBA bus driver defines runtime Power Management functions which
> disable and unprepare AMBA bus clock. This is problematic for runtime PM
> because unpreparing a clock might sleep so it is not interrupt safe.
>
> However some drivers may want to implement runtime PM functions in
> interrupt-safe way (see pm_runtime_irq_safe()). In such case the AMBA
> bus driver should only disable/enable the clock in runtime suspend and
> resume callbacks.
>
> Detect the device driver behavior during runtime suspend. During runtime
> resume deal with clocks according to stored value.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/amba/bus.c       | 24 ++++++++++++++++++++----
>  include/linux/amba/bus.h |  1 +
>  2 files changed, 21 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
> index 47bbdc1b5be3..27ec8882ec8e 100644
> --- a/drivers/amba/bus.c
> +++ b/drivers/amba/bus.c
> @@ -85,6 +85,13 @@ static struct device_attribute amba_dev_attrs[] = {
>  };
>
>  #ifdef CONFIG_PM
> +
> +#ifdef CONFIG_PM_RUNTIME
> +#define get_pm_runtime_irq_safe(dev)   ((dev)->power.irq_safe)
> +#else
> +#define get_pm_runtime_irq_safe(dev)   1

No, this doesn't work for those drivers that isn't configured as
irq_safe. The pm_runtime_force_suspend() invoked from the driver's
system PM suspend callback, will expect clocks to be unprepared when
CONFIG_PM_RUNTIME is unset.

To address this issue, in principle we need to know whether the driver
has invoked pm_runtime_irq_safe(), even when CONFIG_PM_RUNTIME is
unset.

This may be solved by the help of PM core:
1) Move the irq_safe member in the struct dev_pm_info, outside the
#ifdef CONFIG_PM_RUNTIME.
2) Let the pm_runtime_irq_safe() function be implemented for CONFIG_PM
instead of CONFIG_PM_RUNTIME.

If the PM core maintainers don't like that approach we can always add
an amba specific wrapper function for pm_runtime_irq_safe() and store
the information needed in the struct amba_device.

Kind regards
Uffe

> +#endif
> +
>  /*
>   * Hooks to provide runtime PM of the pclk (bus clock).  It is safe to
>   * enable/disable the bus clock at runtime PM suspend/resume as this
> @@ -95,8 +102,14 @@ static int amba_pm_runtime_suspend(struct device *dev)
>         struct amba_device *pcdev = to_amba_device(dev);
>         int ret = pm_generic_runtime_suspend(dev);
>
> -       if (ret == 0 && dev->driver)
> -               clk_disable_unprepare(pcdev->pclk);
> +       if (ret == 0 && dev->driver) {
> +               pcdev->irq_safe = get_pm_runtime_irq_safe(dev);
> +
> +               if (pcdev->irq_safe)
> +                       clk_disable(pcdev->pclk);
> +               else
> +                       clk_disable_unprepare(pcdev->pclk);
> +       }
>
>         return ret;
>  }
> @@ -107,7 +120,10 @@ static int amba_pm_runtime_resume(struct device *dev)
>         int ret;
>
>         if (dev->driver) {
> -               ret = clk_prepare_enable(pcdev->pclk);
> +               if (pcdev->irq_safe)
> +                       ret = clk_enable(pcdev->pclk);
> +               else
> +                       ret = clk_prepare_enable(pcdev->pclk);
>                 /* Failure is probably fatal to the system, but... */
>                 if (ret)
>                         return ret;
> @@ -115,7 +131,7 @@ static int amba_pm_runtime_resume(struct device *dev)
>
>         return pm_generic_runtime_resume(dev);
>  }
> -#endif
> +#endif /* CONFIG_PM */
>
>  static const struct dev_pm_ops amba_pm = {
>         .suspend        = pm_generic_suspend,
> diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
> index ac02f9bd63dc..c4bae79851fb 100644
> --- a/include/linux/amba/bus.h
> +++ b/include/linux/amba/bus.h
> @@ -32,6 +32,7 @@ struct amba_device {
>         struct clk              *pclk;
>         unsigned int            periphid;
>         unsigned int            irq[AMBA_NR_IRQS];
> +       unsigned int            irq_safe:1;
>  };
>
>  struct amba_driver {
> --
> 1.9.1
>
