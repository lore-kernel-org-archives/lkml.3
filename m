Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab3GKG5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 02:57:39 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:63493 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab3GKG5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 02:57:35 -0400
Date: Thu, 11 Jul 2013 08:57:36 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Airlie <airlied@redhat.com>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH 2/2] DRM: use anon_inode instead of delayed inode init
Message-ID: <20130711065735.GO6143@phenom.ffwll.local>
Mail-Followup-To: David Herrmann <dh.herrmann@gmail.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Dave Airlie <airlied@redhat.com>, linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <1373499930-5055-1-git-send-email-dh.herrmann@gmail.com>
 <1373499930-5055-3-git-send-email-dh.herrmann@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373499930-5055-3-git-send-email-dh.herrmann@gmail.com>
X-Operating-System: Linux phenom 3.10.0-rc7+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 01:45:30AM +0200, David Herrmann wrote:
> Instead of delaying inode initialization until first ->open(), we can use
> an anonymous inode. This avoids modifying FS internal inode fields and
> provides us a private address_space right during initialization.
> 
> Delayed TTM dev_mapping initialization is currently left untouched to keep
> this simple. But we could now safely provide the address_space during
> ttm_bo_device_init() instead of delaying until first buffer ->mmap().
> 
> Note that this also fixes several bugs:
>  - We currently call iput(container_of(..dev_mapping..)) before
>    drm_lastclose(), but we reset dev_mapping to zero at the end of
>    drm_lastclose(). This fails if dev_mapping points to an address_space
>    other than the current inode and the char-dev got already removed.
>  - We also drop dev_mapping during any drm_lastclose() call. So if
>    user-space still has VMAs to our buffers, we will be unable to unmap
>    them if the next ->firstopen() is on another inode. dev_mapping will
>    then point to a new address_space and we leak mappings that we no
>    longer control.

It's certainly ugly, but I don't think we have a real problem here. vma
grabs a reference to the open file at mmap time and we grab a reference to
the underlying gem object. So it shouldn't be possible to observe a
non-NULL dev_mapping while the inode refcount has already reached 0
anywhere we actually care. At least in drm/i915 since we never call
unmap_mapping_range if we know that there's no ptes around pointing at
this specific object (which we accurately keep track of in our fault
handler).

TTM might be different, and it's certainly good to rid us of this code.

>  - We ignore inode->i_mapping completely. It is unlikely that a FS uses it
>    to overwrite inode->i_data for char-devs, but it definitely doesn't
>    look very nice to ignore it silently.

Tbh I have no idea what the rules are here ... But since core vfs code
uses the filp->f_mapping at mmap time not frobbing inode->i_mapping looks
like the sane to do.

> Regarding legacy drivers: We no longer reset the address_space during
> drm_lastclose() to avoid re-allocating inodes all the time. However,
> legacy UMS drivers are weird and it is not clear to me whether some of the
> old drivers might depend on this (for what reason?), but I remember Daniel
> told me that i810 might.

i915 in gem+ums mode might. i810 is a different level of horror show
entirely, but since it doesn't do gem we can ignore it here.

> 
> Tested with nouveau on x86_64.
> 
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

I guess it makes sense to merge that after your drm vma offset manager
changes with the little pte shootdown helper since that'll reduce the
diff?
-Daniel

