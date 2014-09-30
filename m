Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaI3VcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:32:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60781 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaI3VcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:32:00 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 012/103] drm/radeon: add bapm module parameter
Date: Tue, 30 Sep 2014 14:30:17 -0700
Message-Id: <1412112708-27356-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.13-stable ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/kv_dpm.c      |  5 ++++-
 drivers/gpu/drm/radeon/radeon.h      |  1 +
 drivers/gpu/drm/radeon/radeon_drv.c  |  4 ++++
 drivers/gpu/drm/radeon/trinity_dpm.c | 17 ++++++++++++++++-
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/kv_dpm.c b/drivers/gpu/drm/radeon/kv_dpm.c
index b419055..1b0331c 100644
--- a/drivers/gpu/drm/radeon/kv_dpm.c
+++ b/drivers/gpu/drm/radeon/kv_dpm.c
@@ -2635,7 +2635,10 @@ int kv_dpm_init(struct radeon_device *rdev)
 	pi->caps_sclk_ds = true;
 	pi->enable_auto_thermal_throttling = true;
 	pi->disable_nb_ps3_in_battery = false;
-	pi->bapm_enable = false;
+	if (radeon_bapm == 0)
+		pi->bapm_enable = false;
+	else
+		pi->bapm_enable = true;
 	pi->voltage_drop_t = 0;
 	pi->caps_sclk_throttle_low_notification = false;
 	pi->caps_fps = false; /* true? */
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 6cc9331..fd2526c 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -99,6 +99,7 @@ extern int radeon_fastfb;
 extern int radeon_dpm;
 extern int radeon_aspm;
 extern int radeon_runtime_pm;
+extern int radeon_bapm;
 
 /*
  * Copy from radeon_drv.h so we don't have to include both and have conflicting
diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index 43872c6..c60fe4f 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -167,6 +167,7 @@ int radeon_fastfb = 0;
 int radeon_dpm = -1;
 int radeon_aspm = -1;
 int radeon_runtime_pm = -1;
+int radeon_bapm = -1;
 
 MODULE_PARM_DESC(no_wb, "Disable AGP writeback for scratch registers");
 module_param_named(no_wb, radeon_no_wb, int, 0444);
@@ -231,6 +232,9 @@ module_param_named(aspm, radeon_aspm, int, 0444);
 MODULE_PARM_DESC(runpm, "PX runtime pm (1 = force enable, 0 = disable, -1 = PX only default)");
 module_param_named(runpm, radeon_runtime_pm, int, 0444);
 
+MODULE_PARM_DESC(bapm, "BAPM support (1 = enable, 0 = disable, -1 = auto)");
+module_param_named(bapm, radeon_bapm, int, 0444);
+
 static struct pci_device_id pciidlist[] = {
 	radeon_PCI_IDS
 };
diff --git a/drivers/gpu/drm/radeon/trinity_dpm.c b/drivers/gpu/drm/radeon/trinity_dpm.c
index d700698..c9d82cb 100644
--- a/drivers/gpu/drm/radeon/trinity_dpm.c
+++ b/drivers/gpu/drm/radeon/trinity_dpm.c
@@ -1868,7 +1868,22 @@ int trinity_dpm_init(struct radeon_device *rdev)
 	for (i = 0; i < SUMO_MAX_HARDWARE_POWERLEVELS; i++)
 		pi->at[i] = TRINITY_AT_DFLT;
 
-	pi->enable_bapm = false;
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
+		pi->enable_bapm = false;
+	} else {
+		pi->enable_bapm = true;
+	}
 	pi->enable_nbps_policy = true;
 	pi->enable_sclk_ds = true;
 	pi->enable_gfx_power_gating = true;
-- 
1.9.1

