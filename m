Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaHDJ1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 05:27:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:16781 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbaHDJ1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 05:27:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,796,1400050800"; 
   d="scan'208";a="579664820"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boon Leong Ong <boon.leong.ong@intel.com>
Subject: [PATCH] USB: pch_udc: USB gadget device support for Intel Quark X1000
Date: Mon,  4 Aug 2014 10:22:54 -0700
Message-Id: <1407172974-22485-1-git-send-email-alvin.chen@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@intel.com>

This patch is to enable the USB gadget device for Intel Quark X1000

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@intel.com>
Signed-off-by: Bing Niu <bing.niu@intel.com>
Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>
---
 drivers/usb/gadget/udc/Kconfig   |    3 ++-
 drivers/usb/gadget/udc/pch_udc.c |   22 +++++++++++++++++++---
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/udc/Kconfig b/drivers/usb/gadget/udc/Kconfig
index 5151f94..34ebaa6 100644
--- a/drivers/usb/gadget/udc/Kconfig
+++ b/drivers/usb/gadget/udc/Kconfig
@@ -332,7 +332,7 @@ config USB_GOKU
 	   gadget drivers to also be dynamically linked.
 
 config USB_EG20T
-	tristate "Intel EG20T PCH/LAPIS Semiconductor IOH(ML7213/ML7831) UDC"
+	tristate "Intel QUARK X1000/EG20T PCH/LAPIS Semiconductor IOH(ML7213/ML7831) UDC"
 	depends on PCI
 	help
 	  This is a USB device driver for EG20T PCH.
@@ -353,6 +353,7 @@ config USB_EG20T
 	  ML7213/ML7831 is companion chip for Intel Atom E6xx series.
 	  ML7213/ML7831 is completely compatible for Intel EG20T PCH.
 
+	  This driver can be used with Intel's Quark X1000 SOC platform
 #
 # LAST -- dummy/emulated controller
 #
diff --git a/drivers/usb/gadget/udc/pch_udc.c b/drivers/usb/gadget/udc/pch_udc.c
index eb8c3be..460d953 100644
--- a/drivers/usb/gadget/udc/pch_udc.c
+++ b/drivers/usb/gadget/udc/pch_udc.c
@@ -343,6 +343,7 @@ struct pch_vbus_gpio_data {
  * @setup_data:		Received setup data
  * @phys_addr:		of device memory
  * @base_addr:		for mapped device memory
+ * @bar:		Indicates which PCI BAR for USB regs
  * @irq:		IRQ line for the device
  * @cfg_data:		current cfg, intf, and alt in use
  * @vbus_gpio:		GPIO informaton for detecting VBUS
@@ -370,14 +371,17 @@ struct pch_udc_dev {
 	struct usb_ctrlrequest		setup_data;
 	unsigned long			phys_addr;
 	void __iomem			*base_addr;
+	unsigned			bar;
 	unsigned			irq;
 	struct pch_udc_cfg_data		cfg_data;
 	struct pch_vbus_gpio_data	vbus_gpio;
 };
 #define to_pch_udc(g)	(container_of((g), struct pch_udc_dev, gadget))
 
+#define PCH_UDC_PCI_BAR_QUARK_X1000	0
 #define PCH_UDC_PCI_BAR			1
 #define PCI_DEVICE_ID_INTEL_EG20T_UDC	0x8808
+#define PCI_DEVICE_ID_INTEL_QUARK_X1000_UDC	0x0939
 #define PCI_VENDOR_ID_ROHM		0x10DB
 #define PCI_DEVICE_ID_ML7213_IOH_UDC	0x801D
 #define PCI_DEVICE_ID_ML7831_IOH_UDC	0x8808
@@ -3076,7 +3080,7 @@ static void pch_udc_remove(struct pci_dev *pdev)
 		iounmap(dev->base_addr);
 	if (dev->mem_region)
 		release_mem_region(dev->phys_addr,
-				   pci_resource_len(pdev, PCH_UDC_PCI_BAR));
+				   pci_resource_len(pdev, dev->bar));
 	if (dev->active)
 		pci_disable_device(pdev);
 	kfree(dev);
@@ -3144,9 +3148,15 @@ static int pch_udc_probe(struct pci_dev *pdev,
 	dev->active = 1;
 	pci_set_drvdata(pdev, dev);
 
+	/* Determine BAR based on PCI ID */
+	if (id->device == PCI_DEVICE_ID_INTEL_QUARK_X1000_UDC)
+		dev->bar = PCH_UDC_PCI_BAR_QUARK_X1000;
+	else
+		dev->bar = PCH_UDC_PCI_BAR;
+
 	/* PCI resource allocation */
-	resource = pci_resource_start(pdev, 1);
-	len = pci_resource_len(pdev, 1);
+	resource = pci_resource_start(pdev, dev->bar);
+	len = pci_resource_len(pdev, dev->bar);
 
 	if (!request_mem_region(resource, len, KBUILD_MODNAME)) {
 		dev_err(&pdev->dev, "%s: pci device used already\n", __func__);
@@ -3212,6 +3222,12 @@ finished:
 
 static const struct pci_device_id pch_udc_pcidev_id[] = {
 	{
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL,
+			   PCI_DEVICE_ID_INTEL_QUARK_X1000_UDC),
+		.class = (PCI_CLASS_SERIAL_USB << 8) | 0xfe,
+		.class_mask = 0xffffffff,
+	},
+	{
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_EG20T_UDC),
 		.class = (PCI_CLASS_SERIAL_USB << 8) | 0xfe,
 		.class_mask = 0xffffffff,
-- 
1.7.9.5

