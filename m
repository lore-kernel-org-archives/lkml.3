Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab3L2CLD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:11:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55496 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752250Ab3L2CKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:53 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David Bulkow" <David.Bulkow@stratus.com>,
        "Yinghai Lu" <yinghai@kernel.org>,
        "Mika Westerberg" <mika.westerberg@linux.intel.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.861559681@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 079/185] PCI: Remove duplicate pci_disable_device()
 from pcie_portdrv_remove()
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pci/pcie/portdrv_pci.c | 1 -
 1 file changed, 1 deletion(-)

--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -151,7 +151,6 @@ static int __devinit pcie_portdrv_probe(
 static void pcie_portdrv_remove(struct pci_dev *dev)
 {
 	pcie_port_device_remove(dev);
-	pci_disable_device(dev);
 }
 
 static int error_detected_iter(struct device *device, void *data)

