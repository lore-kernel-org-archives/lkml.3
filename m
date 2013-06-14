Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab3FNMLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 08:11:05 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:39670 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab3FNMLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 08:11:02 -0400
MIME-Version: 1.0
In-Reply-To: <1371146190-16786-1-git-send-email-zoran.markovic@linaro.org>
References: <1371146190-16786-1-git-send-email-zoran.markovic@linaro.org>
Date: Fri, 14 Jun 2013 14:11:01 +0200
Message-ID: <CAPDyKFrD=q4hOQps5ENJdmAPJyKG1cj7+P6MtXdQ8KQ1cPjnpQ@mail.gmail.com>
Subject: Re: [RFC PATCH] mmc: Enable wakeup_sources for mmc core
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Zoran Markovic <zoran.markovic@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johan Rudholm <johan.rudholm@stericsson.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Konstantin Dorfman <kdorfman@codeaurora.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 June 2013 19:56, Zoran Markovic <zoran.markovic@linaro.org> wrote:
> This is a reworked implementation of wakelocks for the MMC core from
> Android kernel, originally authored by Colin Cross and San Mehat.
> The patch makes sure that whenever a MMC device is inserted/removed,
> the system stays awake until it's reconfigured for the new state.
> It is assumed that 1/2 second is sufficient for the system to start
> the configuration action for the newly detected MMC device, which might
> include e.g. mounting the hosted file system(s).
>
> The implementation uses wakeup_sources instead of wake_locks.
>
> Feedback on the approach is greatly appreciated, in particular for the
> 1/2 second extension peroid.

Hi Zoran,

I am not sure I understand why this patch is needed. When a new card
is inserted/removed and the upper levels gets notification about the
new card, triggering the mounting/un-mounting of the file system, why
should it be the lowest layer (mmc) that prevents the platform from
enter suspend/sleep? Why do we need to prevent it at all?

Note that notifier handling in mmc_pm_notify, was if I remember
correctly, not completely developed when the original version of this
patch was being discussed. mmc_pm_notify prevents cards from being
inserted/removed in the middle of suspend->resume sequence, is that
not enough?

Kind regards
Ulf Hansson

