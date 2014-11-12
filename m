Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933849AbaKLBgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:36:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587AbaKLBgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:36:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.17 287/319] drm/radeon: dpm fixes for asrock systems
Date: Wed, 12 Nov 2014 10:17:05 +0900
Message-Id: <20141112011040.360140888@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 72b3f9183ed57e4a2f0601a1c25ae2fd39855952 upstream.

- bapm seems to cause CPU stuck messages so disable it.
- nb dpm seems to prevent GPU dpm from getting enabled, so
disable it.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=85107

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/kv_dpm.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/kv_dpm.c
+++ b/drivers/gpu/drm/radeon/kv_dpm.c
@@ -2725,7 +2725,11 @@ int kv_dpm_init(struct radeon_device *rd
 
         pi->sram_end = SMC_RAM_END;
 
-	pi->enable_nb_dpm = true;
+	/* Enabling nb dpm on an asrock system prevents dpm from working */
+	if (rdev->pdev->subsystem_vendor == 0x1849)
+		pi->enable_nb_dpm = false;
+	else
+		pi->enable_nb_dpm = true;
 
 	pi->caps_power_containment = true;
 	pi->caps_cac = true;
@@ -2740,10 +2744,19 @@ int kv_dpm_init(struct radeon_device *rd
 	pi->caps_sclk_ds = true;
 	pi->enable_auto_thermal_throttling = true;
 	pi->disable_nb_ps3_in_battery = false;
-	if (radeon_bapm == 0)
+	if (radeon_bapm == -1) {
+		/* There are stability issues reported on with
+		 * bapm enabled on an asrock system.
+		 */
+		if (rdev->pdev->subsystem_vendor == 0x1849)
+			pi->bapm_enable = false;
+		else
+			pi->bapm_enable = true;
+	} else if (radeon_bapm == 0) {
 		pi->bapm_enable = false;
-	else
+	} else {
 		pi->bapm_enable = true;
+	}
 	pi->voltage_drop_t = 0;
 	pi->caps_sclk_throttle_low_notification = false;
 	pi->caps_fps = false; /* true? */


