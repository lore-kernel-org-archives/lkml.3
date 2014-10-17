Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaJQPtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 11:49:17 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:63617 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaJQPtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 11:49:16 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: David Airlie <airlied@linux.ie>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Rob Clark <robdclark@gmail.com>
Subject: [PATCH 3.17 v2] drm/msm: Fix fbdev for 16- and 24-bit modes.
Date: Fri, 17 Oct 2014 16:48:54 +0100
Message-Id: <1413560934-19268-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413556088-30194-1-git-send-email-daniel.thompson@linaro.org>
References: <1413556088-30194-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently forcing the video mode from the kernel command line (for example
video=HDMI-A-1:1280x720-16@60) does not correctly set the number of bits
per pixel. This is due to a rather aggressive override in
msm_fbdev_create(). This is a particular problem for Android bring up
because the software EGL fallbacks don't support 32bpp.

Since the overrides are actually the default values anyway then this
problem can be trivially fixed by removing the overrides completely.

Change was tested by dd'ing a test image to /dev/fb0 with no video=
(still 32bpp), video=1920x1080-32@60, video=1920x1080-24@60 and
video=1920x1080-16@60 .

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: David Airlie <airlied@linux.ie>
Cc: Rob Clark <robdclark@gmail.com>
---
 drivers/gpu/drm/msm/msm_fbdev.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_fbdev.c b/drivers/gpu/drm/msm/msm_fbdev.c
index ab5bfd2..94d55e5 100644
--- a/drivers/gpu/drm/msm/msm_fbdev.c
+++ b/drivers/gpu/drm/msm/msm_fbdev.c
@@ -93,9 +93,6 @@ static int msm_fbdev_create(struct drm_fb_helper *helper,
 	uint32_t paddr;
 	int ret, size;

-	sizes->surface_bpp = 32;
-	sizes->surface_depth = 24;
-
 	DBG("create fbdev: %dx%d@%d (%dx%d)", sizes->surface_width,
 			sizes->surface_height, sizes->surface_bpp,
 			sizes->fb_width, sizes->fb_height);
--
1.9.3

