Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab3DLWqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 18:46:10 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47468 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3DLWqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 18:46:07 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v4 28/29] PCI: Make quirk_io_region to use addon_res
Date: Fri, 12 Apr 2013 15:44:42 -0700
Message-Id: <1365806683-26717-29-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365806683-26717-1-git-send-email-yinghai@kernel.org>
References: <1365806683-26717-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After they are put in add-on resources, they will be safely claimed later.

-v2: According to Bjorn, split change about quirk_io_region calling
     pci_read_config_word to another patch.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/quirks.c | 91 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 57 insertions(+), 34 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 6706182..53aea7c9 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -324,12 +324,52 @@ static void quirk_cs5536_vsa(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA, quirk_cs5536_vsa);
 
-static void quirk_io_region(struct pci_dev *dev, int port,
-				unsigned size, int nr, const char *name)
+static int quirk_read_io(struct pci_dev *dev, struct resource *res, int port)
 {
+	struct pci_bus_region bus_region;
 	u16 region;
+	unsigned size = to_pci_dev_addon_resource(res)->size;
+
+	pci_read_config_word(dev, port, &region);
+	region &= ~(size - 1);
+
+	/* Convert from PCI bus to resource space.  */
+	bus_region.start = region;
+	bus_region.end = region + size - 1;
+
+	pcibios_bus_to_resource(dev, res, &bus_region);
+
+	res->flags |= IORESOURCE_IO;
+	dev_info(&dev->dev, "PIO at %pR\n", res);
+
+	return 0;
+}
+static int quirk_write_io(struct pci_dev *dev, struct resource *res, int port)
+{
 	struct pci_bus_region bus_region;
-	struct resource *res = dev->resource + nr;
+	u16 region;
+	unsigned size = to_pci_dev_addon_resource(res)->size;
+
+	pci_read_config_word(dev, port, &region);
+	region &= size - 1;
+
+	/* Convert to PCI bus space.  */
+	pcibios_resource_to_bus(dev, &bus_region, res);
+	region |= bus_region.start & (~(size - 1));
+
+	pci_write_config_word(dev, port, region);
+
+	return 0;
+}
+static struct resource_ops quirk_io_ops = {
+	.read = quirk_read_io,
+	.write = quirk_write_io,
+};
+
+static void quirk_io_region(struct pci_dev *dev, int port,
+					unsigned size, char *name)
+{
+	u16 region;
 
 	pci_read_config_word(dev, port, &region);
 	region &= ~(size - 1);
@@ -337,18 +377,7 @@ static void quirk_io_region(struct pci_dev *dev, int port,
 	if (!region)
 		return;
 
-	res->name = pci_name(dev);
-	res->start = region;
-	res->end = region + size - 1;
-	res->flags = IORESOURCE_IO;
-
-	/* Convert from PCI bus to resource space.  */
-	bus_region.start = res->start;
-	bus_region.end = res->end;
-	pcibios_bus_to_resource(dev, res, &bus_region);
-
-	if (!pci_claim_resource(dev, nr))
-		dev_info(&dev->dev, "quirk: %pR claimed by %s\n", res, name);
+	pci_add_dev_addon_resource(dev, port, size, &quirk_io_ops, name);
 }
 
 /*
@@ -377,8 +406,8 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI,	PCI_DEVICE_ID_ATI_RS100,   quirk_ati_
  */
 static void quirk_ali7101_acpi(struct pci_dev *dev)
 {
-	quirk_io_region(dev, 0xE0, 64, PCI_BRIDGE_RESOURCES, "ali7101 ACPI");
-	quirk_io_region(dev, 0xE2, 32, PCI_BRIDGE_RESOURCES+1, "ali7101 SMB");
+	quirk_io_region(dev, 0xE0, 64, "ali7101 ACPI");
+	quirk_io_region(dev, 0xE2, 32, "ali7101 SMB");
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AL,	PCI_DEVICE_ID_AL_M7101,		quirk_ali7101_acpi);
 
@@ -506,8 +535,8 @@ static void quirk_piix4_acpi(struct pci_dev *dev)
 {
 	u32 res_a;
 
-	quirk_io_region(dev, 0x40, 64, PCI_BRIDGE_RESOURCES, "PIIX4 ACPI");
-	quirk_io_region(dev, 0x90, 16, PCI_BRIDGE_RESOURCES+1, "PIIX4 SMB");
+	quirk_io_region(dev, 0x40, 64, "PIIX4 ACPI");
+	quirk_io_region(dev, 0x90, 16, "PIIX4 SMB");
 
 	/* Device resource A has enables for some of the other ones */
 	pci_read_config_dword(dev, 0x5c, &res_a);
@@ -563,13 +592,11 @@ static void quirk_ich4_lpc_acpi(struct pci_dev *dev)
 
 	pci_read_config_byte(dev, ICH_ACPI_CNTL, &enable);
 	if (enable & ICH4_ACPI_EN)
-		quirk_io_region(dev, ICH_PMBASE, 128, PCI_BRIDGE_RESOURCES,
-				 "ICH4 ACPI/GPIO/TCO");
+		quirk_io_region(dev, ICH_PMBASE, 128, "ICH4 ACPI/GPIO/TCO");
 
 	pci_read_config_byte(dev, ICH4_GPIO_CNTL, &enable);
 	if (enable & ICH4_GPIO_EN)
-		quirk_io_region(dev, ICH4_GPIOBASE, 64, PCI_BRIDGE_RESOURCES+1,
-				"ICH4 GPIO");
+		quirk_io_region(dev, ICH4_GPIOBASE, 64, "ICH4 GPIO");
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,    PCI_DEVICE_ID_INTEL_82801AA_0,		quirk_ich4_lpc_acpi);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,    PCI_DEVICE_ID_INTEL_82801AB_0,		quirk_ich4_lpc_acpi);
@@ -588,13 +615,11 @@ static void ich6_lpc_acpi_gpio(struct pci_dev *dev)
 
 	pci_read_config_byte(dev, ICH_ACPI_CNTL, &enable);
 	if (enable & ICH6_ACPI_EN)
