Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbaKEK5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:57:54 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:45226 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbaKEK5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:57:52 -0500
MIME-Version: 1.0
In-Reply-To: <1415167740-5762-1-git-send-email-vincent.wan@amd.com>
References: <1415167740-5762-1-git-send-email-vincent.wan@amd.com>
Date: Wed, 5 Nov 2014 11:57:51 +0100
Message-ID: <CAPDyKFpyDeodZcvvhS76q_fB2mujJYP-n_oF=H5BRq5E+dn0ng@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mmc:sdhci: Add a quirk for AMD SDHC transfer mode
 register need to be cleared for cmd without data
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Vincent Wan <vincent.wan@amd.com>
Cc: linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arindam Nath <arindam.nath@amd.com>, Huang Rui <ray.huang@amd.com>,
        Wan Zongshun <mcuos.com@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 November 2014 07:09, Vincent Wan <vincent.wan@amd.com> wrote:
> SDHC controller in AMD chipsets require SDHC transfer mode
> register to be cleared for commands without data. The issue was
> uncovered during testing eMMC cards on KB/ML based platforms
>
> Signed-off-by: Vincent Wan <vincent.wan@amd.com>
> Signed-off-by: Wan Zongshun <mcuos.com@gmail.com>
> Signed-off-by: Arindam Nath <arindam.nath@amd.com>
> Tested-by: Vikram B <vikram.b@amd.com>
> Tested-by: Raghavendra Swamy <raghavendra.swamy@amd.com>

Thanks! Applied for next.

Kind regards
Uffe

> ---
>  drivers/mmc/host/sdhci.c  | 9 +++++++--
>  include/linux/mmc/sdhci.h | 2 ++
>  2 files changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index f895ab0..a743d52 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -915,10 +915,15 @@ static void sdhci_set_transfer_mode(struct sdhci_host *host,
>         struct mmc_data *data = cmd->data;
>
>         if (data == NULL) {
> +               if (host->quirks2 &
> +                       SDHCI_QUIRK2_CLEAR_TRANSFERMODE_REG_BEFORE_CMD) {
> +                       sdhci_writew(host, 0x0, SDHCI_TRANSFER_MODE);
> +               } else {
>                 /* clear Auto CMD settings for no data CMDs */
> -               mode = sdhci_readw(host, SDHCI_TRANSFER_MODE);
> -               sdhci_writew(host, mode & ~(SDHCI_TRNS_AUTO_CMD12 |
> +                       mode = sdhci_readw(host, SDHCI_TRANSFER_MODE);
> +                       sdhci_writew(host, mode & ~(SDHCI_TRNS_AUTO_CMD12 |
>                                 SDHCI_TRNS_AUTO_CMD23), SDHCI_TRANSFER_MODE);
> +               }
>                 return;
>         }
>
> diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
> index 931ac5e..ae7f357 100644
> --- a/include/linux/mmc/sdhci.h
> +++ b/include/linux/mmc/sdhci.h
> @@ -102,6 +102,8 @@ struct sdhci_host {
>  #define SDHCI_QUIRK2_STOP_WITH_TC                      (1<<8)
>  /* Controller does not support 64-bit DMA */
>  #define SDHCI_QUIRK2_BROKEN_64_BIT_DMA                 (1<<9)
> +/* need clear transfer mode register before send cmd */
> +#define SDHCI_QUIRK2_CLEAR_TRANSFERMODE_REG_BEFORE_CMD (1<<10)
>
>         int irq;                /* Device IRQ */
>         void __iomem *ioaddr;   /* Mapped address */
> --
> 1.8.1.2
>
