Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764262Ab3DDSBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 14:01:15 -0400
Received: from arrakis.dune.hu ([78.24.191.176]:59925 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764216Ab3DDSBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 14:01:11 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/2] MIPS: implement pcibios_get_phb_of_node
Date: Thu,  4 Apr 2013 20:01:23 +0200
Message-Id: <1365098483-26821-2-git-send-email-juhosg@openwrt.org>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1365098483-26821-1-git-send-email-juhosg@openwrt.org>
References: <1365098483-26821-1-git-send-email-juhosg@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of_node field of the device assigned to a
PCI bus is used during scanning of the PCI bus.
However on MIPS, the of_node field is assigned
only after the bus has been scanned.

Implement the architecture specific version of
'pcibios_get_phb_of_node'. Which ensures that the
PCI driver core will initialize the of_node field
before starting the scan.

Also remove the local assignment of bus->dev.of_node,
it is not needed after the patch.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 arch/mips/pci/pci.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/mips/pci/pci.c b/arch/mips/pci/pci.c
index 0872f12..594e60d 100644
--- a/arch/mips/pci/pci.c
+++ b/arch/mips/pci/pci.c
@@ -115,7 +115,6 @@ static void pcibios_scanbus(struct pci_controller *hose)
 			pci_bus_assign_resources(bus);
 			pci_enable_bridges(bus);
 		}
-		bus->dev.of_node = hose->of_node;
 	}
 }
 
@@ -169,6 +168,13 @@ void pci_load_of_ranges(struct pci_controller *hose, struct device_node *node)
 		}
 	}
 }
+
+struct device_node *pcibios_get_phb_of_node(struct pci_bus *bus)
+{
+	struct pci_controller *hose = bus->sysdata;
+
+	return of_node_get(hose->of_node);
+}
 #endif
 
 static DEFINE_MUTEX(pci_scan_mutex);
-- 
1.7.10

