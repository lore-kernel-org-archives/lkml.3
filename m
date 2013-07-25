Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab3GYSD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:03:29 -0400
Received: from s16502780.onlinehome-server.info ([87.106.93.118]:61694 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932179Ab3GYSDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:03:09 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Thu, 25 Jul 2013 19:03:01 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        linux-next <linux-next@vger.kernel.org>
Subject: Re: [Intel-gfx] linux-next: Tree for Jul 25 [ call-trace: drm |
 drm-intel related? ]
Message-ID: <20130725180301.GB11514@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Sedat Dilek <sedat.dilek@gmail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	DRI <dri-devel@lists.freedesktop.org>,
	linux-next <linux-next@vger.kernel.org>
References: <CA+icZUU3+egkAVtSVEiOaqWK+7EFi572jGv2jUt=QDuGjbfZOw@mail.gmail.com>
 <CAKMK7uG-KCF5oU2XJ5UWPJn=V3i0jBLs5a=gU9UPuJxY0v=bNw@mail.gmail.com>
 <CA+icZUV-UM_9OSfGfYyb0-qZrFSuqeX-7BiPQ0NbyF7bADW-qA@mail.gmail.com>
 <CA+icZUWJDp6XQZs8hojVJOVyjC8NeV7QoQeFopNoUgwCaYHnSQ@mail.gmail.com>
 <20130725163150.GD6493@cantiga.alporthouse.com>
 <CA+icZUWmpZK0jO_G1ec446WftzXDvSdnHLcQrkmBSHA7fSAqcw@mail.gmail.com>
 <20130725170144.GE6493@cantiga.alporthouse.com>
 <CA+icZUUOmoFY3JDZOYmiP3dV9KAR_8WYfEDQhaynKmhXCLpF9w@mail.gmail.com>
 <20130725172616.GA11514@cantiga.alporthouse.com>
 <CA+icZUUpnQ_=bTtK-0-qG90GjV38oeVe2E1v-KdLZQFQWH21GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUUpnQ_=bTtK-0-qG90GjV38oeVe2E1v-KdLZQFQWH21GQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 78.156.73.22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 07:52:22PM +0200, Sedat Dilek wrote:
> On Thu, Jul 25, 2013 at 7:26 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > On Thu, Jul 25, 2013 at 07:15:03PM +0200, Sedat Dilek wrote:
> >> On Thu, Jul 25, 2013 at 7:01 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> >> > Basically boils down to either an object allocation failure or mmaping
> >> > failure. I think dmesg with drm.debug=7 is the next step.
> >>
> >> Attached! Thanks for taking care.
> >
> > Hmm, looks like i915_gem_map_gtt fails, but no reason given, so can you
> > please apply this for more debug:
> >
> > diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> > index 0563661..34e09bf 100644
> > --- a/drivers/gpu/drm/i915/i915_gem.c
> > +++ b/drivers/gpu/drm/i915/i915_gem.c
> > @@ -1630,24 +1630,29 @@ i915_gem_mmap_gtt(struct drm_file *file,
> >
> >         obj = to_intel_bo(drm_gem_object_lookup(dev, file, handle));
> >         if (&obj->base == NULL) {
> > +               DRM_DRIVER_DEBUG("Unknown object handle %d\n", handle);
> >                 ret = -ENOENT;
> >                 goto unlock;
> >         }
> >
> >         if (obj->base.size > dev_priv->gtt.mappable_end) {
> > +               DRM_DRIVER_DEBUG("Object (%d) larger than mappable aperture (%d) > %d\n",
> > +                               (int)obj->base.size, (int)dev_priv->gtt.mappable_end);
> >                 ret = -E2BIG;
> >                 goto out;
> >         }
> >
> >         if (obj->madv != I915_MADV_WILLNEED) {
> > -               DRM_ERROR("Attempting to mmap a purgeable buffer\n");
> > +               DRM_DRIVER_DEBUG("Attempting to mmap a purgeable buffer\n");
> >                 ret = -EINVAL;
> >                 goto out;
> >         }
> >
> >         ret = i915_gem_object_create_mmap_offset(obj);
> > -       if (ret)
> > +       if (ret) {
> > +               DRM_DRIVER_DEBUG("Failed to allocate mmap offset (ret=%d)\n", ret);
> >                 goto out;
> > +       }
> >
> >         *offset = (u64)obj->base.map_list.hash.key << PAGE_SHIFT;
> >
> > --
> 
> This does not apply... After refreshing and some cleanups... does not build:
> 
> $ LANG=C LC_ALL=C make M=drivers/gpu/drm/i915
>   LD      drivers/gpu/drm/i915/built-in.o
>   CC [M]  drivers/gpu/drm/i915/i915_drv.o
>   CC [M]  drivers/gpu/drm/i915/i915_dma.o
>   CC [M]  drivers/gpu/drm/i915/i915_irq.o
>   CC [M]  drivers/gpu/drm/i915/i915_debugfs.o
>   CC [M]  drivers/gpu/drm/i915/i915_gpu_error.o
>   CC [M]  drivers/gpu/drm/i915/i915_suspend.o
>   CC [M]  drivers/gpu/drm/i915/i915_gem.o
> drivers/gpu/drm/i915/i915_gem.c: In function 'i915_gem_mmap_gtt':
> drivers/gpu/drm/i915/i915_gem.c:1538:3: error: implicit declaration of
> function 'DRM_DRIVER_DEBUG' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[1]: *** [drivers/gpu/drm/i915/i915_gem.o] Error 1
> make: *** [_module_drivers/gpu/drm/i915] Error 2

Bah, try DRM_DEBUG_DRIVER instead.
-Chris


-- 
Chris Wilson, Intel Open Source Technology Centre
