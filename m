Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243AbaLBTXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:23:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46632 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933214AbaLBTWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:22:55 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 062/121] drm/radeon: make sure mode init is complete in bandwidth_update
Date: Tue,  2 Dec 2014 11:19:01 -0800
Message-Id: <1417548000-1794-63-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 8efe82ca908400785253c8f0dfcf301e6bd93488 upstream.

The power management code calls into the display code for
certain things.  If certain power management sysfs attributes
are called before the driver has finished initializing all of
the hardware we can run into problems with uninitialized
modesetting state.  Add a check to make sure modesetting
init has completed to the bandwidth update callbacks to
fix this.  Can be triggered by the tlp and laptop start
up scripts depending on the timing.

bugs:
https://bugzilla.kernel.org/show_bug.cgi?id=83611
https://bugs.freedesktop.org/show_bug.cgi?id=85771

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/cik.c       | 3 +++
 drivers/gpu/drm/radeon/evergreen.c | 3 +++
 drivers/gpu/drm/radeon/r100.c      | 3 +++
 drivers/gpu/drm/radeon/rs600.c     | 3 +++
 drivers/gpu/drm/radeon/rs690.c     | 3 +++
 drivers/gpu/drm/radeon/rv515.c     | 3 +++
 drivers/gpu/drm/radeon/si.c        | 3 +++
 7 files changed, 21 insertions(+)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 927d523..642eed1 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -8690,6 +8690,9 @@ void dce8_bandwidth_update(struct radeon_device *rdev)
 	u32 num_heads = 0, lb_size;
 	int i;
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	for (i = 0; i < rdev->num_crtc; i++) {
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 838dcd5..e337e43 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2361,6 +2361,9 @@ void evergreen_bandwidth_update(struct radeon_device *rdev)
 	u32 num_heads = 0, lb_size;
 	int i;
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	for (i = 0; i < rdev->num_crtc; i++) {
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 10abc4d..a90ce9c 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -3190,6 +3190,9 @@ void r100_bandwidth_update(struct radeon_device *rdev)
 	uint32_t pixel_bytes1 = 0;
 	uint32_t pixel_bytes2 = 0;
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	if (rdev->mode_info.crtcs[0]->base.enabled) {
diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index 76cc8d3..83f6da3 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -888,6 +888,9 @@ void rs600_bandwidth_update(struct radeon_device *rdev)
 	u32 d1mode_priority_a_cnt, d2mode_priority_a_cnt;
 	/* FIXME: implement full support */
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	if (rdev->mode_info.crtcs[0]->base.enabled)
diff --git a/drivers/gpu/drm/radeon/rs690.c b/drivers/gpu/drm/radeon/rs690.c
index e7dab06..008d2d0 100644
--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -579,6 +579,9 @@ void rs690_bandwidth_update(struct radeon_device *rdev)
 	u32 d1mode_priority_a_cnt, d1mode_priority_b_cnt;
 	u32 d2mode_priority_a_cnt, d2mode_priority_b_cnt;
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	if (rdev->mode_info.crtcs[0]->base.enabled)
diff --git a/drivers/gpu/drm/radeon/rv515.c b/drivers/gpu/drm/radeon/rv515.c
index 5d1c316..7295405 100644
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -1271,6 +1271,9 @@ void rv515_bandwidth_update(struct radeon_device *rdev)
 	struct drm_display_mode *mode0 = NULL;
 	struct drm_display_mode *mode1 = NULL;
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	if (rdev->mode_info.crtcs[0]->base.enabled)
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 18c197f..ae10c7c 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -2225,6 +2225,9 @@ void dce6_bandwidth_update(struct radeon_device *rdev)
 	u32 num_heads = 0, lb_size;
 	int i;
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	for (i = 0; i < rdev->num_crtc; i++) {
-- 
1.9.1

