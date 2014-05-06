Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbaEFNhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:37:38 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58984 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757715AbaEFNfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:35:50 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-pci@vger.kernel.org>
CC: <rogerq@ti.com>, <balajitk@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Dan Murphy <dmurphy@ti.com>
Subject: [TEMP PATCH 16/17] pci: host: pcie-dra7xx: use reset framework APIs to reset PCIe
Date: Tue, 6 May 2014 19:04:02 +0530
Message-ID: <1399383244-14556-17-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399383244-14556-1-git-send-email-kishon@ti.com>
References: <1399383244-14556-1-git-send-email-kishon@ti.com>
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
 Documentation/devicetree/bindings/pci/ti-pci.txt |    2 ++
 drivers/pci/host/pci-dra7xx.c                    |   10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/Documentation/devicetree/bindings/pci/ti-pci.txt b/Documentation/devicetree/bindings/pci/ti-pci.txt
index 6cb6f09..cfb95c0 100644
--- a/Documentation/devicetree/bindings/pci/ti-pci.txt
+++ b/Documentation/devicetree/bindings/pci/ti-pci.txt
@@ -9,6 +9,8 @@ This node should have the properties described in "designware-pcie.txt".
  - phys : the phandle for the PHY device (used by generic PHY framework)
  - phy-names : the names of the PHY corresponding to the PHYs present in the
    *phy* phandle.
+ - resets: phandle used if reset is handled be soc
+ - reset-names: name given to the phandle
 
 Example:
 pcie@51000000 {
diff --git a/drivers/pci/host/pci-dra7xx.c b/drivers/pci/host/pci-dra7xx.c
index a37c25c..17d64ee 100644
--- a/drivers/pci/host/pci-dra7xx.c
+++ b/drivers/pci/host/pci-dra7xx.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/resource.h>
+#include <linux/reset.h>
 #include <linux/types.h>
 
 #include "pcie-designware.h"
@@ -281,6 +282,7 @@ static int __init dra7xx_pcie_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct dra7xx_pcie *dra7xx;
 	struct device *dev = &pdev->dev;
+	struct reset_control *rstc;
 
 	dra7xx = devm_kzalloc(&pdev->dev, sizeof(*dra7xx), GFP_KERNEL);
 	if (!dra7xx)
@@ -304,6 +306,14 @@ static int __init dra7xx_pcie_probe(struct platform_device *pdev)
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
 	phy = devm_phy_get(dev, "pcie-phy");
 	if (IS_ERR(phy))
 		return PTR_ERR(phy);
-- 
1.7.9.5

