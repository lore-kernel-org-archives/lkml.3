Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbbA1USq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:18:46 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:44246 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499AbbA1USl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:18:41 -0500
MIME-Version: 1.0
In-Reply-To: <20150127233524.32160.33438.stgit@notabene.brown>
References: <20150127233118.32160.11899.stgit@notabene.brown>
	<20150127233524.32160.33438.stgit@notabene.brown>
Date: Wed, 28 Jan 2015 21:18:40 +0100
Message-ID: <CAPDyKFoe6sVi-oKGwEsoXE3U1Ct=+Swc5g+EkV5V21tvvMqE5w@mail.gmail.com>
Subject: Re: [PATCH 3/3] mmc: omap_hsmmc: switch to 1-bit before turning off
 clocks if interrupts expected.
From: Ulf Hansson <ulf.hansson@linaro.org>
To: NeilBrown <neilb@suse.de>
Cc: Tony Lindgren <tony@atomide.com>, Andreas Fenkart <afenkart@gmail.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        GTA04 owners <gta04-owner@goldelico.com>, NeilBrown <neil@brown.name>,
        linux-omap <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 January 2015 at 00:35, NeilBrown <neilb@suse.de> wrote:
> According to section 7.1.2 of
>
> http://www.sandisk.com/media/File/OEM/Manuals/SD_SDIO_specsv1.pdf
>
>     In the case where the interrupt mechanism is used to wake the host while
>     the card is in a low power state (i.e. no clocks), Both the card and the
>     host shall be placed into the 1-bit SD mode prior to stopping the clock.
>
>
> This is particularly important for the Marvell "libertas" wifi chip
> in the GTA04.  While in 4-bit mode it will only signal an interrupt
> when the clock is running (which is why setting CLKEXTFREE is
> important).
> In 1-bit mode, the interrupt is asynchronous (explained in OMAP3
> TRM description of the CIRQ flag to MMCHS_STAT:
>
>   In 1-bit mode, interrupt source is asynchronous (can be a source of
>   asynchronous wakeup).
>   In 4-bit mode, interrupt source is sampled during the interrupt
>   cycle.
>
> )
>
> We cannot simply set 1-bit mode in omap_hsmmc_runtime_suspend
> as that is called under a spinlock, and setting 1-bit mode requires
> a sleeping call to the card.
>
> So:
>  - use a work_struct to schedule setting of 1-bit mode
>  - intro a 'force_narrow' state flag which transitions:
>      0 -> NARROW_PENDING -> NARROW_FORCED -> 0
>  - have omap_hsmmc_runtime_suspend fail if interrupts are expected
>    but bus is not in 1-bit mode.  When it fails it schedules
>    the work to change the width. and sets NARROW_PENDING
>  - when the host is claimed, if NARROW_FORCED is set, restore the
>    4-bit bus
>  - When the host is released (disable_fclk), if NARROW_FORCED,
>    then suspend immediately, no autosuspend.  If NARROW_PENDING,
>    clear that flag as the device has obviously just been used.

I can't give you more detailed comment about this patch(set) yet. Need
to think a bit more first.

Anyway, I have one concern, see comment below.

