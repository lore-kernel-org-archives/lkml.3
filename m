Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbaHFPSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 11:18:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44613 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbaHFPSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 11:18:34 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-pci@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <bhelgaas@google.com>
CC: <jgunthorpe@obsidianresearch.com>, Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH] PCI: keystone: add a pci quirk to limit mrrs
Date: Wed, 6 Aug 2014 11:18:20 -0400
Message-ID: <1407338300-9146-1-git-send-email-m-karicheri2@ti.com>
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
 This applies on top of the Keystone PCI controller patch series
 at http://thread.gmane.org/gmane.linux.kernel.pci/33523
 drivers/pci/host/pci-keystone.c |   40 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/pci/host/pci-keystone.c b/drivers/pci/host/pci-keystone.c
index c1cfaef..541ab24 100644
--- a/drivers/pci/host/pci-keystone.c
+++ b/drivers/pci/host/pci-keystone.c
@@ -42,8 +42,48 @@
 /* DEV_STAT_CTRL */
 #define PCIE_CAP_BASE		0x70
 
+/* PCIE controller device IDs */
+#define PCIE_RC_K2HK		0xb008
+#define PCIE_RC_K2E		0xb009
+#define PCIE_RC_K2L		0xb00a
+
 #define to_keystone_pcie(x)	container_of(x, struct keystone_pcie, pp)
 
+static void quirk_limit_mrrs(struct pci_dev *dev)
+{
+	struct pci_bus *bus = dev->bus;
+	struct pci_dev *bridge = bus->self;
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
+		u16 id;
+
+		/*
+		 * Keystone PCI controller has a h/w limitation of
+		 * 256 bytes maximum read request size. It can't handle
+		 * anything higher than this. So force this limit on
+		 * all downstream devices
+		 */
+		pci_read_config_word(bridge, PCI_DEVICE_ID, &id);
+		if ((id == PCIE_RC_K2HK) || (id == PCIE_RC_K2E) ||
+		    (id == PCIE_RC_K2L)) {
+			if (pcie_get_readrq(dev) > 256) {
+				pr_info("limiting mrrs to 256\n");
+				pcie_set_readrq(dev, 256);
+			}
+		}
+	}
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, quirk_limit_mrrs);
+
 static int ks_pcie_establish_link(struct keystone_pcie *ks_pcie)
 {
 	struct pcie_port *pp = &ks_pcie->pp;
-- 
1.7.9.5

