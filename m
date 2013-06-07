Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab3FGO6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 10:58:15 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:24277 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab3FGO6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 10:58:12 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [PATCH v2 2/2] at_hdmac: add FIFO configuration parameter to DMA DT binding
Date: Fri, 7 Jun 2013 16:57:05 +0200
Message-ID: <962983ea5510b1574466599fa1e8d857f33b1429.1370615665.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1370615665.git.nicolas.ferre@atmel.com>
References: <cover.1370615665.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ludovic Desroches <ludovic.desroches@atmel.com>

For most devices the FIFO configuration is the same i.e. when half FIFO size is
available/filled, a source/destination request is serviced. But USART devices
have to do it when there is enough space/data available to perform a single
AHB access so the ASAP configuration.

Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
---
 .../devicetree/bindings/dma/atmel-dma.txt          |  7 ++++--
 drivers/dma/at_hdmac.c                             | 25 ++++++++++++++++++----
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/dma/atmel-dma.txt b/Documentation/devicetree/bindings/dma/atmel-dma.txt
index c80e8a3..c280a0e 100644
--- a/Documentation/devicetree/bindings/dma/atmel-dma.txt
+++ b/Documentation/devicetree/bindings/dma/atmel-dma.txt
@@ -24,8 +24,11 @@ The three cells in order are:
 1. A phandle pointing to the DMA controller.
 2. The memory interface (16 most significant bits), the peripheral interface
 (16 less significant bits).
-3. The peripheral identifier for the hardware handshaking interface. The
-identifier can be different for tx and rx.
+3. Parameters for the at91 DMA configuration register which are device
+dependant:
+  - bit 7-0: peripheral identifier for the hardware handshaking interface. The
+  identifier can be different for tx and rx.
+  - bit 11-8: FIFO configuration. 0 for half FIFO, 1 for ALAP, 1 for ASAP.
 
 Example:
 
diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 6db5228..4499dcf 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -14,6 +14,7 @@
  * found on AT91SAM9263.
  */
 
+#include <dt-bindings/dma/at91.h>
 #include <linux/clk.h>
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
@@ -1320,15 +1321,31 @@ static struct dma_chan *at_dma_xlate(struct of_phandle_args *dma_spec,
 	atslave = devm_kzalloc(&dmac_pdev->dev, sizeof(*atslave), GFP_KERNEL);
 	if (!atslave)
 		return NULL;
+
+	atslave->cfg = ATC_DST_H2SEL_HW | ATC_SRC_H2SEL_HW;
 	/*
 	 * We can fill both SRC_PER and DST_PER, one of these fields will be
 	 * ignored depending on DMA transfer direction.
 	 */
-	per_id = dma_spec->args[1];
-	atslave->cfg = ATC_FIFOCFG_HALFFIFO
-		     | ATC_DST_H2SEL_HW | ATC_SRC_H2SEL_HW
-		     | ATC_DST_PER_MSB(per_id) | ATC_DST_PER(per_id)
+	per_id = dma_spec->args[1] & AT91_DMA_CFG_PER_ID_MASK;
+	atslave->cfg |= ATC_DST_PER_MSB(per_id) | ATC_DST_PER(per_id)
 		     | ATC_SRC_PER_MSB(per_id) | ATC_SRC_PER(per_id);
+	/*
+	 * We have to translate the value we get from the device tree since
+	 * the half FIFO configuration value had to be 0 to keep backward
+	 * compatibility.
+	 */
+	switch(dma_spec->args[1] & AT91_DMA_CFG_FIFOCFG_MASK) {
+		case AT91_DMA_CFG_FIFOCFG_ALAP:
+			atslave->cfg |= ATC_FIFOCFG_LARGESTBURST;
+			break;
+		case AT91_DMA_CFG_FIFOCFG_ASAP:
+			atslave->cfg |= ATC_FIFOCFG_ENOUGHSPACE;
+			break;
+		case AT91_DMA_CFG_FIFOCFG_HALF:
+		default:
+			atslave->cfg |= ATC_FIFOCFG_HALFFIFO;
+	}
 	atslave->dma_dev = &dmac_pdev->dev;
 
 	chan = dma_request_channel(mask, at_dma_filter, atslave);
-- 
1.8.2.2

