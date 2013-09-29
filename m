Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab3I2TaM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:30:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59894 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045Ab3I2TaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:30:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        FrankR Huang <FrankR.Huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 39/71] drm/radeon: fix init ordering for r600+
Date: Sun, 29 Sep 2013 12:27:51 -0700
Message-Id: <20130929192646.164725446@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/cik.c       |    9 +++++----
 drivers/gpu/drm/radeon/evergreen.c |    9 +++++----
 drivers/gpu/drm/radeon/ni.c        |    9 +++++----
 drivers/gpu/drm/radeon/r600.c      |    9 +++++----
 drivers/gpu/drm/radeon/rv770.c     |    9 +++++----
 drivers/gpu/drm/radeon/si.c        |    9 +++++----
 6 files changed, 30 insertions(+), 24 deletions(-)

--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -6007,6 +6007,11 @@ static int cik_startup(struct radeon_dev
 	struct radeon_ring *ring;
 	int r;
 
+	/* scratch needs to be initialized before MC */
+	r = r600_vram_scratch_init(rdev);
+	if (r)
+		return r;
+
 	cik_mc_program(rdev);
 
 	if (rdev->flags & RADEON_IS_IGP) {
@@ -6036,10 +6041,6 @@ static int cik_startup(struct radeon_dev
 		}
 	}
 
-	r = r600_vram_scratch_init(rdev);
-	if (r)
-		return r;
-
 	r = cik_pcie_gart_enable(rdev);
 	if (r)
 		return r;
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -5106,6 +5106,11 @@ static int evergreen_startup(struct rade
 	/* enable aspm */
 	evergreen_program_aspm(rdev);
 
+	/* scratch needs to be initialized before MC */
+	r = r600_vram_scratch_init(rdev);
+	if (r)
+		return r;
+
 	evergreen_mc_program(rdev);
 
 	if (ASIC_IS_DCE5(rdev)) {
@@ -5131,10 +5136,6 @@ static int evergreen_startup(struct rade
 		}
 	}
 
-	r = r600_vram_scratch_init(rdev);
-	if (r)
-		return r;
-
 	if (rdev->flags & RADEON_IS_AGP) {
 		evergreen_agp_enable(rdev);
 	} else {
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -2083,6 +2083,11 @@ static int cayman_startup(struct radeon_
 	/* enable aspm */
 	evergreen_program_aspm(rdev);
 
+	/* scratch needs to be initialized before MC */
+	r = r600_vram_scratch_init(rdev);
+	if (r)
+		return r;
+
 	evergreen_mc_program(rdev);
 
 	if (rdev->flags & RADEON_IS_IGP) {
@@ -2109,10 +2114,6 @@ static int cayman_startup(struct radeon_
 		}
 	}
 
-	r = r600_vram_scratch_init(rdev);
-	if (r)
-		return r;
-
 	r = cayman_pcie_gart_enable(rdev);
 	if (r)
 		return r;
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -3334,6 +3334,11 @@ static int r600_startup(struct radeon_de
 	/* enable pcie gen2 link */
 	r600_pcie_gen2_enable(rdev);
 
+	/* scratch needs to be initialized before MC */
+	r = r600_vram_scratch_init(rdev);
+	if (r)
+		return r;
+
 	r600_mc_program(rdev);
 
 	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw) {
@@ -3344,10 +3349,6 @@ static int r600_startup(struct radeon_de
 		}
 	}
 
-	r = r600_vram_scratch_init(rdev);
-	if (r)
-		return r;
-
 	if (rdev->flags & RADEON_IS_AGP) {
 		r600_agp_enable(rdev);
 	} else {
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -1829,6 +1829,11 @@ static int rv770_startup(struct radeon_d
 	/* enable pcie gen2 link */
 	rv770_pcie_gen2_enable(rdev);
 
+	/* scratch needs to be initialized before MC */
+	r = r600_vram_scratch_init(rdev);
+	if (r)
+		return r;
+
 	rv770_mc_program(rdev);
 
 	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw) {
@@ -1839,10 +1844,6 @@ static int rv770_startup(struct radeon_d
 		}
 	}
 
-	r = r600_vram_scratch_init(rdev);
-	if (r)
-		return r;
-
 	if (rdev->flags & RADEON_IS_AGP) {
 		rv770_agp_enable(rdev);
 	} else {
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -6422,6 +6422,11 @@ static int si_startup(struct radeon_devi
 	/* enable aspm */
 	si_program_aspm(rdev);
 
+	/* scratch needs to be initialized before MC */
+	r = r600_vram_scratch_init(rdev);
+	if (r)
+		return r;
+
 	si_mc_program(rdev);
 
 	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->ce_fw ||
@@ -6439,10 +6444,6 @@ static int si_startup(struct radeon_devi
 		return r;
 	}
 
-	r = r600_vram_scratch_init(rdev);
-	if (r)
-		return r;
-
 	r = si_pcie_gart_enable(rdev);
 	if (r)
 		return r;


