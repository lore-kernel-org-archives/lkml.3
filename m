Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab3FRMA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:00:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56073 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284Ab3FRLof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:35 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Adis=20Hamzi=C4=87?= <adis@hamzadis.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 40/93] radeon: Fix system hang issue when using KMS with older cards
Date: Tue, 18 Jun 2013 12:42:48 +0100
Message-Id: <1371555821-12820-41-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Adis=20Hamzi=C4=87?= <adis@hamzadis.com>

commit e49f3959a96dc279860af7e86e6dbcfda50580a5 upstream.

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
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ luis: backport to 3.5: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
index d18b343..7dbb1aa 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -3120,6 +3120,12 @@ static int evergreen_startup(struct radeon_device *rdev)
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
@@ -3264,10 +3270,6 @@ int evergreen_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	rdev->ring[RADEON_RING_TYPE_GFX_INDEX].ring_obj = NULL;
 	r600_ring_init(rdev, &rdev->ring[RADEON_RING_TYPE_GFX_INDEX], 1024 * 1024);
 
diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index 137b1f5..8d2a168 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -1313,6 +1313,12 @@ static int cayman_startup(struct radeon_device *rdev)
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
@@ -1441,10 +1447,6 @@ int cayman_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	ring->ring_obj = NULL;
 	r600_ring_init(rdev, ring, 1024 * 1024);
 
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index fb44e7e..fe70204 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -3896,6 +3896,12 @@ static int r100_startup(struct radeon_device *rdev)
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
@@ -4054,9 +4060,6 @@ int r100_init(struct radeon_device *rdev)
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
index 97722a3..30ec27a 100644
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
@@ -1519,9 +1525,6 @@ int r300_init(struct radeon_device *rdev)
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
index 99137be..1cf55d9 100644
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
@@ -414,10 +420,6 @@ int r420_init(struct radeon_device *rdev)
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
index b5cf837..36b7a5c 100644
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
@@ -299,9 +305,6 @@ int r520_init(struct radeon_device *rdev)
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
index 0c7476d..ffaf3ba 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2401,6 +2401,12 @@ int r600_startup(struct radeon_device *rdev)
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
@@ -2548,10 +2554,6 @@ int r600_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	rdev->ring[RADEON_RING_TYPE_GFX_INDEX].ring_obj = NULL;
 	r600_ring_init(rdev, &rdev->ring[RADEON_RING_TYPE_GFX_INDEX], 1024 * 1024);
 
diff --git a/drivers/gpu/drm/radeon/rs400.c b/drivers/gpu/drm/radeon/rs400.c
index a464eb5..9ada7ed 100644
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
@@ -538,9 +544,6 @@ int rs400_init(struct radeon_device *rdev)
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
index e95c5e6..d0eea5c 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -899,6 +899,12 @@ static int rs600_startup(struct radeon_device *rdev)
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
@@ -1026,9 +1032,6 @@ int rs600_init(struct radeon_device *rdev)
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
index 159b6a4..bcfb0a3 100644
--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -628,6 +628,12 @@ static int rs690_startup(struct radeon_device *rdev)
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
@@ -756,9 +762,6 @@ int rs690_init(struct radeon_device *rdev)
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
index 5e70fcb..3368c8c 100644
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -386,6 +386,12 @@ static int rv515_startup(struct radeon_device *rdev)
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
@@ -518,9 +524,6 @@ int rv515_init(struct radeon_device *rdev)
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
index b4f51c5..3b8e95a 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -931,6 +931,12 @@ static int rv770_startup(struct radeon_device *rdev)
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
@@ -1062,10 +1068,6 @@ int rv770_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	rdev->ring[RADEON_RING_TYPE_GFX_INDEX].ring_obj = NULL;
 	r600_ring_init(rdev, &rdev->ring[RADEON_RING_TYPE_GFX_INDEX], 1024 * 1024);
 
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index df76c27..97b89b7 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -3747,6 +3747,12 @@ static int si_startup(struct radeon_device *rdev)
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
@@ -3911,10 +3917,6 @@ int si_init(struct radeon_device *rdev)
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
1.8.1.2

