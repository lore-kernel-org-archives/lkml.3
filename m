Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab3BLWDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:03:35 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:48021 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab3BLWDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:03:34 -0500
Message-ID: <511ABC32.3050706@suse.cz>
Date: Tue, 12 Feb 2013 23:03:30 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: compositing broken in -next (idr bug)
References: <511ABA59.9050604@suse.cz>
In-Reply-To: <511ABA59.9050604@suse.cz>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 10:55 PM, Jiri Slaby wrote:
> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -453,7 +453,8 @@ drm_gem_flink_ioctl(struct drm_device *dev, void *data,
>         spin_lock(&dev->object_name_lock);
>         if (!obj->name) {
>                 ret = idr_alloc(&dev->object_name_idr, obj, 1, 0,
> GFP_NOWAIT);
> -               obj->name = ret;
> +               if (ret >= 0)
> +                       obj->name = ret;
>                 args->name = (uint64_t) obj->name;
>                 spin_unlock(&dev->object_name_lock);
> 
> @@ -469,6 +470,7 @@ drm_gem_flink_ioctl(struct drm_device *dev, void *data,
>         }
> 
>  err:
> +       idr_preload_end();
>         drm_gem_object_unreference_unlocked(obj);
>         return ret;

Oh my, maybe: return ret < 0 ? ret : 0... Let's try.

-- 
js
suse labs
