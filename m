Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbaEEUUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:20:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbaEEUUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:20:52 -0400
Subject: [PATCH] PCI: Test for std config alias when testing extended config
 space
From: Alex Williamson <alex.williamson@redhat.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Mon, 05 May 2014 14:20:51 -0600
Message-ID: <20140505201835.2466.46125.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a PCI-to-PCIe bridge is stacked on a PCIe-to-PCI bridge, we can
have PCIe endpoints masked by a conventional PCI bus.  This makes the
extended config space of the PCIe endpoing inaccessible.  The PCIe-to-
PCI bridge is supposed to handle any type 1 configuration transactions
where the extended config offset bits are non-zero as an Unsupported
Request rather than forward it to the secondary interface.  As noted
here, there are a couple known offenders to this rule.  These bridges
drop the extended offset bits, resulting in the conventional config
space being aliased many times across the extended config space.  For
Intel NICs, this alias often seems to expose a bogus SR-IOV cap.

Stacking bridges may seem like an uncommon scenario, but note that the
any conventional PCI slot in a modern PC is already the secondary
interface of an onboard PCIe-to-PCI bridge.  The user need only add
a PCI-to-PCIe adapter and PCIe device to encounter this problem.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/probe.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index ef09f5f..fdb0182 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -984,6 +984,43 @@ void set_pcie_hotplug_bridge(struct pci_dev *pdev)
 
 
 /**
+ * pci_ext_cfg_is_aliased - is ext config space just an alias of std config?
+ * @dev: PCI device
+ *
+ * PCI Express to PCI/PCI-X Bridge Specification, rev 1.0, 4.1.4 says that
+ * when forwarding a type1 configuration request the bridge must check that
+ * the extended register address field is zero.  The bridge is not permitted
+ * to forward the transactions and must handle it as an Unsupported Request.
+ * Some bridges do not follow this rule and simply drop the extended register
+ * bits, resulting in the standard config space being aliased, every 256
+ * bytes across the entire configuration space.  Test for this condition by
+ * comparing the first dword of each potential alias to the vendor/device ID.
+ * Known offenders:
+ *   ASM1083/1085 PCIe-to-PCI Reversible Bridge (1b21:1080, rev 01 & 03)
+ *   AMD/ATI SBx00 PCI to PCI Bridge (1002:4384, rev 40)
+ */
+static bool pci_ext_cfg_is_aliased(struct pci_dev *dev)
+{
+#ifdef CONFIG_PCI_QUIRKS
+	int pos;
+	u32 header, tmp;
+
+	pci_read_config_dword(dev, PCI_VENDOR_ID, &header);
+
+	for (pos = PCI_CFG_SPACE_SIZE;
+	     pos < PCI_CFG_SPACE_EXP_SIZE; pos += PCI_CFG_SPACE_SIZE) {
+		if (pci_read_config_dword(dev, pos, &tmp) != PCIBIOS_SUCCESSFUL
+		    || header != tmp)
+			return false;
+	}
+
+	return true;
+#else
+	return false;
+#endif
+}
+
+/**
  * pci_cfg_space_size - get the configuration space size of the PCI device.
  * @dev: PCI device
  *
@@ -1001,7 +1038,7 @@ static int pci_cfg_space_size_ext(struct pci_dev *dev)
 
 	if (pci_read_config_dword(dev, pos, &status) != PCIBIOS_SUCCESSFUL)
 		goto fail;
-	if (status == 0xffffffff)
+	if (status == 0xffffffff || pci_ext_cfg_is_aliased(dev))
 		goto fail;
 
 	return PCI_CFG_SPACE_EXP_SIZE;

