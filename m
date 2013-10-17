Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab3JQN4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 09:56:53 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:49259 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab3JQN4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 09:56:52 -0400
MIME-Version: 1.0
In-Reply-To: <1382006808-22728-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1382006808-22728-1-git-send-email-alexandre.belloni@free-electrons.com>
Date: Thu, 17 Oct 2013 15:56:51 +0200
Message-ID: <CAPDyKFoiWOE47DWrUHNWVPyihL=uCidpd52TV1vgUbq1aMNvbw@mail.gmail.com>
Subject: Re: [PATCHv3] mmc: atmel-mci: add vmmc-supply support
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Chris Ball <cjb@laptop.org>, linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 October 2013 12:46, Alexandre Belloni
<alexandre.belloni@free-electrons.com> wrote:
> Other MMC hosts handle a regulator named vmmc-supply that allows to power the
> MMC card or SDIO device before communicating on the bus.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

> ---
>
> Changes in v2:
>  - use mmc_regulator_get_supply instead of devm_regulator_get
>
> Changes in v3:
>  - en/disable the regulator in .set_ios using mmc_regulator_set_ocr
>
>  drivers/mmc/host/atmel-mci.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index 69e438e..a9e1ba6 100644
> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -1385,8 +1385,14 @@ static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>                 clk_unprepare(host->mck);
>
>         switch (ios->power_mode) {
> +       case MMC_POWER_OFF:
> +               if (!IS_ERR(mmc->supply.vmmc))
> +                       mmc_regulator_set_ocr(mmc, mmc->supply.vmmc, 0);
> +               break;
>         case MMC_POWER_UP:
>                 set_bit(ATMCI_CARD_NEED_INIT, &slot->flags);
> +               if (!IS_ERR(mmc->supply.vmmc))
> +                       mmc_regulator_set_ocr(mmc, mmc->supply.vmmc, ios->vdd);
>                 break;
>         default:
>                 /*
> @@ -2196,6 +2202,7 @@ static int __init atmci_init_slot(struct atmel_mci *host,
>         }
>
>         host->slot[id] = slot;
> +       mmc_regulator_get_supply(mmc);
>         mmc_add_host(mmc);
>
>         if (gpio_is_valid(slot->detect_pin)) {
> --
> 1.8.1.2
>
