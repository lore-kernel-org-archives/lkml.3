Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216AbaKSVxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:53:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933344AbaKSVEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:04:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.14 039/122] drm/radeon: make sure mode init is complete in bandwidth_update
Date: Wed, 19 Nov 2014 12:51:29 -0800
Message-Id: <20141119205210.055071365@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/cik.c       |    3 +++
 drivers/gpu/drm/radeon/evergreen.c |    3 +++
 drivers/gpu/drm/radeon/r100.c      |    3 +++
 drivers/gpu/drm/radeon/rs600.c     |    3 +++
 drivers/gpu/drm/radeon/rs690.c     |    3 +++
 drivers/gpu/drm/radeon/rv515.c     |    3 +++
 drivers/gpu/drm/radeon/si.c        |    3 +++
 7 files changed, 21 insertions(+)

--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -8893,6 +8893,9 @@ void dce8_bandwidth_update(struct radeon
 	u32 num_heads = 0, lb_size;
 	int i;
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	for (i = 0; i < rdev->num_crtc; i++) {
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2362,6 +2362,9 @@ void evergreen_bandwidth_update(struct r
 	u32 num_heads = 0, lb_size;
 	int i;
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	for (i = 0; i < rdev->num_crtc; i++) {
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -3219,6 +3219,9 @@ void r100_bandwidth_update(struct radeon
 	uint32_t pixel_bytes1 = 0;
 	uint32_t pixel_bytes2 = 0;
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	if (rdev->mode_info.crtcs[0]->base.enabled) {
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -890,6 +890,9 @@ void rs600_bandwidth_update(struct radeo
 	u32 d1mode_priority_a_cnt, d2mode_priority_a_cnt;
 	/* FIXME: implement full support */
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	if (rdev->mode_info.crtcs[0]->base.enabled)
--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -579,6 +579,9 @@ void rs690_bandwidth_update(struct radeo
 	u32 d1mode_priority_a_cnt, d1mode_priority_b_cnt;
 	u32 d2mode_priority_a_cnt, d2mode_priority_b_cnt;
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	if (rdev->mode_info.crtcs[0]->base.enabled)
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -1276,6 +1276,9 @@ void rv515_bandwidth_update(struct radeo
 	struct drm_display_mode *mode0 = NULL;
 	struct drm_display_mode *mode1 = NULL;
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	if (rdev->mode_info.crtcs[0]->base.enabled)
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -2227,6 +2227,9 @@ void dce6_bandwidth_update(struct radeon
 	u32 num_heads = 0, lb_size;
 	int i;
 
+	if (!rdev->mode_info.mode_config_initialized)
+		return;
+
 	radeon_update_display_priority(rdev);
 
 	for (i = 0; i < rdev->num_crtc; i++) {


