Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab3DLWqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 18:46:31 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47035 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab3DLWq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 18:46:28 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v4 01/29] PCI: Clean up quirk_io_region
Date: Fri, 12 Apr 2013 15:44:15 -0700
Message-Id: <1365806683-26717-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365806683-26717-1-git-send-email-yinghai@kernel.org>
References: <1365806683-26717-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before every quirk_io_region calling, pci_read_config_word is called.
We can fold that calling into quirk_io_region() to make
code more readable.

According to Bjorn, split this one as separated patch from
addon resource patch.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/quirks.c | 132 ++++++++++++++++++---------------------------------
 1 file changed, 47 insertions(+), 85 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 4273a2d..2dac170 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -324,29 +324,32 @@ static void quirk_cs5536_vsa(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA, quirk_cs5536_vsa);
 
-static void quirk_io_region(struct pci_dev *dev, unsigned region,
-	unsigned size, int nr, const char *name)
+static void quirk_io_region(struct pci_dev *dev, int port,
+				unsigned size, int nr, const char *name)
 {
-	region &= ~(size-1);
-	if (region) {
-		struct pci_bus_region bus_region;
-		struct resource *res = dev->resource + nr;
+	u16 region;
+	struct pci_bus_region bus_region;
+	struct resource *res = dev->resource + nr;
 
-		res->name = pci_name(dev);
-		res->start = region;
-		res->end = region + size - 1;
-		res->flags = IORESOURCE_IO;
+	pci_read_config_word(dev, port, &region);
+	region &= ~(size - 1);
 
-		/* Convert from PCI bus to resource space.  */
-		bus_region.start = res->start;
-		bus_region.end = res->end;
-		pcibios_bus_to_resource(dev, res, &bus_region);
+	if (!region)
+		return;
 
-		if (pci_claim_resource(dev, nr) == 0)
-			dev_info(&dev->dev, "quirk: %pR claimed by %s\n",
-				 res, name);
-	}
-}	
+	res->name = pci_name(dev);
+	res->start = region;
+	res->end = region + size - 1;
+	res->flags = IORESOURCE_IO;
+
+	/* Convert from PCI bus to resource space.  */
+	bus_region.start = res->start;
+	bus_region.end = res->end;
+	pcibios_bus_to_resource(dev, res, &bus_region);
+
+	if (!pci_claim_resource(dev, nr))
+		dev_info(&dev->dev, "quirk: %pR claimed by %s\n", res, name);
+}
 
 /*
  *	ATI Northbridge setups MCE the processor if you even
@@ -374,12 +377,8 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI,	PCI_DEVICE_ID_ATI_RS100,   quirk_ati_
  */
 static void quirk_ali7101_acpi(struct pci_dev *dev)
 {
-	u16 region;
-
-	pci_read_config_word(dev, 0xE0, &region);
-	quirk_io_region(dev, region, 64, PCI_BRIDGE_RESOURCES, "ali7101 ACPI");
-	pci_read_config_word(dev, 0xE2, &region);
-	quirk_io_region(dev, region, 32, PCI_BRIDGE_RESOURCES+1, "ali7101 SMB");
+	quirk_io_region(dev, 0xE0, 64, PCI_BRIDGE_RESOURCES, "ali7101 ACPI");
+	quirk_io_region(dev, 0xE2, 32, PCI_BRIDGE_RESOURCES+1, "ali7101 SMB");
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AL,	PCI_DEVICE_ID_AL_M7101,		quirk_ali7101_acpi);
 
@@ -442,12 +441,10 @@ static void piix4_mem_quirk(struct pci_dev *dev, const char *name, unsigned int
  */
 static void quirk_piix4_acpi(struct pci_dev *dev)
 {
-	u32 region, res_a;
+	u32 res_a;
 
-	pci_read_config_dword(dev, 0x40, &region);
-	quirk_io_region(dev, region, 64, PCI_BRIDGE_RESOURCES, "PIIX4 ACPI");
-	pci_read_config_dword(dev, 0x90, &region);
-	quirk_io_region(dev, region, 16, PCI_BRIDGE_RESOURCES+1, "PIIX4 SMB");
+	quirk_io_region(dev, 0x40, 64, PCI_BRIDGE_RESOURCES, "PIIX4 ACPI");
+	quirk_io_region(dev, 0x90, 16, PCI_BRIDGE_RESOURCES+1, "PIIX4 SMB");
 
 	/* Device resource A has enables for some of the other ones */
 	pci_read_config_dword(dev, 0x5c, &res_a);
@@ -491,7 +488,6 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82443MX_3,	qui
  */
 static void quirk_ich4_lpc_acpi(struct pci_dev *dev)
 {
-	u32 region;
 	u8 enable;
 
 	/*
@@ -503,22 +499,14 @@ static void quirk_ich4_lpc_acpi(struct pci_dev *dev)
 	*/
 
 	pci_read_config_byte(dev, ICH_ACPI_CNTL, &enable);
-	if (enable & ICH4_ACPI_EN) {
-		pci_read_config_dword(dev, ICH_PMBASE, &region);
-		region &= PCI_BASE_ADDRESS_IO_MASK;
-		if (region >= PCIBIOS_MIN_IO)
-			quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES,
-					"ICH4 ACPI/GPIO/TCO");
-	}
+	if (enable & ICH4_ACPI_EN)
+		quirk_io_region(dev, ICH_PMBASE, 128, PCI_BRIDGE_RESOURCES,
+				 "ICH4 ACPI/GPIO/TCO");
 
 	pci_read_config_byte(dev, ICH4_GPIO_CNTL, &enable);
-	if (enable & ICH4_GPIO_EN) {
-		pci_read_config_dword(dev, ICH4_GPIOBASE, &region);
-		region &= PCI_BASE_ADDRESS_IO_MASK;
-		if (region >= PCIBIOS_MIN_IO)
-			quirk_io_region(dev, region, 64,
-					PCI_BRIDGE_RESOURCES + 1, "ICH4 GPIO");
-	}
+	if (enable & ICH4_GPIO_EN)
+		quirk_io_region(dev, ICH4_GPIOBASE, 64, PCI_BRIDGE_RESOURCES+1,
+				"ICH4 GPIO");
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,    PCI_DEVICE_ID_INTEL_82801AA_0,		quirk_ich4_lpc_acpi);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,    PCI_DEVICE_ID_INTEL_82801AB_0,		quirk_ich4_lpc_acpi);
@@ -533,26 +521,17 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,    PCI_DEVICE_ID_INTEL_ESB_1,		qui
 
 static void ich6_lpc_acpi_gpio(struct pci_dev *dev)
 {
-	u32 region;
 	u8 enable;
 
 	pci_read_config_byte(dev, ICH_ACPI_CNTL, &enable);
-	if (enable & ICH6_ACPI_EN) {
-		pci_read_config_dword(dev, ICH_PMBASE, &region);
-		region &= PCI_BASE_ADDRESS_IO_MASK;
-		if (region >= PCIBIOS_MIN_IO)
-			quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES,
-					"ICH6 ACPI/GPIO/TCO");
-	}
+	if (enable & ICH6_ACPI_EN)
+		quirk_io_region(dev, ICH_PMBASE, 128, PCI_BRIDGE_RESOURCES,
+				 "ICH6 ACPI/GPIO/TCO");
 
 	pci_read_config_byte(dev, ICH6_GPIO_CNTL, &enable);
