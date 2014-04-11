Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbaDKIPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 04:15:48 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:33887 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbaDKIPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 04:15:43 -0400
MIME-Version: 1.0
In-Reply-To: <1397172708-19735-1-git-send-email-tim.kryger@linaro.org>
References: <1397172708-19735-1-git-send-email-tim.kryger@linaro.org>
Date: Fri, 11 Apr 2014 10:15:41 +0200
Message-ID: <CAPDyKFrFyBLtL6dVgFy6DkY0gdCjiVpk1OhsfUXD0nhajCetxg@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci: Set ocr_avail directly based on vmmc
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Chris Ball <chris@printf.net>,
        Linux MMC Mailing List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 April 2014 01:31, Tim Kryger <tim.kryger@linaro.org> wrote:
> When an external regulator provides VDD, set ocr_avail directly based on
> the supported voltage range.  This allows for the use of regulators that
> can't provide exactly 1.8v, 3.0v, or 3.3v and ensures that ocr_avil bits
> are only set for supported voltage ranges.  Commit cec2e21 had attempted
> to relax the range checks but because it relied on setting capabilities
> as an intermediate step, ocr_avail could easily get a bit set that the
> host couldn't support.
>
> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> ---
>  drivers/mmc/host/sdhci.c |  107 +++++++++++++++++++++++++---------------------
>  1 file changed, 58 insertions(+), 49 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index 9a79fc4..4d56fbe 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -2769,6 +2769,29 @@ struct sdhci_host *sdhci_alloc_host(struct device *dev,
>
>  EXPORT_SYMBOL_GPL(sdhci_alloc_host);
>
> +static unsigned int sdhci_get_ocr_avail_from_vmmc(struct sdhci_host *host)
> +{
> +       unsigned int ocr_avail = 0;
> +       struct regulator *vmmc = host->vmmc;
> +
> +       if (regulator_is_supported_voltage(vmmc, 1650000, 1950000) > 0)
> +               ocr_avail |= MMC_VDD_165_195;
> +
> +       if (regulator_is_supported_voltage(vmmc, 2900000, 3000000) > 0)
> +               ocr_avail |= MMC_VDD_29_30;
> +
> +       if (regulator_is_supported_voltage(vmmc, 3000000, 3100000) > 0)
> +               ocr_avail |= MMC_VDD_30_31;
> +
> +       if (regulator_is_supported_voltage(vmmc, 3200000, 3300000) > 0)
> +               ocr_avail |= MMC_VDD_32_33;
> +
> +       if (regulator_is_supported_voltage(vmmc, 3300000, 3400000) > 0)
> +               ocr_avail |= MMC_VDD_33_34;
> +
> +       return ocr_avail;
> +}
> +

There is an API called mmc_regulator_get_ocrmask() for this.

>  int sdhci_add_host(struct sdhci_host *host)
>  {
>         struct mmc_host *mmc;
> @@ -3063,24 +3086,39 @@ int sdhci_add_host(struct sdhci_host *host)
>                 }
>         }
>
> -#ifdef CONFIG_REGULATOR
> -       /*
> -        * Voltage range check makes sense only if regulator reports
> -        * any voltage value.
> -        */
> +       /* If using external regulator, check supported voltage ranges */
>         if (host->vmmc && regulator_get_voltage(host->vmmc) > 0) {
> -               ret = regulator_is_supported_voltage(host->vmmc, 2700000,
> -                       3600000);
> -               if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_330)))
> -                       caps[0] &= ~SDHCI_CAN_VDD_330;
> -               if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_300)))
> -                       caps[0] &= ~SDHCI_CAN_VDD_300;
> -               ret = regulator_is_supported_voltage(host->vmmc, 1700000,
> -                       1950000);
> -               if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_180)))
> -                       caps[0] &= ~SDHCI_CAN_VDD_180;
> -       }
> -#endif /* CONFIG_REGULATOR */
> +               ocr_avail = sdhci_get_ocr_avail_from_vmmc(host);
> +       } else {
> +               if (caps[0] & SDHCI_CAN_VDD_330)
> +                       ocr_avail |= MMC_VDD_32_33 | MMC_VDD_33_34;
> +               if (caps[0] & SDHCI_CAN_VDD_300)
> +                       ocr_avail |= MMC_VDD_29_30 | MMC_VDD_30_31;
> +               if (caps[0] & SDHCI_CAN_VDD_180)
> +                       ocr_avail |= MMC_VDD_165_195;
> +       }
> +
> +       if (host->ocr_mask)
> +               ocr_avail = host->ocr_mask;
> +
> +       mmc->ocr_avail = ocr_avail;
> +       mmc->ocr_avail_sdio = ocr_avail;
> +       if (host->ocr_avail_sdio)
> +               mmc->ocr_avail_sdio &= host->ocr_avail_sdio;
> +       mmc->ocr_avail_sd = ocr_avail;
> +       if (host->ocr_avail_sd)
> +               mmc->ocr_avail_sd &= host->ocr_avail_sd;
> +       else /* normal SD controllers don't support 1.8V */
> +               mmc->ocr_avail_sd &= ~MMC_VDD_165_195;
> +       mmc->ocr_avail_mmc = ocr_avail;
> +       if (host->ocr_avail_mmc)
> +               mmc->ocr_avail_mmc &= host->ocr_avail_mmc;
> +
> +       if (mmc->ocr_avail == 0) {
> +               pr_err("%s: Hardware doesn't report any support voltages.\n",
> +                      mmc_hostname(mmc));
> +               return -ENODEV;
> +       }

