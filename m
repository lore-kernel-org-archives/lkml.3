Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759646Ab3IHDVJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:21:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56109 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756288Ab3IHDSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:55 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Deucher" <alexander.deucher@amd.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.880162062@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [060/121] drm/radeon: always program the MC on startup
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 6fab3febf6d949b0a12b1e4e73db38e4a177a79e upstream.

For r6xx+ asics.  This mirrors the behavior of pre-r6xx
asics.  We need to program the MC even if something
else in startup() fails.  Failure to do so results in
an unusable GPU.

Based on a fix from: Mark Kettenis <kettenis@openbsd.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[bwh: Backported to 3.2: adjust context, drop changes to cik.c and si.c]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -3036,6 +3036,8 @@ static int evergreen_startup(struct rade
 	/* enable pcie gen2 link */
 	evergreen_pcie_gen2_enable(rdev);
 
+	evergreen_mc_program(rdev);
+
 	if (ASIC_IS_DCE5(rdev)) {
 		if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw || !rdev->mc_fw) {
 			r = ni_init_microcode(rdev);
@@ -3063,7 +3065,6 @@ static int evergreen_startup(struct rade
 	if (r)
 		return r;
 
-	evergreen_mc_program(rdev);
 	if (rdev->flags & RADEON_IS_AGP) {
 		evergreen_agp_enable(rdev);
 	} else {
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -1353,6 +1353,8 @@ static int cayman_startup(struct radeon_
 	/* enable pcie gen2 link */
 	evergreen_pcie_gen2_enable(rdev);
 
+	evergreen_mc_program(rdev);
+
 	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw || !rdev->mc_fw) {
 		r = ni_init_microcode(rdev);
 		if (r) {
@@ -1370,7 +1372,6 @@ static int cayman_startup(struct radeon_
 	if (r)
 		return r;
 
-	evergreen_mc_program(rdev);
 	r = cayman_pcie_gart_enable(rdev);
 	if (r)
 		return r;
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2415,6 +2415,8 @@ int r600_startup(struct radeon_device *r
 	/* enable pcie gen2 link */
 	r600_pcie_gen2_enable(rdev);
 
+	r600_mc_program(rdev);
+
 	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw) {
 		r = r600_init_microcode(rdev);
 		if (r) {
@@ -2427,7 +2429,6 @@ int r600_startup(struct radeon_device *r
 	if (r)
 		return r;
 
-	r600_mc_program(rdev);
 	if (rdev->flags & RADEON_IS_AGP) {
 		r600_agp_enable(rdev);
 	} else {
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -1057,6 +1057,8 @@ static int rv770_startup(struct radeon_d
 	/* enable pcie gen2 link */
 	rv770_pcie_gen2_enable(rdev);
 
+	rv770_mc_program(rdev);
+
 	if (!rdev->me_fw || !rdev->pfp_fw || !rdev->rlc_fw) {
 		r = r600_init_microcode(rdev);
 		if (r) {
@@ -1069,7 +1071,6 @@ static int rv770_startup(struct radeon_d
 	if (r)
 		return r;
 
-	rv770_mc_program(rdev);
 	if (rdev->flags & RADEON_IS_AGP) {
 		rv770_agp_enable(rdev);
 	} else {

