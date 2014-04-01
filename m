Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaDAL4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:56:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42404 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaDALR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:17:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Alex Deucher <alexdeucher@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 066/144] drm/radeon: re-order firmware loading in preparation for dpm rework
Date: Tue,  1 Apr 2014 12:14:30 +0100
Message-Id: <1396350948-29910-67-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 01ac8794a77192236a4b91c33adf4177ac5a21f0 upstream.

We need to reorder the driver init sequence to better accomodate
dpm which needs to be loaded earlier in the init sequence.  Move
fw init up so that it's available for dpm init.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/cik.c       | 42 ++++++++++++++++++++------------------
 drivers/gpu/drm/radeon/evergreen.c | 33 ++++++++++++++++--------------
 drivers/gpu/drm/radeon/ni.c        | 36 +++++++++++++++++---------------
 drivers/gpu/drm/radeon/r600.c      | 16 +++++++--------
 drivers/gpu/drm/radeon/rv770.c     | 16 +++++++--------
 drivers/gpu/drm/radeon/si.c        | 18 ++++++++--------
 6 files changed, 84 insertions(+), 77 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 6796c9d..8748a86 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -6014,26 +6014,7 @@ static int cik_startup(struct radeon_device *rdev)
 
 	cik_mc_program(rdev);
 
-	if (rdev->flags & RADEON_IS_IGP) {
-		if (!rdev->me_fw || !rdev->pfp_fw || !rdev->ce_fw ||
-		    !rdev->mec_fw || !rdev->sdma_fw || !rdev->rlc_fw) {
-			r = cik_init_microcode(rdev);
-			if (r) {
-				DRM_ERROR("Failed to load firmware!\n");
-				return r;
-			}
-		}
-	} else {
-		if (!rdev->me_fw || !rdev->pfp_fw || !rdev->ce_fw ||
-		    !rdev->mec_fw || !rdev->sdma_fw || !rdev->rlc_fw ||
-		    !rdev->mc_fw) {
-			r = cik_init_microcode(rdev);
-			if (r) {
-				DRM_ERROR("Failed to load firmware!\n");
-				return r;
-			}
-		}
-
+	if (!(rdev->flags & RADEON_IS_IGP)) {
 		r = ci_mc_load_microcode(rdev);
 		if (r) {
 			DRM_ERROR("Failed to load MC firmware!\n");
@@ -6324,6 +6305,27 @@ int cik_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
+	if (rdev->flags & RADEON_IS_IGP) {
+		if (!rdev->me_fw || !rdev->pfp_fw || !rdev->ce_fw ||
+		    !rdev->mec_fw || !rdev->sdma_fw || !rdev->rlc_fw) {
+			r = cik_init_microcode(rdev);
+			if (r) {
+				DRM_ERROR("Failed to load firmware!\n");
+				return r;
+			}
+		}
+	} else {
+		if (!rdev->me_fw || !rdev->pfp_fw || !rdev->ce_fw ||
+		    !rdev->mec_fw || !rdev->sdma_fw || !rdev->rlc_fw ||
+		    !rdev->mc_fw) {
+			r = cik_init_microcode(rdev);
+			if (r) {
+				DRM_ERROR("Failed to load firmware!\n");
+				return r;
+			}
+		}
+	}
+
 	ring = &rdev->ring[RADEON_RING_TYPE_GFX_INDEX];
 	ring->ring_obj = NULL;
 	r600_ring_init(rdev, ring, 1024 * 1024);
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 18ae744..dfd2c51 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -5131,26 +5131,11 @@ static int evergreen_startup(struct radeon_device *rdev)
 	evergreen_mc_program(rdev);
 
 	if (ASIC_IS_DCE5(rdev)) {
-		if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw || !rdev->mc_fw) {
-			r = ni_init_microcode(rdev);
-			if (r) {
-				DRM_ERROR("Failed to load firmware!\n");
-				return r;
-			}
-		}
 		r = ni_mc_load_microcode(rdev);
 		if (r) {
 			DRM_ERROR("Failed to load MC firmware!\n");
 			return r;
 		}
-	} else {
-		if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw) {
-			r = r600_init_microcode(rdev);
-			if (r) {
-				DRM_ERROR("Failed to load firmware!\n");
-				return r;
-			}
-		}
 	}
 
 	if (rdev->flags & RADEON_IS_AGP) {
@@ -5385,6 +5370,24 @@ int evergreen_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
+	if (ASIC_IS_DCE5(rdev)) {
+		if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw || !rdev->mc_fw) {
+			r = ni_init_microcode(rdev);
+			if (r) {
+				DRM_ERROR("Failed to load firmware!\n");
+				return r;
+			}
+		}
+	} else {
+		if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw) {
+			r = r600_init_microcode(rdev);
+			if (r) {
+				DRM_ERROR("Failed to load firmware!\n");
+				return r;
+			}
+		}
+	}
+
 	rdev->ring[RADEON_RING_TYPE_GFX_INDEX].ring_obj = NULL;
 	r600_ring_init(rdev, &rdev->ring[RADEON_RING_TYPE_GFX_INDEX], 1024 * 1024);
 
diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index 9a3849d..6dc5752 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -2101,23 +2101,7 @@ static int cayman_startup(struct radeon_device *rdev)
 
 	evergreen_mc_program(rdev);
 
-	if (rdev->flags & RADEON_IS_IGP) {
-		if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw) {
-			r = ni_init_microcode(rdev);
-			if (r) {
-				DRM_ERROR("Failed to load firmware!\n");
-				return r;
-			}
-		}
-	} else {
-		if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw || !rdev->mc_fw) {
-			r = ni_init_microcode(rdev);
-			if (r) {
-				DRM_ERROR("Failed to load firmware!\n");
-				return r;
-			}
-		}
-
+	if (!(rdev->flags & RADEON_IS_IGP)) {
 		r = ni_mc_load_microcode(rdev);
 		if (r) {
 			DRM_ERROR("Failed to load MC firmware!\n");
@@ -2366,6 +2350,24 @@ int cayman_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
+	if (rdev->flags & RADEON_IS_IGP) {
+		if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw) {
+			r = ni_init_microcode(rdev);
+			if (r) {
+				DRM_ERROR("Failed to load firmware!\n");
+				return r;
+			}
+		}
+	} else {
+		if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw || !rdev->mc_fw) {
+			r = ni_init_microcode(rdev);
+			if (r) {
+				DRM_ERROR("Failed to load firmware!\n");
+				return r;
+			}
+		}
+	}
+
 	ring->ring_obj = NULL;
 	r600_ring_init(rdev, ring, 1024 * 1024);
 
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 093afb9..8862411 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -3348,14 +3348,6 @@ static int r600_startup(struct radeon_device *rdev)
 
 	r600_mc_program(rdev);
 
-	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw) {
-		r = r600_init_microcode(rdev);
-		if (r) {
-			DRM_ERROR("Failed to load firmware!\n");
-			return r;
-		}
-	}
-
 	if (rdev->flags & RADEON_IS_AGP) {
 		r600_agp_enable(rdev);
 	} else {
@@ -3549,6 +3541,14 @@ int r600_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
+	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw) {
+		r = r600_init_microcode(rdev);
+		if (r) {
+			DRM_ERROR("Failed to load firmware!\n");
+			return r;
+		}
+	}
+
 	rdev->ring[RADEON_RING_TYPE_GFX_INDEX].ring_obj = NULL;
 	r600_ring_init(rdev, &rdev->ring[RADEON_RING_TYPE_GFX_INDEX], 1024 * 1024);
 
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index 73529c9..33a7531 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -1836,14 +1836,6 @@ static int rv770_startup(struct radeon_device *rdev)
 
 	rv770_mc_program(rdev);
 
-	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw) {
-		r = r600_init_microcode(rdev);
-		if (r) {
-			DRM_ERROR("Failed to load firmware!\n");
-			return r;
-		}
-	}
-
 	if (rdev->flags & RADEON_IS_AGP) {
 		rv770_agp_enable(rdev);
 	} else {
@@ -2054,6 +2046,14 @@ int rv770_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
+	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw) {
+		r = r600_init_microcode(rdev);
+		if (r) {
+			DRM_ERROR("Failed to load firmware!\n");
+			return r;
+		}
+	}
+
 	rdev->ring[RADEON_RING_TYPE_GFX_INDEX].ring_obj = NULL;
 	r600_ring_init(rdev, &rdev->ring[RADEON_RING_TYPE_GFX_INDEX], 1024 * 1024);
 
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 966bacc..65d761f 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -6472,15 +6472,6 @@ static int si_startup(struct radeon_device *rdev)
 
 	si_mc_program(rdev);
 
-	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->ce_fw ||
-	    !rdev->rlc_fw || !rdev->mc_fw) {
-		r = si_init_microcode(rdev);
-		if (r) {
-			DRM_ERROR("Failed to load firmware!\n");
-			return r;
-		}
-	}
-
 	r = si_mc_load_microcode(rdev);
 	if (r) {
 		DRM_ERROR("Failed to load MC firmware!\n");
@@ -6736,6 +6727,15 @@ int si_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
+	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->ce_fw ||
+	    !rdev->rlc_fw || !rdev->mc_fw) {
+		r = si_init_microcode(rdev);
+		if (r) {
+			DRM_ERROR("Failed to load firmware!\n");
+			return r;
+		}
+	}
+
 	ring = &rdev->ring[RADEON_RING_TYPE_GFX_INDEX];
 	ring->ring_obj = NULL;
 	r600_ring_init(rdev, ring, 1024 * 1024);
-- 
1.9.1

