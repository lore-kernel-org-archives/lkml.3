Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967207AbaFQVww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:52:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54910 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967137AbaFQVwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:52:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 155/212] drm/radeon/pm: don't allow debugfs/sysfs access when PX card is off (v2)
Date: Tue, 17 Jun 2014 14:44:09 -0700
Message-Id: <1403041506-13646-156-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 4f2f203976964e267dc477de6648bdb3acd2b74b upstream.

When the PX card is off don't try and access it. Avoid hw access
to the card while it's off (e.g., reading back invalid temperature).

v2: be less strict

bug:
https://bugzilla.kernel.org/show_bug.cgi?id=76321

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_pm.c | 42 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
index 58b0a80..f5dc5dd 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -361,6 +361,11 @@ static ssize_t radeon_set_pm_profile(struct device *dev,
 	struct drm_device *ddev = dev_get_drvdata(dev);
 	struct radeon_device *rdev = ddev->dev_private;
 
+	/* Can't set profile when the card is off */
+	if  ((rdev->flags & RADEON_IS_PX) &&
+	     (ddev->switch_power_state != DRM_SWITCH_POWER_ON))
+		return -EINVAL;
+
 	mutex_lock(&rdev->pm.mutex);
 	if (rdev->pm.pm_method == PM_METHOD_PROFILE) {
 		if (strncmp("default", buf, strlen("default")) == 0)
@@ -409,6 +414,13 @@ static ssize_t radeon_set_pm_method(struct device *dev,
 	struct drm_device *ddev = dev_get_drvdata(dev);
 	struct radeon_device *rdev = ddev->dev_private;
 
+	/* Can't set method when the card is off */
+	if  ((rdev->flags & RADEON_IS_PX) &&
+	     (ddev->switch_power_state != DRM_SWITCH_POWER_ON)) {
+		count = -EINVAL;
+		goto fail;
+	}
+
 	/* we don't support the legacy modes with dpm */
 	if (rdev->pm.pm_method == PM_METHOD_DPM) {
 		count = -EINVAL;
@@ -446,6 +458,10 @@ static ssize_t radeon_get_dpm_state(struct device *dev,
 	struct radeon_device *rdev = ddev->dev_private;
 	enum radeon_pm_state_type pm = rdev->pm.dpm.user_state;
 
+	if  ((rdev->flags & RADEON_IS_PX) &&
+	     (ddev->switch_power_state != DRM_SWITCH_POWER_ON))
+		return snprintf(buf, PAGE_SIZE, "off\n");
+
 	return snprintf(buf, PAGE_SIZE, "%s\n",
 			(pm == POWER_STATE_TYPE_BATTERY) ? "battery" :
 			(pm == POWER_STATE_TYPE_BALANCED) ? "balanced" : "performance");
@@ -459,6 +475,11 @@ static ssize_t radeon_set_dpm_state(struct device *dev,
 	struct drm_device *ddev = dev_get_drvdata(dev);
 	struct radeon_device *rdev = ddev->dev_private;
 
+	/* Can't set dpm state when the card is off */
+	if  ((rdev->flags & RADEON_IS_PX) &&
+	     (ddev->switch_power_state != DRM_SWITCH_POWER_ON))
+		return -EINVAL;
+
 	mutex_lock(&rdev->pm.mutex);
 	if (strncmp("battery", buf, strlen("battery")) == 0)
 		rdev->pm.dpm.user_state = POWER_STATE_TYPE_BATTERY;
@@ -485,6 +506,10 @@ static ssize_t radeon_get_dpm_forced_performance_level(struct device *dev,
 	struct radeon_device *rdev = ddev->dev_private;
 	enum radeon_dpm_forced_level level = rdev->pm.dpm.forced_level;
 
+	if  ((rdev->flags & RADEON_IS_PX) &&
+	     (ddev->switch_power_state != DRM_SWITCH_POWER_ON))
+		return snprintf(buf, PAGE_SIZE, "off\n");
+
 	return snprintf(buf, PAGE_SIZE, "%s\n",
 			(level == RADEON_DPM_FORCED_LEVEL_AUTO) ? "auto" :
 			(level == RADEON_DPM_FORCED_LEVEL_LOW) ? "low" : "high");
@@ -500,6 +525,11 @@ static ssize_t radeon_set_dpm_forced_performance_level(struct device *dev,
 	enum radeon_dpm_forced_level level;
 	int ret = 0;
 
+	/* Can't force performance level when the card is off */
+	if  ((rdev->flags & RADEON_IS_PX) &&
+	     (ddev->switch_power_state != DRM_SWITCH_POWER_ON))
+		return -EINVAL;
+
 	mutex_lock(&rdev->pm.mutex);
 	if (strncmp("low", buf, strlen("low")) == 0) {
 		level = RADEON_DPM_FORCED_LEVEL_LOW;
@@ -538,8 +568,14 @@ static ssize_t radeon_hwmon_show_temp(struct device *dev,
 				      char *buf)
 {
 	struct radeon_device *rdev = dev_get_drvdata(dev);
+	struct drm_device *ddev = rdev->ddev;
 	int temp;
 
+	/* Can't get temperature when the card is off */
+	if  ((rdev->flags & RADEON_IS_PX) &&
+	     (ddev->switch_power_state != DRM_SWITCH_POWER_ON))
+		return -EINVAL;
+
 	if (rdev->asic->pm.get_temperature)
 		temp = radeon_get_temperature(rdev);
 	else
@@ -1571,8 +1607,12 @@ static int radeon_debugfs_pm_info(struct seq_file *m, void *data)
 	struct drm_info_node *node = (struct drm_info_node *) m->private;
 	struct drm_device *dev = node->minor->dev;
 	struct radeon_device *rdev = dev->dev_private;
+	struct drm_device *ddev = rdev->ddev;
 
-	if (rdev->pm.dpm_enabled) {
+	if  ((rdev->flags & RADEON_IS_PX) &&
+	     (ddev->switch_power_state != DRM_SWITCH_POWER_ON)) {
+		seq_printf(m, "PX asic powered off\n");
+	} else if (rdev->pm.dpm_enabled) {
 		mutex_lock(&rdev->pm.mutex);
 		if (rdev->asic->dpm.debugfs_print_current_performance_level)
 			radeon_dpm_debugfs_print_current_performance_level(rdev, m);
-- 
1.9.1