>
> Cc: San Mehat <san@google.com>
> Cc: Colin Cross <ccross@android.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Chris Ball <cjb@laptop.org>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Johan Rudholm <johan.rudholm@stericsson.com>
> Cc: Jaehoon Chung <jh80.chung@samsung.com>
> Cc: Konstantin Dorfman <kdorfman@codeaurora.org>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> [<zoran.markovic@linaro.org>: tweaked commit message, reworked to use
> wakeup_source_register/unregister instead of wakeup_source_init/trash,
> added the missing __pm_relax() for non-removable devices in mmc_rescan().]
> Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
> ---
>  drivers/mmc/core/core.c  |   31 +++++++++++++++++++++++++------
>  drivers/mmc/core/host.c  |    7 +++++++
>  include/linux/mmc/host.h |    2 ++
>  3 files changed, 34 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index c40396f..d5230c7 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -23,6 +23,7 @@
>  #include <linux/log2.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/pm_wakeup.h>
>  #include <linux/suspend.h>
>  #include <linux/fault-inject.h>
>  #include <linux/random.h>
> @@ -1656,6 +1657,7 @@ void mmc_detect_change(struct mmc_host *host, unsigned long delay)
>         spin_unlock_irqrestore(&host->lock, flags);
>  #endif
>         host->detect_change = 1;
> +       __pm_stay_awake(host->ws);
>         mmc_schedule_delayed_work(&host->detect, delay);
>  }
>
> @@ -2351,13 +2353,16 @@ void mmc_rescan(struct work_struct *work)
>         struct mmc_host *host =
>                 container_of(work, struct mmc_host, detect.work);
>         int i;
> +       bool extend_wakeup = false;
>
>         if (host->rescan_disable)
>                 return;
>
>         /* If there is a non-removable card registered, only scan once */
> -       if ((host->caps & MMC_CAP_NONREMOVABLE) && host->rescan_entered)
> +       if ((host->caps & MMC_CAP_NONREMOVABLE) && host->rescan_entered) {
> +               __pm_relax(host->ws);
>                 return;
> +       }
>         host->rescan_entered = 1;
>
>         mmc_bus_get(host);
> @@ -2400,16 +2405,27 @@ void mmc_rescan(struct work_struct *work)
>
>         mmc_claim_host(host);
>         for (i = 0; i < ARRAY_SIZE(freqs); i++) {
> -               if (!mmc_rescan_try_freq(host, max(freqs[i], host->f_min)))
> +               if (!mmc_rescan_try_freq(host, max(freqs[i], host->f_min))) {
> +                       /* stay awake extra time to process detected device */
> +                       extend_wakeup = true;
>                         break;
> +               }
>                 if (freqs[i] <= host->f_min)
>                         break;
>         }
>         mmc_release_host(host);
>
>   out:
> -       if (host->caps & MMC_CAP_NEEDS_POLL)
> +       if (extend_wakeup)
> +               /* extra 1/2 second should be enough, hopefully */
> +               __pm_wakeup_event(host->ws, MSEC_PER_SEC/2);
> +       else
> +               __pm_relax(host->ws);
> +
> +       if (host->caps & MMC_CAP_NEEDS_POLL) {
> +               __pm_stay_awake(host->ws);
>                 mmc_schedule_delayed_work(&host->detect, HZ);
> +       }
>  }
>
>  void mmc_start_host(struct mmc_host *host)
> @@ -2433,7 +2449,8 @@ void mmc_stop_host(struct mmc_host *host)
>  #endif
>
>         host->rescan_disable = 1;
> -       cancel_delayed_work_sync(&host->detect);
> +       if (cancel_delayed_work_sync(&host->detect))
> +               __pm_relax(host->ws);
>         mmc_flush_scheduled_work();
>
>         /* clear pm flags now and let card drivers set them as needed */
> @@ -2628,7 +2645,8 @@ int mmc_suspend_host(struct mmc_host *host)
>  {
>         int err = 0;
>
> -       cancel_delayed_work(&host->detect);
> +       if (cancel_delayed_work(&host->detect))
> +               __pm_relax(host->ws);
>         mmc_flush_scheduled_work();
>
>         mmc_bus_get(host);
> @@ -2741,7 +2759,8 @@ int mmc_pm_notify(struct notifier_block *notify_block,
>                 spin_lock_irqsave(&host->lock, flags);
>                 host->rescan_disable = 1;
>                 spin_unlock_irqrestore(&host->lock, flags);
> -               cancel_delayed_work_sync(&host->detect);
> +               if (cancel_delayed_work_sync(&host->detect))
> +                       __pm_relax(host->ws);
>
>                 if (!host->bus_ops || host->bus_ops->suspend)
>                         break;
> diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
> index 2a3593d..3cbb3d7 100644
> --- a/drivers/mmc/core/host.c
> +++ b/drivers/mmc/core/host.c
> @@ -452,6 +452,11 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
>         host->class_dev.class = &mmc_host_class;
>         device_initialize(&host->class_dev);
>
> +       host->ws = wakeup_source_register(
> +               kasprintf(GFP_KERNEL, "%s_detect", mmc_hostname(host)));
> +       if (!host->ws)
> +               goto free;
> +
>         mmc_host_clk_init(host);
>
>         mutex_init(&host->slot.lock);
> @@ -555,6 +560,8 @@ void mmc_free_host(struct mmc_host *host)
>         spin_lock(&mmc_host_lock);
>         idr_remove(&mmc_host_idr, host->index);
>         spin_unlock(&mmc_host_lock);
> +       wakeup_source_unregister(host->ws);
> +       host->ws = NULL;
>
>         put_device(&host->class_dev);
>  }
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index e326ae2..9dc2dd6 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -15,6 +15,7 @@
>  #include <linux/sched.h>
>  #include <linux/device.h>
>  #include <linux/fault-inject.h>
> +#include <linux/pm_wakeup.h>
>
>  #include <linux/mmc/core.h>
>  #include <linux/mmc/pm.h>
> @@ -329,6 +330,7 @@ struct mmc_host {
>         int                     claim_cnt;      /* "claim" nesting count */
>
>         struct delayed_work     detect;
> +       struct wakeup_source    *ws;
>         int                     detect_change;  /* card detect flag */
>         struct mmc_slot         slot;
>
> --
> 1.7.9.5
>
