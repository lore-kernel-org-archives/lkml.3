Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbaH2MAD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 08:00:03 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:52550 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaH2MAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 08:00:00 -0400
MIME-Version: 1.0
In-Reply-To: <1408990744-1093-1-git-send-email-dianders@chromium.org>
References: <1408990744-1093-1-git-send-email-dianders@chromium.org>
Date: Fri, 29 Aug 2014 13:59:59 +0200
Message-ID: <CAPDyKFrAP2zRDbR5Xx_mstjLRBGARknjeP1UjR8jXMhBABanXg@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Pass back errors from mmc_of_parse()
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Addy Ke <addy.ke@rock-chips.com>, Olof Johansson <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, Chris Ball <cjb@laptop.org>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        Chris Ball <chris@printf.net>, linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 August 2014 20:19, Doug Anderson <dianders@chromium.org> wrote:
> It's possible that mmc_of_parse() could return errors (possibly in
> some future version it might return -EPROBE_DEFER even).  Let's pass
> those errors back.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Thanks! Applied for next.

I needed to resolve to simple conflict, but you still might want to
verify that the end result is what you expected.

Kind regards
Uffe

> ---
>  drivers/mmc/host/dw_mmc.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 7f227e9..9ef4df0 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -2131,7 +2131,9 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>         if (host->pdata->caps2)
>                 mmc->caps2 = host->pdata->caps2;
>
> -       mmc_of_parse(mmc);
> +       ret = mmc_of_parse(mmc);
> +       if (ret)
> +               goto err_host_allocated;
>
>         if (host->pdata->blk_settings) {
>                 mmc->max_segs = host->pdata->blk_settings->max_segs;
> @@ -2163,7 +2165,7 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>
>         ret = mmc_add_host(mmc);
>         if (ret)
> -               goto err_setup_bus;
> +               goto err_host_allocated;
>
>  #if defined(CONFIG_DEBUG_FS)
>         dw_mci_init_debugfs(slot);
> @@ -2174,9 +2176,9 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>
>         return 0;
>
> -err_setup_bus:
> +err_host_allocated:
>         mmc_free_host(mmc);
> -       return -EINVAL;
> +       return ret;
>  }
>
>  static void dw_mci_cleanup_slot(struct dw_mci_slot *slot, unsigned int id)
> --
> 2.1.0.rc2.206.gedb03e5
>
