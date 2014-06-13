Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbaFMUJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:09:14 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:42534 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaFMUJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:09:11 -0400
Date: Fri, 13 Jun 2014 22:09:05 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Christoph Jaeger <christophjaeger@linux.com>
Cc: daniel.vetter@ffwll.ch, jani.nikula@linux.intel.com, airlied@linux.ie,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Fix memory leak in intel_dsi_init() error path
Message-ID: <20140613200904.GX5821@phenom.ffwll.local>
Mail-Followup-To: Christoph Jaeger <christophjaeger@linux.com>,
	jani.nikula@linux.intel.com, airlied@linux.ie,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <1402689082-20211-1-git-send-email-christophjaeger@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402689082-20211-1-git-send-email-christophjaeger@linux.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 09:51:22PM +0200, Christoph Jaeger wrote:
> intel_dsi_init() bails out without freeing the memory 'intel_dsi' and
> 'intel_connector' point to. Simply bail out before allocating memory.
> 
> Picked up by Coverity - CID 1222750.
> 
> Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>

Queued for -next, thanks for the patch. I've had to rebase the patch a
bit to resolve conflicts. Imo also not for -fixes because of this conflict
potential, so will land in 3.17.
-Daniel
> ---
>  drivers/gpu/drm/i915/intel_dsi.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_dsi.c b/drivers/gpu/drm/i915/intel_dsi.c
> index 02f99d7..6965627 100644
> --- a/drivers/gpu/drm/i915/intel_dsi.c
> +++ b/drivers/gpu/drm/i915/intel_dsi.c
> @@ -675,6 +675,13 @@ bool intel_dsi_init(struct drm_device *dev)
>  	if (!dev_priv->vbt.has_mipi)
>  		return false;
>  
> +	if (IS_VALLEYVIEW(dev)) {
> +		dev_priv->mipi_mmio_base = VLV_MIPI_BASE;
> +	} else {
> +		DRM_ERROR("Unsupported Mipi device to reg base");
> +		return false;
> +	}
> +
>  	intel_dsi = kzalloc(sizeof(*intel_dsi), GFP_KERNEL);
>  	if (!intel_dsi)
>  		return false;
> @@ -689,13 +696,6 @@ bool intel_dsi_init(struct drm_device *dev)
>  	encoder = &intel_encoder->base;
>  	intel_dsi->attached_connector = intel_connector;
>  
> -	if (IS_VALLEYVIEW(dev)) {
> -		dev_priv->mipi_mmio_base = VLV_MIPI_BASE;
> -	} else {
> -		DRM_ERROR("Unsupported Mipi device to reg base");
> -		return false;
> -	}
> -
>  	connector = &intel_connector->base;
>  
>  	drm_encoder_init(dev, encoder, &intel_dsi_funcs, DRM_MODE_ENCODER_DSI);
> -- 
> 1.9.3
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
