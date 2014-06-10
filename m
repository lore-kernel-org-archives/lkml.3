Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828AbaFJUBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:01:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35573 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbaFJTxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:53:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 035/160] drm/radeon: fix runpm handling on APUs (v4)
Date: Tue, 10 Jun 2014 12:44:35 -0700
Message-Id: <1402429600-20477-36-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 90c4cde9d5a2bb6239cb3e253bb3832ed89dc75c upstream.

Don't try and runtime suspend the APU in PX systems.  We
only want to power down the dGPU.

v2: fix harder
v3: fix stupid typo
v4: consolidate runpm enablement to a single flag

bugs:
https://bugs.freedesktop.org/show_bug.cgi?id=75127
https://bugzilla.kernel.org/show_bug.cgi?id=72701

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ kamal: backport to 3.13-stable: no pm_runtime_forbid() ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon.h              |  1 +
 drivers/gpu/drm/radeon/radeon_atpx_handler.c |  2 +-
 drivers/gpu/drm/radeon/radeon_device.c       | 19 ++++++++++---------
 drivers/gpu/drm/radeon/radeon_drv.c          | 12 ++++--------
 drivers/gpu/drm/radeon/radeon_family.h       |  1 +
 drivers/gpu/drm/radeon/radeon_kms.c          | 14 ++++++++++----
 6 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 4485236..319bd81 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -2231,6 +2231,7 @@ struct radeon_device {
 	bool have_disp_power_ref;
 };
 
