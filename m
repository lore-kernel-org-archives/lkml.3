Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187AbaE1O13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 10:27:29 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33824 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425AbaE1O0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 10:26:52 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-pci@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: [PATCH] ARM: pci: add call to pcie_bus_configure_settings()
Date: Wed, 28 May 2014 10:26:16 -0400
Message-ID: <1401287176-4986-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI core supports PCIE_BUS_SAFE and PCIE_BUS_PERFORMANCE modes.
PCI controllers may not be able to handle pay load size higher
than MPS and also read data size higher than MRSS. So limit the
max to the least common supported payload size by calling
pcie_bus_configure_settings(). Using pci=pcie_bus_safe do a walk
and set the MPS to least common value used by devices on the bus.
pci=pcie_bus_perf does do a walk and set MRSS to MPS.

This is suggested as a better solution than pci quirk to do similar
thing.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

CC: Russell King <linux@arm.linux.org.uk>
CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 arch/arm/kernel/bios32.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index 16d43cd..537f99e 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -545,6 +545,18 @@ void pci_common_init_dev(struct device *parent, struct hw_pci *hw)
 		 */
 		pci_bus_add_devices(bus);
 	}
+
+	list_for_each_entry(sys, &head, node) {
+		struct pci_bus *bus = sys->bus;
+
+		/* Configure PCI Express settings */
+		if (bus && !pci_has_flag(PCI_PROBE_ONLY)) {
+			struct pci_bus *child;
+
+			list_for_each_entry(child, &bus->children, node)
+			pcie_bus_configure_settings(child);
+		}
+	}
 }
 
 #ifndef CONFIG_PCI_HOST_ITE8152
-- 
1.7.9.5

