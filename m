Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab3H2SaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:30:15 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:33865 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516Ab3H2SaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:30:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130829181412.GX30088@pengutronix.de>
References: <1377784762-24045-1-git-send-email-fabio.estevam@freescale.com>
	<20130829181412.GX30088@pengutronix.de>
Date: Thu, 29 Aug 2013 15:30:12 -0300
Message-ID: <CAOMZO5BXowdp87WavAS5t0q2K6nxFvcrAp-WK5anfDub+H+5kA@mail.gmail.com>
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

On Thu, Aug 29, 2013 at 3:14 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Thu, Aug 29, 2013 at 10:59:22AM -0300, Fabio Estevam wrote:
>> Since commit b5dc0d10 (drm/imx: kill firstopen callback) the following probe
>> failure is seen:
>>
>> [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
>> [drm] No driver support for vblank timestamp query.
>> [drm] Initialized imx-drm 1.0.0 20120507 on minor 0
>> imx-ldb ldb.10: adding encoder failed with -16
>> imx-ldb: probe of ldb.10 failed with error -16
>> imx-ipuv3 2400000.ipu: IPUv3H probed
>> imx-ipuv3 2800000.ipu: IPUv3H probed
>> imx-ipuv3-crtc imx-ipuv3-crtc.0: adding crtc failed with -16.
>> imx-ipuv3-crtc: probe of imx-ipuv3-crtc.0 failed with error -16
>> imx-ipuv3-crtc imx-ipuv3-crtc.1: adding crtc failed with -16.
>> imx-ipuv3-crtc: probe of imx-ipuv3-crtc.1 failed with error -16
>> imx-ipuv3-crtc imx-ipuv3-crtc.2: adding crtc failed with -16.
>> imx-ipuv3-crtc: probe of imx-ipuv3-crtc.2 failed with error -16
>> imx-ipuv3-crtc imx-ipuv3-crtc.3: adding crtc failed with -16.
>> imx-ipuv3-crtc: probe of imx-ipuv3-crtc.3 failed with error -16
>>
>> The reason for the probe failure is that now 'imxdrm->references' is incremented
>> early in imx_drm_driver_load(), so the following checks in imx_drm_add_crtc()
>> and imx_drm_add_encoder():
>>
>>       if (imxdrm->references) {
>>               ret = -EBUSY;
>>               goto err_busy;
>>       }
>>
>> ,will always fail.
>>
>> Let the drm core handle the references instead of doing this manually in
>> imx-drm. In imx-drm-core the open and close callbacks map to drm_open and
>> drm_close, which handle the references via open_count.
>>
>> After this patch, lvds panel is functional on a mx6qsabrelite board.
>>
>> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
>> ---
>> Changes since v1:
>> - Improved commit log by providing an explanation to the probe failure
>> - Cc'ed Dave/Daniel
>>
>> @@ -485,11 +480,6 @@ int imx_drm_add_crtc(struct drm_crtc *crtc,
>>
>>       mutex_lock(&imxdrm->mutex);
>>
>> -     if (imxdrm->references) {
>> -             ret = -EBUSY;
>> -             goto err_busy;
>> -     }
>
> As I told in v1: Simply removing the code is not an option. We agreed
> that we use the drm core reference counting, so you must actually test
> for it here...

Yes, we did, but after reading a separate thread on this topic, I
learned that drm core does not support it currently.

Daniel mentions [1]: "And I wouldn't worry about module unloading and
refcounting for
now since core drm is terminally broken in that area already anyway"

[1] http://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg43698.html

Can't we just apply this patch so that imx-drm can be functional again
and fix module unloading/refcount later?
