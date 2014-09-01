Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaIAIuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:50:35 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:61458 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752675AbaIAIub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:50:31 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Date: Mon, 1 Sep 2014 09:50:22 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: ville.syrjala@linux.intel.com
Cc: intel-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        Tibor Billes <tbilles@gmx.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Fix lock dropping in
 intel_tv_detect()
Message-ID: <20140901085022.GB11648@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	ville.syrjala@linux.intel.com, intel-gfx@lists.freedesktop.org,
	David Airlie <airlied@linux.ie>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	linux-kernel@vger.kernel.org, Tibor Billes <tbilles@gmx.com>
References: <877g1ndfh5.fsf@intel.com>
 <1409558986-5099-1-git-send-email-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409558986-5099-1-git-send-email-ville.syrjala@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 11:09:46AM +0300, ville.syrjala@linux.intel.com wrote:
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
> Cc: Tibor Billes <tbilles@gmx.com>
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
>  drivers/gpu/drm/i915/intel_tv.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
> index 32186a6..abbf0ea 100644
> --- a/drivers/gpu/drm/i915/intel_tv.c
> +++ b/drivers/gpu/drm/i915/intel_tv.c
> @@ -1311,7 +1311,8 @@ intel_tv_detect(struct drm_connector *connector, bool force)
>  {
>  	struct drm_display_mode mode;
>  	struct intel_tv *intel_tv = intel_attached_tv(connector);
> -	int type;
> +	enum drm_connector_status status = connector->status;
> +	int type = -1;
>  
>  	DRM_DEBUG_KMS("[CONNECTOR:%d:%s] force=%d\n",
>  		      connector->base.id, connector->name,
> @@ -1328,21 +1329,23 @@ intel_tv_detect(struct drm_connector *connector, bool force)
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
> -	} else
> -		return connector->status;
> +	}
>  
>  	if (type < 0)
> -		return connector_status_disconnected;
> +		return status;
>  
>  	intel_tv->type = type;
>  	intel_tv_find_better_format(connector);
>  
> -	return connector_status_connected;
> +	return status;

Hmm, this makes the code unclear. if type != -1, status should always be
connected.

I think:

if (status != connector_status_connected)
  return status;

if (WARN_ON(type < 0))
   return connector_status_disconnected;

intel_tv->type = type;
find_better_format();
return connector_status_connected;

And leave type unset to encourage gcc.



diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
index 32186a6..a109b7b 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1311,6 +1311,7 @@ intel_tv_detect(struct drm_connector *connector, bool force)
 {
        struct drm_display_mode mode;
        struct intel_tv *intel_tv = intel_attached_tv(connector);
+       enum drm_connector_status status = connector->status;
        int type;
 
        DRM_DEBUG_KMS("[CONNECTOR:%d:%s] force=%d\n",
@@ -1327,17 +1328,20 @@ intel_tv_detect(struct drm_connector *connector, bool force)
 
                if (intel_get_load_detect_pipe(connector, &mode, &tmp, &ctx)) {
                        type = intel_tv_detect_type(intel_tv, connector);
+                       status = type < 0 ?
+                               connector_status_disconnected :
+                               connector_status_connected;
+
                        intel_release_load_detect_pipe(connector, &tmp);
                } else
-                       return connector_status_unknown;
+                       status = connector_status_unknown;
 
                drm_modeset_drop_locks(&ctx);
                drm_modeset_acquire_fini(&ctx);
-       } else
-               return connector->status;
+       }
 
-       if (type < 0)
-               return connector_status_disconnected;
+       if (status != connector_status_connected)
+               return status;
 
        intel_tv->type = type;
        intel_tv_find_better_format(connector);

-- 
Chris Wilson, Intel Open Source Technology Centre