I have not fully understand why you have different ocr masks depending
on what card you initialize. Is that really supported by the
controller?

>
>         /*
>          * According to SD Host Controller spec v3.00, if the Host System
> @@ -3106,52 +3144,23 @@ int sdhci_add_host(struct sdhci_host *host)
>                 }
>         }
>
> -       if (caps[0] & SDHCI_CAN_VDD_330) {
> -               ocr_avail |= MMC_VDD_32_33 | MMC_VDD_33_34;
> -
> +       if (ocr_avail & (MMC_VDD_32_33 | MMC_VDD_33_34))
>                 mmc->max_current_330 = ((max_current_caps &
>                                    SDHCI_MAX_CURRENT_330_MASK) >>
>                                    SDHCI_MAX_CURRENT_330_SHIFT) *
>                                    SDHCI_MAX_CURRENT_MULTIPLIER;
> -       }
> -       if (caps[0] & SDHCI_CAN_VDD_300) {
> -               ocr_avail |= MMC_VDD_29_30 | MMC_VDD_30_31;
>
> +       if (ocr_avail & (MMC_VDD_29_30 | MMC_VDD_30_31))
>                 mmc->max_current_300 = ((max_current_caps &
>                                    SDHCI_MAX_CURRENT_300_MASK) >>
>                                    SDHCI_MAX_CURRENT_300_SHIFT) *
>                                    SDHCI_MAX_CURRENT_MULTIPLIER;
> -       }
> -       if (caps[0] & SDHCI_CAN_VDD_180) {
> -               ocr_avail |= MMC_VDD_165_195;
>
> +       if (ocr_avail & MMC_VDD_165_195)
>                 mmc->max_current_180 = ((max_current_caps &
>                                    SDHCI_MAX_CURRENT_180_MASK) >>
>                                    SDHCI_MAX_CURRENT_180_SHIFT) *
>                                    SDHCI_MAX_CURRENT_MULTIPLIER;
> -       }
> -
> -       if (host->ocr_mask)
> -               ocr_avail = host->ocr_mask;
> -
> -       mmc->ocr_avail = ocr_avail;
> -       mmc->ocr_avail_sdio = ocr_avail;
> -       if (host->ocr_avail_sdio)
> -               mmc->ocr_avail_sdio &= host->ocr_avail_sdio;
> -       mmc->ocr_avail_sd = ocr_avail;
> -       if (host->ocr_avail_sd)
> -               mmc->ocr_avail_sd &= host->ocr_avail_sd;
> -       else /* normal SD controllers don't support 1.8V */
> -               mmc->ocr_avail_sd &= ~MMC_VDD_165_195;
> -       mmc->ocr_avail_mmc = ocr_avail;
> -       if (host->ocr_avail_mmc)
> -               mmc->ocr_avail_mmc &= host->ocr_avail_mmc;
> -
> -       if (mmc->ocr_avail == 0) {
> -               pr_err("%s: Hardware doesn't report any "
> -                       "support voltages.\n", mmc_hostname(mmc));
> -               return -ENODEV;
> -       }
>

I have seen some patches around lately touching the code for handling
the regulators (vcc and vccq) in sdhci.

A few times I have suggested to switch to use the
mmc_regulator_get_supply() API to simplify and consolidate code. Could
you please have a look at that?

Kind regards
Ulf Hansson

>         spin_lock_init(&host->lock);
>
> --
> 1.7.9.5
>
