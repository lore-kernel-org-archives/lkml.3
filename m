Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaFXH42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 03:56:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:14840 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbaFXH4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 03:56:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,536,1400050800"; 
   d="scan'208";a="449200654"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boon Leong Ong <boon.leong.ong@intel.com>
Subject: [PATCH] USB: ehci-pci: USB host controller support for Intel Quark X1000
Date: Tue, 24 Jun 2014 08:51:43 -0700
Message-Id: <1403625103-28078-2-git-send-email-alvin.chen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403625103-28078-1-git-send-email-alvin.chen@intel.com>
References: <1403625103-28078-1-git-send-email-alvin.chen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@intel.com>

This patch is to enable USB host controller for Intel Quark X1000. Add pci quirks
to adjust the packet buffer in/out threshold value, and ensure EHCI packet buffer
i/o threshold value is reconfigured to half.

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@intel.com>
Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>
---
 drivers/usb/host/ehci-pci.c   |    4 ++++
 drivers/usb/host/pci-quirks.c |   42 +++++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/pci-quirks.h |    2 ++
 3 files changed, 48 insertions(+)

diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index 3e86bf4..33cfa23 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -50,6 +50,10 @@ static int ehci_pci_reinit(struct ehci_hcd *ehci, struct pci_dev *pdev)
 	if (!retval)
 		ehci_dbg(ehci, "MWI active\n");
 
+	/* Reset the threshold limit */
+	if(unlikely(usb_is_intel_qrk(pdev)))
+		usb_set_qrk_bulk_thresh(pdev);
+
 	return 0;
 }
 
diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 00661d3..1ea8803 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -823,6 +823,48 @@ static int handshake(void __iomem *ptr, u32 mask, u32 done,
 	return -ETIMEDOUT;
 }
 
+#define PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC		0x0939
+bool usb_is_intel_qrk(struct pci_dev *pdev)
+{
+	return pdev->vendor == PCI_VENDOR_ID_INTEL &&
+		pdev->device == PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC;
+
+}
+EXPORT_SYMBOL_GPL(usb_is_intel_qrk);
+
+#define EHCI_INSNREG01		0x84
+#define EHCI_INSNREG01_THRESH	0x007F007F	/* Threshold value */
+void usb_set_qrk_bulk_thresh(struct pci_dev *pdev)
+{
+	void __iomem *base, *op_reg_base;
+	u8 cap_length;
+	u32 val;
+
+	if (!mmio_resource_enabled(pdev, 0))
+		return;
+
+	base = pci_ioremap_bar(pdev, 0);
+	if (base == NULL)
+		return;
+
+	cap_length = readb(base);
+	op_reg_base = base + cap_length;
+
+	val = readl(op_reg_base + EHCI_INSNREG01);
+	dev_printk(KERN_INFO, &pdev->dev, "INSNREG01 is 0x%08x\n", val);
+
+	val = EHCI_INSNREG01_THRESH;
+
+	writel(val, op_reg_base + EHCI_INSNREG01);
+
+	val = readl(op_reg_base + EHCI_INSNREG01);
+	dev_printk(KERN_INFO, &pdev->dev, "INSNREG01 is 0x%08x\n", val);
+
+	iounmap(base);
+
+}
+EXPORT_SYMBOL_GPL(usb_set_qrk_bulk_thresh);
+
 /*
  * Intel's Panther Point chipset has two host controllers (EHCI and xHCI) that
  * share some number of ports.  These ports can be switched between either
diff --git a/drivers/usb/host/pci-quirks.h b/drivers/usb/host/pci-quirks.h
index c622ddf..617c22b 100644
--- a/drivers/usb/host/pci-quirks.h
+++ b/drivers/usb/host/pci-quirks.h
@@ -14,6 +14,8 @@ void usb_amd_quirk_pll_enable(void);
 void usb_enable_intel_xhci_ports(struct pci_dev *xhci_pdev);
 void usb_disable_xhci_ports(struct pci_dev *xhci_pdev);
 void sb800_prefetch(struct device *dev, int on);
+bool usb_is_intel_qrk(struct pci_dev *pdev);
+void usb_set_qrk_bulk_thresh(struct pci_dev *pdev);
 #else
 struct pci_dev;
 static inline void usb_amd_quirk_pll_disable(void) {}
-- 
1.7.9.5

