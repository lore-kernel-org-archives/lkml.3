Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab3IBI7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:59:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275Ab3IBI65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:58:57 -0400
Date: Mon, 2 Sep 2013 11:00:54 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-pci@vger.kernel.org, linux-ide@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 4/4] PCI/MSI: Get rid of pci_enable_msi_block_auto() interface
Message-ID: <22d32807482ab4a2131116c50fe217c111849ec0.1378111919.git.agordeev@redhat.com>
References: <cover.1378111919.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1378111919.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no consumers of pci_enable_msi_block_auto()
interface have left. Eliminate it for now.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 Documentation/PCI/MSI-HOWTO.txt |   12 ++++++------
 drivers/pci/msi.c               |   25 -------------------------
 include/linux/pci.h             |    7 -------
 3 files changed, 6 insertions(+), 38 deletions(-)

diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
index 32d7d15..a8019e3 100644
--- a/Documentation/PCI/MSI-HOWTO.txt
+++ b/Documentation/PCI/MSI-HOWTO.txt
@@ -197,12 +197,12 @@ supported, it can set the pointer count to NULL.
 
 void pci_disable_msi(struct pci_dev *dev)
 
-This function should be used to undo the effect of pci_enable_msi_block(),
-pci_enable_msi(), pci_enable_msi_block_auto() or pci_enable_msi_block_part().
-Calling it restores dev->irq to the pin-based interrupt number and frees the
-previously allocated message signaled interrupt(s). The interrupt may
-subsequently be assigned to another device, so drivers should not cache the
-value of dev->irq.
+This function should be used to undo the effect of pci_enable_msi() or
+pci_enable_msi_block() or pci_enable_msi_block_part().  Calling it restores
+dev->irq to the pin-based interrupt number and frees the previously
+allocated message signaled interrupt(s).  The interrupt may subsequently be
+assigned to another device, so drivers should not cache the value of
+dev->irq.
 
 Before calling this function, a device driver must always call free_irq()
 on any interrupt for which it previously called request_irq().
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index a5c958f..d99f022 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -866,31 +866,6 @@ int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
 }
 EXPORT_SYMBOL(pci_enable_msi_block);
 
-int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec)
-{
-	int ret, nvec;
-	u16 msgctl;
-
-	if (!dev->msi_cap)
-		return -EINVAL;
-
-	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &msgctl);
-	ret = 1 << ((msgctl & PCI_MSI_FLAGS_QMASK) >> 1);
-
-	if (maxvec)
-		*maxvec = ret;
-
-	do {
-		nvec = ret;
-		ret = pci_enable_msi_block(dev, nvec);
-	} while (ret > 0);
-
-	if (ret < 0)
-		return ret;
-	return nvec;
-}
-EXPORT_SYMBOL(pci_enable_msi_block_auto);
-
 void pci_msi_shutdown(struct pci_dev *dev)
 {
 	struct msi_desc *desc;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 6552cee..89935b4 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1133,12 +1133,6 @@ static inline int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
 	return -1;
 }
 
-static inline int
-pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec)
-{
-	return -1;
-}
-
 static inline void pci_msi_shutdown(struct pci_dev *dev)
 { }
 static inline void pci_disable_msi(struct pci_dev *dev)
@@ -1172,7 +1166,6 @@ static inline int pci_msi_enabled(void)
 int pci_enable_msi_block_part(struct pci_dev *dev,
 			      unsigned int nvec, int nvec_mme);
 int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec);
-int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec);
 void pci_msi_shutdown(struct pci_dev *dev);
 void pci_disable_msi(struct pci_dev *dev);
 int pci_msix_table_size(struct pci_dev *dev);
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
