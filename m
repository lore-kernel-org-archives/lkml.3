Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab3CKVJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:09:48 -0400
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:39764 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab3CKVJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:09:47 -0400
X-Policy: 217.70.183.197 is whitelisted
X-Policy: 217.70.183.197 is whitelisted
X-Originating-IP: 173.246.103.110
Date: Mon, 11 Mar 2013 13:25:12 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: gpu: drm: i915: Replaced calls to kmalloc &
 memcpy with kmemdup
Message-ID: <20130311202512.GA7626@jtriplet-mobl1>
References: <1363030240-22250-1-git-send-email-gheorghiuandru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363030240-22250-1-git-send-email-gheorghiuandru@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 09:30:40PM +0200, Alexandru Gheorghiu wrote:
> Replaced calls to kmalloc followed by memcpy with a single call to kmemdup.
> This patch was found using coccinelle.
> 
> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
> ---
>  drivers/gpu/drm/i915/intel_dp.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
> index f61cb79..a3fdd65 100644
> --- a/drivers/gpu/drm/i915/intel_dp.c
> +++ b/drivers/gpu/drm/i915/intel_dp.c
> @@ -2335,11 +2335,10 @@ intel_dp_get_edid(struct drm_connector *connector, struct i2c_adapter *adapter)
>  			return NULL;
>  
>  		size = (intel_connector->edid->extensions + 1) * EDID_LENGTH;
> -		edid = kmalloc(size, GFP_KERNEL);
> +		edid = kmemdup(intel_connector->edid, size, GFP_KERNEL);
>  		if (!edid)
>  			return NULL;
>  
> -		memcpy(edid, intel_connector->edid, size);
>  		return edid;
>  	}

With this change, the conditional no longer makes sense; this should
just "return kmemdup(...);".

That suggests an obvious further cleanup that coccinelle could easily
handle:

if (!foo)
    return NULL;
return foo;

should become just "return foo;".  And you might then want to check for
variables used *only* to capture a return value and immediately
returned, and eliminate them.

- Josh Triplett
