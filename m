Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaAQOtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:49:13 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:45234 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaAQOtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:49:08 -0500
MIME-Version: 1.0
In-Reply-To: <1389933996-19306-1-git-send-email-Li.Xiubo@freescale.com>
References: <1389933996-19306-1-git-send-email-Li.Xiubo@freescale.com>
Date: Fri, 17 Jan 2014 08:49:07 -0600
Message-ID: <CAL_JsqJuAv8=pBuzYO5ZGzroD1kq6gjmNsTjoVyXR=vcu+-pTA@mail.gmail.com>
Subject: Re: [PATCH] of: fix of_update_property()
From: Rob Herring <robherring2@gmail.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 10:46 PM, Xiubo Li <Li.Xiubo@freescale.com> wrote:
> The of_update_property() is intent to update a property in a node

s/intent/indended/

> and if the property does not exist, will add it to the node.
>
> The second search of the property is possibly won't be found, that
> maybe removed by other thread just before the second search begain,
> if so just retry it.

How did you find this problem? Actual use or some artificial stress test?

> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  drivers/of/base.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index f807d0e..d0c53bc 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1572,6 +1572,7 @@ int of_update_property(struct device_node *np, struct property *newprop)
>         if (!newprop->name)
>                 return -EINVAL;
>
> +retry:
>         oldprop = of_find_property(np, newprop->name, NULL);
>         if (!oldprop)
>                 return of_add_property(np, newprop);

Isn't there also a race that if you do 2 updates for a non-existent
property and both threads try to add the property, the first one will
succeed and the 2nd will fail. The 2nd one needs to retry as well.

Also, couldn't the node itself be removed while trying to do the update?

There seem to be multiple problems with this code, but doing multiple
simultaneous, conflicting updates seems like an unlikely case.

Rob

> @@ -1593,7 +1594,7 @@ int of_update_property(struct device_node *np, struct property *newprop)
>         raw_spin_unlock_irqrestore(&devtree_lock, flags);
>
>         if (!found)
> -               return -ENODEV;
> +               goto retry;
>
>  #ifdef CONFIG_PROC_DEVICETREE
>         /* try to add to proc as well if it was initialized */
> --
> 1.8.4
>
>
