Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594Ab3B1Otl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:49:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42342 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932533Ab3B1Otc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:49:32 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 090/139] drm/radeon/dce6: fix display powergating
Date: Thu, 28 Feb 2013 14:44:00 +0000
Message-Id: <1362062689-2567-91-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 0e3d50bfcbd338254795a700dcff429a96cba1a6 upstream.

Only enable it when we disable the display rather than
at DPMS time since enabling it requires a full modeset
to restore the display state.  Fixes blank screens in
certain cases.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_crtc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index 80eb8d5..08b71a3 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -258,8 +258,6 @@ void atombios_crtc_dpms(struct drm_crtc *crtc, int mode)
 		radeon_crtc->enabled = true;
 		/* adjust pm to dpms changes BEFORE enabling crtcs */
 		radeon_pm_compute_clocks(rdev);
-		if (ASIC_IS_DCE6(rdev) && !radeon_crtc->in_mode_set)
-			atombios_powergate_crtc(crtc, ATOM_DISABLE);
 		atombios_enable_crtc(crtc, ATOM_ENABLE);
 		if (ASIC_IS_DCE3(rdev) && !ASIC_IS_DCE6(rdev))
 			atombios_enable_crtc_memreq(crtc, ATOM_ENABLE);
@@ -277,8 +275,6 @@ void atombios_crtc_dpms(struct drm_crtc *crtc, int mode)
 			atombios_enable_crtc_memreq(crtc, ATOM_DISABLE);
 		atombios_enable_crtc(crtc, ATOM_DISABLE);
 		radeon_crtc->enabled = false;
-		if (ASIC_IS_DCE6(rdev) && !radeon_crtc->in_mode_set)
-			atombios_powergate_crtc(crtc, ATOM_ENABLE);
 		/* adjust pm to dpms changes AFTER disabling crtcs */
 		radeon_pm_compute_clocks(rdev);
 		break;
@@ -1673,6 +1669,8 @@ static void atombios_crtc_disable(struct drm_crtc *crtc)
 	int i;
 
 	atombios_crtc_dpms(crtc, DRM_MODE_DPMS_OFF);
+	if (ASIC_IS_DCE6(rdev))
+		atombios_powergate_crtc(crtc, ATOM_ENABLE);
 
 	for (i = 0; i < rdev->num_crtc; i++) {
 		if (rdev->mode_info.crtcs[i] &&
-- 
1.8.1.2

