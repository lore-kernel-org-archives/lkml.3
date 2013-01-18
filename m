Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290Ab3ARHq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 02:46:28 -0500
Received: from norkia.v3.sk ([91.210.183.14]:56972 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010Ab3ARHq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 02:46:27 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH 1/3] dma: mv_xor: do not sync the DMA buffer after being deallocated
Date: Fri, 18 Jan 2013 08:46:20 +0100
Message-Id: <1358495182-30964-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1358495154.28503.5.camel@unicorn>
References: <1358495154.28503.5.camel@unicorn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA_CHECK was unhappy:
mv_xor mv_xor.0: DMA-API: device driver tries to sync DMA memory it has not allocated [device address=0x000000001f3a1a40] [size=2000 bytes]

Deallocation, which involves a sync, happens automatically by
mv_xor_slot_cleanup() once the transfer is finished.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/dma/mv_xor.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index e666983..8b81a04 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -960,8 +960,6 @@ static int mv_xor_memcpy_self_test(struct mv_xor_chan *mv_chan)
 		goto free_resources;
 	}
 
-	dma_sync_single_for_cpu(dma_chan->device->dev, dest_dma,
-				MV_XOR_TEST_SIZE, DMA_FROM_DEVICE);
 	if (memcmp(src, dest, MV_XOR_TEST_SIZE)) {
 		dev_err(dma_chan->device->dev,
 			"Self-test copy failed compare, disabling\n");
@@ -1054,8 +1052,6 @@ mv_xor_xor_self_test(struct mv_xor_chan *mv_chan)
 		goto free_resources;
 	}
 
-	dma_sync_single_for_cpu(dma_chan->device->dev, dest_dma,
-				PAGE_SIZE, DMA_FROM_DEVICE);
 	for (i = 0; i < (PAGE_SIZE / sizeof(u32)); i++) {
 		u32 *ptr = page_address(dest);
 		if (ptr[i] != cmp_word) {
-- 
1.7.1

