Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab3GYSvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:51:04 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:50062 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230Ab3GYSvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:51:00 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130725184504.GC11514@cantiga.alporthouse.com>
References: <CA+icZUV-UM_9OSfGfYyb0-qZrFSuqeX-7BiPQ0NbyF7bADW-qA@mail.gmail.com>
	<CA+icZUWJDp6XQZs8hojVJOVyjC8NeV7QoQeFopNoUgwCaYHnSQ@mail.gmail.com>
	<20130725163150.GD6493@cantiga.alporthouse.com>
	<CA+icZUWmpZK0jO_G1ec446WftzXDvSdnHLcQrkmBSHA7fSAqcw@mail.gmail.com>
	<20130725170144.GE6493@cantiga.alporthouse.com>
	<CA+icZUUOmoFY3JDZOYmiP3dV9KAR_8WYfEDQhaynKmhXCLpF9w@mail.gmail.com>
	<20130725172616.GA11514@cantiga.alporthouse.com>
	<CA+icZUUpnQ_=bTtK-0-qG90GjV38oeVe2E1v-KdLZQFQWH21GQ@mail.gmail.com>
	<CA+icZUXz+6MgbW952fU_da1-RfX8CSZp76gJnOwGDNsd-rdebA@mail.gmail.com>
	<CA+icZUV+D8PvEysipfg9nPXp3ON1QSA7DiFdpYFpdesFF5c0sw@mail.gmail.com>
	<20130725184504.GC11514@cantiga.alporthouse.com>
Date: Thu, 25 Jul 2013 20:50:59 +0200
Message-ID: <CA+icZUVLXxA5LPxzTjyhP5gryNUH3OY+vutoXQj6ydtCU0msbA@mail.gmail.com>
Subject: Re: [Intel-gfx] linux-next: Tree for Jul 25 [ call-trace: drm |
 drm-intel related? ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        linux-next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 8:45 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Thu, Jul 25, 2013 at 08:03:06PM +0200, Sedat Dilek wrote:
>> On Thu, Jul 25, 2013 at 7:55 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> > F*ck. Wrong patch refreshed.
>> >
>>
>> New dmesg attached.
>
> Hmm, not seeing any difference, so let's add a couple more lines just to
> be sure:
>
> (apologies I didn't stash the previous debug patch)
>
> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> index 0563661..4d21f37 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -1624,30 +1624,39 @@ i915_gem_mmap_gtt(struct drm_file *file,
>         struct drm_i915_gem_object *obj;
>         int ret;
>
> +       printk(KERN_ERR "Hello!\n");
> +
>         ret = i915_mutex_lock_interruptible(dev);
> -       if (ret)
> +       if (ret) {
> +               DRM_DEBUG_DRIVER("interrupted: ret=%d\n", ret);
>                 return ret;
> +       }
>
>         obj = to_intel_bo(drm_gem_object_lookup(dev, file, handle));
>         if (&obj->base == NULL) {
> +               DRM_DEBUG_DRIVER("Unknown object handle %d\n", handle);
>                 ret = -ENOENT;
>                 goto unlock;
>         }
>
>         if (obj->base.size > dev_priv->gtt.mappable_end) {
> +               DRM_DEBUG_DRIVER("Object (%d) larger than mappable aperture (%d) > %d\n",
> +                               (int)obj->base.size, (int)dev_priv->gtt.mappable_end);
>                 ret = -E2BIG;
>                 goto out;
>         }
>
>         if (obj->madv != I915_MADV_WILLNEED) {
> -               DRM_ERROR("Attempting to mmap a purgeable buffer\n");
> +               DRM_DEBUG_DRIVER("Attempting to mmap a purgeable buffer\n");
>                 ret = -EINVAL;
>                 goto out;
>         }
>
>         ret = i915_gem_object_create_mmap_offset(obj);
> -       if (ret)
> +       if (ret) {
> +               DRM_DEBUG_DRIVER("Failed to allocate mmap offset (ret=%d)\n", ret);
>                 goto out;
> +       }
>
>         *offset = (u64)obj->base.map_list.hash.key << PAGE_SHIFT;
>
> @@ -1655,6 +1664,7 @@ out:
>         drm_gem_object_unreference(&obj->base);
>  unlock:
>         mutex_unlock(&dev->struct_mutex);
> +       DRM_DEBUG_DRIVER("done, ret=%d\n", ret);
>         return ret;
>  }
>
>
> --

Against what tree is this applicable? It is definitely not drm-intel-nightly.

- S.
> Chris Wilson, Intel Open Source Technology Centre
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
