Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718AbaFQF1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 01:27:50 -0400
Received: from mga14.intel.com ([192.55.52.115]:21078 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932165AbaFQF1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 01:27:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,492,1400050800"; 
   d="scan'208";a="549015211"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [RFC Patch V2 08/16] PCI: kill wrong warning message in pcieport driver
Date: Tue, 17 Jun 2014 13:29:47 +0800
Message-Id: <1402982995-13747-9-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402982995-13747-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402982995-13747-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For hot-added PCIe ports, it always generates a warning message on x86
platforms when binding to pcieport driver as:
	"device [8086:0e0b] has invalid IRQ; check vendor BIOS".

It's due to that we check pci_dev->irq before actually allocating IRQ
number for the PCI device:
	if (!dev->irq && dev->pin) {
		dev_warn(&dev->dev, "device [%04x:%04x] has invalid IRQ; "
			 "check vendor BIOS\n", dev->vendor, dev->device);
	}
 	status = pcie_port_device_register(dev);
		-->pci_enable_device(dev);
			-->pci_enable_device_flags()
				-->do_pci_enable_device()
					-->pcibios_enable_device()
						-->pcibios_enable_irq()

This warning message isn't generated for PCIe ports present at boot time
because x86 arch code has called acpi_pci_irq_enable() in pci_acpi_init()
for each PCI device for safety.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/pci/pcie/portdrv_pci.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index 0d8fdc48e642..0e35f9670066 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -203,10 +203,6 @@ static int pcie_portdrv_probe(struct pci_dev *dev,
 	     (pci_pcie_type(dev) != PCI_EXP_TYPE_DOWNSTREAM)))
 		return -ENODEV;
 
-	if (!dev->irq && dev->pin) {
-		dev_warn(&dev->dev, "device [%04x:%04x] has invalid IRQ; "
-			 "check vendor BIOS\n", dev->vendor, dev->device);
-	}
 	status = pcie_port_device_register(dev);
 	if (status)
 		return status;
-- 
1.7.10.4

