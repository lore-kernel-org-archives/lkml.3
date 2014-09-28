Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaI1Axm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 20:53:42 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:56531 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaI1Axl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 20:53:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140803101707.GA8018@himangi-Dell>
References: <20140803101707.GA8018@himangi-Dell>
Date: Sat, 27 Sep 2014 17:53:41 -0700
Message-ID: <CAN8TOE9phK0ghUTm4b9Pj4R8h_CmGA8-GGi0zs84mkhx2nzgPQ@mail.gmail.com>
Subject: Re: [PATCH] mtd: fsl_ifc_nand: use devm_ functions consistently
From: Brian Norris <computersforpeace@gmail.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Prabhakar Kushwaha <prabhakar@freescale.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Aaron Sierra <asierra@xes-inc.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Joe Schultz <jschultz@xes-inc.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ linux-mtd

FYI, I addressed a similar patch over here:

http://lists.infradead.org/pipermail/linux-mtd/2014-September/055563.html

I'm pretty sure this patch is wrong, and the semantic match is
incorrect (or at least, it has false positives). Just because devm_*
is used in some part of the driver doesn't mean that all allocations
should be. Admittedly, this driver is not the best written (this patch
drew my attention to at least one bug), but I just wanted to let y'all
know.

Regards,
Brian

On Sun, Aug 3, 2014 at 3:17 AM, Himangi Saraogi <himangi774@gmail.com> wrote:
> Use devm_kzalloc for all calls to kzalloc and not just the first.  Use
> devm functions for other allocations as well. The calls to free the
> allocated memory in the remove function are done away with.
>
> The semantic match that finds the inconsistency is as follows:
>
> // <smpl>
> @@
> @@
>
> *devm_kzalloc(...)
> ...
> *kzalloc(...)
> // </smpl>
>
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
> Not compile tested.
>  drivers/mtd/nand/fsl_ifc_nand.c | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/mtd/nand/fsl_ifc_nand.c b/drivers/mtd/nand/fsl_ifc_nand.c
> index 2338124..b403a77 100644
> --- a/drivers/mtd/nand/fsl_ifc_nand.c
> +++ b/drivers/mtd/nand/fsl_ifc_nand.c
> @@ -995,11 +995,6 @@ static int fsl_ifc_chip_remove(struct fsl_ifc_mtd *priv)
>  {
>         nand_release(&priv->mtd);
>
> -       kfree(priv->mtd.name);
> -
> -       if (priv->vbase)
> -               iounmap(priv->vbase);
> -
>         ifc_nand_ctrl->chips[priv->bank] = NULL;
>
>         return 0;
> @@ -1062,7 +1057,8 @@ static int fsl_ifc_nand_probe(struct platform_device *dev)
>
>         mutex_lock(&fsl_ifc_nand_mutex);
>         if (!fsl_ifc_ctrl_dev->nand) {
> -               ifc_nand_ctrl = kzalloc(sizeof(*ifc_nand_ctrl), GFP_KERNEL);
> +               ifc_nand_ctrl = devm_kzalloc(&dev->dev, sizeof(*ifc_nand_ctrl),
> +                                            GFP_KERNEL);
>                 if (!ifc_nand_ctrl) {
>                         mutex_unlock(&fsl_ifc_nand_mutex);
>                         return -ENOMEM;
> @@ -1085,7 +1081,7 @@ static int fsl_ifc_nand_probe(struct platform_device *dev)
>         priv->ctrl = fsl_ifc_ctrl_dev;
>         priv->dev = &dev->dev;
>
> -       priv->vbase = ioremap(res.start, resource_size(&res));
> +       priv->vbase = devm_ioremap(&dev->dev, res.start, resource_size(&res));
>         if (!priv->vbase) {
>                 dev_err(priv->dev, "%s: failed to map chip region\n", __func__);
>                 ret = -ENOMEM;
> @@ -1104,7 +1100,8 @@ static int fsl_ifc_nand_probe(struct platform_device *dev)
>                     IFC_NAND_EVTER_INTR_FTOERIR_EN |
>                     IFC_NAND_EVTER_INTR_WPERIR_EN,
>                     &ifc->ifc_nand.nand_evter_intr_en);
> -       priv->mtd.name = kasprintf(GFP_KERNEL, "%llx.flash", (u64)res.start);
> +       priv->mtd.name = devm_kasprintf(&dev->dev, GFP_KERNEL, "%llx.flash",
> +                                       (u64)res.start);
>         if (!priv->mtd.name) {
>                 ret = -ENOMEM;
>                 goto err;
> @@ -1148,10 +1145,8 @@ static int fsl_ifc_nand_remove(struct platform_device *dev)
>
>         mutex_lock(&fsl_ifc_nand_mutex);
>         ifc_nand_ctrl->counter--;
> -       if (!ifc_nand_ctrl->counter) {
> +       if (!ifc_nand_ctrl->counter)
>                 fsl_ifc_ctrl_dev->nand = NULL;
> -               kfree(ifc_nand_ctrl);
> -       }
>         mutex_unlock(&fsl_ifc_nand_mutex);
>
>         return 0;
> --
> 1.9.1
>
