Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934617Ab3CZPK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:10:26 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:58446 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759810Ab3CZPKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:10:24 -0400
Date: Tue, 26 Mar 2013 16:13:13 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Danny Baumann <dannybaumann@web.de>
Cc: David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/1] drm/i915: Allow specifying a minimum brightness
 level for sysfs control.
Message-ID: <20130326151313.GU9021@phenom.ffwll.local>
Mail-Followup-To: Danny Baumann <dannybaumann@web.de>,
	David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <1364298525-4337-1-git-send-email-dannybaumann@web.de>
 <1364298525-4337-2-git-send-email-dannybaumann@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364298525-4337-2-git-send-email-dannybaumann@web.de>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 12:48:45PM +0100, Danny Baumann wrote:
> When controlling backlight devices via sysfs interface, user space
> generally assumes the minimum level (0) still providing a brightness
> that is usable by the user (probably due to the most commonly used
> backlight device, acpi_videoX, behaving exactly like that). This doesn't
> match the current behaviour of the intel_backlight control, though, as
> the value 0 means 'backlight off'.
> 
> In order to make intel_backlight consistent to other backlight devices,
> introduce a module parameter that allows shifting the 0 level of the
> intel_backlight device. It's expressed in percentages of the maximum
> level. The default is 5, which provides a backlight level that is barely
> readable. Setting it to 0 restores the old behaviour.
> 
> Signed-off-by: Danny Baumann <dannybaumann@web.de>

Thus far our assumption always was that the acpi backlight works better
than the intel native backlight. So everything only uses the intel
backlight if there's no other backlight driver by default.

So if I should merge this as a general solution for Windows 8 machines not
working properly, we first need to figure out what windows does on these
machines and either disable the acpi backlight or adapt it.

Adding more kernel options is not a viable solution for the backlight mess
imo.
-Daniel

> ---
>  drivers/gpu/drm/i915/intel_panel.c | 48 ++++++++++++++++++++++++++++++++------
>  1 file changed, 41 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
> index bee8cb6..5bad49d 100644
> --- a/drivers/gpu/drm/i915/intel_panel.c
> +++ b/drivers/gpu/drm/i915/intel_panel.c
> @@ -395,10 +395,35 @@ intel_panel_detect(struct drm_device *dev)
>  }
>  
>  #ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
> +
> +static int i915_panel_min_brightness_percent = 5;
> +MODULE_PARM_DESC(min_sysfs_brightness, "Minimum brightness percentage settable "
> +	"via sysfs. This adjusts the brightness level of the value '0' in the "
> +	"intel_backlight sysfs backlight interface.");
> +module_param_named(min_sysfs_brightness,
> +		   i915_panel_min_brightness_percent, int, 0400);
> +
> +static int intel_panel_min_brightness(struct drm_device *dev)
> +{
> +	int max;
> +
> +	if (i915_panel_min_brightness_percent <= 0)
> +		return 0;
> +
> +	max = intel_panel_get_max_backlight(dev);
> +	if (i915_panel_min_brightness_percent >= 100)
> +		return max;
> +
> +	return max * i915_panel_min_brightness_percent / 100;
> +}
> +
>  static int intel_panel_update_status(struct backlight_device *bd)
>  {
>  	struct drm_device *dev = bl_get_data(bd);
> -	intel_panel_set_backlight(dev, bd->props.brightness);
> +	int brightness =
> +		bd->props.brightness + intel_panel_min_brightness(dev);
> +
> +	intel_panel_set_backlight(dev, brightness);
>  	return 0;
>  }
>  
> @@ -406,7 +431,10 @@ static int intel_panel_get_brightness(struct backlight_device *bd)
>  {
>  	struct drm_device *dev = bl_get_data(bd);
>  	struct drm_i915_private *dev_priv = dev->dev_private;
> -	return dev_priv->backlight_level;
> +	int brightness =
> +		dev_priv->backlight_level - intel_panel_min_brightness(dev);
> +
> +	return brightness;
>  }
>  
>  static const struct backlight_ops intel_panel_bl_ops = {
> @@ -419,16 +447,21 @@ int intel_panel_setup_backlight(struct drm_connector *connector)
>  	struct drm_device *dev = connector->dev;
>  	struct drm_i915_private *dev_priv = dev->dev_private;
>  	struct backlight_properties props;
> +	int max_brightness;
>  
>  	intel_panel_init_backlight(dev);
>  
> -	memset(&props, 0, sizeof(props));
> -	props.type = BACKLIGHT_RAW;
> -	props.max_brightness = _intel_panel_get_max_backlight(dev);
> -	if (props.max_brightness == 0) {
> +	max_brightness = _intel_panel_get_max_backlight(dev);
> +	if (max_brightness == 0) {
>  		DRM_DEBUG_DRIVER("Failed to get maximum backlight value\n");
>  		return -ENODEV;
>  	}
> +
> +	memset(&props, 0, sizeof(props));
> +	props.type = BACKLIGHT_RAW;
> +	props.max_brightness =
> +		max_brightness - intel_panel_min_brightness(dev);
> +
>  	dev_priv->backlight =
>  		backlight_device_register("intel_backlight",
>  					  &connector->kdev, dev,
> @@ -440,7 +473,8 @@ int intel_panel_setup_backlight(struct drm_connector *connector)
>  		dev_priv->backlight = NULL;
>  		return -ENODEV;
>  	}
> -	dev_priv->backlight->props.brightness = intel_panel_get_backlight(dev);
> +	dev_priv->backlight->props.brightness = intel_panel_get_backlight(dev)
> +		- intel_panel_min_brightness(dev);
>  	return 0;
>  }
>  
> -- 
> 1.8.1.4
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
