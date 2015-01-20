Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbbATLNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:13:37 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:56119 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbbATLNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:13:35 -0500
Date: Tue, 20 Jan 2015 12:13:30 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/36] drm/plane: Add optional ->atomic_disable() callback
Message-ID: <20150120111330.GZ10113@phenom.ffwll.local>
Mail-Followup-To: Thierry Reding <thierry.reding@gmail.com>,
	dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
 <1421750935-4023-4-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421750935-4023-4-git-send-email-thierry.reding@gmail.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 11:48:22AM +0100, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> In order to prevent drivers from having to perform the same checks over
> and over again, add an optional ->atomic_disable callback which the core
> calls under the right circumstances.
> 
> v2: pass old state and detect edges to avoid calling ->atomic_disable on
> already disabled planes, remove redundant comment (Daniel Vetter)
> 
> v3: rename helper to drm_atomic_plane_disabling() to clarify that it is
> checking for transitions, move helper to drm_atomic_helper.h, clarify
> check for !old_state and its relation to transitional helpers
> 

I'd have pasted the entire thread from the discussion into the commit
message. But at least add a References: line for the mail that has all the
details would be good. Either way

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/gpu/drm/drm_atomic_helper.c |  9 ++++++++-
>  drivers/gpu/drm/drm_plane_helper.c  | 10 +++++++++-
>  include/drm/drm_atomic_helper.h     | 37 +++++++++++++++++++++++++++++++++++++
>  include/drm/drm_plane_helper.h      |  3 +++
>  4 files changed, 57 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
> index 010661f23035..1cb04402cd73 100644
> --- a/drivers/gpu/drm/drm_atomic_helper.c
> +++ b/drivers/gpu/drm/drm_atomic_helper.c
> @@ -1113,7 +1113,14 @@ void drm_atomic_helper_commit_planes(struct drm_device *dev,
>  
>  		old_plane_state = old_state->plane_states[i];
>  
> -		funcs->atomic_update(plane, old_plane_state);
> +		/*
> +		 * Special-case disabling the plane if drivers support it.
> +		 */
> +		if (drm_atomic_plane_disabling(plane, old_plane_state) &&
> +		    funcs->atomic_disable)
> +			funcs->atomic_disable(plane, old_plane_state);
> +		else
> +			funcs->atomic_update(plane, old_plane_state);
>  	}
>  
>  	for (i = 0; i < ncrtcs; i++) {
> diff --git a/drivers/gpu/drm/drm_plane_helper.c b/drivers/gpu/drm/drm_plane_helper.c
> index 2f961c180273..02c1a0b74e04 100644
> --- a/drivers/gpu/drm/drm_plane_helper.c
> +++ b/drivers/gpu/drm/drm_plane_helper.c
> @@ -449,7 +449,15 @@ int drm_plane_helper_commit(struct drm_plane *plane,
>  			crtc_funcs[i]->atomic_begin(crtc[i]);
>  	}
>  
> -	plane_funcs->atomic_update(plane, plane_state);
> +	/*
> +	 * Drivers may optionally implement the ->atomic_disable callback, so
> +	 * special-case that here.
> +	 */
> +	if (drm_atomic_plane_disabling(plane, plane_state) &&
> +	    plane_funcs->atomic_disable)
> +		plane_funcs->atomic_disable(plane, plane_state);
> +	else
> +		plane_funcs->atomic_update(plane, plane_state);
>  
>  	for (i = 0; i < 2; i++) {
>  		if (crtc_funcs[i] && crtc_funcs[i]->atomic_flush)
> diff --git a/include/drm/drm_atomic_helper.h b/include/drm/drm_atomic_helper.h
> index 2095917ff8c7..a0ea4ded3cb5 100644
> --- a/include/drm/drm_atomic_helper.h
> +++ b/include/drm/drm_atomic_helper.h
> @@ -127,4 +127,41 @@ void drm_atomic_helper_connector_destroy_state(struct drm_connector *connector,
>  #define drm_atomic_crtc_state_for_each_plane(plane, crtc_state) \
>  	drm_for_each_plane_mask(plane, (crtc_state)->state->dev, (crtc_state)->plane_mask)
>  
> +/*
> + * drm_atomic_plane_disabling - check whether a plane is being disabled
> + * @plane: plane object
> + * @old_state: previous atomic state
> + *
> + * Checks the atomic state of a plane to determine whether it's being disabled
> + * or not. This also WARNs if it detects an invalid state (both CRTC and FB
> + * need to either both be NULL or both be non-NULL).
> + *
> + * RETURNS:
> + * True if the plane is being disabled, false otherwise.
> + */
> +static inline bool
> +drm_atomic_plane_disabling(struct drm_plane *plane,
> +			   struct drm_plane_state *old_state)
> +{
> +	/*
> +	 * When disabling a plane, CRTC and FB should always be NULL together.
> +	 * Anything else should be considered a bug in the atomic core, so we
> +	 * gently warn about it.
> +	 */
> +	WARN_ON((plane->state->crtc == NULL && plane->state->fb != NULL) ||
> +		(plane->state->crtc != NULL && plane->state->fb == NULL));
> +
> +	/*
> +	 * When using the transitional helpers, old_state may be NULL. If so,
> +	 * we know nothing about the current state and have to assume that it
> +	 * might be enabled.
> +	 *
> +	 * When using the atomic helpers, old_state won't be NULL. Therefore
> +	 * this check assumes that either the driver will have reconstructed
> +	 * the correct state in ->reset() or that the driver will have taken
> +	 * appropriate measures to disable all planes.
> +	 */
> +	return (!old_state || old_state->crtc) && !plane->state->crtc;
> +}
> +
>  #endif /* DRM_ATOMIC_HELPER_H_ */
> diff --git a/include/drm/drm_plane_helper.h b/include/drm/drm_plane_helper.h
> index 0f2230311aa8..680be61ef20a 100644
> --- a/include/drm/drm_plane_helper.h
> +++ b/include/drm/drm_plane_helper.h
> @@ -52,6 +52,7 @@ int drm_crtc_init(struct drm_device *dev, struct drm_crtc *crtc,
>   * @cleanup_fb: cleanup a framebuffer when it's no longer used by the plane
>   * @atomic_check: check that a given atomic state is valid and can be applied
>   * @atomic_update: apply an atomic state to the plane
> + * @atomic_disable: disable the plane
>   *
>   * The helper operations are called by the mid-layer CRTC helper.
>   */
> @@ -65,6 +66,8 @@ struct drm_plane_helper_funcs {
>  			    struct drm_plane_state *state);
>  	void (*atomic_update)(struct drm_plane *plane,
>  			      struct drm_plane_state *old_state);
> +	void (*atomic_disable)(struct drm_plane *plane,
> +			       struct drm_plane_state *old_state);
>  };
>  
>  static inline void drm_plane_helper_add(struct drm_plane *plane,
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
