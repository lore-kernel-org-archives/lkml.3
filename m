Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab3I2Thz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:37:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088Ab3I2T3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 54/71] drm/radeon/dpm: fix fallback for empty UVD clocks
Date: Sun, 29 Sep 2013 12:28:06 -0700
Message-Id: <20130929192647.224674210@linuxfoundation.org>
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

commit 84f3d9f7b4781dea6e11dcaf7f81367c1b39fef0 upstream.

Some older 6xx-7xx boards didn't always fill in the
UVD clocks properly in the UVD power states.  This
leads to the driver trying to set a 0 clock which
results in slow or broken UVD playback.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=69120

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/rs780_dpm.c |   10 +++++++---
 drivers/gpu/drm/radeon/rv770_dpm.c |   10 +++++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/radeon/rs780_dpm.c
+++ b/drivers/gpu/drm/radeon/rs780_dpm.c
@@ -717,14 +717,18 @@ static void rs780_parse_pplib_non_clock_
 	if (ATOM_PPLIB_NONCLOCKINFO_VER1 < table_rev) {
 		rps->vclk = le32_to_cpu(non_clock_info->ulVCLK);
 		rps->dclk = le32_to_cpu(non_clock_info->ulDCLK);
-	} else if (r600_is_uvd_state(rps->class, rps->class2)) {
-		rps->vclk = RS780_DEFAULT_VCLK_FREQ;
-		rps->dclk = RS780_DEFAULT_DCLK_FREQ;
 	} else {
 		rps->vclk = 0;
 		rps->dclk = 0;
 	}
 
+	if (r600_is_uvd_state(rps->class, rps->class2)) {
+		if ((rps->vclk == 0) || (rps->dclk == 0)) {
+			rps->vclk = RS780_DEFAULT_VCLK_FREQ;
+			rps->dclk = RS780_DEFAULT_DCLK_FREQ;
+		}
+	}
+
 	if (rps->class & ATOM_PPLIB_CLASSIFICATION_BOOT)
 		rdev->pm.dpm.boot_ps = rps;
 	if (rps->class & ATOM_PPLIB_CLASSIFICATION_UVDSTATE)
--- a/drivers/gpu/drm/radeon/rv770_dpm.c
+++ b/drivers/gpu/drm/radeon/rv770_dpm.c
@@ -2147,14 +2147,18 @@ static void rv7xx_parse_pplib_non_clock_
 	if (ATOM_PPLIB_NONCLOCKINFO_VER1 < table_rev) {
 		rps->vclk = le32_to_cpu(non_clock_info->ulVCLK);
 		rps->dclk = le32_to_cpu(non_clock_info->ulDCLK);
-	} else if (r600_is_uvd_state(rps->class, rps->class2)) {
-		rps->vclk = RV770_DEFAULT_VCLK_FREQ;
-		rps->dclk = RV770_DEFAULT_DCLK_FREQ;
 	} else {
 		rps->vclk = 0;
 		rps->dclk = 0;
 	}
 
+	if (r600_is_uvd_state(rps->class, rps->class2)) {
+		if ((rps->vclk == 0) || (rps->dclk == 0)) {
+			rps->vclk = RV770_DEFAULT_VCLK_FREQ;
+			rps->dclk = RV770_DEFAULT_DCLK_FREQ;
+		}
+	}
+
 	if (rps->class & ATOM_PPLIB_CLASSIFICATION_BOOT)
 		rdev->pm.dpm.boot_ps = rps;
 	if (rps->class & ATOM_PPLIB_CLASSIFICATION_UVDSTATE)


