Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaKFKAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 05:00:09 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:45361 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbaKFKAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 05:00:01 -0500
MIME-Version: 1.0
In-Reply-To: <1415263010-7992-2-git-send-email-k.kozlowski@samsung.com>
References: <1415263010-7992-1-git-send-email-k.kozlowski@samsung.com>
	<1415263010-7992-2-git-send-email-k.kozlowski@samsung.com>
Date: Thu, 6 Nov 2014 11:00:00 +0100
Message-ID: <CAPDyKFoiAPJu-wp1c1N05tWggOE+2agUMDEV03TnpEjY1S6Jzg@mail.gmail.com>
Subject: Re: [PATCH v10 1/5] PM / Runtime: Allow accessing irq_safe if no PM_RUNTIME
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Russell King <linux@arm.linux.org.uk>,
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

On 6 November 2014 09:36, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> Some drivers (e.g. bus drivers) may want to check if power.irq_safe was
> called by child driver, regardless of CONFIG_PM_RUNTIME.
>
> An example scenario is amba/bus.c and dma/pl330.c drivers. The runtime
> suspend/resume callbacks in amba bus driver act differently if irq_safe
> was set by child driver (in irq_safe mode bus clock is only disabled).
>
> The pl330 driver sets irq_safe and assumes that amba bus driver will
> only disable the clock in runtime PM. So in system sleep suspend
> callback the pl330 driver unprepares the clock after calling
> pm_runtime_force_suspend().
>
> However inconsistency would appear if CONFIG_PM_RUNTIME is not set and
> child drivers do not want the irq_safe runtime PM. In such case amba bus
> driver still has to know whether child driver wanted irq_safe - by
> looking at dev->power.irq_safe field.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

FWIW: Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe

> ---
>  include/linux/pm.h         | 2 +-
>  include/linux/pm_runtime.h | 5 ++++-
>  2 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/pm.h b/include/linux/pm.h
> index 383fd68aaee1..b05fa954f50d 100644
> --- a/include/linux/pm.h
> +++ b/include/linux/pm.h
> @@ -566,6 +566,7 @@ struct dev_pm_info {
>         bool                    ignore_children:1;
>         bool                    early_init:1;   /* Owned by the PM core */
>         bool                    direct_complete:1;      /* Owned by the PM core */
> +       unsigned int            irq_safe:1;     /* PM runtime */
>         spinlock_t              lock;
>  #ifdef CONFIG_PM_SLEEP
>         struct list_head        entry;
> @@ -590,7 +591,6 @@ struct dev_pm_info {
>         unsigned int            run_wake:1;
>         unsigned int            runtime_auto:1;
>         unsigned int            no_callbacks:1;
> -       unsigned int            irq_safe:1;
>         unsigned int            use_autosuspend:1;
>         unsigned int            timer_autosuspends:1;
>         unsigned int            memalloc_noio:1;
> diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
> index 367f49b9a1c9..d94a65662a60 100644
> --- a/include/linux/pm_runtime.h
> +++ b/include/linux/pm_runtime.h
> @@ -166,7 +166,10 @@ static inline bool pm_runtime_suspended_if_enabled(struct device *dev) { return
>  static inline bool pm_runtime_enabled(struct device *dev) { return false; }
>
>  static inline void pm_runtime_no_callbacks(struct device *dev) {}
> -static inline void pm_runtime_irq_safe(struct device *dev) {}
> +static inline void pm_runtime_irq_safe(struct device *dev)
> +{
> +       dev->power.irq_safe = 1;
> +}
>
>  static inline bool pm_runtime_callbacks_present(struct device *dev) { return false; }
>  static inline void pm_runtime_mark_last_busy(struct device *dev) {}
> --
> 1.9.1
>
