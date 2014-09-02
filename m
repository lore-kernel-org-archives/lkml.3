Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbaIBKp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:45:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:13744 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbaIBKp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:45:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,448,1406617200"; 
   d="scan'208";a="593283430"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 3/4] mfd: lpc_sch: Add support for Intel Quark X1000
Date: Tue,  2 Sep 2014 13:45:21 +0300
Message-Id: <1409654722-6570-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409654722-6570-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1409654722-6570-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel Quark X1000 SoC supports IRQ based GPIO. This patch will
enable MFD support for Quark X1000 and provide IRQ resources
to Quark X1000 GPIO device driver.

Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Tested-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/mfd/lpc_sch.c | 37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
index bde070a..ae614b2 100644
--- a/drivers/mfd/lpc_sch.c
+++ b/drivers/mfd/lpc_sch.c
@@ -37,6 +37,9 @@
 #define GPIO_IO_SIZE	64
 #define GPIO_IO_SIZE_CENTERTON	128
 
+/* Intel Quark X1000 GPIO IRQ Number */
+#define GPIO_IRQ_QUARK_X1000	9
+
 #define WDTBASE		0x84
 #define WDT_IO_SIZE	64
 
@@ -44,28 +47,37 @@ enum sch_chipsets {
 	LPC_SCH = 0,		/* Intel Poulsbo SCH */
 	LPC_ITC,		/* Intel Tunnel Creek */
 	LPC_CENTERTON,		/* Intel Centerton */
+	LPC_QUARK_X1000,	/* Intel Quark X1000 */
 };
 
 struct lpc_sch_info {
 	unsigned int io_size_smbus;
 	unsigned int io_size_gpio;
 	unsigned int io_size_wdt;
+	int irq_gpio;
 };
 
 static struct lpc_sch_info sch_chipset_info[] = {
 	[LPC_SCH] = {
 		.io_size_smbus = SMBUS_IO_SIZE,
 		.io_size_gpio = GPIO_IO_SIZE,
+		.irq_gpio = -1,
 	},
 	[LPC_ITC] = {
 		.io_size_smbus = SMBUS_IO_SIZE,
 		.io_size_gpio = GPIO_IO_SIZE,
 		.io_size_wdt = WDT_IO_SIZE,
+		.irq_gpio = -1,
 	},
 	[LPC_CENTERTON] = {
 		.io_size_smbus = SMBUS_IO_SIZE,
 		.io_size_gpio = GPIO_IO_SIZE_CENTERTON,
 		.io_size_wdt = WDT_IO_SIZE,
+		.irq_gpio = -1,
+	},
+	[LPC_QUARK_X1000] = {
+		.io_size_gpio = GPIO_IO_SIZE,
+		.irq_gpio = GPIO_IRQ_QUARK_X1000,
 	},
 };
 
@@ -73,6 +85,7 @@ static const struct pci_device_id lpc_sch_ids[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_SCH_LPC), LPC_SCH },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ITC_LPC), LPC_ITC },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_CENTERTON_ILB), LPC_CENTERTON },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QUARK_X1000_ILB), LPC_QUARK_X1000 },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, lpc_sch_ids);
@@ -110,13 +123,13 @@ static int lpc_sch_get_io(struct pci_dev *pdev, int where, const char *name,
 }
 
 static int lpc_sch_populate_cell(struct pci_dev *pdev, int where,
-				 const char *name, int size, int id,
-				 struct mfd_cell *cell)
+				 const char *name, int size, int irq,
+				 int id, struct mfd_cell *cell)
 {
 	struct resource *res;
 	int ret;
 
-	res = devm_kzalloc(&pdev->dev, sizeof(*res), GFP_KERNEL);
+	res = devm_kcalloc(&pdev->dev, 2, sizeof(*res), GFP_KERNEL);
 	if (!res)
 		return -ENOMEM;
 
@@ -132,6 +145,18 @@ static int lpc_sch_populate_cell(struct pci_dev *pdev, int where,
 	cell->ignore_resource_conflicts = true;
 	cell->id = id;
 
+	/* Check if we need to add an IRQ resource */
+	if (irq < 0)
+		return 0;
+
+	res++;
+
+	res->start = irq;
+	res->end = irq;
+	res->flags = IORESOURCE_IRQ;
+
+	cell->num_resources++;
+
 	return 0;
 }
 
@@ -143,7 +168,7 @@ static int lpc_sch_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	int ret;
 
 	ret = lpc_sch_populate_cell(dev, SMBASE, "isch_smbus",
-				    info->io_size_smbus,
+				    info->io_size_smbus, -1,
 				    id->device, &lpc_sch_cells[cells]);
 	if (ret < 0)
 		return ret;
@@ -151,7 +176,7 @@ static int lpc_sch_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		cells++;
 
 	ret = lpc_sch_populate_cell(dev, GPIOBASE, "sch_gpio",
-				    info->io_size_gpio,
+				    info->io_size_gpio, info->irq_gpio,
 				    id->device, &lpc_sch_cells[cells]);
 	if (ret < 0)
 		return ret;
@@ -159,7 +184,7 @@ static int lpc_sch_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		cells++;
 
 	ret = lpc_sch_populate_cell(dev, WDTBASE, "ie6xx_wdt",
-				    info->io_size_wdt,
+				    info->io_size_wdt, -1,
 				    id->device, &lpc_sch_cells[cells]);
 	if (ret < 0)
 		return ret;
-- 
2.1.0