-		quirk_io_region(dev, ICH_PMBASE, 128, PCI_BRIDGE_RESOURCES,
-				 "ICH6 ACPI/GPIO/TCO");
+		quirk_io_region(dev, ICH_PMBASE, 128, "ICH6 ACPI/GPIO/TCO");
 
 	pci_read_config_byte(dev, ICH6_GPIO_CNTL, &enable);
 	if (enable & ICH6_GPIO_EN)
-		quirk_io_region(dev, ICH6_GPIOBASE, 64, PCI_BRIDGE_RESOURCES+1,
-				"ICH6 GPIO");
+		quirk_io_region(dev, ICH6_GPIOBASE, 64, "ICH6 GPIO");
 }
 
 static void ich6_lpc_generic_decode(struct pci_dev *dev, unsigned reg, const char *name, int dynsize)
@@ -693,8 +718,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_ICH10_1, qui
 static void quirk_vt82c586_acpi(struct pci_dev *dev)
 {
 	if (dev->revision & 0x10)
-		quirk_io_region(dev, 0x48, 256, PCI_BRIDGE_RESOURCES,
-				"vt82c586 ACPI");
+		quirk_io_region(dev, 0x48, 256, "vt82c586 ACPI");
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_82C586_3,	quirk_vt82c586_acpi);
 
@@ -708,10 +732,9 @@ static void quirk_vt82c686_acpi(struct pci_dev *dev)
 {
 	quirk_vt82c586_acpi(dev);
 
-	quirk_io_region(dev, 0x70, 128, PCI_BRIDGE_RESOURCES+1,
-				 "vt82c686 HW-mon");
+	quirk_io_region(dev, 0x70, 128, "vt82c686 HW-mon");
 
-	quirk_io_region(dev, 0x90, 16, PCI_BRIDGE_RESOURCES+2, "vt82c686 SMB");
+	quirk_io_region(dev, 0x90, 16, "vt82c686 SMB");
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_82C686_4,	quirk_vt82c686_acpi);
 
@@ -722,8 +745,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_82C686_4,	quirk_vt
  */
 static void quirk_vt8235_acpi(struct pci_dev *dev)
 {
-	quirk_io_region(dev, 0x88, 128, PCI_BRIDGE_RESOURCES, "vt8235 PM");
-	quirk_io_region(dev, 0xd0, 16, PCI_BRIDGE_RESOURCES+1, "vt8235 SMB");
+	quirk_io_region(dev, 0x88, 128, "vt8235 PM");
+	quirk_io_region(dev, 0xd0, 16, "vt8235 SMB");
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8235,	quirk_vt8235_acpi);
 
-- 
1.8.1.4

