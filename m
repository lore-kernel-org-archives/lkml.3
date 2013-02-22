Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab3BVFJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 00:09:24 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:35043 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab3BVFJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 00:09:20 -0500
MIME-Version: 1.0
In-Reply-To: <20130222151746.2eff5346595ba60910df867e@canb.auug.org.au>
References: <20130222151746.2eff5346595ba60910df867e@canb.auug.org.au>
Date: Fri, 22 Feb 2013 00:09:20 -0500
Message-ID: <CAF6AEGsHju8uku6VkuX+8OQe2Hv4hwtnxQROpXxpf+bH1XvBEQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (drm tree related)
From: Rob Clark <robdclark@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dave Airlie <airlied@linux.ie>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, maybe DRM_GEM_CMA_HELPER should depend on ARM (or !PPC)?  Or
maybe there is an alternative fxn to use on other archs?

In truth, it is fine to make TILCDC depend on ARM, as it wouldn't be
used on any other platform (today.. until TI comes up with some crazy
chip w/ some TI DSP plus display controller), although that doesn't
quite feel like the right fix.  It would be nice to make the CMA
helpers do the right thing on other archs somehow.

BR,
-R

On Thu, Feb 21, 2013 at 11:17 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>
> drivers/gpu/drm/drm_gem_cma_helper.c: In function 'drm_gem_cma_buf_destroy':
> drivers/gpu/drm/drm_gem_cma_helper.c:38:2: error: implicit declaration of function 'dma_free_writecombine' [-Werror=implicit-function-declaration]
> drivers/gpu/drm/drm_gem_cma_helper.c: In function 'drm_gem_cma_create':
> drivers/gpu/drm/drm_gem_cma_helper.c:61:2: error: implicit declaration of function 'dma_alloc_writecombine' [-Werror=implicit-function-declaration]
>
> Probably caused by commit 16ea975eac67 ("drm/tilcdc: add TI LCD
> Controller DRM driver (v4)") which forced CONFIG_DRM_GEM_CMA_HELPER to
> 'y'.  dma_alloc/free_writecombine are only defined on ARM.
>
> I added this patch for today.
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 22 Feb 2013 15:14:50 +1100
> Subject: [PATCH] drm/tilcdc: only build on arm
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/gpu/drm/tilcdc/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/tilcdc/Kconfig b/drivers/gpu/drm/tilcdc/Kconfig
> index ae14fd6..d24d040 100644
> --- a/drivers/gpu/drm/tilcdc/Kconfig
> +++ b/drivers/gpu/drm/tilcdc/Kconfig
> @@ -1,6 +1,6 @@
>  config DRM_TILCDC
>         tristate "DRM Support for TI LCDC Display Controller"
> -       depends on DRM && OF
> +       depends on DRM && OF && ARM
>         select DRM_KMS_HELPER
>         select DRM_KMS_CMA_HELPER
>         select DRM_GEM_CMA_HELPER
> --
> 1.8.1
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
