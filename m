Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbaCYRxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:53:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55679 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbaCYRSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:18:18 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 78/81] drm/radeon: disable pll sharing for DP on DCE4.1
Date: Tue, 25 Mar 2014 10:16:31 -0700
Message-Id: <1395767794-5012-79-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 9ef4e1d000a5b335fcebfcf8aef3405e59574c89 upstream.

Causes display problems.  We had already disabled
sharing for non-DP displays.

Based on a patch from:
Niels Ole Salscheider <niels_ole@salscheider-online.de>

bug:
https://bugzilla.kernel.org/show_bug.cgi?id=58121

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_crtc.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index b997e79..b9ff6e2 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -1659,6 +1659,20 @@ static int radeon_atom_pick_pll(struct drm_crtc *crtc)
 			return ATOM_PPLL1;
 		DRM_ERROR("unable to allocate a PPLL\n");
 		return ATOM_PPLL_INVALID;
+	} else if (ASIC_IS_DCE41(rdev)) {
+		/* Don't share PLLs on DCE4.1 chips */
+		if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(radeon_crtc->encoder))) {
+			if (rdev->clock.dp_extclk)
+				/* skip PPLL programming if using ext clock */
+				return ATOM_PPLL_INVALID;
+		}
+		pll_in_use = radeon_get_pll_use_mask(crtc);
+		if (!(pll_in_use & (1 << ATOM_PPLL1)))
+			return ATOM_PPLL1;
+		if (!(pll_in_use & (1 << ATOM_PPLL2)))
+			return ATOM_PPLL2;
+		DRM_ERROR("unable to allocate a PPLL\n");
+		return ATOM_PPLL_INVALID;
 	} else if (ASIC_IS_DCE4(rdev)) {
 		/* in DP mode, the DP ref clock can come from PPLL, DCPLL, or ext clock,
 		 * depending on the asic:
@@ -1686,7 +1700,7 @@ static int radeon_atom_pick_pll(struct drm_crtc *crtc)
 				if (pll != ATOM_PPLL_INVALID)
 					return pll;
 			}
-		} else if (!ASIC_IS_DCE41(rdev)) { /* Don't share PLLs on DCE4.1 chips */
+		} else {
 			/* use the same PPLL for all monitors with the same clock */
 			pll = radeon_get_shared_nondp_ppll(crtc);
 			if (pll != ATOM_PPLL_INVALID)
-- 
1.8.3.2

