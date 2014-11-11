Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbaKKIwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:52:51 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:46760 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaKKIws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:52:48 -0500
MIME-Version: 1.0
In-Reply-To: <1415678573-6093-1-git-send-email-addy.ke@rock-chips.com>
References: <1415109789-7046-1-git-send-email-addy.ke@rock-chips.com>
	<1415678573-6093-1-git-send-email-addy.ke@rock-chips.com>
Date: Tue, 11 Nov 2014 09:52:47 +0100
Message-ID: <CAPDyKFqUoBjhsbz8rkLa9PY_dpgMxnimz3k7OoA5WVhi7MacPQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: try pick the exact same voltage as vmmc for vqmmc
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
        Sonny Rao <sonnyrao@chromium.org>, amstan@chromium.org,
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

On 11 November 2014 05:02, Addy Ke <addy.ke@rock-chips.com> wrote:
> SD2.0 cards need vqmmc and vmmc to be the same.

No, that's not correct.

If I remember the spec correctly, the bus signal threshold is 0.75 * VDD.

> But vqmmc call regulator_set_voltage to set min_uv(2.7v) as far as possible.

I guess you want to do that to save as much power as possible.

> So if we set vmmc 3.3V in dt table, we will get error information as follows:
>
> [   17.785398] mmc_host mmc1: Bus speed (slot 0) = 50000000Hz (slot req
> 50000000Hz, actual 50000000HZ div = 0)
> [   17.795175] mmc1: new high speed SDHC card at address e624
> [   17.801283] mmcblk1: mmc1:e624 SU08G 7.40 GiB
> [   17.816033]  mmcblk1: p1
> [   17.839318] mmcblk1: error -110 sending status command, retrying
> [   17.845363] mmcblk1: error -115 sending stop command, original cmd
> response 0x900, card status 0x800b00
> [   17.854758] mmcblk1: error -84 transferring data, sector 32, nr 24,
> cmd response 0x900, card status 0xb00
> [   17.864328] mmcblk1: retrying using single block read
> [   17.873647] mmcblk1: error -110 sending status command, retrying
> [   17.879660] mmcblk1: error -84 transferring data, sector 44, nr 12,
> cmd response 0x900, card status 0x0
> [   17.889051] end_request: I/O error, dev mmcblk1, sector 44
> [   17.895594] Buffer I/O error on device mmcblk1, logical block 5
> [   17.902484] mmcblk1: error -110 sending status command, retrying
> [   17.908498] mmcblk1: error -84 transferring data, sector 50, nr 6,
> cmd response 0x900, card status 0x0
> [   17.917802] end_request: I/O error, dev mmcblk1, sector 50
> [   17.924984] Buffer I/O error on device mmcblk1, logical block 6
> [   18.431258] mmc_host mmc1: Timeout sending command (cmd 0x200000 arg
> 0x0 status 0x80200000)
>
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> ---
>  drivers/mmc/host/dw_mmc.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index b4c3044..a8b70b5 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -1163,8 +1163,14 @@ static int dw_mci_switch_voltage(struct mmc_host *mmc, struct mmc_ios *ios)
>          */
>         uhs = mci_readl(host, UHS_REG);
>         if (ios->signal_voltage == MMC_SIGNAL_VOLTAGE_330) {
> -               min_uv = 2700000;
> -               max_uv = 3600000;
> +               /* try pick the exact same voltage as vmmc for vqmmc */

This seems like a generic SD protocol issue.

Should we maybe provide some helper function from the mmc core, which
in principle take the negotiated card->ocr into account while
calculating the signal voltage level. Typically min_uv should be 0.75
x (card->ocr), for these cases.

Comments?

> +               if (!IS_ERR(mmc->supply.vmmc)) {
> +                       min_uv = regulator_get_voltage(mmc->supply.vmmc);
> +                       max_uv = min_uv;
> +               } else {
> +                       min_uv = 2700000;
> +                       max_uv = 3600000;
> +               }
>                 uhs &= ~v18;
>         } else {
>                 min_uv = 1700000;
> --
> 1.8.3.2
>
>

Kind regards
Uffe
