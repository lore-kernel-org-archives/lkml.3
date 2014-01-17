Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaAQJZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 04:25:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287AbaAQJZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:25:36 -0500
Date: Fri, 17 Jan 2014 10:27:38 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/9] PCI/MSI: Phase out pci_enable_msi_block()
Message-ID: <20140117092737.GB29340@dhcp-26-207.brq.redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1389904166.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This update obsoletes pci_enable_msi_block() function
in favor of pci_enable_msi_range().

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/pci/msi.c   |   17 +++++++++++++++--
 include/linux/pci.h |    7 ++-----
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 7a0fec6..49088d0 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -889,7 +889,7 @@ EXPORT_SYMBOL(pci_msi_vec_count);
  * updates the @dev's irq member to the lowest new interrupt number; the
  * other interrupt numbers allocated to this device are consecutive.
  */
-int pci_enable_msi_block(struct pci_dev *dev, int nvec)
+static int pci_enable_msi_block(struct pci_dev *dev, int nvec)
 {
 	int status, maxvec;
 
@@ -918,7 +918,6 @@ int pci_enable_msi_block(struct pci_dev *dev, int nvec)
 	status = msi_capability_init(dev, nvec);
 	return status;
 }
-EXPORT_SYMBOL(pci_enable_msi_block);
 
 void pci_msi_shutdown(struct pci_dev *dev)
 {
@@ -1148,6 +1147,20 @@ int pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec)
 EXPORT_SYMBOL(pci_enable_msi_range);
 
 /**
+ * pci_enable_msi - configure device's MSI capability structure
+ * @dev: device to configure
+ *
+ * This function initializes the single MSI mode. It returns a negative errno
+ * if an error occurs. If it succeeds, it returns 0 and updates the @dev's
+ * irq member to the new interrupt number;
+ **/
+int pci_enable_msi(struct pci_dev *dev)
+{
+	return pci_enable_msi_block(dev, 1);
+}
+EXPORT_SYMBOL(pci_enable_msi);
+
+/**
  * pci_enable_msix_range - configure device's MSI-X capability structure
  * @dev: pointer to the pci_dev data structure of MSI-X device function
  * @entries: pointer to an array of MSI-X entries
diff --git a/include/linux/pci.h b/include/linux/pci.h
index fa959aa..5b58078 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1157,7 +1157,7 @@ struct msix_entry {
 
 #ifdef CONFIG_PCI_MSI
 int pci_msi_vec_count(struct pci_dev *dev);
-int pci_enable_msi_block(struct pci_dev *dev, int nvec);
+int pci_enable_msi(struct pci_dev *dev);
 void pci_msi_shutdown(struct pci_dev *dev);
 void pci_disable_msi(struct pci_dev *dev);
 int pci_msix_vec_count(struct pci_dev *dev);
@@ -1172,8 +1172,7 @@ int pci_enable_msix_range(struct pci_dev *dev, struct msix_entry *entries,
 			  int minvec, int maxvec);
 #else
 static inline int pci_msi_vec_count(struct pci_dev *dev) { return -ENOSYS; }
-static inline int pci_enable_msi_block(struct pci_dev *dev, int nvec)
-{ return -ENOSYS; }
+static inline int pci_enable_msi(struct pci_dev *dev) { return -ENOSYS; }
 static inline void pci_msi_shutdown(struct pci_dev *dev) { }
 static inline void pci_disable_msi(struct pci_dev *dev) { }
 static inline int pci_msix_vec_count(struct pci_dev *dev) { return -ENOSYS; }
@@ -1223,8 +1222,6 @@ static inline void pcie_set_ecrc_checking(struct pci_dev *dev) { }
 static inline void pcie_ecrc_get_policy(char *str) { }
 #endif
 
-#define pci_enable_msi(pdev)	pci_enable_msi_block(pdev, 1)
-
 #ifdef CONFIG_HT_IRQ
 /* The functions a driver should call */
 int  ht_create_irq(struct pci_dev *dev, int idx);
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
