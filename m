Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbaJCWQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:16:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758052AbaJCWQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:16:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Petallo, MauriceX R" <mauricex.r.petallo@intel.com>
Subject: [PATCH 3.14 231/238] dmaengine: dw: dont perform DMA when dmaengine_submit is called
Date: Fri,  3 Oct 2014 14:32:26 -0700
Message-Id: <20141003212921.051229006@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit dd8ecfcac66b4485416b2d1df0ec4798b198d7d6 upstream.

Accordingly to discussion [1] and followed up documentation the DMA controller
driver shouldn't start any DMA operations when dmaengine_submit() is called.

This patch fixes the workflow in dw_dmac driver to follow the documentation.

[1] http://www.spinics.net/lists/arm-kernel/msg125987.html

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Cc: "Petallo, MauriceX R" <mauricex.r.petallo@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/TODO      |    1 -
 drivers/dma/dw/core.c |   19 +++++++------------
 2 files changed, 7 insertions(+), 13 deletions(-)

--- a/drivers/dma/TODO
+++ b/drivers/dma/TODO
@@ -7,7 +7,6 @@ TODO for slave dma
 	- imx-dma
 	- imx-sdma
 	- mxs-dma.c
-	- dw_dmac
 	- intel_mid_dma
 4. Check other subsystems for dma drivers and merge/move to dmaengine
 5. Remove dma_slave_config's dma direction.
--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -680,17 +680,9 @@ static dma_cookie_t dwc_tx_submit(struct
 	 * possible, perhaps even appending to those already submitted
 	 * for DMA. But this is hard to do in a race-free manner.
 	 */
-	if (list_empty(&dwc->active_list)) {
-		dev_vdbg(chan2dev(tx->chan), "%s: started %u\n", __func__,
-				desc->txd.cookie);
-		list_add_tail(&desc->desc_node, &dwc->active_list);
-		dwc_dostart(dwc, dwc_first_active(dwc));
-	} else {
-		dev_vdbg(chan2dev(tx->chan), "%s: queued %u\n", __func__,
-				desc->txd.cookie);
 
-		list_add_tail(&desc->desc_node, &dwc->queue);
-	}
+	dev_vdbg(chan2dev(tx->chan), "%s: queued %u\n", __func__, desc->txd.cookie);
+	list_add_tail(&desc->desc_node, &dwc->queue);
 
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
@@ -1095,9 +1087,12 @@ dwc_tx_status(struct dma_chan *chan,
 static void dwc_issue_pending(struct dma_chan *chan)
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
+	unsigned long		flags;
 
-	if (!list_empty(&dwc->queue))
-		dwc_scan_descriptors(to_dw_dma(chan->device), dwc);
+	spin_lock_irqsave(&dwc->lock, flags);
+	if (list_empty(&dwc->active_list))
+		dwc_dostart_first_queued(dwc);
+	spin_unlock_irqrestore(&dwc->lock, flags);
 }
 
 static int dwc_alloc_chan_resources(struct dma_chan *chan)


