Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934713AbaFIXHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:07:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933676AbaFIWph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.14 40/78] drm/radeon/dpm: resume fixes for some systems
Date: Mon,  9 Jun 2014 15:48:20 -0700
Message-Id: <20140609224814.645598481@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |    6 ++----
 drivers/gpu/drm/radeon/radeon_device.c |    4 ++++
 drivers/gpu/drm/radeon/radeon_pm.c     |    1 -
 3 files changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -270,8 +270,6 @@ void atombios_crtc_dpms(struct drm_crtc
 	switch (mode) {
 	case DRM_MODE_DPMS_ON:
 		radeon_crtc->enabled = true;
-		/* adjust pm to dpms changes BEFORE enabling crtcs */
-		radeon_pm_compute_clocks(rdev);
 		atombios_enable_crtc(crtc, ATOM_ENABLE);
 		if (ASIC_IS_DCE3(rdev) && !ASIC_IS_DCE6(rdev))
 			atombios_enable_crtc_memreq(crtc, ATOM_ENABLE);
@@ -289,10 +287,10 @@ void atombios_crtc_dpms(struct drm_crtc
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
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1536,6 +1536,10 @@ int radeon_resume_kms(struct drm_device
 
 	radeon_restore_bios_scratch_regs(rdev);
 
+	/* set the power state here in case we are a PX system or headless */
+	if ((rdev->pm.pm_method == PM_METHOD_DPM) && rdev->pm.dpm_enabled)
+		radeon_pm_compute_clocks(rdev);
+
 	if (fbcon) {
 		radeon_fbdev_set_suspend(rdev, 0);
 		console_unlock();
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -1082,7 +1082,6 @@ static void radeon_pm_resume_dpm(struct
 	if (ret)
 		goto dpm_resume_fail;
 	rdev->pm.dpm_enabled = true;
-	radeon_pm_compute_clocks(rdev);
 	return;
 
 dpm_resume_fail:


