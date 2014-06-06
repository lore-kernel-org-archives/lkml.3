Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaFFPUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:20:34 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:60929 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaFFPUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:20:33 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <1401980308-5116-5-git-send-email-daniel.vetter@ffwll.ch>
References: <1401980308-5116-1-git-send-email-daniel.vetter@ffwll.ch>
	<1401980308-5116-5-git-send-email-daniel.vetter@ffwll.ch>
Date: Fri, 6 Jun 2014 17:20:30 +0200
Message-ID: <CAKMK7uH7GWspr03NBi7rVY+2UN-vdthMV7eixXA-xc3t2JdzPg@mail.gmail.com>
Subject: Re: [PATCH 5/5] drm/i915: Kick out vga console
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Herrmann <dh.herrmann@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomi/Jean can you please ack merging this through drm-intel trees? It
just exports the vga and dummy consoles so that i915 can do what it
needs to do.

Thanks, Daniel

On Thu, Jun 5, 2014 at 4:58 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> Touching the VGA resources on an IVB EFI machine causes hard hangs when
> we then kick out the efifb. Ouch.
>
> Apparently this also prevents unclaimed register errors on hsw and
> hard machine hangs on my i855gm when trying to unbind fbcon.
>
> Also, we want this to make I915_FBDEV=n safe.
>
> v2: Rebase and pimp commit message.
>
> v3: We also need to unregister the vga console, otherwise the unbind
> of the fb console before module unload might resurrect it again.
>
> v4: Ignore errors when the vga console is already unregistered - this
> can happen when e.g. reloading i915.ko.
>
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=67813
> Cc: David Herrmann <dh.herrmann@gmail.com>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: linux-fbdev@vger.kernel.org
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk> (v1)
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
>  drivers/gpu/drm/i915/i915_dma.c  | 43 +++++++++++++++++++++++++++++++++++++++-
>  drivers/video/console/dummycon.c |  1 +
>  drivers/video/console/vgacon.c   |  1 +
>  3 files changed, 44 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
> index 27fe65ac5940..bcb66ddd649e 100644
> --- a/drivers/gpu/drm/i915/i915_dma.c
> +++ b/drivers/gpu/drm/i915/i915_dma.c
> @@ -36,6 +36,8 @@
>  #include "i915_drv.h"
>  #include "i915_trace.h"
>  #include <linux/pci.h>
> +#include <linux/console.h>
> +#include <linux/vt.h>
>  #include <linux/vgaarb.h>
>  #include <linux/acpi.h>
>  #include <linux/pnp.h>
> @@ -1449,6 +1451,38 @@ static void i915_kick_out_firmware_fb(struct drm_i915_private *dev_priv)
>  }
>  #endif
>
> +#if !defined(CONFIG_VGA_CONSOLE)
> +static int i915_kick_out_vgacon(struct drm_i915_private *dev_priv)
> +{
> +       return 0;
> +}
> +#elif !defined(CONFIG_DUMMY_CONSOLE)
> +static int i915_kick_out_vgacon(struct drm_i915_private *dev_priv)
> +{
> +       return -ENODEV;
> +}
> +#else
> +static int i915_kick_out_vgacon(struct drm_i915_private *dev_priv)
> +{
> +       int ret;
> +
> +       DRM_INFO("Replacing VGA console driver\n");
> +
> +       console_lock();
> +       ret = do_take_over_console(&dummy_con, 0, MAX_NR_CONSOLES - 1, 1);
> +       if (ret == 0) {
> +               ret = do_unregister_con_driver(&vga_con);
> +
> +               /* Ignore "already unregistered". */
> +               if (ret == -ENODEV)
> +                       ret = 0;
> +       }
> +       console_unlock();
> +
> +       return ret;
> +}
> +#endif
> +
>  static void i915_dump_device_info(struct drm_i915_private *dev_priv)
>  {
>         const struct intel_device_info *info = &dev_priv->info;
> @@ -1622,8 +1656,15 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
>         if (ret)
>                 goto out_regs;
>
> -       if (drm_core_check_feature(dev, DRIVER_MODESET))
> +       if (drm_core_check_feature(dev, DRIVER_MODESET)) {
> +               ret = i915_kick_out_vgacon(dev_priv);
> +               if (ret) {
> +                       DRM_ERROR("failed to remove conflicting VGA console\n");
> +                       goto out_gtt;
> +               }
> +
>                 i915_kick_out_firmware_fb(dev_priv);
> +       }
>
>         pci_set_master(dev->pdev);
>
> diff --git a/drivers/video/console/dummycon.c b/drivers/video/console/dummycon.c
> index b63860f7beab..40bec8d64b0a 100644
> --- a/drivers/video/console/dummycon.c
> +++ b/drivers/video/console/dummycon.c
> @@ -77,3 +77,4 @@ const struct consw dummy_con = {
>      .con_set_palette = DUMMY,
>      .con_scrolldelta = DUMMY,
>  };
> +EXPORT_SYMBOL_GPL(dummy_con);
> diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
> index 9d8feac67637..84acd6223dc5 100644
> --- a/drivers/video/console/vgacon.c
> +++ b/drivers/video/console/vgacon.c
> @@ -1440,5 +1440,6 @@ const struct consw vga_con = {
>         .con_build_attr = vgacon_build_attr,
>         .con_invert_region = vgacon_invert_region,
>  };
> +EXPORT_SYMBOL(vga_con);
>
>  MODULE_LICENSE("GPL");
> --
> 1.8.1.4
>



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
