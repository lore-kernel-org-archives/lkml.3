Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaDDD2D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 23:28:03 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:12257 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030AbaDDD17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 23:27:59 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zze0eahzz1f42h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch21a7h1fc6h208chzdchz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26d3h1155h)
From: <hongbo.zhang@freescale.com>
To: <vkoul@infradead.org>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>
CC: <scottwood@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>,
        Hongbo Zhang <hongbo.zhang@freescale.com>
Subject: [PATCH v2 2/8] DMA: Freescale: unify register access methods
Date: Fri, 4 Apr 2014 11:27:11 +0800
Message-ID: <1396582037-23065-3-git-send-email-hongbo.zhang@freescale.com>
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

Methods of accessing DMA contorller registers are inconsistent, some registers
are accessed by DMA_IN/OUT directly, while others are accessed by functions
get/set_* which are wrappers of DMA_IN/OUT, and even for the BCR register, it
is read by get_bcr but written by DMA_OUT.
This patch unifies the inconsistent methods, all registers are accessed by
get/set_* now.

Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
---
 drivers/dma/fsldma.c |   52 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 19 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index ec50420..5f32cb8 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -61,6 +61,16 @@ static u32 get_sr(struct fsldma_chan *chan)
 	return DMA_IN(chan, &chan->regs->sr, 32);
 }
 
+static void set_mr(struct fsldma_chan *chan, u32 val)
+{
+	DMA_OUT(chan, &chan->regs->mr, val, 32);
+}
+
+static u32 get_mr(struct fsldma_chan *chan)
+{
+	return DMA_IN(chan, &chan->regs->mr, 32);
+}
+
 static void set_cdar(struct fsldma_chan *chan, dma_addr_t addr)
 {
 	DMA_OUT(chan, &chan->regs->cdar, addr | FSL_DMA_SNEN, 64);
@@ -71,6 +81,11 @@ static dma_addr_t get_cdar(struct fsldma_chan *chan)
 	return DMA_IN(chan, &chan->regs->cdar, 64) & ~FSL_DMA_SNEN;
 }
 
