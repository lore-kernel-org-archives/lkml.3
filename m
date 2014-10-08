Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbaJHL3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 07:29:16 -0400
Received: from mail-yk0-f174.google.com ([209.85.160.174]:40731 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120AbaJHL3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 07:29:14 -0400
MIME-Version: 1.0
In-Reply-To: <1412618020-22278-1-git-send-email-sonnyrao@chromium.org>
References: <1412618020-22278-1-git-send-email-sonnyrao@chromium.org>
From: Alim Akhtar <alim.akhtar@gmail.com>
Date: Wed, 8 Oct 2014 16:58:32 +0530
Message-ID: <CAGOxZ53bviLbuA27=1QjNUgxA_WMMP-6siV=DajuN8iSqsasMg@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Reset DMA before enabling IDMAC
To: Sonny Rao <sonnyrao@chromium.org>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Heiko Stuebner <heiko@sntech.de>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>, eddie.cai@rock-chips.com,
        addy.ke@rock-chips.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sonny/Doug,

On Mon, Oct 6, 2014 at 11:23 PM, Sonny Rao <sonnyrao@chromium.org> wrote:
> We've already got a reset of DMA after it's done.  Add one before we
> start DMA too.  This fixes a data corruption on Rockchip SoCs which
> will get bad data when doing a DMA transfer after doing a PIO transfer.
>
> We tested this on an Exynos 5800 with HS200 and didn't notice any
> difference in sequential read throughput.
>
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/mmc/host/dw_mmc.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 69f0cc6..2b5401e 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -83,6 +83,7 @@ struct idmac_desc {
>  #endif /* CONFIG_MMC_DW_IDMAC */
>
>  static bool dw_mci_reset(struct dw_mci *host);
> +static bool dw_mci_ctrl_reset(struct dw_mci *host, u32 reset);
>
>  #if defined(CONFIG_DEBUG_FS)
>  static int dw_mci_req_show(struct seq_file *s, void *v)
> @@ -448,6 +449,9 @@ static void dw_mci_idmac_start_dma(struct dw_mci *host, unsigned int sg_len)
>
>         dw_mci_translate_sglist(host, host->data, sg_len);
>
> +       /* Make sure to reset DMA in case we did PIO before this */
> +       dw_mci_ctrl_reset(host, SDMMC_CTRL_DMA_RESET);
> +
Though this is good to do, but this does not look complete to me.
dw_mmc data book does mention that " It is recommended that the host
issue reset to DMA interface by setting DMA_RESET bit of the CTRL
register and then issue a IDMAC software reset."
The above lines are from 'Transmission and reception with internal
DMA' section of the data book.
My suggestion here to add dw_mci_idmac_reset() call after this above change.

What is the controller version used in your case?
>         /* Select IDMAC interface */
>         temp = mci_readl(host, CTRL);
>         temp |= SDMMC_CTRL_USE_IDMAC;
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards,
Alim
