Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917AbaDIKb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 06:31:28 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:19687 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690AbaDIKbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 06:31:25 -0400
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Tejun Heo <tj@kernel.org>
CC: Hans de Goede <hdegoede@redhat.com>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
        <guohanjun@huawei.com>
Subject: [PATCH 2/2] ahci: add support for Hisilicon sata
Date: Wed, 9 Apr 2014 18:30:19 +0800
Message-ID: <1397039419-9716-2-git-send-email-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 1.8.3.msysgit.0
In-Reply-To: <1397039419-9716-1-git-send-email-wangkefeng.wang@huawei.com>
References: <1397039419-9716-1-git-send-email-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.21.224]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kefeng Wang <kefeng.wang@linaro.org>

The hip04 SoC of hisilicon has an AHCI compliant SATA controller,
and it is compliant with the ahci 1.3 and sata 3.0 specification.

There is a wrong bit in HOST_CAP of hip04 sata controller, which
enable unsupported feature of FBS, use AHCI_HFLAG_NO_FBS hflag to
disable it.

Signed-off-by: Kefeng Wang <kefeng.wang@linaro.org>
---
 .../devicetree/bindings/ata/ahci-platform.txt      |    3 +-
 drivers/ata/ahci_platform.c                        |   65 +++++++++++++++-----
 2 files changed, 52 insertions(+), 16 deletions(-)

diff --git a/Documentation/devicetree/bindings/ata/ahci-platform.txt b/Documentation/devicetree/bindings/ata/ahci-platform.txt
index 48b285f..aab1d70 100644
--- a/Documentation/devicetree/bindings/ata/ahci-platform.txt
+++ b/Documentation/devicetree/bindings/ata/ahci-platform.txt
@@ -7,7 +7,8 @@ Required properties:
 - compatible        : compatible list, one of "snps,spear-ahci",
                       "snps,exynos5440-ahci", "ibm,476gtr-ahci",
                       "allwinner,sun4i-a10-ahci", "fsl,imx53-ahci"
-                      "fsl,imx6q-ahci" or "snps,dwc-ahci"
+                      "fsl,imx6q-ahci", "snps,dwc-ahci" or
+                      "hisilicon,hisi-ahci"
 - interrupts        : <interrupt mapping for SATA IRQ>
 - reg               : <registers mapping>
 
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index ef67e79..9581d51 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -17,22 +17,61 @@
 #include <linux/pm.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/libata.h>
 #include <linux/ahci_platform.h>
 #include "ahci.h"
 
-static const struct ata_port_info ahci_port_info = {
-	.flags		= AHCI_FLAG_COMMON,
-	.pio_mask	= ATA_PIO4,
-	.udma_mask	= ATA_UDMA6,
-	.port_ops	= &ahci_platform_ops,
+enum ahci_type {
+	AHCI,		/* standard platform ahci */
+	HIP04_AHCI,	/* ahci on HiP04 */
 };
 
+static const struct ata_port_info ahci_port_info[] = {
+	[AHCI] = {
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_platform_ops,
+	},
+	[HIP04_AHCI] = {
+		AHCI_HFLAGS	(AHCI_HFLAG_NO_FBS),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_platform_ops,
+	},
+};
+
+static const struct of_device_id ahci_of_match[] = {
+	{ .compatible = "snps,spear-ahci", },
+	{ .compatible = "snps,exynos5440-ahci", },
+	{ .compatible = "ibm,476gtr-ahci", },
+	{ .compatible = "snps,dwc-ahci", },
+	{ .compatible = "hisilicon,hisi-ahci", .data = (void *)HIP04_AHCI, },
+	{},
+};
+MODULE_DEVICE_TABLE(of, ahci_of_match);
+
+static int ahci_match_of_id(struct platform_device *pdev,
+			    enum ahci_type *ahci_type)
+{
+	const struct of_device_id *of_id = of_match_device(ahci_of_match,
+							   &pdev->dev);
+	if (!of_id)
+		return -ENODEV;
+	*ahci_type = (unsigned long)(of_id->data);
+	return 0;
+}
+
 static int ahci_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct ahci_platform_data *pdata = dev_get_platdata(dev);
 	struct ahci_host_priv *hpriv;
+	struct ata_port_info pi;
+	enum ahci_type ahci_type;
 	int rc;
 
 	hpriv = ahci_platform_get_resources(pdev);
@@ -55,7 +94,12 @@ static int ahci_probe(struct platform_device *pdev)
 			goto disable_resources;
 	}
 
-	rc = ahci_platform_init_host(pdev, hpriv, &ahci_port_info, 0, 0);
+	if (!ahci_match_of_id(pdev, &ahci_type))
+		pi = ahci_port_info[ahci_type];
+	else
+		pi = ahci_port_info[AHCI];
+
+	rc = ahci_platform_init_host(pdev, hpriv, &pi, 0, 0);
 	if (rc)
 		goto pdata_exit;
 
@@ -71,15 +115,6 @@ disable_resources:
 static SIMPLE_DEV_PM_OPS(ahci_pm_ops, ahci_platform_suspend,
 			 ahci_platform_resume);
 
-static const struct of_device_id ahci_of_match[] = {
-	{ .compatible = "snps,spear-ahci", },
-	{ .compatible = "snps,exynos5440-ahci", },
-	{ .compatible = "ibm,476gtr-ahci", },
-	{ .compatible = "snps,dwc-ahci", },
-	{},
-};
-MODULE_DEVICE_TABLE(of, ahci_of_match);
-
 static struct platform_driver ahci_driver = {
 	.probe = ahci_probe,
 	.remove = ata_platform_remove_one,
-- 
1.7.1


