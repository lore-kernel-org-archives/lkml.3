Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab3BDNmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:42:44 -0500
Received: from mail-ia0-f173.google.com ([209.85.210.173]:37377 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab3BDNmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:42:43 -0500
MIME-Version: 1.0
In-Reply-To: <1359291524.11083.5.camel@phoenix>
References: <1359291524.11083.5.camel@phoenix>
Date: Mon, 4 Feb 2013 21:42:42 +0800
Message-ID: <CAN1soZxoUTt_aLB70camxXHQb2oVutsnDLF-ki6NekoWQqbt+A@mail.gmail.com>
Subject: Re: [RFT][PATCH v2] backlight: 88pm860x_bl: Add missing of_node_put()
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2013 at 8:58 PM, Axel Lin <axel.lin@ingics.com> wrote:
> of_find_node_by_name() returns a node pointer with refcount incremented, use
> of_node_put() on it when done.
>
> of_find_node_by_name() will call of_node_put() against the node pass to from
> parameter, thus we also need to call of_node_get(from) before calling
> of_find_node_by_name().
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> v2:
> need to call of_node_get(pdev->dev.parent->of_node) before calling
> of_find_node_by_name().
>
>  drivers/video/backlight/88pm860x_bl.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/video/backlight/88pm860x_bl.c b/drivers/video/backlight/88pm860x_bl.c
> index c072ed9..2cd6350 100644
> --- a/drivers/video/backlight/88pm860x_bl.c
> +++ b/drivers/video/backlight/88pm860x_bl.c
> @@ -165,8 +165,10 @@ static int pm860x_backlight_dt_init(struct platform_device *pdev,
>                                     struct pm860x_backlight_data *data,
>                                     char *name)
>  {
> -       struct device_node *nproot = pdev->dev.parent->of_node, *np;
> +       struct device_node *nproot, *np;
>         int iset = 0;
> +
> +       nproot = of_node_get(pdev->dev.parent->of_node);
>         if (!nproot)
>                 return -ENODEV;
>         nproot = of_find_node_by_name(nproot, "backlights");
> @@ -184,6 +186,7 @@ static int pm860x_backlight_dt_init(struct platform_device *pdev,
>                         break;
>                 }
>         }
> +       of_node_put(nproot);
>         return 0;
>  }
>  #else

Don't agree on this. If we want to protect it, we should use the logic in below.
1. of_node_get() in parent 88pm860x-core driver.
2. of_node_put() in child backlight driver or anything else.

The reference is used to prevent of_node releasing before some usage.
At here, we need
to prevent parent driver to release of_node. I can't see any benefit
from of_node_get()
in the child backlight driver.

Regards
Haojian
