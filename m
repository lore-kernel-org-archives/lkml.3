Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605Ab3LERpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:45:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38358 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757386Ab3LERhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:37:52 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 65/90] PCI: Remove duplicate pci_disable_device() from pcie_portdrv_remove()
Date: Thu,  5 Dec 2013 17:35:47 +0000
Message-Id: <1386264972-5399-66-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/pci/pcie/portdrv_pci.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index e0610bd..7e41b70 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -151,7 +151,6 @@ static int __devinit pcie_portdrv_probe(struct pci_dev *dev,
 static void pcie_portdrv_remove(struct pci_dev *dev)
 {
 	pcie_port_device_remove(dev);
-	pci_disable_device(dev);
 }
 
 static int error_detected_iter(struct device *device, void *data)
-- 
1.8.3.2

