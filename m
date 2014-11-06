Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbaKFXFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:05:51 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:52075 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbaKFXFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 18:05:44 -0500
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: gregkh@linuxfoundation.org, jslaby@suse.cz, cascardo@linux.vnet.ibm.com,
        markh@compro.net
Cc: lidza.louina@gmail.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-serial@vger.kernel.org,
        Konrad Zapalowicz <bergo.torino@gmail.com>
Subject: [PATCH v2 2/4] drivers: serial: jsm: Enable support for Digi Classic adapters
Date: Fri,  7 Nov 2014 00:05:33 +0100
Message-Id: <1415315135-29716-3-git-send-email-bergo.torino@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415315135-29716-2-git-send-email-bergo.torino@gmail.com>
References: <20141106191808.GA32427@kroah.com>
 <1415315135-29716-1-git-send-email-bergo.torino@gmail.com>
 <1415315135-29716-2-git-send-email-bergo.torino@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit enables support for the Digi Classic adapters line in the
jsm driver. This means changes in:
	- device probing code
	- device cleanup code
	- driver description (Kconfig)

The init/cleanup code is based on the staging/dgnc driver.

Signed-off-by: Konrad Zapalowicz <bergo.torino@gmail.com>
---
 drivers/tty/serial/Kconfig          |   4 +-
 drivers/tty/serial/jsm/jsm.h        |   4 +
 drivers/tty/serial/jsm/jsm_driver.c | 151 ++++++++++++++++++++++++++++--------
 drivers/tty/serial/jsm/jsm_tty.c    |   2 +
 4 files changed, 128 insertions(+), 33 deletions(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 649b784..da6570f 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1029,11 +1029,11 @@ config SERIAL_VR41XX_CONSOLE
 	  a console on a serial port, say Y.  Otherwise, say N.
 
 config SERIAL_JSM
-	tristate "Digi International NEO PCI Support"
+	tristate "Digi International NEO and Classic PCI Support"
 	depends on PCI
 	select SERIAL_CORE
 	help
-	  This is a driver for Digi International's Neo series
+	  This is a driver for Digi International's Neo and Classic series
 	  of cards which provide multiple serial ports. You would need
 	  something like this to connect more than two modems to your Linux
 	  box, for instance in order to become a dial-in server. This driver
diff --git a/drivers/tty/serial/jsm/jsm.h b/drivers/tty/serial/jsm/jsm.h
index 3094282..662523d 100644
--- a/drivers/tty/serial/jsm/jsm.h
+++ b/drivers/tty/serial/jsm/jsm.h
@@ -68,6 +68,10 @@ do {								\
 #define MAX_STOPS_SENT	5
 
 /* Board ids */
+#define PCI_DEVICE_ID_CLASSIC_4		0x0028
+#define PCI_DEVICE_ID_CLASSIC_8		0x0029
+#define PCI_DEVICE_ID_CLASSIC_4_422	0x00D0
+#define PCI_DEVICE_ID_CLASSIC_8_422	0x00D1
 #define PCI_DEVICE_ID_NEO_4             0x00B0
 #define PCI_DEVICE_ID_NEO_1_422         0x00CC
 #define PCI_DEVICE_ID_NEO_1_422_485     0x00CD
diff --git a/drivers/tty/serial/jsm/jsm_driver.c b/drivers/tty/serial/jsm/jsm_driver.c
index d2885a7..0927ddf 100644
--- a/drivers/tty/serial/jsm/jsm_driver.c
+++ b/drivers/tty/serial/jsm/jsm_driver.c
@@ -31,8 +31,7 @@
 #include "jsm.h"
 
 MODULE_AUTHOR("Digi International, http://www.digi.com");
-MODULE_DESCRIPTION("Driver for the Digi International "
-		   "Neo PCI based product line");
+MODULE_DESCRIPTION("Driver for the Digi International Neo and Classic PCI based product line");
 MODULE_LICENSE("GPL");
 MODULE_SUPPORTED_DEVICE("jsm");
 
@@ -50,7 +49,7 @@ struct uart_driver jsm_uart_driver = {
 };
 
 static pci_ers_result_t jsm_io_error_detected(struct pci_dev *pdev,
-                                       pci_channel_state_t state);
+					pci_channel_state_t state);
 static pci_ers_result_t jsm_io_slot_reset(struct pci_dev *pdev);
 static void jsm_io_resume(struct pci_dev *pdev);
 
@@ -68,7 +67,7 @@ static int jsm_probe_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int rc = 0;
 	struct jsm_board *brd;
-	static int adapter_count = 0;
+	static int adapter_count;
 
 	rc = pci_enable_device(pdev);
 	if (rc) {
@@ -82,10 +81,8 @@ static int jsm_probe_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_disable_device;
 	}
 
-	brd = kzalloc(sizeof(struct jsm_board), GFP_KERNEL);
+	brd = kzalloc(sizeof(*brd), GFP_KERNEL);
 	if (!brd) {
-		dev_err(&pdev->dev,
-			"memory allocation for board structure failed\n");
 		rc = -ENOMEM;
 		goto out_release_regions;
 	}
@@ -95,7 +92,6 @@ static int jsm_probe_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	brd->pci_dev = pdev;
 
 	switch (pdev->device) {
-
 	case PCI_DEVICE_ID_NEO_2DB9:
 	case PCI_DEVICE_ID_NEO_2DB9PRI:
 	case PCI_DEVICE_ID_NEO_2RJ45:
@@ -104,6 +100,8 @@ static int jsm_probe_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		brd->maxports = 2;
 		break;
 
+	case PCI_DEVICE_ID_CLASSIC_4:
+	case PCI_DEVICE_ID_CLASSIC_4_422:
 	case PCI_DEVICE_ID_NEO_4:
 	case PCIE_DEVICE_ID_NEO_4:
 	case PCIE_DEVICE_ID_NEO_4RJ45:
@@ -111,6 +109,8 @@ static int jsm_probe_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		brd->maxports = 4;
 		break;
 
+	case PCI_DEVICE_ID_CLASSIC_8:
+	case PCI_DEVICE_ID_CLASSIC_8_422:
 	case PCI_DEVICE_ID_DIGI_NEO_8:
 	case PCIE_DEVICE_ID_NEO_8:
 	case PCIE_DEVICE_ID_NEO_8RJ45:
@@ -129,36 +129,109 @@ static int jsm_probe_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	brd->irq = pdev->irq;
 
-	jsm_dbg(INIT, &brd->pci_dev, "jsm_found_board - NEO adapter\n");
+	switch (pdev->device) {
+	case PCI_DEVICE_ID_CLASSIC_4:
+	case PCI_DEVICE_ID_CLASSIC_4_422:
+	case PCI_DEVICE_ID_CLASSIC_8:
+	case PCI_DEVICE_ID_CLASSIC_8_422:
+
+		jsm_dbg(INIT, &brd->pci_dev,
+			"jsm_found_board - Classic adapter\n");
+
+		/*
+		 * For PCI ClassicBoards
+		 * PCI Local Address (.i.e. "resource" number) space
+		 * 0	PLX Memory Mapped Config
+		 * 1	PLX I/O Mapped Config
+		 * 2	I/O Mapped UARTs and Status
+		 * 3	Memory Mapped VPD
+		 * 4	Memory Mapped UARTs and Status
+		 */
+
+		/* Get the PCI Base Address Registers */
+		brd->membase = pci_resource_start(pdev, 4);
+		brd->membase_end = pci_resource_end(pdev, 4);
+
+		if (brd->membase & 0x1)
+			brd->membase &= ~0x3;
+		else
+			brd->membase &= ~0xF;
+
+		brd->iobase = pci_resource_start(pdev, 1);
+		brd->iobase_end = pci_resource_end(pdev, 1);
+		brd->iobase = ((unsigned int)(brd->iobase)) & 0xFFFE;
+
+		/* Assign the board_ops struct */
+		brd->bd_ops = &jsm_cls_ops;
+
+		brd->bd_uart_offset = 0x8;
+		brd->bd_dividend = 921600;
+
+		brd->re_map_membase = ioremap(brd->membase,
+						pci_resource_len(pdev, 4));
+		if (!brd->re_map_membase) {
+			dev_err(&pdev->dev,
+				"Card has no PCI Memory resources, failing board.\n");
+			rc = -ENOMEM;
+			goto out_kfree_brd;
+		}
 
-	/* get the PCI Base Address Registers */
-	brd->membase	= pci_resource_start(pdev, 0);
-	brd->membase_end = pci_resource_end(pdev, 0);
+		/*
+		 * Enable Local Interrupt 1			(0x1),
+		 * Local Interrupt 1 Polarity Active high	(0x2),
+		 * Enable PCI interrupt				(0x43)
+		 */
+		outb(0x43, brd->iobase + 0x4c);
 
-	if (brd->membase & 1)
-		brd->membase &= ~3;
-	else
-		brd->membase &= ~15;
+		break;
 
-	/* Assign the board_ops struct */
-	brd->bd_ops = &jsm_neo_ops;
+	case PCI_DEVICE_ID_NEO_2DB9:
+	case PCI_DEVICE_ID_NEO_2DB9PRI:
+	case PCI_DEVICE_ID_NEO_2RJ45:
+	case PCI_DEVICE_ID_NEO_2RJ45PRI:
+	case PCI_DEVICE_ID_NEO_2_422_485:
+	case PCI_DEVICE_ID_NEO_4:
+	case PCIE_DEVICE_ID_NEO_4:
+	case PCIE_DEVICE_ID_NEO_4RJ45:
+	case PCIE_DEVICE_ID_NEO_4_IBM:
+	case PCI_DEVICE_ID_DIGI_NEO_8:
+	case PCIE_DEVICE_ID_NEO_8:
+	case PCIE_DEVICE_ID_NEO_8RJ45:
 
-	brd->bd_uart_offset = 0x200;
-	brd->bd_dividend = 921600;
+		jsm_dbg(INIT, &brd->pci_dev, "jsm_found_board - NEO adapter\n");
 
-	brd->re_map_membase = ioremap(brd->membase, pci_resource_len(pdev, 0));
-	if (!brd->re_map_membase) {
-		dev_err(&pdev->dev,
-			"card has no PCI Memory resources, "
-			"failing board.\n");
-		rc = -ENOMEM;
-		goto out_kfree_brd;
+		/* get the PCI Base Address Registers */
+		brd->membase	= pci_resource_start(pdev, 0);
+		brd->membase_end = pci_resource_end(pdev, 0);
+
+		if (brd->membase & 1)
+			brd->membase &= ~0x3;
+		else
+			brd->membase &= ~0xF;
+
+		/* Assign the board_ops struct */
+		brd->bd_ops = &jsm_neo_ops;
+
+		brd->bd_uart_offset = 0x200;
+		brd->bd_dividend = 921600;
+
+		brd->re_map_membase = ioremap(brd->membase,
+						pci_resource_len(pdev, 0));
+		if (!brd->re_map_membase) {
+			dev_err(&pdev->dev,
+				"Card has no PCI Memory resources, failing board.\n");
+			rc = -ENOMEM;
+			goto out_kfree_brd;
+		}
+
+		break;
+	default:
+		return -ENXIO;
 	}
 
-	rc = request_irq(brd->irq, brd->bd_ops->intr,
-			IRQF_SHARED, "JSM", brd);
+	rc = request_irq(brd->irq, brd->bd_ops->intr, IRQF_SHARED, "JSM", brd);
 	if (rc) {
-		printk(KERN_WARNING "Failed to hook IRQ %d\n",brd->irq);
+		dev_warn(&pdev->dev, "Failed to hook IRQ %d\n", brd->irq);
 		goto out_iounmap;
 	}
 
@@ -178,7 +251,7 @@ static int jsm_probe_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* Log the information about the board */
-	dev_info(&pdev->dev, "board %d: Digi Neo (rev %d), irq %d\n",
+	dev_info(&pdev->dev, "board %d: Digi Classic/Neo (rev %d), irq %d\n",
 			adapter_count, brd->rev, brd->irq);
 
 	pci_set_drvdata(pdev, brd);
@@ -205,6 +278,18 @@ static void jsm_remove_one(struct pci_dev *pdev)
 	struct jsm_board *brd = pci_get_drvdata(pdev);
 	int i = 0;
 
+	switch (pdev->device) {
+	case PCI_DEVICE_ID_CLASSIC_4:
+	case PCI_DEVICE_ID_CLASSIC_4_422:
+	case PCI_DEVICE_ID_CLASSIC_8:
+	case PCI_DEVICE_ID_CLASSIC_8_422:
+		/* Tell card not to interrupt anymore. */
+		outb(0x0, brd->iobase + 0x4c);
+		break;
+	default:
+		break;
+	}
+
 	jsm_remove_uart_port(brd);
 
 	free_irq(brd->irq, brd);
@@ -239,6 +324,10 @@ static struct pci_device_id jsm_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCIE_DEVICE_ID_NEO_4), 0, 0, 11 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCIE_DEVICE_ID_NEO_4RJ45), 0, 0, 12 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCIE_DEVICE_ID_NEO_8RJ45), 0, 0, 13 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_CLASSIC_4), 0, 0, 14 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_CLASSIC_4_422), 0, 0, 15 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_CLASSIC_8), 0, 0, 16 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_CLASSIC_8_422), 0, 0, 17 },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, jsm_pci_tbl);
diff --git a/drivers/tty/serial/jsm/jsm_tty.c b/drivers/tty/serial/jsm/jsm_tty.c
index 3e5c156..f9b1fbd 100644
--- a/drivers/tty/serial/jsm/jsm_tty.c
+++ b/drivers/tty/serial/jsm/jsm_tty.c
@@ -415,6 +415,8 @@ int jsm_tty_init(struct jsm_board *brd)
 
 		if (brd->bd_uart_offset == 0x200)
 			ch->ch_neo_uart =  vaddr + (brd->bd_uart_offset * i);
+		else
+			ch->ch_cls_uart =  vaddr + (brd->bd_uart_offset * i);
 
 		ch->ch_bd = brd;
 		ch->ch_portnum = i;
-- 
1.9.1

