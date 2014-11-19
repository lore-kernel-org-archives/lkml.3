Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576AbaKSWY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:24:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469AbaKSUyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.17 067/141] drm/radeon: use gart for DMA IB tests
Date: Wed, 19 Nov 2014 12:51:30 -0800
Message-Id: <20141119205152.860043550@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 0b021c5802fbe5addf6f89f5030f684adf04f7b7 upstream.

Use gart rather than vram to avoid having to deal with
the HDP cache.

Port of adfed2b0587289013f8143c54913ddfd44ac1fd3
(drm/radeon: use gart memory for DMA ring tests)
to the IB tests.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/cik_sdma.c |   21 ++++++++++++---------
 drivers/gpu/drm/radeon/r600_dma.c |   20 ++++++++++----------
 2 files changed, 22 insertions(+), 19 deletions(-)

--- a/drivers/gpu/drm/radeon/cik_sdma.c
+++ b/drivers/gpu/drm/radeon/cik_sdma.c
@@ -666,17 +666,20 @@ int cik_sdma_ib_test(struct radeon_devic
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
@@ -685,8 +688,8 @@ int cik_sdma_ib_test(struct radeon_devic
 	}
 
 	ib.ptr[0] = SDMA_PACKET(SDMA_OPCODE_WRITE, SDMA_WRITE_SUB_OPCODE_LINEAR, 0);
-	ib.ptr[1] = rdev->vram_scratch.gpu_addr & 0xfffffffc;
-	ib.ptr[2] = upper_32_bits(rdev->vram_scratch.gpu_addr);
+	ib.ptr[1] = lower_32_bits(gpu_addr);
+	ib.ptr[2] = upper_32_bits(gpu_addr);
 	ib.ptr[3] = 1;
 	ib.ptr[4] = 0xDEADBEEF;
 	ib.length_dw = 5;
@@ -703,7 +706,7 @@ int cik_sdma_ib_test(struct radeon_devic
 		return r;
 	}
 	for (i = 0; i < rdev->usec_timeout; i++) {
-		tmp = readl(ptr);
+		tmp = le32_to_cpu(rdev->wb.wb[index/4]);
 		if (tmp == 0xDEADBEEF)
 			break;
 		DRM_UDELAY(1);
--- a/drivers/gpu/drm/radeon/r600_dma.c
+++ b/drivers/gpu/drm/radeon/r600_dma.c
@@ -338,17 +338,17 @@ int r600_dma_ib_test(struct radeon_devic
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
@@ -357,8 +357,8 @@ int r600_dma_ib_test(struct radeon_devic
 	}
 
 	ib.ptr[0] = DMA_PACKET(DMA_PACKET_WRITE, 0, 0, 1);
-	ib.ptr[1] = rdev->vram_scratch.gpu_addr & 0xfffffffc;
-	ib.ptr[2] = upper_32_bits(rdev->vram_scratch.gpu_addr) & 0xff;
+	ib.ptr[1] = lower_32_bits(gpu_addr);
+	ib.ptr[2] = upper_32_bits(gpu_addr) & 0xff;
 	ib.ptr[3] = 0xDEADBEEF;
 	ib.length_dw = 4;
 
@@ -374,7 +374,7 @@ int r600_dma_ib_test(struct radeon_devic
 		return r;
 	}
 	for (i = 0; i < rdev->usec_timeout; i++) {
-		tmp = readl(ptr);
+		tmp = le32_to_cpu(rdev->wb.wb[index/4]);
 		if (tmp == 0xDEADBEEF)
 			break;
 		DRM_UDELAY(1);


