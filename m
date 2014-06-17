Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967283AbaFQWBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:01:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54859 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967094AbaFQVwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:52:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 078/212] PCI: mvebu: split PCIe BARs into multiple MBus windows when needed
Date: Tue, 17 Jun 2014 14:42:52 -0700
Message-Id: <1403041506-13646-79-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit 398f5d5e10b6b917cd9d35ef21d545b0afbada22 upstream.

MBus windows are used on Marvell platforms to map certain peripherals
in the physical address space. In the PCIe context, MBus windows are
needed to map PCIe I/O and memory regions in the physical address.

However, those MBus windows can only have power of two sizes, while
PCIe BAR do not necessarily guarantee this. For this reason, the
current pci-mvebu breaks on platforms where PCIe devices have BARs
that don't sum up to a power of two size at the emulated bridge level.

This commit fixes this by allowing the pci-mvebu driver to create
multiple contiguous MBus windows (each having a power of two size) to
cover a given PCIe BAR.

To achieve this, two functions are added: mvebu_pcie_add_windows() and
mvebu_pcie_del_windows() to respectively add and remove all the MBus
windows that are needed to map the provided PCIe region base and
size. The emulated PCI bridge code now calls those functions, instead
of directly calling the mvebu-mbus driver functions.

Fixes: 45361a4fe446 ('pci: PCIe driver for Marvell Armada 370/XP systems')
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Link: https://lkml.kernel.org/r/1397823593-1932-8-git-send-email-thomas.petazzoni@free-electrons.com
Tested-by: Neil Greatorex <neil@fatboyfat.co.uk>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
[ kamal: backport to 3.13-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/pci/host/pci-mvebu.c | 88 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 74 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index 045cbb5..d55291c 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -286,6 +286,58 @@ static int mvebu_pcie_hw_wr_conf(struct mvebu_pcie_port *port,
 	return PCIBIOS_SUCCESSFUL;
 }
 
+/*
+ * Remove windows, starting from the largest ones to the smallest
+ * ones.
+ */
+static void mvebu_pcie_del_windows(struct mvebu_pcie_port *port,
+				   phys_addr_t base, size_t size)
+{
+	while (size) {
+		size_t sz = 1 << (fls(size) - 1);
+
+		mvebu_mbus_del_window(base, sz);
+		base += sz;
+		size -= sz;
+	}
+}
+
+/*
+ * MBus windows can only have a power of two size, but PCI BARs do not
+ * have this constraint. Therefore, we have to split the PCI BAR into
+ * areas each having a power of two size. We start from the largest
+ * one (i.e highest order bit set in the size).
+ */
+static void mvebu_pcie_add_windows(struct mvebu_pcie_port *port,
+				   unsigned int target, unsigned int attribute,
+				   phys_addr_t base, size_t size,
+				   phys_addr_t remap)
+{
+	size_t size_mapped = 0;
+
+	while (size) {
+		size_t sz = 1 << (fls(size) - 1);
+		int ret;
+
+		ret = mvebu_mbus_add_window_remap_by_id(target, attribute, base,
+							sz, remap);
+		if (ret) {
+			dev_err(&port->pcie->pdev->dev,
+				"Could not create MBus window at 0x%x, size 0x%x: %d\n",
+				base, sz, ret);
+			mvebu_pcie_del_windows(port, base - size_mapped,
+					       size_mapped);
+			return;
+		}
+
+		size -= sz;
+		size_mapped += sz;
+		base += sz;
+		if (remap != MVEBU_MBUS_NO_REMAP)
+			remap += sz;
+	}
+}
+
 static void mvebu_pcie_handle_iobase_change(struct mvebu_pcie_port *port)
 {
 	phys_addr_t iobase;
@@ -296,8 +348,8 @@ static void mvebu_pcie_handle_iobase_change(struct mvebu_pcie_port *port)
 
 		/* If a window was configured, remove it */
 		if (port->iowin_base) {
-			mvebu_mbus_del_window(port->iowin_base,
-					      port->iowin_size);
+			mvebu_pcie_del_windows(port, port->iowin_base,
+					       port->iowin_size);
 			port->iowin_base = 0;
 			port->iowin_size = 0;
 		}
@@ -319,9 +371,9 @@ static void mvebu_pcie_handle_iobase_change(struct mvebu_pcie_port *port)
 			    (port->bridge.iolimitupper << 16)) -
 			    iobase) + 1;
 
-	mvebu_mbus_add_window_remap_by_id(port->io_target, port->io_attr,
-					  port->iowin_base, port->iowin_size,
-					  iobase);
+	mvebu_pcie_add_windows(port, port->io_target, port->io_attr,
+			       port->iowin_base, port->iowin_size,
+			       iobase);
 
 	pci_ioremap_io(iobase, port->iowin_base);
 }
@@ -333,8 +385,8 @@ static void mvebu_pcie_handle_membase_change(struct mvebu_pcie_port *port)
 
 		/* If a window was configured, remove it */
 		if (port->memwin_base) {
-			mvebu_mbus_del_window(port->memwin_base,
-					      port->memwin_size);
+			mvebu_pcie_del_windows(port, port->memwin_base,
+					       port->memwin_size);
 			port->memwin_base = 0;
 			port->memwin_size = 0;
 		}
@@ -353,8 +405,9 @@ static void mvebu_pcie_handle_membase_change(struct mvebu_pcie_port *port)
 		(((port->bridge.memlimit & 0xFFF0) << 16) | 0xFFFFF) -
 		port->memwin_base + 1;
 
-	mvebu_mbus_add_window_by_id(port->mem_target, port->mem_attr,
-				    port->memwin_base, port->memwin_size);
+	mvebu_pcie_add_windows(port, port->mem_target, port->mem_attr,
+			       port->memwin_base, port->memwin_size,
+			       MVEBU_MBUS_NO_REMAP);
 }
 
 /*
@@ -695,14 +748,21 @@ static resource_size_t mvebu_pcie_align_resource(struct pci_dev *dev,
 
 	/*
 	 * On the PCI-to-PCI bridge side, the I/O windows must have at
-	 * least a 64 KB size and be aligned on their size, and the
-	 * memory windows must have at least a 1 MB size and be
-	 * aligned on their size
+	 * least a 64 KB size and the memory windows must have at
+	 * least a 1 MB size. Moreover, MBus windows need to have a
+	 * base address aligned on their size, and their size must be
+	 * a power of two. This means that if the BAR doesn't have a
+	 * power of two size, several MBus windows will actually be
+	 * created. We need to ensure that the biggest MBus window
+	 * (which will be the first one) is aligned on its size, which
+	 * explains the rounddown_pow_of_two() being done here.
 	 */
 	if (res->flags & IORESOURCE_IO)
-		return round_up(start, max((resource_size_t)SZ_64K, size));
+		return round_up(start, max((resource_size_t)SZ_64K,
+					    rounddown_pow_of_two(size)));
 	else if (res->flags & IORESOURCE_MEM)
-		return round_up(start, max((resource_size_t)SZ_1M, size));
+		return round_up(start, max((resource_size_t)SZ_1M,
+					    rounddown_pow_of_two(size)));
 	else
 		return start;
 }
-- 
1.9.1

