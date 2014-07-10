Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbaGJVus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:50:48 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:35786 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbaGJVuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:50:46 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 03/83] drm/radeon: Report doorbell configuration to kfd
Date: Fri, 11 Jul 2014 00:50:03 +0300
Message-Id: <1405029027-6085-2-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Radeon and KFD share the doorbell aperture.
Radeon sets it up, takes the doorbells required for its own rings
and reports the setup to KFD.
Radeon reserved doorbells are at the start of the doorbell aperture.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/radeon.h        |  4 ++++
 drivers/gpu/drm/radeon/radeon_device.c | 31 +++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 7cda75d..4e7e41f 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -676,6 +676,10 @@ struct radeon_doorbell {
 
 int radeon_doorbell_get(struct radeon_device *rdev, u32 *page);
 void radeon_doorbell_free(struct radeon_device *rdev, u32 doorbell);
+void radeon_doorbell_get_kfd_info(struct radeon_device *rdev,
+				  phys_addr_t *aperture_base,
+				  size_t *aperture_size,
+				  size_t *start_offset);
 
 /*
  * IRQS.
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 03686fa..98538d2 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -328,6 +328,37 @@ void radeon_doorbell_free(struct radeon_device *rdev, u32 doorbell)
 		__clear_bit(doorbell, rdev->doorbell.used);
 }
 
+/**
+ * radeon_doorbell_get_kfd_info - Report doorbell configuration required to
+ *                                setup KFD
+ *
+ * @rdev: radeon_device pointer
+ * @aperture_base: output returning doorbell aperture base physical address
+ * @aperture_size: output returning doorbell aperture size in bytes
+ * @start_offset: output returning # of doorbell bytes reserved for radeon.
+ *
+ * Radeon and the KFD share the doorbell aperture. Radeon sets it up,
+ * takes doorbells required for its own rings and reports the setup to KFD.
+ * Radeon reserved doorbells are at the start of the doorbell aperture.
+ */
+void radeon_doorbell_get_kfd_info(struct radeon_device *rdev,
+				  phys_addr_t *aperture_base,
+				  size_t *aperture_size,
+				  size_t *start_offset)
+{
+	/* The first num_doorbells are used by radeon.
+	 * KFD takes whatever's left in the aperture. */
+	if (rdev->doorbell.size > rdev->doorbell.num_doorbells * sizeof(u32)) {
+		*aperture_base = rdev->doorbell.base;
+		*aperture_size = rdev->doorbell.size;
+		*start_offset = rdev->doorbell.num_doorbells * sizeof(u32);
+	} else {
+		*aperture_base = 0;
+		*aperture_size = 0;
+		*start_offset = 0;
+	}
+}
+
 /*
  * radeon_wb_*()
  * Writeback is the the method by which the the GPU updates special pages
-- 
1.9.1

