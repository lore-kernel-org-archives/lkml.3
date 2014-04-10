Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965881AbaDJKil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:38:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:32637 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965833AbaDJKih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:38:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,833,1389772800"; 
   d="scan'208";a="518404734"
Message-ID: <1397126366.16960.17.camel@sagar-desktop>
Subject: Re: [PATCH v2 1/4] drm: Adding new flag to restrict bitmask drm
 properties as 32 bit type and 32 bit value pair
From: Sagar Arun Kamble <sagar.a.kamble@intel.com>
To: intel-gfx@lists.freedesktop.org
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, robdclark@gmail.com,
        rusty@rustcorp.com.au
Date: Thu, 10 Apr 2014 16:09:26 +0530
In-Reply-To: <1395757947-16492-1-git-send-email-sagar.a.kamble@intel.com>
References: <20140320135151.GO6912@strange.amr.corp.intel.com>
	 <1395757947-16492-1-git-send-email-sagar.a.kamble@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adding Rob and Rusty in the review thread.

Kindly review these patches for interface being proposed to set
color/alpha property of planes modeled after glBlendFunc.

 http://lists.freedesktop.org/archives/intel-gfx/2014-March/042350.html
 http://lists.freedesktop.org/archives/intel-gfx/2014-March/042351.html
 http://lists.freedesktop.org/archives/intel-gfx/2014-March/042352.html
 http://lists.freedesktop.org/archives/intel-gfx/2014-March/042587.html
 http://lists.freedesktop.org/archives/intel-gfx/2014-March/042354.html

thanks,
Sagar


On Tue, 2014-03-25 at 20:02 +0530, sagar.a.kamble@intel.com wrote:
> From: Sagar Kamble <sagar.a.kamble@intel.com>
> 
> With this patch new flag DRM_MODE_PROP_32BIT_PAIR is added that will help make use
> of 64 bit value of bitmask property as two 32 bit values.
> 
> Cc: airlied@linux.ie
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Sagar Kamble <sagar.a.kamble@intel.com>
> ---
>  drivers/gpu/drm/drm_crtc.c  | 22 ++++++++++++++++------
>  include/uapi/drm/drm_mode.h |  3 +++
>  2 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
> index 4e43fc2..d0d03ec 100644
> --- a/drivers/gpu/drm/drm_crtc.c
> +++ b/drivers/gpu/drm/drm_crtc.c
> @@ -2993,10 +2993,13 @@ int drm_property_add_enum(struct drm_property *property, int index,
>  
>  	/*
>  	 * Bitmask enum properties have the additional constraint of values
> -	 * from 0 to 63
> +	 * from 0 to 63. For properties with 32BIT_PAIR Flag set this constraint
> +	 * range is 0 to 31.
>  	 */
> -	if ((property->flags & DRM_MODE_PROP_BITMASK) && (value > 63))
> -		return -EINVAL;
> +	if (property->flags & DRM_MODE_PROP_BITMASK)
> +		if (((property->flags & DRM_MODE_PROP_32BIT_PAIR) && (value > 31)) ||
> +		    (value > 63))
> +			return -EINVAL;
>  
>  	if (!list_empty(&property->enum_blob_list)) {
>  		list_for_each_entry(prop_enum, &property->enum_blob_list, head) {
> @@ -3305,9 +3308,16 @@ static bool drm_property_change_is_valid(struct drm_property *property,
>  	} else if (property->flags & DRM_MODE_PROP_BITMASK) {
>  		int i;
>  		uint64_t valid_mask = 0;
> -		for (i = 0; i < property->num_values; i++)
> -			valid_mask |= (1ULL << property->values[i]);
> -		return !(value & ~valid_mask);
> +		uint32_t valid_32bit_mask = 0;
> +		if (property->flags & DRM_MODE_PROP_32BIT_PAIR) {
> +			for (i = 0; i < property->num_values; i++)
> +				valid_32bit_mask |= (1UL << property->values[i]);
> +			return !((value & 0xFFFFFFFF) & ~valid_32bit_mask);
> +		} else {
> +			for (i = 0; i < property->num_values; i++)
> +				valid_mask |= (1ULL << property->values[i]);
> +			return !(value & ~valid_mask);
> +		}
>  	} else if (property->flags & DRM_MODE_PROP_BLOB) {
>  		/* Only the driver knows */
>  		return true;
> diff --git a/include/uapi/drm/drm_mode.h b/include/uapi/drm/drm_mode.h
> index f104c26..5e3a7d9 100644
> --- a/include/uapi/drm/drm_mode.h
> +++ b/include/uapi/drm/drm_mode.h
> @@ -250,6 +250,9 @@ struct drm_mode_get_connector {
>  #define DRM_MODE_PROP_ENUM	(1<<3) /* enumerated type with text strings */
>  #define DRM_MODE_PROP_BLOB	(1<<4)
>  #define DRM_MODE_PROP_BITMASK	(1<<5) /* bitmask of enumerated types */
> +#define DRM_MODE_PROP_32BIT_PAIR (1<<6) /* 32 bit bitmask of enumerated types
> +					 * and 32 bit of value of the type */
> +
>  
>  struct drm_mode_property_enum {
>  	__u64 value;


