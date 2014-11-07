Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaKGSkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:40:36 -0500
Received: from queue01c.mail.zen.net.uk ([212.23.3.237]:36324 "EHLO
	queue01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbaKGSkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:40:15 -0500
From: Jon Medhurst <tixy@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/2] dma: pl330: Align DMA memcpy operations to MFIFO width
Date: Fri,  7 Nov 2014 18:05:17 +0000
Message-Id: <1415383518-29327-2-git-send-email-tixy@linaro.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415383518-29327-1-git-send-email-tixy@linaro.org>
References: <1415383518-29327-1-git-send-email-tixy@linaro.org>
X-Originating-smarthost01a-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The algorithm used for programming the DMA Controller doesn't take into
consideration the requirements of transfers that are not aligned to the
bus width. This failure may result in DMA transferring one too few MFIFO
entries (so too few bytes are copied) or the DMA trying to write one too
many MFIFO entries and hanging because this is never provided.

See "MFIFO Usage Overview" chapter in the the TRM for "CoreLink DMA
Controller DMA-330", Revision r1p1.

We work around these shortcomings by making sure we pick a burst size
and length which ensures no bursts straddle an MFIFO entry.

Signed-off-by: Jon Medhurst <tixy@linaro.org>
---
 drivers/dma/pl330.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 4839bfa..8f869ec 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2459,8 +2459,13 @@ pl330_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dst,
 	/* Select max possible burst size */
 	burst = pl330->pcfg.data_bus_width / 8;
 
+	/*
+	 * Make sure we use a burst size that aligns with all the memcpy
+	 * parameters because our DMA programming algorithm doesn't cope with
+	 * transfers which straddle an entry in the DMA device's MFIFO.
+	 */
 	while (burst > 1) {
-		if (!(len % burst))
+		if (!((src | dst | len) % burst))
 			break;
 		burst /= 2;
 	}
@@ -2469,6 +2474,13 @@ pl330_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dst,
 	while (burst != (1 << desc->rqcfg.brst_size))
 		desc->rqcfg.brst_size++;
 
+	/*
+	 * If burst size is smaller than bus width then make sure we only
+	 * transfer one at a time to avoid a burst stradling an MFIFO entry.
+	 */
+	if (desc->rqcfg.brst_size * 8 < pl330->pcfg.data_bus_width)
+		desc->rqcfg.brst_len = 1;
+
 	desc->rqcfg.brst_len = get_burst_len(desc, len);
 
 	desc->txd.flags = flags;
-- 
2.1.1

