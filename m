Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaHMI6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:58:48 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:63710 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaHMI6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:58:45 -0400
MIME-Version: 1.0
In-Reply-To: <1407845127-8448-1-git-send-email-srinivas.kandadgatla@linaro.org>
References: <1407844950-8072-1-git-send-email-srinivas.kandadgatla@linaro.org>
	<1407845127-8448-1-git-send-email-srinivas.kandadgatla@linaro.org>
Date: Wed, 13 Aug 2014 10:58:45 +0200
Message-ID: <CACRpkdY-rhuqMgY7ZRB8YEi+AiNMV_SLbSGJy7Nw+ytyjQXMnA@mail.gmail.com>
Subject: Re: [PATCH RFC 5/5] mmc: mmci: move ST specific sdio setup under a condition
From: Linus Walleij <linus.walleij@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 2:05 PM, Srinivas Kandagatla
<srinivas.kandagatla@linaro.org> wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> This patch moves ST specific sdio setup under a vendor id condition,
> this will ensure that the ST specfic setup is not done on other vendor
> like Qualcomm.
>
> Originally the issue was detected while testing WLAN ath6kl on IFC6410
> board with APQ8064 SOC.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

So instead of again checking hw_designer (I think that's a bit
messy) and instead of having the flag bool sdio from patch
1, why not introduce 2 flags in vendor_data:

bool st_sdio;
bool qcom_sdio;

> +++ b/drivers/mmc/host/mmci.c
> @@ -828,7 +828,8 @@ static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
>                          * otherwise the transfer will not start. The threshold
>                          * depends on the rate of MCLK.
>                          */
> -                       if (data->flags & MMC_DATA_WRITE &&
> +                       if (host->hw_designer == AMBA_VENDOR_ST &&
> +                           data->flags & MMC_DATA_WRITE &&

And this becomes just

if (variant->st_sdio)...

>                             (host->size < 8 ||
>                              (host->size <= 8 && host->mclk > 50000000)))
>                                 clk = host->clk_reg & ~variant->clkreg_enable;

Yours,
Linus Walleij
