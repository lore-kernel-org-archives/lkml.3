Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaJIJRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 05:17:01 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:3518 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaJIJQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 05:16:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 09 Oct 2014 02:16:40 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] drm: tegra: Check return value of drm_vblank_get()
Date: Thu, 9 Oct 2014 18:16:49 +0900
Message-ID: <1412846209-28630-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.1.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drm_vblank_get() can return an error, which we should propagate.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/tegra/dc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 6553fd238685..b08df07cad47 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -699,6 +699,7 @@ static int tegra_dc_page_flip(struct drm_crtc *crtc, struct drm_framebuffer *fb,
 {
 	struct tegra_dc *dc = to_tegra_dc(crtc);
 	struct drm_device *drm = crtc->dev;
+	int ret;
 
 	if (dc->event)
 		return -EBUSY;
@@ -706,7 +707,9 @@ static int tegra_dc_page_flip(struct drm_crtc *crtc, struct drm_framebuffer *fb,
 	if (event) {
 		event->pipe = dc->pipe;
 		dc->event = event;
-		drm_vblank_get(drm, dc->pipe);
+		ret = drm_vblank_get(drm, dc->pipe);
+		if (ret < 0)
+			return ret;
 	}
 
 	tegra_dc_set_base(dc, 0, 0, fb);
-- 
2.1.2

