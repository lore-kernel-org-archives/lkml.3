Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbaCDUGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:06:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411AbaCDUFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:05:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.10 97/97] drm/radeon: disable pll sharing for DP on DCE4.1
Date: Tue,  4 Mar 2014 12:04:50 -0800
Message-Id: <20140304200349.186365367@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -1661,6 +1661,20 @@ static int radeon_atom_pick_pll(struct d
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
@@ -1688,7 +1702,7 @@ static int radeon_atom_pick_pll(struct d
 				if (pll != ATOM_PPLL_INVALID)
 					return pll;
 			}
-		} else if (!ASIC_IS_DCE41(rdev)) { /* Don't share PLLs on DCE4.1 chips */
+		} else {
 			/* use the same PPLL for all monitors with the same clock */
 			pll = radeon_get_shared_nondp_ppll(crtc);
 			if (pll != ATOM_PPLL_INVALID)


