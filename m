Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697AbaEMH0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:26:44 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36161 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbaEMH0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:26:42 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <joelf@ti.com>
CC: <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH] ARM: edma: Clean up and simplify the code around irq request
Date: Tue, 13 May 2014 10:26:01 +0300
Message-ID: <1399965961-23739-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get the two interrupt line number at the same time by merging the two
instance of if(node){}else{} places.
replace the &pdev->dev with the already existing dev which makes it possible
to collapse lines with devm_request_irq()

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/common/edma.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index db2d9dc62d33..fade9ada81f8 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -1596,7 +1596,6 @@ static int edma_probe(struct platform_device *pdev)
 	struct resource		*r[EDMA_MAX_CC] = {NULL};
 	struct resource		res[EDMA_MAX_CC];
 	char			res_name[10];
-	char			irq_name[10];
 	struct device_node	*node = pdev->dev.of_node;
 	struct device		*dev = &pdev->dev;
 	int			ret;
@@ -1718,14 +1717,21 @@ static int edma_probe(struct platform_device *pdev)
 
 		if (node) {
 			irq[j] = irq_of_parse_and_map(node, 0);
+			err_irq[j] = irq_of_parse_and_map(node, 2);
 		} else {
+			char irq_name[10];
+
 			sprintf(irq_name, "edma%d", j);
 			irq[j] = platform_get_irq_byname(pdev, irq_name);
+
+			sprintf(irq_name, "edma%d_err", j);
+			err_irq[j] = platform_get_irq_byname(pdev, irq_name);
 		}
 		edma_cc[j]->irq_res_start = irq[j];
-		status = devm_request_irq(&pdev->dev, irq[j],
-					  dma_irq_handler, 0, "edma",
-					  &pdev->dev);
+		edma_cc[j]->irq_res_end = err_irq[j];
+
+		status = devm_request_irq(dev, irq[j], dma_irq_handler, 0,
+					  "edma", dev);
 		if (status < 0) {
 			dev_dbg(&pdev->dev,
 				"devm_request_irq %d failed --> %d\n",
@@ -1733,16 +1739,8 @@ static int edma_probe(struct platform_device *pdev)
 			return status;
 		}
 
-		if (node) {
-			err_irq[j] = irq_of_parse_and_map(node, 2);
-		} else {
-			sprintf(irq_name, "edma%d_err", j);
-			err_irq[j] = platform_get_irq_byname(pdev, irq_name);
-		}
-		edma_cc[j]->irq_res_end = err_irq[j];
-		status = devm_request_irq(&pdev->dev, err_irq[j],
-					  dma_ccerr_handler, 0,
-					  "edma_error", &pdev->dev);
+		status = devm_request_irq(dev, err_irq[j], dma_ccerr_handler, 0,
+					  "edma_error", dev);
 		if (status < 0) {
 			dev_dbg(&pdev->dev,
 				"devm_request_irq %d failed --> %d\n",
-- 
1.9.3

