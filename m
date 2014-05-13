Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964800AbaEMKcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:32:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55654 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933899AbaEMKbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:31:14 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <joelf@ti.com>
CC: <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>
Subject: [PATCH v2 2/5] ARM: edma: Get IP information from HW when booting with DT
Date: Tue, 13 May 2014 13:30:29 +0300
Message-ID: <1399977032-26469-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1399977032-26469-1-git-send-email-peter.ujfalusi@ti.com>
References: <1399977032-26469-1-git-send-email-peter.ujfalusi@ti.com>
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

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/common/edma.c | 128 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 79 insertions(+), 49 deletions(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index fade9ada81f8..1a98f3cd4cd9 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -102,7 +102,16 @@
 #define PARM_OFFSET(param_no)	(EDMA_PARM + ((param_no) << 5))
 
 #define EDMA_DCHMAP	0x0100  /* 64 registers */
-#define CHMAP_EXIST	BIT(24)
+
+/* CCCFG register */
+#define GET_NUM_DMACH(x)	(x & 0x7) /* bits 0-2 */
+#define GET_NUM_QDMACH(x)	((x & 0x70) >> 4) /* bits 4-6 */
+#define GET_NUM_INTCH(x)	((x & 0x700) >> 8) /* bits 8-10 */
+#define GET_NUM_PAENTRY(x)	((x & 0x7000) >> 12) /* bits 12-14 */
+#define GET_NUM_EVQUE(x)	((x & 0x70000) >> 16) /* bits 16-18 */
+#define GET_NUM_REGN(x)		((x & 0x300000) >> 20) /* bits 20-21 */
+#define CHMAP_EXIST		BIT(24)
+#define MP_EXIST		BIT(25)
 
 #define EDMA_MAX_DMACH           64
 #define EDMA_MAX_PARAMENTRY     512
@@ -1415,6 +1424,68 @@ void edma_clear_event(unsigned channel)
 }
 EXPORT_SYMBOL(edma_clear_event);
 
+static int edma_setup_info_from_hw(struct device *dev,
+				   struct edma_soc_info *pdata)
+{
+	int i;
+	u32 value, cccfg, n_tc;
+	s8 (*queue_tc_map)[2], (*queue_priority_map)[2];
+
+	/* Decode the eDMA3 configuration from CCCFG register */
+	cccfg = edma_read(0, EDMA_CCCFG);
+
+	value = GET_NUM_DMACH(cccfg);
+	pdata->n_channel = BIT(value + 1);
+
+	value = GET_NUM_REGN(cccfg);
+	pdata->n_region = BIT(value);
+
+	value = GET_NUM_PAENTRY(cccfg);
+	pdata->n_slot = BIT(value + 4);
+
+	value = GET_NUM_EVQUE(cccfg);
+	n_tc = value + 1;
+
+	dev_dbg(dev, "eDMA3 HW configuration (cccfg: 0x%08x):\n", cccfg);
+	dev_dbg(dev, "n_channel: %u\n", pdata->n_channel);
+	dev_dbg(dev, "n_region: %u\n", pdata->n_region);
+	dev_dbg(dev, "n_slot: %u\n", pdata->n_slot);
+	dev_dbg(dev, "n_tc: %u\n", n_tc);
+
+	pdata->n_cc = 1;
+
+	queue_tc_map = devm_kzalloc(dev, (n_tc + 1) * sizeof(s8), GFP_KERNEL);
+	if (!queue_tc_map)
+		return -ENOMEM;
+
+	for (i = 0; i < n_tc; i++) {
+		queue_tc_map[i][0] = i;
+		queue_tc_map[i][1] = i;
+	}
+	queue_tc_map[i][0] = -1;
+	queue_tc_map[i][1] = -1;
+
+	pdata->queue_tc_mapping = queue_tc_map;
+
+	queue_priority_map = devm_kzalloc(dev, (n_tc + 1) * sizeof(s8),
+					  GFP_KERNEL);
+	if (!queue_priority_map)
+		return -ENOMEM;
+
+	for (i = 0; i < n_tc; i++) {
+		queue_priority_map[i][0] = i;
+		queue_priority_map[i][1] = i;
+	}
+	queue_priority_map[i][0] = -1;
+	queue_priority_map[i][1] = -1;
+
+	pdata->queue_priority_mapping = queue_priority_map;
+
+	pdata->default_queue = 0;
+
+	return 0;
+}
+
 #if IS_ENABLED(CONFIG_OF) && IS_ENABLED(CONFIG_DMADEVICES)
 
 static int edma_of_read_u32_to_s16_array(const struct device_node *np,
@@ -1483,63 +1554,16 @@ static int edma_of_parse_dt(struct device *dev,
 			    struct device_node *node,
 			    struct edma_soc_info *pdata)
 {
-	int ret = 0, i;
-	u32 value;
+	int ret = 0;
 	struct property *prop;
 	size_t sz;
 	struct edma_rsv_info *rsv_info;
-	s8 (*queue_tc_map)[2], (*queue_priority_map)[2];
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
-	pdata->n_cc = 1;
 
 	rsv_info = devm_kzalloc(dev, sizeof(struct edma_rsv_info), GFP_KERNEL);
 	if (!rsv_info)
 		return -ENOMEM;
 	pdata->rsv = rsv_info;
 
-	queue_tc_map = devm_kzalloc(dev, 8*sizeof(s8), GFP_KERNEL);
-	if (!queue_tc_map)
-		return -ENOMEM;
-
-	for (i = 0; i < 3; i++) {
-		queue_tc_map[i][0] = i;
-		queue_tc_map[i][1] = i;
-	}
-	queue_tc_map[i][0] = -1;
-	queue_tc_map[i][1] = -1;
-
-	pdata->queue_tc_mapping = queue_tc_map;
-
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
@@ -1655,6 +1679,12 @@ static int edma_probe(struct platform_device *pdev)
 		if (IS_ERR(edmacc_regs_base[j]))
 			return PTR_ERR(edmacc_regs_base[j]);
 
+		if (node) {
+			/* Get eDMA3 configuration from IP */
+			ret = edma_setup_info_from_hw(dev, info[j]);
+			if (ret)
+				return ret;
+		}
 		edma_cc[j] = devm_kzalloc(&pdev->dev, sizeof(struct edma),
 					  GFP_KERNEL);
 		if (!edma_cc[j])
-- 
1.9.3

