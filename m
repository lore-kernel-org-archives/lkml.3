Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554AbaEPMVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:21:53 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50204 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757162AbaEPMSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:18:06 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <joelf@ti.com>, <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>
Subject: [PATCH v3 03/13] ARM: edma: Do not change TC -> Queue mapping, leave it to default.
Date: Fri, 16 May 2014 15:17:10 +0300
Message-ID: <1400242640-9902-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1400242640-9902-1-git-send-email-peter.ujfalusi@ti.com>
References: <1400242640-9902-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to change the default TC -> Queue mapping. By default the
mapping is: TC0 -> Q0, TC1 -> Q1, etc.
Changing this has no benefits at all and all the board files are just setting
the same mapping back to the HW.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/common/edma.c | 28 +---------------------------
 1 file changed, 1 insertion(+), 27 deletions(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index d42c84a3432a..0bc5ed6fc249 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -290,12 +290,6 @@ static void map_dmach_queue(unsigned ctlr, unsigned ch_no,
 			~(0x7 << bit), queue_no << bit);
 }
 
-static void __init map_queue_tc(unsigned ctlr, int queue_no, int tc_no)
-{
-	int bit = queue_no * 4;
-	edma_modify(ctlr, EDMA_QUETCMAP, ~(0x7 << bit), ((tc_no & 0x7) << bit));
-}
-
 static void __init assign_priority_to_queue(unsigned ctlr, int queue_no,
 		int priority)
 {
@@ -1470,7 +1464,7 @@ static int edma_of_parse_dt(struct device *dev,
 	struct property *prop;
 	size_t sz;
 	struct edma_rsv_info *rsv_info;
-	s8 (*queue_tc_map)[2], (*queue_priority_map)[2];
+	s8 (*queue_priority_map)[2];
 
 	ret = of_property_read_u32(node, "dma-channels", &value);
 	if (ret < 0)
@@ -1495,19 +1489,6 @@ static int edma_of_parse_dt(struct device *dev,
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
 	queue_priority_map = devm_kzalloc(dev, 8*sizeof(s8), GFP_KERNEL);
 	if (!queue_priority_map)
 		return -ENOMEM;
@@ -1568,7 +1549,6 @@ static int edma_probe(struct platform_device *pdev)
 	struct edma_soc_info	**info = pdev->dev.platform_data;
 	struct edma_soc_info    *ninfo[EDMA_MAX_CC] = {NULL};
 	s8		(*queue_priority_mapping)[2];
-	s8		(*queue_tc_mapping)[2];
 	int			i, j, off, ln, found = 0;
 	int			status = -1;
 	const s16		(*rsv_chans)[2];
@@ -1735,14 +1715,8 @@ static int edma_probe(struct platform_device *pdev)
 		for (i = 0; i < edma_cc[j]->num_channels; i++)
 			map_dmach_queue(j, i, info[j]->default_queue);
 
-		queue_tc_mapping = info[j]->queue_tc_mapping;
 		queue_priority_mapping = info[j]->queue_priority_mapping;
 
-		/* Event queue to TC mapping */
-		for (i = 0; queue_tc_mapping[i][0] != -1; i++)
-			map_queue_tc(j, queue_tc_mapping[i][0],
-					queue_tc_mapping[i][1]);
-
 		/* Event queue priority mapping */
 		for (i = 0; queue_priority_mapping[i][0] != -1; i++)
 			assign_priority_to_queue(j,
-- 
1.9.3

