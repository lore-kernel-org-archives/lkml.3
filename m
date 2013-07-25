Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab3GYTSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 15:18:45 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:40735 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756883Ab3GYTSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 15:18:44 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <86ppu6tsmu.fsf@miki.keithp.com>
References: <1374544202-15496-1-git-send-email-keithp@keithp.com>
	<1374544202-15496-5-git-send-email-keithp@keithp.com>
	<20130723052856.GD5939@phenom.ffwll.local>
	<86li4v3ds7.fsf@miki.keithp.com>
	<20130724212308.GZ5939@phenom.ffwll.local>
	<86siz3v2m7.fsf@miki.keithp.com>
	<20130725074757.GE5939@phenom.ffwll.local>
	<86ppu6tsmu.fsf@miki.keithp.com>
Date: Thu, 25 Jul 2013 21:18:43 +0200
X-Google-Sender-Auth: PVbkQIUvnEmRp4vSWFhezmZcnSg
Message-ID: <CAKMK7uFiL+p48Phwc=jmWtsOgjNOYJzTCWmHe3Bp7-jWMpTtTA@mail.gmail.com>
Subject: Re: [PATCH 4/5] drm/i915: Add async page flip support for IVB
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 8:13 PM, Keith Packard <keithp@keithp.com> wrote:
> Daniel Vetter <daniel@ffwll.ch> writes:
>
>> On Wed, Jul 24, 2013 at 06:40:16PM -0700, Keith Packard wrote:
>>> Daniel Vetter <daniel@ffwll.ch> writes:
>>>
>>> > We could just unconditionally increase the alignement in
>>> > intel_pin_and_fence_fb_obj - we already have more strict requirements due
>>> > to a bunch of w/a in other places. So shouldn't hurt at all really.
>>>
>>> That seems like a fine plan; 32kB isn't that onerous. Do you want the
>>> trivial patch to do this from me then?
>>
>> Yes please, merging patches from other people is much easier than begging for
>> review for my own ;-)
>> -Daniel
>
> Here's a replacement for patch #4 that just adds the alignment
> requirement there. Do you want any other changes in this series?

Generally I think checking our current sw state instead of reading hw
registers would be safer, e.g. in case we start to queue up more than
one pageflip. For async pageflips in benchmark mode "flip as fast as
you can queue" would be a sensible mode.
-Daniel

