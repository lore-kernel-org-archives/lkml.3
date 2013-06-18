Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab3FRLnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:43:40 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:39532 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab3FRLni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:43:38 -0400
MIME-Version: 1.0
In-Reply-To: <1371553171-23530-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1371553171-23530-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Tue, 18 Jun 2013 17:13:37 +0530
Message-ID: <CAK9yfHwq_OC6s5Lvh6j5RP5xCTzgkWxFLrUq7_5i_7gPfCDTXQ@mail.gmail.com>
Subject: Re: [PATCH] clocksource: sh_cmt: Use devm_* managed helpers
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On 18 June 2013 16:29, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> This simplifies the main error path by getting rid of it.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/clocksource/sh_cmt.c | 40 ++++++++++++++--------------------------
>  1 file changed, 14 insertions(+), 26 deletions(-)
>
> The patch is based on top of renesas-next-20130618 plus Magnus'
> "clocksource: sh_cmt: 32-bit control register support" patch.
>
> diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
> index 0965e98..7001e4d 100644
> --- a/drivers/clocksource/sh_cmt.c
> +++ b/drivers/clocksource/sh_cmt.c
> @@ -681,20 +681,18 @@ static int sh_cmt_setup(struct sh_cmt_priv *p, struct platform_device *pdev)
>         struct sh_timer_config *cfg = pdev->dev.platform_data;
>         struct resource *res, *res2;
>         int irq, ret;
> -       ret = -ENXIO;
>
> -       memset(p, 0, sizeof(*p));
>         p->pdev = pdev;
>
>         if (!cfg) {
>                 dev_err(&p->pdev->dev, "missing platform data\n");
> -               goto err0;
> +               return -ENXIO;
>         }
>
>         res = platform_get_resource(p->pdev, IORESOURCE_MEM, 0);
>         if (!res) {
>                 dev_err(&p->pdev->dev, "failed to get I/O memory\n");
> -               goto err0;
> +               return -ENXIO;
>         }
>
>         /* optional resource for the shared timer start/stop register */
> @@ -703,23 +701,23 @@ static int sh_cmt_setup(struct sh_cmt_priv *p, struct platform_device *pdev)
>         irq = platform_get_irq(p->pdev, 0);
>         if (irq < 0) {
>                 dev_err(&p->pdev->dev, "failed to get irq\n");
> -               goto err0;
> +               return -ENXIO;
>         }
>
>         /* map memory, let mapbase point to our channel */
> -       p->mapbase = ioremap_nocache(res->start, resource_size(res));
> +       p->mapbase = devm_ioremap_resource(&pdev->dev, res);
>         if (p->mapbase == NULL) {

You should check for  IS_ERR (p->mapbase) and return PTR_ERR(p->mapbase)

>                 dev_err(&p->pdev->dev, "failed to remap I/O memory\n");

This error message is not required as devm_ioremap_resource prints its own.

-- 
With warm regards,
Sachin
