Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab3CRLvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:51:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab3CRLvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:51:49 -0400
Date: Mon, 18 Mar 2013 12:51:45 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Shawn Starr <shawn.starr@rogers.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH] drm/i915: Flush writes to GMBUS registers
In-Reply-To: <1363605185-4030-1-git-send-email-chris@chris-wilson.co.uk>
Message-ID: <alpine.LNX.2.00.1303181251040.9529@pobox.suse.cz>
References: <alpine.LNX.2.00.1303151424140.9529@pobox.suse.cz> <1363605185-4030-1-git-send-email-chris@chris-wilson.co.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Mar 2013, Chris Wilson wrote:

> If we do not complete the writes to the GMBUS registers, they remain
> active for an indefinite period of time afterwards, even causing
> spurious interrupts on gm45.
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Link: http://lkml.kernel.org/r/alpine.LNX.2.00.1303151424140.9529@pobox.suse.cz
> Cc: Shawn Starr <shawn.starr@rogers.com>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>

Unfortunately I can't provide my Tested-by or Acked-by for this, as I am 
still seeing the "nobody cared" for irq 16 with this patch applied.

> ---
>  drivers/gpu/drm/i915/intel_i2c.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
> index acf8aec..ca6c17e 100644
> --- a/drivers/gpu/drm/i915/intel_i2c.c
> +++ b/drivers/gpu/drm/i915/intel_i2c.c
> @@ -64,6 +64,7 @@ intel_i2c_reset(struct drm_device *dev)
>  	struct drm_i915_private *dev_priv = dev->dev_private;
>  	I915_WRITE(dev_priv->gpio_mmio_base + GMBUS0, 0);
>  	I915_WRITE(dev_priv->gpio_mmio_base + GMBUS4, 0);
> +	POSTING_READ(dev_priv->gpio_mmio_base + GMBUS4);
>  }
>  
>  static void intel_i2c_quirk_set(struct drm_i915_private *dev_priv, bool enable)
> @@ -232,6 +233,7 @@ gmbus_wait_hw_status(struct drm_i915_private *dev_priv,
>  	finish_wait(&dev_priv->gmbus_wait_queue, &wait);
>  
>  	I915_WRITE(GMBUS4 + reg_offset, 0);
> +	POSTING_READ(GMBUS4 + reg_offset);
>  
>  	if (gmbus2 & GMBUS_SATOER)
>  		return -ENXIO;
> @@ -257,6 +259,7 @@ gmbus_wait_idle(struct drm_i915_private *dev_priv)
>  	ret = wait_event_timeout(dev_priv->gmbus_wait_queue, C, 10);
>  
>  	I915_WRITE(GMBUS4 + reg_offset, 0);
> +	POSTING_READ(GMBUS4 + reg_offset);
>  
>  	if (ret)
>  		return 0;
> @@ -486,6 +489,7 @@ timeout:
>  	ret = i2c_bit_algo.master_xfer(adapter, msgs, num);
>  
>  out:
> +	POSTING_READ(GMBUS0 + dev_priv->gpio_mmio_base);
>  	mutex_unlock(&dev_priv->gmbus_mutex);
>  	return ret;
>  }
> -- 
> 1.7.10.4
> 

-- 
Jiri Kosina
SUSE Labs
