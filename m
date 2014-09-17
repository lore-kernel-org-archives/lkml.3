Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbaIQTzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 15:55:24 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:47439 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604AbaIQTzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 15:55:22 -0400
MIME-Version: 1.0
In-Reply-To: <1410542338-24565-1-git-send-email-swarren@wwwdotorg.org>
References: <1410542338-24565-1-git-send-email-swarren@wwwdotorg.org>
Date: Wed, 17 Sep 2014 21:55:21 +0200
Message-ID: <CAPDyKFq63LKHKJ_1JD=SGU=V1eE-1105qPLy1EQtf=4k8dwKkA@mail.gmail.com>
Subject: Re: [PATCH] mmc: don't request CD IRQ until mmc_start_host()
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Chris Ball <chris@printf.net>, linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 September 2014 19:18, Stephen Warren <swarren@wwwdotorg.org> wrote:
> From: Stephen Warren <swarren@nvidia.com>
>
> As soon as the CD IRQ is requested, it can trigger, since it's an
> externally controlled event. If it does, delayed_work host->detect will
> be scheduled.
>
> Many host controller probe()s are roughly structured as:
>
> *_probe() {
>     host = sdhci_pltfm_init();
>     mmc_of_parse(host->mmc);
>     rc = sdhci_add_host(host);
>     if (rc) {
>         sdhci_pltfm_free();
>         return rc;
>     }
>
> In 3.17, CD IRQs can are enabled quite early via *_probe() ->
> mmc_of_parse() -> mmc_gpio_request_cd() -> mmc_gpiod_request_cd_irq().
>
> Note that in linux-next, mmc_of_parse() calls mmc_gpio*d*_request_cd()
> rather than mmc_gpio_request_cd(), and mmc_gpio*d*_request_cd() doesn't
> call mmc_gpiod_request_cd_irq(). However, this issue still exists for
> any other direct users of mmc_gpio_request_cd().
>
> sdhci_add_host() may fail part way through (e.g. due to deferred
> probe for a vmmc regulator), and sdhci_pltfm_free() does nothing to
> unrequest the CD IRQ nor cancel the delayed_work. sdhci_pltfm_free() is
> coded to assume that if sdhci_add_host() failed, then the delayed_work
> cannot (or should not) have been triggered.
>
> This can lead to the following with CONFIG_DEBUG_OBJECTS_* enabled, when
> kfree(host) is eventually called inside sdhci_pltfm_free():
>
> WARNING: CPU: 2 PID: 6 at lib/debugobjects.c:263 debug_print_object+0x8c/0xb4()
> ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x18
>
> The object being complained about is host->detect.
>
> There's no need to request the CD IRQ so early; mmc_start_host() already
> requests it, and I *assume* that mmc_start_host() is called somehow for
> all host controllers. For SDHCI hosts at least, the typical call path
> that does this is: *_probe() -> sdhci_add_host() -> mmc_add_host() ->
> mmc_start_host(). So, remove the call to mmc_gpiod_request_cd_irq() from
> mmc_gpio_request_cd(). This matches mmc_gpio*d*_request_cd(), which
> already doesn't call mmc_gpiod_request_cd_irq().
>
> This solves the problem (eliminates the kernel error message above),
> since it guarantees that the IRQ can't trigger before mmc_start_host()
> is called.
>
> The critical point here is that once sdhci_add_host() calls
> mmc_add_host() -> mmc_start_host(), sdhci_add_host() is coded not to
> fail. In other words, if there's a chance that mmc_start_host() may have
> been called, and CD IRQs triggered, and the delayed_work scheduled,
> sdhci_add_host() won't fail, and so cleanup is no longer via
> sdhci_pltfm_free() (which doesn't free the IRQ or cancel the work queue)
> but instead must be via sdhci_remove_host(), which calls mmc_remove_host()
> -> mmc_stop_host(), which does free the IRQ and cancel the work queue.
>
> This fixes what I might conclude to be a mistake in commit 740a221ef0e5
> ("mmc: slot-gpio: Add GPIO descriptor based CD GPIO API"), which added the
> call from mmc_start_host() to mmc_gpiod_request_cd_irq(), but also added
> incorrectly added a call from mmc_gpio_request_cd() to
> mmc_gpiod_request_cd_irq().
>
> CC: Russell King <linux@arm.linux.org.uk>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Alexandre Courbot <acourbot@nvidia.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Hi Stephen,

Thanks for looking into this. It seems like this issue has been
present for quite a while.
I believe your patch should have a stable tag for 3.15+ as well,
unless you object I will add it.

Applied for next!

Kind regards
Uffe

> ---
>  drivers/mmc/core/slot-gpio.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/mmc/core/slot-gpio.c b/drivers/mmc/core/slot-gpio.c
> index 5f89cb83d5f0..187f48a5795a 100644
> --- a/drivers/mmc/core/slot-gpio.c
> +++ b/drivers/mmc/core/slot-gpio.c
> @@ -221,8 +221,6 @@ int mmc_gpio_request_cd(struct mmc_host *host, unsigned int gpio,
>         ctx->override_cd_active_level = true;
>         ctx->cd_gpio = gpio_to_desc(gpio);
>
> -       mmc_gpiod_request_cd_irq(host);
> -
>         return 0;
>  }
>  EXPORT_SYMBOL(mmc_gpio_request_cd);
> --
> 1.9.1
>