>
> From 9a51e7118fce58c835cabb192f6b6e0a4a5f6660 Mon Sep 17 00:00:00 2001
> From: Keith Packard <keithp@keithp.com>
> Date: Mon, 22 Jul 2013 18:12:28 -0700
> Subject: [PATCH 4/5] drm/i915: Add async page flip support for IVB
>
> This adds the necesary register defines for async page flipping
> through the command ring, and then hooks those up for Ivybridge (gen7)
> page flipping.
>
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/i915_reg.h      |  6 +++++
>  drivers/gpu/drm/i915/intel_display.c | 46 ++++++++++++++++++++++++++++++++----
>  2 files changed, 48 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
> index dc3d6a7..029cfb0 100644
> --- a/drivers/gpu/drm/i915/i915_reg.h
> +++ b/drivers/gpu/drm/i915/i915_reg.h
> @@ -209,6 +209,7 @@
>  #define MI_LOAD_SCAN_LINES_INCL MI_INSTR(0x12, 0)
>  #define MI_DISPLAY_FLIP                MI_INSTR(0x14, 2)
>  #define MI_DISPLAY_FLIP_I915   MI_INSTR(0x14, 1)
> +#define   MI_DISPLAY_FLIP_ASYNC_INDICATOR      (1 << 22)
>  #define   MI_DISPLAY_FLIP_PLANE(n) ((n) << 20)
>  /* IVB has funny definitions for which plane to flip. */
>  #define   MI_DISPLAY_FLIP_IVB_PLANE_A  (0 << 19)
> @@ -217,6 +218,11 @@
>  #define   MI_DISPLAY_FLIP_IVB_SPRITE_B (3 << 19)
>  #define   MI_DISPLAY_FLIP_IVB_PLANE_C  (4 << 19)
>  #define   MI_DISPLAY_FLIP_IVB_SPRITE_C (5 << 19)
> +/* These go in the bottom of the base address value */
> +#define   MI_DISPLAY_FLIP_TYPE_SYNC    (0 << 0)
> +#define   MI_DISPLAY_FLIP_TYPE_ASYNC   (1 << 0)
> +#define   MI_DISPLAY_FLIP_TYPE_STEREO  (2 << 0)
> +#define   MI_DISPLAY_FLIP_TYPE_SYNCHRONOUS     (0 << 0)
>  #define MI_ARB_ON_OFF          MI_INSTR(0x08, 0)
>  #define   MI_ARB_ENABLE                        (1<<0)
>  #define   MI_ARB_DISABLE               (0<<0)
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index bdb8854..f2624a4 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -1833,8 +1833,10 @@ intel_pin_and_fence_fb_obj(struct drm_device *dev,
>                         alignment = 64 * 1024;
>                 break;
>         case I915_TILING_X:
> -               /* pin() will align the object as required by fence */
> -               alignment = 0;
> +               /* Async page flipping requires X tiling and 32kB alignment, so just
> +                * make all X tiled frame buffers aligned for that
> +                */
> +               alignment = 32 * 1024;
>                 break;
>         case I915_TILING_Y:
>                 /* Despite that we check this in framebuffer_init userspace can
> @@ -7514,6 +7516,8 @@ static int intel_gen7_queue_flip(struct drm_device *dev,
>         struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
>         struct intel_ring_buffer *ring = &dev_priv->ring[BCS];
>         uint32_t plane_bit = 0;
> +       uint32_t cmd;
> +       uint32_t base;
>         int ret;
>
>         ret = intel_pin_and_fence_fb_obj(dev, obj, ring);
> @@ -7536,13 +7540,43 @@ static int intel_gen7_queue_flip(struct drm_device *dev,
>                 goto err_unpin;
>         }
>
> +       cmd = MI_DISPLAY_FLIP_I915 | plane_bit;
> +       base = i915_gem_obj_ggtt_offset(obj) + intel_crtc->dspaddr_offset;
> +
> +       if (flags & DRM_MODE_PAGE_FLIP_ASYNC) {
> +
> +               /* XXX check limitations for async flip here */
> +
> +               if (fb->pitches[0] != I915_READ(DSPSTRIDE(intel_crtc->plane))) {
> +                       WARN_ONCE(1, "mismatching stride in async plane flip (%d != %d)\n",
> +                                 fb->pitches[0], I915_READ(DSPSTRIDE(intel_crtc->plane)));
> +                       ret = -EINVAL;
> +                       goto err_unpin;
> +               }
> +
> +               if (obj->tiling_mode != I915_TILING_X) {
> +                       WARN_ONCE(1, "async plane flip requires X tiling\n");
> +                       ret = -EINVAL;
> +                       goto err_unpin;
> +               }
> +
> +               if ((I915_READ(DSPCNTR(intel_crtc->plane)) & DISPPLANE_TILED) == 0) {
> +                       WARN_ONCE(1, "display not currently tiled in async plane flip\n");
> +                       ret = -EINVAL;
> +                       goto err_unpin;
> +               }
> +
> +               cmd |= MI_DISPLAY_FLIP_ASYNC_INDICATOR;
> +               base |= MI_DISPLAY_FLIP_TYPE_ASYNC;
> +       }
> +
>         ret = intel_ring_begin(ring, 4);
>         if (ret)
>                 goto err_unpin;
>
> -       intel_ring_emit(ring, MI_DISPLAY_FLIP_I915 | plane_bit);
> +       intel_ring_emit(ring, cmd);
>         intel_ring_emit(ring, (fb->pitches[0] | obj->tiling_mode));
> -       intel_ring_emit(ring, i915_gem_obj_ggtt_offset(obj) + intel_crtc->dspaddr_offset);
> +       intel_ring_emit(ring, base);
>         intel_ring_emit(ring, (MI_NOOP));
>
>         intel_mark_page_flip_active(intel_crtc);
> @@ -9705,6 +9739,10 @@ void intel_modeset_init(struct drm_device *dev)
>                 dev->mode_config.max_width = 8192;
>                 dev->mode_config.max_height = 8192;
>         }
> +
> +       if (IS_GEN7(dev))
> +               dev->mode_config.async_page_flip = true;
> +
>         dev->mode_config.fb_base = dev_priv->gtt.mappable_base;
>
>         DRM_DEBUG_KMS("%d display pipe%s available.\n",
> --
> 1.8.3.2
>
>
>
> --
> keith.packard@intel.com



--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
