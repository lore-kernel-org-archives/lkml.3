Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab3JDT5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 15:57:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:50672 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133Ab3JDT5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 15:57:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1035,1371106800"; 
   d="scan'208";a="388047496"
From: David Cohen <david.a.cohen@linux.intel.com>
To: linus.walleij@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>,
        Fei Yang <fei.yang@intel.com>, Ning Li <ning.li@intel.com>
Subject: [PATCH 1/3] gpio: langwell: add Intel Merrifield support
Date: Fri,  4 Oct 2013 13:01:40 -0700
Message-Id: <1380916902-23791-2-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1380916902-23791-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1380916902-23791-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a better way to handle multiple SoC's and adds
Intel Merrifield support to gpio-langwell.

It was based on previous work from Ning Li <ning.li@intel.com>

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Signed-off-by: Fei Yang <fei.yang@intel.com>
Signed-off-by: Ning Li <ning.li@intel.com>
---
 drivers/gpio/gpio-langwell.c | 93 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 82 insertions(+), 11 deletions(-)

diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index bfa1af1..bf3b959 100644
--- a/drivers/gpio/gpio-langwell.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -37,6 +37,9 @@
 #include <linux/pm_runtime.h>
 #include <linux/irqdomain.h>
 
+#define LNW_IRQ_TYPE_EDGE	(1 << 0)
+#define LNW_IRQ_TYPE_LEVEL	(1 << 1)
+
 /*
  * Langwell chip has 64 pins and thus there are 2 32bit registers to control
  * each feature, while Penwell chip has 96 pins for each block, and need 3 32bit
@@ -62,6 +65,16 @@ enum GPIO_REG {
 	GAFR,		/* alt function */
 };
 
+/* langwell gpio driver data */
+struct lnw_gpio_ddata {
+	u16 ngpio;		/* number of gpio pins */
+	u32 gplr_offset;	/* offset of first GPLR register from base */
+	u32 flis_base;		/* base address of FLIS registers */
+	u32 flis_len;		/* length of FLIS registers */
+	u32 (*get_flis_offset)(int gpio);
+	u32 chip_irq_type;	/* chip interrupt type */
+};
+
 struct lnw_gpio {
 	struct gpio_chip		chip;
 	void __iomem			*reg_base;
@@ -227,13 +240,71 @@ static struct irq_chip lnw_irqchip = {
 	.irq_set_type	= lnw_irq_type,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(lnw_gpio_ids) = {   /* pin number */
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080f), .driver_data = 64 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x081f), .driver_data = 96 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x081a), .driver_data = 96 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x08eb), .driver_data = 96 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x08f7), .driver_data = 96 },
-	{ 0, }
+static const struct lnw_gpio_ddata gpio_lincroft = {
+	.ngpio = 64,
+};
+
+static const struct lnw_gpio_ddata gpio_penwell_aon = {
+	.ngpio = 96,
+	.chip_irq_type = LNW_IRQ_TYPE_EDGE,
+};
+
+static const struct lnw_gpio_ddata gpio_penwell_core = {
+	.ngpio = 96,
+	.chip_irq_type = LNW_IRQ_TYPE_EDGE,
+};
+
+static const struct lnw_gpio_ddata gpio_cloverview_aon = {
+	.ngpio = 96,
+	.chip_irq_type = LNW_IRQ_TYPE_EDGE | LNW_IRQ_TYPE_LEVEL,
+};
+
+static const struct lnw_gpio_ddata gpio_cloverview_core = {
+	.ngpio = 96,
+	.chip_irq_type = LNW_IRQ_TYPE_EDGE,
+};
+
+static const struct lnw_gpio_ddata gpio_tangier = {
+	.ngpio = 192,
+	.gplr_offset = 4,
+	.flis_base = 0xff0c0000,
+	.flis_len = 0x8000,
+	.get_flis_offset = NULL,
+	.chip_irq_type = LNW_IRQ_TYPE_EDGE,
+};
+
+static DEFINE_PCI_DEVICE_TABLE(lnw_gpio_ids) = {
+	{
+		/* Lincroft */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080f),
+		.driver_data = (kernel_ulong_t)&gpio_lincroft,
+	},
+	{
+		/* Penwell AON */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x081f),
+		.driver_data = (kernel_ulong_t)&gpio_penwell_aon,
+	},
+	{
+		/* Penwell Core */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x081a),
+		.driver_data = (kernel_ulong_t)&gpio_penwell_core,
+	},
+	{
+		/* Cloverview Aon */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x08eb),
+		.driver_data = (kernel_ulong_t)&gpio_cloverview_aon,
+	},
+	{
+		/* Cloverview Core */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x08f7),
+		.driver_data = (kernel_ulong_t)&gpio_cloverview_core,
+	},
+	{
+		/* Tangier */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x1199),
+		.driver_data = (kernel_ulong_t)&gpio_tangier,
+	},
+	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, lnw_gpio_ids);
 
@@ -316,7 +387,7 @@ static int lnw_gpio_probe(struct pci_dev *pdev,
 	u32 gpio_base;
 	u32 irq_base;
 	int retval;
-	int ngpio = id->driver_data;
+	struct lnw_gpio_ddata *ddata = (struct lnw_gpio_ddata *)id->driver_data;
 
 	retval = pcim_enable_device(pdev);
 	if (retval)
@@ -351,14 +422,14 @@ static int lnw_gpio_probe(struct pci_dev *pdev,
 	lnw->chip.set = lnw_gpio_set;
 	lnw->chip.to_irq = lnw_gpio_to_irq;
 	lnw->chip.base = gpio_base;
-	lnw->chip.ngpio = ngpio;
+	lnw->chip.ngpio = ddata->ngpio;
 	lnw->chip.can_sleep = 0;
 	lnw->pdev = pdev;
 
 	spin_lock_init(&lnw->lock);
 
-	lnw->domain = irq_domain_add_simple(pdev->dev.of_node, ngpio, irq_base,
-					    &lnw_gpio_irq_ops, lnw);
+	lnw->domain = irq_domain_add_simple(pdev->dev.of_node, ddata->ngpio,
+					    irq_base, &lnw_gpio_irq_ops, lnw);
 	if (!lnw->domain)
 		return -ENOMEM;
 
-- 
1.8.4.rc3

