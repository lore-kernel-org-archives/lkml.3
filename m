Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451AbaCDU7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:59:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697AbaCDUEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.13 112/172] PCI: mvebu: Use Device ID and revision from underlying endpoint
Date: Tue,  4 Mar 2014 12:03:16 -0800
Message-Id: <20140304200303.292068608@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/host/pci-mvebu.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -60,14 +60,6 @@
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
@@ -377,7 +369,8 @@ static void mvebu_sw_pci_bridge_init(str
 
 	bridge->class = PCI_CLASS_BRIDGE_PCI;
 	bridge->vendor = PCI_VENDOR_ID_MARVELL;
-	bridge->device = MARVELL_EMULATED_PCI_PCI_BRIDGE_ID;
+	bridge->device = mvebu_readl(port, PCIE_DEV_ID_OFF) >> 16;
+	bridge->revision = mvebu_readl(port, PCIE_DEV_REV_OFF) & 0xff;
 	bridge->header_type = PCI_HEADER_TYPE_BRIDGE;
 	bridge->cache_line_size = 0x10;
 


