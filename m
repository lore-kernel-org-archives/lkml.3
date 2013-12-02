Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab3LBT5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:57:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39200 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab3LBTSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Bulkow <David.Bulkow@stratus.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 3.12 110/212] PCI: Remove duplicate pci_disable_device() from pcie_portdrv_remove()
Date: Mon,  2 Dec 2013 11:15:01 -0800
Message-Id: <20131202191259.526492554@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit e7cc5cf74544d97d7b69e2701595037474db1f96 upstream.

The pcie_portdrv .probe() method calls pci_enable_device() once, in
pcie_port_device_register(), but the .remove() method calls
pci_disable_device() twice, in pcie_port_device_remove() and in
pcie_portdrv_remove().

That causes a "disabling already-disabled device" warning when removing a
PCIe port device.  This happens all the time when removing Thunderbolt
devices, but is also easy to reproduce with, e.g.,
"echo 0000:00:1c.3 > /sys/bus/pci/drivers/pcieport/unbind"

This patch removes the disable from pcie_portdrv_remove().

[bhelgaas: changelog, tag for stable]
Reported-by: David Bulkow <David.Bulkow@stratus.com>
Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pcie/portdrv_pci.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -223,7 +223,6 @@ static int pcie_portdrv_probe(struct pci
 static void pcie_portdrv_remove(struct pci_dev *dev)
 {
 	pcie_port_device_remove(dev);
-	pci_disable_device(dev);
 }
 
 static int error_detected_iter(struct device *device, void *data)


