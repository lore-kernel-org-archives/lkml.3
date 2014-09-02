Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaIBLl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:41:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:9739 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbaIBLl1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:41:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,448,1406617200"; 
   d="scan'208";a="567085481"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: ville.syrjala@linux.intel.com, intel-gfx@lists.freedesktop.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Tibor Billes <tbilles@gmx.com>
Subject: Re: [PATCH v3] drm/i915: Fix lock dropping in intel_tv_detect()
In-Reply-To: <1409651842-14446-1-git-send-email-ville.syrjala@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20140902082635.GA25238@nuc-i3427.alporthouse.com> <1409651842-14446-1-git-send-email-ville.syrjala@linux.intel.com>
User-Agent: Notmuch/0.18.1+85~gcca05ac (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 02 Sep 2014 14:41:22 +0300
Message-ID: <878um2i719.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep 2014, ville.syrjala@linux.intel.com wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
>
> When intel_tv_detect() fails to do load detection it would forget to
> drop the locks and clean up the acquire context. Fix it up.
>
> This is a regression from:
>  commit 208bf9fdcd3575aa4a5d48b3e0295f7cdaf6fc44
>  Author: Ville Syrjälä <ville.syrjala@linux.intel.com>
>  Date:   Mon Aug 11 13:15:35 2014 +0300
>
>     drm/i915: Fix locking for intel_enable_pipe_a()
>
> v2: Make the code more readable (Chris)
> v3: Drop WARN_ON(type < 0) (Chris)
>
> Cc: stable@vger.kernel.org
> Cc: Tibor Billes <tbilles@gmx.com>
> Reported-by: Tibor Billes <tbilles@gmx.com>
> Tested-by: Tibor Billes <tbilles@gmx.com>
> Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

Pushed to drm-intel-fixes, thanks for the patch, review, and testing.

BR,
Jani.


> ---
>  drivers/gpu/drm/i915/intel_tv.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
> index 32186a6..c69d3ce 100644
> --- a/drivers/gpu/drm/i915/intel_tv.c
> +++ b/drivers/gpu/drm/i915/intel_tv.c
> @@ -1311,6 +1311,7 @@ intel_tv_detect(struct drm_connector *connector, bool force)
>  {
>  	struct drm_display_mode mode;
>  	struct intel_tv *intel_tv = intel_attached_tv(connector);
> +	enum drm_connector_status status;
>  	int type;
>  
>  	DRM_DEBUG_KMS("[CONNECTOR:%d:%s] force=%d\n",
> @@ -1328,16 +1329,19 @@ intel_tv_detect(struct drm_connector *connector, bool force)
>  		if (intel_get_load_detect_pipe(connector, &mode, &tmp, &ctx)) {
>  			type = intel_tv_detect_type(intel_tv, connector);
>  			intel_release_load_detect_pipe(connector, &tmp);
> +			status = type < 0 ?
> +				connector_status_disconnected :
> +				connector_status_connected;
>  		} else
> -			return connector_status_unknown;
> +			status = connector_status_unknown;
>  
>  		drm_modeset_drop_locks(&ctx);
>  		drm_modeset_acquire_fini(&ctx);
>  	} else
>  		return connector->status;
>  
> -	if (type < 0)
> -		return connector_status_disconnected;
> +	if (status != connector_status_connected)
> +		return status;
>  
>  	intel_tv->type = type;
>  	intel_tv_find_better_format(connector);
> -- 
> 1.8.5.5
>

-- 
Jani Nikula, Intel Open Source Technology Center
