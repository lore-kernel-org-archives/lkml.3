Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbaGHHlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 03:41:24 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45532 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbaGHHlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 03:41:21 -0400
MIME-Version: 1.0
In-Reply-To: <1403864931-4663-1-git-send-email-acourbot@nvidia.com>
References: <1403864931-4663-1-git-send-email-acourbot@nvidia.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 8 Jul 2014 16:41:00 +0900
Message-ID: <CAAVeFuLjPAu0Rfbx29dAKjo2bn2k049cQsue+67UwZu8edBEfg@mail.gmail.com>
Subject: Re: [PATCH 1/2] drm/nouveau/bar: add noncached ioremap property
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping Ben, how do these two patches look like?

On Fri, Jun 27, 2014 at 7:28 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Some BARs (like GK20A's) do not support being ioremapped write-combined.
> Add a boolean property to the BAR structure and handle that case in the
> Nouveau BO implementation.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpu/drm/nouveau/core/include/subdev/bar.h |  3 +++
>  drivers/gpu/drm/nouveau/nouveau_bo.c              | 17 ++++++++++++-----
>  2 files changed, 15 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/gpu/drm/nouveau/core/include/subdev/bar.h b/drivers/gpu/drm/nouveau/core/include/subdev/bar.h
> index 9faa98e67ad8..9002cbb6432b 100644
> --- a/drivers/gpu/drm/nouveau/core/include/subdev/bar.h
> +++ b/drivers/gpu/drm/nouveau/core/include/subdev/bar.h
> @@ -20,6 +20,9 @@ struct nouveau_bar {
>                     u32 flags, struct nouveau_vma *);
>         void (*unmap)(struct nouveau_bar *, struct nouveau_vma *);
>         void (*flush)(struct nouveau_bar *);
> +
> +       /* whether the BAR supports to be ioremapped WC or should be uncached */
> +       bool iomap_uncached;
>  };
>
>  static inline struct nouveau_bar *
> diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
> index b6dc85c614be..4db886f9f793 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_bo.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
> @@ -500,18 +500,25 @@ nouveau_bo_init_mem_type(struct ttm_bo_device *bdev, uint32_t type,
>                 man->default_caching = TTM_PL_FLAG_CACHED;
>                 break;
>         case TTM_PL_VRAM:
> +               man->flags = TTM_MEMTYPE_FLAG_FIXED |
> +                            TTM_MEMTYPE_FLAG_MAPPABLE;
> +               man->available_caching = TTM_PL_FLAG_UNCACHED |
> +                                        TTM_PL_FLAG_WC;
> +               man->default_caching = TTM_PL_FLAG_WC;
> +
>                 if (nv_device(drm->device)->card_type >= NV_50) {
> +                       /* Some BARs do not support being ioremapped WC */
> +                       if (nouveau_bar(drm->device)->iomap_uncached) {
> +                               man->available_caching = TTM_PL_FLAG_UNCACHED;
> +                               man->default_caching = TTM_PL_FLAG_UNCACHED;
> +                       }
> +
>                         man->func = &nouveau_vram_manager;
>                         man->io_reserve_fastpath = false;
>                         man->use_io_reserve_lru = true;
>                 } else {
>                         man->func = &ttm_bo_manager_func;
>                 }
> -               man->flags = TTM_MEMTYPE_FLAG_FIXED |
> -                            TTM_MEMTYPE_FLAG_MAPPABLE;
> -               man->available_caching = TTM_PL_FLAG_UNCACHED |
> -                                        TTM_PL_FLAG_WC;
> -               man->default_caching = TTM_PL_FLAG_WC;
>                 break;
>         case TTM_PL_TT:
>                 if (nv_device(drm->device)->card_type >= NV_50)
> --
> 2.0.0
>
