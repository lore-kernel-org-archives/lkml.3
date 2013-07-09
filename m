Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab3GIFnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 01:43:50 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:22051 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab3GIFnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 01:43:49 -0400
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Cc: "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: [PATCH 1/1] ia64/pci: set mmio decoding on for some host bridge
Date: Tue,  9 Jul 2013 13:42:11 +0800
Message-Id: <1373348531-31893-1-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some IA64 platforms with intel PCI bridge, for example, HP BL890c i2
with  Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port,
when kernel tries to disable the mmio decoding on the PCI bridge devices,
kernel may crash.

And in the comment of function quirk_mmio_always_on, it also says:
"But doing so (disable the mmio decoding) may cause problems on host bridge
 and perhaps other key system devices"

So, for this PCI bridge,  dev->mmio_always_on bit should be set to 1.

To avoid affecting the use of quirk_mmio_always_on, a new function is created.

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 drivers/pci/quirks.c    |   17 +++++++++++++++++
 include/linux/pci_ids.h |    1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e85d230..665af3e 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -44,6 +44,23 @@ static void quirk_mmio_always_on(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_ANY_ID, PCI_ANY_ID,
 				PCI_CLASS_BRIDGE_HOST, 8, quirk_mmio_always_on);
 
+#ifdef CONFIG_IA64
+/*
+ * On some IA64 platforms, for some intel PCI bridge devices, for example,
+ * the Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port,
+ * disable the mmio decoding on this device may cause system crash.
+ * So dev->mmio_always_on bit should be set to 1.
+ */
+static void quirk_mmio_on_intel_pcibridge(struct pci_dev *dev)
+{
+	dev->mmio_always_on = 1;
+}
+DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_INTEL,
+			PCI_DEVICE_ID_INTEL_5520_5550_X58,
+			PCI_CLASS_BRIDGE_PCI,
+			8, quirk_mmio_on_intel_pcibridge);
+#endif
+
 /* The Mellanox Tavor device gives false positive parity errors
  * Mark this device with a broken_parity_status, to allow
  * PCI scanning code to "skip" this now blacklisted device.
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 3bed2e8..d8c60b7 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2742,6 +2742,7 @@
 #define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH2_RANK_REV2  0x2db2
 #define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH2_TC_REV2    0x2db3
 #define PCI_DEVICE_ID_INTEL_82855PM_HB	0x3340
+#define PCI_DEVICE_ID_INTEL_5520_5550_X58       0x3408
 #define PCI_DEVICE_ID_INTEL_IOAT_TBG4	0x3429
 #define PCI_DEVICE_ID_INTEL_IOAT_TBG5	0x342a
 #define PCI_DEVICE_ID_INTEL_IOAT_TBG6	0x342b
-- 
1.7.10.4

