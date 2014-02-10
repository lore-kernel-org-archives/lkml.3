Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaBJNnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:43:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:53948 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195AbaBJNnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:43:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,818,1384329600"; 
   d="scan'208";a="478999334"
Date: Mon, 10 Feb 2014 15:43:11 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: sagar.a.kamble@intel.com
Cc: intel-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Rob Clark <robdclark@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 02/11] drm: Add support_bits parameter to
 drm_property_create_bitmask()
Message-ID: <20140210134311.GL3891@intel.com>
References: <1392017478-4945-1-git-send-email-sagar.a.kamble@intel.com>
 <1392017478-4945-3-git-send-email-sagar.a.kamble@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392017478-4945-3-git-send-email-sagar.a.kamble@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 01:01:09PM +0530, sagar.a.kamble@intel.com wrote:
> From: Ville Syrjälä <ville.syrjala at linux.intel.com>
> 
> Make drm_property_create_bitmask() a bit more generic by allowing the
> caller to specify which bits are in fact supported. This allows multiple
> callers to use the same enum list, but still create different versions
> of the same property with different list of supported bits.
> 
> v5: Fixed the caller of this function in omapdrm to comply with supported
> bitmask definition.

How can it be v5 w/o any v2,v3,v4?

In any case I think this is still broken. I'll reply with a new patch...

> 
> Cc: David Airlie <airlied@linux.ie>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: Rob Clark <robdclark@gmail.com>
> Cc: Sagar Kamble <sagar.a.kamble@intel.com>
> Cc: "Ville Syrjälä" <ville.syrjala@linux.intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Signed-off-by: Sagar Kamble <sagar.a.kamble@intel.com>
> Reviewed-by: Rob Clark <robdclark@gmail.com>
> ---
>  drivers/gpu/drm/drm_crtc.c           | 6 +++++-
>  drivers/gpu/drm/omapdrm/omap_plane.c | 8 +++++++-
>  include/drm/drm_crtc.h               | 3 ++-
>  3 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
> index 3b7d32d..628d3d3 100644
> --- a/drivers/gpu/drm/drm_crtc.c
> +++ b/drivers/gpu/drm/drm_crtc.c
> @@ -2906,7 +2906,8 @@ EXPORT_SYMBOL(drm_property_create_enum);
>  struct drm_property *drm_property_create_bitmask(struct drm_device *dev,
>  					 int flags, const char *name,
>  					 const struct drm_prop_enum_list *props,
> -					 int num_values)
> +					 int num_values,
> +					 unsigned int supported_bits)
>  {
>  	struct drm_property *property;
>  	int i, ret;
> @@ -2918,6 +2919,9 @@ struct drm_property *drm_property_create_bitmask(struct drm_device *dev,
>  		return NULL;
>  
>  	for (i = 0; i < num_values; i++) {
> +		if (!(supported_bits & (1 << i)))
> +			continue;
> +
>  		ret = drm_property_add_enum(property, i,
>  				      props[i].type,
>  				      props[i].name);
> diff --git a/drivers/gpu/drm/omapdrm/omap_plane.c b/drivers/gpu/drm/omapdrm/omap_plane.c
> index 046d5e6..b288f38 100644
> --- a/drivers/gpu/drm/omapdrm/omap_plane.c
> +++ b/drivers/gpu/drm/omapdrm/omap_plane.c
> @@ -309,7 +309,13 @@ void omap_plane_install_properties(struct drm_plane *plane,
>  					{ DRM_REFLECT_Y,  "reflect-y" },
>  			};
>  			prop = drm_property_create_bitmask(dev, 0, "rotation",
> -					props, ARRAY_SIZE(props));
> +					props, ARRAY_SIZE(props),
> +					BIT(DRM_ROTATE_0) |
> +					BIT(DRM_ROTATE_90) |
> +					BIT(DRM_ROTATE_180) |
> +					BIT(DRM_ROTATE_270) |
> +					BIT(DRM_REFLECT_X) |
> +					BIT(DRM_REFLECT_Y));
>  			if (prop == NULL)
>  				return;
>  			priv->rotation_prop = prop;
> diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
> index d5c46c1..41b86d2 100644
> --- a/include/drm/drm_crtc.h
> +++ b/include/drm/drm_crtc.h
> @@ -1070,7 +1070,8 @@ extern struct drm_property *drm_property_create_enum(struct drm_device *dev, int
>  struct drm_property *drm_property_create_bitmask(struct drm_device *dev,
>  					 int flags, const char *name,
>  					 const struct drm_prop_enum_list *props,
> -					 int num_values);
> +					 int num_values,
> +					 unsigned int supported_bits);
>  struct drm_property *drm_property_create_range(struct drm_device *dev, int flags,
>  					 const char *name,
>  					 uint64_t min, uint64_t max);
> -- 
> 1.8.5

-- 
Ville Syrjälä
Intel OTC
