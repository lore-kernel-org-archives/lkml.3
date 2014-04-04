Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbaDDD3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 23:29:46 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:49692
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030AbaDDD2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 23:28:07 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zze0eahzz1f42h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch21a7h1fc6h208chzdchz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26d3h1155h)
From: <hongbo.zhang@freescale.com>
To: <vkoul@infradead.org>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>
CC: <scottwood@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>,
        Hongbo Zhang <hongbo.zhang@freescale.com>
Subject: [PATCH v2 4/8] DMA: Freescale: add fsl_dma_free_descriptor() to reduce code duplication
Date: Fri, 4 Apr 2014 11:27:13 +0800
Message-ID: <1396582037-23065-5-git-send-email-hongbo.zhang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396582037-23065-1-git-send-email-hongbo.zhang@freescale.com>
References: <1396582037-23065-1-git-send-email-hongbo.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hongbo Zhang <hongbo.zhang@freescale.com>

There are several places where descriptors are freed using identical code.
This patch puts this code into a function to reduce code duplication.

Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
---
 drivers/dma/fsldma.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index b71cc04..b5a0ffa 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -418,6 +418,19 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 }
 
 /**
+ * fsl_dma_free_descriptor - Free descriptor from channel's DMA pool.
+ * @chan : Freescale DMA channel
+ * @desc: descriptor to be freed
+ */
+static void fsl_dma_free_descriptor(struct fsldma_chan *chan,
+		struct fsl_desc_sw *desc)
+{
+	list_del(&desc->node);
+	chan_dbg(chan, "LD %p free\n", desc);
+	dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
+}
+
+/**
  * fsl_dma_alloc_descriptor - Allocate descriptor from channel's DMA pool.
  * @chan : Freescale DMA channel
  *
@@ -489,11 +502,8 @@ static void fsldma_free_desc_list(struct fsldma_chan *chan,
 {
 	struct fsl_desc_sw *desc, *_desc;
 
-	list_for_each_entry_safe(desc, _desc, list, node) {
-		list_del(&desc->node);
-		chan_dbg(chan, "LD %p free\n", desc);
-		dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
-	}
+	list_for_each_entry_safe(desc, _desc, list, node)
+		fsl_dma_free_descriptor(chan, desc);
 }
 
 static void fsldma_free_desc_list_reverse(struct fsldma_chan *chan,
@@ -501,11 +511,8 @@ static void fsldma_free_desc_list_reverse(struct fsldma_chan *chan,
 {
 	struct fsl_desc_sw *desc, *_desc;
 
-	list_for_each_entry_safe_reverse(desc, _desc, list, node) {
-		list_del(&desc->node);
-		chan_dbg(chan, "LD %p free\n", desc);
-		dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
-	}
+	list_for_each_entry_safe_reverse(desc, _desc, list, node)
+		fsl_dma_free_descriptor(chan, desc);
 }
 
 /**
@@ -819,8 +826,7 @@ static void fsldma_cleanup_descriptor(struct fsldma_chan *chan,
 	dma_run_dependencies(txd);
 
 	dma_descriptor_unmap(txd);
-	chan_dbg(chan, "LD %p free\n", desc);
-	dma_pool_free(chan->desc_pool, desc, txd->phys);
+	fsl_dma_free_descriptor(chan, desc);
 }
 
 /**
-- 
1.7.9.5



