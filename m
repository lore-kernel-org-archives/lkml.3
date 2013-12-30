Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687Ab3L3H1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 02:27:31 -0500
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:14234 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751614Ab3L3H10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 02:27:26 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH v5 3/4] PCI/MSI: Introduce pci_msix_vec_count() interface
Date: Mon, 30 Dec 2013 08:28:15 +0100
Message-Id: <5b1d3471b1f255996ea39ddd6b8ff3cb7a2da9ff.1388262668.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1388262668.git.agordeev@redhat.com>
References: <cover.1388262668.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This update is needed to create a consistent MSI-X counterpart
for pci_msi_vec_count() MSI interface. Device drivers can use
this function to obtain maximum number of MSI-X interrupts the
device supports and i.e. use that number in a following call
to pci_enable_msix() interface.

Interface pci_msix_vec_count() supersedes pci_msix_table_size()
function and returns a negative errno if device does not support
MSI-X interrupts. After this update callers must always check the
returned value.

The only user of pci_msix_table_size() function was PCI-Express
port driver, which is also updated by this change.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
---
 Documentation/PCI/MSI-HOWTO.txt |   13 +++++++++++++
 drivers/pci/msi.c               |   18 +++++++++++++-----
 drivers/pci/pcie/portdrv_core.c |    7 ++++---
 include/linux/pci.h             |    6 +++---
 4 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
index aa4ad98..b58f4a4 100644
--- a/Documentation/PCI/MSI-HOWTO.txt
+++ b/Documentation/PCI/MSI-HOWTO.txt
@@ -243,6 +243,19 @@ MSI-X Table.  This address is mapped by the PCI subsystem, and should not
 be accessed directly by the device driver.  If the driver wishes to
 mask or unmask an interrupt, it should call disable_irq() / enable_irq().
 
+4.3.4 pci_msix_vec_count
+
+int pci_msix_vec_count(struct pci_dev *dev)
+
+This function could be used to retrieve number of entries in the device
+MSI-X table.
+
+If this function returns a negative number, it indicates the device is
+not capable of sending MSI-Xs.
+
+If this function returns a positive number, it indicates the maximum
+number of MSI-X interrupt vectors that could be allocated.
+
 4.4 Handling devices implementing both MSI and MSI-X capabilities
 
 If a device implements both MSI and MSI-X capabilities, it can
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index ff7d4f0..32dca35 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -957,19 +957,25 @@ void pci_disable_msi(struct pci_dev *dev)
 EXPORT_SYMBOL(pci_disable_msi);
 
 /**
- * pci_msix_table_size - return the number of device's MSI-X table entries
+ * pci_msix_vec_count - return the number of device's MSI-X table entries
  * @dev: pointer to the pci_dev data structure of MSI-X device function
- */
-int pci_msix_table_size(struct pci_dev *dev)
+
+ * This function returns the number of device's MSI-X table entries and
+ * therefore the number of MSI-X vectors device is capable to send.
+ * It returns a negative errno if the device is not capable sending MSI-X
+ * interrupts.
+ **/
+int pci_msix_vec_count(struct pci_dev *dev)
 {
 	u16 control;
 
 	if (!dev->msix_cap)
-		return 0;
+		return -EINVAL;
 
 	pci_read_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, &control);
 	return msix_table_size(control);
 }
+EXPORT_SYMBOL(pci_msix_vec_count);
 
 /**
  * pci_enable_msix - configure device's MSI-X capability structure
@@ -998,7 +1004,9 @@ int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
 	if (status)
 		return status;
 
-	nr_entries = pci_msix_table_size(dev);
+	nr_entries = pci_msix_vec_count(dev);
+	if (nr_entries < 0)
+		return nr_entries;
 	if (nvec > nr_entries)
 		return nr_entries;
 
diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 16a1ce4..986f8ea 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -79,9 +79,10 @@ static int pcie_port_enable_msix(struct pci_dev *dev, int *vectors, int mask)
 	u16 reg16;
 	u32 reg32;
 
-	nr_entries = pci_msix_table_size(dev);
-	if (!nr_entries)
-		return -EINVAL;
+	nr_entries = pci_msix_vec_count(dev);
+	if (nr_entries < 0)
+		return nr_entries;
+	BUG_ON(!nr_entries);
 	if (nr_entries > PCIE_PORT_MAX_MSIX_ENTRIES)
 		nr_entries = PCIE_PORT_MAX_MSIX_ENTRIES;
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 206fa07..d031639 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1181,9 +1181,9 @@ static inline void pci_msi_shutdown(struct pci_dev *dev)
 static inline void pci_disable_msi(struct pci_dev *dev)
 { }
 
-static inline int pci_msix_table_size(struct pci_dev *dev)
+static inline int pci_msix_vec_count(struct pci_dev *dev)
 {
-	return 0;
+	return -ENOSYS;
 }
 static inline int pci_enable_msix(struct pci_dev *dev,
 				  struct msix_entry *entries, int nvec)
@@ -1210,7 +1210,7 @@ int pci_msi_vec_count(struct pci_dev *dev);
 int pci_enable_msi_block(struct pci_dev *dev, int nvec);
 void pci_msi_shutdown(struct pci_dev *dev);
 void pci_disable_msi(struct pci_dev *dev);
-int pci_msix_table_size(struct pci_dev *dev);
+int pci_msix_vec_count(struct pci_dev *dev);
 int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec);
 void pci_msix_shutdown(struct pci_dev *dev);
 void pci_disable_msix(struct pci_dev *dev);
-- 
1.7.7.6

