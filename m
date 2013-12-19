Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab3LSL7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:59:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45169 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab3LSL66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:58:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 153/208] drm/radeon: fixup bad vram size on SI
Date: Thu, 19 Dec 2013 11:54:11 +0000
Message-Id: <1387454106-19326-154-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 0ca223b029a261e82fb2f50c52eb85d510f4260e upstream.

Some boards seem to have garbage in the upper
16 bits of the vram size register.  Check for
this and clamp the size properly.  Fixes
boards reporting bogus amounts of vram.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/si.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index bf1fcb6..a69180c 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -3903,8 +3903,15 @@ static int si_mc_init(struct radeon_device *rdev)
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

