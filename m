Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab3H3QIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 12:08:17 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:52632 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab3H3QIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 12:08:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130829183706.GZ30088@pengutronix.de>
References: <1377784762-24045-1-git-send-email-fabio.estevam@freescale.com>
	<20130829181412.GX30088@pengutronix.de>
	<CAOMZO5BXowdp87WavAS5t0q2K6nxFvcrAp-WK5anfDub+H+5kA@mail.gmail.com>
	<20130829183706.GZ30088@pengutronix.de>
Date: Fri, 30 Aug 2013 13:08:14 -0300
Message-ID: <CAOMZO5ANriVriw5W6qPG7OxPAsbvVHfZfzoCJk-d3aiAtyQkFA@mail.gmail.com>
Subject: Re: [PATCH v2] imx-drm: Fix probe failure
From: Fabio Estevam <festevam@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Dave Airlie <airlied@redhat.com>, daniel.vetter@ffwll.ch,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

On Thu, Aug 29, 2013 at 3:37 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> It's not about the module refcount. It's only that a on a drm device
> which is in use you better do not add/remove components.
>
> Again: The imx-drm driver does *not* do hotplugging. It will *not* add
> or remove components when the device is opened. The code you remove
> exactly makes (or made before Daniels patch) that sure.

I am not sure what would be the correct fix for this.

What about this?

--- a/drivers/staging/imx-drm/imx-drm-core.c
+++ b/drivers/staging/imx-drm/imx-drm-core.c
@@ -438,6 +438,8 @@ static int imx_drm_driver_load(struct drm_device
*drm, unsigned long flags)
                ret = -EINVAL;

        ret = 0;
+
+       imxdrm->references = -1;

 err_init:
        mutex_unlock(&imxdrm->mutex);
@@ -485,7 +487,7 @@ int imx_drm_add_crtc(struct drm_crtc *crtc,

        mutex_lock(&imxdrm->mutex);

-       if (imxdrm->references) {
+       if (imxdrm->references > 0) {
                ret = -EBUSY;
                goto err_busy;
        }
@@ -564,7 +566,7 @@ int imx_drm_add_encoder(struct drm_encoder *encoder,

        mutex_lock(&imxdrm->mutex);

-       if (imxdrm->references) {
+       if (imxdrm->references > 0) {
                ret = -EBUSY;
                goto err_busy;
        }
@@ -709,7 +711,7 @@ int imx_drm_add_connector(struct drm_connector *connector,

        mutex_lock(&imxdrm->mutex);

-       if (imxdrm->references) {
+       if (imxdrm->references > 0) {
                ret = -EBUSY;
                goto err_busy;
        }
