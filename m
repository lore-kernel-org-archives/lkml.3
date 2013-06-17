Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab3FQRtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:49:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50614 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab3FQRfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:35:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Adis=20Hamzi=C4=87?= <adis@hamzadis.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 44/84] radeon: Fix system hang issue when using KMS with older cards
Date: Mon, 17 Jun 2013 10:30:48 -0700
Message-Id: <1371490288-23167-45-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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
index b336afc..eeb1aad 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -3573,6 +3573,12 @@ static int evergreen_startup(struct radeon_device *rdev)
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
@@ -3721,10 +3727,6 @@ int evergreen_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	rdev->ring[RADEON_RING_TYPE_GFX_INDEX].ring_obj = NULL;
 	r600_ring_init(rdev, &rdev->ring[RADEON_RING_TYPE_GFX_INDEX], 1024 * 1024);
 
diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index 10e1bd1..ce94b27 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -1602,6 +1602,12 @@ static int cayman_startup(struct radeon_device *rdev)
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
@@ -1748,10 +1754,6 @@ int cayman_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	ring->ring_obj = NULL;
 	r600_ring_init(rdev, ring, 1024 * 1024);
 
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 62719ec..b833fbe 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -3979,6 +3979,12 @@ static int r100_startup(struct radeon_device *rdev)
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
@@ -4134,9 +4140,6 @@ int r100_init(struct radeon_device *rdev)
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
index d0ba602..39369c1 100644
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
index becb03e..040d27a 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2791,6 +2791,12 @@ static int r600_startup(struct radeon_device *rdev)
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
@@ -2945,10 +2951,6 @@ int r600_init(struct radeon_device *rdev)
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
index 5706d2a..fad6633 100644
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
@@ -753,9 +759,6 @@ int rs690_init(struct radeon_device *rdev)
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
index 1b2444f..caada8c 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -1016,6 +1016,12 @@ static int rv770_startup(struct radeon_device *rdev)
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
@@ -1155,10 +1161,6 @@ int rv770_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	rdev->ring[RADEON_RING_TYPE_GFX_INDEX].ring_obj = NULL;
 	r600_ring_init(rdev, &rdev->ring[RADEON_RING_TYPE_GFX_INDEX], 1024 * 1024);
 
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 5d4bc96..075d52e 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -4137,6 +4137,12 @@ static int si_startup(struct radeon_device *rdev)
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
@@ -4297,10 +4303,6 @@ int si_init(struct radeon_device *rdev)
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

