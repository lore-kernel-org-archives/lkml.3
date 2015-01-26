Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbbAZPPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:15:48 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:33451 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbbAZPPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:15:45 -0500
MIME-Version: 1.0
In-Reply-To: <1422271175-19445-2-git-send-email-addy.ke@rock-chips.com>
References: <1422271175-19445-1-git-send-email-addy.ke@rock-chips.com>
	<1422271175-19445-2-git-send-email-addy.ke@rock-chips.com>
Date: Mon, 26 Jan 2015 16:15:44 +0100
Message-ID: <CAPDyKFp=5epMggHu0+u_LU7ETujcoeP2xOpB7iD6JF2bs8BnEA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mmc: core: use card pointer as the first parameter of execute_tuning()
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?Q?Pawe=C5=82_Moll?= <pawel.moll@arm.com>,
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
        Alexandru Stan <amstan@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "zhenfu.fang" <zhenfu.fang@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, lintao <lintao@rock-chips.com>,
        chenfen <chenfen@rock-chips.com>, zyf <zyf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Chris Zhong <zyw@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        Han Jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        zhangqing <zhangqing@rock-chips.com>, Lin Huang <hl@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 January 2015 at 12:19, Addy Ke <addy.ke@rock-chips.com> wrote:
> We need to take the card pointer in execute_tuning() for mmc_send_status(),

mmc_send_status() is an mmc core function, not intended for host's to call.

> but mmc->card is NULL in tuning state. So we need change the first parameter
> of execute_tuning() to card pointer(struct mmc_card * card).

So, why do we need this?

Kind regards
Uffe

>
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> ---
>  drivers/mmc/core/core.c           | 2 +-
>  drivers/mmc/host/dw_mmc.c         | 3 ++-
>  drivers/mmc/host/rtsx_pci_sdmmc.c | 3 ++-
>  drivers/mmc/host/rtsx_usb_sdmmc.c | 3 ++-
>  include/linux/mmc/host.h          | 2 +-
>  5 files changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 1be7055..271f024 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -1101,7 +1101,7 @@ int mmc_execute_tuning(struct mmc_card *card)
>                 opcode = MMC_SEND_TUNING_BLOCK;
>
>         mmc_host_clk_hold(host);
> -       err = host->ops->execute_tuning(host, opcode);
> +       err = host->ops->execute_tuning(card, opcode);
>         mmc_host_clk_release(host);
>
>         if (err)
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 4bd22af..e54e656 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -1485,8 +1485,9 @@ free_blk_test:
>         return ret;
>  }
>
> -static int dw_mci_execute_tuning(struct mmc_host *mmc, u32 opcode)
> +static int dw_mci_execute_tuning(struct mmc_card *card, u32 opcode)
>  {
> +       struct mmc_host *mmc = card->host;
>         struct dw_mci_slot *slot = mmc_priv(mmc);
>         struct dw_mci *host = slot->host;
>         const struct dw_mci_drv_data *drv_data = host->drv_data;
> diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
> index 1d3d6c4..230bd2f 100644
> --- a/drivers/mmc/host/rtsx_pci_sdmmc.c
> +++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
> @@ -1270,8 +1270,9 @@ out:
>         return err;
>  }
>
> -static int sdmmc_execute_tuning(struct mmc_host *mmc, u32 opcode)
> +static int sdmmc_execute_tuning(struct mmc_card *card, u32 opcode)
>  {
> +       struct mmc_host *mmc = card->host;
>         struct realtek_pci_sdmmc *host = mmc_priv(mmc);
>         struct rtsx_pcr *pcr = host->pcr;
>         int err = 0;
> diff --git a/drivers/mmc/host/rtsx_usb_sdmmc.c b/drivers/mmc/host/rtsx_usb_sdmmc.c
> index 88af827..c494c06 100644
> --- a/drivers/mmc/host/rtsx_usb_sdmmc.c
> +++ b/drivers/mmc/host/rtsx_usb_sdmmc.c
> @@ -1265,8 +1265,9 @@ out:
>                 return 0;
>  }
>
> -static int sdmmc_execute_tuning(struct mmc_host *mmc, u32 opcode)
> +static int sdmmc_execute_tuning(struct mmc_card *card, u32 opcode)
>  {
> +       struct mmc_host *mmc = card->host;
>         struct rtsx_usb_sdmmc *host = mmc_priv(mmc);
>         struct rtsx_ucr *ucr = host->ucr;
>         int err = 0;
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index 0c8cbe5..ec4128e 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -133,7 +133,7 @@ struct mmc_host_ops {
>         int     (*card_busy)(struct mmc_host *host);
>
>         /* The tuning command opcode value is different for SD and eMMC cards */
> -       int     (*execute_tuning)(struct mmc_host *host, u32 opcode);
> +       int     (*execute_tuning)(struct mmc_card *card, u32 opcode);
>
>         /* Prepare HS400 target operating frequency depending host driver */
>         int     (*prepare_hs400_tuning)(struct mmc_host *host, struct mmc_ios *ios);
> --
> 1.8.3.2
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
