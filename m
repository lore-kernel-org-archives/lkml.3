Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbaKYLHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:07:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58898 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbaKYKmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:49 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 178/254] drm/radeon: make sure mode init is complete in bandwidth_update
Date: Tue, 25 Nov 2014 10:38:48 +0000
Message-Id: <1416912004-5928-179-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
index 180f2638c9cc..6f015436e51d 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -9060,6 +9060,9 @@ void dce8_bandwidth_update(struct radeon_device *rdev)
 	u32 num_heads = 0, lb_size;
 	int i;
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	for (i = 0; i < rdev->num_crtc; i++) {
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 15e4f28015e1..cd620bca6dd6 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2346,6 +2346,9 @@ void evergreen_bandwidth_update(struct radeon_device *rdev)
 	u32 num_heads = 0, lb_size;
 	int i;
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	for (i = 0; i < rdev->num_crtc; i++) {
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 1544efcf1c3a..7f64a30b50cd 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -3197,6 +3197,9 @@ void r100_bandwidth_update(struct radeon_device *rdev)
 	uint32_t pixel_bytes1 = 0;
 	uint32_t pixel_bytes2 = 0;
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	if (rdev->mode_info.crtcs[0]->base.enabled) {
diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index d1a35cb1c91d..d6e64b93d8b1 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -874,6 +874,9 @@ void rs600_bandwidth_update(struct radeon_device *rdev)
 	u32 d1mode_priority_a_cnt, d2mode_priority_a_cnt;
 	/* FIXME: implement full support */
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	if (rdev->mode_info.crtcs[0]->base.enabled)
diff --git a/drivers/gpu/drm/radeon/rs690.c b/drivers/gpu/drm/radeon/rs690.c
index 3462b64369bf..0a2d36e81108 100644
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
index 3e21e869015f..76c790c947b6 100644
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -1277,6 +1277,9 @@ void rv515_bandwidth_update(struct radeon_device *rdev)
 	struct drm_display_mode *mode0 = NULL;
 	struct drm_display_mode *mode1 = NULL;
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	if (rdev->mode_info.crtcs[0]->base.enabled)
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 6c17d3b0be8b..79fa0d13a3ca 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -2228,6 +2228,9 @@ void dce6_bandwidth_update(struct radeon_device *rdev)
 	u32 num_heads = 0, lb_size;
 	int i;
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	for (i = 0; i < rdev->num_crtc; i++) {
-- 
2.1.0

