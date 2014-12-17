Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbaLQSC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 13:02:57 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:40273 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbaLQSCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 13:02:54 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
To: <gregkh@linuxfoundation.org>, <vinod.koul@intel.com>,
        <dmaengine@vger.kernel.org>, <bhelgaas@google.com>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [RFC PATCH 2/2] PCI: get device dma configuration from parent
Date: Wed, 17 Dec 2014 13:02:24 -0500
Message-ID: <1418839344-14393-3-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418839344-14393-1-git-send-email-m-karicheri2@ti.com>
References: <1418839344-14393-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes use of the helper function dma_get_parent_cfg() to
get dma configuration from the parent of the root bus bridge device.
One particular comfiguration that is required for Keystone PCI devices
to function correctly is the dma_pfn_offset that has to be correctly
set in the pci device's device structure in order for getting the
dma_mask right for the device.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 drivers/pci/probe.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index c8ca98c..8f4d55b 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1519,6 +1519,8 @@ static void pci_init_capabilities(struct pci_dev *dev)
 
 void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
 {
+	struct pci_bus *temp_bus = bus;
+	struct device *parent;
 	int ret;
 
 	pci_configure_device(dev);
@@ -1527,9 +1529,21 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
 	dev->dev.release = pci_release_dev;
 
 	set_dev_node(&dev->dev, pcibus_to_node(bus));
-	dev->dev.dma_mask = &dev->dma_mask;
-	dev->dev.dma_parms = &dev->dma_parms;
-	dev->dev.coherent_dma_mask = 0xffffffffull;
+	/*
+	 * look for host bridge and check if the dma parameters
+	 * can be copied from parent
+	 */
+	while (!pci_is_root_bus(temp_bus))
+		temp_bus = temp_bus->parent;
+
+	parent = temp_bus->bridge->parent;
+
+	/* override with parent dma configuration if available */
+	if (dma_get_parent_cfg(&dev->dev, parent) < 0) {
+		dev->dev.dma_mask = &dev->dma_mask;
+		dev->dev.dma_parms = &dev->dma_parms;
+		dev->dev.coherent_dma_mask = 0xffffffffull;
+	}
 
 	pci_set_dma_max_seg_size(dev, 65536);
 	pci_set_dma_seg_boundary(dev, 0xffffffff);
-- 
1.7.9.5

