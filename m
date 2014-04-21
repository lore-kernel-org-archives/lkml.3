Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaDUECu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 00:02:50 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:41578 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaDUECE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 00:02:04 -0400
From: Kefeng Wang <kefeng.wang@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com
Subject: [PATCH v3 2/2] ahci: add support for Hisilicon sata
Date: Mon, 21 Apr 2014 12:01:42 +0800
Message-Id: <1398052903-10322-3-git-send-email-kefeng.wang@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398052903-10322-1-git-send-email-kefeng.wang@linaro.org>
References: <1398052903-10322-1-git-send-email-kefeng.wang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hip04 SoC of hisilicon has an AHCI compliant SATA controller,
and it is compliant with the ahci 1.3 and sata 3.0 specification.

There is a wrong bit in HOST_CAP of hip04 sata controller, which
enable unsupported feature of FBS, use AHCI_HFLAG_NO_FBS hflag to
disable it.

Cc: Hans de Geode <hdegoede@redhat.com>
Signed-off-by: Kefeng Wang <kefeng.wang@linaro.org>
---
 .../devicetree/bindings/ata/ahci-platform.txt      |    3 ++-
 drivers/ata/ahci_platform.c                        |   10 ++++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

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
index ef67e79..48b9feb 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -17,11 +17,12 @@
 #include <linux/pm.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
+#include <linux/of_device.h>
 #include <linux/libata.h>
 #include <linux/ahci_platform.h>
 #include "ahci.h"
 
-static const struct ata_port_info ahci_port_info = {
+static struct ata_port_info ahci_port_info = {
 	.flags		= AHCI_FLAG_COMMON,
 	.pio_mask	= ATA_PIO4,
 	.udma_mask	= ATA_UDMA6,
@@ -32,6 +33,7 @@ static int ahci_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct ahci_platform_data *pdata = dev_get_platdata(dev);
+	struct ata_port_info *pi = &ahci_port_info;
 	struct ahci_host_priv *hpriv;
 	int rc;
 
@@ -55,7 +57,10 @@ static int ahci_probe(struct platform_device *pdev)
 			goto disable_resources;
 	}
 
-	rc = ahci_platform_init_host(pdev, hpriv, &ahci_port_info, 0, 0);
+	if (of_device_is_compatible(dev->of_node, "hisilicon,hisi-ahci"))
+		pi->private_data = (void *)AHCI_HFLAG_NO_FBS;
+
+	rc = ahci_platform_init_host(pdev, hpriv, pi, 0, 0);
 	if (rc)
 		goto pdata_exit;
 
@@ -76,6 +81,7 @@ static const struct of_device_id ahci_of_match[] = {
 	{ .compatible = "snps,exynos5440-ahci", },
 	{ .compatible = "ibm,476gtr-ahci", },
 	{ .compatible = "snps,dwc-ahci", },
+	{ .compatible = "hisilicon,hisi-ahci", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ahci_of_match);
-- 
1.7.9.5

