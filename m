Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbaIAJOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:14:21 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:44523 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbaIAJOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:14:18 -0400
Date: Mon, 1 Sep 2014 11:14:40 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [drm/i915/3.17] panic in i915_digport_work_func
Message-ID: <20140901091440.GW15520@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	Mike Galbraith <umgwanakikbuti@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Dave Airlie <airlied@redhat.com>
References: <1409382202.5141.36.camel@marge.simpson.net>
 <1409486735.4991.19.camel@marge.simpson.net>
 <CAPM=9txZ5mS3u-7FrjCMF6T3sATfAU2Y+fpyXi-REPWXExBajA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9txZ5mS3u-7FrjCMF6T3sATfAU2Y+fpyXi-REPWXExBajA@mail.gmail.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 05:02:51PM +1000, Dave Airlie wrote:
> >     drm/i915: add DP 1.2 MST support (v0.7)
> >
> >     This adds DP 1.2 MST support on Haswell systems.
> >
> I've attached a patch that might fix this, please test and let me know.
> 
> Dave.

> From d407c946fbf5c48f30160591f5bd71fbe158aeb4 Mon Sep 17 00:00:00 2001
> From: Dave Airlie <airlied@redhat.com>
> Date: Mon, 1 Sep 2014 16:58:12 +1000
> Subject: [PATCH] drm/i915: handle G45/GM45 pulse detection connected state.
> 
> In the HPD pulse handler we check for long pulses if the port is actually
> connected, however we do that for IBX, but we use the pulse handling code on
> GM45 systems as well, so we need to use a diffent check.
> 
> This patch refactors the digital port connected check out of the g4x detection
> path and reuses it in the hpd pulse path.
> 
> Should fix:
> Message-ID: <1409382202.5141.36.camel@marge.simpson.net>
> 
> Reported-by: Mike Galbraith <umgwanakikbuti@gmail.com>
> Signed-off-by: Dave Airlie <airlied@redhat.com>

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
>  drivers/gpu/drm/i915/intel_dp.c | 55 +++++++++++++++++++++++++++--------------
>  1 file changed, 37 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
> index 67cfed6..81d7681 100644
> --- a/drivers/gpu/drm/i915/intel_dp.c
> +++ b/drivers/gpu/drm/i915/intel_dp.c
> @@ -3661,24 +3661,12 @@ ironlake_dp_detect(struct intel_dp *intel_dp)
>  	return intel_dp_detect_dpcd(intel_dp);
>  }
>  
> -static enum drm_connector_status
> -g4x_dp_detect(struct intel_dp *intel_dp)
> +static int g4x_digital_port_connected(struct drm_device *dev,
> +				       struct intel_digital_port *intel_dig_port)
>  {
> -	struct drm_device *dev = intel_dp_to_dev(intel_dp);
>  	struct drm_i915_private *dev_priv = dev->dev_private;
> -	struct intel_digital_port *intel_dig_port = dp_to_dig_port(intel_dp);
>  	uint32_t bit;
>  
> -	/* Can't disconnect eDP, but you can close the lid... */
> -	if (is_edp(intel_dp)) {
> -		enum drm_connector_status status;
> -
> -		status = intel_panel_detect(dev);
> -		if (status == connector_status_unknown)
> -			status = connector_status_connected;
> -		return status;
> -	}
> -
>  	if (IS_VALLEYVIEW(dev)) {
>  		switch (intel_dig_port->port) {
>  		case PORT_B:
> @@ -3691,7 +3679,7 @@ g4x_dp_detect(struct intel_dp *intel_dp)
>  			bit = PORTD_HOTPLUG_LIVE_STATUS_VLV;
>  			break;
>  		default:
> -			return connector_status_unknown;
> +			return -EINVAL;
>  		}
>  	} else {
>  		switch (intel_dig_port->port) {
> @@ -3705,11 +3693,36 @@ g4x_dp_detect(struct intel_dp *intel_dp)
>  			bit = PORTD_HOTPLUG_LIVE_STATUS_G4X;
>  			break;
>  		default:
> -			return connector_status_unknown;
> +			return -EINVAL;
>  		}
>  	}
>  
>  	if ((I915_READ(PORT_HOTPLUG_STAT) & bit) == 0)
> +		return 0;
> +	return 1;
> +}
> +
> +static enum drm_connector_status
> +g4x_dp_detect(struct intel_dp *intel_dp)
> +{
> +	struct drm_device *dev = intel_dp_to_dev(intel_dp);
> +	struct intel_digital_port *intel_dig_port = dp_to_dig_port(intel_dp);
> +	int ret;
> +
> +	/* Can't disconnect eDP, but you can close the lid... */
> +	if (is_edp(intel_dp)) {
> +		enum drm_connector_status status;
> +
> +		status = intel_panel_detect(dev);
> +		if (status == connector_status_unknown)
> +			status = connector_status_connected;
> +		return status;
> +	}
> +
> +	ret = g4x_digital_port_connected(dev, intel_dig_port);
> +	if (ret == -EINVAL)
> +		return connector_status_unknown;
> +	else if (ret == 0)
>  		return connector_status_disconnected;
>  
>  	return intel_dp_detect_dpcd(intel_dp);
> @@ -4066,8 +4079,14 @@ intel_dp_hpd_pulse(struct intel_digital_port *intel_dig_port, bool long_hpd)
>  	intel_display_power_get(dev_priv, power_domain);
>  
>  	if (long_hpd) {
> -		if (!ibx_digital_port_connected(dev_priv, intel_dig_port))
> -			goto mst_fail;
> +
> +		if (HAS_PCH_SPLIT(dev)) {
> +			if (!ibx_digital_port_connected(dev_priv, intel_dig_port))
> +				goto mst_fail;
> +		} else {
> +			if (g4x_digital_port_connected(dev, intel_dig_port) != 1)
> +				goto mst_fail;
> +		}
>  
>  		if (!intel_dp_get_dpcd(intel_dp)) {
>  			goto mst_fail;
> -- 
> 1.9.3
> 


-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
