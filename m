Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab3CKXDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:03:48 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:65179 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab3CKXDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:03:47 -0400
Date: Tue, 12 Mar 2013 00:03:30 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915: use simple attribute in debugfs routines
Message-ID: <20130311230330.GC3872@bremse>
Mail-Followup-To: Kees Cook <keescook@chromium.org>,
	linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org
References: <20130310211006.GA26200@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130310211006.GA26200@www.outflux.net>
X-Operating-System: Linux bremse 3.8.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 02:10:06PM -0700, Kees Cook wrote:
> This replaces the manual read/write routines in debugfs with the common
> simple attribute helpers. Doing this gets rid of repeated copy/pasting
> of copy_from_user and value formatting code.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>

Queued for -next, thanks for the patch. When sending drm/i915 patches,
please also cc intel-gfx@lists.freedesktop.org (it's open for
non-subscribers non without nagging "you're mail is in the moderation
queue" replies).

Thanks, Daniel

> ---
>  drivers/gpu/drm/i915/i915_debugfs.c |  394 +++++++++--------------------------
>  1 file changed, 98 insertions(+), 296 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
> index aae3148..d86c304 100644
> --- a/drivers/gpu/drm/i915/i915_debugfs.c
> +++ b/drivers/gpu/drm/i915/i915_debugfs.c
> @@ -849,76 +849,42 @@ static const struct file_operations i915_error_state_fops = {
>  	.release = i915_error_state_release,
>  };
>  
> -static ssize_t
> -i915_next_seqno_read(struct file *filp,
> -		 char __user *ubuf,
> -		 size_t max,
> -		 loff_t *ppos)
> +static int
> +i915_next_seqno_get(void *data, u64 *val)
>  {
> -	struct drm_device *dev = filp->private_data;
> +	struct drm_device *dev = data;
>  	drm_i915_private_t *dev_priv = dev->dev_private;
> -	char buf[80];
> -	int len;
>  	int ret;
>  
>  	ret = mutex_lock_interruptible(&dev->struct_mutex);
>  	if (ret)
>  		return ret;
>  
> -	len = snprintf(buf, sizeof(buf),
> -		       "next_seqno :  0x%x\n",
> -		       dev_priv->next_seqno);
> -
> +	*val = dev_priv->next_seqno;
>  	mutex_unlock(&dev->struct_mutex);
>  
> -	if (len > sizeof(buf))
> -		len = sizeof(buf);
> -
> -	return simple_read_from_buffer(ubuf, max, ppos, buf, len);
> +	return 0;
>  }
>  
> -static ssize_t
> -i915_next_seqno_write(struct file *filp,
> -		      const char __user *ubuf,
> -		      size_t cnt,
> -		      loff_t *ppos)
> -{
> -	struct drm_device *dev = filp->private_data;
> -	char buf[20];
> -	u32 val = 1;
> +static int
> +i915_next_seqno_set(void *data, u64 val)
> +{
> +	struct drm_device *dev = data;
>  	int ret;
>  
> -	if (cnt > 0) {
> -		if (cnt > sizeof(buf) - 1)
> -			return -EINVAL;
> -
> -		if (copy_from_user(buf, ubuf, cnt))
> -			return -EFAULT;
> -		buf[cnt] = 0;
> -
> -		ret = kstrtouint(buf, 0, &val);
> -		if (ret < 0)
> -			return ret;
> -	}
> -
>  	ret = mutex_lock_interruptible(&dev->struct_mutex);
>  	if (ret)
>  		return ret;
>  
>  	ret = i915_gem_set_seqno(dev, val);
> -
>  	mutex_unlock(&dev->struct_mutex);
>  
> -	return ret ?: cnt;
> +	return ret;
>  }
>  
> -static const struct file_operations i915_next_seqno_fops = {
> -	.owner = THIS_MODULE,
> -	.open = simple_open,
> -	.read = i915_next_seqno_read,
> -	.write = i915_next_seqno_write,
> -	.llseek = default_llseek,
> -};
> +DEFINE_SIMPLE_ATTRIBUTE(i915_next_seqno_fops,
> +			i915_next_seqno_get, i915_next_seqno_set,
> +			"next_seqno :  0x%llx\n");
>  
>  static int i915_rstdby_delays(struct seq_file *m, void *unused)
>  {
> @@ -1680,105 +1646,51 @@ static int i915_dpio_info(struct seq_file *m, void *data)
>  	return 0;
>  }
>  
> -static ssize_t
> -i915_wedged_read(struct file *filp,
> -		 char __user *ubuf,
> -		 size_t max,
> -		 loff_t *ppos)
> +static int
> +i915_wedged_get(void *data, u64 *val)
>  {
> -	struct drm_device *dev = filp->private_data;
> +	struct drm_device *dev = data;
>  	drm_i915_private_t *dev_priv = dev->dev_private;
> -	char buf[80];
> -	int len;
>  
> -	len = snprintf(buf, sizeof(buf),
> -		       "wedged :  %d\n",
> -		       atomic_read(&dev_priv->gpu_error.reset_counter));
> +	*val = atomic_read(&dev_priv->gpu_error.reset_counter);
>  
> -	if (len > sizeof(buf))
> -		len = sizeof(buf);
> -
> -	return simple_read_from_buffer(ubuf, max, ppos, buf, len);
> +	return 0;
>  }
>  
> -static ssize_t
> -i915_wedged_write(struct file *filp,
> -		  const char __user *ubuf,
> -		  size_t cnt,
> -		  loff_t *ppos)
> +static int
> +i915_wedged_set(void *data, u64 val)
>  {
> -	struct drm_device *dev = filp->private_data;
> -	char buf[20];
> -	int val = 1;
> -
> -	if (cnt > 0) {
> -		if (cnt > sizeof(buf) - 1)
> -			return -EINVAL;
> +	struct drm_device *dev = data;
>  
> -		if (copy_from_user(buf, ubuf, cnt))
> -			return -EFAULT;
> -		buf[cnt] = 0;
> -
> -		val = simple_strtoul(buf, NULL, 0);
> -	}
> -
> -	DRM_INFO("Manually setting wedged to %d\n", val);
> +	DRM_INFO("Manually setting wedged to %llu\n", val);
>  	i915_handle_error(dev, val);
>  
> -	return cnt;
> +	return 0;
>  }
>  
> -static const struct file_operations i915_wedged_fops = {
> -	.owner = THIS_MODULE,
> -	.open = simple_open,
> -	.read = i915_wedged_read,
> -	.write = i915_wedged_write,
> -	.llseek = default_llseek,
> -};
> +DEFINE_SIMPLE_ATTRIBUTE(i915_wedged_fops,
> +			i915_wedged_get, i915_wedged_set,
> +			"wedged :  %llu\n");
>  
> -static ssize_t
> -i915_ring_stop_read(struct file *filp,
> -		    char __user *ubuf,
> -		    size_t max,
> -		    loff_t *ppos)
> +static int
> +i915_ring_stop_get(void *data, u64 *val)
>  {
> -	struct drm_device *dev = filp->private_data;
> +	struct drm_device *dev = data;
>  	drm_i915_private_t *dev_priv = dev->dev_private;
> -	char buf[20];
> -	int len;
> -
> -	len = snprintf(buf, sizeof(buf),
> -		       "0x%08x\n", dev_priv->gpu_error.stop_rings);
>  
> -	if (len > sizeof(buf))
> -		len = sizeof(buf);
> +	*val = dev_priv->gpu_error.stop_rings;
>  
> -	return simple_read_from_buffer(ubuf, max, ppos, buf, len);
> +	return 0;
>  }
>  
> -static ssize_t
> -i915_ring_stop_write(struct file *filp,
> -		     const char __user *ubuf,
> -		     size_t cnt,
> -		     loff_t *ppos)
> +static int
> +i915_ring_stop_set(void *data, u64 val)
>  {
> -	struct drm_device *dev = filp->private_data;
> +	struct drm_device *dev = data;
>  	struct drm_i915_private *dev_priv = dev->dev_private;
> -	char buf[20];
> -	int val = 0, ret;
> -
> -	if (cnt > 0) {
> -		if (cnt > sizeof(buf) - 1)
> -			return -EINVAL;
> -
> -		if (copy_from_user(buf, ubuf, cnt))
> -			return -EFAULT;
> -		buf[cnt] = 0;
> -
> -		val = simple_strtoul(buf, NULL, 0);
> -	}
> +	int ret;
>  
> -	DRM_DEBUG_DRIVER("Stopping rings 0x%08x\n", val);
> +	DRM_DEBUG_DRIVER("Stopping rings 0x%08llx\n", val);
>  
>  	ret = mutex_lock_interruptible(&dev->struct_mutex);
>  	if (ret)
> @@ -1787,16 +1699,12 @@ i915_ring_stop_write(struct file *filp,
>  	dev_priv->gpu_error.stop_rings = val;
>  	mutex_unlock(&dev->struct_mutex);
>  
> -	return cnt;
> +	return 0;
>  }
>  
> -static const struct file_operations i915_ring_stop_fops = {
> -	.owner = THIS_MODULE,
> -	.open = simple_open,
> -	.read = i915_ring_stop_read,
> -	.write = i915_ring_stop_write,
> -	.llseek = default_llseek,
> -};
> +DEFINE_SIMPLE_ATTRIBUTE(i915_ring_stop_fops,
> +			i915_ring_stop_get, i915_ring_stop_set,
> +			"0x%08llx\n");
>  
>  #define DROP_UNBOUND 0x1
>  #define DROP_BOUND 0x2
> @@ -1806,46 +1714,23 @@ static const struct file_operations i915_ring_stop_fops = {
>  		  DROP_BOUND | \
>  		  DROP_RETIRE | \
>  		  DROP_ACTIVE)
> -static ssize_t
> -i915_drop_caches_read(struct file *filp,
> -		      char __user *ubuf,
> -		      size_t max,
> -		      loff_t *ppos)
> +static int
> +i915_drop_caches_get(void *data, u64 *val)
>  {
> -	char buf[20];
> -	int len;
> -
> -	len = snprintf(buf, sizeof(buf), "0x%08x\n", DROP_ALL);
> -	if (len > sizeof(buf))
> -		len = sizeof(buf);
> +	*val = DROP_ALL;
>  
> -	return simple_read_from_buffer(ubuf, max, ppos, buf, len);
> +	return 0;
>  }
>  
> -static ssize_t
> -i915_drop_caches_write(struct file *filp,
> -		       const char __user *ubuf,
> -		       size_t cnt,
> -		       loff_t *ppos)
> +static int
> +i915_drop_caches_set(void *data, u64 val)
>  {
> -	struct drm_device *dev = filp->private_data;
> +	struct drm_device *dev = data;
>  	struct drm_i915_private *dev_priv = dev->dev_private;
>  	struct drm_i915_gem_object *obj, *next;
> -	char buf[20];
> -	int val = 0, ret;
> -
> -	if (cnt > 0) {
> -		if (cnt > sizeof(buf) - 1)
> -			return -EINVAL;
> -
> -		if (copy_from_user(buf, ubuf, cnt))
> -			return -EFAULT;
> -		buf[cnt] = 0;
> -
> -		val = simple_strtoul(buf, NULL, 0);
> -	}
> +	int ret;
>  
> -	DRM_DEBUG_DRIVER("Dropping caches: 0x%08x\n", val);
> +	DRM_DEBUG_DRIVER("Dropping caches: 0x%08llx\n", val);
>  
>  	/* No need to check and wait for gpu resets, only libdrm auto-restarts
>  	 * on ioctls on -EAGAIN. */
> @@ -1883,27 +1768,19 @@ i915_drop_caches_write(struct file *filp,
>  unlock:
>  	mutex_unlock(&dev->struct_mutex);
>  
> -	return ret ?: cnt;
> +	return ret;
>  }
>  
> -static const struct file_operations i915_drop_caches_fops = {
> -	.owner = THIS_MODULE,
> -	.open = simple_open,
> -	.read = i915_drop_caches_read,
> -	.write = i915_drop_caches_write,
> -	.llseek = default_llseek,
> -};
> +DEFINE_SIMPLE_ATTRIBUTE(i915_drop_caches_fops,
> +			i915_drop_caches_get, i915_drop_caches_set,
> +			"0x%08llx\n");
>  
> -static ssize_t
> -i915_max_freq_read(struct file *filp,
> -		   char __user *ubuf,
> -		   size_t max,
> -		   loff_t *ppos)
> +static int
> +i915_max_freq_get(void *data, u64 *val)
>  {
> -	struct drm_device *dev = filp->private_data;
> +	struct drm_device *dev = data;
>  	drm_i915_private_t *dev_priv = dev->dev_private;
> -	char buf[80];
> -	int len, ret;
> +	int ret;
>  
>  	if (!(IS_GEN6(dev) || IS_GEN7(dev)))
>  		return -ENODEV;
> @@ -1912,42 +1789,23 @@ i915_max_freq_read(struct file *filp,
>  	if (ret)
>  		return ret;
>  
> -	len = snprintf(buf, sizeof(buf),
> -		       "max freq: %d\n", dev_priv->rps.max_delay * GT_FREQUENCY_MULTIPLIER);
> +	*val = dev_priv->rps.max_delay * GT_FREQUENCY_MULTIPLIER;
>  	mutex_unlock(&dev_priv->rps.hw_lock);
>  
> -	if (len > sizeof(buf))
> -		len = sizeof(buf);
> -
> -	return simple_read_from_buffer(ubuf, max, ppos, buf, len);
> +	return 0;
>  }
>  
> -static ssize_t
> -i915_max_freq_write(struct file *filp,
> -		  const char __user *ubuf,
> -		  size_t cnt,
> -		  loff_t *ppos)
> +static int
> +i915_max_freq_set(void *data, u64 val)
>  {
> -	struct drm_device *dev = filp->private_data;
> +	struct drm_device *dev = data;
>  	struct drm_i915_private *dev_priv = dev->dev_private;
> -	char buf[20];
> -	int val = 1, ret;
> +	int ret;
>  
>  	if (!(IS_GEN6(dev) || IS_GEN7(dev)))
>  		return -ENODEV;
>  
> -	if (cnt > 0) {
> -		if (cnt > sizeof(buf) - 1)
> -			return -EINVAL;
> -
> -		if (copy_from_user(buf, ubuf, cnt))
> -			return -EFAULT;
> -		buf[cnt] = 0;
> -
> -		val = simple_strtoul(buf, NULL, 0);
> -	}
> -
> -	DRM_DEBUG_DRIVER("Manually setting max freq to %d\n", val);
> +	DRM_DEBUG_DRIVER("Manually setting max freq to %llu\n", val);
>  
>  	ret = mutex_lock_interruptible(&dev_priv->rps.hw_lock);
>  	if (ret)
> @@ -1961,25 +1819,19 @@ i915_max_freq_write(struct file *filp,
>  	gen6_set_rps(dev, val / GT_FREQUENCY_MULTIPLIER);
>  	mutex_unlock(&dev_priv->rps.hw_lock);
>  
> -	return cnt;
> +	return 0;
>  }
>  
> -static const struct file_operations i915_max_freq_fops = {
> -	.owner = THIS_MODULE,
> -	.open = simple_open,
> -	.read = i915_max_freq_read,
> -	.write = i915_max_freq_write,
> -	.llseek = default_llseek,
> -};
> +DEFINE_SIMPLE_ATTRIBUTE(i915_max_freq_fops,
> +			i915_max_freq_get, i915_max_freq_set,
> +			"max freq: %llu\n");
>  
> -static ssize_t
> -i915_min_freq_read(struct file *filp, char __user *ubuf, size_t max,
> -		   loff_t *ppos)
> +static int
> +i915_min_freq_get(void *data, u64 *val)
>  {
> -	struct drm_device *dev = filp->private_data;
> +	struct drm_device *dev = data;
>  	drm_i915_private_t *dev_priv = dev->dev_private;
> -	char buf[80];
> -	int len, ret;
> +	int ret;
>  
>  	if (!(IS_GEN6(dev) || IS_GEN7(dev)))
>  		return -ENODEV;
> @@ -1988,40 +1840,23 @@ i915_min_freq_read(struct file *filp, char __user *ubuf, size_t max,
>  	if (ret)
>  		return ret;
>  
> -	len = snprintf(buf, sizeof(buf),
> -		       "min freq: %d\n", dev_priv->rps.min_delay * GT_FREQUENCY_MULTIPLIER);
> +	*val = dev_priv->rps.min_delay * GT_FREQUENCY_MULTIPLIER;
>  	mutex_unlock(&dev_priv->rps.hw_lock);
>  
> -	if (len > sizeof(buf))
> -		len = sizeof(buf);
> -
> -	return simple_read_from_buffer(ubuf, max, ppos, buf, len);
> +	return 0;
>  }
>  
> -static ssize_t
> -i915_min_freq_write(struct file *filp, const char __user *ubuf, size_t cnt,
> -		    loff_t *ppos)
> +static int
> +i915_min_freq_set(void *data, u64 val)
>  {
> -	struct drm_device *dev = filp->private_data;
> +	struct drm_device *dev = data;
>  	struct drm_i915_private *dev_priv = dev->dev_private;
> -	char buf[20];
> -	int val = 1, ret;
> +	int ret;
>  
>  	if (!(IS_GEN6(dev) || IS_GEN7(dev)))
>  		return -ENODEV;
>  
> -	if (cnt > 0) {
> -		if (cnt > sizeof(buf) - 1)
> -			return -EINVAL;
> -
> -		if (copy_from_user(buf, ubuf, cnt))
> -			return -EFAULT;
> -		buf[cnt] = 0;
> -
> -		val = simple_strtoul(buf, NULL, 0);
> -	}
> -
> -	DRM_DEBUG_DRIVER("Manually setting min freq to %d\n", val);
> +	DRM_DEBUG_DRIVER("Manually setting min freq to %llu\n", val);
>  
>  	ret = mutex_lock_interruptible(&dev_priv->rps.hw_lock);
>  	if (ret)
> @@ -2035,28 +1870,20 @@ i915_min_freq_write(struct file *filp, const char __user *ubuf, size_t cnt,
>  	gen6_set_rps(dev, val / GT_FREQUENCY_MULTIPLIER);
>  	mutex_unlock(&dev_priv->rps.hw_lock);
>  
> -	return cnt;
> +	return 0;
>  }
>  
> -static const struct file_operations i915_min_freq_fops = {
> -	.owner = THIS_MODULE,
> -	.open = simple_open,
> -	.read = i915_min_freq_read,
> -	.write = i915_min_freq_write,
> -	.llseek = default_llseek,
> -};
> +DEFINE_SIMPLE_ATTRIBUTE(i915_min_freq_fops,
> +			i915_min_freq_get, i915_min_freq_set,
> +			"min freq: %llu\n");
>  
> -static ssize_t
> -i915_cache_sharing_read(struct file *filp,
> -		   char __user *ubuf,
> -		   size_t max,
> -		   loff_t *ppos)
> +static int
> +i915_cache_sharing_get(void *data, u64 *val)
>  {
> -	struct drm_device *dev = filp->private_data;
> +	struct drm_device *dev = data;
>  	drm_i915_private_t *dev_priv = dev->dev_private;
> -	char buf[80];
>  	u32 snpcr;
> -	int len, ret;
> +	int ret;
>  
>  	if (!(IS_GEN6(dev) || IS_GEN7(dev)))
>  		return -ENODEV;
> @@ -2068,46 +1895,25 @@ i915_cache_sharing_read(struct file *filp,
>  	snpcr = I915_READ(GEN6_MBCUNIT_SNPCR);
>  	mutex_unlock(&dev_priv->dev->struct_mutex);
>  
> -	len = snprintf(buf, sizeof(buf),
> -		       "%d\n", (snpcr & GEN6_MBC_SNPCR_MASK) >>
> -		       GEN6_MBC_SNPCR_SHIFT);
> -
> -	if (len > sizeof(buf))
> -		len = sizeof(buf);
> +	*val = (snpcr & GEN6_MBC_SNPCR_MASK) >> GEN6_MBC_SNPCR_SHIFT;
>  
> -	return simple_read_from_buffer(ubuf, max, ppos, buf, len);
> +	return 0;
>  }
>  
> -static ssize_t
> -i915_cache_sharing_write(struct file *filp,
> -		  const char __user *ubuf,
> -		  size_t cnt,
> -		  loff_t *ppos)
> +static int
> +i915_cache_sharing_set(void *data, u64 val)
>  {
> -	struct drm_device *dev = filp->private_data;
> +	struct drm_device *dev = data;
>  	struct drm_i915_private *dev_priv = dev->dev_private;
> -	char buf[20];
>  	u32 snpcr;
> -	int val = 1;
>  
>  	if (!(IS_GEN6(dev) || IS_GEN7(dev)))
>  		return -ENODEV;
>  
> -	if (cnt > 0) {
> -		if (cnt > sizeof(buf) - 1)
> -			return -EINVAL;
> -
> -		if (copy_from_user(buf, ubuf, cnt))
> -			return -EFAULT;
> -		buf[cnt] = 0;
> -
> -		val = simple_strtoul(buf, NULL, 0);
> -	}
> -
> -	if (val < 0 || val > 3)
> +	if (val > 3)
>  		return -EINVAL;
>  
> -	DRM_DEBUG_DRIVER("Manually setting uncore sharing to %d\n", val);
> +	DRM_DEBUG_DRIVER("Manually setting uncore sharing to %llu\n", val);
>  
>  	/* Update the cache sharing policy here as well */
>  	snpcr = I915_READ(GEN6_MBCUNIT_SNPCR);
> @@ -2115,16 +1921,12 @@ i915_cache_sharing_write(struct file *filp,
>  	snpcr |= (val << GEN6_MBC_SNPCR_SHIFT);
>  	I915_WRITE(GEN6_MBCUNIT_SNPCR, snpcr);
>  
> -	return cnt;
> +	return 0;
>  }
>  
> -static const struct file_operations i915_cache_sharing_fops = {
> -	.owner = THIS_MODULE,
> -	.open = simple_open,
> -	.read = i915_cache_sharing_read,
> -	.write = i915_cache_sharing_write,
> -	.llseek = default_llseek,
> -};
> +DEFINE_SIMPLE_ATTRIBUTE(i915_cache_sharing_fops,
> +			i915_cache_sharing_get, i915_cache_sharing_set,
> +			"%llu\n");
>  
>  /* As the drm_debugfs_init() routines are called before dev->dev_private is
>   * allocated we need to hook into the minor for release. */
> -- 
> 1.7.9.5
> 
> 
> -- 
> Kees Cook
> Chrome OS Security

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
