Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaLOXo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 18:44:27 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:37079 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaLOXoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 18:44:25 -0500
MIME-Version: 1.0
In-Reply-To: <1418685929-13096-2-git-send-email-dianders@chromium.org>
References: <1418685929-13096-1-git-send-email-dianders@chromium.org>
	<1418685929-13096-2-git-send-email-dianders@chromium.org>
Date: Mon, 15 Dec 2014 15:44:24 -0800
X-Google-Sender-Auth: 2jjzvL5p6b7GdxVgxlcnfKeL2U4
Message-ID: <CAL1qeaHfsq1xOOBMQc58uSvV4unuEWHjqVpiZrpu2bQD36LbXg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mmc: dw_mmc: Use mmc_regulator_set_vqmmc in start_signal_voltage_switch
From: Andrew Bresticker <abrestic@chromium.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, Mark Brown <broonie@kernel.org>,
        Alexandru Stan <amstan@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On Mon, Dec 15, 2014 at 3:25 PM, Doug Anderson <dianders@chromium.org> wrote:
> We've introduced a new helper in the MMC core:
> mmc_regulator_set_vqmmc().  Let's use this in dw_mmc.  Using this new
> helper has some advantages:
>
> 1. We get the mmc_regulator_set_vqmmc() behavior of trying to match
>    VQMMC and VMMC when the signal voltage is 3.3V.  This ensures max
>    compatibility.
>
> 2. We get rid of a few more warnings when probing unsupported
>    voltages.
>
> 3. We get rid of some non-dw_mmc specific code in dw_mmc.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

One small comment below...

> @@ -1170,24 +1168,11 @@ static int dw_mci_switch_voltage(struct mmc_host *mmc, struct mmc_ios *ios)
>          */
>         uhs = mci_readl(host, UHS_REG);
>         if (ios->signal_voltage == MMC_SIGNAL_VOLTAGE_330) {
> -               min_uv = 2700000;
> -               max_uv = 3600000;
>                 uhs &= ~v18;
>         } else {
> -               min_uv = 1700000;
> -               max_uv = 1950000;
>                 uhs |= v18;
>         }
> -       if (!IS_ERR(mmc->supply.vqmmc)) {
> -               ret = regulator_set_voltage(mmc->supply.vqmmc, min_uv, max_uv);
> -
> -               if (ret) {
> -                       dev_dbg(&mmc->class_dev,
> -                                        "Regulator set error %d: %d - %d\n",
> -                                        ret, min_uv, max_uv);
> -                       return ret;
> -               }
> -       }
> +       mmc_regulator_set_vqmmc(mmc, ios);

Shouldn't we check the return value here and bail out of the voltage
switch procedure if it fails?
