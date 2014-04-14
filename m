Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbaDNVxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:53:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54421 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbaDNVxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:53:33 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: devel@driverdev.osuosl.org, Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 7/8] imx-drm: ipuv3-crtc: Change display enable/disable order
Date: Mon, 14 Apr 2014 23:53:22 +0200
Message-Id: <1397512403-19622-8-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397512403-19622-1-git-send-email-p.zabel@pengutronix.de>
References: <1397512403-19622-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that ipu_dc_disable_channel correctly waits for the channel to finish,
we can reorder the enable/disable order to first stop the DC and DI and
only then disable the IDMAC. Enabling is done the other way around: IDMAC
first, then DC, then DI.

This avoids an issue where sometimes the channel would not correctly start,
leading to non-working LVDS displays.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/imx-drm/ipuv3-crtc.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/imx-drm/ipuv3-crtc.c b/drivers/staging/imx-drm/ipuv3-crtc.c
index c48f640..c771ac1 100644
--- a/drivers/staging/imx-drm/ipuv3-crtc.c
+++ b/drivers/staging/imx-drm/ipuv3-crtc.c
@@ -63,9 +63,11 @@ static void ipu_fb_enable(struct ipu_crtc *ipu_crtc)
 	if (ipu_crtc->enabled)
 		return;
 
-	ipu_di_enable(ipu_crtc->di);
-	ipu_dc_enable_channel(ipu_crtc->dc);
+	/* TODO: Enable DC module here, right now it is never disabled */
 	ipu_plane_enable(ipu_crtc->plane[0]);
+	/* Start DC channel and DI after IDMAC */
+	ipu_dc_enable_channel(ipu_crtc->dc);
+	ipu_di_enable(ipu_crtc->di);
 
 	ipu_crtc->enabled = 1;
 }
@@ -75,9 +77,11 @@ static void ipu_fb_disable(struct ipu_crtc *ipu_crtc)
 	if (!ipu_crtc->enabled)
 		return;
 
-	ipu_plane_disable(ipu_crtc->plane[0]);
+	/* Stop DC channel and DI before IDMAC */
 	ipu_dc_disable_channel(ipu_crtc->dc);
 	ipu_di_disable(ipu_crtc->di);
+	ipu_plane_disable(ipu_crtc->plane[0]);
+	/* TODO: Disable DC module here */
 
 	ipu_crtc->enabled = 0;
 }
-- 
1.9.1

