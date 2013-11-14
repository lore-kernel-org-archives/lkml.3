Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab3KNQyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:54:37 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:61292 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979Ab3KNQyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:54:00 -0500
Date: Thu, 14 Nov 2013 14:53:59 -0200
From: Rodrigo Vivi <rodrigo.vivi@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Duncan Laurie <dlaurie@chromium.org>
Subject: Re: [PATCH] i915: Use 120MHz LVDS SSC clock for gen5/gen6/gen7
Message-ID: <20131114165142.GA11645@bratislava.fso.intel.com>
References: <1384394383-8582-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384394383-8582-1-git-send-email-olof@lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 05:59:43PM -0800, Olof Johansson wrote:
> From: Duncan Laurie <dlaurie@chromium.org>
> 
> We had been using a DMI table workaround to select the right
> frequency for devices, but this is fragile and must be updated
> with every new platform.
> 
> Instead the default case when VBT is missing is changed to use
> 120MHz clock for LVDS SSC for these generations.
> 
> The docs for 2010-Core, SandyBridge, and IvyBridge all indicate
> that the reference frequency for LVDS is 120MHz:
> 
> "2010 Core"
> http://intellinuxgraphics.org/IHD_OS_Vol3_Part3r2.pdf
> page 38
> Reference Frequency: 120MHz for CRT and LVDS.  100MHz for the FDI.
> 
> "2011 SandyBridge"
> http://intellinuxgraphics.org/documentation/SNB/IHD_OS_Vol3_Part3.pdf
> page 33
> Reference Frequency: 120MHz for CRT, HDMI, LVDS.  100MHz for the FDI.
> 
> "2012 IvyBridge"
> http://intellinuxgraphics.org/documentation/IVB/IHD_OS_Vol3_Part4.pdf
> page 27
> Reference Frequency: 120 MHz for CRT, HDMI, LVDS, 100MHz for the FDI.

Checked. You are right.
And actually true even for HSW and BDW. 120 is the default and 100 is for test mode.

> 
> Signed-off-by: Duncan Laurie <dlaurie@chromium.org>
> [olof: Fixup for recent base, switched from if/else to single call]
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
> 
> Daniel,
> 
> This applies on top of -next, which I'm presuming is close to your
> for-3.13 base right now. It'd be good to see this go in since it's needed
> to boot on Chromebooks (with developer mode off), and is thus blocking
> testing next/mainline on a regular basis here.
> 
> Thanks!
> 
> -Olof
> 
>  drivers/gpu/drm/i915/intel_bios.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
> index 6dd622d733b9..e4fba39631a5 100644
> --- a/drivers/gpu/drm/i915/intel_bios.c
> +++ b/drivers/gpu/drm/i915/intel_bios.c
> @@ -790,7 +790,12 @@ init_vbt_defaults(struct drm_i915_private *dev_priv)
>  
>  	/* Default to using SSC */
>  	dev_priv->vbt.lvds_use_ssc = 1;
> -	dev_priv->vbt.lvds_ssc_freq = intel_bios_ssc_frequency(dev, 1);
> +	/*
> +	 * Core/SandyBridge/IvyBridge use alternative (120MHz) reference
> +	 * clock for LVDS.
> +	 */
> +	dev_priv->vbt.lvds_ssc_freq = intel_bios_ssc_frequency(dev,
> +			!HAS_PCH_SPLIT(dev));

I'm just not convinced this is the right way to fix this here.
Mainly because for most of platforms the alternate is 100 and default is 120.
The ideal in my opinion should be to invert the alternate inside ssc_freqeuncy function and use the exception, that is probably IS_PINEVIEW(dev)...

Not sure though... just a guess since this alternate was implemented for pineview...

>  	DRM_DEBUG_KMS("Set default to SSC at %dMHz\n", dev_priv->vbt.lvds_ssc_freq);
>  
>  	for (port = PORT_A; port < I915_MAX_PORTS; port++) {
> -- 
> 1.8.4.1.601.g02b3b1d
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
