Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbaFYJt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:49:57 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:47648 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbaFYJt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:49:56 -0400
MIME-Version: 1.0
In-Reply-To: <1403681134-12616-1-git-send-email-tim.kryger@gmail.com>
References: <1403681134-12616-1-git-send-email-tim.kryger@gmail.com>
Date: Wed, 25 Jun 2014 11:49:55 +0200
Message-ID: <CAPDyKFr-eG04G39AcX2DyUiBgOTE4AY5MZbw6FXBtq918s2rJQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci: Improve external VDD regulator support
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Tim Kryger <tim.kryger@gmail.com>
Cc: Chris Ball <chris@printf.net>, Sachin Kamat <spk.linux@gmail.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/2014, Tim Kryger <tim.kryger@gmail.com> wrote:
> A standard compliant SDHCI can itself supply VDD at 1.8, 3.0, or 3.3v.
> Several vendors ignore this and instead rely upon external regulators
> to supply VDD.  While the external regulators typically can supply one
> of the standard SDHCI voltage levels, there is no real reason for this
> to be a hard requirement.
>
> This patch alters the SDHCI driver such that external VDD regulators
> that provide voltages other than the three mentioned above may be used
> so long as they can supply a voltage that meets the needs of the card.
>
> In the case that an external VDD regulator is provided, it is reasonable
> to ignore the voltage capabilities of the host controller and allow the
> external regulator to set the OCR mask.  Additionally, there is no need
> to convert a VDD voltage request into one of the standard SDHCI voltage
> levels or program it in the host controller's power control register.
>
> Signed-off-by: Tim Kryger <tim.kryger@gmail.com>
> Tested-by: Sachin Kamat <spk.linux@gmail.com>

Thanks! Applied for next.

Kind regards
Uffe

> ---
>
> This change corrects a regression observed on Exynos platforms that was
> triggered by "mmc: sdhci: Use mmc core regulator infrastucture"
>
> https://www.mail-archive.com/linux-mmc@vger.kernel.org/msg27101.html
>
>  drivers/mmc/host/sdhci.c |   16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index c23a872..07a2426 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -1226,6 +1226,13 @@ static void sdhci_set_power(struct sdhci_host *host,
> unsigned char mode,
>  	struct mmc_host *mmc = host->mmc;
>  	u8 pwr = 0;
>
> +	if (!IS_ERR(mmc->supply.vmmc)) {
> +		spin_unlock_irq(&host->lock);
> +		mmc_regulator_set_ocr(host->mmc, mmc->supply.vmmc, vdd);
> +		spin_lock_irq(&host->lock);
> +		return;
> +	}
> +
>  	if (mode != MMC_POWER_OFF) {
>  		switch (1 << vdd) {
>  		case MMC_VDD_165_195:
> @@ -1284,12 +1291,6 @@ static void sdhci_set_power(struct sdhci_host *host,
> unsigned char mode,
>  		if (host->quirks & SDHCI_QUIRK_DELAY_AFTER_POWER)
>  			mdelay(10);
>  	}
> -
> -	if (!IS_ERR(mmc->supply.vmmc)) {
> -		spin_unlock_irq(&host->lock);
> -		mmc_regulator_set_ocr(host->mmc, mmc->supply.vmmc, vdd);
> -		spin_lock_irq(&host->lock);
> -	}
>  }
>
> /*****************************************************************************\
> @@ -3092,8 +3093,9 @@ int sdhci_add_host(struct sdhci_host *host)
>  				   SDHCI_MAX_CURRENT_MULTIPLIER;
>  	}
>
> +	/* If OCR set by external regulators, use it instead */
>  	if (mmc->ocr_avail)
> -		ocr_avail &= mmc->ocr_avail;
> +		ocr_avail = mmc->ocr_avail;
>
>  	if (host->ocr_mask)
>  		ocr_avail &= host->ocr_mask;
> --
> 1.7.9.5
>
>