+bool radeon_is_px(struct drm_device *dev);
 int radeon_device_init(struct radeon_device *rdev,
 		       struct drm_device *ddev,
 		       struct pci_dev *pdev,
diff --git a/drivers/gpu/drm/radeon/radeon_atpx_handler.c b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
index fa9a9c0..dedea72 100644
--- a/drivers/gpu/drm/radeon/radeon_atpx_handler.c
+++ b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
@@ -59,7 +59,7 @@ struct atpx_mux {
 	u16 mux;
 } __packed;
 
-bool radeon_is_px(void) {
+bool radeon_has_atpx(void) {
 	return radeon_atpx_priv.atpx_detected;
 }
 
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 39b033b..63069a9 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -102,11 +102,14 @@ static const char radeon_family_name[][16] = {
 	"LAST",
 };
 
-#if defined(CONFIG_VGA_SWITCHEROO)
-bool radeon_is_px(void);
-#else
-static inline bool radeon_is_px(void) { return false; }
-#endif
+bool radeon_is_px(struct drm_device *dev)
+{
+	struct radeon_device *rdev = dev->dev_private;
+
+	if (rdev->flags & RADEON_IS_PX)
+		return true;
+	return false;
+}
 
 /**
  * radeon_program_register_sequence - program an array of registers.
@@ -1077,7 +1080,7 @@ static void radeon_switcheroo_set_state(struct pci_dev *pdev, enum vga_switchero
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
 
-	if (radeon_is_px() && state == VGA_SWITCHEROO_OFF)
+	if (radeon_is_px(dev) && state == VGA_SWITCHEROO_OFF)
 		return;
 
 	if (state == VGA_SWITCHEROO_ON) {
@@ -1298,9 +1301,7 @@ int radeon_device_init(struct radeon_device *rdev,
 	 * ignore it */
 	vga_client_register(rdev->pdev, rdev, NULL, radeon_vga_set_decode);
 
-	if (radeon_runtime_pm == 1)
-		runtime = true;
-	if ((radeon_runtime_pm == -1) && radeon_is_px())
+	if (rdev->flags & RADEON_IS_PX)
 		runtime = true;
 	vga_switcheroo_register_client(rdev->pdev, &radeon_switcheroo_ops, runtime);
 	if (runtime)
diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index 5fa8196..43872c6 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -111,6 +111,7 @@ void radeon_gem_object_close(struct drm_gem_object *obj,
 extern int radeon_get_crtc_scanoutpos(struct drm_device *dev, int crtc,
 				      int *vpos, int *hpos, ktime_t *stime,
 				      ktime_t *etime);
+extern bool radeon_is_px(struct drm_device *dev);
 extern const struct drm_ioctl_desc radeon_ioctls_kms[];
 extern int radeon_max_kms_ioctl;
 int radeon_mmap(struct file *filp, struct vm_area_struct *vma);
@@ -140,11 +141,9 @@ void radeon_debugfs_cleanup(struct drm_minor *minor);
 #if defined(CONFIG_VGA_SWITCHEROO)
 void radeon_register_atpx_handler(void);
 void radeon_unregister_atpx_handler(void);
-bool radeon_is_px(void);
 #else
 static inline void radeon_register_atpx_handler(void) {}
 static inline void radeon_unregister_atpx_handler(void) {}
-static inline bool radeon_is_px(void) { return false; }
 #endif
 
 int radeon_no_wb;
@@ -400,7 +399,7 @@ static int radeon_pmops_runtime_suspend(struct device *dev)
 	if (radeon_runtime_pm == 0)
 		return -EINVAL;
 
-	if (radeon_runtime_pm == -1 && !radeon_is_px())
+	if (radeon_runtime_pm == -1 && !radeon_is_px(drm_dev))
 		return -EINVAL;
 
 	drm_dev->switch_power_state = DRM_SWITCH_POWER_CHANGING;
@@ -422,10 +421,7 @@ static int radeon_pmops_runtime_resume(struct device *dev)
 	struct drm_device *drm_dev = pci_get_drvdata(pdev);
 	int ret;
 
-	if (radeon_runtime_pm == 0)
-		return -EINVAL;
-
-	if (radeon_runtime_pm == -1 && !radeon_is_px())
+	if (!radeon_is_px(drm_dev))
 		return -EINVAL;
 
 	drm_dev->switch_power_state = DRM_SWITCH_POWER_CHANGING;
@@ -454,7 +450,7 @@ static int radeon_pmops_runtime_idle(struct device *dev)
 		return -EBUSY;
 
 	/* are we PX enabled? */
-	if (radeon_runtime_pm == -1 && !radeon_is_px()) {
+	if (radeon_runtime_pm == -1 && !radeon_is_px(drm_dev)) {
 		DRM_DEBUG_DRIVER("failing to power off - not px\n");
 		return -EBUSY;
 	}
diff --git a/drivers/gpu/drm/radeon/radeon_family.h b/drivers/gpu/drm/radeon/radeon_family.h
index 614ad54..9da5da4 100644
--- a/drivers/gpu/drm/radeon/radeon_family.h
+++ b/drivers/gpu/drm/radeon/radeon_family.h
@@ -115,6 +115,7 @@ enum radeon_chip_flags {
 	RADEON_NEW_MEMMAP = 0x00400000UL,
 	RADEON_IS_PCI = 0x00800000UL,
 	RADEON_IS_IGPGART = 0x01000000UL,
+	RADEON_IS_PX = 0x02000000UL,
 };
 
 #endif
diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index 4818b44..10a416e 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -35,9 +35,9 @@
 #include <linux/pm_runtime.h>
 
 #if defined(CONFIG_VGA_SWITCHEROO)
-bool radeon_is_px(void);
+bool radeon_has_atpx(void);
 #else
-static inline bool radeon_is_px(void) { return false; }
+static inline bool radeon_has_atpx(void) { return false; }
 #endif
 
 /**
@@ -107,6 +107,13 @@ int radeon_driver_load_kms(struct drm_device *dev, unsigned long flags)
 		flags |= RADEON_IS_PCI;
 	}
 
+	if (radeon_runtime_pm == 1)
+		flags |= RADEON_IS_PX;
+	else if ((radeon_runtime_pm == -1) &&
+		 radeon_has_atpx() &&
+		 ((flags & RADEON_IS_IGP) == 0))
+		flags |= RADEON_IS_PX;
+
 	/* radeon_device_init should report only fatal error
 	 * like memory allocation failure or iomapping failure,
 	 * or memory manager initialization failure, it must
@@ -137,8 +144,7 @@ int radeon_driver_load_kms(struct drm_device *dev, unsigned long flags)
 				"Error during ACPI methods call\n");
 	}
 
-	if ((radeon_runtime_pm == 1) ||
-	    ((radeon_runtime_pm == -1) && radeon_is_px())) {
+	if (radeon_is_px(dev)) {
 		pm_runtime_use_autosuspend(dev->dev);
 		pm_runtime_set_autosuspend_delay(dev->dev, 5000);
 		pm_runtime_set_active(dev->dev);
-- 
1.9.1

