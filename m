Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab3AUI5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 03:57:40 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:64149 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab3AUI5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 03:57:39 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20121214110100.7836.65250.stgit@zurg>
References: <20121214110100.7836.65250.stgit@zurg>
Date: Mon, 21 Jan 2013 09:57:37 +0100
X-Google-Sender-Auth: 1DslHtsLwTXJH8VRLgEf8R6mrAY
Message-ID: <CAKMK7uGaEo89cZv7heqJ78omzcsKvOJZXP97rshdge0B=WXNhw@mail.gmail.com>
Subject: Re: [PATCH] drm/fb: avoid sleeping in unblank_screen() if oops in progress
From: Daniel Vetter <daniel@ffwll.ch>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 12:01 PM, Konstantin Khlebnikov
<khlebnikov@openvz.org> wrote:
> unblank_screen() can be called from interrupt context during oops.
> thus all ->fb_blank handlers should avoid sleeping in this situation.
>
> callstack:
> panic()
> bust_spinlocks(1)
> unblank_screen()
> vc->vc_sw->con_blank()
> fbcon_blank()
> fb_blank()
> info->fbops->fb_blank()
> drm_fb_helper_blank()
> drm_fb_helper_dpms()
> mutex_lock(&dev->mode_config.mutex)
>
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Airlie <airlied@linux.ie>
> Cc: dri-devel@lists.freedesktop.org

Since the fb helper already has its own panic notifier it's imo better
to just bail out if there's an oops in progress. The panic notifier
itself completely lacks locking though. I'm working on some fb helper
cleanups, so I'll take care of this mess.
-Daniel

> ---
>  drivers/gpu/drm/drm_fb_helper.c |   25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
> index 954d175..2c9f49f 100644
> --- a/drivers/gpu/drm/drm_fb_helper.c
> +++ b/drivers/gpu/drm/drm_fb_helper.c
> @@ -326,7 +326,7 @@ static struct sysrq_key_op sysrq_drm_fb_helper_restore_op = {
>  static struct sysrq_key_op sysrq_drm_fb_helper_restore_op = { };
>  #endif
>
> -static void drm_fb_helper_dpms(struct fb_info *info, int dpms_mode)
> +static int drm_fb_helper_dpms(struct fb_info *info, int dpms_mode)
>  {
>         struct drm_fb_helper *fb_helper = info->par;
>         struct drm_device *dev = fb_helper->dev;
> @@ -334,10 +334,15 @@ static void drm_fb_helper_dpms(struct fb_info *info, int dpms_mode)
>         struct drm_connector *connector;
>         int i, j;
>
> +       if (oops_in_progress) {
> +               if (!mutex_trylock(&dev->mode_config.mutex))
> +                       return -EBUSY;
> +       } else
> +               mutex_lock(&dev->mode_config.mutex);
> +
>         /*
>          * For each CRTC in this fb, turn the connectors on/off.
>          */
> -       mutex_lock(&dev->mode_config.mutex);
>         for (i = 0; i < fb_helper->crtc_count; i++) {
>                 crtc = fb_helper->crtc_info[i].mode_set.crtc;
>
> @@ -353,6 +358,7 @@ static void drm_fb_helper_dpms(struct fb_info *info, int dpms_mode)
>                 }
>         }
>         mutex_unlock(&dev->mode_config.mutex);
> +       return 0;
>  }
>
>  int drm_fb_helper_blank(int blank, struct fb_info *info)
> @@ -360,24 +366,19 @@ int drm_fb_helper_blank(int blank, struct fb_info *info)
>         switch (blank) {
>         /* Display: On; HSync: On, VSync: On */
>         case FB_BLANK_UNBLANK:
> -               drm_fb_helper_dpms(info, DRM_MODE_DPMS_ON);
> -               break;
> +               return drm_fb_helper_dpms(info, DRM_MODE_DPMS_ON);
>         /* Display: Off; HSync: On, VSync: On */
>         case FB_BLANK_NORMAL:
> -               drm_fb_helper_dpms(info, DRM_MODE_DPMS_STANDBY);
> -               break;
> +               return drm_fb_helper_dpms(info, DRM_MODE_DPMS_STANDBY);
>         /* Display: Off; HSync: Off, VSync: On */
>         case FB_BLANK_HSYNC_SUSPEND:
> -               drm_fb_helper_dpms(info, DRM_MODE_DPMS_STANDBY);
> -               break;
> +               return drm_fb_helper_dpms(info, DRM_MODE_DPMS_STANDBY);
>         /* Display: Off; HSync: On, VSync: Off */
>         case FB_BLANK_VSYNC_SUSPEND:
> -               drm_fb_helper_dpms(info, DRM_MODE_DPMS_SUSPEND);
> -               break;
> +               return drm_fb_helper_dpms(info, DRM_MODE_DPMS_SUSPEND);
>         /* Display: Off; HSync: Off, VSync: Off */
>         case FB_BLANK_POWERDOWN:
> -               drm_fb_helper_dpms(info, DRM_MODE_DPMS_OFF);
> -               break;
> +               return drm_fb_helper_dpms(info, DRM_MODE_DPMS_OFF);
>         }
>         return 0;
>  }
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
