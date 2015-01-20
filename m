Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbbATLSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:18:52 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:36385 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbbATLSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:18:49 -0500
Date: Tue, 20 Jan 2015 12:18:45 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 34/36] drm/tegra: Track active planes in CRTC state
Message-ID: <20150120111845.GA10113@phenom.ffwll.local>
Mail-Followup-To: Thierry Reding <thierry.reding@gmail.com>,
	dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
 <1421750935-4023-35-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421750935-4023-35-git-send-email-thierry.reding@gmail.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 11:48:53AM +0100, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Wrap struct drm_crtc_state in a driver-specific structure and add the
> planes field which keeps track of which planes are updated or disabled
> during a modeset. This allows atomic updates of the the display engine
> at ->atomic_flush() time.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

commit 6ddd388ab222b66b596342becc76d5031c0e2fc8
Author: Rob Clark <robdclark@gmail.com>
Date:   Fri Nov 21 15:28:31 2014 -0500

    drm/atomic: track bitmask of planes attached to crtc

added this to the core since it seems to be generally useful. Does tegra
need more?
-Daniel

> ---
>  drivers/gpu/drm/tegra/dc.c | 72 ++++++++++++++++++++++++++++------------------
>  1 file changed, 44 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
> index 52ae563cb531..835de4398c8f 100644
> --- a/drivers/gpu/drm/tegra/dc.c
> +++ b/drivers/gpu/drm/tegra/dc.c
> @@ -54,6 +54,8 @@ struct tegra_dc_state {
>  	struct clk *clk;
>  	unsigned long pclk;
>  	unsigned int div;
> +
> +	u32 planes;
>  };
>  
>  static inline struct tegra_dc_state *to_dc_state(struct drm_crtc_state *state)
> @@ -64,20 +66,6 @@ static inline struct tegra_dc_state *to_dc_state(struct drm_crtc_state *state)
>  	return NULL;
>  }
>  
> -static void tegra_dc_window_commit(struct tegra_dc *dc, unsigned int index)
> -{
> -	u32 value = WIN_A_ACT_REQ << index;
> -
> -	tegra_dc_writel(dc, value << 8, DC_CMD_STATE_CONTROL);
> -	tegra_dc_writel(dc, value, DC_CMD_STATE_CONTROL);
> -}
> -
> -static void tegra_dc_cursor_commit(struct tegra_dc *dc)
> -{
> -	tegra_dc_writel(dc, CURSOR_ACT_REQ << 8, DC_CMD_STATE_CONTROL);
> -	tegra_dc_writel(dc, CURSOR_ACT_REQ, DC_CMD_STATE_CONTROL);
> -}
> -
>  /*
>   * Reads the active copy of a register. This takes the dc->lock spinlock to
>   * prevent races with the VBLANK processing which also needs access to the
> @@ -395,8 +383,6 @@ static void tegra_dc_setup_window(struct tegra_dc *dc, unsigned int index,
>  		break;
>  	}
>  
> -	tegra_dc_window_commit(dc, index);
> -
>  	spin_unlock_irqrestore(&dc->lock, flags);
>  }
>  
> @@ -439,9 +425,28 @@ static void tegra_plane_cleanup_fb(struct drm_plane *plane,
>  {
>  }
>  
> +static int tegra_plane_state_add(struct tegra_plane *plane,
> +				 struct drm_plane_state *state)
> +{
> +	struct drm_crtc_state *crtc_state;
> +	struct tegra_dc_state *tegra;
> +
> +	/* Propagate errors from allocation or locking failures. */
> +	crtc_state = drm_atomic_plane_get_crtc_state(state);
> +	if (IS_ERR(crtc_state))
> +		return PTR_ERR(crtc_state);
> +
> +	tegra = to_dc_state(crtc_state);
> +
> +	tegra->planes |= WIN_A_ACT_REQ << plane->index;
> +
> +	return 0;
> +}
> +
>  static int tegra_plane_atomic_check(struct drm_plane *plane,
>  				    struct drm_plane_state *state)
>  {
> +	struct tegra_plane *tegra = to_tegra_plane(plane);
>  	struct tegra_dc *dc = to_tegra_dc(state->crtc);
>  	struct tegra_bo_tiling tiling;
>  	int err;
> @@ -472,6 +477,10 @@ static int tegra_plane_atomic_check(struct drm_plane *plane,
>  		}
>  	}
>  
> +	err = tegra_plane_state_add(tegra, state);
> +	if (err < 0)
> +		return err;
> +
>  	return 0;
>  }
>  
> @@ -538,8 +547,6 @@ static void tegra_plane_atomic_disable(struct drm_plane *plane,
>  	value &= ~WIN_ENABLE;
>  	tegra_dc_writel(dc, value, DC_WIN_WIN_OPTIONS);
>  
> -	tegra_dc_window_commit(dc, p->index);
> -
>  	spin_unlock_irqrestore(&dc->lock, flags);
>  }
>  
> @@ -599,6 +606,9 @@ static const u32 tegra_cursor_plane_formats[] = {
>  static int tegra_cursor_atomic_check(struct drm_plane *plane,
>  				     struct drm_plane_state *state)
>  {
> +	struct tegra_plane *tegra = to_tegra_plane(plane);
> +	int err;
> +
>  	/* no need for further checks if the plane is being disabled */
>  	if (!state->crtc)
>  		return 0;
> @@ -616,6 +626,10 @@ static int tegra_cursor_atomic_check(struct drm_plane *plane,
>  	    state->crtc_w != 128 && state->crtc_w != 256)
>  		return -EINVAL;
>  
> +	err = tegra_plane_state_add(tegra, state);
> +	if (err < 0)
> +		return err;
> +
>  	return 0;
>  }
>  
> @@ -680,9 +694,6 @@ static void tegra_cursor_atomic_update(struct drm_plane *plane,
>  	value = (state->crtc_y & 0x3fff) << 16 | (state->crtc_x & 0x3fff);
>  	tegra_dc_writel(dc, value, DC_DISP_CURSOR_POSITION);
>  
> -	/* apply changes */
> -	tegra_dc_cursor_commit(dc);
> -	tegra_dc_commit(dc);
>  }
>  
>  static void tegra_cursor_atomic_disable(struct drm_plane *plane,
> @@ -700,9 +711,6 @@ static void tegra_cursor_atomic_disable(struct drm_plane *plane,
>  	value = tegra_dc_readl(dc, DC_DISP_DISP_WIN_OPTIONS);
>  	value &= ~CURSOR_ENABLE;
>  	tegra_dc_writel(dc, value, DC_DISP_DISP_WIN_OPTIONS);
> -
> -	tegra_dc_cursor_commit(dc);
> -	tegra_dc_commit(dc);
>  }
>  
>  static const struct drm_plane_funcs tegra_cursor_plane_funcs = {
> @@ -734,6 +742,13 @@ static struct drm_plane *tegra_dc_cursor_plane_create(struct drm_device *drm,
>  	if (!plane)
>  		return ERR_PTR(-ENOMEM);
>  
> +	/*
> +	 * We'll treat the cursor as an overlay plane with index 6 here so
> +	 * that the update and activation request bits in DC_CMD_STATE_CONTROL
> +	 * match up.
> +	 */
> +	plane->index = 6;
> +
>  	num_formats = ARRAY_SIZE(tegra_cursor_plane_formats);
>  	formats = tegra_cursor_plane_formats;
>  
> @@ -1029,7 +1044,6 @@ static void tegra_crtc_disable(struct drm_crtc *crtc)
>  	}
>  
>  	drm_crtc_vblank_off(crtc);
> -	tegra_dc_commit(dc);
>  }
>  
>  static bool tegra_crtc_mode_fixup(struct drm_crtc *crtc,
> @@ -1207,10 +1221,7 @@ static void tegra_crtc_prepare(struct drm_crtc *crtc)
>  
>  static void tegra_crtc_commit(struct drm_crtc *crtc)
>  {
> -	struct tegra_dc *dc = to_tegra_dc(crtc);
> -
>  	drm_crtc_vblank_on(crtc);
> -	tegra_dc_commit(dc);
>  }
>  
>  static int tegra_crtc_atomic_check(struct drm_crtc *crtc,
> @@ -1235,6 +1246,11 @@ static void tegra_crtc_atomic_begin(struct drm_crtc *crtc)
>  
>  static void tegra_crtc_atomic_flush(struct drm_crtc *crtc)
>  {
> +	struct tegra_dc_state *state = to_dc_state(crtc->state);
> +	struct tegra_dc *dc = to_tegra_dc(crtc);
> +
> +	tegra_dc_writel(dc, state->planes << 8, DC_CMD_STATE_CONTROL);
> +	tegra_dc_writel(dc, state->planes, DC_CMD_STATE_CONTROL);
>  }
>  
>  static const struct drm_crtc_helper_funcs tegra_crtc_helper_funcs = {
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