-	if (enable & ICH6_GPIO_EN) {
-		pci_read_config_dword(dev, ICH6_GPIOBASE, &region);
-		region &= PCI_BASE_ADDRESS_IO_MASK;
-		if (region >= PCIBIOS_MIN_IO)
-			quirk_io_region(dev, region, 64,
-					PCI_BRIDGE_RESOURCES + 1, "ICH6 GPIO");
-	}
+	if (enable & ICH6_GPIO_EN)
+		quirk_io_region(dev, ICH6_GPIOBASE, 64, PCI_BRIDGE_RESOURCES+1,
+				"ICH6 GPIO");
 }
 
 static void ich6_lpc_generic_decode(struct pci_dev *dev, unsigned reg, const char *name, int dynsize)
@@ -650,13 +629,9 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_ICH10_1, qui
  */
 static void quirk_vt82c586_acpi(struct pci_dev *dev)
 {
-	u32 region;
-
-	if (dev->revision & 0x10) {
-		pci_read_config_dword(dev, 0x48, &region);
-		region &= PCI_BASE_ADDRESS_IO_MASK;
-		quirk_io_region(dev, region, 256, PCI_BRIDGE_RESOURCES, "vt82c586 ACPI");
-	}
+	if (dev->revision & 0x10)
+		quirk_io_region(dev, 0x48, 256, PCI_BRIDGE_RESOURCES,
+				"vt82c586 ACPI");
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_82C586_3,	quirk_vt82c586_acpi);
 
@@ -668,18 +643,12 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_82C586_3,	quirk_vt
  */
 static void quirk_vt82c686_acpi(struct pci_dev *dev)
 {
-	u16 hm;
-	u32 smb;
-
 	quirk_vt82c586_acpi(dev);
 
-	pci_read_config_word(dev, 0x70, &hm);
-	hm &= PCI_BASE_ADDRESS_IO_MASK;
-	quirk_io_region(dev, hm, 128, PCI_BRIDGE_RESOURCES + 1, "vt82c686 HW-mon");
+	quirk_io_region(dev, 0x70, 128, PCI_BRIDGE_RESOURCES+1,
+				 "vt82c686 HW-mon");
 
-	pci_read_config_dword(dev, 0x90, &smb);
-	smb &= PCI_BASE_ADDRESS_IO_MASK;
-	quirk_io_region(dev, smb, 16, PCI_BRIDGE_RESOURCES + 2, "vt82c686 SMB");
+	quirk_io_region(dev, 0x90, 16, PCI_BRIDGE_RESOURCES+2, "vt82c686 SMB");
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_82C686_4,	quirk_vt82c686_acpi);
 
@@ -690,15 +659,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_82C686_4,	quirk_vt
  */
 static void quirk_vt8235_acpi(struct pci_dev *dev)
 {
-	u16 pm, smb;
-
-	pci_read_config_word(dev, 0x88, &pm);
-	pm &= PCI_BASE_ADDRESS_IO_MASK;
-	quirk_io_region(dev, pm, 128, PCI_BRIDGE_RESOURCES, "vt8235 PM");
-
-	pci_read_config_word(dev, 0xd0, &smb);
-	smb &= PCI_BASE_ADDRESS_IO_MASK;
-	quirk_io_region(dev, smb, 16, PCI_BRIDGE_RESOURCES + 1, "vt8235 SMB");
+	quirk_io_region(dev, 0x88, 128, PCI_BRIDGE_RESOURCES, "vt8235 PM");
+	quirk_io_region(dev, 0xd0, 16, PCI_BRIDGE_RESOURCES+1, "vt8235 SMB");
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8235,	quirk_vt8235_acpi);
 
-- 
1.8.1.4

