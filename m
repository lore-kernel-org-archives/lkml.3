Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaJQO2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 10:28:30 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:38793 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaJQO23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 10:28:29 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: David Airlie <airlied@linux.ie>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Rob Clark <robdclark@gmail.com>
Subject: [PATCH 3.17] drm/msm: Fix fbdev for 16- and 24-bit modes.
Date: Fri, 17 Oct 2014 15:28:08 +0100
Message-Id: <1413556088-30194-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently forcing the video mode from the kernel command line (for example
video=HDMI-A-1:1280x720-16@60) does not correctly set the number of bits
per pixel. This is due to a rather aggressive override in
msm_fbdev_create(). This is a particular problem for Android bring up
because the software EGL fallbacks don't support 32bpp.

This problem could be trivially fixed by removing the override completely.
However to avoid regressing commit 96673ecbd7f6 ("drm/msm: default to
XR24 rather than AR24") this patch continues to override the depth if
there are 32 bits per pixel.

Change was tested by dd'ing a test image to /dev/fb0 with no video=
(still 32bpp, DBG() message observed), video=1920x1080-32@60 (message
observed), video=1920x1080-24@60 and video=1920x1080-16@60 .

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: David Airlie <airlied@linux.ie>
Cc: Rob Clark <robdclark@gmail.com>
---
 drivers/gpu/drm/msm/msm_fbdev.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_fbdev.c b/drivers/gpu/drm/msm/msm_fbdev.c
index ab5bfd2..ed0171d 100644
--- a/drivers/gpu/drm/msm/msm_fbdev.c
+++ b/drivers/gpu/drm/msm/msm_fbdev.c
@@ -93,8 +93,10 @@ static int msm_fbdev_create(struct drm_fb_helper *helper,
 	uint32_t paddr;
 	int ret, size;

-	sizes->surface_bpp = 32;
-	sizes->surface_depth = 24;
+	if (sizes->surface_bpp == 32) {
+		DBG("forcing surface depth to 24\n");
+		sizes->surface_depth = 24;
+	}

 	DBG("create fbdev: %dx%d@%d (%dx%d)", sizes->surface_width,
 			sizes->surface_height, sizes->surface_bpp,
--
1.9.3

