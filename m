Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbaBTX7B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:59:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123AbaBTXyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:54:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Tom Stellard <thomas.stellard@amd.com>
Subject: [PATCH 3.13 42/99] drm/radeon: consolidate sdma hdp flushing code for CIK
Date: Thu, 20 Feb 2014 15:52:37 -0800
Message-Id: <20140220235119.436777687@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235118.191692546@linuxfoundation.org>
References: <20140220235118.191692546@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit ca113f6baeb314a66463c35565b4f7955c484000 upstream.

It's used in several places so move to a common shared
function.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Tom Stellard <thomas.stellard@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/cik_sdma.c |   35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/radeon/cik_sdma.c
+++ b/drivers/gpu/drm/radeon/cik_sdma.c
@@ -88,6 +88,27 @@ void cik_sdma_ring_ib_execute(struct rad
 }
 
 /**
+ * cik_sdma_hdp_flush_ring_emit - emit an hdp flush on the DMA ring
+ *
+ * @rdev: radeon_device pointer
+ * @ridx: radeon ring index
+ *
+ * Emit an hdp flush packet on the requested DMA ring.
+ */
+static void cik_sdma_hdp_flush_ring_emit(struct radeon_device *rdev,
+					 int ridx)
+{
+	struct radeon_ring *ring = &rdev->ring[ridx];
+
+	/* We should be using the new POLL_REG_MEM special op packet here
+	 * but it causes sDMA to hang sometimes
+	 */
+	radeon_ring_write(ring, SDMA_PACKET(SDMA_OPCODE_SRBM_WRITE, 0, 0xf000));
+	radeon_ring_write(ring, HDP_MEM_COHERENCY_FLUSH_CNTL >> 2);
+	radeon_ring_write(ring, 0);
+}
+
+/**
  * cik_sdma_fence_ring_emit - emit a fence on the DMA ring
  *
  * @rdev: radeon_device pointer
@@ -111,12 +132,7 @@ void cik_sdma_fence_ring_emit(struct rad
 	/* generate an interrupt */
 	radeon_ring_write(ring, SDMA_PACKET(SDMA_OPCODE_TRAP, 0, 0));
 	/* flush HDP */
-	/* We should be using the new POLL_REG_MEM special op packet here
-	 * but it causes sDMA to hang sometimes
-	 */
-	radeon_ring_write(ring, SDMA_PACKET(SDMA_OPCODE_SRBM_WRITE, 0, 0xf000));
-	radeon_ring_write(ring, HDP_MEM_COHERENCY_FLUSH_CNTL >> 2);
-	radeon_ring_write(ring, 0);
+	cik_sdma_hdp_flush_ring_emit(rdev, fence->ring);
 }
 
 /**
@@ -747,12 +763,7 @@ void cik_dma_vm_flush(struct radeon_devi
 	radeon_ring_write(ring, VMID(0));
 
 	/* flush HDP */
-	/* We should be using the new POLL_REG_MEM special op packet here
-	 * but it causes sDMA to hang sometimes
-	 */
-	radeon_ring_write(ring, SDMA_PACKET(SDMA_OPCODE_SRBM_WRITE, 0, 0xf000));
-	radeon_ring_write(ring, HDP_MEM_COHERENCY_FLUSH_CNTL >> 2);
-	radeon_ring_write(ring, 0);
+	cik_sdma_hdp_flush_ring_emit(rdev, ridx);
 
 	/* flush TLB */
 	radeon_ring_write(ring, SDMA_PACKET(SDMA_OPCODE_SRBM_WRITE, 0, 0xf000));


