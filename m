Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935705Ab3DILGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 07:06:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:36390 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758447Ab3DILGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 07:06:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,438,1363158000"; 
   d="scan'208";a="316520601"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-acpi@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH v2 5/5] ACPI / LPSS: add support of shared clock
Date: Tue,  9 Apr 2013 14:05:47 +0300
Message-Id: <1365505547-10552-6-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1365505547-10552-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1365505547-10552-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>

The DMA controller in Lynxpoint is using the LPSS root clock as a functional
clock to work properly. Proposed patch adds support of the shared clock. It
also avoids hardcoding the name of the DMA device in clk-lpt.c and the name of
the root clock in acpi_lpss.c.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/acpi_lpss.c               | 26 ++++++++++++++++++++++----
 drivers/clk/x86/clk-lpt.c              | 15 +++++++++++----
 include/linux/platform_data/clk-lpss.h |  5 +++++
 3 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index b1c9542..652fd5c 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -35,11 +35,16 @@ ACPI_MODULE_NAME("acpi_lpss");
 
 struct lpss_device_desc {
 	bool clk_required;
-	const char *clk_parent;
+	const char *clkdev_name;
 	bool ltr_required;
 	unsigned int prv_offset;
 };
 
+static struct lpss_device_desc lpss_dma_desc = {
+	.clk_required = true,
+	.clkdev_name = "hclk",
+};
+
 struct lpss_private_data {
 	void __iomem *mmio_base;
 	resource_size_t mmio_size;
@@ -49,7 +54,6 @@ struct lpss_private_data {
 
 static struct lpss_device_desc lpt_dev_desc = {
 	.clk_required = true,
-	.clk_parent = "lpss_clk",
 	.prv_offset = 0x800,
 	.ltr_required = true,
 };
@@ -60,6 +64,9 @@ static struct lpss_device_desc lpt_sdio_dev_desc = {
 };
 
 static const struct acpi_device_id acpi_lpss_device_ids[] = {
+	/* Generic LPSS devices */
+	{ "INTL9C60", (unsigned long)&lpss_dma_desc },
+
 	/* Lynxpoint LPSS devices */
 	{ "INT33C0", (unsigned long)&lpt_dev_desc },
 	{ "INT33C1", (unsigned long)&lpt_dev_desc },
@@ -91,16 +98,27 @@ static int register_device_clock(struct acpi_device *adev,
 				 struct lpss_private_data *pdata)
 {
 	const struct lpss_device_desc *dev_desc = pdata->dev_desc;
+	struct lpss_clk_data *clk_data;
 
 	if (!lpss_clk_dev)
 		lpt_register_clock_device();
 
-	if (!dev_desc->clk_parent || !pdata->mmio_base
+	clk_data = platform_get_drvdata(lpss_clk_dev);
+	if (!clk_data)
+		return -ENODEV;
+
+	if (dev_desc->clkdev_name) {
+		clk_register_clkdev(clk_data->clk, dev_desc->clkdev_name,
+				    dev_name(&adev->dev));
+		return 0;
+	}
+
+	if (!pdata->mmio_base
 	    || pdata->mmio_size < dev_desc->prv_offset + LPSS_CLK_SIZE)
 		return -ENODATA;
 
 	pdata->clk = clk_register_gate(NULL, dev_name(&adev->dev),
-				       dev_desc->clk_parent, 0,
+				       clk_data->name, 0,
 				       pdata->mmio_base + dev_desc->prv_offset,
 				       0, 0, NULL);
 	if (IS_ERR(pdata->clk))
diff --git a/drivers/clk/x86/clk-lpt.c b/drivers/clk/x86/clk-lpt.c
index 5cf4f46..e70fae3f 100644
--- a/drivers/clk/x86/clk-lpt.c
+++ b/drivers/clk/x86/clk-lpt.c
@@ -15,22 +15,29 @@
 #include <linux/clk-provider.h>
 #include <linux/err.h>
 #include <linux/module.h>
+#include <linux/platform_data/clk-lpss.h>
 #include <linux/platform_device.h>
 
 #define PRV_CLOCK_PARAMS 0x800
 
 static int lpt_clk_probe(struct platform_device *pdev)
 {
+	struct lpss_clk_data *drvdata;
 	struct clk *clk;
 
+	drvdata = devm_kmalloc(&pdev->dev, sizeof(*drvdata), GFP_KERNEL);
+	if (!drvdata)
+		return -ENOMEM;
+
 	/* LPSS free running clock */
-	clk = clk_register_fixed_rate(&pdev->dev, "lpss_clk", NULL, CLK_IS_ROOT,
-				      100000000);
+	drvdata->name = "lpss_clk";
+	clk = clk_register_fixed_rate(&pdev->dev, drvdata->name, NULL,
+				      CLK_IS_ROOT, 100000000);
 	if (IS_ERR(clk))
 		return PTR_ERR(clk);
 
-	/* Shared DMA clock */
-	clk_register_clkdev(clk, "hclk", "INTL9C60.0.auto");
+	drvdata->clk = clk;
+	platform_set_drvdata(pdev, drvdata);
 	return 0;
 }
 
diff --git a/include/linux/platform_data/clk-lpss.h b/include/linux/platform_data/clk-lpss.h
index 528e73c..2390199 100644
--- a/include/linux/platform_data/clk-lpss.h
+++ b/include/linux/platform_data/clk-lpss.h
@@ -13,6 +13,11 @@
 #ifndef __CLK_LPSS_H
 #define __CLK_LPSS_H
 
+struct lpss_clk_data {
+	const char *name;
+	struct clk *clk;
+};
+
 extern int lpt_clk_init(void);
 
 #endif /* __CLK_LPSS_H */
-- 
1.8.2.rc0.22.gb3600c3

