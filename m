Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760552Ab3B0AVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:21:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933602Ab3B0AJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:09:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 43/86] drm/radeon/dce6: fix display powergating
Date: Tue, 26 Feb 2013 16:07:51 -0800
Message-Id: <20130226235917.380042568@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 0e3d50bfcbd338254795a700dcff429a96cba1a6 upstream.

Only enable it when we disable the display rather than
at DPMS time since enabling it requires a full modeset
to restore the display state.  Fixes blank screens in
certain cases.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -258,8 +258,6 @@ void atombios_crtc_dpms(struct drm_crtc
 		radeon_crtc->enabled = true;
 		/* adjust pm to dpms changes BEFORE enabling crtcs */
 		radeon_pm_compute_clocks(rdev);
-		if (ASIC_IS_DCE6(rdev) && !radeon_crtc->in_mode_set)
-			atombios_powergate_crtc(crtc, ATOM_DISABLE);
 		atombios_enable_crtc(crtc, ATOM_ENABLE);
 		if (ASIC_IS_DCE3(rdev) && !ASIC_IS_DCE6(rdev))
 			atombios_enable_crtc_memreq(crtc, ATOM_ENABLE);
@@ -277,8 +275,6 @@ void atombios_crtc_dpms(struct drm_crtc
 			atombios_enable_crtc_memreq(crtc, ATOM_DISABLE);
 		atombios_enable_crtc(crtc, ATOM_DISABLE);
 		radeon_crtc->enabled = false;
-		if (ASIC_IS_DCE6(rdev) && !radeon_crtc->in_mode_set)
-			atombios_powergate_crtc(crtc, ATOM_ENABLE);
 		/* adjust pm to dpms changes AFTER disabling crtcs */
 		radeon_pm_compute_clocks(rdev);
 		break;
@@ -1670,6 +1666,8 @@ static void atombios_crtc_disable(struct
 	int i;
 
 	atombios_crtc_dpms(crtc, DRM_MODE_DPMS_OFF);
+	if (ASIC_IS_DCE6(rdev))
+		atombios_powergate_crtc(crtc, ATOM_ENABLE);
 
 	for (i = 0; i < rdev->num_crtc; i++) {
 		if (rdev->mode_info.crtcs[i] &&


