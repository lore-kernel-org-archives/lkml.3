Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaBCV1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 16:27:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008AbaBCV1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:27:36 -0500
Subject: [PATCH v2 1/3] pci: Add device specific PCI ACS enable
From: Alex Williamson <alex.williamson@redhat.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Mon, 03 Feb 2014 14:27:33 -0700
Message-ID: <20140203212733.8607.27633.stgit@bling.home>
In-Reply-To: <20140203212216.8607.68273.stgit@bling.home>
References: <20140203212216.8607.68273.stgit@bling.home>
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
index 1febe90..b89502f 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2180,21 +2180,18 @@ void pci_request_acs(void)
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
@@ -2212,6 +2209,23 @@ void pci_enable_acs(struct pci_dev *dev)
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
index 5cb726c..f681fb0 100644
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
index fb57c89..f9a47dd 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1510,6 +1510,7 @@ enum pci_fixup_pass {
 void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev);
 struct pci_dev *pci_get_dma_source(struct pci_dev *dev);
 int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
+void pci_dev_specific_enable_acs(struct pci_dev *dev);
 #else
 static inline void pci_fixup_device(enum pci_fixup_pass pass,
 				    struct pci_dev *dev) { }
@@ -1522,6 +1523,7 @@ static inline int pci_dev_specific_acs_enabled(struct pci_dev *dev,
 {
 	return -ENOTTY;
 }
+static inline void pci_dev_specific_enable_acs(struct pci_dev *dev) {}
 #endif
 
 void __iomem *pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen);

