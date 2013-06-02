Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab3FBOsx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 10:48:53 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33748 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab3FBOsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 10:48:46 -0400
From: =?UTF-8?q?Adis=20Hamzi=C4=87?= <adis@hamzadis.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Adis=20Hamzi=C4=87?= <adis@hamzadis.com>
Subject: [PATCH 1/1] radeon: Fix system hang issue when using KMS with older cards
Date: Sun,  2 Jun 2013 16:47:54 +0200
Message-Id: <1370184474-14392-1-git-send-email-adis@hamzadis.com>
X-Mailer: git-send-email 1.8.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current radeon driver initialization routines, when using KMS, are written
so that the IRQ installation routine is called before initializing the WB buffer
and the CP rings. With some ASICs, though, the IRQ routine tries to access the
GFX_INDEX ring causing a call to RREG32 with the value of -1 in
radeon_fence_read. This, in turn causes the system to completely hang with some
cards, requiring a hard reset.

A call stack that can cause such a hang looks like this (using rv515 ASIC for the
example here):
 * rv515_init (rv515.c)
 * radeon_irq_kms_init (radeon_irq_kms.c)
 * drm_irq_install (drm_irq.c)
 * radeon_driver_irq_preinstall_kms (radeon_irq_kms.c)
 * rs600_irq_process (rs600.c)
 * radeon_fence_process - due to SW interrupt (radeon_fence.c)
 * radeon_fence_read (radeon_fence.c)
 * hang due to RREG32(-1)

The patch moves the IRQ installation to the card startup routine, after the ring
has been initialized, but before the IRQ has been set. This fixes the issue, but
requires a check to see if the IRQ is already installed, as is the case in the
system resume codepath.
I have tested the patch on three machines using the rv515, the rv770 and the
evergreen ASIC. They worked without issues.

This seems to be a known issue and has been reported on several bug tracking
sites by various distributions (see links below). Most of reports recommend
booting the system with KMS disabled and then enabling KMS by reloading the
radeon module. For some reason, this was indeed a usable workaround, however,
UMS is now deprecated and disabled by default.

Bug reports:
https://bugzilla.redhat.com/show_bug.cgi?id=845745
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/561789
https://bbs.archlinux.org/viewtopic.php?id=156964

