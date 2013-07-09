Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab3GIUdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 16:33:25 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:61150 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab3GIUdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 16:33:23 -0400
Date: Tue, 9 Jul 2013 22:33:22 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Guenter Roeck <linux@roeck-us.net>
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Mika Kuoppala <mika.kuoppala@intel.com>
Subject: Re: [PATCH] Revert "drm/i915: unconditionally use mt forcewake on
 hsw/ivb"
Message-ID: <20130709203322.GC18285@phenom.ffwll.local>
Mail-Followup-To: Guenter Roeck <linux@roeck-us.net>,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Mika Kuoppala <mika.kuoppala@intel.com>
References: <1373400849-30351-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373400849-30351-1-git-send-email-linux@roeck-us.net>
X-Operating-System: Linux phenom 3.10.0-rc5+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 01:14:09PM -0700, Guenter Roeck wrote:
> This reverts commit 36ec8f877481449bdfa072e6adf2060869e2b970.
> 
> The commit results in repeated 'Timed out waiting for forcewake old ack
> to clear' messages on a Supermicro C7H61 board (BIOS version 2.00 and 2.00b)
> with i7-3770K CPU. It ultimately results in a hangup if the system is highly
> loaded. Reverting the commit fixes the issue.
> 
> While I understand that this should be fixed in the BIOS, a more recent BIOS
> is not available fron the vendor. If/since no better solution is not available,
> reverting the patch seems to be the way to go (otherwise me and others with
> the same problem won't be able to run the upstream kernel on affected boards).
> 
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Mika Kuoppala <mika.kuoppala@intel.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Can you please add the bugzilla link here?

> ---
>  drivers/gpu/drm/i915/intel_pm.c |   31 +++++++++++++++++++++++++++----
>  1 file changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
> index aa01128..5bae9ba 100644
> --- a/drivers/gpu/drm/i915/intel_pm.c
> +++ b/drivers/gpu/drm/i915/intel_pm.c
> @@ -4510,12 +4510,35 @@ void intel_gt_init(struct drm_device *dev)
>  	if (IS_VALLEYVIEW(dev)) {
>  		dev_priv->gt.force_wake_get = vlv_force_wake_get;
>  		dev_priv->gt.force_wake_put = vlv_force_wake_put;
> -	} else if (IS_IVYBRIDGE(dev) || IS_HASWELL(dev)) {
> -		dev_priv->gt.force_wake_get = __gen6_gt_force_wake_mt_get;
> -		dev_priv->gt.force_wake_put = __gen6_gt_force_wake_mt_put;

Please keep the unconditional use of mt forcewake for haswell, afaik we
don't have any reports that there are still broken BIOS out there.


> -	} else if (IS_GEN6(dev)) {
> +	} else if (INTEL_INFO(dev)->gen >= 6) {
>  		dev_priv->gt.force_wake_get = __gen6_gt_force_wake_get;
>  		dev_priv->gt.force_wake_put = __gen6_gt_force_wake_put;
> +
> +		/* IVB configs may use multi-threaded forcewake */
> +		if (IS_IVYBRIDGE(dev) || IS_HASWELL(dev)) {
> +			u32 ecobus;
> +
> +			/* A small trick here - if the bios hasn't configured
> +			 * MT forcewake, and if the device is in RC6, then
> +			 * force_wake_mt_get will not wake the device and the
> +			 * ECOBUS read will return zero. Which will be
> +			 * (correctly) interpreted by the test below as MT
> +			 * forcewake being disabled.
> +			 */
> +			mutex_lock(&dev->struct_mutex);
> +			__gen6_gt_force_wake_mt_get(dev_priv);
> +			ecobus = I915_READ_NOTRACE(ECOBUS);
> +			__gen6_gt_force_wake_mt_put(dev_priv);
> +			mutex_unlock(&dev->struct_mutex);
> +
> +			if (ecobus & FORCEWAKE_MT_ENABLE) {
> +				DRM_DEBUG_KMS("Using MT version of forcewake\n");
> +				dev_priv->gt.force_wake_get =
> +					__gen6_gt_force_wake_mt_get;
> +				dev_priv->gt.force_wake_put =
> +					__gen6_gt_force_wake_mt_put;
> +			}

This needs a DRM_INFO warning if MT forcewake is not available telling the
user telling the user that this might result in hangs with recent DDX
version, e.g.: "No MT forcewake available on Ivybridge, this can result in
issues when using vblank-synced partial screen updates."

Thanks, Daniel

> +		}
>  	}
>  	INIT_DELAYED_WORK(&dev_priv->rps.delayed_resume_work,
>  			  intel_gen6_powersave_work);
> -- 
> 1.7.9.7
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
