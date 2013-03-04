Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab3CDF4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 00:56:39 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:56231 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab3CDF4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 00:56:38 -0500
MIME-Version: 1.0
In-Reply-To: <1362376059.414.1.camel@phoenix>
References: <1362376059.414.1.camel@phoenix>
Date: Mon, 4 Mar 2013 13:56:37 +0800
Message-ID: <CAD6h2NSnH68_2iXd5g3vxuoADdWkQhiFCjXHbKKAg3KgA5wgQQ@mail.gmail.com>
Subject: Re: [PATCH RFT] pinctrl: single: Fix build error
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 March 2013 13:47, Axel Lin <axel.lin@ingics.com> wrote:
> If pcs->is_pinconf is false, it means does not support pinconf.
> If pcs->is_pinconf is true, is_generic flag is always true.
>
> This patch fixes below build error:
>
>   CC [M]  drivers/pinctrl/pinctrl-single.o
> drivers/pinctrl/pinctrl-single.c: In function 'pcs_probe':
> drivers/pinctrl/pinctrl-single.c:1441:3: error: assignment of member 'is_generic' in read-only object
> make[2]: *** [drivers/pinctrl/pinctrl-single.o] Error 1
> make[1]: *** [drivers/pinctrl] Error 2
> make: *** [drivers] Error 2
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/pinctrl/pinctrl-single.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
> index 4cdcf85..e35dabd 100644
> --- a/drivers/pinctrl/pinctrl-single.c
> +++ b/drivers/pinctrl/pinctrl-single.c
> @@ -734,6 +734,7 @@ static const struct pinconf_ops pcs_pinconf_ops = {
>         .pin_config_dbg_show = pcs_pinconf_dbg_show,
>         .pin_config_group_dbg_show = pcs_pinconf_group_dbg_show,
>         .pin_config_config_dbg_show = pcs_pinconf_config_dbg_show,
> +       .is_generic = true,

There's two cases for is_generic. Your fix only make thing worse.

By the way, I already sent a patch to fix it.

Regards
Haojian
>  };
>
>  /**
> @@ -1435,10 +1436,9 @@ static int pcs_probe(struct platform_device *pdev)
>         pcs->desc.name = DRIVER_NAME;
>         pcs->desc.pctlops = &pcs_pinctrl_ops;
>         pcs->desc.pmxops = &pcs_pinmux_ops;
> -       pcs->desc.confops = &pcs_pinconf_ops;
> +       if (pcs->is_pinconf)
> +               pcs->desc.confops = &pcs_pinconf_ops;
>         pcs->desc.owner = THIS_MODULE;
> -       if (match->data)
> -               pcs_pinconf_ops.is_generic = true;
>
>         ret = pcs_allocate_pin_table(pcs);
>         if (ret < 0)
> --
> 1.7.9.5
>
>
>
