Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbaKLP3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:29:50 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:44515 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbaKLP3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:29:48 -0500
MIME-Version: 1.0
In-Reply-To: <1415802748-30530-4-git-send-email-k.kozlowski@samsung.com>
References: <1415802748-30530-1-git-send-email-k.kozlowski@samsung.com>
	<1415802748-30530-4-git-send-email-k.kozlowski@samsung.com>
Date: Wed, 12 Nov 2014 16:29:47 +0100
Message-ID: <CAPDyKFoJFGhyNSqrie9TddBOTvZ2-RVqvET9Y6JCvJqh+FMgww@mail.gmail.com>
Subject: Re: [PATCH v11 3/6] amba: Don't unprepare the clocks if device driver
 wants IRQ safe runtime PM
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org, Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 November 2014 15:32, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> The AMBA bus driver defines runtime Power Management functions which
> disable and unprepare AMBA bus clock. This is problematic for runtime PM
> because unpreparing a clock might sleep so it is not interrupt safe.
>
> However some drivers may want to implement runtime PM functions in
> interrupt-safe way (see pm_runtime_irq_safe()). In such case the AMBA
> bus driver should only disable/enable the clock in runtime suspend and
> resume callbacks.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

> ---
>  drivers/amba/bus.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
> index a4ac490dd784..c2153a1d1981 100644
> --- a/drivers/amba/bus.c
> +++ b/drivers/amba/bus.c
> @@ -95,8 +95,12 @@ static int amba_pm_runtime_suspend(struct device *dev)
>         struct amba_device *pcdev = to_amba_device(dev);
>         int ret = pm_generic_runtime_suspend(dev);
>
> -       if (ret == 0 && dev->driver)
> -               clk_disable_unprepare(pcdev->pclk);
> +       if (ret == 0 && dev->driver) {
> +               if (pm_runtime_is_irq_safe(dev))
> +                       clk_disable(pcdev->pclk);
> +               else
> +                       clk_disable_unprepare(pcdev->pclk);
> +       }
>
>         return ret;
>  }
> @@ -107,7 +111,10 @@ static int amba_pm_runtime_resume(struct device *dev)
>         int ret;
>
>         if (dev->driver) {
> -               ret = clk_prepare_enable(pcdev->pclk);
> +               if (pm_runtime_is_irq_safe(dev))
> +                       ret = clk_enable(pcdev->pclk);
> +               else
> +                       ret = clk_prepare_enable(pcdev->pclk);
>                 /* Failure is probably fatal to the system, but... */
>                 if (ret)
>                         return ret;
> @@ -115,7 +122,7 @@ static int amba_pm_runtime_resume(struct device *dev)
>
>         return pm_generic_runtime_resume(dev);
>  }
> -#endif
> +#endif /* CONFIG_PM */
>
>  static const struct dev_pm_ops amba_pm = {
>         .suspend        = pm_generic_suspend,
> --
> 1.9.1
>
