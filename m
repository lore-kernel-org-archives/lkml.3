Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaBXQVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:21:48 -0500
Received: from oproxy14-pub.mail.unifiedlayer.com ([67.222.51.224]:41482 "HELO
	oproxy14-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753189AbaBXQVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:21:45 -0500
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Feb 2014 11:21:45 EST
Date: Mon, 24 Feb 2014 08:15:22 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: 3.13 i915 brightness settings broken when going from docked ->
 undocked
Message-ID: <20140224081522.7965819e@jbarnes-desktop>
In-Reply-To: <20140223155059.GA11167@zod>
References: <CA+5PVA4zC1+TPWWdANnm7RuBDduwNetdTknfzSkVTpFcPSGZww@mail.gmail.com>
	<CA+5PVA6Td43Zzd8L59_mE7E5hFuVSxhAwd+tczs_BSHXNOx5yw@mail.gmail.com>
	<20140223155059.GA11167@zod>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Feb 2014 10:50:59 -0500
Josh Boyer <jwboyer@fedoraproject.org> wrote:

> On Thu, Feb 20, 2014 at 07:31:41PM -0500, Josh Boyer wrote:
> >On Wed, Feb 19, 2014 at 9:20 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> >> Hi All,
> >>
> >> We've had a rather weird report[1] of the brightness adjustments being
> >> broken in a specific case with Thinkpad x220 hardware (SandyBridge
> >> based).  If you boot the machine with it in a dock and then undock,
> >> the brightness adjustments do not work.  That is with either the FN
> >> keys or the GNOME brightness slider.
> >>
> >> I can see that the value of
> >> /sys/class/backlight/acpi_video0/brightness increases/decreases but
> >> /sys/class/backlight/intel_backlight/brightness doesn't reflect any
> >> changes.  With 3.12 this works, and oddly with 3.14-rc1 it works
> >> (specifically, it starts working around v3.13-10231-g53d8ab2 which is
> >> right after the first DRM merge for 3.14).  With 3.13, if I undock and
> >> echo a higher value in the intel_backlight_brightness sysfs entry, the
> >> brightness will actually increase so it can be done manually, but it
> >> does not work as you'd expect.
> >>
> >> I'm in the middle of trying to do a reverse bisect for which patch
> >> fixes it in the 3.14-rcX series, but that's taking a while.  I thought
> >> I'd email and see if anyone already knows about this situation, what
> >> patch in 3.13 broke this, and which one then fixed it again.  Thus far
> >> all I've gathered is that backlight handling is confusing.
> >
> >The reverse bisect between 3.13 and 3.14-rc1 didn't prove fruitful,
> >either because I messed it up or there's a combination of things that
> >fix the issue.  So instead I did a regular git bisect between 3.12 and
> >3.13 to see which commit _broke_ things and caused the above behavior.
> > That landed me at:
> >
> >Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> >Date:   Thu Oct 31 18:55:49 2013 +0200
> >
> >    drm/i915: make backlight functions take a connector
> >
> >I have no idea if that makes sense or not, but it's at least something
> >that seems to be in a relevant area of code.  Does anyone involved in
> >that know why it would cause the above symptoms on 3.13, and which
> >commit(s) fix it in 3.14-rc1?
> 
> Since nobody is replying I poked around a bit myself.  The one commit
> that looks somewhat relevant in 3.14-rc1 seems to be:
> 
> commit c91c9f32843a1b433de5a1ead4789a6bc8d3d914
> Author: Jani Nikula <jani.nikula@intel.com>
> Date:   Fri Nov 8 16:48:55 2013 +0200
> 
>     drm/i915: make asle notifications update backlight on all connectors
> 
> That doesn't apply cleanly on 3.13 because of the other reworks that
> went in first, so I came up with the patch below.  It seems to fix it
> for my machine, but I'm waiting for confirmation from the original bug
> reporter still.  Maybe this will elicit some comments?
> 
> josh
> 
> Backport of upstream commit c91c9f328
> 
> ---
>  drivers/gpu/drm/i915/i915_drv.h       |  1 +
>  drivers/gpu/drm/i915/intel_opregion.c | 31 ++++++-------------------------
>  drivers/gpu/drm/i915/intel_panel.c    |  4 ++++
>  3 files changed, 11 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
> index 221ac62..d6d4349 100644
> --- a/drivers/gpu/drm/i915/i915_drv.h
> +++ b/drivers/gpu/drm/i915/i915_drv.h
> @@ -1371,6 +1371,7 @@ typedef struct drm_i915_private {
>  
>  	/* backlight */
>  	struct {
> +		bool present;
>  		int level;
>  		bool enabled;
>  		spinlock_t lock; /* bl registers and the above bl fields */
> diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
> index 6d69a9b..b2a51ae 100644
> --- a/drivers/gpu/drm/i915/intel_opregion.c
> +++ b/drivers/gpu/drm/i915/intel_opregion.c
> @@ -414,38 +414,19 @@ static u32 asle_set_backlight(struct drm_device *dev, u32 bclp)
>  		return ASLC_BACKLIGHT_FAILED;
>  
>  	mutex_lock(&dev->mode_config.mutex);
> -	/*
> -	 * Could match the OpRegion connector here instead, but we'd also need
> -	 * to verify the connector could handle a backlight call.
> -	 */
> -	list_for_each_entry(encoder, &dev->mode_config.encoder_list, head)
> -		if (encoder->crtc == crtc) {
> -			found = true;
> -			break;
> -		}
> -
> -	if (!found) {
> -		ret = ASLC_BACKLIGHT_FAILED;
> -		goto out;
> -	}
>  
> -	list_for_each_entry(connector, &dev->mode_config.connector_list, head)
> -		if (connector->encoder == encoder)
> -			intel_connector = to_intel_connector(connector);
> -
> -	if (!intel_connector) {
> -		ret = ASLC_BACKLIGHT_FAILED;
> -		goto out;
> +	DRM_DEBUG_KMS("updating opregion backlight %d/255\n", bclp);
> +	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
> +		intel_connector = to_intel_connector(connector);
> +		if (dev_priv->backlight.present)
> +			intel_panel_set_backlight(intel_connector, bclp, 255);
>  	}
>  
> -	DRM_DEBUG_KMS("updating opregion backlight %d/255\n", bclp);
> -	intel_panel_set_backlight(intel_connector, bclp, 255);
>  	iowrite32(DIV_ROUND_UP(bclp * 100, 255) | ASLE_CBLV_VALID, &asle->cblv);
>  
> -out:
>  	mutex_unlock(&dev->mode_config.mutex);
>  
> -	return ret;
> +	return 0;
>  }
>  
>  static u32 asle_set_als_illum(struct drm_device *dev, u32 alsi)
> diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
> index e6f782d..fa7b984 100644
> --- a/drivers/gpu/drm/i915/intel_panel.c
> +++ b/drivers/gpu/drm/i915/intel_panel.c
> @@ -832,6 +832,9 @@ int intel_panel_setup_backlight(struct drm_connector *connector)
>  		dev_priv->backlight.device = NULL;
>  		return -ENODEV;
>  	}
> +
> +	dev_priv->backlight.present = true;
> +
>  	return 0;
>  }
>  
> @@ -839,6 +842,7 @@ void intel_panel_destroy_backlight(struct drm_device *dev)
>  {
>  	struct drm_i915_private *dev_priv = dev->dev_private;
>  	if (dev_priv->backlight.device) {
> +		dev_priv->backlight.present = false;
>  		backlight_device_unregister(dev_priv->backlight.device);
>  		dev_priv->backlight.device = NULL;
>  	}

Yeah I think it looks reasonable, I was waiting for Jani to get back
since I think he's thought about this more.

Fundamentally, mapping from an OpRegion connector to a drm connector is
what we need, and your bits look a little closer to that than the
current code.

-- 
Jesse Barnes, Intel Open Source Technology Center
