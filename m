Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbaFJTrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:47:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34955 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbaFJTrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:47:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 076/160] drm/radeon: properly unregister hwmon interface (v2)
Date: Tue, 10 Jun 2014 12:45:16 -0700
Message-Id: <1402429600-20477-77-git-send-email-kamal@canonical.com>
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

commit cb3e4e7c59e4b43ac378631f6101f5c8de3a27a5 upstream.

Need to properly unregister the hwmon device on driver
unload.

v2: minor clean up

bug:
https://bugzilla.kernel.org/show_bug.cgi?id=73931

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_pm.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
index d7e631b..5ca7072 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -603,7 +603,6 @@ static const struct attribute_group *hwmon_groups[] = {
 static int radeon_hwmon_init(struct radeon_device *rdev)
 {
 	int err = 0;
-	struct device *hwmon_dev;
 
 	switch (rdev->pm.int_thermal_type) {
 	case THERMAL_TYPE_RV6XX:
@@ -616,11 +615,11 @@ static int radeon_hwmon_init(struct radeon_device *rdev)
 	case THERMAL_TYPE_KV:
 		if (rdev->asic->pm.get_temperature == NULL)
 			return err;
-		hwmon_dev = hwmon_device_register_with_groups(rdev->dev,
-							      "radeon", rdev,
-							      hwmon_groups);
-		if (IS_ERR(hwmon_dev)) {
-			err = PTR_ERR(hwmon_dev);
+		rdev->pm.int_hwmon_dev = hwmon_device_register_with_groups(rdev->dev,
+									   "radeon", rdev,
+									   hwmon_groups);
+		if (IS_ERR(rdev->pm.int_hwmon_dev)) {
+			err = PTR_ERR(rdev->pm.int_hwmon_dev);
 			dev_err(rdev->dev,
 				"Unable to register hwmon device: %d\n", err);
 		}
@@ -632,6 +631,12 @@ static int radeon_hwmon_init(struct radeon_device *rdev)
 	return err;
 }
 
+static void radeon_hwmon_fini(struct radeon_device *rdev)
+{
+	if (rdev->pm.int_hwmon_dev)
+		hwmon_device_unregister(rdev->pm.int_hwmon_dev);
+}
+
 static void radeon_dpm_thermal_work_handler(struct work_struct *work)
 {
 	struct radeon_device *rdev =
@@ -1314,6 +1319,8 @@ static void radeon_pm_fini_old(struct radeon_device *rdev)
 		device_remove_file(rdev->dev, &dev_attr_power_method);
 	}
 
+	radeon_hwmon_fini(rdev);
+
 	if (rdev->pm.power_state)
 		kfree(rdev->pm.power_state);
 }
@@ -1333,6 +1340,8 @@ static void radeon_pm_fini_dpm(struct radeon_device *rdev)
 	}
 	radeon_dpm_fini(rdev);
 
+	radeon_hwmon_fini(rdev);
+
 	if (rdev->pm.power_state)
 		kfree(rdev->pm.power_state);
 }
-- 
1.9.1

