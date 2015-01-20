Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbbATLKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:10:21 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:59762 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbbATLKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:10:15 -0500
Date: Tue, 20 Jan 2015 12:10:11 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/36] drm/atomic: Add drm_atomic_plane_get_crtc_state()
Message-ID: <20150120111011.GX10113@phenom.ffwll.local>
Mail-Followup-To: Thierry Reding <thierry.reding@gmail.com>,
	dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
 <1421750935-4023-6-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421750935-4023-6-git-send-email-thierry.reding@gmail.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 11:48:24AM +0100, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> This function is useful to obtain the state of the CRTC that a plane is
> being attached to.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  include/drm/drm_atomic.h | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/include/drm/drm_atomic.h b/include/drm/drm_atomic.h
> index 51168a8b723a..ddca107e5cce 100644
> --- a/include/drm/drm_atomic.h
> +++ b/include/drm/drm_atomic.h
> @@ -75,4 +75,25 @@ int __must_check drm_atomic_check_only(struct drm_atomic_state *state);
>  int __must_check drm_atomic_commit(struct drm_atomic_state *state);
>  int __must_check drm_atomic_async_commit(struct drm_atomic_state *state);
>  
> +/**
> + * drm_atomic_plane_get_crtc_state - obtain atomic state of the CRTC that a
> + *     plane is being attached to
> + * @state: atomic state of plane
> + *
> + * Getting the atomic state of the CRTC that a given plane being attached to
> + * is non-trivial. We need to look at the global atomic state that the plane
> + * state is part of and extract the CRTC state using the CRTC's index. Using
> + * the drm_atomic_get_crtc_state() helper we make sure to acquire the proper
> + * locks, too.
> + *
> + * RETURNS:
> + * The atomic state of the CRTC that the plane is being attached to, or an
> + * ERR_PTR()-encoded negative error code on failure.
> + */
> +static inline struct drm_crtc_state *
> +drm_atomic_plane_get_crtc_state(struct drm_plane_state *state)
> +{
> +	return drm_atomic_get_crtc_state(state->state, state->crtc);

Hm, imo open-coding this is totally ok. Actually better since state->crtc
might be NULL, and hiding that isn't a good idea.

If you have a atomic_plane_disable hook then ->crtc is guaranteed to be
non-NULL in atomic_plane_update, but being explicit here is imo a feature.
So nacked from my side.
-Daniel

> +}
> +
>  #endif /* DRM_ATOMIC_H_ */
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
