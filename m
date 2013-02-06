Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab3BFJSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 04:18:25 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:39350 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab3BFJST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 04:18:19 -0500
Date: Wed, 6 Feb 2013 10:20:30 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, intel-gfx@lists.freedesktop.org,
        linux-pm@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 3/3] drm/i915: support resume without VT
 switch v2
Message-ID: <20130206092030.GH5813@phenom.ffwll.local>
Mail-Followup-To: Jesse Barnes <jbarnes@virtuousgeek.org>,
	linux-kernel@vger.kernel.org, rjw@sisk.pl,
	intel-gfx@lists.freedesktop.org, linux-pm@vger.kernel.org
References: <1359985042-2610-1-git-send-email-jbarnes@virtuousgeek.org>
 <1359985042-2610-3-git-send-email-jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359985042-2610-3-git-send-email-jbarnes@virtuousgeek.org>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 01:37:22PM +0000, Jesse Barnes wrote:
> Add support for resuming the suspend configuration at resume time to
> avoid slow and ugly VT switches during suspend and resume.  Also emit a
> hotplug event at resume time to make sure any potential configuration
> changes (monitors coming and going, dock events) are handled properly.
> 
> v2: use new fb flag to indicate we don't need to VT switch
> 
> Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> ---
>  drivers/gpu/drm/i915/i915_drv.c      |   28 +++++++++++++++++++++++++---
>  drivers/gpu/drm/i915/i915_drv.h      |    1 +
>  drivers/gpu/drm/i915/intel_display.c |   25 +++++++++++++++++++++++++
>  drivers/gpu/drm/i915/intel_fb.c      |    3 +++
>  4 files changed, 54 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
> index 1172658..7dbaa01 100644
> --- a/drivers/gpu/drm/i915/i915_drv.c
> +++ b/drivers/gpu/drm/i915/i915_drv.c
> @@ -483,8 +483,6 @@ static int i915_drm_freeze(struct drm_device *dev)
>  
>  		cancel_delayed_work_sync(&dev_priv->rps.delayed_resume_work);
>  
> -		intel_modeset_disable(dev);
> -

You can't just drop this without replacement I think, check git blame for
why it's been added.

>  		drm_irq_uninstall(dev);
>  	}
>  
> @@ -544,6 +542,24 @@ void intel_console_resume(struct work_struct *work)
>  	console_unlock();
>  }
>  
> +static void intel_resume_hotplug(struct drm_device *dev)
> +{
> +	struct drm_mode_config *mode_config = &dev->mode_config;
> +	struct intel_encoder *encoder;
> +
> +	mutex_lock(&mode_config->mutex);
> +	DRM_DEBUG_KMS("running encoder hotplug functions\n");
> +
> +	list_for_each_entry(encoder, &mode_config->encoder_list, base.head)
> +		if (encoder->hot_plug)
> +			encoder->hot_plug(encoder);
> +
> +	mutex_unlock(&mode_config->mutex);
> +
> +	/* Just fire off a uevent and let userspace tell us what to do */
> +	drm_helper_hpd_irq_event(dev);
> +}

This should imo be in a separate patch, since afaict we don't bother with
this right now. And I guess we should figure out how this should be done
across drm drivers ...

> +
>  static int __i915_drm_thaw(struct drm_device *dev)
>  {
>  	struct drm_i915_private *dev_priv = dev->dev_private;
> @@ -563,8 +579,14 @@ static int __i915_drm_thaw(struct drm_device *dev)
>  		mutex_unlock(&dev->struct_mutex);
>  
>  		intel_modeset_init_hw(dev);
> -		intel_modeset_setup_hw_state(dev, false);

Since this doesn't add any delays (besides a few register reads), but adds
tons of paranoid checks for our state-handling: Why drop it? Dropping this
also explains why you get away with killing intel_modeset_disable without
swimming in a see of WARN_ONs ;-)

>  		drm_irq_install(dev);
> +
> +		/* Resume the modeset for every activated CRTC */
> +		mutex_lock(&dev->mode_config.mutex);
> +		intel_resume_force_mode(dev);
> +		mutex_unlock(&dev->mode_config.mutex);
> +
> +		intel_resume_hotplug(dev);
>  	}
>  
>  	intel_opregion_init(dev);
> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
> index 12ab3bd..c8b1896 100644
> --- a/drivers/gpu/drm/i915/i915_drv.h
> +++ b/drivers/gpu/drm/i915/i915_drv.h
> @@ -1680,6 +1680,7 @@ extern void gen6_set_rps(struct drm_device *dev, u8 val);
>  extern void intel_detect_pch(struct drm_device *dev);
>  extern int intel_trans_dp_port_sel(struct drm_crtc *crtc);
>  extern int intel_enable_rc6(const struct drm_device *dev);
> +extern int intel_resume_force_mode(struct drm_device *dev);
>  
>  extern bool i915_semaphore_is_enabled(struct drm_device *dev);
>  int i915_reg_read_ioctl(struct drm_device *dev, void *data,
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index da1ad9c..a127877 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -9369,6 +9369,31 @@ void intel_modeset_cleanup(struct drm_device *dev)
>  	drm_mode_config_cleanup(dev);
>  }
>  
> +int intel_resume_force_mode(struct drm_device *dev)
> +{
> +	struct drm_crtc *crtc;
> +	struct drm_encoder *encoder;
> +	struct drm_encoder_helper_funcs *encoder_funcs;
> +	struct drm_crtc_helper_funcs *crtc_funcs;
> +	int ret;
> +
> +	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
> +
> +		if (!crtc->enabled) {
> +			DRM_ERROR("skipping disabled crtc\n");
> +			continue;
> +		}
> +
> +		ret = intel_set_mode(crtc, &crtc->mode, crtc->x, crtc->y,
> +				     crtc->fb);
> +
> +		if (ret == false)
> +			DRM_ERROR("failed to set mode on crtc %p\n", crtc);
> +	}
> +
> +	return 0;
> +}

intel_modeset_setup_hw_state(dev, true); should do exactly this trick, see
the lid notifier in intel_lvds.c. That presumes though that you don't kill
the modeset state, which might require some changes in
intel_modeset_disable.

> +
>  /*
>   * Return which encoder is currently attached for connector.
>   */
> diff --git a/drivers/gpu/drm/i915/intel_fb.c b/drivers/gpu/drm/i915/intel_fb.c
> index 7b30b5c..d4955b5 100644
> --- a/drivers/gpu/drm/i915/intel_fb.c
> +++ b/drivers/gpu/drm/i915/intel_fb.c
> @@ -148,6 +148,9 @@ static int intelfb_create(struct intel_fbdev *ifbdev,
>  	}
>  	info->screen_size = size;
>  
> +	/* This driver doesn't need a VT switch to restore the mode on resume */
> +	info->skip_vt_switch = true;
> +
>  //	memset(info->screen_base, 0, size);

Follow-up patch to kill this // commented-line?

>  
>  	drm_fb_helper_fill_fix(info, fb->pitches[0], fb->depth);
> -- 
> 1.7.9.5
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
