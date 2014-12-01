Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaLAJfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 04:35:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:14393 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbaLAJfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 04:35:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,492,1413270000"; 
   d="scan'208";a="646103243"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Jay Aurabind <mail@aurabindo.in>, Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915 Trouble with minimum brightness
In-Reply-To: <5478C9AA.2010600@aurabindo.in>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <5478C9AA.2010600@aurabindo.in>
User-Agent: Notmuch/0.19~rc1+1~g08b4944 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 01 Dec 2014 11:34:55 +0200
Message-ID: <87k32bbtmo.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2014, Jay Aurabind <mail@aurabindo.in> wrote:
> Hello all,
>
> I notice that some activity has been going on with the minimum value
> of display brightness recently (e1c412e7575).
>
> But the minimum value thats currently chosen is not at all acceptable
> for my eyes. My display is working perfectly without that restriction
> on minimum intensity.  I tend to stare at the screen a lot and the
> current minimum settings is straining my eyes.
>
> Even if you say that it may not be good for the devices, I still
> insist, because I want my *display* to fail first, not my eyes.  So
> please try providing a way for the needy users to override this
> minimum settings. I hope adding a module parameter would be easy fix.
>
> Something like this: ? (I dont call myself a kernel programmer yet,
> just scratching the surface)
>
>
> Provide provision for users to disable restriction on minimum brightness
> value introduced in:
>
>     commit e1c412e75754ab7b7002f3e18a2652d999c40d4b
>     Author: Jani Nikula <jani.nikula@intel.com>
>     Date:   Wed Nov 5 14:46:31 2014 +0200
>
>         drm/i915: safeguard against too high minimum brightness
>
> There are systems which work reliably without restriction on minimum
> value of display brightness. Also the arbitrary value may be too high
> for many users as well.

Please file a new bug at [1], reference this mail, and attach
/sys/kernel/debug/dri/0/i915_opregion.

The minimum value is chosen and provided by the OEM. There's still some
open questions about the interpretation of the value though (which lead
to the commit you referenced), so I'm hesitant to make changes before we
have those cleared up.

In general I am not fond of adding new module parameters for tuning
things. Every new knob is another point of failure that we need to test,
and they are pretty much part of the ABI we can't easily drop or change.

BR,
Jani.

[1] https://bugs.freedesktop.org/enter_bug.cgi?product=DRI&component=DRM/Intel


>
> Signed-off-by: Aurabindo J <mail@aurabindo.in>
> ---
>  drivers/gpu/drm/i915/i915_drv.h    |  1 +
>  drivers/gpu/drm/i915/i915_params.c |  6 ++++++
>  drivers/gpu/drm/i915/intel_panel.c | 14 ++++++++++----
>  3 files changed, 17 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
> index 16a6f6d..55d2ead 100644
> --- a/drivers/gpu/drm/i915/i915_drv.h
> +++ b/drivers/gpu/drm/i915/i915_drv.h
> @@ -2213,6 +2213,7 @@ struct i915_params {
>  	int disable_power_well;
>  	int enable_ips;
>  	int invert_brightness;
> +	int restrict_min_brightness;
>  	int enable_cmd_parser;
>  	/* leave bools at the end to not create holes */
>  	bool enable_hangcheck;
> diff --git a/drivers/gpu/drm/i915/i915_params.c b/drivers/gpu/drm/i915/i915_params.c
> index c91cb20..0601c2a 100644
> --- a/drivers/gpu/drm/i915/i915_params.c
> +++ b/drivers/gpu/drm/i915/i915_params.c
> @@ -46,6 +46,7 @@ struct i915_params i915 __read_mostly = {
>  	.prefault_disable = 0,
>  	.reset = true,
>  	.invert_brightness = 0,
> +	.restrict_min_brightness = 1,
>  	.disable_display = 0,
>  	.enable_cmd_parser = 1,
>  	.disable_vtd_wa = 0,
> @@ -155,6 +156,11 @@ MODULE_PARM_DESC(invert_brightness,
>  	"to dri-devel@lists.freedesktop.org, if your machine needs it. "
>  	"It will then be included in an upcoming module version.");
>
> +module_param_named(restrict_min_brightness, i915.restrict_min_brightness, int, 0600);
> +MODULE_PARM_DESC(restrict_min_brightness,
> +	"Restrict minimum brightness "
> +	"(-1 disable restriction, 0 value from VBT, 1 arbitrary value )");
> +
>  module_param_named(disable_display, i915.disable_display, bool, 0600);
>  MODULE_PARM_DESC(disable_display, "Disable display (default: false)");
>
> diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
> index 41b3be2..def9f4e 100644
> --- a/drivers/gpu/drm/i915/intel_panel.c
> +++ b/drivers/gpu/drm/i915/intel_panel.c
> @@ -1109,10 +1109,16 @@ static u32 get_backlight_min_vbt(struct intel_connector *connector)
>  	 * against this by letting the minimum be at most (arbitrarily chosen)
>  	 * 25% of the max.
>  	 */
> -	min = clamp_t(int, dev_priv->vbt.backlight.min_brightness, 0, 64);
> -	if (min != dev_priv->vbt.backlight.min_brightness) {
> -		DRM_DEBUG_KMS("clamping VBT min backlight %d/255 to %d/255\n",
> -			      dev_priv->vbt.backlight.min_brightness, min);
> +	if (i915.restrict_min_brightness < 0)
> +		min = 0;
> +	else if (i915.restrict_min_brightness == 0)
> +		min = dev_priv->vbt.backlight.min_brightness;
> +	else {
> +		min = clamp_t(int, dev_priv->vbt.backlight.min_brightness, 0, 64);
> +		if (min != dev_priv->vbt.backlight.min_brightness) {
> +			DRM_DEBUG_KMS("clamping VBT min backlight %d/255 to %d/255\n",
> +					dev_priv->vbt.backlight.min_brightness, min);
> +	    }
>  	}
>
>  	/* vbt value is a coefficient in range [0..255] */
> -- 
> 2.1.3
>
>
>
>
>

-- 
Jani Nikula, Intel Open Source Technology Center
