Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab3H2SOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:14:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53823 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436Ab3H2SOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:14:21 -0400
Date: Thu, 29 Aug 2013 20:14:12 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: airlied@redhat.com, daniel.vetter@ffwll.ch, gregkh@linuxfoundation.org,
        festevam@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] imx-drm: Fix probe failure
Message-ID: <20130829181412.GX30088@pengutronix.de>
References: <1377784762-24045-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377784762-24045-1-git-send-email-fabio.estevam@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 20:09:23 up 5 days,  3:40, 29 users,  load average: 0.05, 0.03, 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 10:59:22AM -0300, Fabio Estevam wrote:
> Since commit b5dc0d10 (drm/imx: kill firstopen callback) the following probe
> failure is seen:
> 
> [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [drm] No driver support for vblank timestamp query.
> [drm] Initialized imx-drm 1.0.0 20120507 on minor 0
> imx-ldb ldb.10: adding encoder failed with -16
> imx-ldb: probe of ldb.10 failed with error -16
> imx-ipuv3 2400000.ipu: IPUv3H probed
> imx-ipuv3 2800000.ipu: IPUv3H probed
> imx-ipuv3-crtc imx-ipuv3-crtc.0: adding crtc failed with -16.
> imx-ipuv3-crtc: probe of imx-ipuv3-crtc.0 failed with error -16
> imx-ipuv3-crtc imx-ipuv3-crtc.1: adding crtc failed with -16.
> imx-ipuv3-crtc: probe of imx-ipuv3-crtc.1 failed with error -16
> imx-ipuv3-crtc imx-ipuv3-crtc.2: adding crtc failed with -16.
> imx-ipuv3-crtc: probe of imx-ipuv3-crtc.2 failed with error -16
> imx-ipuv3-crtc imx-ipuv3-crtc.3: adding crtc failed with -16.
> imx-ipuv3-crtc: probe of imx-ipuv3-crtc.3 failed with error -16
> 
> The reason for the probe failure is that now 'imxdrm->references' is incremented
> early in imx_drm_driver_load(), so the following checks in imx_drm_add_crtc()
> and imx_drm_add_encoder():
> 
> 	if (imxdrm->references) {
> 		ret = -EBUSY;
> 		goto err_busy;
> 	}
> 
> ,will always fail.
> 
> Let the drm core handle the references instead of doing this manually in 
> imx-drm. In imx-drm-core the open and close callbacks map to drm_open and 
> drm_close, which handle the references via open_count.
> 
> After this patch, lvds panel is functional on a mx6qsabrelite board.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
> Changes since v1:
> - Improved commit log by providing an explanation to the probe failure
> - Cc'ed Dave/Daniel
> 
> @@ -485,11 +480,6 @@ int imx_drm_add_crtc(struct drm_crtc *crtc,
>  
>  	mutex_lock(&imxdrm->mutex);
>  
> -	if (imxdrm->references) {
> -		ret = -EBUSY;
> -		goto err_busy;
> -	}

As I told in v1: Simply removing the code is not an option. We agreed
that we use the drm core reference counting, so you must actually test
for it here...

> @@ -564,11 +553,6 @@ int imx_drm_add_encoder(struct drm_encoder *encoder,
>  
>  	mutex_lock(&imxdrm->mutex);
>  
> -	if (imxdrm->references) {
> -		ret = -EBUSY;
> -		goto err_busy;
> -	}

...here...

>  	mutex_lock(&imxdrm->mutex);
>  
> -	if (imxdrm->references) {
> -		ret = -EBUSY;
> -		goto err_busy;
> -	}

...and here.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
