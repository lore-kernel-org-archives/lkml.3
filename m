Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbaJ0ONQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:13:16 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:63241 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbaJ0ONP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:13:15 -0400
MIME-Version: 1.0
In-Reply-To: <1413478686-6857-1-git-send-email-sonnyrao@chromium.org>
References: <1413478686-6857-1-git-send-email-sonnyrao@chromium.org>
Date: Mon, 27 Oct 2014 15:13:03 +0100
Message-ID: <CAPDyKFoBw8p_cGCz9+j5naNeCXu6tn_YEuLss3tSUSowbCAeGQ@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: dw_mmc: Reset DMA before enabling IDMAC
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: Alim Akhtar <alim.akhtar@gmail.com>, linux-mmc <linux-mmc@vger.kernel.org>,
        Heiko Stuebner <heiko@sntech.de>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Doug Anderson <dianders@chromium.org>, eddie.cai@rock-chips.com,
        Addy Ke <addy.ke@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 October 2014 18:58, Sonny Rao <sonnyrao@chromium.org> wrote:
> We've already got a reset of DMA after it's done.  Add one before we
> start DMA too.  This fixes a data corruption on Rockchip SoCs which
> will get bad data when doing a DMA transfer after doing a PIO transfer.
>
> We tested this on an Exynos 5800 with HS200 and didn't notice any
> difference in sequential read throughput.
>
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Doug Anderson <dianders@chromium.org>

Thanks! Applied for next!

Kind regards
Uffe

> ---
>  drivers/mmc/host/dw_mmc.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 69f0cc6..ca67f69 100644
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
> @@ -448,6 +449,10 @@ static void dw_mci_idmac_start_dma(struct dw_mci *host, unsigned int sg_len)
>
>         dw_mci_translate_sglist(host, host->data, sg_len);
>
> +       /* Make sure to reset DMA in case we did PIO before this */
> +       dw_mci_ctrl_reset(host, SDMMC_CTRL_DMA_RESET);
> +       dw_mci_idmac_reset(host);
> +
>         /* Select IDMAC interface */
>         temp = mci_readl(host, CTRL);
>         temp |= SDMMC_CTRL_USE_IDMAC;
> --
> 2.1.2
>
