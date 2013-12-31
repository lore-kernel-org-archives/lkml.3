Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab3LaLam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 06:30:42 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:47311 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab3LaLak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 06:30:40 -0500
MIME-Version: 1.0
In-Reply-To: <1388357260-4843-5-git-send-email-Julia.Lawall@lip6.fr>
References: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
	<1388357260-4843-5-git-send-email-Julia.Lawall@lip6.fr>
Date: Tue, 31 Dec 2013 12:30:39 +0100
Message-ID: <CAFLxGvx+JrErEM1z=_86DVcGeufFR2jgLhNMYoUJ5i2dZLYmxQ@mail.gmail.com>
Subject: Re: [PATCH 4/25] UBI: fix error return code
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, kernel-janitors@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 29, 2013 at 11:47 PM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Set the return variable to an error code as done elsewhere in the function.
>
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
>
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Reviewed-by: Richard Weinberger <richard@nod.at>

> ---
> Not tested.
>
>  drivers/mtd/ubi/attach.c |    4 +++-
>  drivers/mtd/ubi/build.c  |    4 +++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
> index 33bb1f2..6f27d9a 100644
> --- a/drivers/mtd/ubi/attach.c
> +++ b/drivers/mtd/ubi/attach.c
> @@ -1453,8 +1453,10 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
>                 struct ubi_attach_info *scan_ai;
>
>                 scan_ai = alloc_ai("ubi_ckh_aeb_slab_cache");
> -               if (!scan_ai)
> +               if (!scan_ai) {
> +                       err = -ENOMEM;
>                         goto out_wl;
> +               }
>
>                 err = scan_all(ubi, scan_ai, 0);
>                 if (err) {
> diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
> index e05dc62..57deae9 100644
> --- a/drivers/mtd/ubi/build.c
> +++ b/drivers/mtd/ubi/build.c
> @@ -1245,8 +1245,10 @@ static int __init ubi_init(void)
>         ubi_wl_entry_slab = kmem_cache_create("ubi_wl_entry_slab",
>                                               sizeof(struct ubi_wl_entry),
>                                               0, 0, NULL);
> -       if (!ubi_wl_entry_slab)
> +       if (!ubi_wl_entry_slab) {
> +               err = -ENOMEM;
>                 goto out_dev_unreg;
> +       }
>
>         err = ubi_debugfs_init();
>         if (err)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
