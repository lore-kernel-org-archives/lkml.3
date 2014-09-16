Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbaIPSZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:25:28 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:35105 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722AbaIPSZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:25:25 -0400
MIME-Version: 1.0
In-Reply-To: <1410872360-27029-4-git-send-email-k.kozlowski@samsung.com>
References: <1410872360-27029-1-git-send-email-k.kozlowski@samsung.com>
	<1410872360-27029-4-git-send-email-k.kozlowski@samsung.com>
Date: Tue, 16 Sep 2014 20:25:25 +0200
Message-ID: <CAPDyKFrNYxSx3KwOLg0Bgw2TCtsC2-1YXjo1kSms2ie_b8sNww@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] amba: Don't unprepare the clocks if device driver
 wants IRQ safe runtime PM
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
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

On 16 September 2014 14:59, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
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

Do we really need a WARN_ON here. Driver shouldn't update their
irq_safe value dynamically, right!?

> +
> +               if (pcdev->irq_safe)
> +                       clk_disable(pcdev->pclk);

Since the irq_safe flag, could be considered as a special case, an
option for these cases - could be to leave the clock to be entirely
handled from the driver's runtime PM callback instead.

I wonder if that could simplify both for the driver and for the amba bus?

Russell, what do you think? Is it a bad idea?

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

I suggest to remove the local copy of this flag and to use
pm_runtime_is_irq_safe(dev) directly instead.

>                         break;
> +               }
>
>                 pm_runtime_disable(dev);
>                 pm_runtime_set_suspended(dev);
> diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
> index ad52027a9cbf..ce101e4497d6 100644
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

Kind regards
Uffe
