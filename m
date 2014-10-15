Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaJOH1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 03:27:08 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63454 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaJOH1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 03:27:04 -0400
MIME-Version: 1.0
In-Reply-To: <1411566612-32277-4-git-send-email-k.kozlowski@samsung.com>
References: <1411566612-32277-1-git-send-email-k.kozlowski@samsung.com>
	<1411566612-32277-4-git-send-email-k.kozlowski@samsung.com>
Date: Wed, 15 Oct 2014 09:27:02 +0200
Message-ID: <CAPDyKFqTd06Z74G66=kkM2ZyV9w9Ec3jx-qt4Wmy36ns59oh1w@mail.gmail.com>
Subject: Re: [PATCH v7 3/5] amba: Don't unprepare the clocks if device driver
 wants IRQ safe runtime PM
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 September 2014 15:50, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
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

As I stated earlier, I think the local copy of the irq_safe flag and
the including WARN_ON is a bit unnecessary. Still since Russell
insisted in having them, I am happy as well. :-)

Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe

> ---
>  drivers/amba/bus.c       | 29 +++++++++++++++++++++++++----
>  include/linux/amba/bus.h |  1 +
>  2 files changed, 26 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
> index 3cf61a127ee5..e8fd5706954f 100644
> --- a/drivers/amba/bus.c
> +++ b/drivers/amba/bus.c
> @@ -94,8 +94,18 @@ static int amba_pm_runtime_suspend(struct device *dev)
>         struct amba_device *pcdev = to_amba_device(dev);
>         int ret = pm_generic_runtime_suspend(dev);
>
> -       if (ret == 0 && dev->driver)
> -               clk_disable_unprepare(pcdev->pclk);
> +       if (ret == 0 && dev->driver) {
> +               /*
> +                * Drivers should not change pm_runtime_irq_safe()
> +                * after probe.
> +                */
> +               WARN_ON(pcdev->irq_safe != pm_runtime_is_irq_safe(dev));
> +
> +               if (pcdev->irq_safe)
> +                       clk_disable(pcdev->pclk);
> +               else
> +                       clk_disable_unprepare(pcdev->pclk);
> +       }
>
>         return ret;
>  }
> @@ -106,7 +116,16 @@ static int amba_pm_runtime_resume(struct device *dev)
>         int ret;
>
>         if (dev->driver) {
> -               ret = clk_prepare_enable(pcdev->pclk);
> +               /*
> +                * Drivers should not change pm_runtime_irq_safe()
> +                * after probe.
> +                */
> +               WARN_ON(pcdev->irq_safe != pm_runtime_is_irq_safe(dev));
> +
> +               if (pcdev->irq_safe)
> +                       ret = clk_enable(pcdev->pclk);
> +               else
> +                       ret = clk_prepare_enable(pcdev->pclk);
>                 /* Failure is probably fatal to the system, but... */
>                 if (ret)
>                         return ret;
> @@ -191,8 +210,10 @@ static int amba_probe(struct device *dev)
>                 pm_runtime_enable(dev);
>
>                 ret = pcdrv->probe(pcdev, id);
> -               if (ret == 0)
> +               if (ret == 0) {
> +                       pcdev->irq_safe = pm_runtime_is_irq_safe(dev);
>                         break;
> +               }
>
>                 pm_runtime_disable(dev);
>                 pm_runtime_set_suspended(dev);
> diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
> index bb352d0bd737..fd0c0bfa1d38 100644
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
