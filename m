Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaI3VeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:34:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60798 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaI3VcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:32:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 014/103] drm/radeon: Add ability to get and change dpm state when radeon PX card is turned off
Date: Tue, 30 Sep 2014 14:30:19 -0700
Message-Id: <1412112708-27356-15-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>

commit b07a657e3a05b81c8a30d60e3f3746ca5a48ee62 upstream.

This fixing commit 4f2f203976964e267dc477de6648bdb3acd2b74b

bug:
https://bugzilla.kernel.org/show_bug.cgi?id=76321

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_pm.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
index b19ac0d..807144a 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -458,10 +458,6 @@ static ssize_t radeon_get_dpm_state(struct device *dev,
 	struct radeon_device *rdev = ddev->dev_private;
 	enum radeon_pm_state_type pm = rdev->pm.dpm.user_state;
 
-	if  ((rdev->flags & RADEON_IS_PX) &&
-	     (ddev->switch_power_state != DRM_SWITCH_POWER_ON))
-		return snprintf(buf, PAGE_SIZE, "off\n");
-
 	return snprintf(buf, PAGE_SIZE, "%s\n",
 			(pm == POWER_STATE_TYPE_BATTERY) ? "battery" :
 			(pm == POWER_STATE_TYPE_BALANCED) ? "balanced" : "performance");
@@ -475,11 +471,6 @@ static ssize_t radeon_set_dpm_state(struct device *dev,
 	struct drm_device *ddev = dev_get_drvdata(dev);
 	struct radeon_device *rdev = ddev->dev_private;
 
-	/* Can't set dpm state when the card is off */
-	if  ((rdev->flags & RADEON_IS_PX) &&
-	     (ddev->switch_power_state != DRM_SWITCH_POWER_ON))
-		return -EINVAL;
-
 	mutex_lock(&rdev->pm.mutex);
 	if (strncmp("battery", buf, strlen("battery")) == 0)
 		rdev->pm.dpm.user_state = POWER_STATE_TYPE_BATTERY;
@@ -493,7 +484,12 @@ static ssize_t radeon_set_dpm_state(struct device *dev,
 		goto fail;
 	}
 	mutex_unlock(&rdev->pm.mutex);
-	radeon_pm_compute_clocks(rdev);
+
+	/* Can't set dpm state when the card is off */
+	if (!(rdev->flags & RADEON_IS_PX) ||
+	    (ddev->switch_power_state == DRM_SWITCH_POWER_ON))
+		radeon_pm_compute_clocks(rdev);
+
 fail:
 	return count;
 }
-- 
1.9.1

