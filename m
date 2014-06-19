Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966481AbaFSX7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 19:59:46 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:41661 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965771AbaFSX7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 19:59:44 -0400
Date: Fri, 20 Jun 2014 02:59:38 +0300
From: Siarhei Siamashka <siarhei.siamashka@gmail.com>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Inki Dae <inki.dae@samsung.com>, dri-devel@lists.freedesktop.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] drm/exynos/fbdev: don't set
 fix.smem/mmio_{start,len}
Message-ID: <20140620025938.2e80efa0@i7>
In-Reply-To: <1396603322-13585-1-git-send-email-djkurtz@chromium.org>
References: <1396603322-13585-1-git-send-email-djkurtz@chromium.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  4 Apr 2014 17:22:01 +0800
Daniel Kurtz <djkurtz@chromium.org> wrote:

> Kernel access to the eyxnos fbdev framebuffer is via its gem object's
> kernel mapping (kvaddr, stored in info->screen_base).
> 
> User space access is provided by mmap(), read() and write() of /dev/fb/fb0.
> These functions also only use screen_base/screen_size().
> 
> Therefore, it is not necessary to set fix->smem_{start,len} or
> fix->mmio_{start,len} fields.
> 
> This avoids leaking kernel, physical and dma mapped addresses to user
> space via the ioctls FBIOGET_VSCREENINFO and FBIOGET_FSCREENINFO.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_fbdev.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c b/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
> index 5fa342e..2dcc589 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
> @@ -123,14 +123,7 @@ static int exynos_drm_fbdev_update(struct drm_fb_helper *helper,
>  
>  	dev->mode_config.fb_base = (resource_size_t)buffer->dma_addr;
>  	fbi->screen_base = buffer->kvaddr + offset;
> -	if (is_drm_iommu_supported(dev))
> -		fbi->fix.smem_start = (unsigned long)
> -			(page_to_phys(sg_page(buffer->sgt->sgl)) + offset);
> -	else
> -		fbi->fix.smem_start = (unsigned long)buffer->dma_addr;
> -
>  	fbi->screen_size = size;
> -	fbi->fix.smem_len = size;

Can we keep proper initialization of 'smem_len'? Some userland
applications use it for calculating the size for mmap:

    http://cgit.freedesktop.org/xorg/xserver/tree/hw/xfree86/fbdevhw/fbdevhw.c?id=xorg-server-1.15.99.903#n571

>  
>  	return 0;
>  }

Basically, this patch breaks the xf86-video-fbdev ddx and some users
are already unhappy.

-- 
Best regards,
Siarhei Siamashka
