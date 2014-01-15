Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbaAOWij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:38:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40755 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbaAOVyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:54:07 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 023/166] drm/radeon: fixup bad vram size on SI
Date: Wed, 15 Jan 2014 13:50:37 -0800
Message-Id: <1389822780-4729-24-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 0ca223b029a261e82fb2f50c52eb85d510f4260e upstream.

Some boards seem to have garbage in the upper
16 bits of the vram size register.  Check for
this and clamp the size properly.  Fixes
boards reporting bogus amounts of vram.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/si.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 966b5e6..ff9a680 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -2426,8 +2426,15 @@ static int si_mc_init(struct radeon_device *rdev)
 	rdev->mc.aper_base = pci_resource_start(rdev->pdev, 0);
 	rdev->mc.aper_size = pci_resource_len(rdev->pdev, 0);
 	/* size in MB on si */
-	rdev->mc.mc_vram_size = RREG32(CONFIG_MEMSIZE) * 1024ULL * 1024ULL;
-	rdev->mc.real_vram_size = RREG32(CONFIG_MEMSIZE) * 1024ULL * 1024ULL;
+	tmp = RREG32(CONFIG_MEMSIZE);
+	/* some boards may have garbage in the upper 16 bits */
+	if (tmp & 0xffff0000) {
+		DRM_INFO("Probable bad vram size: 0x%08x\n", tmp);
+		if (tmp & 0xffff)
+			tmp &= 0xffff;
+	}
+	rdev->mc.mc_vram_size = tmp * 1024ULL * 1024ULL;
+	rdev->mc.real_vram_size = rdev->mc.mc_vram_size;
 	rdev->mc.visible_vram_size = rdev->mc.aper_size;
 	si_vram_gtt_location(rdev, &rdev->mc);
 	radeon_update_bandwidth_info(rdev);
-- 
1.8.3.2

