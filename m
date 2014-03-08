Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaCHSvM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 13:51:12 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:34907 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbaCHSvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 13:51:10 -0500
MIME-Version: 1.0
In-Reply-To: <1394304546-19433-1-git-send-email-sagar.a.kamble@intel.com>
References: <20140224160628.GU3852@intel.com>
	<1394304546-19433-1-git-send-email-sagar.a.kamble@intel.com>
Date: Sat, 8 Mar 2014 13:51:09 -0500
Message-ID: <CADnq5_P_j66y2j3v8r9jHOffhfz3L3_fQpnP-OFdfOeLEWqs8A@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] drm/i915: Enabling 128x128 and 256x256 ARGB Cursor Support
From: Alex Deucher <alexdeucher@gmail.com>
To: sagar.a.kamble@intel.com
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        "G, Pallavi" <pallavi.g@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 8, 2014 at 1:49 PM,  <sagar.a.kamble@intel.com> wrote:
> From: Sagar Kamble <sagar.a.kamble@intel.com>
>
> With this patch we allow larger cursor planes of sizes 128x128
> and 256x256.
>
> v2: Added more precise check on size while setting cursor plane.
>
> v3: Changes related to restructuring cursor size restrictions
> and DRM_DEBUG usage.
>

I'm not sure how useful it is since you appear to be able to
selectively adjust the cursor size, but I recently added support for
exposing the cursor size as a drm cap:
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=8716ed4e7bed4e4c7e3f37940e950ddc0362f450

Alex

> Testcase: igt/kms_cursor_crc
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Cc: David Airlie <airlied@linux.ie>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: G, Pallavi <pallavi.g@intel.com>
> Signed-off-by: Sagar Kamble <sagar.a.kamble@intel.com>
> ---
>  drivers/gpu/drm/i915/i915_reg.h      |  4 ++++
>  drivers/gpu/drm/i915/intel_display.c | 36 +++++++++++++++++++++++++++++++-----
>  2 files changed, 35 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
> index 146609a..aee8258 100644
> --- a/drivers/gpu/drm/i915/i915_reg.h
> +++ b/drivers/gpu/drm/i915/i915_reg.h
> @@ -3551,7 +3551,11 @@ enum punit_power_well {
>  /* New style CUR*CNTR flags */
>  #define   CURSOR_MODE          0x27
>  #define   CURSOR_MODE_DISABLE   0x00
> +#define   CURSOR_MODE_128_32B_AX 0x02
> +#define   CURSOR_MODE_256_32B_AX 0x03
>  #define   CURSOR_MODE_64_32B_AX 0x07
> +#define   CURSOR_MODE_128_ARGB_AX ((1 << 5) | CURSOR_MODE_128_32B_AX)
> +#define   CURSOR_MODE_256_ARGB_AX ((1 << 5) | CURSOR_MODE_256_32B_AX)
>  #define   CURSOR_MODE_64_ARGB_AX ((1 << 5) | CURSOR_MODE_64_32B_AX)
>  #define   MCURSOR_PIPE_SELECT  (1 << 28)
>  #define   MCURSOR_PIPE_A       0x00
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index 0868afb..e59e8fd 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -7440,10 +7440,22 @@ static void i9xx_update_cursor(struct drm_crtc *crtc, u32 base)
>         bool visible = base != 0;
>
>         if (intel_crtc->cursor_visible != visible) {
> +               int16_t width = intel_crtc->cursor_width;
>                 uint32_t cntl = I915_READ(CURCNTR(pipe));
>                 if (base) {
>                         cntl &= ~(CURSOR_MODE | MCURSOR_PIPE_SELECT);
> -                       cntl |= CURSOR_MODE_64_ARGB_AX | MCURSOR_GAMMA_ENABLE;
> +
> +                       switch (width) {
> +                               case 64:
> +                                       cntl |= CURSOR_MODE_64_ARGB_AX | MCURSOR_GAMMA_ENABLE;
> +                                       break;
> +                               case 128:
> +                                       cntl |= CURSOR_MODE_128_ARGB_AX | MCURSOR_GAMMA_ENABLE;
> +                                       break;
> +                               case 256:
> +                                       cntl |= CURSOR_MODE_256_ARGB_AX | MCURSOR_GAMMA_ENABLE;
> +                                       break;
> +                       }
>                         cntl |= pipe << 28; /* Connect to correct pipe */
>                 } else {
>                         cntl &= ~(CURSOR_MODE | MCURSOR_GAMMA_ENABLE);
> @@ -7468,10 +7480,22 @@ static void ivb_update_cursor(struct drm_crtc *crtc, u32 base)
>         bool visible = base != 0;
>
>         if (intel_crtc->cursor_visible != visible) {
> +               int16_t width = intel_crtc->cursor_width;
>                 uint32_t cntl = I915_READ(CURCNTR_IVB(pipe));
>                 if (base) {
>                         cntl &= ~CURSOR_MODE;
> -                       cntl |= CURSOR_MODE_64_ARGB_AX | MCURSOR_GAMMA_ENABLE;
> +
> +                       switch (width) {
> +                               case 64:
> +                                       cntl |= CURSOR_MODE_64_ARGB_AX | MCURSOR_GAMMA_ENABLE;
> +                                       break;
> +                               case 128:
> +                                       cntl |= CURSOR_MODE_128_ARGB_AX | MCURSOR_GAMMA_ENABLE;
> +                                       break;
> +                               case 256:
> +                                       cntl |= CURSOR_MODE_256_ARGB_AX | MCURSOR_GAMMA_ENABLE;
> +                                       break;
> +                       }
>                 } else {
>                         cntl &= ~(CURSOR_MODE | MCURSOR_GAMMA_ENABLE);
>                         cntl |= CURSOR_MODE_DISABLE;
> @@ -7567,9 +7591,11 @@ static int intel_crtc_cursor_set(struct drm_crtc *crtc,
>                 goto finish;
>         }
>
> -       /* Currently we only support 64x64 cursors */
> -       if (width != 64 || height != 64) {
> -               DRM_ERROR("we currently only support 64x64 cursors\n");
> +       /* Check for which cursor types we support */
> +       if (!((width == 64 && height == 64) ||
> +                       (width == 128 && height == 128 && !IS_GEN2(dev)) ||
> +                       (width == 256 && height == 256 && !IS_GEN2(dev)))) {
> +               DRM_DEBUG("Cursor dimension not supported\n");
>                 return -EINVAL;
>         }
>
> --
> 1.8.5
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
