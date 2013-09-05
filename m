Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763660Ab3IEMuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 08:50:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761785Ab3IEMuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 08:50:52 -0400
Date: Thu, 5 Sep 2013 14:52:47 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-pci@vger.kernel.org, linux-ide@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v2 2/6] PCI/MSI: Factor out pci_get_msi_cap() interface
Message-ID: <c5ff8fbf905a3df2b75369da725ab5ebf31544ff.1378383792.git.agordeev@redhat.com>
References: <cover.1378383792.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1378383792.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out the operation of retrieving the number of MSI
vectors the device requested, that is a value encoded in
the Multiple Message Capable register.

This change is a prerequisite for the forthcoming update
of the AHCI device driver.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 Documentation/PCI/MSI-HOWTO.txt |   12 ++++++++++++
 drivers/pci/msi.c               |   30 ++++++++++++++++++++----------
 include/linux/pci.h             |    6 ++++++
 3 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
index 32d7d15..205eb5d 100644
--- a/Documentation/PCI/MSI-HOWTO.txt
+++ b/Documentation/PCI/MSI-HOWTO.txt
@@ -209,6 +209,18 @@ on any interrupt for which it previously called request_irq().
 Failure to do so results in a BUG_ON(), leaving the device with
 MSI enabled and thus leaking its vector.
 
+4.2.6 pci_get_msi_cap
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
 4.3 Using MSI-X
 
 The MSI-X capability is much more flexible than the MSI capability.
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 647e9b1..c50d518 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -802,17 +802,30 @@ static int pci_msi_check_device(struct pci_dev *dev,
 	return 0;
 }
 
-int pci_enable_msi_block_part(struct pci_dev *dev,
-			      unsigned int nvec, int nvec_mme)
+int pci_get_msi_cap(struct pci_dev *dev)
 {
-	int status, maxvec;
+	int ret;
 	u16 msgctl;
 
 	if (!dev->msi_cap)
 		return -EINVAL;
 
 	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &msgctl);
-	maxvec = 1 << ((msgctl & PCI_MSI_FLAGS_QMASK) >> 1);
+	ret = 1 << ((msgctl & PCI_MSI_FLAGS_QMASK) >> 1);
+
+	return ret;
+}
+EXPORT_SYMBOL(pci_get_msi_cap);
+
+int pci_enable_msi_block_part(struct pci_dev *dev,
+			      unsigned int nvec, int nvec_mme)
+{
+	int status, maxvec;
+	u16 msgctl;
+
+	maxvec = pci_get_msi_cap(dev);
+	if (maxvec < 0)
+		return maxvec;
 
 	if (nvec_mme < 0)
 		nvec_mme = maxvec;
@@ -869,13 +882,10 @@ EXPORT_SYMBOL(pci_enable_msi_block);
 int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec)
 {
 	int ret, nvec;
-	u16 msgctl;
-
-	if (!dev->msi_cap)
-		return -EINVAL;
 
-	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &msgctl);
-	ret = 1 << ((msgctl & PCI_MSI_FLAGS_QMASK) >> 1);
+	ret = pci_get_msi_cap(dev);
+	if (ret < 0)
+		return ret;
 
 	if (maxvec)
 		*maxvec = ret;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 6552cee..b866048 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1122,6 +1122,11 @@ struct msix_entry {
 
 
 #ifndef CONFIG_PCI_MSI
+static inline int pci_get_msi_cap(struct pci_dev *dev)
+{
+	return -1;
+}
+
 static inline int
 pci_enable_msi_block_part(struct pci_dev *dev, unsigned int nvec, int nvec_mme)
 {
@@ -1169,6 +1174,7 @@ static inline int pci_msi_enabled(void)
 	return 0;
 }
 #else
+int pci_get_msi_cap(struct pci_dev *dev);
 int pci_enable_msi_block_part(struct pci_dev *dev,
 			      unsigned int nvec, int nvec_mme);
 int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec);
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
