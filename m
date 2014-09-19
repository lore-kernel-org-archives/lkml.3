Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbaISPb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:31:26 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:64659 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301AbaISPaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:30:55 -0400
Date: Fri, 19 Sep 2014 17:31:21 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Inki Dae <inki.dae@samsung.com>, Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        "open list:DRM DRIVERS FOR E..." <dri-devel@lists.freedesktop.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, drake@endlessm.com,
        daniel@ffwll.ch, m.szyprowski@samsung.com
Subject: Re: [PATCH] drm/exynos: init vblank with real number of crtcs
Message-ID: <20140919153121.GC15734@phenom.ffwll.local>
Mail-Followup-To: Andrzej Hajda <a.hajda@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Joonyoung Shim <jy0922.shim@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
	"open list:DRM DRIVERS FOR E..." <dri-devel@lists.freedesktop.org>,
	"moderated list:ARM/S5P EXYNOS AR..." <linux-samsung-soc@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>, drake@endlessm.com,
	m.szyprowski@samsung.com
References: <1411131440-15395-1-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411131440-15395-1-git-send-email-a.hajda@samsung.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 02:57:20PM +0200, Andrzej Hajda wrote:
> Initialization of vblank with MAX_CRTC caused attempts
> to disabling vblanks for non-existing crtcs in case
> drm used fewer crtcs. The patch fixes it.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_drv.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
> index 9b00e4e..dc4affd 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
> @@ -94,10 +94,6 @@ static int exynos_drm_load(struct drm_device *dev, unsigned long flags)
>  	/* init kms poll for handling hpd */
>  	drm_kms_helper_poll_init(dev);
>  
> -	ret = drm_vblank_init(dev, MAX_CRTC);
> -	if (ret)
> -		goto err_mode_config_cleanup;
> -
>  	/* setup possible_clones. */
>  	exynos_drm_encoder_setup(dev);
>  
> @@ -106,22 +102,26 @@ static int exynos_drm_load(struct drm_device *dev, unsigned long flags)
>  	/* Try to bind all sub drivers. */
>  	ret = component_bind_all(dev->dev, dev);
>  	if (ret)
> -		goto err_cleanup_vblank;
> +		goto err_mode_config_cleanup;
> +
> +	ret = drm_vblank_init(dev, dev->mode_config.num_crtc);

Hm, I wonder whether we should have a drm_mode_vblank_init which dtrt here
for kms drivers? Suggestions for a better name welcome ;-)
-Daniel

> +	if (ret)
> +		goto err_unbind_all;
>  
>  	/* Probe non kms sub drivers and virtual display driver. */
>  	ret = exynos_drm_device_subdrv_probe(dev);
>  	if (ret)
> -		goto err_unbind_all;
> +		goto err_cleanup_vblank;
>  
>  	/* force connectors detection */
>  	drm_helper_hpd_irq_event(dev);
>  
>  	return 0;
>  
> -err_unbind_all:
> -	component_unbind_all(dev->dev, dev);
>  err_cleanup_vblank:
>  	drm_vblank_cleanup(dev);
> +err_unbind_all:
> +	component_unbind_all(dev->dev, dev);
>  err_mode_config_cleanup:
>  	drm_mode_config_cleanup(dev);
>  	drm_release_iommu_mapping(dev);
> @@ -138,8 +138,8 @@ static int exynos_drm_unload(struct drm_device *dev)
>  	exynos_drm_fbdev_fini(dev);
>  	drm_kms_helper_poll_fini(dev);
>  
> -	component_unbind_all(dev->dev, dev);
>  	drm_vblank_cleanup(dev);
> +	component_unbind_all(dev->dev, dev);
>  	drm_mode_config_cleanup(dev);
>  	drm_release_iommu_mapping(dev);
>  
> -- 
> 1.9.1
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
