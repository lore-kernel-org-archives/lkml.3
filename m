Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195AbaJ3LLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:11:38 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:54250 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758559AbaJ3LLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:11:35 -0400
MIME-Version: 1.0
In-Reply-To: <1414666240-16782-1-git-send-email-addy.ke@rock-chips.com>
References: <1414635679-12565-1-git-send-email-addy.ke@rock-chips.com>
	<1414666240-16782-1-git-send-email-addy.ke@rock-chips.com>
Date: Thu, 30 Oct 2014 12:11:34 +0100
Message-ID: <CAPDyKFqgNmLbbJpATCqwu0R65xuf=TKP0+pjskGj4xZOjXN8Hw@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: add support for the other bit of sdio interrupt
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "tgih.jun@samsung.com" <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Dinh Nguyen <dinguyen@altera.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Doug Anderson <dianders@chromium.org>,
        Sonny Rao <sonnyrao@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org,
        "zhenfu.fang" <zhenfu.fang@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, lintao <lintao@rock-chips.com>,
        chenfen <chenfen@rock-chips.com>, zyf <zyf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Chris Zhong <zyw@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        zhangqing <zhangqing@rock-chips.com>, Lin Huang <hl@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 October 2014 11:50, Addy Ke <addy.ke@rock-chips.com> wrote:
> The bit of sdio interrupt is 16 in designware implementation,
> but it is 24 in RK3288. This patch add sdio_id0 for the number
> of slot0 in the SDIO interrupt registers, which can be set in
> platform DT table, such as:
> - rockchip,sdio-interrupt-slot0 = <8>;

No, this shouldn't be information in DT.

Instead this can be kept in the driver, depending on what version of
the mmc controller that is being used. Right!?

Kind regards
Uffe

>
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> ---
>  drivers/mmc/host/dw_mmc-rockchip.c | 13 +++++++++++++
>  drivers/mmc/host/dw_mmc.c          | 12 +++++++-----
>  drivers/mmc/host/dw_mmc.h          |  2 ++
>  include/linux/mmc/dw_mmc.h         |  3 +++
>  4 files changed, 25 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/mmc/host/dw_mmc-rockchip.c b/drivers/mmc/host/dw_mmc-rockchip.c
> index f0c2cb1..54655e7 100644
> --- a/drivers/mmc/host/dw_mmc-rockchip.c
> +++ b/drivers/mmc/host/dw_mmc-rockchip.c
> @@ -65,6 +65,18 @@ static void dw_mci_rk3288_set_ios(struct dw_mci *host, struct mmc_ios *ios)
>         }
>  }
>
> +static int dw_mci_rk3288_parse_dt(struct dw_mci *host)
> +{
> +       struct device_node *np = host->dev->of_node;
> +       int sdio_id0;
> +
> +       if (!of_property_read_u32(np, "rockchip,sdio-interrupt-slot0",
> +                                 &sdio_id0))
> +               host->sdio_id0 = sdio_id0;
> +
> +       return 0;
> +}
> +
>  static const struct dw_mci_drv_data rk2928_drv_data = {
>         .prepare_command        = dw_mci_rockchip_prepare_command,
>  };
> @@ -73,6 +85,7 @@ static const struct dw_mci_drv_data rk3288_drv_data = {
>         .prepare_command        = dw_mci_rockchip_prepare_command,
>         .set_ios                = dw_mci_rk3288_set_ios,
>         .setup_clock    = dw_mci_rk3288_setup_clock,
> +       .parse_dt       = dw_mci_rk3288_parse_dt,
>  };
>
>  static const struct of_device_id dw_mci_rockchip_match[] = {
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 69f0cc6..2ea7467 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -819,7 +819,7 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
>
>                 /* enable clock; only low power if no SDIO */
>                 clk_en_a = SDMMC_CLKEN_ENABLE << slot->id;
> -               if (!(mci_readl(host, INTMASK) & SDMMC_INT_SDIO(slot->id)))
> +               if (!(mci_readl(host, INTMASK) & SDMMC_INT_SDIO(slot->sdio_id)))
>                         clk_en_a |= SDMMC_CLKEN_LOW_PWR << slot->id;
>                 mci_writel(host, CLKENA, clk_en_a);
>
> @@ -1180,10 +1180,10 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
>                 dw_mci_disable_low_power(slot);
>
>                 mci_writel(host, INTMASK,
> -                          (int_mask | SDMMC_INT_SDIO(slot->id)));
> +                          (int_mask | SDMMC_INT_SDIO(slot->sdio_id)));
>         } else {
>                 mci_writel(host, INTMASK,
> -                          (int_mask & ~SDMMC_INT_SDIO(slot->id)));
> +                          (int_mask & ~SDMMC_INT_SDIO(slot->sdio_id)));
>         }
>  }
>
> @@ -2035,8 +2035,9 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
>                 /* Handle SDIO Interrupts */
>                 for (i = 0; i < host->num_slots; i++) {
>                         struct dw_mci_slot *slot = host->slot[i];
> -                       if (pending & SDMMC_INT_SDIO(i)) {
> -                               mci_writel(host, RINTSTS, SDMMC_INT_SDIO(i));
> +                       if (pending & SDMMC_INT_SDIO(slot->sdio_id)) {
> +                               mci_writel(host, RINTSTS,
> +                                          SDMMC_INT_SDIO(slot->sdio_id));
>                                 mmc_signal_sdio_irq(slot->mmc);
>                         }
>                 }
> @@ -2206,6 +2207,7 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>
>         slot = mmc_priv(mmc);
>         slot->id = id;
> +       slot->sdio_id = host->sdio_id0 + id;
>         slot->mmc = mmc;
>         slot->host = host;
>         host->slot[id] = slot;
> diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
> index 01b99e8..3e966a9 100644
> --- a/drivers/mmc/host/dw_mmc.h
> +++ b/drivers/mmc/host/dw_mmc.h
> @@ -214,6 +214,7 @@ extern int dw_mci_resume(struct dw_mci *host);
>   *     with CONFIG_MMC_CLKGATE.
>   * @flags: Random state bits associated with the slot.
>   * @id: Number of this slot.
> + * @sdio_id: Number of this slot in the SDIO interrupt registers.
>   * @last_detect_state: Most recently observed card detect state.
>   */
>  struct dw_mci_slot {
> @@ -234,6 +235,7 @@ struct dw_mci_slot {
>  #define DW_MMC_CARD_PRESENT    0
>  #define DW_MMC_CARD_NEED_INIT  1
>         int                     id;
> +       int                     sdio_id;
>         int                     last_detect_state;
>  };
>
> diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
> index 0013669..4c0d3f2 100644
> --- a/include/linux/mmc/dw_mmc.h
> +++ b/include/linux/mmc/dw_mmc.h
> @@ -96,6 +96,7 @@ struct mmc_data;
>   * @quirks: Set of quirks that apply to specific versions of the IP.
>   * @irq_flags: The flags to be passed to request_irq.
>   * @irq: The irq value to be passed to request_irq.
> + * @sdio_id0: Number of slot0 in the SDIO interrupt registers.
>   *
>   * Locking
>   * =======
> @@ -193,6 +194,8 @@ struct dw_mci {
>         bool                    vqmmc_enabled;
>         unsigned long           irq_flags; /* IRQ flags */
>         int                     irq;
> +
> +       int                     sdio_id0;
>  };
>
>  /* DMA ops for Internal/External DMAC interface */
> --
> 1.8.3.2
>
>
