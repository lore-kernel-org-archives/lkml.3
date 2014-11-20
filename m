Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbaKTOo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 09:44:56 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:42202 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062AbaKTOoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:44:54 -0500
MIME-Version: 1.0
In-Reply-To: <20141120145016.19160b8b@canb.auug.org.au>
References: <20141120145016.19160b8b@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 20 Nov 2014 14:44:33 +0000
X-Google-Sender-Auth: VmxxICHEyukeOZ88UWZI46JKn10
Message-ID: <CACxGe6vdoD6w4LH1wkJODoaRd4tRk75NiVMGTQ3tU_CvRWcidA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the devicetree tree with the
 devicetree-current tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Stephen,

Yes, that looks right, but I'm going to drop the patch from my tree.
It isn't a critical fix. The failure it solves is not a serious or
dangerous.

Thanks,
g.

On Thu, Nov 20, 2014 at 3:50 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> Today's linux-next merge of the devicetree tree got a conflict in
> drivers/of/unittest.c between commit 817d2001c709 ("of/selftest: Fix
> testing when /aliases is missing") from the devicetree-current tree and
> commit 5063e25a302e ("of: Eliminate of_allnodes list") from the
> devicetree tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc drivers/of/unittest.c
> index ae8b75904104,082bb2b6a5ad..000000000000
> --- a/drivers/of/unittest.c
> +++ b/drivers/of/unittest.c
> @@@ -853,19 -858,20 +858,23 @@@ static int __init selftest_data_add(voi
>
>                 for_each_of_allnodes(np)
>                         __of_attach_node_sysfs(np);
>  -              of_aliases = of_find_node_by_path("/aliases");
>  -              of_chosen = of_find_node_by_path("/chosen");
>  -              return 0;
>  +      } else {
>  +              /* attach the sub-tree to live tree */
> -               rc = attach_node_and_children(selftest_data_node);
> -               if (WARN_ON(rc))
> -                       return rc;
> ++              np = selftest_data_node->child;
> ++              while (np) {
> ++                      struct device_node *next = np->sibling;
> ++                      np->parent = of_root;
> ++                      attach_node_and_children(np);
> ++                      np = next;
> ++              }
>         }
>
>  -      /* attach the sub-tree to live tree */
>  -      np = selftest_data_node->child;
>  -      while (np) {
>  -              struct device_node *next = np->sibling;
>  -              np->parent = of_root;
>  -              attach_node_and_children(np);
>  -              np = next;
>  -      }
>  +      /* Make sure of_aliases and of_chosen are up-to-date */
>  +      if (!of_aliases)
>  +              of_aliases = of_find_node_by_path("/aliases");
>  +      if (!of_chosen)
>  +              of_chosen = of_find_node_by_path("/chosen");
> -       return rc;
> +       return 0;
>   }
>
>   /**
