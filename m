Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759825Ab3DZBrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 21:47:09 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46885 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758931Ab3DZBrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 21:47:06 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Huang Ying <ying.huang@intel.com>
Cc: David Bulkow <David.Bulkow@stratus.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] PCI: Remove duplicate pci_disable_device for pcie port
Date: Thu, 25 Apr 2013 18:47:00 -0700
Message-Id: <1366940820-15302-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <5AA430FFE4486C448003201AC83BC85E03DEA483@EXHQ.corp.stratus.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During chasing one PCI xHCI hotplug problem, David Bulkow found

	static void pcie_portdrv_remove(struct pci_dev *dev)
	{
        	pcie_port_device_remove(dev);
	        pci_disable_device(dev);
	}
and
	void pcie_port_device_remove(struct pci_dev *dev)
	{
        	device_for_each_child(&dev->dev, NULL, remove_iter);
	        cleanup_service_irqs(dev);
	        pci_disable_device(dev);
	}

that extra pci_disable_device in pcie_port_device_remove() was added by
| commit dc5351784eb36f1fec4efa88e01581be72c0b711
| Author: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
| Date:   Wed Nov 25 21:04:00 2009 +0900
|
|    PCI: portdrv: cleanup service irqs initialization

so pci_dsiable_device is called two times.

We should remove extra one in pcie_portdrv_remove.

Reported-by: David Bulkow <David.Bulkow@stratus.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/pcie/portdrv_pci.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6/drivers/pci/pcie/portdrv_pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_pci.c
+++ linux-2.6/drivers/pci/pcie/portdrv_pci.c
@@ -223,7 +223,6 @@ static int pcie_portdrv_probe(struct pci
 static void pcie_portdrv_remove(struct pci_dev *dev)
 {
 	pcie_port_device_remove(dev);
-	pci_disable_device(dev);
 }
 
 static int error_detected_iter(struct device *device, void *data)
