Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaIVTph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 15:45:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:65033 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbaIVTpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 15:45:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,573,1406617200"; 
   d="scan'208";a="603612217"
Message-ID: <54207C23.7010107@intel.com>
Date: Mon, 22 Sep 2014 22:44:35 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
CC: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] mmc: don't request CD IRQ until mmc_start_host()
References: <1411401462-1509-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1411401462-1509-1-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/09/2014 6:57 p.m., Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>
> As soon as the CD IRQ is requested, it can trigger, since it's an
> externally controlled event. If it does, delayed_work host->detect will
> be scheduled.
>
> Many host controller probe()s are roughly structured as:
>
> *_probe() {
>      host = sdhci_pltfm_init();
>      mmc_of_parse(host->mmc);
>      rc = sdhci_add_host(host);
>      if (rc) {
>          sdhci_pltfm_free();
>          return rc;
>      }
>
> In 3.17, CD IRQs can are enabled quite early via *_probe() ->
> mmc_of_parse() -> mmc_gpio_request_cd() -> mmc_gpiod_request_cd_irq().
>
> Note that in linux-next, mmc_of_parse() calls mmc_gpio*d*_request_cd()
> rather than mmc_gpio_request_cd(), and mmc_gpio*d*_request_cd() doesn't
> call mmc_gpiod_request_cd_irq(). However, this issue still exists if
> mmc_gpio_request_cd() is called directly before mmc_start_host().
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
> requests it. For most SDHCI hosts at least, the typical call path that
> does this is: *_probe() -> sdhci_add_host() -> mmc_add_host() ->
> mmc_start_host(). Therefore, remove the call to mmc_gpiod_request_cd_irq()
> from mmc_gpio_request_cd(). This also matches mmc_gpio*d*_request_cd(),
> which already doesn't call mmc_gpiod_request_cd_irq().
>
> However, some host controller drivers call mmc_gpio_request_cd() after
> mmc_start_host() has already been called, and assume that this will also
> call mmc_gpiod_request_cd_irq(). Update those drivers to explicitly call
> mmc_gpiod_request_cd_irq() themselves. Ideally, these drivers should be
> modified to move their call to mmc_gpio_request_cd() before their call
> to mmc_add_host(). However that's too large a change for stable.
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
> CC: Russell King <linux@arm.linux.org.uk>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Alexandre Courbot <acourbot@nvidia.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
> Note: This is a patch for v3.17 (and perhaps earlier); linux-next doesn't
> have this problem due to other code re-structing. However, I think those
> patches are too large to backport.
>
> v3: Explicitly call mmc_gpiod_request_cd_irq() from drivers that call
> mmc_gpio_request_cd() after calling mmc_add_host(), rather than modifying
> the function signature of mmc_gpio_request_cd().
>
> v2: Rather than completely removing mmc_gpio_request_cd()'s call to
> mmc_gpiod_request_cd_irq(), make the call conditional.
> ---
>   drivers/mmc/core/slot-gpio.c    | 2 --
>   drivers/mmc/host/mmc_spi.c      | 1 +
>   drivers/mmc/host/sdhci-sirf.c   | 1 +
>   drivers/mmc/host/tmio_mmc_pio.c | 1 +
>   4 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/core/slot-gpio.c b/drivers/mmc/core/slot-gpio.c
> index 5f89cb83d5f0..187f48a5795a 100644
> --- a/drivers/mmc/core/slot-gpio.c
> +++ b/drivers/mmc/core/slot-gpio.c
> @@ -221,8 +221,6 @@ int mmc_gpio_request_cd(struct mmc_host *host, unsigned int gpio,
>   	ctx->override_cd_active_level = true;
>   	ctx->cd_gpio = gpio_to_desc(gpio);
>
> -	mmc_gpiod_request_cd_irq(host);
> -
>   	return 0;
>   }
>   EXPORT_SYMBOL(mmc_gpio_request_cd);
> diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
> index cc8d4a6099cd..e4a07546f8b6 100644
> --- a/drivers/mmc/host/mmc_spi.c
> +++ b/drivers/mmc/host/mmc_spi.c
> @@ -1436,6 +1436,7 @@ static int mmc_spi_probe(struct spi_device *spi)
>   					     host->pdata->cd_debounce);
>   		if (status != 0)
>   			goto fail_add_host;
> +		mmc_gpiod_request_cd_irq(mmc);
>   	}
>
>   	if (host->pdata && host->pdata->flags & MMC_SPI_USE_RO_GPIO) {
> diff --git a/drivers/mmc/host/sdhci-sirf.c b/drivers/mmc/host/sdhci-sirf.c
> index 17004531d089..b6db259aea9e 100644
> --- a/drivers/mmc/host/sdhci-sirf.c
> +++ b/drivers/mmc/host/sdhci-sirf.c
> @@ -94,6 +94,7 @@ static int sdhci_sirf_probe(struct platform_device *pdev)
>   				ret);
>   			goto err_request_cd;
>   		}
> +		mmc_gpiod_request_cd_irq(host->mmc);
>   	}
>
>   	return 0;
> diff --git a/drivers/mmc/host/tmio_mmc_pio.c b/drivers/mmc/host/tmio_mmc_pio.c
> index faf0924e71cb..59d9a7249b2e 100644
> --- a/drivers/mmc/host/tmio_mmc_pio.c
> +++ b/drivers/mmc/host/tmio_mmc_pio.c
> @@ -1103,6 +1103,7 @@ int tmio_mmc_host_probe(struct tmio_mmc_host **host,
>   			tmio_mmc_host_remove(_host);
>   			return ret;
>   		}
> +		mmc_gpiod_request_cd_irq(mmc);
>   	}
>
>   	*host = _host;
>
