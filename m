Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224AbaEMMOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 08:14:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:55475 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933186AbaEMMOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 08:14:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1044,1389772800"; 
   d="scan'208";a="539559862"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Mike Turquette <mturquette@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Li Aubrey <aubrey.li@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] ACPI / LPSS: support for fractional divider clock
Date: Tue, 13 May 2014 15:13:53 +0300
Message-Id: <1399983233-18037-5-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1399983233-18037-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1399983233-18037-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LPSS platforms offer the M/N divider clock for most devices.
This creates fractional divider type clock for the ones that
have it. It is needed with UART as the clock rate must
accommodate to the requested baud rate.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/acpi/acpi_lpss.c | 63 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 42 insertions(+), 21 deletions(-)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index 24e49a5..3c7b97d 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -29,6 +29,7 @@ ACPI_MODULE_NAME("acpi_lpss");
 #define LPSS_LTR_SIZE	0x18
 
 /* Offsets relative to LPSS_PRIVATE_OFFSET */
+#define LPSS_CLK_DIVIDER_DEF_MASK	(BIT(1) | BIT(16))
 #define LPSS_GENERAL			0x08
 #define LPSS_GENERAL_LTR_MODE_SW	BIT(2)
 #define LPSS_GENERAL_UART_RTS_OVRD	BIT(3)
@@ -60,6 +61,7 @@ struct lpss_device_desc {
 	bool ltr_required;
 	unsigned int prv_offset;
 	size_t prv_size_override;
+	bool clk_divider;
 	bool clk_gate;
 	bool save_ctx;
 	struct lpss_shared_clock *shared_clock;
@@ -97,6 +99,14 @@ static struct lpss_device_desc lpt_dev_desc = {
 	.clk_required = true,
 	.prv_offset = 0x800,
 	.ltr_required = true,
+	.clk_divider = true,
+	.clk_gate = true,
+};
+
+static struct lpss_device_desc lpt_i2c_dev_desc = {
+	.clk_required = true,
+	.prv_offset = 0x800,
+	.ltr_required = true,
 	.clk_gate = true,
 };
 
@@ -104,6 +114,7 @@ static struct lpss_device_desc lpt_uart_dev_desc = {
 	.clk_required = true,
 	.prv_offset = 0x800,
 	.ltr_required = true,
+	.clk_divider = true,
 	.clk_gate = true,
 	.setup = lpss_uart_setup,
 };
@@ -125,31 +136,21 @@ static struct lpss_device_desc byt_pwm_dev_desc = {
 	.shared_clock = &pwm_clock,
 };
 
-static struct lpss_shared_clock uart_clock = {
-	.name = "uart_clk",
-	.rate = 44236800,
-};
-
 static struct lpss_device_desc byt_uart_dev_desc = {
 	.clk_required = true,
 	.prv_offset = 0x800,
+	.clk_divider = true,
 	.clk_gate = true,
 	.save_ctx = true,
-	.shared_clock = &uart_clock,
 	.setup = lpss_uart_setup,
 };
 
-static struct lpss_shared_clock spi_clock = {
-	.name = "spi_clk",
-	.rate = 50000000,
-};
-
 static struct lpss_device_desc byt_spi_dev_desc = {
 	.clk_required = true,
 	.prv_offset = 0x400,
+	.clk_divider = true,
 	.clk_gate = true,
 	.save_ctx = true,
-	.shared_clock = &spi_clock,
 };
 
 static struct lpss_device_desc byt_sdio_dev_desc = {
@@ -175,8 +176,8 @@ static const struct acpi_device_id acpi_lpss_device_ids[] = {
 	/* Lynxpoint LPSS devices */
 	{ "INT33C0", (unsigned long)&lpt_dev_desc },
 	{ "INT33C1", (unsigned long)&lpt_dev_desc },
-	{ "INT33C2", (unsigned long)&lpt_dev_desc },
-	{ "INT33C3", (unsigned long)&lpt_dev_desc },
+	{ "INT33C2", (unsigned long)&lpt_i2c_dev_desc },
+	{ "INT33C3", (unsigned long)&lpt_i2c_dev_desc },
 	{ "INT33C4", (unsigned long)&lpt_uart_dev_desc },
 	{ "INT33C5", (unsigned long)&lpt_uart_dev_desc },
 	{ "INT33C6", (unsigned long)&lpt_sdio_dev_desc },
@@ -221,9 +222,11 @@ static int register_device_clock(struct acpi_device *adev,
 {
 	const struct lpss_device_desc *dev_desc = pdata->dev_desc;
 	struct lpss_shared_clock *shared_clock = dev_desc->shared_clock;
+	const char *devname = dev_name(&adev->dev);
 	struct clk *clk = ERR_PTR(-ENODEV);
 	struct lpss_clk_data *clk_data;
-	const char *parent;
+	const char *parent, *clk_name;
+	void __iomem *prv_base;
 
 	if (!lpss_clk_dev)
 		lpt_register_clock_device();
@@ -234,7 +237,7 @@ static int register_device_clock(struct acpi_device *adev,
 
 	if (dev_desc->clkdev_name) {
 		clk_register_clkdev(clk_data->clk, dev_desc->clkdev_name,
-				    dev_name(&adev->dev));
+				    devname);
 		return 0;
 	}
 
@@ -243,6 +246,7 @@ static int register_device_clock(struct acpi_device *adev,
 		return -ENODATA;
 
 	parent = clk_data->name;
+	prv_base = pdata->mmio_base + dev_desc->prv_offset;
 
 	if (shared_clock) {
 		clk = shared_clock->clk;
@@ -256,16 +260,33 @@ static int register_device_clock(struct acpi_device *adev,
 	}
 
 	if (dev_desc->clk_gate) {
-		clk = clk_register_gate(NULL, dev_name(&adev->dev), parent, 0,
-					pdata->mmio_base + dev_desc->prv_offset,
-					0, 0, NULL);
-		pdata->clk = clk;
+		clk = clk_register_gate(NULL, devname, parent, 0,
+					prv_base, 0, 0, NULL);
+		parent = devname;
+	}
+
+	if (dev_desc->clk_divider) {
+		/* Prevent division by zero */
+		if (!readl(prv_base))
+			writel(LPSS_CLK_DIVIDER_DEF_MASK, prv_base);
+
+		clk_name = kasprintf(GFP_KERNEL, "%s-div", devname);
+		clk = clk_register_fractional_divider(NULL, clk_name, parent,
+						      0, prv_base,
+						      1, 15, 16, 15, 0, NULL);
+		parent = clk_name;
+
+		clk_name = kasprintf(GFP_KERNEL, "%s-update", devname);
+		clk = clk_register_gate(NULL, clk_name, parent,
+					CLK_SET_RATE_PARENT | CLK_SET_RATE_GATE,
+					prv_base, 31, 0, NULL);
 	}
 
 	if (IS_ERR(clk))
 		return PTR_ERR(clk);
 
-	clk_register_clkdev(clk, NULL, dev_name(&adev->dev));
+	pdata->clk = clk;
+	clk_register_clkdev(clk, NULL, devname);
 	return 0;
 }
 
-- 
2.0.0.rc2

