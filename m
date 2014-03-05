Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854AbaCEO1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:27:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41369 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253AbaCEO1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:27:33 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrew Lunn <andrew@lunn.ch>, Bjorn Helgaas <bhelgaas@google.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 131/131] PCI: mvebu: Use Device ID and revision from underlying endpoint
Date: Wed,  5 Mar 2014 14:24:15 +0000
Message-Id: <1394029455-23128-132-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Lunn <andrew@lunn.ch>

commit 322a8e91844f4ae2093e0d3d8a318d0ef2596756 upstream.

Marvell SoCs place the SoC number into the PCIe endpoint device ID.  The
SoC stepping is placed into the PCIe revision. The old plat-orion PCIe
driver allowed this information to be seen in user space with a simple
lspci command.

The new driver places a virtual PCI-PCI bridge on top of these endpoints.
It has its own hard coded PCI device ID. Thus it is no longer possible to
see what the SoC is using lspci.

When initializing the PCI-PCI bridge, set its device ID and revision from
the underlying endpoint, thus restoring this functionality.  Debian would
like to use this in order to aid installing the correct DTB file.

Fixes: 45361a4fe4464 ("pci: PCIe driver for Marvell Armada 370/XP systems")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
[ luis: backported to 3.11: replaced mvebu_readl() by readl() ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/pci/host/pci-mvebu.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index 7bf3926..86d3fa4 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -56,14 +56,6 @@
 #define PCIE_DEBUG_CTRL         0x1a60
 #define  PCIE_DEBUG_SOFT_RESET		BIT(20)
 
-/*
- * This product ID is registered by Marvell, and used when the Marvell
- * SoC is not the root complex, but an endpoint on the PCIe bus. It is
- * therefore safe to re-use this PCI ID for our emulated PCI-to-PCI
- * bridge.
- */
-#define MARVELL_EMULATED_PCI_PCI_BRIDGE_ID 0x7846
-
 /* PCI configuration space of a PCI-to-PCI bridge */
 struct mvebu_sw_pci_bridge {
 	u16 vendor;
@@ -356,7 +348,8 @@ static void mvebu_sw_pci_bridge_init(struct mvebu_pcie_port *port)
 
 	bridge->class = PCI_CLASS_BRIDGE_PCI;
 	bridge->vendor = PCI_VENDOR_ID_MARVELL;
-	bridge->device = MARVELL_EMULATED_PCI_PCI_BRIDGE_ID;
+	bridge->device = readl(port->base + PCIE_DEV_ID_OFF) >> 16;
+	bridge->revision = readl(port->base + PCIE_DEV_REV_OFF) & 0xff;
 	bridge->header_type = PCI_HEADER_TYPE_BRIDGE;
 	bridge->cache_line_size = 0x10;
 
-- 
1.9.0

