Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab3H2SbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:31:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43437 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab3H2SbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:31:19 -0400
Date: Thu, 29 Aug 2013 20:31:14 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <fabio.estevam@freescale.com>, airlied@redhat.com,
        gregkh@linuxfoundation.org, festevam@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] imx-drm: Fix probe failure
Message-ID: <20130829183114.GY30088@pengutronix.de>
References: <1377784762-24045-1-git-send-email-fabio.estevam@freescale.com>
 <20130829152130.GD5606@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130829152130.GD5606@phenom.ffwll.local>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 20:21:19 up 5 days,  3:52, 38 users,  load average: 0.00, 0.01, 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 05:21:30PM +0200, Daniel Vetter wrote:
> On Thu, Aug 29, 2013 at 10:59:22AM -0300, Fabio Estevam wrote:
> > Since commit b5dc0d10 (drm/imx: kill firstopen callback) the following probe
> > failure is seen:
> > 
> > [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> > [drm] No driver support for vblank timestamp query.
> > [drm] Initialized imx-drm 1.0.0 20120507 on minor 0
> > imx-ldb ldb.10: adding encoder failed with -16
> > imx-ldb: probe of ldb.10 failed with error -16
> > imx-ipuv3 2400000.ipu: IPUv3H probed
> > imx-ipuv3 2800000.ipu: IPUv3H probed
> > imx-ipuv3-crtc imx-ipuv3-crtc.0: adding crtc failed with -16.
> > imx-ipuv3-crtc: probe of imx-ipuv3-crtc.0 failed with error -16
> > imx-ipuv3-crtc imx-ipuv3-crtc.1: adding crtc failed with -16.
> > imx-ipuv3-crtc: probe of imx-ipuv3-crtc.1 failed with error -16
> > imx-ipuv3-crtc imx-ipuv3-crtc.2: adding crtc failed with -16.
> > imx-ipuv3-crtc: probe of imx-ipuv3-crtc.2 failed with error -16
> > imx-ipuv3-crtc imx-ipuv3-crtc.3: adding crtc failed with -16.
> > imx-ipuv3-crtc: probe of imx-ipuv3-crtc.3 failed with error -16
> > 
> > The reason for the probe failure is that now 'imxdrm->references' is incremented
> > early in imx_drm_driver_load(), so the following checks in imx_drm_add_crtc()
> > and imx_drm_add_encoder():
> > 
> > 	if (imxdrm->references) {
> > 		ret = -EBUSY;
> > 		goto err_busy;
> > 	}
> > 
> > ,will always fail.
> > 
> > Let the drm core handle the references instead of doing this manually in 
> > imx-drm. In imx-drm-core the open and close callbacks map to drm_open and 
> > drm_close, which handle the references via open_count.
> > 
> > After this patch, lvds panel is functional on a mx6qsabrelite board.
> > 
> > Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Yeah, just ripping out the imxdrm->references stuff will restore imx, but
> of course all the funny races are still fundamentally there. So we still
> rely on userspace being really careful to obey the right module loading
> sequence and not start any drm client before that has all completed. So
> 
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> Greg, when you slurp this in can you pls also add the imx todo entry from
> the other thread?
> 
> http://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg43698.html


You said there:

> +- Fix up the driver load sequence to make sure all submodules for encoders/crtcs
> +  are fully loaded before the drm driver is registered.

We can't know when all submodules are registered and really I think this
is not necessary. The driver will use the components available during
open time. When being opened no components will be registered/deregistered.
So a user will always get a functional drm device with the components he
actually loaded.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
