Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab3KLOc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:32:28 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:37247 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491Ab3KLOcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:32:09 -0500
MIME-Version: 1.0
In-Reply-To: <CA+5PVA72-oR=-T=dL=Y=+gymuDSMd1E8VrSbzGQDxxuJDfoKZg@mail.gmail.com>
References: <CA+5PVA72-oR=-T=dL=Y=+gymuDSMd1E8VrSbzGQDxxuJDfoKZg@mail.gmail.com>
Date: Tue, 12 Nov 2013 09:32:08 -0500
X-Google-Sender-Auth: 7xAKhWuizmvormKcuR1VLeuUjCk
Message-ID: <CA+5PVA6c6fu5vEnkf1Fk4BE_r-i4Bv1noOoz1sAPDpP3U3PDjw@mail.gmail.com>
Subject: Re: imx-drm/ipuv3-crtc.ko fails to link
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Dave Airlie <airlied@gmail.com>,
        devel@driverdev.osuosl.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 11:22 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> Hi All,
>
> With v3.12-2839-gedae583 (Linus' tree as of this morning), the
> ipuv3-crtc.ko module fails to link with the following messages:
>
> ERROR: "ipu_plane_disable" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
> ERROR: "ipu_plane_enable" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
> ERROR: "ipu_plane_irq" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
> ERROR: "ipu_plane_get_resources"
> [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
> ERROR: "ipu_plane_init" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
> ERROR: "imx_drm_crtc_id" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
> ERROR: "ipu_plane_mode_set" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
> ERROR: "ipu_plane_set_base" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
> ERROR: "ipu_plane_put_resources"
> [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2

Actually, I think this is because ipuv3-plane.c was added to the
Makefile as a requisite file for ipuv3-crtc.ko with commit
b8d181e408af6a017d, but Kbuild isn't interpreting it that way because
it's a tristate option, not a bool.  Making it work would require
something like:

imx-ipuv3-crct-objs  := ipuv3-crtc.o ipuv3-plane.o
obj-$(CONFIG_DRM_IMX_IPUV3)  += imx-ipuv3-crct.o

But that would rename the module from ipuv3-crtc.ko to
imx-ipuv3-crct.ko.  Even with that, it still fails to link with:

ERROR: "imx_drm_crtc_id" [drivers/staging/imx-drm/imx-ipuv3-crtc.ko] undefined!

So two questions really.

1) Are the tristate options for DRM_IMX_IPUV3, DRM_IMX_IPUV3_CORE,
DRM_IMX_LDB, DRM_IMX_TVE, DRM_IMX_PARALLEL_DISPLAY, and
DRM_IMX_FB_HELPER really all supposed to be separate modules, or
should they be boolean options to the main DRM_IMX tristate?

2) If the answer to question 1 is "all separate modules", then either
ipuv3-crtc.c needs to be renamed or the final module name will be
different.

And did anyone actually try building all of these as modules?  This
used to work in 3.12, but I'm not sure that was actually tested there
either.

josh
