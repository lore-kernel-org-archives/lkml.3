Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaJGM1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:27:09 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29462 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaJGM1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:27:05 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-b0-5433dc16fab2
Message-id: <5433DC15.5000000@samsung.com>
Date: Tue, 07 Oct 2014 14:27:01 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Inki Dae <inki.dae@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        "open list:DRM DRIVERS FOR E..." <dri-devel@lists.freedesktop.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, drake@endlessm.com,
        daniel@ffwll.ch, m.szyprowski@samsung.com
Subject: Re: [PATCH] drm/exynos: init vblank with real number of crtcs
References: <1411131440-15395-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <1411131440-15395-1-git-send-email-a.hajda@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t/xK7pid4xDDDattbLoPXeSyeL/tonM
	Fo/mP2a2uPL1PZvFpPsTWCxe3LvIYtG74CqbxdmmN+wWl3fNYbOYcX4fk8XaI3fZLWZMfsnm
	wOOx6HuWx95vC1g8tn97wOpxv/s4k0ffllWMHp83yQWwRXHZpKTmZJalFunbJXBl/Dv/ka3g
	v2DF2sZTjA2M1/m6GDk5JARMJO5NuMICYYtJXLi3nq2LkYtDSGApo8TCa3tZIJxPjBJtzX1g
	VbwCWhLbGteD2SwCqhLHHl5iBLHZBDQl/m6+yQZiiwpESJy8u4cdol5Q4sfke2D1IgLKEqv2
	tYPFmQVOMUvcaFMBsYUF3CSmPH7BDGILCThLfP67E8zmFHCRWDrzFtB8DqB6PYn7F7UgWuUl
	Nq95yzyBUWAWkg2zEKpmIalawMi8ilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMkOr7uYFx6
	zOoQowAHoxIP7wot4xAh1sSy4srcQ4wSHMxKIrynLwKFeFMSK6tSi/Lji0pzUosPMTJxcEo1
	MK77weBsYvvVX5ih4b20s4/vw0O5//u7O+TT7e2VzCbGtf7csZm9s/+NR9/bQ9rB7BZ7uM3S
	bD0YGEUsOWZma0etZrkmZLb10qaAHLeXWtzHRa1XhizIb3b0VLon9sbd54q/sv+TWXc6v2XO
	mXD8+dkLjd3zvu7Qu2/5iY85rEvE3KhkWoGjEktxRqKhFnNRcSIA2QMKpGwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Inki,

Gently ping.

Andrzej


On 09/19/2014 02:57 PM, Andrzej Hajda wrote:
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
> 

