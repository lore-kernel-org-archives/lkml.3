Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751279Ab3JSHDK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 03:03:10 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:14960 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750948Ab3JSHDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 03:03:08 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH RFC v2 09/29] PCI/MSI: Factor out pci_get_msi_cap() interface
Date: Fri, 18 Oct 2013 19:12:09 +0200
Message-Id: <85500e7239fcb104df091bbfa873eef8ae654772.1382103786.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1382103786.git.agordeev@redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device drivers can use this interface to obtain maximum number
of MSI interrupts the device supports and use that number i.e.
in a following call to pci_enable_msi_block() interface.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 Documentation/PCI/MSI-HOWTO.txt |   15 +++++++++++++++
 drivers/pci/msi.c               |   33 +++++++++++++++++++++------------
 include/linux/pci.h             |    6 ++++++
 3 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
index 845edb5..e7e3b20 100644
--- a/Documentation/PCI/MSI-HOWTO.txt
+++ b/Documentation/PCI/MSI-HOWTO.txt
@@ -169,6 +169,21 @@ on any interrupt for which it previously called request_irq().
 Failure to do so results in a BUG_ON(), leaving the device with
 MSI enabled and thus leaking its vector.
 
+4.2.5 pci_get_msi_cap
+
+int pci_get_msi_cap(struct pci_dev *dev)
+
+This function could be used to retrieve the number of MSI vectors the
+device requested (via the Multiple Message Capable register). The MSI
+specification only allows the returned value to be a power of two,
+up to a maximum of 2^5 (32).
+
+If this function returns a negative number, it indicates the device is
+not capable of sending MSIs.
+
+If this function returns a positive number, it indicates the maximum
+number of MSI interrupt vectors that could be allocated.
+
 4.3 Using MSI-X
 
 The MSI-X capability is much more flexible than the MSI capability.
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index fdae3a4..14dc4d1 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -795,6 +795,21 @@ static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
 	return 0;
 }
 
+int pci_get_msi_cap(struct pci_dev *dev)
+{
+	int ret;
+	u16 msgctl;
+
+	if (!dev->msi_cap)
+		return -EINVAL;
+
+	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &msgctl);
+	ret = 1 << ((msgctl & PCI_MSI_FLAGS_QMASK) >> 1);
+
+	return ret;
+}
+EXPORT_SYMBOL(pci_get_msi_cap);
+
 /**
  * pci_enable_msi_block - configure device's MSI capability structure
  * @dev: device to configure
@@ -811,13 +826,10 @@ static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
 int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
 {
 	int status, maxvec;
-	u16 msgctl;
 
-	if (!dev->msi_cap)
-		return -EINVAL;
-
-	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &msgctl);
-	maxvec = 1 << ((msgctl & PCI_MSI_FLAGS_QMASK) >> 1);
+	maxvec = pci_get_msi_cap(dev);
+	if (maxvec < 0)
+		return maxvec;
 	if (nvec > maxvec)
 		return maxvec;
 
@@ -842,13 +854,10 @@ EXPORT_SYMBOL(pci_enable_msi_block);
 int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec)
 {
 	int ret, nvec;
-	u16 msgctl;
 
-	if (!dev->msi_cap)
-		return -EINVAL;
-
-	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &msgctl);
-	ret = 1 << ((msgctl & PCI_MSI_FLAGS_QMASK) >> 1);
+	ret = pci_get_msi_cap(dev);
+	if (ret < 0)
+		return ret;
 
 	if (maxvec)
 		*maxvec = ret;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index d6832de..df72084 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1146,6 +1146,11 @@ struct msix_entry {
 
 
 #ifndef CONFIG_PCI_MSI
+static inline int pci_get_msi_cap(struct pci_dev *dev)
+{
+	return -ENOSYS;
+}
+
 static inline int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
 {
 	return -ENOSYS;
@@ -1187,6 +1192,7 @@ static inline int pci_msi_enabled(void)
 	return 0;
 }
 #else
+int pci_get_msi_cap(struct pci_dev *dev);
 int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec);
 int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec);
 void pci_msi_shutdown(struct pci_dev *dev);
-- 
1.7.7.6