+static void set_bcr(struct fsldma_chan *chan, u32 val)
+{
+	DMA_OUT(chan, &chan->regs->bcr, val, 32);
+}
+
 static u32 get_bcr(struct fsldma_chan *chan)
 {
 	return DMA_IN(chan, &chan->regs->bcr, 32);
@@ -135,7 +150,7 @@ static void set_ld_eol(struct fsldma_chan *chan, struct fsl_desc_sw *desc)
 static void dma_init(struct fsldma_chan *chan)
 {
 	/* Reset the channel */
-	DMA_OUT(chan, &chan->regs->mr, 0, 32);
+	set_mr(chan, 0);
 
 	switch (chan->feature & FSL_DMA_IP_MASK) {
 	case FSL_DMA_IP_85XX:
@@ -144,16 +159,15 @@ static void dma_init(struct fsldma_chan *chan)
 		 * EOLNIE - End of links interrupt enable
 		 * BWC - Bandwidth sharing among channels
 		 */
-		DMA_OUT(chan, &chan->regs->mr, FSL_DMA_MR_BWC
-				| FSL_DMA_MR_EIE | FSL_DMA_MR_EOLNIE, 32);
+		set_mr(chan, FSL_DMA_MR_BWC | FSL_DMA_MR_EIE
+			| FSL_DMA_MR_EOLNIE);
 		break;
 	case FSL_DMA_IP_83XX:
 		/* Set the channel to below modes:
 		 * EOTIE - End-of-transfer interrupt enable
 		 * PRC_RM - PCI read multiple
 		 */
-		DMA_OUT(chan, &chan->regs->mr, FSL_DMA_MR_EOTIE
-				| FSL_DMA_MR_PRC_RM, 32);
+		set_mr(chan, FSL_DMA_MR_EOTIE | FSL_DMA_MR_PRC_RM);
 		break;
 	}
 }
@@ -175,10 +189,10 @@ static void dma_start(struct fsldma_chan *chan)
 {
 	u32 mode;
 
-	mode = DMA_IN(chan, &chan->regs->mr, 32);
+	mode = get_mr(chan);
 
 	if (chan->feature & FSL_DMA_CHAN_PAUSE_EXT) {
-		DMA_OUT(chan, &chan->regs->bcr, 0, 32);
+		set_bcr(chan, 0);
 		mode |= FSL_DMA_MR_EMP_EN;
 	} else {
 		mode &= ~FSL_DMA_MR_EMP_EN;
@@ -191,7 +205,7 @@ static void dma_start(struct fsldma_chan *chan)
 		mode |= FSL_DMA_MR_CS;
 	}
 
-	DMA_OUT(chan, &chan->regs->mr, mode, 32);
+	set_mr(chan, mode);
 }
 
 static void dma_halt(struct fsldma_chan *chan)
@@ -200,7 +214,7 @@ static void dma_halt(struct fsldma_chan *chan)
 	int i;
 
 	/* read the mode register */
-	mode = DMA_IN(chan, &chan->regs->mr, 32);
+	mode = get_mr(chan);
 
 	/*
 	 * The 85xx controller supports channel abort, which will stop
@@ -209,14 +223,14 @@ static void dma_halt(struct fsldma_chan *chan)
 	 */
 	if ((chan->feature & FSL_DMA_IP_MASK) == FSL_DMA_IP_85XX) {
 		mode |= FSL_DMA_MR_CA;
-		DMA_OUT(chan, &chan->regs->mr, mode, 32);
+		set_mr(chan, mode);
 
 		mode &= ~FSL_DMA_MR_CA;
 	}
 
 	/* stop the DMA controller */
 	mode &= ~(FSL_DMA_MR_CS | FSL_DMA_MR_EMS_EN);
-	DMA_OUT(chan, &chan->regs->mr, mode, 32);
+	set_mr(chan, mode);
 
 	/* wait for the DMA controller to become idle */
 	for (i = 0; i < 100; i++) {
@@ -245,7 +259,7 @@ static void fsl_chan_set_src_loop_size(struct fsldma_chan *chan, int size)
 {
 	u32 mode;
 
-	mode = DMA_IN(chan, &chan->regs->mr, 32);
+	mode = get_mr(chan);
 
 	switch (size) {
 	case 0:
@@ -259,7 +273,7 @@ static void fsl_chan_set_src_loop_size(struct fsldma_chan *chan, int size)
 		break;
 	}
 
-	DMA_OUT(chan, &chan->regs->mr, mode, 32);
+	set_mr(chan, mode);
 }
 
 /**
@@ -277,7 +291,7 @@ static void fsl_chan_set_dst_loop_size(struct fsldma_chan *chan, int size)
 {
 	u32 mode;
 
-	mode = DMA_IN(chan, &chan->regs->mr, 32);
+	mode = get_mr(chan);
 
 	switch (size) {
 	case 0:
@@ -291,7 +305,7 @@ static void fsl_chan_set_dst_loop_size(struct fsldma_chan *chan, int size)
 		break;
 	}
 
-	DMA_OUT(chan, &chan->regs->mr, mode, 32);
+	set_mr(chan, mode);
 }
 
 /**
@@ -312,10 +326,10 @@ static void fsl_chan_set_request_count(struct fsldma_chan *chan, int size)
 
 	BUG_ON(size > 1024);
 
-	mode = DMA_IN(chan, &chan->regs->mr, 32);
+	mode = get_mr(chan);
 	mode |= (__ilog2(size) << 24) & 0x0f000000;
 
-	DMA_OUT(chan, &chan->regs->mr, mode, 32);
+	set_mr(chan, mode);
 }
 
 /**
@@ -889,9 +903,9 @@ static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan)
 	if ((chan->feature & FSL_DMA_IP_MASK) == FSL_DMA_IP_85XX) {
 		u32 mode;
 
-		mode = DMA_IN(chan, &chan->regs->mr, 32);
+		mode = get_mr(chan);
 		mode &= ~FSL_DMA_MR_CS;
-		DMA_OUT(chan, &chan->regs->mr, mode, 32);
+		set_mr(chan, mode);
 	}
 
 	/*
-- 
1.7.9.5



