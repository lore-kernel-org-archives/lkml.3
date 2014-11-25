Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbaKYLGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:06:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58902 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbaKYKmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:49 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 179/254] drm/radeon: use gart for DMA IB tests
Date: Tue, 25 Nov 2014 10:38:49 +0000
Message-Id: <1416912004-5928-180-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 0b021c5802fbe5addf6f89f5030f684adf04f7b7 upstream.

Use gart rather than vram to avoid having to deal with
the HDP cache.

Port of adfed2b0587289013f8143c54913ddfd44ac1fd3
(drm/radeon: use gart memory for DMA ring tests)
to the IB tests.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/cik_sdma.c | 21 ++++++++++++---------
 drivers/gpu/drm/radeon/r600_dma.c | 20 ++++++++++----------
 2 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik_sdma.c b/drivers/gpu/drm/radeon/cik_sdma.c
index f54d45bad01d..fc9177194c7c 100644
--- a/drivers/gpu/drm/radeon/cik_sdma.c
+++ b/drivers/gpu/drm/radeon/cik_sdma.c
@@ -636,17 +636,20 @@ int cik_sdma_ib_test(struct radeon_device *rdev, struct radeon_ring *ring)
 {
 	struct radeon_ib ib;
 	unsigned i;
+	unsigned index;
 	int r;
-	void __iomem *ptr = (void *)rdev->vram_scratch.ptr;
 	u32 tmp = 0;
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
 
 	r = radeon_ib_get(rdev, ring->idx, &ib, NULL, 256);
 	if (r) {
@@ -655,8 +658,8 @@ int cik_sdma_ib_test(struct radeon_device *rdev, struct radeon_ring *ring)
 	}
 
 	ib.ptr[0] = SDMA_PACKET(SDMA_OPCODE_WRITE, SDMA_WRITE_SUB_OPCODE_LINEAR, 0);
-	ib.ptr[1] = rdev->vram_scratch.gpu_addr & 0xfffffffc;
-	ib.ptr[2] = upper_32_bits(rdev->vram_scratch.gpu_addr);
+	ib.ptr[1] = lower_32_bits(gpu_addr);
+	ib.ptr[2] = upper_32_bits(gpu_addr);
 	ib.ptr[3] = 1;
 	ib.ptr[4] = 0xDEADBEEF;
 	ib.length_dw = 5;
@@ -673,7 +676,7 @@ int cik_sdma_ib_test(struct radeon_device *rdev, struct radeon_ring *ring)
 		return r;
 	}
 	for (i = 0; i < rdev->usec_timeout; i++) {
-		tmp = readl(ptr);
+		tmp = le32_to_cpu(rdev->wb.wb[index/4]);
 		if (tmp == 0xDEADBEEF)
 			break;
 		DRM_UDELAY(1);
diff --git a/drivers/gpu/drm/radeon/r600_dma.c b/drivers/gpu/drm/radeon/r600_dma.c
index 964c32031059..f1c584f21419 100644
--- a/drivers/gpu/drm/radeon/r600_dma.c
+++ b/drivers/gpu/drm/radeon/r600_dma.c
@@ -338,17 +338,17 @@ int r600_dma_ib_test(struct radeon_device *rdev, struct radeon_ring *ring)
 {
 	struct radeon_ib ib;
 	unsigned i;
+	unsigned index;
 	int r;
-	void __iomem *ptr = (void *)rdev->vram_scratch.ptr;
 	u32 tmp = 0;
+	u64 gpu_addr;
 
-	if (!ptr) {
-		DRM_ERROR("invalid vram scratch pointer\n");
-		return -EINVAL;
-	}
+	if (ring->idx == R600_RING_TYPE_DMA_INDEX)
+		index = R600_WB_DMA_RING_TEST_OFFSET;
+	else
+		index = CAYMAN_WB_DMA1_RING_TEST_OFFSET;
 
-	tmp = 0xCAFEDEAD;
-	writel(tmp, ptr);
+	gpu_addr = rdev->wb.gpu_addr + index;
 
 	r = radeon_ib_get(rdev, ring->idx, &ib, NULL, 256);
 	if (r) {
@@ -357,8 +357,8 @@ int r600_dma_ib_test(struct radeon_device *rdev, struct radeon_ring *ring)
 	}
 
 	ib.ptr[0] = DMA_PACKET(DMA_PACKET_WRITE, 0, 0, 1);
-	ib.ptr[1] = rdev->vram_scratch.gpu_addr & 0xfffffffc;
-	ib.ptr[2] = upper_32_bits(rdev->vram_scratch.gpu_addr) & 0xff;
+	ib.ptr[1] = lower_32_bits(gpu_addr);
+	ib.ptr[2] = upper_32_bits(gpu_addr) & 0xff;
 	ib.ptr[3] = 0xDEADBEEF;
 	ib.length_dw = 4;
 
@@ -374,7 +374,7 @@ int r600_dma_ib_test(struct radeon_device *rdev, struct radeon_ring *ring)
 		return r;
 	}
 	for (i = 0; i < rdev->usec_timeout; i++) {
-		tmp = readl(ptr);
+		tmp = le32_to_cpu(rdev->wb.wb[index/4]);
 		if (tmp == 0xDEADBEEF)
 			break;
 		DRM_UDELAY(1);
-- 
2.1.0

