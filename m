Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab3H2PVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 11:21:22 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:45080 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab3H2PVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 11:21:21 -0400
Date: Thu, 29 Aug 2013 17:21:30 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: airlied@redhat.com, daniel.vetter@ffwll.ch, gregkh@linuxfoundation.org,
        s.hauer@pengutronix.de, festevam@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] imx-drm: Fix probe failure
Message-ID: <20130829152130.GD5606@phenom.ffwll.local>
Mail-Followup-To: Fabio Estevam <fabio.estevam@freescale.com>,
	airlied@redhat.com, gregkh@linuxfoundation.org,
	s.hauer@pengutronix.de, festevam@gmail.com,
	linux-kernel@vger.kernel.org
References: <1377784762-24045-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377784762-24045-1-git-send-email-fabio.estevam@freescale.com>
X-Operating-System: Linux phenom 3.11.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
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

Yeah, just ripping out the imxdrm->references stuff will restore imx, but
of course all the funny races are still fundamentally there. So we still
rely on userspace being really careful to obey the right module loading
sequence and not start any drm client before that has all completed. So

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Greg, when you slurp this in can you pls also add the imx todo entry from
the other thread?

http://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg43698.html

Or do you want me to send in a real patch?

Thanks, Daniel


> ---
> Changes since v1:
> - Improved commit log by providing an explanation to the probe failure
> - Cc'ed Dave/Daniel
> 
>  drivers/staging/imx-drm/imx-drm-core.c | 23 -----------------------
>  1 file changed, 23 deletions(-)
> 
> diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
> index 47c5888..6f0d24c 100644
> --- a/drivers/staging/imx-drm/imx-drm-core.c
> +++ b/drivers/staging/imx-drm/imx-drm-core.c
> @@ -41,7 +41,6 @@ struct imx_drm_device {
>  	struct list_head			encoder_list;
>  	struct list_head			connector_list;
>  	struct mutex				mutex;
> -	int					references;
>  	int					pipes;
>  	struct drm_fbdev_cma			*fbhelper;
>  };
> @@ -241,8 +240,6 @@ struct drm_device *imx_drm_device_get(void)
>  		}
>  	}
>  
> -	imxdrm->references++;
> -
>  	return imxdrm->drm;
>  
>  unwind_crtc:
> @@ -280,8 +277,6 @@ void imx_drm_device_put(void)
>  	list_for_each_entry(enc, &imxdrm->encoder_list, list)
>  		module_put(enc->owner);
>  
> -	imxdrm->references--;
> -
>  	mutex_unlock(&imxdrm->mutex);
>  }
>  EXPORT_SYMBOL_GPL(imx_drm_device_put);
> @@ -485,11 +480,6 @@ int imx_drm_add_crtc(struct drm_crtc *crtc,
>  
>  	mutex_lock(&imxdrm->mutex);
>  
> -	if (imxdrm->references) {
> -		ret = -EBUSY;
> -		goto err_busy;
> -	}
> -
>  	imx_drm_crtc = kzalloc(sizeof(*imx_drm_crtc), GFP_KERNEL);
>  	if (!imx_drm_crtc) {
>  		ret = -ENOMEM;
> @@ -523,7 +513,6 @@ int imx_drm_add_crtc(struct drm_crtc *crtc,
>  err_register:
>  	kfree(imx_drm_crtc);
>  err_alloc:
> -err_busy:
>  	mutex_unlock(&imxdrm->mutex);
>  	return ret;
>  }
> @@ -564,11 +553,6 @@ int imx_drm_add_encoder(struct drm_encoder *encoder,
>  
>  	mutex_lock(&imxdrm->mutex);
>  
> -	if (imxdrm->references) {
> -		ret = -EBUSY;
> -		goto err_busy;
> -	}
> -
>  	imx_drm_encoder = kzalloc(sizeof(*imx_drm_encoder), GFP_KERNEL);
>  	if (!imx_drm_encoder) {
>  		ret = -ENOMEM;
> @@ -595,7 +579,6 @@ int imx_drm_add_encoder(struct drm_encoder *encoder,
>  err_register:
>  	kfree(imx_drm_encoder);
>  err_alloc:
> -err_busy:
>  	mutex_unlock(&imxdrm->mutex);
>  
>  	return ret;
> @@ -709,11 +692,6 @@ int imx_drm_add_connector(struct drm_connector *connector,
>  
>  	mutex_lock(&imxdrm->mutex);
>  
> -	if (imxdrm->references) {
> -		ret = -EBUSY;
> -		goto err_busy;
> -	}
> -
>  	imx_drm_connector = kzalloc(sizeof(*imx_drm_connector), GFP_KERNEL);
>  	if (!imx_drm_connector) {
>  		ret = -ENOMEM;
> @@ -738,7 +716,6 @@ int imx_drm_add_connector(struct drm_connector *connector,
>  err_register:
>  	kfree(imx_drm_connector);
>  err_alloc:
> -err_busy:
>  	mutex_unlock(&imxdrm->mutex);
>  
>  	return ret;
> -- 
> 1.8.1.2
> 
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
