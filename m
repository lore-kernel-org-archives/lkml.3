Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaBUEZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 23:25:04 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50353 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbaBUEZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 23:25:01 -0500
From: Joel Fernandes <joelf@ti.com>
To: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: <nsekhar@ti.com>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH] ARM: EDMA: Use platform_get_resource functions for DT
Date: Thu, 20 Feb 2014 22:24:21 -0600
Message-ID: <1392956661-28787-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, EDMA driver uses of_address_to_resource for getting Channel
controller and x-bar register resources. Use platform_get_resource_by_name
instead regardless of whether its DT-boot or not, document the new reg-names
properties.

Also, while at it get rid of the assumption in the code that "CC" is at reg
index 0 in the DT and xbar is at offset 1. Instead use reg-names to get the
memory resource in concern keeping things much cleaner and simpler. This also
makes it possible to have multiple channel controllers.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 Documentation/devicetree/bindings/dma/ti-edma.txt |    7 ++++++
 arch/arm/boot/dts/am33xx.dtsi                     |    1 +
 arch/arm/boot/dts/am4372.dtsi                     |    1 +
 arch/arm/common/edma.c                            |   28 ++++++++++-----------
 4 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/Documentation/devicetree/bindings/dma/ti-edma.txt b/Documentation/devicetree/bindings/dma/ti-edma.txt
index 9fbbdb7..176e42b 100644
--- a/Documentation/devicetree/bindings/dma/ti-edma.txt
+++ b/Documentation/devicetree/bindings/dma/ti-edma.txt
@@ -8,6 +8,12 @@ Required properties:
               Clients should use a single channel number per DMA request.
 - dma-channels: Specify total DMA channels per CC
 - reg: Memory map for accessing module
+- reg-names: Since there can be different memory regions, each reg
+  entry should correspond to one of the following reg-names (X being 0 to N):
+	edma_ccX: memory map for Xth Channel Controller
+	edma_tcX: memory map for Xth Transfer Controller
+	Additionally there can be a memory map for xbar (in control module):
+		edma_xbar: memory map for xbar access.
 - interrupt-parent: Interrupt controller the interrupt is routed through
 - interrupts: Exactly 3 interrupts need to be specified in the order:
               1. Transfer completion interrupt.
@@ -21,6 +27,7 @@ Example:
 
 edma: edma@49000000 {
 	reg = <0x49000000 0x10000>;
+	reg-names = "edma_cc0";
 	interrupt-parent = <&intc>;
 	interrupts = <12 13 14>;
 	compatible = "ti,edma3";
diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 2b66e67..55f5723 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -123,6 +123,7 @@
 			ti,hwmods = "tpcc", "tptc0", "tptc1", "tptc2";
 			reg =	<0x49000000 0x10000>,
 				<0x44e10f90 0x10>;
+			reg-names = "edma_cc0", "edma_xbar";
 			interrupts = <12 13 14>;
 			#dma-cells = <1>;
 			dma-channels = <64>;
diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index babdc84..1323a97 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -100,6 +100,7 @@
 			ti,hwmods = "tpcc", "tptc0", "tptc1", "tptc2";
 			reg =	<0x49000000 0x10000>,
 				<0x44e10f90 0x10>;
+			reg-names = "edma_cc0", "edma_xbar";
 			interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
 					<GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>,
 					<GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index dc95efc..ae0ccae 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -1458,10 +1458,11 @@ static int edma_xbar_event_map(struct device *dev,
 			       struct edma_soc_info *pdata, int len)
 {
 	int ret, i;
-	struct resource res;
+	struct resource *res;
 	void __iomem *xbar;
 	const s16 (*xbar_chans)[2];
 	u32 shift, offset, mux;
+	struct platform_device *pdev;
 
 	xbar_chans = devm_kzalloc(dev,
 				  len/sizeof(s16) + 2*sizeof(s16),
@@ -1469,11 +1470,14 @@ static int edma_xbar_event_map(struct device *dev,
 	if (!xbar_chans)
 		return -ENOMEM;
 
-	ret = of_address_to_resource(node, 1, &res);
-	if (ret)
+	pdev = to_platform_device(dev);
+	res = platform_get_resource_byname(pdev,
+					   IORESOURCE_MEM,
+					   "edma_xbar");
+	if (!res)
 		return -EIO;
 
-	xbar = devm_ioremap(dev, res.start, resource_size(&res));
+	xbar = devm_ioremap(dev, res->start, resource_size(res));
 	if (!xbar)
 		return -ENOMEM;
 
@@ -1614,7 +1618,6 @@ static int edma_probe(struct platform_device *pdev)
 	int			irq[EDMA_MAX_CC] = {0, 0};
 	int			err_irq[EDMA_MAX_CC] = {0, 0};
 	struct resource		*r[EDMA_MAX_CC] = {NULL};
-	struct resource		res[EDMA_MAX_CC];
 	char			res_name[10];
 	char			irq_name[10];
 	struct device_node	*node = pdev->dev.of_node;
@@ -1653,16 +1656,11 @@ static int edma_probe(struct platform_device *pdev)
 				return -ENODEV;
 			break;
 		}
-		if (node) {
-			ret = of_address_to_resource(node, j, &res[j]);
-			if (!ret)
-				r[j] = &res[j];
-		} else {
-			sprintf(res_name, "edma_cc%d", j);
-			r[j] = platform_get_resource_byname(pdev,
-						IORESOURCE_MEM,
-						res_name);
-		}
+
+		sprintf(res_name, "edma_cc%d", j);
+		r[j] = platform_get_resource_byname(pdev,
+					IORESOURCE_MEM,
+					res_name);
 		if (!r[j]) {
 			if (found)
 				break;
-- 
1.7.9.5

