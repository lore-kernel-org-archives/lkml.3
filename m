Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab3KLO6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:58:11 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37992 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab3KLO6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:58:03 -0500
Date: Tue, 12 Nov 2013 15:57:52 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, Dave Airlie <airlied@gmail.com>,
        devel@driverdev.osuosl.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: imx-drm/ipuv3-crtc.ko fails to link
Message-ID: <20131112145752.GM24559@pengutronix.de>
References: <CA+5PVA72-oR=-T=dL=Y=+gymuDSMd1E8VrSbzGQDxxuJDfoKZg@mail.gmail.com>
 <CA+5PVA6c6fu5vEnkf1Fk4BE_r-i4Bv1noOoz1sAPDpP3U3PDjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA6c6fu5vEnkf1Fk4BE_r-i4Bv1noOoz1sAPDpP3U3PDjw@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:53:17 up 80 days, 24 min, 56 users,  load average: 0.21, 0.11,
 0.07
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

On Tue, Nov 12, 2013 at 09:32:08AM -0500, Josh Boyer wrote:
> On Mon, Nov 11, 2013 at 11:22 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> > Hi All,
> >
> > With v3.12-2839-gedae583 (Linus' tree as of this morning), the
> > ipuv3-crtc.ko module fails to link with the following messages:
> >
> > ERROR: "ipu_plane_disable" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
> > ERROR: "ipu_plane_enable" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
> > ERROR: "ipu_plane_irq" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
> > ERROR: "ipu_plane_get_resources"
> > [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
> > ERROR: "ipu_plane_init" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
> > ERROR: "imx_drm_crtc_id" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
> > ERROR: "ipu_plane_mode_set" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
> > ERROR: "ipu_plane_set_base" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
> > ERROR: "ipu_plane_put_resources"
> > [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
> > make[1]: *** [__modpost] Error 1
> > make: *** [modules] Error 2
> 
> Actually, I think this is because ipuv3-plane.c was added to the
> Makefile as a requisite file for ipuv3-crtc.ko with commit
> b8d181e408af6a017d, but Kbuild isn't interpreting it that way because
> it's a tristate option, not a bool.  Making it work would require
> something like:
> 
> imx-ipuv3-crct-objs  := ipuv3-crtc.o ipuv3-plane.o
> obj-$(CONFIG_DRM_IMX_IPUV3)  += imx-ipuv3-crct.o
> 
> But that would rename the module from ipuv3-crtc.ko to
> imx-ipuv3-crct.ko.  Even with that, it still fails to link with:
> 
> ERROR: "imx_drm_crtc_id" [drivers/staging/imx-drm/imx-ipuv3-crtc.ko] undefined!
> 
> So two questions really.
> 
> 1) Are the tristate options for DRM_IMX_IPUV3, DRM_IMX_IPUV3_CORE,
> DRM_IMX_LDB, DRM_IMX_TVE, DRM_IMX_PARALLEL_DISPLAY, and
> DRM_IMX_FB_HELPER really all supposed to be separate modules, or
> should they be boolean options to the main DRM_IMX tristate?

I think at least the ipuv3 core should be a separate module since this
could be used without drm support (for the input pathes, handled via v4l2)

> 
> 2) If the answer to question 1 is "all separate modules", then either
> ipuv3-crtc.c needs to be renamed or the final module name will be
> different.

The final module name shouldn't matter, we can change it.

Does a EXPORT_SYMBOL_GPL(imx_drm_crtc_id) help fixing the problem?

> 
> And did anyone actually try building all of these as modules?  This
> used to work in 3.12, but I'm not sure that was actually tested there
> either.

At least I explicitly made this work when writing the IPU stuff, but I
must admit that we mostly use monolithic kernels here.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
