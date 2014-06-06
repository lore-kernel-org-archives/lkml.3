Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaFFHsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:48:08 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:53567 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaFFHsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:48:04 -0400
Date: Fri, 6 Jun 2014 09:47:59 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 5/5] drm/i915: Kick out vga console
Message-ID: <20140606074758.GA7416@phenom.ffwll.local>
Mail-Followup-To: David Herrmann <dh.herrmann@gmail.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Chris Wilson <chris@chris-wilson.co.uk>
References: <1401980308-5116-1-git-send-email-daniel.vetter@ffwll.ch>
 <1401980308-5116-5-git-send-email-daniel.vetter@ffwll.ch>
 <CANq1E4Si5+DVVz5xUcp0FXaX2rSH0XJTCa_TBD5PtRs0cJwo0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANq1E4Si5+DVVz5xUcp0FXaX2rSH0XJTCa_TBD5PtRs0cJwo0A@mail.gmail.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 09:28:03AM +0200, David Herrmann wrote:
> Hi
> 
> On Thu, Jun 5, 2014 at 4:58 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > Touching the VGA resources on an IVB EFI machine causes hard hangs when
> > we then kick out the efifb. Ouch.
> >
> > Apparently this also prevents unclaimed register errors on hsw and
> > hard machine hangs on my i855gm when trying to unbind fbcon.
> >
> > Also, we want this to make I915_FBDEV=n safe.
> >
> > v2: Rebase and pimp commit message.
> >
> > v3: We also need to unregister the vga console, otherwise the unbind
> > of the fb console before module unload might resurrect it again.
> >
> > v4: Ignore errors when the vga console is already unregistered - this
> > can happen when e.g. reloading i915.ko.
> >
> > Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=67813
> > Cc: David Herrmann <dh.herrmann@gmail.com>
> > Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> > Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > Cc: linux-fbdev@vger.kernel.org
> > Cc: Jani Nikula <jani.nikula@linux.intel.com>
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk> (v1)
> > Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > ---
> >  drivers/gpu/drm/i915/i915_dma.c  | 43 +++++++++++++++++++++++++++++++++++++++-
> >  drivers/video/console/dummycon.c |  1 +
> >  drivers/video/console/vgacon.c   |  1 +
> >  3 files changed, 44 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
> > index 27fe65ac5940..bcb66ddd649e 100644
> > --- a/drivers/gpu/drm/i915/i915_dma.c
> > +++ b/drivers/gpu/drm/i915/i915_dma.c
> > @@ -36,6 +36,8 @@
> >  #include "i915_drv.h"
> >  #include "i915_trace.h"
> >  #include <linux/pci.h>
> > +#include <linux/console.h>
> > +#include <linux/vt.h>
> >  #include <linux/vgaarb.h>
> >  #include <linux/acpi.h>
> >  #include <linux/pnp.h>
> > @@ -1449,6 +1451,38 @@ static void i915_kick_out_firmware_fb(struct drm_i915_private *dev_priv)
> >  }
> >  #endif
> >
> > +#if !defined(CONFIG_VGA_CONSOLE)
> > +static int i915_kick_out_vgacon(struct drm_i915_private *dev_priv)
> > +{
> > +       return 0;
> > +}
> > +#elif !defined(CONFIG_DUMMY_CONSOLE)
> 
> Why not "select DUMMY_CONSOLE if VT"? It's really stupid to disable
> DUMMY_CONSOLE.. Furthermore, we already rely on HW_CONSOLE_BINDING so
> this should be safe.

Iirc this lead kconfig to complain about dep loops ... And I've tried to
figure it out, but I think it's actually impossible. So I let it be with
the -ENODEV to make sure if it's not impossible any more we'll catch it.
-Daniel

> 
> Patch looks good to me:
> 
> Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
> 
> Thanks
> David
> 
> > +static int i915_kick_out_vgacon(struct drm_i915_private *dev_priv)
> > +{
> > +       return -ENODEV;
> > +}
> > +#else
> > +static int i915_kick_out_vgacon(struct drm_i915_private *dev_priv)
> > +{
> > +       int ret;
> > +
> > +       DRM_INFO("Replacing VGA console driver\n");
> > +
> > +       console_lock();
> > +       ret = do_take_over_console(&dummy_con, 0, MAX_NR_CONSOLES - 1, 1);
> > +       if (ret == 0) {
> > +               ret = do_unregister_con_driver(&vga_con);
> > +
> > +               /* Ignore "already unregistered". */
> > +               if (ret == -ENODEV)
> > +                       ret = 0;
> > +       }
> > +       console_unlock();
> > +
> > +       return ret;
> > +}
> > +#endif
> > +
> >  static void i915_dump_device_info(struct drm_i915_private *dev_priv)
> >  {
> >         const struct intel_device_info *info = &dev_priv->info;
> > @@ -1622,8 +1656,15 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
> >         if (ret)
> >                 goto out_regs;
> >
> > -       if (drm_core_check_feature(dev, DRIVER_MODESET))
> > +       if (drm_core_check_feature(dev, DRIVER_MODESET)) {
> > +               ret = i915_kick_out_vgacon(dev_priv);
> > +               if (ret) {
> > +                       DRM_ERROR("failed to remove conflicting VGA console\n");
> > +                       goto out_gtt;
> > +               }
> > +
> >                 i915_kick_out_firmware_fb(dev_priv);
> > +       }
> >
> >         pci_set_master(dev->pdev);
> >
> > diff --git a/drivers/video/console/dummycon.c b/drivers/video/console/dummycon.c
> > index b63860f7beab..40bec8d64b0a 100644
> > --- a/drivers/video/console/dummycon.c
> > +++ b/drivers/video/console/dummycon.c
> > @@ -77,3 +77,4 @@ const struct consw dummy_con = {
> >      .con_set_palette = DUMMY,
> >      .con_scrolldelta = DUMMY,
> >  };
> > +EXPORT_SYMBOL_GPL(dummy_con);
> > diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
> > index 9d8feac67637..84acd6223dc5 100644
> > --- a/drivers/video/console/vgacon.c
> > +++ b/drivers/video/console/vgacon.c
> > @@ -1440,5 +1440,6 @@ const struct consw vga_con = {
> >         .con_build_attr = vgacon_build_attr,
> >         .con_invert_region = vgacon_invert_region,
> >  };
> > +EXPORT_SYMBOL(vga_con);
> >
> >  MODULE_LICENSE("GPL");
> > --
> > 1.8.1.4
> >

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
