Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab3ENMwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 08:52:35 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:59896 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756770Ab3ENMwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 08:52:32 -0400
MIME-Version: 1.0
In-Reply-To: <1368370791-32630-1-git-send-email-laurent.navet@gmail.com>
References: <1368370791-32630-1-git-send-email-laurent.navet@gmail.com>
Date: Tue, 14 May 2013 14:52:31 +0200
Message-ID: <CACRpkdbbDzudp_W0d1VW1NCMUTHA25v2N3rXopQ+_zGrQB9AyQ@mail.gmail.com>
Subject: Re: [PATCH] drivers: pinctrl: vt8500: use devm_ioremap_resource()
From: Linus Walleij <linus.walleij@linaro.org>
To: Laurent Navet <laurent.navet@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Tony Prisk <linux@prisktech.co.nz>, Stephen Warren <swarren@nvidia.com>,
        Olof Johansson <olof@lixom.net>, Axel Lin <axel.lin@ingics.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 4:59 PM, Laurent Navet <laurent.navet@gmail.com> wrote:

> Replace a call to deprecated devm_request_and_ioremap by devm_ioremap_resource.

Oh is that deprecated? I had no clue :-/
Can you point to some rationale about this so I'm not
totally misguided in my world..?

> Found with coccicheck and this semantic patch:
>  scripts/coccinelle/api/devm_ioremap_resource.cocci
>
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>

Seems OK if the deprecation is ongoing.
Tony can I have your ACK?

>  drivers/pinctrl/vt8500/pinctrl-wmt.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/pinctrl/vt8500/pinctrl-wmt.c b/drivers/pinctrl/vt8500/pinctrl-wmt.c
> index ab63104..e877082 100644
> --- a/drivers/pinctrl/vt8500/pinctrl-wmt.c
> +++ b/drivers/pinctrl/vt8500/pinctrl-wmt.c
> @@ -569,10 +569,10 @@ int wmt_pinctrl_probe(struct platform_device *pdev,
>         struct resource *res;
>
>         res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -       data->base = devm_request_and_ioremap(&pdev->dev, res);
> -       if (!data->base) {
> +       data->base = devm_ioremap_resource(&pdev->dev, res);
> +       if (IS_ERR(data->base)) {
>                 dev_err(&pdev->dev, "failed to map memory resource\n");
> -               return -EBUSY;
> +               return PTR_ERR(data->base);
>         }

Grant is just going to *not* love this type of patches replacing
nullchecks with IS_ERR() stuff all over the kernel.

We had a discussion whether the compiler can be made to
annotate and typecheck pointers to avoid doing mistakes with
pointers containing error codes like this. (Vague but you maybe
know what I'm after.)

Yours,
Linus Walleij
