Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab3KZU40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 15:56:26 -0500
Received: from 6.77.broadband6.iol.cz ([88.101.77.6]:52504 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752003Ab3KZU4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 15:56:24 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH v3 08/11] PCI/MSI: Factor out pci_get_msi_cap() interface
Date: Tue, 26 Nov 2013 10:09:57 +0100
Message-Id: <28840beabf04db10ea555dc15033eaeb8a226231.1385399393.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1385399393.git.agordeev@redhat.com>
References: <cover.1385399393.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device drivers can use this interface to obtain maximum number
of MSI interrupts the device supports and use that number i.e.
in a following call to pci_enable_msi_block() interface.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
---
 Documentation/PCI/MSI-HOWTO.txt |   15 ++++++++++++++
 drivers/pci/msi.c               |   41 +++++++++++++++++++++++++++++++-------
 include/linux/pci.h             |    6 +++++
 3 files changed, 54 insertions(+), 8 deletions(-)

diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
index a4d174e..9c1282e 100644
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
index 4656b88..3558b45 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -823,6 +823,31 @@ static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
 }
 
 /**
+ * pci_get_msi_cap - Return the number of MSI vectors device is capable to send
+ * @dev: device to report about
+ *
+ * This function returns the number of MSI vectors a device requested via
+ * Multiple Message Capable register. It returns a negative errno if the
+ * device is not capable sending MSI interrupts. Otherwise, the call succeeds
+ * and returns a power of two, up to a maximum of 2^5 (32), according to the
+ * MSI specification.
+ **/
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
+/**
  * pci_enable_msi_block - configure device's MSI capability structure
  * @dev: device to configure
  * @nvec: number of interrupts to configure
@@ -838,13 +863,13 @@ static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
 int pci_enable_msi_block(struct pci_dev *dev, int nvec)
 {
 	int status, maxvec;
-	u16 msgctl;
 
-	if (!dev->msi_cap || dev->current_state != PCI_D0)
+	if (dev->current_state != PCI_D0)
 		return -EINVAL;
 
-	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &msgctl);
-	maxvec = 1 << ((msgctl & PCI_MSI_FLAGS_QMASK) >> 1);
+	maxvec = pci_get_msi_cap(dev);
+	if (maxvec < 0)
+		return maxvec;
 	if (nvec > maxvec)
 		return maxvec;
 
@@ -869,13 +894,13 @@ EXPORT_SYMBOL(pci_enable_msi_block);
 int pci_enable_msi_block_auto(struct pci_dev *dev, int *maxvec)
 {
 	int ret, nvec;
-	u16 msgctl;
 
-	if (!dev->msi_cap || dev->current_state != PCI_D0)
+	if (dev->current_state != PCI_D0)
 		return -EINVAL;
 
-	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &msgctl);
-	ret = 1 << ((msgctl & PCI_MSI_FLAGS_QMASK) >> 1);
+	ret = pci_get_msi_cap(dev);
+	if (ret < 0)
+		return ret;
 
 	if (maxvec)
 		*maxvec = ret;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 6ba0deb..e337086 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1155,6 +1155,11 @@ struct msix_entry {
 
 
 #ifndef CONFIG_PCI_MSI
+static inline int pci_get_msi_cap(struct pci_dev *dev)
+{
+	return -ENOSYS;
+}
+
 static inline int pci_enable_msi_block(struct pci_dev *dev, int nvec)
 {
 	return -ENOSYS;
@@ -1196,6 +1201,7 @@ static inline int pci_msi_enabled(void)
 	return 0;
 }
 #else
+int pci_get_msi_cap(struct pci_dev *dev);
 int pci_enable_msi_block(struct pci_dev *dev, int nvec);
 int pci_enable_msi_block_auto(struct pci_dev *dev, int *maxvec);
 void pci_msi_shutdown(struct pci_dev *dev);
-- 
1.7.7.6

