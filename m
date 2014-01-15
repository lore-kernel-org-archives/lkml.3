Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbaAOWUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:20:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41137 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbaAOV6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:58:39 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 068/166] drm/radeon: Fix sideport problems on certain RS690 boards
Date: Wed, 15 Jan 2014 13:51:22 -0800
Message-Id: <1389822780-4729-69-git-send-email-kamal@canonical.com>
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

commit 8333f0fe133be420ce3fcddfd568c3a559ab274e upstream.

Some RS690 boards with 64MB of sideport memory show up as
having 128MB sideport + 256MB of UMA.  In this case,
just skip the sideport memory and use UMA.  This fixes
rendering corruption and should improve performance.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=35457

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/rs690.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/radeon/rs690.c b/drivers/gpu/drm/radeon/rs690.c
index fad6633..213381f 100644
--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -160,6 +160,17 @@ static void rs690_mc_init(struct radeon_device *rdev)
 	base = RREG32_MC(R_000100_MCCFG_FB_LOCATION);
 	base = G_000100_MC_FB_START(base) << 16;
 	rdev->mc.igp_sideport_enabled = radeon_atombios_sideport_present(rdev);
+	/* Some boards seem to be configured for 128MB of sideport memory,
+	 * but really only have 64MB.  Just skip the sideport and use
+	 * UMA memory.
+	 */
+	if (rdev->mc.igp_sideport_enabled &&
+	    (rdev->mc.real_vram_size == (384 * 1024 * 1024))) {
+		base += 128 * 1024 * 1024;
+		rdev->mc.real_vram_size -= 128 * 1024 * 1024;
+		rdev->mc.mc_vram_size = rdev->mc.real_vram_size;
+	}
+
 	rs690_pm_info(rdev);
 	radeon_vram_location(rdev, &rdev->mc, base);
 	rdev->mc.gtt_base_align = rdev->mc.gtt_size - 1;
-- 
1.8.3.2

