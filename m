Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761509Ab3DCI2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:28:33 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:34559 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761373Ab3DCI2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:28:30 -0400
Date: Wed, 3 Apr 2013 10:31:24 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Subject: Re: linux-next: manual merge of the drm-intel tree with Linus' tree
Message-ID: <20130403083124.GG2228@phenom.ffwll.local>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jani Nikula <jani.nikula@intel.com>
References: <20130403134349.e009a401ab6ec761edbfedd7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130403134349.e009a401ab6ec761edbfedd7@canb.auug.org.au>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 01:43:49PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the drm-intel tree got a conflict in
> drivers/gpu/drm/i915/intel_panel.c between commit b1289371fcd5 ("Revert
> "drm/i915: write backlight harder"") from Linus' tree and commit
> 31ad8ec6a614 ("drm/i915: group backlight related stuff into a struct")
> from the drm-intel tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, I carry the same merge resolution locally.
-Daniel

> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/gpu/drm/i915/intel_panel.c
> index bee8cb6,0e7e873..0000000
> --- a/drivers/gpu/drm/i915/intel_panel.c
> +++ b/drivers/gpu/drm/i915/intel_panel.c
> @@@ -318,9 -321,16 +321,13 @@@ void intel_panel_enable_backlight(struc
>   {
>   	struct drm_i915_private *dev_priv = dev->dev_private;
>   
> - 	if (dev_priv->backlight_level == 0)
> - 		dev_priv->backlight_level = intel_panel_get_max_backlight(dev);
> + 	if (dev_priv->backlight.level == 0) {
> + 		dev_priv->backlight.level = intel_panel_get_max_backlight(dev);
> + 		if (dev_priv->backlight.device)
> + 			dev_priv->backlight.device->props.brightness =
> + 				dev_priv->backlight.level;
> + 	}
>   
>  -	dev_priv->backlight.enabled = true;
>  -	intel_panel_actually_set_backlight(dev, dev_priv->backlight.level);
>  -
>   	if (INTEL_INFO(dev)->gen >= 4) {
>   		uint32_t reg, tmp;
>   
> @@@ -356,12 -366,12 +363,12 @@@
>   	}
>   
>   set_level:
>  -	/* Check the current backlight level and try to set again if it's zero.
>  -	 * On some machines, BLC_PWM_CPU_CTL is cleared to zero automatically
>  -	 * when BLC_PWM_CPU_CTL2 and BLC_PWM_PCH_CTL1 are written.
>  +	/* Call below after setting BLC_PWM_CPU_CTL2 and BLC_PWM_PCH_CTL1.
>  +	 * BLC_PWM_CPU_CTL may be cleared to zero automatically when these
>  +	 * registers are set.
>   	 */
> - 	dev_priv->backlight_enabled = true;
> - 	intel_panel_actually_set_backlight(dev, dev_priv->backlight_level);
>  -	if (!intel_panel_get_backlight(dev))
>  -		intel_panel_actually_set_backlight(dev, dev_priv->backlight.level);
> ++	dev_priv->backlight.enabled = true;
> ++	intel_panel_actually_set_backlight(dev, dev_priv->backlight.level);
>   }
>   
>   static void intel_panel_init_backlight(struct drm_device *dev)



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
