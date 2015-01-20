Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbbATLHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:07:25 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54847 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbbATLHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:07:24 -0500
Date: Tue, 20 Jan 2015 12:07:19 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/36] drm/atomic: Add ->atomic_check() to encoder helpers
Message-ID: <20150120110719.GW10113@phenom.ffwll.local>
Mail-Followup-To: Thierry Reding <thierry.reding@gmail.com>,
	dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
 <1421750935-4023-5-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421750935-4023-5-git-send-email-thierry.reding@gmail.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 11:48:23AM +0100, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> This callback can be used instead of the legacy ->mode_fixup() and is
> passed the CRTC and connector states. It can thus use these states to
> validate the modeset and cache values in the state to be used during
> the actual modeset.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Yeah, this addition makes sense.

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

> ---
>  drivers/gpu/drm/drm_atomic_helper.c | 23 ++++++++++++++++-------
>  include/drm/drm_crtc_helper.h       |  6 ++++++
>  2 files changed, 22 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
> index 1cb04402cd73..b837d148d880 100644
> --- a/drivers/gpu/drm/drm_atomic_helper.c
> +++ b/drivers/gpu/drm/drm_atomic_helper.c
> @@ -297,13 +297,22 @@ mode_fixup(struct drm_atomic_state *state)
>  			}
>  		}
>  
> -
> -		ret = funcs->mode_fixup(encoder, &crtc_state->mode,
> -					&crtc_state->adjusted_mode);
> -		if (!ret) {
> -			DRM_DEBUG_KMS("[ENCODER:%d:%s] fixup failed\n",
> -				      encoder->base.id, encoder->name);
> -			return -EINVAL;
> +		if (funcs->atomic_check) {
> +			ret = funcs->atomic_check(encoder, crtc_state,
> +						  conn_state);
> +			if (ret) {
> +				DRM_DEBUG_KMS("[ENCODER:%d:%s] check failed\n",
> +					      encoder->base.id, encoder->name);
> +				return ret;
> +			}
> +		} else {
> +			ret = funcs->mode_fixup(encoder, &crtc_state->mode,
> +						&crtc_state->adjusted_mode);
> +			if (!ret) {
> +				DRM_DEBUG_KMS("[ENCODER:%d:%s] fixup failed\n",
> +					      encoder->base.id, encoder->name);
> +				return -EINVAL;
> +			}
>  		}
>  	}
>  
> diff --git a/include/drm/drm_crtc_helper.h b/include/drm/drm_crtc_helper.h
> index e76828d81a8b..5810c027acdc 100644
> --- a/include/drm/drm_crtc_helper.h
> +++ b/include/drm/drm_crtc_helper.h
> @@ -115,6 +115,7 @@ struct drm_crtc_helper_funcs {
>   * @get_crtc: return CRTC that the encoder is currently attached to
>   * @detect: connection status detection
>   * @disable: disable encoder when not in use (overrides DPMS off)
> + * @atomic_check: check for validity of an atomic update
>   *
>   * The helper operations are called by the mid-layer CRTC helper.
>   */
> @@ -137,6 +138,11 @@ struct drm_encoder_helper_funcs {
>  					    struct drm_connector *connector);
>  	/* disable encoder when not in use - more explicit than dpms off */
>  	void (*disable)(struct drm_encoder *encoder);
> +
> +	/* atomic helpers */
> +	int (*atomic_check)(struct drm_encoder *encoder,
> +			    struct drm_crtc_state *crtc_state,
> +			    struct drm_connector_state *conn_state);
>  };
>  
>  /**
> -- 
> 2.1.3
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
