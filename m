Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab3JJPtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:49:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52971 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390Ab3JJPtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:49:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tom Stellard <thomas.stellard@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 028/104] drm/radeon/si: Add support for CP DMA to CS checker for compute v2
Date: Thu, 10 Oct 2013 08:41:16 -0700
Message-Id: <1381419752-29733-29-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Stellard <thomas.stellard@amd.com>

commit e5b9e7503eb1f4884efa3b321d3cc47806779202 upstream.

Also add a new RADEON_INFO query to check that CP DMA packets are
supported on the compute ring.

CP DMA has been supported since the 3.8 kernel, but due to an oversight
we forgot to teach the CS checker that the CP DMA packet was legal for
the compute ring on Southern Islands GPUs.

This patch fixes a bug where the radeon driver will incorrectly reject a legal
CP DMA packet from user space.  I would like to have the patch
backported to stable so that we don't have to require Mesa users to use a
bleeding edge kernel in order to take advantage of this feature which
is already present in the stable kernels (3.8 and newer).

v2:
  - Don't bump kms version, so this patch can be backported to stable
    kernels.

Signed-off-by: Tom Stellard <thomas.stellard@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_kms.c |   3 +
 drivers/gpu/drm/radeon/si.c         | 106 +++++++++++++++++++++---------------
 include/uapi/drm/radeon_drm.h       |   3 +
 3 files changed, 67 insertions(+), 45 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index bc36922..799ce63 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -381,6 +381,9 @@ int radeon_info_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 		else
 			return -EINVAL;
 		break;
+	case RADEON_INFO_SI_CP_DMA_COMPUTE:
+		value = 1;
+		break;
 	default:
 		DRM_DEBUG_KMS("Invalid request %d\n", info->request);
 		return -EINVAL;
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 7742831..966b5e6 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -2622,13 +2622,64 @@ static int si_vm_packet3_ce_check(struct radeon_device *rdev,
 	return 0;
 }
 
