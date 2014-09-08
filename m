Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbaIHQ6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:58:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33752 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbaIHQ6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:58:39 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <jgunthorpe@obsidianresearch.com>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH - v3] PCI: keystone: add a pci quirk to limit mrrs
Date: Mon, 8 Sep 2014 12:58:34 -0400
Message-ID: <1410195514-29945-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keystone PCI controller has a limitation that memory read request
size must not exceed 256 bytes. This is a hardware limitation and
add a quirk to force this limit on all downstream devices by
updating mrrs.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
  -v3: added check for vendor id and use pci_matc_id() to do matching
  -v2: made the quirk happens after tuning
  -v1: changed printk to indicate PCI bdf
 drivers/pci/host/pci-keystone.c |   47 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/pci/host/pci-keystone.c b/drivers/pci/host/pci-keystone.c
index c1cfaef..0a477e5 100644
--- a/drivers/pci/host/pci-keystone.c
+++ b/drivers/pci/host/pci-keystone.c
@@ -42,8 +42,55 @@
 /* DEV_STAT_CTRL */
 #define PCIE_CAP_BASE		0x70
 
+/* PCIE controller device IDs */
+#define PCIE_RC_K2HK		0xb008
+#define PCIE_RC_K2E		0xb009
+#define PCIE_RC_K2L		0xb00a
+
 #define to_keystone_pcie(x)	container_of(x, struct keystone_pcie, pp)
 
+
+
+static void quirk_limit_mrrs(struct pci_dev *dev)
+{
+	struct pci_bus *bus = dev->bus;
+	struct pci_dev *bridge = bus->self;
+	static const struct pci_device_id rc_pci_devids[] = {
+		{ PCI_DEVICE(PCI_VENDOR_ID_TI, PCIE_RC_K2HK),
+		 .class = PCI_CLASS_BRIDGE_PCI << 8, .class_mask = ~0, },
+		{ PCI_DEVICE(PCI_VENDOR_ID_TI, PCIE_RC_K2E),
+		 .class = PCI_CLASS_BRIDGE_PCI << 8, .class_mask = ~0, },
+		{ PCI_DEVICE(PCI_VENDOR_ID_TI, PCIE_RC_K2L),
+		 .class = PCI_CLASS_BRIDGE_PCI << 8, .class_mask = ~0, },
+		{ 0, },
+	};
+
+	if (pci_is_root_bus(bus))
+		return;
+
+	/* look for the host bridge */
+	while (!pci_is_root_bus(bus)) {
+		bridge = bus->self;
+		bus = bus->parent;
+	}
+
+	if (bridge) {
+		/*
+		 * Keystone PCI controller has a h/w limitation of
+		 * 256 bytes maximum read request size. It can't handle
+		 * anything higher than this. So force this limit on
+		 * all downstream devices
+		 */
+		if (pci_match_id(rc_pci_devids, bridge)) {
+			if (pcie_get_readrq(dev) > 256) {
+				dev_info(&dev->dev, "limiting mrrs to 256\n");
+				pcie_set_readrq(dev, 256);
+			}
+		}
+	}
+}
+DECLARE_PCI_FIXUP_ENABLE(PCI_ANY_ID, PCI_ANY_ID, quirk_limit_mrrs);
+
 static int ks_pcie_establish_link(struct keystone_pcie *ks_pcie)
 {
 	struct pcie_port *pp = &ks_pcie->pp;
-- 
1.7.9.5

