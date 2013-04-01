Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab3DAHZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 03:25:04 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:34044 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907Ab3DAHZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 03:25:02 -0400
MIME-Version: 1.0
In-Reply-To: <1364742271.3834.7.camel@phoenix>
References: <1364741987.3834.2.camel@phoenix> <1364742271.3834.7.camel@phoenix>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 1 Apr 2013 15:24:41 +0800
Message-ID: <CAMPhdO8sxF5N1_SGrcrqd4g8hGq-dWx9_XXLCG25G0pYw+i5fg@mail.gmail.com>
Subject: Re: [PATCH 3/3] pwm: pxa: Remove clk_enabled field from struct pxa_pwm_chip
To: Axel Lin <axel.lin@ingics.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 31, 2013 at 11:04 PM, Axel Lin <axel.lin@ingics.com> wrote:
> clk_enable/clk_disable maintain an enable_count, clk_prepare and clk_unprepare
> also maintain a prepare_count. These APIs will do prepare/enable when the first
> user calling these APIs, and do disable/unprepare when the corresponding counter
> reach 0. Thus We don't need to maintain a clk_enabled counter here.

The original intention is to keep a paired clk enable counter no matter
how the user calls pwm_enable()/pwm_disable() in pair or not, if that's
no longer the case.

>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/pwm/pwm-pxa.c |   16 ++--------------
>  1 file changed, 2 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/pwm/pwm-pxa.c b/drivers/pwm/pwm-pxa.c
> index 20370e6..b789882 100644
> --- a/drivers/pwm/pwm-pxa.c
> +++ b/drivers/pwm/pwm-pxa.c
> @@ -48,7 +48,6 @@ struct pxa_pwm_chip {
>         struct device   *dev;
>
>         struct clk      *clk;
> -       int             clk_enabled;
>         void __iomem    *mmio_base;
>  };
>
> @@ -108,24 +107,15 @@ static int pxa_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
>  static int pxa_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
>  {
>         struct pxa_pwm_chip *pc = to_pxa_pwm_chip(chip);
> -       int rc = 0;
>
> -       if (!pc->clk_enabled) {
> -               rc = clk_prepare_enable(pc->clk);
> -               if (!rc)
> -                       pc->clk_enabled++;
> -       }
> -       return rc;
> +       return clk_prepare_enable(pc->clk);
>  }
>
>  static void pxa_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
>  {
>         struct pxa_pwm_chip *pc = to_pxa_pwm_chip(chip);
>
> -       if (pc->clk_enabled) {
> -               clk_disable_unprepare(pc->clk);
> -               pc->clk_enabled--;
> -       }
> +       clk_disable_unprepare(pc->clk);
>  }
>
>  static struct pwm_ops pxa_pwm_ops = {
> @@ -152,8 +142,6 @@ static int pwm_probe(struct platform_device *pdev)
>         if (IS_ERR(pwm->clk))
>                 return PTR_ERR(pwm->clk);
>
> -       pwm->clk_enabled = 0;
> -
>         pwm->chip.dev = &pdev->dev;
>         pwm->chip.ops = &pxa_pwm_ops;
>         pwm->chip.base = -1;
> --
> 1.7.10.4
>
>
>
