Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbaEOGpD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:45:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:40282 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258AbaEOGo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:44:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1057,1389772800"; 
   d="scan'208";a="532238386"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH V6 09/11] ACPI: introduce flag .is_master_device
Date: Thu, 15 May 2014 14:44:14 +0800
Message-Id: <1400136256-2218-10-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400136256-2218-1-git-send-email-rui.zhang@intel.com>
References: <1400136256-2218-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some ACPI device objects, they represent master devices,
and their children devices are enumerated by bus controller drivers
for the buses they are on.

In this case, we do not want to enumerate their children devices to
platform bus explicitly in acpi scan code.

Thus a new flag .is_master_device is introduced in this patch.

For devices with this flag set, we will not do default enumeration
for their children.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/acpi_lpss.c | 62 +++++++++++++++++++++++++++++++++---------------
 include/acpi/acpi_bus.h  |  3 ++-
 2 files changed, 45 insertions(+), 20 deletions(-)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index 965428f..4ab0915 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -54,6 +54,7 @@ struct lpss_shared_clock {
 struct lpss_private_data;
 
 struct lpss_device_desc {
+	bool is_master_device;
 	bool clk_required;
 	const char *clkdev_name;
 	bool ltr_required;
@@ -91,6 +92,7 @@ static void lpss_uart_setup(struct lpss_private_data *pdata)
 }
 
 static struct lpss_device_desc lpt_dev_desc = {
+	.is_master_device = true,
 	.clk_required = true,
 	.prv_offset = 0x800,
 	.ltr_required = true,
@@ -98,6 +100,7 @@ static struct lpss_device_desc lpt_dev_desc = {
 };
 
 static struct lpss_device_desc lpt_uart_dev_desc = {
+	.is_master_device = true,
 	.clk_required = true,
 	.prv_offset = 0x800,
 	.ltr_required = true,
@@ -106,6 +109,7 @@ static struct lpss_device_desc lpt_uart_dev_desc = {
 };
 
 static struct lpss_device_desc lpt_sdio_dev_desc = {
+	.is_master_device = true,
 	.prv_offset = 0x1000,
 	.prv_size_override = 0x1018,
 	.ltr_required = true,
@@ -127,6 +131,7 @@ static struct lpss_shared_clock uart_clock = {
 };
 
 static struct lpss_device_desc byt_uart_dev_desc = {
+	.is_master_device = true,
 	.clk_required = true,
 	.prv_offset = 0x800,
 	.clk_gate = true,
@@ -140,6 +145,7 @@ static struct lpss_shared_clock spi_clock = {
 };
 
 static struct lpss_device_desc byt_spi_dev_desc = {
+	.is_master_device = true,
 	.clk_required = true,
 	.prv_offset = 0x400,
 	.clk_gate = true,
@@ -147,6 +153,7 @@ static struct lpss_device_desc byt_spi_dev_desc = {
 };
 
 static struct lpss_device_desc byt_sdio_dev_desc = {
+	.is_master_device = true,
 	.clk_required = true,
 };
 
@@ -156,16 +163,24 @@ static struct lpss_shared_clock i2c_clock = {
 };
 
 static struct lpss_device_desc byt_i2c_dev_desc = {
+	.is_master_device = true,
 	.clk_required = true,
 	.prv_offset = 0x800,
 	.shared_clock = &i2c_clock,
 };
 
 #define LPSS_PTR(desc) ((unsigned long)&desc)
+#define LPSS_MASTER_PTR(desc) LPSS_PTR(desc)
 
 #else
 
-#define LPSS_PTR(desc) 0
+static struct lpss_device_desc lpss_dummy_desc;
+static struct lpss_device_desc lpss_dummy_master_desc = {
+	.is_master_device = true,
+};
+
+#define LPSS_PTR(desc) (&lpss_dummy_desc)
+#define LPSS_MASTER_PTR(desc) (&lpss_dummy_master_desc)
 
 #endif
 
@@ -174,30 +189,30 @@ static const struct acpi_device_id acpi_lpss_device_ids[] = {
 	{ "INTL9C60", LPSS_PTR(lpss_dma_desc) },
 
 	/* Lynxpoint LPSS devices */
-	{ "INT33C0", LPSS_PTR(lpt_dev_desc) },
-	{ "INT33C1", LPSS_PTR(lpt_dev_desc) },
-	{ "INT33C2", LPSS_PTR(lpt_dev_desc) },
-	{ "INT33C3", LPSS_PTR(lpt_dev_desc) },
-	{ "INT33C4", LPSS_PTR(lpt_uart_dev_desc) },
-	{ "INT33C5", LPSS_PTR(lpt_uart_dev_desc) },
-	{ "INT33C6", LPSS_PTR(lpt_sdio_dev_desc) },
+	{ "INT33C0", LPSS_MASTER_PTR(lpt_dev_desc) },
+	{ "INT33C1", LPSS_MASTER_PTR(lpt_dev_desc) },
+	{ "INT33C2", LPSS_MASTER_PTR(lpt_dev_desc) },
+	{ "INT33C3", LPSS_MASTER_PTR(lpt_dev_desc) },
+	{ "INT33C4", LPSS_MASTER_PTR(lpt_uart_dev_desc) },
+	{ "INT33C5", LPSS_MASTER_PTR(lpt_uart_dev_desc) },
+	{ "INT33C6", LPSS_MASTER_PTR(lpt_sdio_dev_desc) },
 	{ "INT33C7", },
 
 	/* BayTrail LPSS devices */
 	{ "80860F09", LPSS_PTR(byt_pwm_dev_desc) },
-	{ "80860F0A", LPSS_PTR(byt_uart_dev_desc) },
-	{ "80860F0E", LPSS_PTR(byt_spi_dev_desc) },
-	{ "80860F14", LPSS_PTR(byt_sdio_dev_desc) },
-	{ "80860F41", LPSS_PTR(byt_i2c_dev_desc) },
+	{ "80860F0A", LPSS_MASTER_PTR(byt_uart_dev_desc) },
+	{ "80860F0E", LPSS_MASTER_PTR(byt_spi_dev_desc) },
+	{ "80860F14", LPSS_MASTER_PTR(byt_sdio_dev_desc) },
+	{ "80860F41", LPSS_MASTER_PTR(byt_i2c_dev_desc) },
 	{ "INT33B2", },
 
-	{ "INT3430", LPSS_PTR(lpt_dev_desc) },
-	{ "INT3431", LPSS_PTR(lpt_dev_desc) },
-	{ "INT3432", LPSS_PTR(lpt_dev_desc) },
-	{ "INT3433", LPSS_PTR(lpt_dev_desc) },
-	{ "INT3434", LPSS_PTR(lpt_uart_dev_desc) },
-	{ "INT3435", LPSS_PTR(lpt_uart_dev_desc) },
-	{ "INT3436", LPSS_PTR(lpt_sdio_dev_desc) },
+	{ "INT3430", LPSS_MASTER_PTR(lpt_dev_desc) },
+	{ "INT3431", LPSS_MASTER_PTR(lpt_dev_desc) },
+	{ "INT3432", LPSS_MASTER_PTR(lpt_dev_desc) },
+	{ "INT3433", LPSS_MASTER_PTR(lpt_dev_desc) },
+	{ "INT3434", LPSS_MASTER_PTR(lpt_uart_dev_desc) },
+	{ "INT3435", LPSS_MASTER_PTR(lpt_uart_dev_desc) },
+	{ "INT3436", LPSS_MASTER_PTR(lpt_sdio_dev_desc) },
 	{ "INT3437", },
 
 	{ }
@@ -285,6 +300,8 @@ static int acpi_lpss_create_device(struct acpi_device *adev,
 	if (!dev_desc)
 		return acpi_create_platform_device(adev, id);
 
+	adev->flags.is_master_device = dev_desc->is_master_device;
+
 	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
@@ -528,6 +545,13 @@ static struct acpi_scan_handler lpss_handler = {
 static int acpi_lpss_dummy_attach(struct acpi_device *adev,
 				const struct acpi_device_id *id)
 {
+	struct lpss_device_desc *dev_desc;
+
+	dev_desc = (struct lpss_device_desc *)id->driver_data;
+	if (!dev_desc)
+		return 1;
+
+	adev->flags.is_master_device = dev_desc->is_master_device;
 	return 1;
 }
 
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index ec92ad3..13ac75f 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -207,7 +207,8 @@ struct acpi_device_flags {
 	u32 no_hotplug:1;
 	u32 hotplug_notify:1;
 	u32 is_dock_station:1;
-	u32 reserved:22;
+	u32 is_master_device:1;
+	u32 reserved:21;
 };
 
 /* File System */
-- 
1.8.3.2

