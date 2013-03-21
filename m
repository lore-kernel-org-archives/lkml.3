Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab3CUA4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 20:56:54 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8309 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab3CUA4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 20:56:52 -0400
X-IronPort-AV: E=Sophos;i="4.84,881,1355126400"; 
   d="scan'208";a="31389948"
Message-ID: <514A5AD3.3010605@codeaurora.org>
Date: Wed, 20 Mar 2013 17:56:51 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Rohit Vaswani <rvaswani@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [Please Ignore] Re: [PATCH] Changes to resolve the multiple client
 issue: by Michael Street
References: <1363826498-7254-1-git-send-email-rvaswani@codeaurora.org>
In-Reply-To: <1363826498-7254-1-git-send-email-rvaswani@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please Ignore.

On 3/20/2013 5:41 PM, Rohit Vaswani wrote:
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
>   src/msm-dri2.c |   21 +++++++++++++++++++--
>   src/msm-drm.c  |   39 ++++++++++++++++++++++++++++++---------
>   src/msm-drm.h  |    1 +
>   3 files changed, 50 insertions(+), 11 deletions(-)
>
> diff --git a/src/msm-dri2.c b/src/msm-dri2.c
> index e5bdf8a..7eadc48 100644
> --- a/src/msm-dri2.c
> +++ b/src/msm-dri2.c
> @@ -131,9 +131,10 @@ DoFlipMDP4(ScreenPtr pScreen, PixmapPtr pPixmap,
>   {
>       struct mdp_overlay overlay;
>       struct msmfb_overlay_data play;
> +    struct drm_kgsl_gem_get_ion_fd ionfdioctl;
>       ScrnInfoPtr pScrn = xf86Screens[pScreen->myNum];
>       MSMPtr pMsm = MSMPTR(pScrn);
> -    int ret;
> +    int ret = 0;
>       struct msm_pixmap_priv *pixpriv;
>   
>   
> @@ -190,9 +191,21 @@ DoFlipMDP4(ScreenPtr pScreen, PixmapPtr pPixmap,
>       }
>   
>       pixpriv = exaGetPixmapDriverPrivate(pPixmap);
> +    ionfdioctl.ion_fd = 0;
> +    if(pixpriv->bo->ion_fd == 0) {
> +	    ionfdioctl.handle = pixpriv->bo->handle;
> +	    ret = ioctl(pixpriv->bo->fd, DRM_IOCTL_KGSL_GEM_GET_ION_FD, &ionfdioctl);
> +	    if (ret < 0) {
> +	        ErrorF("DRM: DRM_IOCTL_KGSL_GEM_GET_ION_FD failed: %m\n");
> +	        return ret;
> +	    }
> +        play.data.memory_id =  ionfdioctl.ion_fd;
> +    }
> +    else {
> +        play.data.memory_id = pixpriv->bo->ion_fd;
> +    }
>       play.id = fbOverlay;
>       play.data.offset = pixpriv->bo->offsets[pixpriv->bo->active];
> -    play.data.memory_id = pixpriv->bo->ion_fd;
>       play.data.priv = 0;
>       play.data.flags = 0;
>   
> @@ -206,6 +219,10 @@ DoFlipMDP4(ScreenPtr pScreen, PixmapPtr pPixmap,
>       if (ret < 0)
>           ErrorF("FBIOPAN_DISPLAY failed line %d error %d\n",__LINE__,errno);
>   
> +    if(ionfdioctl.ion_fd != 0) {
> +	    close(ionfdioctl.ion_fd);
> +    }
> +
>       return ret == 0 ? TRUE : FALSE;
>   }
>   #endif
> diff --git a/src/msm-drm.c b/src/msm-drm.c
> index 1e13d4a..3603cbd 100644
> --- a/src/msm-drm.c
> +++ b/src/msm-drm.c
> @@ -218,6 +218,7 @@ msm_drm_bo_create(MSMPtr pMsm, int fd, int size, int type)
>       bo->fd = fd;
>       bo->active = 0;
>       bo->count = 1;
> +    bo->allocated = 0;
>   
>       /* All memory defaults to KMEM */
>       bo->memtype = DRM_KGSL_GEM_TYPE_KMEM;
> @@ -260,20 +261,21 @@ int
>   msm_drm_bo_alloc(struct msm_drm_bo *bo)
>   {
>       struct drm_kgsl_gem_alloc alloc;
> -    struct drm_kgsl_gem_get_ion_fd ionfdioctl;
> +    //struct drm_kgsl_gem_get_ion_fd ionfdioctl;
>       int ret;
>   
>       if (bo == NULL)
>   	return -1;
>   
>       /* If the offset is set, then assume it has been allocated */
> -    if (bo->ion_fd != 0)
> +    if (bo->allocated != 0)
>   	return 0;
>   
>       memset(&alloc, 0, sizeof(alloc));
>       alloc.handle = bo->handle;
>   
>       ret = ioctl(bo->fd, DRM_IOCTL_KGSL_GEM_ALLOC, &alloc);
> +    bo->allocated = 1;
>   
>       if (ret) {
>   	/* if the ioctl isn't supported, then use the legacy PREP ioctl */
> @@ -299,13 +301,13 @@ msm_drm_bo_alloc(struct msm_drm_bo *bo)
>   	return ret;
>       }
>   
> -    ionfdioctl.handle = bo->handle;
> -    ret = ioctl(bo->fd, DRM_IOCTL_KGSL_GEM_GET_ION_FD, &ionfdioctl);
> -    if (ret < 0) {
> -        ErrorF("DRM: DRM_IOCTL_KGSL_GEM_GET_ION_FD failed: %m\n");
> -        return ret;
> -    }
> -    bo->ion_fd = ionfdioctl.ion_fd;
> +//    ionfdioctl.handle = bo->handle;
> +//    ret = ioctl(bo->fd, DRM_IOCTL_KGSL_GEM_GET_ION_FD, &ionfdioctl);
> +//    if (ret < 0) {
> +//        ErrorF("DRM: DRM_IOCTL_KGSL_GEM_GET_ION_FD failed: %m\n");
> +//        return ret;
> +//    }
> +//    bo->ion_fd = ionfdioctl.ion_fd;
>   
>       bo->offset = alloc.offset;
>       return 0;
> @@ -356,6 +358,7 @@ msm_drm_bo_map(struct msm_drm_bo *bo)
>   {
>       int ret, i;
>       unsigned int mapsize;
> +    struct drm_kgsl_gem_get_ion_fd ionfdioctl;
>   
>       if (bo == NULL)
>   	return -1;
> @@ -401,8 +404,22 @@ msm_drm_bo_map(struct msm_drm_bo *bo)
>   
>       if (ret == 0)
>       {
> +        ionfdioctl.handle = bo->handle;
> +	if(bo->ion_fd == 0)
> +	{
> +        	ret = ioctl(bo->fd, DRM_IOCTL_KGSL_GEM_GET_ION_FD, &ionfdioctl);
> +        	if (ret < 0) {
> +            	ErrorF("DRM: DRM_IOCTL_KGSL_GEM_GET_ION_FD failed: %m\n");
> +            	return ret;
> +        	}
> +        	bo->ion_fd = ionfdioctl.ion_fd;
> +	}
> +	else ErrorF("DRM: ion_fd %d already allocated\n", bo->ion_fd);
> +
>           bo->hostptr = mmap(0, mapsize, PROT_READ | PROT_WRITE, MAP_SHARED,
>                              bo->ion_fd, 0);
> +	close(bo->ion_fd);
> +	bo->ion_fd = 0;
>       }
>       else
>       {
> @@ -434,6 +451,8 @@ msm_drm_bo_unmap(struct msm_drm_bo *bo)
>   	munmap((void *) bo->hostptr, bo->size);
>   
>       bo->hostptr = 0;
> +    close(bo->ion_fd);
> +    bo->ion_fd = 0;
>   #endif
>   }
>   
> @@ -452,6 +471,8 @@ msm_drm_bo_free(MSMPtr pMsm, struct msm_drm_bo *bo)
>   	}
>   	else
>   		_msm_drm_bo_free(bo);
> +
> +	bo->allocated = 0;
>   }
>   
>   /* Set the next buffer in the list as active */
> diff --git a/src/msm-drm.h b/src/msm-drm.h
> index 55d071d..1eaf8e4 100644
> --- a/src/msm-drm.h
> +++ b/src/msm-drm.h
> @@ -53,6 +53,7 @@ struct msm_drm_bo {
>       int ref;
>       int active;
>       unsigned long long offset;
> +    int allocated;
>   };
>   
>   int msm_drm_init(int fd);


Thanks,
Rohit Vaswani

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, hosted by The Linux Foundation

