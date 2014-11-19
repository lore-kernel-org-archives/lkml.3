Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbaKSTDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 14:03:46 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:33780 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968AbaKSTDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 14:03:44 -0500
MIME-Version: 1.0
In-Reply-To: <1416423073-8105-1-git-send-email-dianders@chromium.org>
References: <1416423073-8105-1-git-send-email-dianders@chromium.org>
Date: Wed, 19 Nov 2014 11:03:43 -0800
X-Google-Sender-Auth: 1s91OE0otTyvGWnOKtZaaoH4dL8
Message-ID: <CAL1qeaGkQVimrFNtGgfTJEHNemG_QUTecQwH4=nXu1_u1rWwhg@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Turn the card clock off at suspend time
From: Andrew Bresticker <abrestic@chromium.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>, Heiko Stuebner <heiko@sntech.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org, Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug,

On Wed, Nov 19, 2014 at 10:51 AM, Doug Anderson <dianders@chromium.org> wrote:
> Since the dw_mmc driver was first added to Linux it's had a TODO in it
> that we should turn off the card clock during suspend.  I have no idea
> for sure why it wasn't done originally, but if I had to guess I'd
> guess it was related to the lack of a common clock framework.  Let's
> do it now.
>
> There is no reason for the card clock to be left on during suspend and
> most systems will eventually turn it off anyway (when whole clock
> trees are disabled).  However, it's good to be explicit that it's
> disabled at the time that the MMC subsystem is disabled.

Should the bus clock (biu) be disabled as well?

> This actually fixes a bug on Rockchip rk3288 where an SDIO card wakes
> the system back up during suspend.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/mmc/host/dw_mmc.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 5a37c33..c448159 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -2825,11 +2825,10 @@ EXPORT_SYMBOL(dw_mci_remove);
>
>
>  #ifdef CONFIG_PM_SLEEP
> -/*
> - * TODO: we should probably disable the clock to the card in the suspend path.
> - */
>  int dw_mci_suspend(struct dw_mci *host)
>  {
> +       clk_disable(host->ciu_clk);

I think you need to check for IS_ERR(host->ciu_clk) since the clock is
optional.  Also, maybe disable_unprepare instead of just disable?

> @@ -2838,6 +2837,8 @@ int dw_mci_resume(struct dw_mci *host)
>  {
>         int i, ret;
>
> +       clk_enable(host->ciu_clk);

Check return value?
