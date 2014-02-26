Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbaBZTlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:41:45 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:38029 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbaBZThb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:37:31 -0500
Subject: [PATCH 4/9] PCI: Mark resources as IORESOURCE_UNSET if we can't
 assign them
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 26 Feb 2014 12:37:29 -0700
Message-ID: <20140226193729.10125.54723.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140226192614.10125.68711.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140226192614.10125.68711.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When assigning addresses to resources, mark them with IORESOURCE_UNSET
before we start and clear IORESOURCE_UNSET if assignment is successful.
That means that if we print the resource during assignment, we will show
the size, not a meaningless address.

Also, clear IORESOURCE_UNSET if we do assign an address, so we print the
address when it is valid.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/pci.c       |    2 ++
 drivers/pci/quirks.c    |    5 +++++
 drivers/pci/rom.c       |    2 ++
 drivers/pci/setup-res.c |    4 ++++
 4 files changed, 13 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 99293fa40db9..dc9ce62be7aa 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4244,6 +4244,7 @@ void pci_reassigndev_resource_alignment(struct pci_dev *dev)
 				"Rounding up size of resource #%d to %#llx.\n",
 				i, (unsigned long long)size);
 		}
+		r->flags |= IORESOURCE_UNSET;
 		r->end = size - 1;
 		r->start = 0;
 	}
@@ -4257,6 +4258,7 @@ void pci_reassigndev_resource_alignment(struct pci_dev *dev)
 			r = &dev->resource[i];
 			if (!(r->flags & IORESOURCE_MEM))
 				continue;
+			r->flags |= IORESOURCE_UNSET;
 			r->end = resource_size(r) - 1;
 			r->start = 0;
 		}
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 5cb726c193de..6e596ab77fb9 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -296,6 +296,7 @@ static void quirk_s3_64M(struct pci_dev *dev)
 	struct resource *r = &dev->resource[0];
 
 	if ((r->start & 0x3ffffff) || r->end != r->start + 0x3ffffff) {
+		r->flags |= IORESOURCE_UNSET;
 		r->start = 0;
 		r->end = 0x3ffffff;
 	}
@@ -937,6 +938,8 @@ DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_FE_GATE_700C
 static void quirk_dunord(struct pci_dev *dev)
 {
 	struct resource *r = &dev->resource [1];
+
+	r->flags |= IORESOURCE_UNSET;
 	r->start = 0;
 	r->end = 0xffffff;
 }
@@ -1740,6 +1743,7 @@ static void quirk_tc86c001_ide(struct pci_dev *dev)
 	struct resource *r = &dev->resource[0];
 
 	if (r->start & 0x8) {
+		r->flags |= IORESOURCE_UNSET;
 		r->start = 0;
 		r->end = 0xf;
 	}
@@ -1769,6 +1773,7 @@ static void quirk_plx_pci9050(struct pci_dev *dev)
 			dev_info(&dev->dev,
 				 "Re-allocating PLX PCI 9050 BAR %u to length 256 to avoid bit 7 bug\n",
 				 bar);
+			r->flags |= IORESOURCE_UNSET;
 			r->start = 0;
 			r->end = 0xff;
 		}
diff --git a/drivers/pci/rom.c b/drivers/pci/rom.c
index 5d595724e5f4..c1839450d4d6 100644
--- a/drivers/pci/rom.c
+++ b/drivers/pci/rom.c
@@ -197,8 +197,10 @@ void pci_unmap_rom(struct pci_dev *pdev, void __iomem *rom)
 void pci_cleanup_rom(struct pci_dev *pdev)
 {
 	struct resource *res = &pdev->resource[PCI_ROM_RESOURCE];
+
 	if (res->flags & IORESOURCE_ROM_COPY) {
 		kfree((void*)(unsigned long)res->start);
+		res->flags |= IORESOURCE_UNSET;
 		res->flags &= ~IORESOURCE_ROM_COPY;
 		res->start = 0;
 		res->end = 0;
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 5c060b152ce6..0474b0217fdf 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -263,6 +263,7 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 	resource_size_t align, size;
 	int ret;
 
+	res->flags |= IORESOURCE_UNSET;
 	align = pci_resource_alignment(dev, res);
 	if (!align) {
 		dev_info(&dev->dev, "BAR %d: can't assign %pR "
@@ -282,6 +283,7 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 		ret = pci_revert_fw_address(res, dev, resno, size);
 
 	if (!ret) {
+		res->flags &= ~IORESOURCE_UNSET;
 		res->flags &= ~IORESOURCE_STARTALIGN;
 		dev_info(&dev->dev, "BAR %d: assigned %pR\n", resno, res);
 		if (resno < PCI_BRIDGE_RESOURCES)
@@ -297,6 +299,7 @@ int pci_reassign_resource(struct pci_dev *dev, int resno, resource_size_t addsiz
 	resource_size_t new_size;
 	int ret;
 
+	res->flags |= IORESOURCE_UNSET;
 	if (!res->parent) {
 		dev_info(&dev->dev, "BAR %d: can't reassign an unassigned resource %pR "
 			 "\n", resno, res);
@@ -307,6 +310,7 @@ int pci_reassign_resource(struct pci_dev *dev, int resno, resource_size_t addsiz
 	new_size = resource_size(res) + addsize;
 	ret = _pci_assign_resource(dev, resno, new_size, min_align);
 	if (!ret) {
+		res->flags &= ~IORESOURCE_UNSET;
 		res->flags &= ~IORESOURCE_STARTALIGN;
 		dev_info(&dev->dev, "BAR %d: reassigned %pR\n", resno, res);
 		if (resno < PCI_BRIDGE_RESOURCES)

