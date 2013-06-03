Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039Ab3FCWck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:32:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6940 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759262Ab3FCWaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:30:08 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=VYtufcDFwb8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=A_iTFifiloAA:10 a=zd2uoN0lAAAA:8 a=VwQbUJbxAAAA:8 a=eSGMd2RKCo40mgylbpUA:9 a=bma-QhgU-_UA:10 a=wu_e27o_rKQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221203.157566274@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:11:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Niels Ole Salscheider <niels_ole@salscheider-online.de>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [64/65] drm/radeon: Fix VRAM size calculation for VRAM >= 4GB
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0064-drm-radeon-Fix-VRAM-size-calculation-for-VRAM-4GB.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Niels Ole Salscheider <niels_ole@salscheider-online.de>

[ Upstream commit fc986034540102cd090237bf3f70262e1ae80d9c ]

Add ULL prefix to avoid overflow.

Signed-off-by: Niels Ole Salscheider <niels_ole@salscheider-online.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/radeon/evergreen.c  |    4 ++--
 drivers/gpu/drm/radeon/radeon_ttm.c |    2 +-
 drivers/gpu/drm/radeon/si.c         |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 5c23991..5cec317 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2272,8 +2272,8 @@ int evergreen_mc_init(struct radeon_device *rdev)
 		rdev->mc.real_vram_size = RREG32(CONFIG_MEMSIZE);
 	} else {
 		/* size in MB on evergreen/cayman/tn */
-		rdev->mc.mc_vram_size = RREG32(CONFIG_MEMSIZE) * 1024 * 1024;
-		rdev->mc.real_vram_size = RREG32(CONFIG_MEMSIZE) * 1024 * 1024;
+		rdev->mc.mc_vram_size = RREG32(CONFIG_MEMSIZE) * 1024ULL * 1024ULL;
+		rdev->mc.real_vram_size = RREG32(CONFIG_MEMSIZE) * 1024ULL * 1024ULL;
 	}
 	rdev->mc.visible_vram_size = rdev->mc.aper_size;
 	r700_vram_gtt_location(rdev, &rdev->mc);
diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index 5b71c71..7ba7d4b 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -725,7 +725,7 @@ int radeon_ttm_init(struct radeon_device *rdev)
 		return r;
 	}
 	DRM_INFO("radeon: %uM of VRAM memory ready\n",
-		 (unsigned)rdev->mc.real_vram_size / (1024 * 1024));
+		 (unsigned) (rdev->mc.real_vram_size / (1024 * 1024)));
 	r = ttm_bo_init_mm(&rdev->mman.bdev, TTM_PL_TT,
 				rdev->mc.gtt_size >> PAGE_SHIFT);
 	if (r) {
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index f2b256c..7d0026b 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -2343,8 +2343,8 @@ static int si_mc_init(struct radeon_device *rdev)
 	rdev->mc.aper_base = pci_resource_start(rdev->pdev, 0);
 	rdev->mc.aper_size = pci_resource_len(rdev->pdev, 0);
 	/* size in MB on si */
-	rdev->mc.mc_vram_size = RREG32(CONFIG_MEMSIZE) * 1024 * 1024;
-	rdev->mc.real_vram_size = RREG32(CONFIG_MEMSIZE) * 1024 * 1024;
+	rdev->mc.mc_vram_size = RREG32(CONFIG_MEMSIZE) * 1024ULL * 1024ULL;
+	rdev->mc.real_vram_size = RREG32(CONFIG_MEMSIZE) * 1024ULL * 1024ULL;
 	rdev->mc.visible_vram_size = rdev->mc.aper_size;
 	si_vram_gtt_location(rdev, &rdev->mc);
 	radeon_update_bandwidth_info(rdev);
-- 
1.7.10.4


