Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab3CFTzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 14:55:44 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:42227 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab3CFTzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 14:55:42 -0500
From: Matt Porter <mporter@ti.com>
To: Vinod Koul <vinod.koul@intel.com>, Chris Ball <cjb@laptop.org>
Cc: Dan Williams <djbw@fb.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: [PATCH v4 2/3] dma: edma: add device_slave_sg_limits() support
Date: Wed,  6 Mar 2013 14:56:06 -0500
Message-Id: <1362599767-11292-3-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362599767-11292-1-git-send-email-mporter@ti.com>
References: <1362599767-11292-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement device_slave_sg_limits().

EDMA has a finite set of PaRAM slots available for linking a
multi-segment SG transfer. In order to prevent any one channel
from consuming all PaRAM slots to fulfill a large SG transfer,
the driver reports a static per-channel max number of SG segments
it will handle.

The maximum size of an SG segment is limited by the addr_width
and maxburst of a given transfer request. These values are
provided by the client driver and used to calculate and return
the maximum segment length.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 drivers/dma/edma.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index cd7e328..42373bf 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -70,6 +70,7 @@ struct edma_chan {
 	bool				alloced;
 	int				slot[EDMA_MAX_SLOTS];
 	struct dma_slave_config		cfg;
+	struct dma_slave_sg_limits	sg_limits;
 };
 
 struct edma_cc {
@@ -462,6 +463,20 @@ static void edma_issue_pending(struct dma_chan *chan)
 	spin_unlock_irqrestore(&echan->vchan.lock, flags);
 }
 
+static struct dma_slave_sg_limits
+*edma_get_slave_sg_limits(struct dma_chan *chan,
+			enum dma_slave_buswidth addr_width,
+			u32 maxburst)
+{
+	struct edma_chan *echan;
+
+	echan = to_edma_chan(chan);
+	echan->sg_limits.max_seg_len =
+		(SZ_64K - 1) * addr_width * maxburst;
+
+	return &echan->sg_limits;
+}
+
 static size_t edma_desc_size(struct edma_desc *edesc)
 {
 	int i;
@@ -521,6 +536,7 @@ static void __init edma_chan_init(struct edma_cc *ecc,
 		echan->ch_num = EDMA_CTLR_CHAN(ecc->ctlr, i);
 		echan->ecc = ecc;
 		echan->vchan.desc_free = edma_desc_free;
+		echan->sg_limits.max_seg_nr = MAX_NR_SG;
 
 		vchan_init(&echan->vchan, dma);
 
@@ -537,6 +553,7 @@ static void edma_dma_init(struct edma_cc *ecc, struct dma_device *dma,
 	dma->device_alloc_chan_resources = edma_alloc_chan_resources;
 	dma->device_free_chan_resources = edma_free_chan_resources;
 	dma->device_issue_pending = edma_issue_pending;
+	dma->device_slave_sg_limits = edma_get_slave_sg_limits;
 	dma->device_tx_status = edma_tx_status;
 	dma->device_control = edma_control;
 	dma->dev = dev;
-- 
1.7.9.5

