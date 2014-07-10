Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbaGJNEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:04:43 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38413 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbaGJNEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:04:40 -0400
Date: Thu, 10 Jul 2014 15:04:49 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        David Herrmann <dh.herrmann@gmail.com>, Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Subject: Re: [Nouveau] [PATCH v4 4/6] drm/nouveau: synchronize BOs when
 required
Message-ID: <20140710130449.GG17271@phenom.ffwll.local>
Mail-Followup-To: Alexandre Courbot <acourbot@nvidia.com>,
	Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
	David Herrmann <dh.herrmann@gmail.com>,
	Lucas Stach <dev@lynxeye.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
References: <1404807961-30530-1-git-send-email-acourbot@nvidia.com>
 <1404807961-30530-5-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404807961-30530-5-git-send-email-acourbot@nvidia.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 05:25:59PM +0900, Alexandre Courbot wrote:
> On architectures for which access to GPU memory is non-coherent,
> caches need to be flushed and invalidated explicitly when BO control
> changes between CPU and GPU.
> 
> This patch adds buffer synchronization functions which invokes the
> correct API (PCI or DMA) to ensure synchronization is effective.
> 
> Based on the TTM DMA cache helper patches by Lucas Stach.
> 
> Signed-off-by: Lucas Stach <dev@lynxeye.de>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpu/drm/nouveau/nouveau_bo.c  | 56 +++++++++++++++++++++++++++++++++++
>  drivers/gpu/drm/nouveau/nouveau_bo.h  |  2 ++
>  drivers/gpu/drm/nouveau/nouveau_gem.c | 12 ++++++++
>  3 files changed, 70 insertions(+)
> 
> diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
> index 67e9e8e2e2ec..47e4e8886769 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_bo.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
> @@ -402,6 +402,60 @@ nouveau_bo_unmap(struct nouveau_bo *nvbo)
>  		ttm_bo_kunmap(&nvbo->kmap);
>  }
>  
> +void
> +nouveau_bo_sync_for_device(struct nouveau_bo *nvbo)
> +{
> +	struct nouveau_drm *drm = nouveau_bdev(nvbo->bo.bdev);
> +	struct nouveau_device *device = nouveau_dev(drm->dev);
> +	struct ttm_dma_tt *ttm_dma = (struct ttm_dma_tt *)nvbo->bo.ttm;
> +	int i;
> +
> +	if (!ttm_dma)
> +		return;
> +
> +	if (nv_device_is_cpu_coherent(device) || nvbo->force_coherent)
> +		return;

Is the is_cpu_coherent check really required? On coherent platforms the
sync_for_foo should be a noop. It's the dma api's job to encapsulate this
knowledge so that drivers can be blissfully ignorant. The explicit
is_coherent check makes this a bit leaky. And same comment that underlying
the bus-specifics dma-mapping functions are identical.
-Daniel

> +
> +	if (nv_device_is_pci(device)) {
> +		for (i = 0; i < ttm_dma->ttm.num_pages; i++)
> +			pci_dma_sync_single_for_device(device->pdev,
> +				ttm_dma->dma_address[i], PAGE_SIZE,
> +				PCI_DMA_TODEVICE);
> +	} else {
> +		for (i = 0; i < ttm_dma->ttm.num_pages; i++)
> +			dma_sync_single_for_device(nv_device_base(device),
> +				ttm_dma->dma_address[i], PAGE_SIZE,
> +				DMA_TO_DEVICE);
> +	}
> +}
> +
> +void
> +nouveau_bo_sync_for_cpu(struct nouveau_bo *nvbo)
> +{
> +	struct nouveau_drm *drm = nouveau_bdev(nvbo->bo.bdev);
> +	struct nouveau_device *device = nouveau_dev(drm->dev);
> +	struct ttm_dma_tt *ttm_dma = (struct ttm_dma_tt *)nvbo->bo.ttm;
> +	int i;
> +
> +	if (!ttm_dma)
> +		return;
> +
> +	if (nv_device_is_cpu_coherent(device) || nvbo->force_coherent)
> +		return;
> +
> +	if (nv_device_is_pci(device)) {
> +		for (i = 0; i < ttm_dma->ttm.num_pages; i++)
> +			pci_dma_sync_single_for_cpu(device->pdev,
> +				ttm_dma->dma_address[i], PAGE_SIZE,
> +				PCI_DMA_FROMDEVICE);
> +	} else {
> +		for (i = 0; i < ttm_dma->ttm.num_pages; i++)
> +			dma_sync_single_for_cpu(nv_device_base(device),
> +				ttm_dma->dma_address[i], PAGE_SIZE,
> +				DMA_FROM_DEVICE);
> +	}
> +}
> +
>  int
>  nouveau_bo_validate(struct nouveau_bo *nvbo, bool interruptible,
>  		    bool no_wait_gpu)
> @@ -418,6 +472,8 @@ nouveau_bo_validate(struct nouveau_bo *nvbo, bool interruptible,
>  	if (!ttm)
>  		return ret;
>  
> +	nouveau_bo_sync_for_device(nvbo);
> +
>  	device = nouveau_dev(nouveau_bdev(ttm->bdev)->dev);
>  	nv_wr32(device, 0x70004, 0x00000001);
>  	if (!nv_wait(device, 0x070004, 0x00000001, 0x00000000))
> diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.h b/drivers/gpu/drm/nouveau/nouveau_bo.h
> index ff17c1f432fc..fa42298d2dca 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_bo.h
> +++ b/drivers/gpu/drm/nouveau/nouveau_bo.h
> @@ -81,6 +81,8 @@ void nouveau_bo_wr32(struct nouveau_bo *, unsigned index, u32 val);
>  void nouveau_bo_fence(struct nouveau_bo *, struct nouveau_fence *);
>  int  nouveau_bo_validate(struct nouveau_bo *, bool interruptible,
>  			 bool no_wait_gpu);
> +void nouveau_bo_sync_for_device(struct nouveau_bo *nvbo);
> +void nouveau_bo_sync_for_cpu(struct nouveau_bo *nvbo);
>  
>  struct nouveau_vma *
>  nouveau_bo_vma_find(struct nouveau_bo *, struct nouveau_vm *);
> diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
> index c90c0dc0afe8..08829a720891 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_gem.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
> @@ -896,6 +896,7 @@ nouveau_gem_ioctl_cpu_prep(struct drm_device *dev, void *data,
>  	spin_lock(&nvbo->bo.bdev->fence_lock);
>  	ret = ttm_bo_wait(&nvbo->bo, true, true, no_wait);
>  	spin_unlock(&nvbo->bo.bdev->fence_lock);
> +	nouveau_bo_sync_for_cpu(nvbo);
>  	drm_gem_object_unreference_unlocked(gem);
>  	return ret;
>  }
> @@ -904,6 +905,17 @@ int
>  nouveau_gem_ioctl_cpu_fini(struct drm_device *dev, void *data,
>  			   struct drm_file *file_priv)
>  {
> +	struct drm_nouveau_gem_cpu_fini *req = data;
> +	struct drm_gem_object *gem;
> +	struct nouveau_bo *nvbo;
> +
> +	gem = drm_gem_object_lookup(dev, file_priv, req->handle);
> +	if (!gem)
> +		return -ENOENT;
> +	nvbo = nouveau_gem_object(gem);
> +
> +	nouveau_bo_sync_for_device(nvbo);
> +	drm_gem_object_unreference_unlocked(gem);
>  	return 0;
>  }
>  
> -- 
> 2.0.0
> 
> _______________________________________________
> Nouveau mailing list
> Nouveau@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/nouveau

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