> ---
>  drivers/gpu/drm/drm_drv.c              |  1 -
>  drivers/gpu/drm/drm_fops.c             | 24 +++---------------------
>  drivers/gpu/drm/drm_stub.c             | 12 +++++++++++-
>  drivers/gpu/drm/i915/i915_gem.c        |  4 ++--
>  drivers/gpu/drm/nouveau/nouveau_gem.c  |  2 +-
>  drivers/gpu/drm/omapdrm/omap_gem.c     |  7 ++++---
>  drivers/gpu/drm/qxl/qxl_object.c       |  2 +-
>  drivers/gpu/drm/qxl/qxl_ttm.c          |  2 +-
>  drivers/gpu/drm/radeon/radeon_object.c |  2 +-
>  drivers/gpu/drm/radeon/radeon_ttm.c    |  2 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_drv.c    |  2 +-
>  include/drm/drmP.h                     |  2 +-
>  12 files changed, 27 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
> index 99fcd7c..9797613 100644
> --- a/drivers/gpu/drm/drm_drv.c
> +++ b/drivers/gpu/drm/drm_drv.c
> @@ -232,7 +232,6 @@ int drm_lastclose(struct drm_device * dev)
>  	    !drm_core_check_feature(dev, DRIVER_MODESET))
>  		drm_dma_takedown(dev);
>  
> -	dev->dev_mapping = NULL;
>  	mutex_unlock(&dev->struct_mutex);
>  
>  	DRM_DEBUG("lastclose completed\n");
> diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
> index 3a24385..6752f59 100644
> --- a/drivers/gpu/drm/drm_fops.c
> +++ b/drivers/gpu/drm/drm_fops.c
> @@ -122,8 +122,6 @@ int drm_open(struct inode *inode, struct file *filp)
>  	struct drm_minor *minor;
>  	int retcode = 0;
>  	int need_setup = 0;
> -	struct address_space *old_mapping;
> -	struct address_space *old_imapping;
>  
>  	minor = idr_find(&drm_minors_idr, minor_id);
>  	if (!minor)
> @@ -137,16 +135,9 @@ int drm_open(struct inode *inode, struct file *filp)
>  
>  	if (!dev->open_count++)
>  		need_setup = 1;
> -	mutex_lock(&dev->struct_mutex);
> -	old_imapping = inode->i_mapping;
> -	old_mapping = dev->dev_mapping;
> -	if (old_mapping == NULL)
> -		dev->dev_mapping = &inode->i_data;
> -	/* ihold ensures nobody can remove inode with our i_data */
> -	ihold(container_of(dev->dev_mapping, struct inode, i_data));
> -	inode->i_mapping = dev->dev_mapping;
> -	filp->f_mapping = dev->dev_mapping;
> -	mutex_unlock(&dev->struct_mutex);
> +
> +	/* set address_space for shared mappings */
> +	filp->f_mapping = dev->anon_inode->i_mapping;
>  
>  	retcode = drm_open_helper(inode, filp, dev);
>  	if (retcode)
> @@ -160,12 +151,6 @@ int drm_open(struct inode *inode, struct file *filp)
>  	return 0;
>  
>  err_undo:
> -	mutex_lock(&dev->struct_mutex);
> -	filp->f_mapping = old_imapping;
> -	inode->i_mapping = old_imapping;
> -	iput(container_of(dev->dev_mapping, struct inode, i_data));
> -	dev->dev_mapping = old_mapping;
> -	mutex_unlock(&dev->struct_mutex);
>  	dev->open_count--;
>  	return retcode;
>  }
> @@ -543,9 +528,6 @@ int drm_release(struct inode *inode, struct file *filp)
>  		}
>  	}
>  
> -	BUG_ON(dev->dev_mapping == NULL);
> -	iput(container_of(dev->dev_mapping, struct inode, i_data));
> -
>  	/* drop the reference held my the file priv */
>  	drm_master_put(&file_priv->master);
>  	file_priv->is_master = 0;
> diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
> index 327ca19..45804f1 100644
> --- a/drivers/gpu/drm/drm_stub.c
> +++ b/drivers/gpu/drm/drm_stub.c
> @@ -31,6 +31,7 @@
>   * DEALINGS IN THE SOFTWARE.
>   */
>  
> +#include <linux/anon_inodes.h>
>  #include <linux/module.h>
>  #include <linux/moduleparam.h>
>  #include <linux/slab.h>
> @@ -267,8 +268,14 @@ int drm_fill_in_dev(struct drm_device *dev,
>  	mutex_init(&dev->struct_mutex);
>  	mutex_init(&dev->ctxlist_mutex);
>  
> +	/* create private address_space on anon inode */
> +	dev->anon_inode = anon_inode_new();
> +	if (IS_ERR(dev->anon_inode))
> +		return PTR_ERR(dev->anon_inode);
> +
>  	if (drm_ht_create(&dev->map_hash, 12)) {
> -		return -ENOMEM;
> +		retcode = -ENOMEM;
> +		goto err_inode;
>  	}
>  
>  	/* the DRM has 6 basic counters */
> @@ -309,6 +316,8 @@ int drm_fill_in_dev(struct drm_device *dev,
>  
>        error_out_unreg:
>  	drm_lastclose(dev);
> +err_inode:
> +	iput(dev->anon_inode);
>  	return retcode;
>  }
>  EXPORT_SYMBOL(drm_fill_in_dev);
> @@ -478,6 +487,7 @@ void drm_put_dev(struct drm_device *dev)
>  
>  	drm_put_minor(&dev->primary);
>  
> +	iput(dev->anon_inode);
>  	list_del(&dev->driver_item);
>  	kfree(dev->devname);
>  	kfree(dev);
> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> index 769f752..37c73e3 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -1425,8 +1425,8 @@ i915_gem_release_mmap(struct drm_i915_gem_object *obj)
>  	if (!obj->fault_mappable)
>  		return;
>  
> -	if (obj->base.dev->dev_mapping)
> -		unmap_mapping_range(obj->base.dev->dev_mapping,
> +	if (obj->base.dev->anon_inode->i_mapping)
> +		unmap_mapping_range(obj->base.dev->anon_inode->i_mapping,
>  				    (loff_t)obj->base.map_list.hash.key<<PAGE_SHIFT,
>  				    obj->base.size, 1);
>  
> diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
> index e72d09c..ceb4d34 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_gem.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
> @@ -243,7 +243,7 @@ nouveau_gem_ioctl_new(struct drm_device *dev, void *data,
>  	struct nouveau_bo *nvbo = NULL;
>  	int ret = 0;
>  
> -	drm->ttm.bdev.dev_mapping = drm->dev->dev_mapping;
> +	drm->ttm.bdev.dev_mapping = drm->dev->anon_inode->i_mapping;
>  
>  	if (!pfb->memtype_valid(pfb, req->info.tile_flags)) {
>  		NV_ERROR(cli, "bad page flags: 0x%08x\n", req->info.tile_flags);
> diff --git a/drivers/gpu/drm/omapdrm/omap_gem.c b/drivers/gpu/drm/omapdrm/omap_gem.c
> index ebbdf41..8f77a35 100644
> --- a/drivers/gpu/drm/omapdrm/omap_gem.c
> +++ b/drivers/gpu/drm/omapdrm/omap_gem.c
> @@ -152,7 +152,7 @@ static struct {
>  static void evict_entry(struct drm_gem_object *obj,
>  		enum tiler_fmt fmt, struct usergart_entry *entry)
>  {
> -	if (obj->dev->dev_mapping) {
> +	if (obj->dev->anon_inode->i_mapping) {
>  		struct omap_gem_object *omap_obj = to_omap_bo(obj);
>  		int n = usergart[fmt].height;
>  		size_t size = PAGE_SIZE * n;
> @@ -163,12 +163,13 @@ static void evict_entry(struct drm_gem_object *obj,
>  			int i;
>  			/* if stride > than PAGE_SIZE then sparse mapping: */
>  			for (i = n; i > 0; i--) {
> -				unmap_mapping_range(obj->dev->dev_mapping,
> +				unmap_mapping_range(obj->dev->anon_inode->i_mapping,
>  						off, PAGE_SIZE, 1);
>  				off += PAGE_SIZE * m;
>  			}
>  		} else {
> -			unmap_mapping_range(obj->dev->dev_mapping, off, size, 1);
> +			unmap_mapping_range(obj->dev->anon_inode->i_mapping,
> +					    off, size, 1);
>  		}
>  	}
>  
> diff --git a/drivers/gpu/drm/qxl/qxl_object.c b/drivers/gpu/drm/qxl/qxl_object.c
> index 1191fe7..df2f03a 100644
> --- a/drivers/gpu/drm/qxl/qxl_object.c
> +++ b/drivers/gpu/drm/qxl/qxl_object.c
> @@ -82,7 +82,7 @@ int qxl_bo_create(struct qxl_device *qdev,
>  	int r;
>  
>  	if (unlikely(qdev->mman.bdev.dev_mapping == NULL))
> -		qdev->mman.bdev.dev_mapping = qdev->ddev->dev_mapping;
> +		qdev->mman.bdev.dev_mapping = qdev->ddev->anon_inode->i_mapping;
>  	if (kernel)
>  		type = ttm_bo_type_kernel;
>  	else
> diff --git a/drivers/gpu/drm/qxl/qxl_ttm.c b/drivers/gpu/drm/qxl/qxl_ttm.c
> index 489cb8c..0f62d35 100644
> --- a/drivers/gpu/drm/qxl/qxl_ttm.c
> +++ b/drivers/gpu/drm/qxl/qxl_ttm.c
> @@ -515,7 +515,7 @@ int qxl_ttm_init(struct qxl_device *qdev)
>  	DRM_INFO("qxl: %luM of IO pages memory ready (VRAM domain)\n",
>  		 ((unsigned)num_io_pages * PAGE_SIZE) / (1024 * 1024));
>  	if (unlikely(qdev->mman.bdev.dev_mapping == NULL))
> -		qdev->mman.bdev.dev_mapping = qdev->ddev->dev_mapping;
> +		qdev->mman.bdev.dev_mapping = qdev->ddev->anon_inode->i_mapping;
>  	r = qxl_ttm_debugfs_init(qdev);
>  	if (r) {
>  		DRM_ERROR("Failed to init debugfs\n");
> diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
> index 0219d26..f79bc77 100644
> --- a/drivers/gpu/drm/radeon/radeon_object.c
> +++ b/drivers/gpu/drm/radeon/radeon_object.c
> @@ -120,7 +120,7 @@ int radeon_bo_create(struct radeon_device *rdev,
>  
>  	size = ALIGN(size, PAGE_SIZE);
>  
> -	rdev->mman.bdev.dev_mapping = rdev->ddev->dev_mapping;
> +	rdev->mman.bdev.dev_mapping = rdev->ddev->anon_inode->i_mapping;
>  	if (kernel) {
>  		type = ttm_bo_type_kernel;
>  	} else if (sg) {
> diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
> index 6c0ce89..6071ecb 100644
> --- a/drivers/gpu/drm/radeon/radeon_ttm.c
> +++ b/drivers/gpu/drm/radeon/radeon_ttm.c
> @@ -735,7 +735,7 @@ int radeon_ttm_init(struct radeon_device *rdev)
>  	}
>  	DRM_INFO("radeon: %uM of GTT memory ready.\n",
>  		 (unsigned)(rdev->mc.gtt_size / (1024 * 1024)));
> -	rdev->mman.bdev.dev_mapping = rdev->ddev->dev_mapping;
> +	rdev->mman.bdev.dev_mapping = rdev->ddev->anon_inode->i_mapping;
>  
>  	r = radeon_ttm_debugfs_init(rdev);
>  	if (r) {
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> index 78e2164..5b9bf2b 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> @@ -760,7 +760,7 @@ static int vmw_driver_open(struct drm_device *dev, struct drm_file *file_priv)
>  		goto out_no_tfile;
>  
>  	file_priv->driver_priv = vmw_fp;
> -	dev_priv->bdev.dev_mapping = dev->dev_mapping;
> +	dev_priv->bdev.dev_mapping = dev->anon_inode->i_mapping;
>  
>  	return 0;
>  
> diff --git a/include/drm/drmP.h b/include/drm/drmP.h
> index 12083dc..51bf85e 100644
> --- a/include/drm/drmP.h
> +++ b/include/drm/drmP.h
> @@ -1198,7 +1198,7 @@ struct drm_device {
>  	unsigned int num_crtcs;                  /**< Number of CRTCs on this device */
>  	void *dev_private;		/**< device private data */
>  	void *mm_private;
> -	struct address_space *dev_mapping;
> +	struct inode *anon_inode;
>  	struct drm_sigdata sigdata;	   /**< For block_all_signals */
>  	sigset_t sigmask;
>  
> -- 
> 1.8.3.2
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
