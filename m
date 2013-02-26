Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233Ab3BZX5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:57:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760204Ab3BZX5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 065/150] drm/radeon: fix multi-head power profile stability on BTC+ asics
Date: Tue, 26 Feb 2013 15:55:22 -0800
Message-Id: <20130226235530.975237116@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 7ae764b11ed63279e9dcf25be972ff4ca21a9875 upstream.

vddci needs to track mclk for multi-head.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen.c |   13 +++++++++++++
 drivers/gpu/drm/radeon/radeon_pm.c |    2 +-
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -403,6 +403,19 @@ void evergreen_pm_misc(struct radeon_dev
 			rdev->pm.current_vddc = voltage->voltage;
 			DRM_DEBUG("Setting: vddc: %d\n", voltage->voltage);
 		}
+
+		/* starting with BTC, there is one state that is used for both
+		 * MH and SH.  Difference is that we always use the high clock index for
+		 * mclk and vddci.
+		 */
+		if ((rdev->pm.pm_method == PM_METHOD_PROFILE) &&
+		    (rdev->family >= CHIP_BARTS) &&
+		    rdev->pm.active_crtc_count &&
+		    ((rdev->pm.profile_index == PM_PROFILE_MID_MH_IDX) ||
+		     (rdev->pm.profile_index == PM_PROFILE_LOW_MH_IDX)))
+			voltage = &rdev->pm.power_state[req_ps_idx].
+				clock_info[rdev->pm.profiles[PM_PROFILE_HIGH_MH_IDX].dpms_on_cm_idx].voltage;
+
 		/* 0xff01 is a flag rather then an actual voltage */
 		if (voltage->vddci == 0xff01)
 			return;
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -169,7 +169,7 @@ static void radeon_set_power_state(struc
 
 		/* starting with BTC, there is one state that is used for both
 		 * MH and SH.  Difference is that we always use the high clock index for
-		 * mclk.
+		 * mclk and vddci.
 		 */
 		if ((rdev->pm.pm_method == PM_METHOD_PROFILE) &&
 		    (rdev->family >= CHIP_BARTS) &&


