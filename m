Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaKFWr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:47:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59161 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbaKFWo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:44:27 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Alexander Fyodorov <halcy@yandex.ru>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 076/162] drm/radeon: use gart memory for DMA ring tests
Date: Thu,  6 Nov 2014 14:35:40 -0800
Message-Id: <1415313426-9622-77-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit adfed2b0587289013f8143c54913ddfd44ac1fd3 upstream.

Avoids HDP cache flush issues when using vram which can
cause ring test failures on certain boards.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Alexander Fyodorov <halcy@yandex.ru>
[ kamal: backport to 3.13-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/cik_sdma.c | 21 ++++++++++++---------
 drivers/gpu/drm/radeon/r600_dma.c | 21 ++++++++++++---------
 drivers/gpu/drm/radeon/radeon.h   |  2 ++
 3 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik_sdma.c b/drivers/gpu/drm/radeon/cik_sdma.c
index 9fd95c7..376502d 100644
--- a/drivers/gpu/drm/radeon/cik_sdma.c
+++ b/drivers/gpu/drm/radeon/cik_sdma.c
@@ -508,16 +508,19 @@ int cik_sdma_ring_test(struct radeon_device *rdev,
 {
 	unsigned i;
 	int r;
-	void __iomem *ptr = (void *)rdev->vram_scratch.ptr;
+	unsigned index;
 	u32 tmp;
+	u64 gpu_addr;
 
-	if (!ptr) {
-		DRM_ERROR("invalid vram scratch pointer\n");
-		return -EINVAL;
-	}
+	if (ring->idx == R600_RING_TYPE_DMA_INDEX)
+		index = R600_WB_DMA_RING_TEST_OFFSET;
+	else
+		index = CAYMAN_WB_DMA1_RING_TEST_OFFSET;
+
+	gpu_addr = rdev->wb.gpu_addr + index;
 
 	tmp = 0xCAFEDEAD;
-	writel(tmp, ptr);
+	rdev->wb.wb[index/4] = cpu_to_le32(tmp);
 
 	r = radeon_ring_lock(rdev, ring, 5);
 	if (r) {
@@ -525,14 +528,14 @@ int cik_sdma_ring_test(struct radeon_device *rdev,
 		return r;
 	}
 	radeon_ring_write(ring, SDMA_PACKET(SDMA_OPCODE_WRITE, SDMA_WRITE_SUB_OPCODE_LINEAR, 0));
-	radeon_ring_write(ring, rdev->vram_scratch.gpu_addr & 0xfffffffc);
-	radeon_ring_write(ring, upper_32_bits(rdev->vram_scratch.gpu_addr) & 0xffffffff);
+	radeon_ring_write(ring, lower_32_bits(gpu_addr));
+	radeon_ring_write(ring, upper_32_bits(gpu_addr));
 	radeon_ring_write(ring, 1); /* number of DWs to follow */
 	radeon_ring_write(ring, 0xDEADBEEF);
 	radeon_ring_unlock_commit(rdev, ring);
 
 	for (i = 0; i < rdev->usec_timeout; i++) {
-		tmp = readl(ptr);
+		tmp = le32_to_cpu(rdev->wb.wb[index/4]);
 		if (tmp == 0xDEADBEEF)
 			break;
 		DRM_UDELAY(1);
diff --git a/drivers/gpu/drm/radeon/r600_dma.c b/drivers/gpu/drm/radeon/r600_dma.c
index 616d37a..cf5e181 100644
--- a/drivers/gpu/drm/radeon/r600_dma.c
+++ b/drivers/gpu/drm/radeon/r600_dma.c
@@ -227,16 +227,19 @@ int r600_dma_ring_test(struct radeon_device *rdev,
 {
 	unsigned i;
 	int r;
-	void __iomem *ptr = (void *)rdev->vram_scratch.ptr;
+	unsigned index;
 	u32 tmp;
+	u64 gpu_addr;
 
-	if (!ptr) {
-		DRM_ERROR("invalid vram scratch pointer\n");
-		return -EINVAL;
-	}
+	if (ring->idx == R600_RING_TYPE_DMA_INDEX)
+		index = R600_WB_DMA_RING_TEST_OFFSET;
+	else
+		index = CAYMAN_WB_DMA1_RING_TEST_OFFSET;
+
+	gpu_addr = rdev->wb.gpu_addr + index;
 
 	tmp = 0xCAFEDEAD;
-	writel(tmp, ptr);
+	rdev->wb.wb[index/4] = cpu_to_le32(tmp);
 
 	r = radeon_ring_lock(rdev, ring, 4);
 	if (r) {
@@ -244,13 +247,13 @@ int r600_dma_ring_test(struct radeon_device *rdev,
 		return r;
 	}
 	radeon_ring_write(ring, DMA_PACKET(DMA_PACKET_WRITE, 0, 0, 1));
-	radeon_ring_write(ring, rdev->vram_scratch.gpu_addr & 0xfffffffc);
-	radeon_ring_write(ring, upper_32_bits(rdev->vram_scratch.gpu_addr) & 0xff);
+	radeon_ring_write(ring, lower_32_bits(gpu_addr));
+	radeon_ring_write(ring, upper_32_bits(gpu_addr) & 0xff);
 	radeon_ring_write(ring, 0xDEADBEEF);
 	radeon_ring_unlock_commit(rdev, ring);
 
 	for (i = 0; i < rdev->usec_timeout; i++) {
-		tmp = readl(ptr);
+		tmp = le32_to_cpu(rdev->wb.wb[index/4]);
 		if (tmp == 0xDEADBEEF)
 			break;
 		DRM_UDELAY(1);
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index fd2526c..ee3be48 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -1081,6 +1081,8 @@ struct radeon_wb {
 #define R600_WB_EVENT_OFFSET     3072
 #define CIK_WB_CP1_WPTR_OFFSET     3328
 #define CIK_WB_CP2_WPTR_OFFSET     3584
+#define R600_WB_DMA_RING_TEST_OFFSET 3588
+#define CAYMAN_WB_DMA1_RING_TEST_OFFSET 3592
 
 /**
  * struct radeon_pm - power management datas
-- 
1.9.1

