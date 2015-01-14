Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbbANLcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 06:32:00 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:58671 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbbANLb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 06:31:57 -0500
MIME-Version: 1.0
In-Reply-To: <1421193524-19967-1-git-send-email-dianders@chromium.org>
References: <1421193524-19967-1-git-send-email-dianders@chromium.org>
Date: Wed, 14 Jan 2015 12:31:56 +0100
Message-ID: <CAPDyKFqQZBsm0WR7qfxu3Rdx-rLEevaK3i58fyQ=Y98hhyTJCw@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Power on vqmmc in MMC_POWER_ON, not MMC_POWER_UP
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>, Alexandru Stan <amstan@chromium.org>,
        Addy Ke <addy.ke@rock-chips.com>, Yuvaraj Kumar <yuvaraj.cd@gmail.com>,
        Chris Ball <chris@printf.net>, linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 January 2015 at 00:58, Doug Anderson <dianders@chromium.org> wrote:
> If we power up vqmmc in MMC_POWER_ON then we end up turning it on
> before mmc_power_up() sets the signal voltage.  That's not so great
> since we might be powering it up at the wrong voltage.
>
> Note that this is how Yuvaraj originally coded things up in
> <https://patchwork.kernel.org/patch/4401231/> but he changed it on my
> suggestion.  Apparently I was wrong.
>
> Reported-by: Alexandru M Stan <amstan@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Thanks! Applied for next.

Kind regards
Uffe

> ---
>  drivers/mmc/host/dw_mmc.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 2e8abc8..4d2e3c2 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -1119,6 +1119,12 @@ static void dw_mci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>                                 return;
>                         }
>                 }
> +               set_bit(DW_MMC_CARD_NEED_INIT, &slot->flags);
> +               regs = mci_readl(slot->host, PWREN);
> +               regs |= (1 << slot->id);
> +               mci_writel(slot->host, PWREN, regs);
> +               break;
> +       case MMC_POWER_ON:
>                 if (!IS_ERR(mmc->supply.vqmmc) && !slot->host->vqmmc_enabled) {
>                         ret = regulator_enable(mmc->supply.vqmmc);
>                         if (ret < 0)
> @@ -1127,10 +1133,6 @@ static void dw_mci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>                         else
>                                 slot->host->vqmmc_enabled = true;
>                 }
> -               set_bit(DW_MMC_CARD_NEED_INIT, &slot->flags);
> -               regs = mci_readl(slot->host, PWREN);
> -               regs |= (1 << slot->id);
> -               mci_writel(slot->host, PWREN, regs);
>                 break;
>         case MMC_POWER_OFF:
>                 if (!IS_ERR(mmc->supply.vmmc))
> --
> 2.2.0.rc0.207.ga3a616c
>
