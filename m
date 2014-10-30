Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbaJ3ElK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 00:41:10 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:51911 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092AbaJ3ElH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 00:41:07 -0400
MIME-Version: 1.0
In-Reply-To: <1414635679-12565-1-git-send-email-addy.ke@rock-chips.com>
References: <1414635679-12565-1-git-send-email-addy.ke@rock-chips.com>
Date: Wed, 29 Oct 2014 21:41:05 -0700
X-Google-Sender-Auth: dAgfnsb6X14oK6L7E1j-lY-KA-Y
Message-ID: <CAD=FV=Uo3gcnGFn=gpZhV1r+qyZxJ_tpAEiSsu06P=csHTScug@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: add a quirk for the defferent bit of sdio interrupt
From: Doug Anderson <dianders@chromium.org>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "zhenfu.fang" <zhenfu.fang@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, lintao <lintao@rock-chips.com>,
        chenfen <chenfen@rock-chips.com>, zyf <zyf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Chris <zyw@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        zhangqing <zhangqing@rock-chips.com>, Lin Huang <hl@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addy,

On Wed, Oct 29, 2014 at 7:21 PM, Addy Ke <addy.ke@rock-chips.com> wrote:
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -778,6 +778,12 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
>         u32 div;
>         u32 clk_en_a;
>         u32 sdmmc_cmd_bits = SDMMC_CMD_UPD_CLK | SDMMC_CMD_PRV_DAT_WAIT;
> +       u32 sdio_int_bit;
> +
> +       if (host->quirks & DW_MCI_QUIRK_SDIO_INT_24BIT)
> +               sdio_int_bit = SDMMC_INT_SDIO_24BIT(slot->id);
> +       else
> +               sdio_int_bit = SDMMC_INT_SDIO(slot->id);

You can avoid a lot of "if" tests if you just add a new "sdio->id"
field to the slot and init it at probe time.  It would be "8 +
slot->id" for rk3288 systems.

> @@ -2452,6 +2471,9 @@ static struct dw_mci_of_quirks {
>         }, {
>                 .quirk  = "disable-wp",
>                 .id     = DW_MCI_QUIRK_NO_WRITE_PROTECT,
> +       }, {
> +               .quirk  = "sdio-int-24bit",
> +               .id     = DW_MCI_QUIRK_SDIO_INT_24BIT,

This is adding a device tree binding.  You need to document it.

...but you should probably avoid that anyway.  All rk3288 chips need
this.  You should just add do what you need to do automatically if
you're a rk3288.  You've already got a specific compatible string for
rk3288.

-Doug
