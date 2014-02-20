Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbaBTXxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:53:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46154 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190AbaBTXxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:53:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Tom Stellard <thomas.stellard@amd.com>
Subject: [PATCH 3.13 43/99] drm/radeon/cik: use POLL_REG_MEM special op for sDMA HDP flush
Date: Thu, 20 Feb 2014 15:52:38 -0800
Message-Id: <20140220235119.464894895@linuxfoundation.org>
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

commit da9e07e6f53eaac4e838bc8c987d87c5769be724 upstream.

This is the preferred flushing method on CIK.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Tom Stellard <thomas.stellard@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/cik_sdma.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/radeon/cik_sdma.c
+++ b/drivers/gpu/drm/radeon/cik_sdma.c
@@ -99,13 +99,21 @@ static void cik_sdma_hdp_flush_ring_emit
 					 int ridx)
 {
 	struct radeon_ring *ring = &rdev->ring[ridx];
+	u32 extra_bits = (SDMA_POLL_REG_MEM_EXTRA_OP(1) |
+			  SDMA_POLL_REG_MEM_EXTRA_FUNC(3)); /* == */
+	u32 ref_and_mask;
 
-	/* We should be using the new POLL_REG_MEM special op packet here
-	 * but it causes sDMA to hang sometimes
-	 */
-	radeon_ring_write(ring, SDMA_PACKET(SDMA_OPCODE_SRBM_WRITE, 0, 0xf000));
-	radeon_ring_write(ring, HDP_MEM_COHERENCY_FLUSH_CNTL >> 2);
-	radeon_ring_write(ring, 0);
+	if (ridx == R600_RING_TYPE_DMA_INDEX)
+		ref_and_mask = SDMA0;
+	else
+		ref_and_mask = SDMA1;
+
+	radeon_ring_write(ring, SDMA_PACKET(SDMA_OPCODE_POLL_REG_MEM, 0, extra_bits));
+	radeon_ring_write(ring, GPU_HDP_FLUSH_DONE);
+	radeon_ring_write(ring, GPU_HDP_FLUSH_REQ);
+	radeon_ring_write(ring, ref_and_mask); /* reference */
+	radeon_ring_write(ring, ref_and_mask); /* mask */
+	radeon_ring_write(ring, (0xfff << 16) | 10); /* retry count, poll interval */
 }
 
 /**