+static int si_vm_packet3_cp_dma_check(u32 *ib, u32 idx)
+{
+	u32 start_reg, reg, i;
+	u32 command = ib[idx + 4];
+	u32 info = ib[idx + 1];
+	u32 idx_value = ib[idx];
+	if (command & PACKET3_CP_DMA_CMD_SAS) {
+		/* src address space is register */
+		if (((info & 0x60000000) >> 29) == 0) {
+			start_reg = idx_value << 2;
+			if (command & PACKET3_CP_DMA_CMD_SAIC) {
+				reg = start_reg;
+				if (!si_vm_reg_valid(reg)) {
+					DRM_ERROR("CP DMA Bad SRC register\n");
+					return -EINVAL;
+				}
+			} else {
+				for (i = 0; i < (command & 0x1fffff); i++) {
+					reg = start_reg + (4 * i);
+					if (!si_vm_reg_valid(reg)) {
+						DRM_ERROR("CP DMA Bad SRC register\n");
+						return -EINVAL;
+					}
+				}
+			}
+		}
+	}
+	if (command & PACKET3_CP_DMA_CMD_DAS) {
+		/* dst address space is register */
+		if (((info & 0x00300000) >> 20) == 0) {
+			start_reg = ib[idx + 2];
+			if (command & PACKET3_CP_DMA_CMD_DAIC) {
+				reg = start_reg;
+				if (!si_vm_reg_valid(reg)) {
+					DRM_ERROR("CP DMA Bad DST register\n");
+					return -EINVAL;
+				}
+			} else {
+				for (i = 0; i < (command & 0x1fffff); i++) {
+					reg = start_reg + (4 * i);
+				if (!si_vm_reg_valid(reg)) {
+						DRM_ERROR("CP DMA Bad DST register\n");
+						return -EINVAL;
+					}
+				}
+			}
+		}
+	}
+	return 0;
+}
+
 static int si_vm_packet3_gfx_check(struct radeon_device *rdev,
 				   u32 *ib, struct radeon_cs_packet *pkt)
 {
+	int r;
 	u32 idx = pkt->idx + 1;
 	u32 idx_value = ib[idx];
 	u32 start_reg, end_reg, reg, i;
-	u32 command, info;
 
 	switch (pkt->opcode) {
 	case PACKET3_NOP:
@@ -2729,50 +2780,9 @@ static int si_vm_packet3_gfx_check(struct radeon_device *rdev,
 		}
 		break;
 	case PACKET3_CP_DMA:
-		command = ib[idx + 4];
-		info = ib[idx + 1];
-		if (command & PACKET3_CP_DMA_CMD_SAS) {
-			/* src address space is register */
-			if (((info & 0x60000000) >> 29) == 0) {
-				start_reg = idx_value << 2;
-				if (command & PACKET3_CP_DMA_CMD_SAIC) {
-					reg = start_reg;
-					if (!si_vm_reg_valid(reg)) {
-						DRM_ERROR("CP DMA Bad SRC register\n");
-						return -EINVAL;
-					}
-				} else {
-					for (i = 0; i < (command & 0x1fffff); i++) {
-						reg = start_reg + (4 * i);
-						if (!si_vm_reg_valid(reg)) {
-							DRM_ERROR("CP DMA Bad SRC register\n");
-							return -EINVAL;
-						}
-					}
-				}
-			}
-		}
-		if (command & PACKET3_CP_DMA_CMD_DAS) {
-			/* dst address space is register */
-			if (((info & 0x00300000) >> 20) == 0) {
-				start_reg = ib[idx + 2];
-				if (command & PACKET3_CP_DMA_CMD_DAIC) {
-					reg = start_reg;
-					if (!si_vm_reg_valid(reg)) {
-						DRM_ERROR("CP DMA Bad DST register\n");
-						return -EINVAL;
-					}
-				} else {
-					for (i = 0; i < (command & 0x1fffff); i++) {
-						reg = start_reg + (4 * i);
-						if (!si_vm_reg_valid(reg)) {
-							DRM_ERROR("CP DMA Bad DST register\n");
-							return -EINVAL;
-						}
-					}
-				}
-			}
-		}
+		r = si_vm_packet3_cp_dma_check(ib, idx);
+		if (r)
+			return r;
 		break;
 	default:
 		DRM_ERROR("Invalid GFX packet3: 0x%x\n", pkt->opcode);
@@ -2784,6 +2794,7 @@ static int si_vm_packet3_gfx_check(struct radeon_device *rdev,
 static int si_vm_packet3_compute_check(struct radeon_device *rdev,
 				       u32 *ib, struct radeon_cs_packet *pkt)
 {
+	int r;
 	u32 idx = pkt->idx + 1;
 	u32 idx_value = ib[idx];
 	u32 start_reg, reg, i;
@@ -2856,6 +2867,11 @@ static int si_vm_packet3_compute_check(struct radeon_device *rdev,
 				return -EINVAL;
 		}
 		break;
+	case PACKET3_CP_DMA:
+		r = si_vm_packet3_cp_dma_check(ib, idx);
+		if (r)
+			return r;
+		break;
 	default:
 		DRM_ERROR("Invalid Compute packet3: 0x%x\n", pkt->opcode);
 		return -EINVAL;
diff --git a/include/uapi/drm/radeon_drm.h b/include/uapi/drm/radeon_drm.h
index eeda917..59c1b31 100644
--- a/include/uapi/drm/radeon_drm.h
+++ b/include/uapi/drm/radeon_drm.h
@@ -972,6 +972,9 @@ struct drm_radeon_cs {
 #define RADEON_INFO_MAX_SE		0x12
 /* max SH per SE */
 #define RADEON_INFO_MAX_SH_PER_SE	0x13
+/* query if CP DMA is supported on the compute ring */
+#define RADEON_INFO_SI_CP_DMA_COMPUTE	0x17
+
 
 struct drm_radeon_info {
 	uint32_t		request;
-- 
1.8.1.2

