Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933420AbaE2Gkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:40:33 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59846 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756066AbaE2Gk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:40:28 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, <tony@atomide.com>, <jg1.han@samsung.com>,
        <kishon@ti.com>, Dan Murphy <dmurphy@ti.com>
Subject: [TEMP PATCH v2 17/18] PCI: host: pcie-dra7xx: use reset framework APIs to reset PCIe
Date: Thu, 29 May 2014 12:08:19 +0530
Message-ID: <1401345500-20188-18-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401345500-20188-1-git-send-email-kishon@ti.com>
References: <1401345500-20188-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get reset nodes from dt and use reset framework APIs to reset PCIe.
This is needed since reset is handled by the SoC.

Cc: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 Documentation/devicetree/bindings/pci/ti-pci.txt |    4 ++++
 drivers/pci/host/pci-dra7xx.c                    |   10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/pci/ti-pci.txt b/Documentation/devicetree/bindings/pci/ti-pci.txt
index d07d2eb..3649c2e 100644
--- a/Documentation/devicetree/bindings/pci/ti-pci.txt
+++ b/Documentation/devicetree/bindings/pci/ti-pci.txt
@@ -22,6 +22,8 @@ PCIe Designware Controller
    num-lanes,
    interrupt-map-mask,
    interrupt-map : as specified in ../designware-pcie.txt
+ - resets: phandle used if reset is handled be soc
+ - reset-names: name given to the phandle
 
 Example:
 axi {
@@ -45,6 +47,8 @@ axi {
 		ti,hwmods = "pcie1";
 		phys = <&pcie1_phy>;
 		phy-names = "pcie-phy0";
+		resets = <&prm_resets &device_reset>;
+		reset-names = "reset";
 		interrupt-map-mask = <0 0 0 7>;
 		interrupt-map = <0 0 0 1 &pcie_intc 1>,
 				<0 0 0 2 &pcie_intc 2>,
diff --git a/drivers/pci/host/pci-dra7xx.c b/drivers/pci/host/pci-dra7xx.c
index 8fb3a2e..17f5e6a 100644
--- a/drivers/pci/host/pci-dra7xx.c
+++ b/drivers/pci/host/pci-dra7xx.c
@@ -22,6 +22,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/resource.h>
+#include <linux/reset.h>
 #include <linux/types.h>
 
 #include "pcie-designware.h"
@@ -332,6 +333,7 @@ static int __init dra7xx_pcie_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct device_node *np = dev->of_node;
 	char name[10];
+	struct reset_control *rstc;
 
 	dra7xx = devm_kzalloc(dev, sizeof(*dra7xx), GFP_KERNEL);
 	if (!dra7xx)
@@ -355,6 +357,14 @@ static int __init dra7xx_pcie_probe(struct platform_device *pdev)
 	if (!base)
 		return -ENOMEM;
 
+	rstc = devm_reset_control_get(dev, "reset");
+	if (IS_ERR(rstc))
+		return PTR_ERR(rstc);
+
+	ret = reset_control_deassert(rstc);
+	if (ret)
+		return ret;
+
 	phy_count = of_property_count_strings(np, "phy-names");
 	if (phy_count < 0) {
 		dev_err(dev, "unable to find the strings\n");
-- 
1.7.9.5

