Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaKZVG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 16:06:57 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:57111 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaKZVGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 16:06:54 -0500
MIME-Version: 1.0
In-Reply-To: <1417023640-23464-2-git-send-email-leif.lindholm@linaro.org>
References: <1417023640-23464-1-git-send-email-leif.lindholm@linaro.org> <1417023640-23464-2-git-send-email-leif.lindholm@linaro.org>
From: Grant Likely <grant.likely@linaro.org>
Date: Wed, 26 Nov 2014 21:06:33 +0000
X-Google-Sender-Auth: 0gP6QNiyKafzgEbtJ-0H83yCQTs
Message-ID: <CACxGe6tQ5rWzCUcS+_fFY+rjEyua2khApAoCVKpTuJAghU=N_w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] of: add optional options parameter to of_find_node_by_path()
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ian Campbell <ijc@debian.org>, Andrew Lunn <andrew@lunn.ch>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 5:40 PM, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> Update of_find_node_by_path():
> 1) Ignore any part of the path beyond and including the ':' separator.
> 2) Set the new provided pointer argument to the beginning of the string
>    following the ':' separator.
>
> Coccinelle fixup using:
>
> @@
> expression E1;
> @@
>
> - of_find_node_by_path(E1)
> + of_find_node_by_path(E1, NULL)
>
> drivers/of/resolver.c manually updated, since spatch fails to parse
> it correctly.
>
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>

Okay, so you're probably going to kill me for the next comment...
After actually looking at this I can see that it's going to be a hard
patch to merge because of conflicts. It will need to be merged at the
end of a merge window to catch all the users, but that will mean that
the important part of the patch won't be able to be queued up in
linux-next.

So you were right the first time around. Create a new function name
that adds the extra argument and make of_find_node_by_path() a static
inline wrapper. That way I can queue it up into linux-next immediately
and the cleanup across the tree can be generated and submitted at the
very end of the merge window.

> @@ -380,7 +380,8 @@ static inline struct device_node *of_find_matching_node_and_match(
>         return NULL;
>  }
>
> -static inline struct device_node *of_find_node_by_path(const char *path)
> +static inline struct device_node *of_find_node_by_path(const char *path,
> +       char **opts)

const char **opts

>  {
>         return NULL;
>  }
> diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
> index e695517..0056963 100644
> --- a/sound/soc/fsl/fsl_ssi.c
> +++ b/sound/soc/fsl/fsl_ssi.c
> @@ -1427,7 +1427,7 @@ static int fsl_ssi_probe(struct platform_device *pdev)
>          * device tree.  We also pass the address of the CPU DAI driver
>          * structure.
>          */
> -       sprop = of_get_property(of_find_node_by_path("/"), "compatible", NULL);
> +       sprop = of_get_property(of_find_node_by_path("/", NULL), "compatible", NULL);
>         /* Sometimes the compatible name has a "fsl," prefix, so we strip it. */
>         p = strrchr(sprop, ',');
>         if (p)
> --
> 1.7.10.4
>
