Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747Ab3KMHpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 02:45:08 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:49009 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757893Ab3KMHpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 02:45:01 -0500
Date: Wed, 13 Nov 2013 10:44:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] dmaengine: edma: double free on error in edma_prep_slave_sg()
Message-ID: <20131113074446.GC25541@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We accidentally applied two correct but duplicative fixes for a memory
leak here:
4b6271a64463 ('dma: edma: Fix memory leak')
2f6d8fad0a16 ('dma: edma.c: remove edma_desc leakage')

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index ea4abaa..9c8103d 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -420,7 +420,6 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 				edma_alloc_slot(EDMA_CTLR(echan->ch_num),
 						EDMA_SLOT_ANY);
 			if (echan->slot[i] < 0) {
-				kfree(edesc);
 				dev_err(dev, "Failed to allocate slot\n");
 				kfree(edesc);
 				return NULL;
