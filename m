Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab3HNKmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:42:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34707 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638Ab3HNKi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:38:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 67/75] drm/radeon: always program the MC on startup
Date: Wed, 14 Aug 2013 11:36:56 +0100
Message-Id: <1376476624-10011-68-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 6fab3febf6d949b0a12b1e4e73db38e4a177a79e upstream.

For r6xx+ asics.  This mirrors the behavior of pre-r6xx
asics.  We need to program the MC even if something
else in startup() fails.  Failure to do so results in
an unusable GPU.

Based on a fix from: Mark Kettenis <kettenis@openbsd.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ luis: backported to 3.5:
  - adjusted context
  - dropped changes to drivers/gpu/drm/radeon/cik.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen.c | 3 ++-
 drivers/gpu/drm/radeon/ni.c        | 3 ++-
 drivers/gpu/drm/radeon/r600.c      | 3 ++-
 drivers/gpu/drm/radeon/rv770.c     | 3 ++-
 drivers/gpu/drm/radeon/si.c        | 3 ++-
 5 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 7dbb1aa..7ac565f 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -3064,6 +3064,8 @@ static int evergreen_startup(struct radeon_device *rdev)
 	/* enable pcie gen2 link */
 	evergreen_pcie_gen2_enable(rdev);
 
+	evergreen_mc_program(rdev);
+
 	if (ASIC_IS_DCE5(rdev)) {
 		if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw || !rdev->mc_fw) {
 			r = ni_init_microcode(rdev);
@@ -3091,7 +3093,6 @@ static int evergreen_startup(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	evergreen_mc_program(rdev);
 	if (rdev->flags & RADEON_IS_AGP) {
 		evergreen_agp_enable(rdev);
 	} else {
diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index 8d2a168..ba9ae56 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -1239,6 +1239,8 @@ static int cayman_startup(struct radeon_device *rdev)
 	/* enable pcie gen2 link */
 	evergreen_pcie_gen2_enable(rdev);
 
+	evergreen_mc_program(rdev);
+
 	if (rdev->flags & RADEON_IS_IGP) {
 		if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw) {
 			r = ni_init_microcode(rdev);
@@ -1267,7 +1269,6 @@ static int cayman_startup(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	evergreen_mc_program(rdev);
 	r = cayman_pcie_gart_enable(rdev);
 	if (r)
 		return r;
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index ffaf3ba..0e431c0 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2361,6 +2361,8 @@ int r600_startup(struct radeon_device *rdev)
 	/* enable pcie gen2 link */
 	r600_pcie_gen2_enable(rdev);
 
+	r600_mc_program(rdev);
+
 	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw) {
 		r = r600_init_microcode(rdev);
 		if (r) {
@@ -2373,7 +2375,6 @@ int r600_startup(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	r600_mc_program(rdev);
 	if (rdev->flags & RADEON_IS_AGP) {
 		r600_agp_enable(rdev);
 	} else {
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index 3b8e95a..d6fa2b5 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -890,6 +890,8 @@ static int rv770_startup(struct radeon_device *rdev)
 	/* enable pcie gen2 link */
 	rv770_pcie_gen2_enable(rdev);
 
+	rv770_mc_program(rdev);
+
 	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw) {
 		r = r600_init_microcode(rdev);
 		if (r) {
@@ -902,7 +904,6 @@ static int rv770_startup(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	rv770_mc_program(rdev);
 	if (rdev->flags & RADEON_IS_AGP) {
 		rv770_agp_enable(rdev);
 	} else {
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 97b89b7..625c4ba 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -3683,6 +3683,8 @@ static int si_startup(struct radeon_device *rdev)
 	struct radeon_ring *ring;
 	int r;
 
+	si_mc_program(rdev);
+
 	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->ce_fw ||
 	    !rdev->rlc_fw || !rdev->mc_fw) {
 		r = si_init_microcode(rdev);
@@ -3702,7 +3704,6 @@ static int si_startup(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	si_mc_program(rdev);
 	r = si_pcie_gart_enable(rdev);
 	if (r)
 		return r;
-- 
1.8.3.2

