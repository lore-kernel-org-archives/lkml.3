Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaKKLUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:20:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57817 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbaKKLLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 143/170] drm/radeon: add bapm module parameter
Date: Tue, 11 Nov 2014 11:08:22 +0000
Message-Id: <1415704129-12709-144-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 6e909f74db2aa9c5b5606b81efcbe18f2749b008 upstream.

Add a module paramter to enable bapm on APUs.  It's disabled
by default on certain APUs due to stability issues.  This
option makes it easier to test and to enable it on systems that
are stable.

bug:
https://bugzilla.kernel.org/show_bug.cgi?id=81021

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/kv_dpm.c      |  5 ++++-
 drivers/gpu/drm/radeon/radeon.h      |  1 +
 drivers/gpu/drm/radeon/radeon_drv.c  |  4 ++++
 drivers/gpu/drm/radeon/trinity_dpm.c | 24 +++++++++++++++---------
 4 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/radeon/kv_dpm.c b/drivers/gpu/drm/radeon/kv_dpm.c
index f00e6a6c254a..67cb472d188c 100644
--- a/drivers/gpu/drm/radeon/kv_dpm.c
+++ b/drivers/gpu/drm/radeon/kv_dpm.c
@@ -2740,7 +2740,10 @@ int kv_dpm_init(struct radeon_device *rdev)
 	pi->caps_sclk_ds = true;
 	pi->enable_auto_thermal_throttling = true;
 	pi->disable_nb_ps3_in_battery = false;
-	pi->bapm_enable = true;
+	if (radeon_bapm == 0)
+		pi->bapm_enable = false;
+	else
+		pi->bapm_enable = true;
 	pi->voltage_drop_t = 0;
 	pi->caps_sclk_throttle_low_notification = false;
 	pi->caps_fps = false; /* true? */
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 2a085d65b659..a7861a4ba340 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -103,6 +103,7 @@ extern int radeon_hard_reset;
 extern int radeon_vm_size;
 extern int radeon_vm_block_size;
 extern int radeon_deep_color;
+extern int radeon_bapm;
 
 /*
  * Copy from radeon_drv.h so we don't have to include both and have conflicting
diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index a089abb76363..1c5c88c2209b 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -176,6 +176,7 @@ int radeon_hard_reset = 0;
 int radeon_vm_size = 4;
 int radeon_vm_block_size = 9;
 int radeon_deep_color = 0;
+int radeon_bapm = -1;
 
 MODULE_PARM_DESC(no_wb, "Disable AGP writeback for scratch registers");
 module_param_named(no_wb, radeon_no_wb, int, 0444);
@@ -252,6 +253,9 @@ module_param_named(vm_block_size, radeon_vm_block_size, int, 0444);
 MODULE_PARM_DESC(deep_color, "Deep Color support (1 = enable, 0 = disable (default))");
 module_param_named(deep_color, radeon_deep_color, int, 0444);
 
+MODULE_PARM_DESC(bapm, "BAPM support (1 = enable, 0 = disable, -1 = auto)");
+module_param_named(bapm, radeon_bapm, int, 0444);
+
 static struct pci_device_id pciidlist[] = {
 	radeon_PCI_IDS
 };
diff --git a/drivers/gpu/drm/radeon/trinity_dpm.c b/drivers/gpu/drm/radeon/trinity_dpm.c
index 32e50be9c4ac..57f780053b3e 100644
--- a/drivers/gpu/drm/radeon/trinity_dpm.c
+++ b/drivers/gpu/drm/radeon/trinity_dpm.c
@@ -1874,16 +1874,22 @@ int trinity_dpm_init(struct radeon_device *rdev)
 	for (i = 0; i < SUMO_MAX_HARDWARE_POWERLEVELS; i++)
 		pi->at[i] = TRINITY_AT_DFLT;
 
-	/* There are stability issues reported on with
-	 * bapm enabled when switching between AC and battery
-	 * power.  At the same time, some MSI boards hang
-	 * if it's not enabled and dpm is enabled.  Just enable
-	 * it for MSI boards right now.
-	 */
-	if (rdev->pdev->subsystem_vendor == 0x1462)
-		pi->enable_bapm = true;
-	else
+	if (radeon_bapm == -1) {
+		/* There are stability issues reported on with
+		 * bapm enabled when switching between AC and battery
+		 * power.  At the same time, some MSI boards hang
+		 * if it's not enabled and dpm is enabled.  Just enable
+		 * it for MSI boards right now.
+		 */
+		if (rdev->pdev->subsystem_vendor == 0x1462)
+			pi->enable_bapm = true;
+		else
+			pi->enable_bapm = false;
+	} else if (radeon_bapm == 0) {
 		pi->enable_bapm = false;
+	} else {
+		pi->enable_bapm = true;
+	}
 	pi->enable_nbps_policy = true;
 	pi->enable_sclk_ds = true;
 	pi->enable_gfx_power_gating = true;
-- 
2.1.0

