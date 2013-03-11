Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab3CKVT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:19:57 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36259 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932125Ab3CKVTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:19:35 -0400
Message-ID: <1363036774.2056.59.camel@joe-AO722>
Subject: Re: [PATCH] drivers: gpu: drm: i915: Replaced calls to kmalloc &
 memcpy with kmemdup
From: Joe Perches <joe@perches.com>
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Date: Mon, 11 Mar 2013 14:19:34 -0700
In-Reply-To: <1363034382-22752-1-git-send-email-gheorghiuandru@gmail.com>
References: <1363034382-22752-1-git-send-email-gheorghiuandru@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 22:39 +0200, Alexandru Gheorghiu wrote:
> Replaced calls to kmalloc followed by memcpy with a single call to kmemdup.
> Also removed a now redundant if statement.
[]
> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
[]
> @@ -2335,11 +2335,8 @@ intel_dp_get_edid(struct drm_connector *connector, struct i2c_adapter *adapter)
>  			return NULL;
>  
>  		size = (intel_connector->edid->extensions + 1) * EDID_LENGTH;
> -		edid = kmalloc(size, GFP_KERNEL);
> -		if (!edid)
> -			return NULL;
> +		edid = kmemdup(intel_connector->edid, size, GFP_KERNEL);
>  
> -		memcpy(edid, intel_connector->edid, size);
>  		return edid;
>  	}
>  

Might as well get rid of the stack variable edid altogether.
Maybe get rid of size too and use:

	if (intel_connector->edid) {
		/* invalid edid */
		if (IS_ERR(intel_connector->edid))
			return NULL;

		return kmemdup(intel_connector->edid,
			       (intel_connector->edid->extensions + 1) * EDID_LENGTH,
			       GFP_KERNEL);
	}


