Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab3JSHG1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 03:06:27 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:15253 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751240Ab3JSHG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 03:06:26 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH RFC v2 11/29] PCI/MSI: Convert pci_msix_table_size() to a public interface
Date: Fri, 18 Oct 2013 19:12:11 +0200
Message-Id: <04a7098780907bd8848d4939b24a74e70e274866.1382103786.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1382103786.git.agordeev@redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make pci_msix_table_size() return error code if the device
does not support MSI-X. This update is needed to create a
consistent MSI-X counterpart for pci_get_msi_cap() MSI
interface.

Device drivers can use this interface to obtain maximum number
of MSI-X interrupts the device supports and i.e. use that number
in a following call to pci_enable_msix() interface.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 Documentation/PCI/MSI-HOWTO.txt |   13 +++++++++++++
 drivers/pci/msi.c               |    5 ++++-
 drivers/pci/pcie/portdrv_core.c |    5 +++--
 include/linux/pci.h             |    2 +-
 4 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
index 47118f3..fdf3ae3 100644
--- a/Documentation/PCI/MSI-HOWTO.txt
+++ b/Documentation/PCI/MSI-HOWTO.txt
@@ -245,6 +245,19 @@ MSI-X Table.  This address is mapped by the PCI subsystem, and should not
 be accessed directly by the device driver.  If the driver wishes to
 mask or unmask an interrupt, it should call disable_irq() / enable_irq().
 
+4.3.4 pci_msix_table_size
+
+int pci_msix_table_size(struct pci_dev *dev)
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
index 13bd901..96f51d0 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -898,11 +898,12 @@ int pci_msix_table_size(struct pci_dev *dev)
 	u16 control;
 
 	if (!dev->msix_cap)
-		return 0;
+		return -EINVAL;
 
 	pci_read_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, &control);
 	return msix_table_size(control);
 }
+EXPORT_SYMBOL(pci_msix_table_size);
 
 /**
  * pci_enable_msix - configure device's MSI-X capability structure
@@ -933,6 +934,8 @@ int pci_enable_msix(struct pci_dev *dev,
 		return status;
 
 	nr_entries = pci_msix_table_size(dev);
+	if (nr_entries < 0)
+		return nr_entries;
 	if (nvec > nr_entries)
 		return nr_entries;
 
diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 31063ac..242f9ff 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -80,8 +80,9 @@ static int pcie_port_enable_msix(struct pci_dev *dev, int *vectors, int mask)
 	u32 reg32;
 
 	nr_entries = pci_msix_table_size(dev);
-	if (!nr_entries)
-		return -EINVAL;
+	if (nr_entries < 0)
+		return nr_entries;
+	BUG_ON(!nr_entries);
 	if (nr_entries > PCIE_PORT_MAX_MSIX_ENTRIES)
 		nr_entries = PCIE_PORT_MAX_MSIX_ENTRIES;
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index a04f5da..bef5775 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1163,7 +1163,7 @@ static inline void pci_disable_msi(struct pci_dev *dev)
 
 static inline int pci_msix_table_size(struct pci_dev *dev)
 {
-	return 0;
+	return -ENOSYS;
 }
 static inline int pci_enable_msix(struct pci_dev *dev,
 				  struct msix_entry *entries, int unsigned nvec)
-- 
1.7.7.6

