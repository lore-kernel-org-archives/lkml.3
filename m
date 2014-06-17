Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967233AbaFQWP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:15:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54541 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966756AbaFQVvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:51:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>, Dave Airlie <airlied@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 199/212] drm/radeon/dpm: resume fixes for some systems
Date: Tue, 17 Jun 2014 14:44:53 -0700
Message-Id: <1403041506-13646-200-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 3640da2faa952a2e9439a254c1ce76033ca0a6dc upstream.

Setting the power state prior to restoring the display
hardware leads to blank screens on some systems.  Drop
the power state set from dpm resume.  The power state
will get set as part of the mode set sequence.  Also
add an explicit power state set after mode set resume
to cover PX and headless systems.

bug:
https://bugzilla.kernel.org/show_bug.cgi?id=76761

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
[ kamal: backport to 3.13-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_crtc.c | 6 ++----
 drivers/gpu/drm/radeon/radeon_device.c | 5 +++++
 drivers/gpu/drm/radeon/radeon_pm.c     | 1 -
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index 153aa49..c9ee271 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -270,8 +270,6 @@ void atombios_crtc_dpms(struct drm_crtc *crtc, int mode)
 	switch (mode) {
 	case DRM_MODE_DPMS_ON:
 		radeon_crtc->enabled = true;
-		/* adjust pm to dpms changes BEFORE enabling crtcs */
-		radeon_pm_compute_clocks(rdev);
 		atombios_enable_crtc(crtc, ATOM_ENABLE);
 		if (ASIC_IS_DCE3(rdev) && !ASIC_IS_DCE6(rdev))
 			atombios_enable_crtc_memreq(crtc, ATOM_ENABLE);
@@ -289,10 +287,10 @@ void atombios_crtc_dpms(struct drm_crtc *crtc, int mode)
 			atombios_enable_crtc_memreq(crtc, ATOM_DISABLE);
 		atombios_enable_crtc(crtc, ATOM_DISABLE);
 		radeon_crtc->enabled = false;
-		/* adjust pm to dpms changes AFTER disabling crtcs */
-		radeon_pm_compute_clocks(rdev);
 		break;
 	}
+	/* adjust pm to dpms */
+	radeon_pm_compute_clocks(rdev);
 }
 
 static void
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 63069a9..716293c 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1547,6 +1547,11 @@ int radeon_resume_kms(struct drm_device *dev, bool resume, bool fbcon)
 	}
 
 	drm_kms_helper_poll_enable(dev);
+
+	/* set the power state here in case we are a PX system or headless */
+	if ((rdev->pm.pm_method == PM_METHOD_DPM) && rdev->pm.dpm_enabled)
+		radeon_pm_compute_clocks(rdev);
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
index f5dc5dd..446e67f 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -1093,7 +1093,6 @@ static void radeon_pm_resume_dpm(struct radeon_device *rdev)
 		}
 	} else {
 		rdev->pm.dpm_enabled = true;
-		radeon_pm_compute_clocks(rdev);
 	}
 }
 
-- 
1.9.1

