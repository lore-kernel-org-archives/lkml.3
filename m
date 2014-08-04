Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbaHDM1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 08:27:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60944 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbaHDM1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 08:27:36 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <joelf@ti.com>
CC: <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
Subject: [PATCH] ARM: edma: Fix configuration parsing for SoCs with multiple eDMA3 CC
Date: Mon, 4 Aug 2014 15:26:56 +0300
Message-ID: <1407155216-20267-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The edma_setup_from_hw() should know about the CC number when parsing the
CCCFG register - when it reads the register to be precise. The base
addresses for CCs stored in an array and we need to provide the correct id
to edma_read() in order to read the correct register.

Cc: <stable@vger.kernel.org> # 3.16
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/common/edma.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index 88099175fc56..d86771abbf57 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -1443,14 +1443,14 @@ void edma_assign_channel_eventq(unsigned channel, enum dma_event_q eventq_no)
 EXPORT_SYMBOL(edma_assign_channel_eventq);
 
 static int edma_setup_from_hw(struct device *dev, struct edma_soc_info *pdata,
-			      struct edma *edma_cc)
+			      struct edma *edma_cc, int cc_id)
 {
 	int i;
 	u32 value, cccfg;
 	s8 (*queue_priority_map)[2];
 
 	/* Decode the eDMA3 configuration from CCCFG register */
-	cccfg = edma_read(0, EDMA_CCCFG);
+	cccfg = edma_read(cc_id, EDMA_CCCFG);
 
 	value = GET_NUM_REGN(cccfg);
 	edma_cc->num_region = BIT(value);
@@ -1464,7 +1464,8 @@ static int edma_setup_from_hw(struct device *dev, struct edma_soc_info *pdata,
 	value = GET_NUM_EVQUE(cccfg);
 	edma_cc->num_tc = value + 1;
 
-	dev_dbg(dev, "eDMA3 HW configuration (cccfg: 0x%08x):\n", cccfg);
+	dev_dbg(dev, "eDMA3 CC%d HW configuration (cccfg: 0x%08x):\n", cc_id,
+		cccfg);
 	dev_dbg(dev, "num_region: %u\n", edma_cc->num_region);
 	dev_dbg(dev, "num_channel: %u\n", edma_cc->num_channels);
 	dev_dbg(dev, "num_slot: %u\n", edma_cc->num_slots);
@@ -1684,7 +1685,7 @@ static int edma_probe(struct platform_device *pdev)
 			return -ENOMEM;
 
 		/* Get eDMA3 configuration from IP */
-		ret = edma_setup_from_hw(dev, info[j], edma_cc[j]);
+		ret = edma_setup_from_hw(dev, info[j], edma_cc[j], j);
 		if (ret)
 			return ret;
 
-- 
2.0.2

