Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761345AbbA2KY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:24:57 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:57458 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758187AbbA2KYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:24:53 -0500
MIME-Version: 1.0
In-Reply-To: <1422463516-19557-1-git-send-email-rklein@nvidia.com>
References: <1422463516-19557-1-git-send-email-rklein@nvidia.com>
Date: Thu, 29 Jan 2015 11:24:52 +0100
Message-ID: <CAPDyKFrVLPEiVVzpseeUfLCFtS8UWCChkFPT_OftMbAyQLnGBQ@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: tegra: Write xfer_mode, CMD regs in together
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Chris Ball <chris@printf.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        pkunapuli@nvidia.com, linux-mmc <linux-mmc@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 January 2015 at 17:45, Rhyland Klein <rklein@nvidia.com> wrote:
> From: Pavan Kunapuli <pkunapuli@nvidia.com>
>
> If there is a gap between xfer mode and command register writes,
> tegra SDMMC controller can sometimes issue a spurious command before
> the CMD register is written. To avoid this, these two registers need
> to be written together in a single write operation.
>
> This is implemented as an NVQUIRK as it applies to T114, T124 and
> T132.
>
> Signed-off-by: Pavan Kunapuli <pkunapuli@nvidia.com>
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>

Thanks! Applied for next.

Kind regards
Uffe

> ---
> v2:
>  - Fixed quirk flag check  s/*/&
>  - Removed line clearing xfer_mode_shadow
>  - Added explicit mention of which platforms this applies to in
>    description
>
>  drivers/mmc/host/sdhci-tegra.c |   30 +++++++++++++++++++++++++++++-
>  1 file changed, 29 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
> index 59797106af93..f3778d58d1cd 100644
> --- a/drivers/mmc/host/sdhci-tegra.c
> +++ b/drivers/mmc/host/sdhci-tegra.c
> @@ -41,6 +41,7 @@
>  #define NVQUIRK_DISABLE_SDR50          BIT(3)
>  #define NVQUIRK_DISABLE_SDR104         BIT(4)
>  #define NVQUIRK_DISABLE_DDR50          BIT(5)
> +#define NVQUIRK_SHADOW_XFER_MODE_REG   BIT(6)
>
>  struct sdhci_tegra_soc_data {
>         const struct sdhci_pltfm_data *pdata;
> @@ -67,6 +68,31 @@ static u16 tegra_sdhci_readw(struct sdhci_host *host, int reg)
>         return readw(host->ioaddr + reg);
>  }
>
> +static void tegra_sdhci_writew(struct sdhci_host *host, u16 val, int reg)
> +{
> +       struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> +       struct sdhci_tegra *tegra_host = pltfm_host->priv;
> +       const struct sdhci_tegra_soc_data *soc_data = tegra_host->soc_data;
> +
> +       if (soc_data->nvquirks & NVQUIRK_SHADOW_XFER_MODE_REG) {
> +               switch (reg) {
> +               case SDHCI_TRANSFER_MODE:
> +                       /*
> +                        * Postpone this write, we must do it together with a
> +                        * command write that is down below.
> +                        */
> +                       pltfm_host->xfer_mode_shadow = val;
> +                       return;
> +               case SDHCI_COMMAND:
> +                       writel((val << 16) | pltfm_host->xfer_mode_shadow,
> +                               host->ioaddr + SDHCI_TRANSFER_MODE);
> +                       return;
> +               }
> +       }
> +
> +       writew(val, host->ioaddr + reg);
> +}
> +
>  static void tegra_sdhci_writel(struct sdhci_host *host, u32 val, int reg)
>  {
>         struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> @@ -147,6 +173,7 @@ static void tegra_sdhci_set_bus_width(struct sdhci_host *host, int bus_width)
>  static const struct sdhci_ops tegra_sdhci_ops = {
>         .get_ro     = tegra_sdhci_get_ro,
>         .read_w     = tegra_sdhci_readw,
> +       .write_w    = tegra_sdhci_writew,
>         .write_l    = tegra_sdhci_writel,
>         .set_clock  = sdhci_set_clock,
>         .set_bus_width = tegra_sdhci_set_bus_width,
> @@ -201,7 +228,8 @@ static struct sdhci_tegra_soc_data soc_data_tegra114 = {
>         .pdata = &sdhci_tegra114_pdata,
>         .nvquirks = NVQUIRK_DISABLE_SDR50 |
>                     NVQUIRK_DISABLE_DDR50 |
> -                   NVQUIRK_DISABLE_SDR104,
> +                   NVQUIRK_DISABLE_SDR104 |
> +                   NVQUIRK_SHADOW_XFER_MODE_REG,
>  };
>
>  static const struct of_device_id sdhci_tegra_dt_match[] = {
> --
> 1.7.9.5
>