Signed-off-by: Adis Hamzić <adis@hamzadis.com>
---
 drivers/gpu/drm/radeon/evergreen.c | 10 ++++++----
 drivers/gpu/drm/radeon/ni.c        | 10 ++++++----
 drivers/gpu/drm/radeon/r100.c      |  9 ++++++---
 drivers/gpu/drm/radeon/r300.c      |  9 ++++++---
 drivers/gpu/drm/radeon/r420.c      | 10 ++++++----
 drivers/gpu/drm/radeon/r520.c      |  9 ++++++---
 drivers/gpu/drm/radeon/r600.c      | 10 ++++++----
 drivers/gpu/drm/radeon/rs400.c     |  9 ++++++---
 drivers/gpu/drm/radeon/rs600.c     |  9 ++++++---
 drivers/gpu/drm/radeon/rs690.c     |  9 ++++++---
 drivers/gpu/drm/radeon/rv515.c     |  9 ++++++---
 drivers/gpu/drm/radeon/rv770.c     | 10 ++++++----
 drivers/gpu/drm/radeon/si.c        | 10 ++++++----
 13 files changed, 78 insertions(+), 45 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 8546e3b..0f89ce3 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -4754,6 +4754,12 @@ static int evergreen_startup(struct radeon_device *rdev)
 		rdev->ring[R600_RING_TYPE_UVD_INDEX].ring_size = 0;
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r = r600_irq_init(rdev);
 	if (r) {
 		DRM_ERROR("radeon: IH init failed (%d).\n", r);
@@ -4923,10 +4929,6 @@ int evergreen_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	rdev->ring[RADEON_RING_TYPE_GFX_INDEX].ring_obj = NULL;
 	r600_ring_init(rdev, &rdev->ring[RADEON_RING_TYPE_GFX_INDEX], 1024 * 1024);
 
diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index 7969c0c..8458330 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -2025,6 +2025,12 @@ static int cayman_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r = r600_irq_init(rdev);
 	if (r) {
 		DRM_ERROR("radeon: IH init failed (%d).\n", r);
@@ -2190,10 +2196,6 @@ int cayman_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	ring->ring_obj = NULL;
 	r600_ring_init(rdev, ring, 1024 * 1024);
 
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 4973bff..d0314ec 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -3869,6 +3869,12 @@ static int r100_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r100_irq_set(rdev);
 	rdev->config.r100.hdp_cntl = RREG32(RADEON_HOST_PATH_CNTL);
 	/* 1M ring buffer */
@@ -4024,9 +4030,6 @@ int r100_init(struct radeon_device *rdev)
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
index c60350e..b9b776f 100644
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -1382,6 +1382,12 @@ static int r300_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r100_irq_set(rdev);
 	rdev->config.r300.hdp_cntl = RREG32(RADEON_HOST_PATH_CNTL);
 	/* 1M ring buffer */
@@ -1516,9 +1522,6 @@ int r300_init(struct radeon_device *rdev)
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
diff --git a/drivers/gpu/drm/radeon/r420.c b/drivers/gpu/drm/radeon/r420.c
index 6fce2eb..4e796ec 100644
--- a/drivers/gpu/drm/radeon/r420.c
+++ b/drivers/gpu/drm/radeon/r420.c
@@ -265,6 +265,12 @@ static int r420_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r100_irq_set(rdev);
 	rdev->config.r300.hdp_cntl = RREG32(RADEON_HOST_PATH_CNTL);
 	/* 1M ring buffer */
@@ -411,10 +417,6 @@ int r420_init(struct radeon_device *rdev)
 	if (r) {
 		return r;
 	}
-	r = radeon_irq_kms_init(rdev);
-	if (r) {
-		return r;
-	}
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r) {
diff --git a/drivers/gpu/drm/radeon/r520.c b/drivers/gpu/drm/radeon/r520.c
index f795a4e..e1aece7 100644
--- a/drivers/gpu/drm/radeon/r520.c
+++ b/drivers/gpu/drm/radeon/r520.c
@@ -194,6 +194,12 @@ static int r520_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	rs600_irq_set(rdev);
 	rdev->config.r300.hdp_cntl = RREG32(RADEON_HOST_PATH_CNTL);
 	/* 1M ring buffer */
@@ -297,9 +303,6 @@ int r520_init(struct radeon_device *rdev)
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index b45e648..0f30d0d 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -3202,6 +3202,12 @@ static int r600_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r = r600_irq_init(rdev);
 	if (r) {
 		DRM_ERROR("radeon: IH init failed (%d).\n", r);
@@ -3356,10 +3362,6 @@ int r600_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	rdev->ring[RADEON_RING_TYPE_GFX_INDEX].ring_obj = NULL;
 	r600_ring_init(rdev, &rdev->ring[RADEON_RING_TYPE_GFX_INDEX], 1024 * 1024);
 
diff --git a/drivers/gpu/drm/radeon/rs400.c b/drivers/gpu/drm/radeon/rs400.c
index 73051ce..233a9b9 100644
--- a/drivers/gpu/drm/radeon/rs400.c
+++ b/drivers/gpu/drm/radeon/rs400.c
@@ -417,6 +417,12 @@ static int rs400_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r100_irq_set(rdev);
 	rdev->config.r300.hdp_cntl = RREG32(RADEON_HOST_PATH_CNTL);
 	/* 1M ring buffer */
@@ -535,9 +541,6 @@ int rs400_init(struct radeon_device *rdev)
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index 46fa1b0..670b555 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -923,6 +923,12 @@ static int rs600_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	rs600_irq_set(rdev);
 	rdev->config.r300.hdp_cntl = RREG32(RADEON_HOST_PATH_CNTL);
 	/* 1M ring buffer */
@@ -1047,9 +1053,6 @@ int rs600_init(struct radeon_device *rdev)
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
diff --git a/drivers/gpu/drm/radeon/rs690.c b/drivers/gpu/drm/radeon/rs690.c
index ab4c86c..55880d5 100644
--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -651,6 +651,12 @@ static int rs690_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	rs600_irq_set(rdev);
 	rdev->config.r300.hdp_cntl = RREG32(RADEON_HOST_PATH_CNTL);
 	/* 1M ring buffer */
@@ -776,9 +782,6 @@ int rs690_init(struct radeon_device *rdev)
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
diff --git a/drivers/gpu/drm/radeon/rv515.c b/drivers/gpu/drm/radeon/rv515.c
index ffcba73..21c7d7b 100644
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -532,6 +532,12 @@ static int rv515_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	rs600_irq_set(rdev);
 	rdev->config.r300.hdp_cntl = RREG32(RADEON_HOST_PATH_CNTL);
 	/* 1M ring buffer */
@@ -662,9 +668,6 @@ int rv515_init(struct radeon_device *rdev)
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index 08aef24..4a62ad2 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -1887,6 +1887,12 @@ static int rv770_startup(struct radeon_device *rdev)
 		rdev->ring[R600_RING_TYPE_UVD_INDEX].ring_size = 0;
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r = r600_irq_init(rdev);
 	if (r) {
 		DRM_ERROR("radeon: IH init failed (%d).\n", r);
@@ -2045,10 +2051,6 @@ int rv770_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	rdev->ring[RADEON_RING_TYPE_GFX_INDEX].ring_obj = NULL;
 	r600_ring_init(rdev, &rdev->ring[RADEON_RING_TYPE_GFX_INDEX], 1024 * 1024);
 
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index d1ba9d8..a1b0da6 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -5350,6 +5350,12 @@ static int si_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r = si_irq_init(rdev);
 	if (r) {
 		DRM_ERROR("radeon: IH init failed (%d).\n", r);
@@ -5533,10 +5539,6 @@ int si_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	ring = &rdev->ring[RADEON_RING_TYPE_GFX_INDEX];
 	ring->ring_obj = NULL;
 	r600_ring_init(rdev, ring, 1024 * 1024);
-- 
1.8.3

