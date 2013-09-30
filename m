Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab3I3KWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:22:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43697 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab3I3KNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:07 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 072/104] drm/radeon: fix init ordering for r600+
Date: Mon, 30 Sep 2013 11:10:49 +0100
Message-Id: <1380535881-9239-73-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit e5903d399a7b0e5c14673c1206f4aeec2859c730 upstream.

The vram scratch buffer needs to be initialized
before the mc is programmed otherwise we program
0 as the GPU address of the default GPU fault
page.  In most cases we put vram at zero anyway and
reserve a page for the legacy vga buffer so in practice
this shouldn't cause any problems, but better to make
it correct.

Was changed in:
6fab3febf6d949b0a12b1e4e73db38e4a177a79e

Reported-by: FrankR Huang <FrankR.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ luis: backported to 3.5:
  - adjusted context
  -dropped changes to drivers/gpu/drm/radeon/cik.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen.c | 9 +++++----
 drivers/gpu/drm/radeon/ni.c        | 9 +++++----
 drivers/gpu/drm/radeon/r600.c      | 9 +++++----
 drivers/gpu/drm/radeon/rv770.c     | 9 +++++----
 drivers/gpu/drm/radeon/si.c        | 9 +++++----
 5 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 269fa76..650e2d7 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -3081,6 +3081,11 @@ static int evergreen_startup(struct radeon_device *rdev)
 	/* enable pcie gen2 link */
 	evergreen_pcie_gen2_enable(rdev);
 
+	/* scratch needs to be initialized before MC */
+	r = r600_vram_scratch_init(rdev);
+	if (r)
+		return r;
+
 	evergreen_mc_program(rdev);
 
 	if (ASIC_IS_DCE5(rdev)) {
@@ -3106,10 +3111,6 @@ static int evergreen_startup(struct radeon_device *rdev)
 		}
 	}
 
-	r = r600_vram_scratch_init(rdev);
-	if (r)
-		return r;
-
 	if (rdev->flags & RADEON_IS_AGP) {
 		evergreen_agp_enable(rdev);
 	} else {
diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index ba9ae56..fcd7335 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -1239,6 +1239,11 @@ static int cayman_startup(struct radeon_device *rdev)
 	/* enable pcie gen2 link */
 	evergreen_pcie_gen2_enable(rdev);
 
+	/* scratch needs to be initialized before MC */
+	r = r600_vram_scratch_init(rdev);
+	if (r)
+		return r;
+
 	evergreen_mc_program(rdev);
 
 	if (rdev->flags & RADEON_IS_IGP) {
@@ -1265,10 +1270,6 @@ static int cayman_startup(struct radeon_device *rdev)
 		}
 	}
 
-	r = r600_vram_scratch_init(rdev);
-	if (r)
-		return r;
-
 	r = cayman_pcie_gart_enable(rdev);
 	if (r)
 		return r;
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 0e431c0..3458d4a 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2361,6 +2361,11 @@ int r600_startup(struct radeon_device *rdev)
 	/* enable pcie gen2 link */
 	r600_pcie_gen2_enable(rdev);
 
+	/* scratch needs to be initialized before MC */
+	r = r600_vram_scratch_init(rdev);
+	if (r)
+		return r;
+
 	r600_mc_program(rdev);
 
 	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw) {
@@ -2371,10 +2376,6 @@ int r600_startup(struct radeon_device *rdev)
 		}
 	}
 
-	r = r600_vram_scratch_init(rdev);
-	if (r)
-		return r;
-
 	if (rdev->flags & RADEON_IS_AGP) {
 		r600_agp_enable(rdev);
 	} else {
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index d6fa2b5..186d019 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -890,6 +890,11 @@ static int rv770_startup(struct radeon_device *rdev)
 	/* enable pcie gen2 link */
 	rv770_pcie_gen2_enable(rdev);
 
+	/* scratch needs to be initialized before MC */
+	r = r600_vram_scratch_init(rdev);
+	if (r)
+		return r;
+
 	rv770_mc_program(rdev);
 
 	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw) {
@@ -900,10 +905,6 @@ static int rv770_startup(struct radeon_device *rdev)
 		}
 	}
 
-	r = r600_vram_scratch_init(rdev);
-	if (r)
-		return r;
-
 	if (rdev->flags & RADEON_IS_AGP) {
 		rv770_agp_enable(rdev);
 	} else {
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index d3454a0..9987345 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -3698,6 +3698,11 @@ static int si_startup(struct radeon_device *rdev)
 	struct radeon_ring *ring;
 	int r;
 
+	/* scratch needs to be initialized before MC */
+	r = r600_vram_scratch_init(rdev);
+	if (r)
+		return r;
+
 	si_mc_program(rdev);
 
 	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->ce_fw ||
@@ -3715,10 +3720,6 @@ static int si_startup(struct radeon_device *rdev)
 		return r;
 	}
 
-	r = r600_vram_scratch_init(rdev);
-	if (r)
-		return r;
-
 	r = si_pcie_gart_enable(rdev);
 	if (r)
 		return r;
-- 
1.8.3.2

