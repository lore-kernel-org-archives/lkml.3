Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab3I2Tyn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:54:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab3I2T2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:28:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tom Stellard <thomas.stellard@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 27/49] drm/radeon/si: Add support for CP DMA to CS checker for compute v2
Date: Sun, 29 Sep 2013 12:27:01 -0700
Message-Id: <20130929191604.855506372@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929191603.008825488@linuxfoundation.org>
References: <20130929191603.008825488@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_kms.c |    3 +
 drivers/gpu/drm/radeon/si.c         |  106 ++++++++++++++++++++----------------
 include/uapi/drm/radeon_drm.h       |    2 
 3 files changed, 66 insertions(+), 45 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -414,6 +414,9 @@ int radeon_info_ioctl(struct drm_device
 		value = rdev->config.si.tile_mode_array;
 		value_size = sizeof(uint32_t)*32;
 		break;
+	case RADEON_INFO_SI_CP_DMA_COMPUTE:
+		*value = 1;
+		break;
 	default:
 		DRM_DEBUG_KMS("Invalid request %d\n", info->request);
 		return -EINVAL;
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -3796,13 +3796,64 @@ static int si_vm_packet3_ce_check(struct
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
@@ -3903,50 +3954,9 @@ static int si_vm_packet3_gfx_check(struc
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
@@ -3958,6 +3968,7 @@ static int si_vm_packet3_gfx_check(struc
 static int si_vm_packet3_compute_check(struct radeon_device *rdev,
 				       u32 *ib, struct radeon_cs_packet *pkt)
 {
+	int r;
 	u32 idx = pkt->idx + 1;
 	u32 idx_value = ib[idx];
 	u32 start_reg, reg, i;
@@ -4030,6 +4041,11 @@ static int si_vm_packet3_compute_check(s
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
--- a/include/uapi/drm/radeon_drm.h
+++ b/include/uapi/drm/radeon_drm.h
@@ -979,6 +979,8 @@ struct drm_radeon_cs {
 #define RADEON_INFO_RING_WORKING	0x15
 /* SI tile mode array */
 #define RADEON_INFO_SI_TILE_MODE_ARRAY	0x16
+/* query if CP DMA is supported on the compute ring */
+#define RADEON_INFO_SI_CP_DMA_COMPUTE	0x17
 
 
 struct drm_radeon_info {


