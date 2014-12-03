Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaLCL1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:27:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbaLCL10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:26 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 035/101] drm/radeon: make sure mode init is complete in bandwidth_update
Date: Wed,  3 Dec 2014 12:25:57 +0100
Message-Id: <30c45d8c1094fa14ef7180bbd5cf3af33b49f1c8.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
index 8cefe1cf7df7..0fc5fd6b3b41 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -8105,6 +8105,9 @@ void dce8_bandwidth_update(struct radeon_device *rdev)
 	u32 num_heads = 0, lb_size;
 	int i;
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	for (i = 0; i < rdev->num_crtc; i++) {
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 7ca58fc7a1c6..9e726f2d2e75 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2312,6 +2312,9 @@ void evergreen_bandwidth_update(struct radeon_device *rdev)
 	u32 num_heads = 0, lb_size;
 	int i;
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	for (i = 0; i < rdev->num_crtc; i++) {
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index d71333033b2b..f98dcbeb9a72 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -3189,6 +3189,9 @@ void r100_bandwidth_update(struct radeon_device *rdev)
 	uint32_t pixel_bytes1 = 0;
 	uint32_t pixel_bytes2 = 0;
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	if (rdev->mode_info.crtcs[0]->base.enabled) {
diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index e0daa4fdb073..bbe84591f159 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -826,6 +826,9 @@ void rs600_bandwidth_update(struct radeon_device *rdev)
 	u32 d1mode_priority_a_cnt, d2mode_priority_a_cnt;
 	/* FIXME: implement full support */
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	if (rdev->mode_info.crtcs[0]->base.enabled)
diff --git a/drivers/gpu/drm/radeon/rs690.c b/drivers/gpu/drm/radeon/rs690.c
index 3c38f0af78fb..d33b4ad39b25 100644
--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -585,6 +585,9 @@ void rs690_bandwidth_update(struct radeon_device *rdev)
 	u32 d1mode_priority_a_cnt, d1mode_priority_b_cnt;
 	u32 d2mode_priority_a_cnt, d2mode_priority_b_cnt;
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	if (rdev->mode_info.crtcs[0]->base.enabled)
diff --git a/drivers/gpu/drm/radeon/rv515.c b/drivers/gpu/drm/radeon/rv515.c
index 873eb4b193b4..9de81c5487e9 100644
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -1279,6 +1279,9 @@ void rv515_bandwidth_update(struct radeon_device *rdev)
 	struct drm_display_mode *mode0 = NULL;
 	struct drm_display_mode *mode1 = NULL;
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	if (rdev->mode_info.crtcs[0]->base.enabled)
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 53769e9cf595..50482e763d80 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -2230,6 +2230,9 @@ void dce6_bandwidth_update(struct radeon_device *rdev)
 	u32 num_heads = 0, lb_size;
 	int i;
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	for (i = 0; i < rdev->num_crtc; i++) {
-- 
2.1.3

