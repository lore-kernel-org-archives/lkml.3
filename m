Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbaAPFuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 00:50:24 -0500
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:58936
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751297AbaAPFsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 00:48:07 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21a7h1fc6hzdchz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h2487h1155h)
From: <hongbo.zhang@freescale.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>
CC: <scottwood@freescale.com>, <LeoLi@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Hongbo Zhang <hongbo.zhang@freescale.com>
Subject: [PATCH 2/7] DMA: Freescale: remove attribute DMA_INTERRUPT of dmaengine
Date: Thu, 16 Jan 2014 13:47:21 +0800
Message-ID: <1389851246-8564-3-git-send-email-hongbo.zhang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389851246-8564-1-git-send-email-hongbo.zhang@freescale.com>
References: <1389851246-8564-1-git-send-email-hongbo.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hongbo Zhang <hongbo.zhang@freescale.com>

Delete attribute DMA_INTERRUPT because fsldma doesn't support this function,
exception will be thrown if talitos is used to offload xor at the same time.

Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
---
 drivers/dma/fsldma.c |   31 -------------------------------
 1 file changed, 31 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index fbf19d3..95236e6 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -534,35 +534,6 @@ static void fsl_dma_free_chan_resources(struct dma_chan *dchan)
 }
 
 static struct dma_async_tx_descriptor *
-fsl_dma_prep_interrupt(struct dma_chan *dchan, unsigned long flags)
-{
-	struct fsldma_chan *chan;
-	struct fsl_desc_sw *new;
-
-	if (!dchan)
-		return NULL;
-
-	chan = to_fsl_chan(dchan);
-
-	new = fsl_dma_alloc_descriptor(chan);
-	if (!new) {
-		chan_err(chan, "%s\n", msg_ld_oom);
-		return NULL;
-	}
-
-	new->async_tx.cookie = -EBUSY;
-	new->async_tx.flags = flags;
-
-	/* Insert the link descriptor to the LD ring */
-	list_add_tail(&new->node, &new->tx_list);
-
-	/* Set End-of-link to the last link descriptor of new list */
-	set_ld_eol(chan, new);
-
-	return &new->async_tx;
-}
-
-static struct dma_async_tx_descriptor *
 fsl_dma_prep_memcpy(struct dma_chan *dchan,
 	dma_addr_t dma_dst, dma_addr_t dma_src,
 	size_t len, unsigned long flags)
@@ -1318,12 +1289,10 @@ static int fsldma_of_probe(struct platform_device *op)
 	fdev->irq = irq_of_parse_and_map(op->dev.of_node, 0);
 
 	dma_cap_set(DMA_MEMCPY, fdev->common.cap_mask);
-	dma_cap_set(DMA_INTERRUPT, fdev->common.cap_mask);
 	dma_cap_set(DMA_SG, fdev->common.cap_mask);
 	dma_cap_set(DMA_SLAVE, fdev->common.cap_mask);
 	fdev->common.device_alloc_chan_resources = fsl_dma_alloc_chan_resources;
 	fdev->common.device_free_chan_resources = fsl_dma_free_chan_resources;
-	fdev->common.device_prep_dma_interrupt = fsl_dma_prep_interrupt;
 	fdev->common.device_prep_dma_memcpy = fsl_dma_prep_memcpy;
 	fdev->common.device_prep_dma_sg = fsl_dma_prep_sg;
 	fdev->common.device_tx_status = fsl_tx_status;
-- 
1.7.9.5



