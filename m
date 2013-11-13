Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345Ab3KMGaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 01:30:17 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:55400 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758223Ab3KMGaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 01:30:09 -0500
From: Olof Johansson <olof@lixom.net>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH 1/2] dmaengine: ipu: fix warnings from 64-bit dma_addr_t printouts
Date: Tue, 12 Nov 2013 22:30:43 -0800
Message-Id: <1384324244-11330-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This resolves a number of warnings such as the below when building with
64-bit dma_addr_t on arm:

drivers/dma/ipu/ipu_idmac.c:1235:2: warning: format '%x' expects argument
  of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=]

..by upcasting to u64 and using %llx.

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/dma/ipu/ipu_idmac.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index cb9c0bc..128ca14 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1232,8 +1232,10 @@ static irqreturn_t idmac_interrupt(int irq, void *dev_id)
 	desc = list_entry(ichan->queue.next, struct idmac_tx_desc, list);
 	descnew = desc;
 
-	dev_dbg(dev, "IDMAC irq %d, dma 0x%08x, next dma 0x%08x, current %d, curbuf 0x%08x\n",
-		irq, sg_dma_address(*sg), sgnext ? sg_dma_address(sgnext) : 0, ichan->active_buffer, curbuf);
+	dev_dbg(dev, "IDMAC irq %d, dma %#llx, next dma %#llx, current %d, curbuf %#x\n",
+		irq, (u64)sg_dma_address(*sg),
+		sgnext ? (u64)sg_dma_address(sgnext) : 0,
+		ichan->active_buffer, curbuf);
 
 	/* Find the descriptor of sgnext */
 	sgnew = idmac_sg_next(ichan, &descnew, *sg);
-- 
1.7.10.4

