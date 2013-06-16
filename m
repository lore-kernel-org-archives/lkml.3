Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab3FPWMz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:12:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46325 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755558Ab3FPWJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:09:12 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Deucher" <alexander.deucher@amd.com>,
        "=?UTF-8?q?Adis=20Hamzi=C4=87?=" <adis@hamzadis.com>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.110987206@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [51/83] radeon: Fix system hang issue when using KMS with older cards
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Adis Hamzić <adis@hamzadis.com>

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
[bwh: Backported to 3.2:
 - Adjust context
 - Drop changes for Southern Islands]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -3086,6 +3086,12 @@ static int evergreen_startup(struct rade
 		return r;
 
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
@@ -3218,10 +3224,6 @@ int evergreen_init(struct radeon_device
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	rdev->cp.ring_obj = NULL;
 	r600_ring_init(rdev, 1024 * 1024);
 
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -1389,6 +1389,12 @@ static int cayman_startup(struct radeon_
 		return r;
 
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
@@ -1506,10 +1512,6 @@ int cayman_init(struct radeon_device *rd
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	rdev->cp.ring_obj = NULL;
 	r600_ring_init(rdev, 1024 * 1024);
 
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -3905,6 +3905,12 @@ static int r100_startup(struct radeon_de
 		return r;
 
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
@@ -4050,9 +4056,6 @@ int r100_init(struct radeon_device *rdev
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -1397,6 +1397,12 @@ static int r300_startup(struct radeon_de
 		return r;
 
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
@@ -1521,9 +1527,6 @@ int r300_init(struct radeon_device *rdev
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
--- a/drivers/gpu/drm/radeon/r420.c
+++ b/drivers/gpu/drm/radeon/r420.c
@@ -255,6 +255,12 @@ static int r420_startup(struct radeon_de
 		return r;
 
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
@@ -391,10 +397,6 @@ int r420_init(struct radeon_device *rdev
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
--- a/drivers/gpu/drm/radeon/r520.c
+++ b/drivers/gpu/drm/radeon/r520.c
@@ -188,6 +188,12 @@ static int r520_startup(struct radeon_de
 		return r;
 
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
@@ -281,9 +287,6 @@ int r520_init(struct radeon_device *rdev
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2449,6 +2449,12 @@ int r600_startup(struct radeon_device *r
 		return r;
 
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
@@ -2592,10 +2598,6 @@ int r600_init(struct radeon_device *rdev
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	rdev->cp.ring_obj = NULL;
 	r600_ring_init(rdev, 1024 * 1024);
 
--- a/drivers/gpu/drm/radeon/rs400.c
+++ b/drivers/gpu/drm/radeon/rs400.c
@@ -411,6 +411,12 @@ static int rs400_startup(struct radeon_d
 		return r;
 
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
@@ -519,9 +525,6 @@ int rs400_init(struct radeon_device *rde
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -848,6 +848,12 @@ static int rs600_startup(struct radeon_d
 		return r;
 
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
@@ -963,9 +969,6 @@ int rs600_init(struct radeon_device *rde
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -622,6 +622,12 @@ static int rs690_startup(struct radeon_d
 		return r;
 
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
@@ -738,9 +744,6 @@ int rs690_init(struct radeon_device *rde
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -380,6 +380,12 @@ static int rv515_startup(struct radeon_d
 		return r;
 
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
@@ -500,9 +506,6 @@ int rv515_init(struct radeon_device *rde
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -1092,6 +1092,12 @@ static int rv770_startup(struct radeon_d
 		return r;
 
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
@@ -1220,10 +1226,6 @@ int rv770_init(struct radeon_device *rde
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	rdev->cp.ring_obj = NULL;
 	r600_ring_init(rdev, 1024 * 1024);
 

