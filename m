Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256AbaEPMSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:18:25 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50228 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038AbaEPMSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:18:20 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <joelf@ti.com>, <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>
Subject: [PATCH v3 08/13] ARM: edma: Get IP configuration from HW (number of channels, tc, etc)
Date: Fri, 16 May 2014 15:17:15 +0300
Message-ID: <1400242640-9902-9-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1400242640-9902-1-git-send-email-peter.ujfalusi@ti.com>
References: <1400242640-9902-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From CCCFG register of eDMA3 we can get all the needed information for the
driver about the IP:
Number of channels: NUM_DMACH
Number of regions: NUM_REGN
Number of slots (PaRAM sets): NUM_PAENTRY
Number of TC/EQ: NUM_EVQUE

In case when booted with DT or the queue_priority_mapping is not provided
set up a default priority map.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/common/edma.c | 115 +++++++++++++++++++++++++++++++------------------
 1 file changed, 73 insertions(+), 42 deletions(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index aa9473cb0c23..485be42519b9 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -102,7 +102,13 @@
 #define PARM_OFFSET(param_no)	(EDMA_PARM + ((param_no) << 5))
 
 #define EDMA_DCHMAP	0x0100  /* 64 registers */
-#define CHMAP_EXIST	BIT(24)
+
+/* CCCFG register */
+#define GET_NUM_DMACH(x)	(x & 0x7) /* bits 0-2 */
+#define GET_NUM_PAENTRY(x)	((x & 0x7000) >> 12) /* bits 12-14 */
+#define GET_NUM_EVQUE(x)	((x & 0x70000) >> 16) /* bits 16-18 */
+#define GET_NUM_REGN(x)		((x & 0x300000) >> 20) /* bits 20-21 */
+#define CHMAP_EXIST		BIT(24)
 
 #define EDMA_MAX_DMACH           64
 #define EDMA_MAX_PARAMENTRY     512
@@ -1408,6 +1414,67 @@ void edma_clear_event(unsigned channel)
 }
 EXPORT_SYMBOL(edma_clear_event);
 
+static int edma_setup_from_hw(struct device *dev, struct edma_soc_info *pdata,
+			      struct edma *edma_cc)
+{
+	int i;
+	u32 value, cccfg;
+	s8 (*queue_priority_map)[2];
+
+	/* Decode the eDMA3 configuration from CCCFG register */
+	cccfg = edma_read(0, EDMA_CCCFG);
+
+	value = GET_NUM_REGN(cccfg);
+	edma_cc->num_region = BIT(value);
+
+	value = GET_NUM_DMACH(cccfg);
+	edma_cc->num_channels = BIT(value + 1);
+
+	value = GET_NUM_PAENTRY(cccfg);
+	edma_cc->num_slots = BIT(value + 4);
+
+	value = GET_NUM_EVQUE(cccfg);
+	edma_cc->num_tc = value + 1;
+
+	dev_dbg(dev, "eDMA3 HW configuration (cccfg: 0x%08x):\n", cccfg);
+	dev_dbg(dev, "num_region: %u\n", edma_cc->num_region);
+	dev_dbg(dev, "num_channel: %u\n", edma_cc->num_channels);
+	dev_dbg(dev, "num_slot: %u\n", edma_cc->num_slots);
+	dev_dbg(dev, "num_tc: %u\n", edma_cc->num_tc);
+
+	/* Nothing need to be done if queue priority is provided */
+	if (pdata->queue_priority_mapping)
+		return 0;
+
+	/*
+	 * Configure TC/queue priority as follows:
+	 * Q0 - priority 0
+	 * Q1 - priority 1
+	 * Q2 - priority 2
+	 * ...
+	 * The meaning of priority numbers: 0 highest priority, 7 lowest
+	 * priority. So Q0 is the highest priority queue and the last queue has
+	 * the lowest priority.
+	 */
+	queue_priority_map = devm_kzalloc(dev,
+					  (edma_cc->num_tc + 1) * sizeof(s8),
+					  GFP_KERNEL);
+	if (!queue_priority_map)
+		return -ENOMEM;
+
+	for (i = 0; i < edma_cc->num_tc; i++) {
+		queue_priority_map[i][0] = i;
+		queue_priority_map[i][1] = i;
+	}
+	queue_priority_map[i][0] = -1;
+	queue_priority_map[i][1] = -1;
+
+	pdata->queue_priority_mapping = queue_priority_map;
+	pdata->default_queue = 0;
+
+	return 0;
+}
+
 #if IS_ENABLED(CONFIG_OF) && IS_ENABLED(CONFIG_DMADEVICES)
 
 static int edma_xbar_event_map(struct device *dev, struct device_node *node,
@@ -1458,50 +1525,16 @@ static int edma_of_parse_dt(struct device *dev,
 			    struct device_node *node,
 			    struct edma_soc_info *pdata)
 {
-	int ret = 0, i;
-	u32 value;
+	int ret = 0;
 	struct property *prop;
 	size_t sz;
 	struct edma_rsv_info *rsv_info;
-	s8 (*queue_priority_map)[2];
-
-	ret = of_property_read_u32(node, "dma-channels", &value);
-	if (ret < 0)
-		return ret;
-	pdata->n_channel = value;
-
-	ret = of_property_read_u32(node, "ti,edma-regions", &value);
-	if (ret < 0)
-		return ret;
-	pdata->n_region = value;
-
-	ret = of_property_read_u32(node, "ti,edma-slots", &value);
-	if (ret < 0)
-		return ret;
-	pdata->n_slot = value;
-
-	pdata->n_tc = 3;
 
 	rsv_info = devm_kzalloc(dev, sizeof(struct edma_rsv_info), GFP_KERNEL);
 	if (!rsv_info)
 		return -ENOMEM;
 	pdata->rsv = rsv_info;
 
-	queue_priority_map = devm_kzalloc(dev, 8*sizeof(s8), GFP_KERNEL);
-	if (!queue_priority_map)
-		return -ENOMEM;
-
-	for (i = 0; i < 3; i++) {
-		queue_priority_map[i][0] = i;
-		queue_priority_map[i][1] = i;
-	}
-	queue_priority_map[i][0] = -1;
-	queue_priority_map[i][1] = -1;
-
-	pdata->queue_priority_mapping = queue_priority_map;
-
-	pdata->default_queue = 0;
-
 	prop = of_find_property(node, "ti,edma-xbar-event-map", &sz);
 	if (prop)
 		ret = edma_xbar_event_map(dev, node, pdata, sz);
@@ -1621,14 +1654,12 @@ static int edma_probe(struct platform_device *pdev)
 		if (!edma_cc[j])
 			return -ENOMEM;
 
-		edma_cc[j]->num_channels = min_t(unsigned, info[j]->n_channel,
-							EDMA_MAX_DMACH);
-		edma_cc[j]->num_slots = min_t(unsigned, info[j]->n_slot,
-							EDMA_MAX_PARAMENTRY);
-		edma_cc[j]->num_tc = info[j]->n_tc;
+		/* Get eDMA3 configuration from IP */
+		ret = edma_setup_from_hw(dev, info[j], edma_cc[j]);
+		if (ret)
+			return ret;
 
 		edma_cc[j]->default_queue = info[j]->default_queue;
-		edma_cc[j]->num_region = info[j]->n_region;
 
 		dev_dbg(&pdev->dev, "DMA REG BASE ADDR=%p\n",
 			edmacc_regs_base[j]);
-- 
1.9.3

