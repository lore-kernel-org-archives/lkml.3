Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbaA1LMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 06:12:47 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:47045 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072AbaA1LMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 06:12:44 -0500
MIME-Version: 1.0
In-Reply-To: <1390906213-7612-1-git-send-email-Vincent.Yang@tw.fujitsu.com>
References: <1390906213-7612-1-git-send-email-Vincent.Yang@tw.fujitsu.com>
Date: Tue, 28 Jan 2014 12:12:44 +0100
Message-ID: <CAPDyKFpiNWsSmJyApdLEz1Z433EJ9XHALt4n0uWm7QujNWj-nQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: core: Prevent unexpected SD Clock gating during
 Signal Voltage Switch Procedure
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Vincent Yang <vincent.yang.fujitsu@gmail.com>
Cc: Chris Ball <cjb@laptop.org>, linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        andy.green@linaro.org, jaswinder.singh@linaro.org,
        fujitsu@lists.linaro.org, nonaka.h@jp.fujitsu.com,
        Vincent Yang <Vincent.Yang@tw.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 January 2014 11:50, Vincent Yang <vincent.yang.fujitsu@gmail.com> wrote:
> When switching the signal voltage from 3.3V to 1.8V, there should be only
> one SD Clock gating and un-gating operation. Between them the SD host
> controller should switch signal level to 1.8V.
> However, sometimes there is an additional gating and un-gating operation
> immediately after CMD11. This operation can cause some UHS-I cards report
> failure by holding DAT[3:0] low. It is because CONFIG_MMC_CLKGATE attempts
> to aggressively gate the clock for power saving.
>
> This patch is going to hold SD Clock before CMD11, therefore, the additional
> gating and un-gating operation can be prevented. It has been verified on
> some UHS-I SD memory cards and works correctly.

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

> ---
>  drivers/mmc/core/core.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 098374b..86a35ef 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -1432,6 +1432,8 @@ int mmc_set_signal_voltage(struct mmc_host *host, int signal_voltage, u32 ocr)
>                 pr_warning("%s: cannot verify signal voltage switch\n",
>                                 mmc_hostname(host));
>
> +       mmc_host_clk_hold(host);
> +
>         cmd.opcode = SD_SWITCH_VOLTAGE;
>         cmd.arg = 0;
>         cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
> @@ -1442,8 +1444,6 @@ int mmc_set_signal_voltage(struct mmc_host *host, int signal_voltage, u32 ocr)
>
>         if (!mmc_host_is_spi(host) && (cmd.resp[0] & R1_ERROR))
>                 return -EIO;
> -
> -       mmc_host_clk_hold(host);
>         /*
>          * The card should drive cmd and dat[0:3] low immediately
>          * after the response of cmd11, but wait 1 ms to be sure
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