>
> This all allows a graceful and race-free switch to 1-bit mode
> before switching off the clocks, if interrupts are enabled.
>
> With this, I can use my libertas wifi with a 4-bit bus, with
> interrupts and runtime power-management enabled, and get around
> 14Mb/sec throughput (which is the best I've seen).
>
> Signed-off-by: NeilBrown <neil@brown.name>
> ---
>  drivers/mmc/host/omap_hsmmc.c |   55 ++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 53 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index f84cfb01716d..91ddebbec8a3 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -214,6 +214,10 @@ struct omap_hsmmc_host {
>         int                     reqs_blocked;
>         int                     use_reg;
>         int                     req_in_progress;
> +       int                     force_narrow;
> +#define NARROW_PENDING 1
> +#define NARROW_FORCED  2
> +       struct work_struct      width_work;
>         unsigned long           clk_rate;
>         unsigned int            flags;
>  #define AUTO_CMD23             (1 << 0)        /* Auto CMD23 support */
> @@ -1778,12 +1782,43 @@ static void omap_hsmmc_conf_bus_power(struct omap_hsmmc_host *host)
>         set_sd_bus_power(host);
>  }
>
> +static void omap_hsmmc_width_work(struct work_struct *work)
> +{
> +       struct omap_hsmmc_host *host = container_of(work,
> +                                                   struct omap_hsmmc_host,
> +                                                   width_work);
> +       atomic_t noblock;
> +
> +       atomic_set(&noblock, 1);
> +       if (__mmc_claim_host(host->mmc, &noblock)) {
> +               /* Device active again */
> +               host->force_narrow = 0;
> +               return;
> +       }
> +       if (host->force_narrow != NARROW_PENDING) {
> +               /* Someone claimed and released before we got here */
> +               mmc_release_host(host->mmc);
> +               return;
> +       }
> +       if (sdio_disable_wide(host->mmc->card) == 0)
> +               host->force_narrow = NARROW_FORCED;
> +       else
> +               host->force_narrow = 0;
> +       mmc_release_host(host->mmc);
> +}
> +
>  static int omap_hsmmc_enable_fclk(struct mmc_host *mmc)
>  {
>         struct omap_hsmmc_host *host = mmc_priv(mmc);
>
>         pm_runtime_get_sync(host->dev);
>
> +       if (host->force_narrow == NARROW_FORCED) {
> +               if (sdio_enable_4bit_bus(mmc->card) > 0)
> +                       mmc_set_bus_width(mmc, MMC_BUS_WIDTH_4);
> +               host->force_narrow = 0;
> +       }
> +
>         return 0;
>  }
>
> @@ -1791,8 +1826,13 @@ static int omap_hsmmc_disable_fclk(struct mmc_host *mmc)
>  {
>         struct omap_hsmmc_host *host = mmc_priv(mmc);
>
> -       pm_runtime_mark_last_busy(host->dev);
> -       pm_runtime_put_autosuspend(host->dev);
> +       if (host->force_narrow == NARROW_FORCED) {
> +               pm_runtime_put_sync(host->dev);
> +       } else {
> +               host->force_narrow = 0;
> +               pm_runtime_mark_last_busy(host->dev);
> +               pm_runtime_put_autosuspend(host->dev);
> +       }
>
>         return 0;
>  }
> @@ -2024,6 +2064,7 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
>         host->power_mode = MMC_POWER_OFF;
>         host->next_data.cookie = 1;
>         host->pbias_enabled = 0;
> +       INIT_WORK(&host->width_work, omap_hsmmc_width_work);
>
>         ret = omap_hsmmc_gpio_init(mmc, host, pdata);
>         if (ret)
> @@ -2311,6 +2352,16 @@ static int omap_hsmmc_runtime_suspend(struct device *dev)
>         spin_lock_irqsave(&host->irq_lock, flags);
>         if ((host->mmc->caps & MMC_CAP_SDIO_IRQ) &&
>             (host->flags & HSMMC_SDIO_IRQ_ENABLED)) {
> +               if (host->mmc->ios.bus_width != MMC_BUS_WIDTH_1) {
> +                       /* In 4-bit mode the card need the clock
> +                        * to deliver interrupts, so it isn't safe
> +                        * to turn it off.
> +                        */
> +                       host->force_narrow = NARROW_PENDING;
> +                       schedule_work(&host->width_work);
> +                       ret = -EBUSY;
> +                       goto abort;

>From a host driver perspective, don't you think this a bit too much to
implement to cover this case!?

I would rather see the host driver to invoke _one_ API provided by the
mmc core, which takes care of the needed things and also tells the
host driver whether it's safe to enter runtime PM suspend state or
not. Could that work?

> +               }
>                 /* disable sdio irq handling to prevent race */
>                 OMAP_HSMMC_WRITE(host->base, ISE, 0);
>                 OMAP_HSMMC_WRITE(host->base, IE, 0);
>
>

Kind regards
Uffe
