Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbaKKMD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:03:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57247 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbaKKLJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Alexander Fyodorov <halcy@yandex.ru>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 032/170] drm/radeon: use gart memory for DMA ring tests
Date: Tue, 11 Nov 2014 11:06:31 +0000
Message-Id: <1415704129-12709-33-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit adfed2b0587289013f8143c54913ddfd44ac1fd3 upstream.

Avoids HDP cache flush issues when using vram which can
cause ring test failures on certain boards.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Alexander Fyodorov <halcy@yandex.ru>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/cik_sdma.c | 21 ++++++++++++---------
 drivers/gpu/drm/radeon/r600_dma.c | 21 ++++++++++++---------
 drivers/gpu/drm/radeon/radeon.h   |  2 ++
 3 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik_sdma.c b/drivers/gpu/drm/radeon/cik_sdma.c
index 72bff72c036d..f54d45bad01d 100644
--- a/drivers/gpu/drm/radeon/cik_sdma.c
+++ b/drivers/gpu/drm/radeon/cik_sdma.c
@@ -580,16 +580,19 @@ int cik_sdma_ring_test(struct radeon_device *rdev,
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
@@ -597,14 +600,14 @@ int cik_sdma_ring_test(struct radeon_device *rdev,
 		return r;
 	}
 	radeon_ring_write(ring, SDMA_PACKET(SDMA_OPCODE_WRITE, SDMA_WRITE_SUB_OPCODE_LINEAR, 0));
-	radeon_ring_write(ring, rdev->vram_scratch.gpu_addr & 0xfffffffc);
-	radeon_ring_write(ring, upper_32_bits(rdev->vram_scratch.gpu_addr));
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
index b766e052d91f..964c32031059 100644
--- a/drivers/gpu/drm/radeon/r600_dma.c
+++ b/drivers/gpu/drm/radeon/r600_dma.c
@@ -232,16 +232,19 @@ int r600_dma_ring_test(struct radeon_device *rdev,
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
@@ -249,13 +252,13 @@ int r600_dma_ring_test(struct radeon_device *rdev,
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
index 2d6b55d8461e..2a085d65b659 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -1102,6 +1102,8 @@ struct radeon_wb {
 #define R600_WB_EVENT_OFFSET     3072
 #define CIK_WB_CP1_WPTR_OFFSET     3328
 #define CIK_WB_CP2_WPTR_OFFSET     3584
+#define R600_WB_DMA_RING_TEST_OFFSET 3588
+#define CAYMAN_WB_DMA1_RING_TEST_OFFSET 3592
 
 /**
  * struct radeon_pm - power management datas
-- 
2.1.0

