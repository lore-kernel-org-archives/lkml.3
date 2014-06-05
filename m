Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbaFEEWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:22:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbaFEEWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:22:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 187/214] drm/radeon: always program the MC on startup
Date: Wed,  4 Jun 2014 21:19:10 -0700
Message-Id: <20140605041704.580993742@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 6fab3febf6d949b0a12b1e4e73db38e4a177a79e upstream.

For r6xx+ asics.  This mirrors the behavior of pre-r6xx
asics.  We need to program the MC even if something
else in startup() fails.  Failure to do so results in
an unusable GPU.

Based on a fix from: Mark Kettenis <kettenis@openbsd.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[wml: Backported to 3.4:
- adjust context
- drop changes to cik.c]
Signed-off-by: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/evergreen.c |    3 ++-
 drivers/gpu/drm/radeon/ni.c        |    3 ++-
 drivers/gpu/drm/radeon/r600.c      |    3 ++-
 drivers/gpu/drm/radeon/rv770.c     |    3 ++-
 drivers/gpu/drm/radeon/si.c        |    3 ++-
 5 files changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -3219,6 +3219,8 @@ static int evergreen_startup(struct rade
 	/* enable pcie gen2 link */
 	evergreen_pcie_gen2_enable(rdev);
 
+	evergreen_mc_program(rdev);
+
 	if (ASIC_IS_DCE5(rdev)) {
 		if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw || !rdev->mc_fw) {
 			r = ni_init_microcode(rdev);
@@ -3246,7 +3248,6 @@ static int evergreen_startup(struct rade
 	if (r)
 		return r;
 
-	evergreen_mc_program(rdev);
 	if (rdev->flags & RADEON_IS_AGP) {
 		evergreen_agp_enable(rdev);
 	} else {
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -1552,6 +1552,8 @@ static int cayman_startup(struct radeon_
 	/* enable pcie gen2 link */
 	evergreen_pcie_gen2_enable(rdev);
 
+	evergreen_mc_program(rdev);
+
 	if (rdev->flags & RADEON_IS_IGP) {
 		if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw) {
 			r = ni_init_microcode(rdev);
@@ -1580,7 +1582,6 @@ static int cayman_startup(struct radeon_
 	if (r)
 		return r;
 
-	evergreen_mc_program(rdev);
 	r = cayman_pcie_gart_enable(rdev);
 	if (r)
 		return r;
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2431,6 +2431,8 @@ int r600_startup(struct radeon_device *r
 	/* enable pcie gen2 link */
 	r600_pcie_gen2_enable(rdev);
 
+	r600_mc_program(rdev);
+
 	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw) {
 		r = r600_init_microcode(rdev);
 		if (r) {
@@ -2443,7 +2445,6 @@ int r600_startup(struct radeon_device *r
 	if (r)
 		return r;
 
-	r600_mc_program(rdev);
 	if (rdev->flags & RADEON_IS_AGP) {
 		r600_agp_enable(rdev);
 	} else {
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -1058,6 +1058,8 @@ static int rv770_startup(struct radeon_d
 	/* enable pcie gen2 link */
 	rv770_pcie_gen2_enable(rdev);
 
+	rv770_mc_program(rdev);
+
 	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw) {
 		r = r600_init_microcode(rdev);
 		if (r) {
@@ -1070,7 +1072,6 @@ static int rv770_startup(struct radeon_d
 	if (r)
 		return r;
 
-	rv770_mc_program(rdev);
 	if (rdev->flags & RADEON_IS_AGP) {
 		rv770_agp_enable(rdev);
 	} else {
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -3834,6 +3834,8 @@ static int si_startup(struct radeon_devi
 	struct radeon_ring *ring;
 	int r;
 
+	si_mc_program(rdev);
+
 	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->ce_fw ||
 	    !rdev->rlc_fw || !rdev->mc_fw) {
 		r = si_init_microcode(rdev);
@@ -3853,7 +3855,6 @@ static int si_startup(struct radeon_devi
 	if (r)
 		return r;
 
-	si_mc_program(rdev);
 	r = si_pcie_gart_enable(rdev);
 	if (r)
 		return r;


