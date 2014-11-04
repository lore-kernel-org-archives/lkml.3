Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218AbaKDF27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 00:28:59 -0500
Received: from mail-oi0-f41.google.com ([209.85.218.41]:51275 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaKDF24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 00:28:56 -0500
MIME-Version: 1.0
In-Reply-To: <54584260.8030602@nvidia.com>
References: <54584260.8030602@nvidia.com>
Date: Mon, 3 Nov 2014 21:28:55 -0800
Message-ID: <CAD7vxxKb668Y0hpYRhwMjQnNrDCQMzn=XGtLEU+ZAtY=OFjHLg@mail.gmail.com>
Subject: Re: Possible regression with commit 52221610d
From: Tim Kryger <tim.kryger@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Sachin Kamat <spk.linux@gmail.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 7:05 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Hi guys,
>
> On the NVIDIA shield (tegra114-roth) platform, I have noticed that MMC
> stopped working completely on recent kernels. MMC devices will not show up
> and the message "mmc1: Controller never released inhibit bit(s)." shows up
> repeatedly in the console.
>
> After bisecting I tracked commit 52221610dd84dc3e9196554f0292ca9e8ab3541d
> ("mmc: sdhci: Improve external VDD regulator support") as the one that
> introduced this issue, which seems somehow surprising to me since it has
> been around for a while and nobody else complained about this AFAICT.

I'm not too familiar with the Nvidia Shield so can you please confirm
the following?

The controller in the Tegra114 is SDHCI compliant and as such
sdhci_tegra_probe calls sdhci_add_host.  External regulators are
sought in sdhci_add_host with a call to mmc_regulator_get_supply.
Since no external regulators are specified in tegra114.dtsi or
tegra114-roth.dts, mmc->supply.vmmc and mmc->supply.vqmmc are set to
-ENODEV.

> The following diff solves the issue for me, however I don't know whether it
> also reverts the intended purpose of the initial patch:
>
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index ada1a3ea3a87..615701bb8ea3 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -1235,13 +1235,6 @@ static void sdhci_set_power(struct sdhci_host *host,
> unsigned char mode,
>         struct mmc_host *mmc = host->mmc;
>         u8 pwr = 0;
>
> -       if (!IS_ERR(mmc->supply.vmmc)) {
> -               spin_unlock_irq(&host->lock);
> -               mmc_regulator_set_ocr(mmc, mmc->supply.vmmc, vdd);
> -               spin_lock_irq(&host->lock);
> -               return;
> -       }
> -
>         if (mode != MMC_POWER_OFF) {
>                 switch (1 << vdd) {
>                 case MMC_VDD_165_195:
> @@ -1300,6 +1293,12 @@ static void sdhci_set_power(struct sdhci_host *host,
> unsigned char mode,
>                 if (host->quirks & SDHCI_QUIRK_DELAY_AFTER_POWER)
>                         mdelay(10);
>         }
> +
> +       if (!IS_ERR(mmc->supply.vmmc)) {
> +               spin_unlock_irq(&host->lock);
> +               mmc_regulator_set_ocr(mmc, mmc->supply.vmmc, vdd);
> +               spin_lock_irq(&host->lock);
> +       }
>  }
>
> Does this look like the right approach? If not, would you have any
> suggestion as to how to solve this problem?

The patch you proposed would break Exynos4210 so I don't think it is
appropriate.

Do you understand why this code block is executed on your hardware?  I
wouldn't expect it.

Can you provide the relevant parts of the log before the problem occurs?

Thanks,
Tim Kryger
