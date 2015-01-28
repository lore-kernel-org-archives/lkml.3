Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760058AbbA1B2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:28:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41026 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759802AbbA1B2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marek Kordik <kordikmarek@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 3.18 18/61] PCI: Pass bridge device, not bus, when updating bridge windows
Date: Tue, 27 Jan 2015 17:26:30 -0800
Message-Id: <20150128012639.023033446@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit 3f2f4dc456e9f80849b99d79600a7257690ca4b1 upstream.

pci_setup_bridge_io(), pci_setup_bridge_mmio(), and
pci_setup_bridge_mmio_pref() program the windows of PCI-PCI bridges.
Previously they accepted a pointer to the pci_bus of the secondary bus,
then looked up the bridge leading to that bus.  Pass the bridge directly,
which will make it more convenient for future callers.

No functional change.

[bhelgaas: changelog, split into separate patch]
Link: https://bugzilla.kernel.org/show_bug.cgi?id=85491
Reported-by: Marek Kordik <kordikmarek@gmail.com>
Fixes: 5b28541552ef ("PCI: Restrict 64-bit prefetchable bridge windows to 64-bit resources")
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/setup-bus.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -530,9 +530,8 @@ EXPORT_SYMBOL(pci_setup_cardbus);
    config space writes, so it's quite possible that an I/O window of
    the bridge will have some undesirable address (e.g. 0) after the
    first write. Ditto 64-bit prefetchable MMIO.  */
-static void pci_setup_bridge_io(struct pci_bus *bus)
+static void pci_setup_bridge_io(struct pci_dev *bridge)
 {
-	struct pci_dev *bridge = bus->self;
 	struct resource *res;
 	struct pci_bus_region region;
 	unsigned long io_mask;
@@ -545,7 +544,7 @@ static void pci_setup_bridge_io(struct p
 		io_mask = PCI_IO_1K_RANGE_MASK;
 
 	/* Set up the top and bottom of the PCI I/O segment for this bus. */
-	res = bus->resource[0];
+	res = &bridge->resource[PCI_BRIDGE_RESOURCES + 0];
 	pcibios_resource_to_bus(bridge->bus, &region, res);
 	if (res->flags & IORESOURCE_IO) {
 		pci_read_config_word(bridge, PCI_IO_BASE, &l);
@@ -568,15 +567,14 @@ static void pci_setup_bridge_io(struct p
 	pci_write_config_dword(bridge, PCI_IO_BASE_UPPER16, io_upper16);
 }
 
-static void pci_setup_bridge_mmio(struct pci_bus *bus)
+static void pci_setup_bridge_mmio(struct pci_dev *bridge)
 {
-	struct pci_dev *bridge = bus->self;
 	struct resource *res;
 	struct pci_bus_region region;
 	u32 l;
 
 	/* Set up the top and bottom of the PCI Memory segment for this bus. */
-	res = bus->resource[1];
+	res = &bridge->resource[PCI_BRIDGE_RESOURCES + 1];
 	pcibios_resource_to_bus(bridge->bus, &region, res);
 	if (res->flags & IORESOURCE_MEM) {
 		l = (region.start >> 16) & 0xfff0;
@@ -588,9 +586,8 @@ static void pci_setup_bridge_mmio(struct
 	pci_write_config_dword(bridge, PCI_MEMORY_BASE, l);
 }
 
-static void pci_setup_bridge_mmio_pref(struct pci_bus *bus)
+static void pci_setup_bridge_mmio_pref(struct pci_dev *bridge)
 {
-	struct pci_dev *bridge = bus->self;
 	struct resource *res;
 	struct pci_bus_region region;
 	u32 l, bu, lu;
@@ -602,7 +599,7 @@ static void pci_setup_bridge_mmio_pref(s
 
 	/* Set up PREF base/limit. */
 	bu = lu = 0;
-	res = bus->resource[2];
+	res = &bridge->resource[PCI_BRIDGE_RESOURCES + 2];
 	pcibios_resource_to_bus(bridge->bus, &region, res);
 	if (res->flags & IORESOURCE_PREFETCH) {
 		l = (region.start >> 16) & 0xfff0;
@@ -630,13 +627,13 @@ static void __pci_setup_bridge(struct pc
 		 &bus->busn_res);
 
 	if (type & IORESOURCE_IO)
-		pci_setup_bridge_io(bus);
+		pci_setup_bridge_io(bridge);
 
 	if (type & IORESOURCE_MEM)
-		pci_setup_bridge_mmio(bus);
+		pci_setup_bridge_mmio(bridge);
 
 	if (type & IORESOURCE_PREFETCH)
-		pci_setup_bridge_mmio_pref(bus);
+		pci_setup_bridge_mmio_pref(bridge);
 
 	pci_write_config_word(bridge, PCI_BRIDGE_CONTROL, bus->bridge_ctl);
 }


