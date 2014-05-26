Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaEZJxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 05:53:50 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:41472 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaEZJxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 05:53:48 -0400
MIME-Version: 1.0
In-Reply-To: <1400849515-7343-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1400849515-7343-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Mon, 26 May 2014 11:53:47 +0200
Message-ID: <CAPDyKFpdDOepF6YzKnCZPggbA5F=ZjLmA9-6uTUxF7jeYtyiTw@mail.gmail.com>
Subject: Re: [PATCH v3 07/13] mmc: mmci: add ddrmode mask to variant data
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 May 2014 14:51,  <srinivas.kandagatla@linaro.org> wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> This patch adds ddrmode mask to variant structure giving more flexibility
> to the driver to support more SOCs which have different datactrl register
> layout.
>
> Without this patch datactrl register is updated with wrong ddrmode mask on non
> ST SOCs, resulting in card detection failures.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/mmc/host/mmci.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
> index 1385554..dec70d2 100644
> --- a/drivers/mmc/host/mmci.c
> +++ b/drivers/mmc/host/mmci.c
> @@ -59,6 +59,7 @@ static unsigned int fmax = 515633;
>   *               is asserted (likewise for RX)
>   * @sdio: variant supports SDIO
>   * @st_clkdiv: true if using a ST-specific clock divider algorithm
> + * @datactrl_mask_ddrmode: ddr mode mask in datactrl register.
>   * @blksz_datactrl16: true if Block size is at b16..b30 position in datactrl register
>   * @blksz_datactrl4: true if Block size is at b4..b16 position in datactrl
>   *                  register
> @@ -76,6 +77,7 @@ struct variant_data {
>         unsigned int            datalength_bits;
>         unsigned int            fifosize;
>         unsigned int            fifohalfsize;
> +       unsigned int            datactrl_mask_ddrmode;
>         bool                    sdio;
>         bool                    st_clkdiv;
>         bool                    blksz_datactrl16;
> @@ -114,6 +116,7 @@ static struct variant_data variant_u300 = {
>         .fifosize               = 16 * 4,
>         .fifohalfsize           = 8 * 4,
>         .clkreg_enable          = MCI_ST_U300_HWFCEN,
> +       .datactrl_mask_ddrmode  = MCI_ST_DPSM_DDRMODE,
>         .datalength_bits        = 16,
>         .sdio                   = true,
>         .pwrreg_powerup         = MCI_PWR_ON,
> @@ -126,6 +129,7 @@ static struct variant_data variant_nomadik = {
>         .fifosize               = 16 * 4,
>         .fifohalfsize           = 8 * 4,
>         .clkreg                 = MCI_CLK_ENABLE,
> +       .datactrl_mask_ddrmode  = MCI_ST_DPSM_DDRMODE,
>         .datalength_bits        = 24,
>         .sdio                   = true,
>         .st_clkdiv              = true,
> @@ -140,6 +144,7 @@ static struct variant_data variant_ux500 = {
>         .fifohalfsize           = 8 * 4,
>         .clkreg                 = MCI_CLK_ENABLE,
>         .clkreg_enable          = MCI_ST_UX500_HWFCEN,
> +       .datactrl_mask_ddrmode  = MCI_ST_DPSM_DDRMODE,
>         .datalength_bits        = 24,
>         .sdio                   = true,
>         .st_clkdiv              = true,
> @@ -155,6 +160,7 @@ static struct variant_data variant_ux500v2 = {
>         .fifohalfsize           = 8 * 4,
>         .clkreg                 = MCI_CLK_ENABLE,
>         .clkreg_enable          = MCI_ST_UX500_HWFCEN,
> +       .datactrl_mask_ddrmode  = MCI_ST_DPSM_DDRMODE,

Only the ux500v2 supports DDR mode, using the MCI_ST_DPSM_DDRMODE bit.

>         .datalength_bits        = 24,
>         .sdio                   = true,
>         .st_clkdiv              = true,
> @@ -800,7 +806,7 @@ static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
>                 }
>
>         if (host->mmc->ios.timing == MMC_TIMING_UHS_DDR50)
> -               datactrl |= MCI_ST_DPSM_DDRMODE;
> +               datactrl |= variant->datactrl_mask_ddrmode;
>
>         /*
>          * Attempt to use DMA operation mode, if this
> --
> 1.9.1
>

Kind regards
Ulf Hansson
