Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab3CLEPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 00:15:17 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:55211 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab3CLEPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 00:15:15 -0400
MIME-Version: 1.0
In-Reply-To: <25B60CDC2F704E4E9D88FFD52780CB4C0BDEB0547F@SC-VEXCH1.marvell.com>
References: <25B60CDC2F704E4E9D88FFD52780CB4C0BDEB0547F@SC-VEXCH1.marvell.com>
Date: Tue, 12 Mar 2013 12:15:14 +0800
Message-ID: <CADz5_g+KfxL43BKKsgZZ3Xg4sZWE4-ZaFpFhphKrfj9yK59-XA@mail.gmail.com>
Subject: Re: FW: Regulator API ignored return values
From: Kevin Liu <keyuan.liu@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Axel Lin <axel.lin@ingics.com>, Jingoo Han <jg1.han@samsung.com>,
        Felipe Balbi <balbi@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-mmc-owner@vger.kernel.org [mailto:linux-mmc-owner@vger.kernel.org] On Behalf Of Chris Ball
> Sent: Tuesday, March 12, 2013 5:56 AM
> To: Arnd Bergmann
> Cc: linux-kernel@vger.kernel.org; Stephen Warren; linux-arm-kernel@lists.infradead.org; Mark Brown; Linus Walleij; Axel Lin; Jingoo Han; Felipe Balbi; Dmitry Torokhov; linux-mmc@vger.kernel.org
> Subject: Re: Regulator API ignored return values
>
> Hi,
>
> On Mon, Mar 11 2013, Arnd Bergmann wrote:
>> ==> build/dove_defconfig/faillog <==
>> /git/arm-soc/drivers/mmc/host/sdhci.c: In function 'sdhci_add_host':
>> /git/arm-soc/drivers/mmc/host/sdhci.c:2910:19: warning: ignoring
>> return value of 'regulator_enable', declared with attribute
>> warn_unused_result [-Wunused-result]
>
> Thanks, this looks like the right fix to me:
>
>
> Subject: [PATCH] mmc: sdhci: Don't ignore regulator_enable() return value
>
> Fixes:
> /git/arm-soc/drivers/mmc/host/sdhci.c: In function 'sdhci_add_host':
> /git/arm-soc/drivers/mmc/host/sdhci.c:2910:19: warning: ignoring
> return value of 'regulator_enable', declared with attribute
> warn_unused_result [-Wunused-result]
>
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Chris Ball <cjb@laptop.org>
> ---
>  drivers/mmc/host/sdhci.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index 51bbba4..fbf0b93 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -2907,12 +2907,17 @@ int sdhci_add_host(struct sdhci_host *host)
>                         host->vqmmc = NULL;
>                 }
>         } else {
> -               regulator_enable(host->vqmmc);
> +               ret = regulator_enable(host->vqmmc);
>                 if (!regulator_is_supported_voltage(host->vqmmc, 1700000,
>                         1950000))
>                         caps[1] &= ~(SDHCI_SUPPORT_SDR104 |
>                                         SDHCI_SUPPORT_SDR50 |
>                                         SDHCI_SUPPORT_DDR50);
> +               if (ret) {
> +                       pr_warn("%s: Failed to enable vqmmc regulator: %d\n",
> +                               mmc_hostname(mmc), ret);

Need add regulator_put here since regulator_get has succeed?

> +                       host->vqmmc = NULL;
> +               }
>         }
>
>         if (host->quirks2 & SDHCI_QUIRK2_NO_1_8_V)
> --
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
