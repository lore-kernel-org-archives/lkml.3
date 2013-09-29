Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab3I2Tgs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:36:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab3I2T3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 53/71] drm/radeon/dpm: handle bapm on trinity
Date: Sun, 29 Sep 2013 12:28:05 -0700
Message-Id: <20130929192647.091755521@linuxfoundation.org>
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

commit ef4e03658420bbf91365647615460668c2510e79 upstream.

bapm is a power management feature for handling the
power budget between the CPU and GPU on APUs.  This
patch adds support for enabling or disabling it.
For now disable it by default.  Enabling it properly
requires quite a bit more work and will be addressed
in a separate patch.

This patch fixes hangs on boot on certain trinity
laptops when the system is on battery power.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/ppsmc.h       |    2 ++
 drivers/gpu/drm/radeon/trinity_dpm.c |    2 ++
 drivers/gpu/drm/radeon/trinity_dpm.h |    1 +
 drivers/gpu/drm/radeon/trinity_smc.c |    8 ++++++++
 4 files changed, 13 insertions(+)

--- a/drivers/gpu/drm/radeon/ppsmc.h
+++ b/drivers/gpu/drm/radeon/ppsmc.h
@@ -106,6 +106,8 @@ typedef uint8_t PPSMC_Result;
 #define PPSMC_MSG_DPM_N_LevelsDisabled      ((uint32_t) 0x112)
 #define PPSMC_MSG_DCE_RemoveVoltageAdjustment   ((uint32_t) 0x11d)
 #define PPSMC_MSG_DCE_AllowVoltageAdjustment    ((uint32_t) 0x11e)
+#define PPSMC_MSG_EnableBAPM                ((uint32_t) 0x120)
+#define PPSMC_MSG_DisableBAPM               ((uint32_t) 0x121)
 #define PPSMC_MSG_UVD_DPM_Config            ((uint32_t) 0x124)
 
 
--- a/drivers/gpu/drm/radeon/trinity_dpm.c
+++ b/drivers/gpu/drm/radeon/trinity_dpm.c
@@ -1091,6 +1091,7 @@ int trinity_dpm_enable(struct radeon_dev
 	trinity_program_sclk_dpm(rdev);
 	trinity_start_dpm(rdev);
 	trinity_wait_for_dpm_enabled(rdev);
+	trinity_dpm_bapm_enable(rdev, false);
 	trinity_release_mutex(rdev);
 
 	if (rdev->irq.installed &&
@@ -1116,6 +1117,7 @@ void trinity_dpm_disable(struct radeon_d
 		trinity_release_mutex(rdev);
 		return;
 	}
+	trinity_dpm_bapm_enable(rdev, false);
 	trinity_disable_clock_power_gating(rdev);
 	sumo_clear_vc(rdev);
 	trinity_wait_for_level_0(rdev);
--- a/drivers/gpu/drm/radeon/trinity_dpm.h
+++ b/drivers/gpu/drm/radeon/trinity_dpm.h
@@ -118,6 +118,7 @@ struct trinity_power_info {
 #define TRINITY_AT_DFLT            30
 
 /* trinity_smc.c */
+int trinity_dpm_bapm_enable(struct radeon_device *rdev, bool enable);
 int trinity_dpm_config(struct radeon_device *rdev, bool enable);
 int trinity_uvd_dpm_config(struct radeon_device *rdev);
 int trinity_dpm_force_state(struct radeon_device *rdev, u32 n);
--- a/drivers/gpu/drm/radeon/trinity_smc.c
+++ b/drivers/gpu/drm/radeon/trinity_smc.c
@@ -56,6 +56,14 @@ static int trinity_notify_message_to_smu
 	return 0;
 }
 
+int trinity_dpm_bapm_enable(struct radeon_device *rdev, bool enable)
+{
+	if (enable)
+		return trinity_notify_message_to_smu(rdev, PPSMC_MSG_EnableBAPM);
+	else
+		return trinity_notify_message_to_smu(rdev, PPSMC_MSG_DisableBAPM);
+}
+
 int trinity_dpm_config(struct radeon_device *rdev, bool enable)
 {
 	if (enable)


