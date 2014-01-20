Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbaATWBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 17:01:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbaATWBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 17:01:48 -0500
Subject: [PATCH 1/2] pci: Add device specific PCI ACS enable
From: Alex Williamson <alex.williamson@redhat.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Mon, 20 Jan 2014 15:01:46 -0700
Message-ID: <20140120220146.29567.64686.stgit@bling.home>
In-Reply-To: <20140120215502.29567.11291.stgit@bling.home>
References: <20140120215502.29567.11291.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices support PCI ACS-like features, but don't report it using
the standard PCIe capabilities.  We already provide hooks for device
specific testing of ACS, but not for device specific enabling of ACS.
This provides that setup hook.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/pci.c    |   26 ++++++++++++++++++++------
 drivers/pci/quirks.c |   25 +++++++++++++++++++++++++
 include/linux/pci.h  |    2 ++
 3 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 07369f3..a57ff7f 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2357,21 +2357,18 @@ void pci_request_acs(void)
 }
 
 /**
- * pci_enable_acs - enable ACS if hardware support it
+ * pci_std_enable_acs - enable ACS on devices using standard ACS capabilites
  * @dev: the PCI device
  */
-void pci_enable_acs(struct pci_dev *dev)
+static int pci_std_enable_acs(struct pci_dev *dev)
 {
 	int pos;
 	u16 cap;
 	u16 ctrl;
 
-	if (!pci_acs_enable)
-		return;
-
 	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ACS);
 	if (!pos)
-		return;
+		return -ENODEV;
 
 	pci_read_config_word(dev, pos + PCI_ACS_CAP, &cap);
 	pci_read_config_word(dev, pos + PCI_ACS_CTRL, &ctrl);
@@ -2389,6 +2386,23 @@ void pci_enable_acs(struct pci_dev *dev)
 	ctrl |= (cap & PCI_ACS_UF);
 
 	pci_write_config_word(dev, pos + PCI_ACS_CTRL, ctrl);
+
+	return 0;
+}
+
+/**
+ * pci_enable_acs - enable ACS if hardware support it
+ * @dev: the PCI device
+ */
+void pci_enable_acs(struct pci_dev *dev)
+{
+	if (!pci_acs_enable)
+		return;
+
+	if (!pci_std_enable_acs(dev))
+		return;
+
+	pci_dev_specific_enable_acs(dev);
 }
 
 static bool pci_acs_flags_enabled(struct pci_dev *pdev, u16 acs_flags)
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 3a02717..4be1cd5 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3461,3 +3461,28 @@ int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags)
 
 	return -ENOTTY;
 }
+
+static const struct pci_dev_enable_acs {
+	u16 vendor;
+	u16 device;
+	int (*enable_acs)(struct pci_dev *dev);
+} pci_dev_enable_acs[] = {
+	{ 0 }
+};
+
+void pci_dev_specific_enable_acs(struct pci_dev *dev)
+{
+	const struct pci_dev_enable_acs *i;
+	int ret;
+
+	for (i = pci_dev_enable_acs; i->enable_acs; i++) {
+		if ((i->vendor == dev->vendor ||
+		     i->vendor == (u16)PCI_ANY_ID) &&
+		    (i->device == dev->device ||
+		     i->device == (u16)PCI_ANY_ID)) {
+			ret = i->enable_acs(dev);
+			if (ret >= 0)
+				return;
+		}
+	}
+}
diff --git a/include/linux/pci.h b/include/linux/pci.h
index a13d682..7905fd8 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1633,6 +1633,7 @@ enum pci_fixup_pass {
 void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev);
 struct pci_dev *pci_get_dma_source(struct pci_dev *dev);
 int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
+void pci_dev_specific_enable_acs(struct pci_dev *dev);
 #else
 static inline void pci_fixup_device(enum pci_fixup_pass pass,
 				    struct pci_dev *dev) {}
@@ -1645,6 +1646,7 @@ static inline int pci_dev_specific_acs_enabled(struct pci_dev *dev,
 {
 	return -ENOTTY;
 }
+static inline void pci_dev_specific_enable_acs(struct pci_dev *dev) {}
 #endif
 
 void __iomem *pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen);

