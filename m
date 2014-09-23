Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391AbaIWU6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 16:58:25 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:61988 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176AbaIWU6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 16:58:24 -0400
Date: Tue, 23 Sep 2014 14:58:20 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 3/3] PCI/MSI: Remove arch_msi_check_device()
Message-ID: <20140923205820.GE6776@google.com>
References: <cover.1410078503.git.agordeev@redhat.com>
 <50a2f79ce58b6b67b40d7737b21c168131240c31.1410078503.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50a2f79ce58b6b67b40d7737b21c168131240c31.1410078503.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 07, 2014 at 08:57:55PM +0200, Alexander Gordeev wrote:
> There are no archs that override arch_msi_check_device()
> hook. Remove it as it is completely redundant.
> 
> If an arch would need to check MSI/MSI-X possibility for a
> device it should make it within arch_setup_msi_irqs() hook.
> 
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-pci@vger.kernel.org
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  drivers/pci/msi.c   | 49 +++++++++++++------------------------------------
>  include/linux/msi.h |  3 ---
>  2 files changed, 13 insertions(+), 39 deletions(-)

I like this patch a lot, but it's doing several things at once, so I split
it into several patches as follows.  I think it is equivalent, but I did
not add Thomas' tested-by.

I also reversed the sense of pci_msi_supported() so it returns true (1)
when MSI/MSI-X is supported and false (0) otherwise.

The whole thing is on my pci/msi branch at
https://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=pci/msi

Let me know if you see any issues.

Bjorn


commit 28a3ec3f672d42a877d8770a33305dfe82c2cc90
Author: Alexander Gordeev <agordeev@redhat.com>
Date:   Tue Sep 23 12:39:54 2014 -0600

    PCI/MSI: Remove arch_msi_check_device()
    
    No architectures implement arch_msi_check_device() or the struct msi_chip
    .check_device() method, so remove them.
    
    Remove the "type" parameter to pci_msi_check_device() because it was only
    used to call arch_msi_check_device() and is no longer needed.
    
    [bhelgaas: changelog, split to separate patch]
    Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index aff384aea639..a0b623d97ad8 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -56,16 +56,6 @@ void __weak arch_teardown_msi_irq(unsigned int irq)
 	chip->teardown_irq(chip, irq);
 }
 
-int __weak arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
-{
-	struct msi_chip *chip = dev->bus->msi;
-
-	if (!chip || !chip->check_device)
-		return 0;
-
-	return chip->check_device(chip, dev, nvec, type);
-}
-
 int __weak arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
 	struct msi_desc *entry;
@@ -788,10 +778,9 @@ out_free:
  * to determine if MSI/-X are supported for the device. If MSI/-X is
  * supported return 0, else return an error code.
  **/
-static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
+static int pci_msi_check_device(struct pci_dev *dev, int nvec)
 {
 	struct pci_bus *bus;
-	int ret;
 
 	/* MSI must be globally enabled and supported by the device */
 	if (!pci_msi_enable || !dev || dev->no_msi)
@@ -816,10 +805,6 @@ static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
 		if (bus->bus_flags & PCI_BUS_FLAGS_NO_MSI)
 			return -EINVAL;
 
-	ret = arch_msi_check_device(dev, nvec, type);
-	if (ret)
-		return ret;
-
 	return 0;
 }
 
@@ -925,7 +910,7 @@ int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
 	if (!entries || !dev->msix_cap || dev->current_state != PCI_D0)
 		return -EINVAL;
 
-	status = pci_msi_check_device(dev, nvec, PCI_CAP_ID_MSIX);
+	status = pci_msi_check_device(dev, nvec);
 	if (status)
 		return status;
 
@@ -1059,7 +1044,7 @@ int pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec)
 		nvec = maxvec;
 
 	do {
-		rc = pci_msi_check_device(dev, nvec, PCI_CAP_ID_MSI);
+		rc = pci_msi_check_device(dev, nvec);
 		if (rc < 0) {
 			return rc;
 		} else if (rc > 0) {
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 6be66f48b026..36c63cfccf5b 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -55,7 +55,6 @@ int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc);
 void arch_teardown_msi_irq(unsigned int irq);
 int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
 void arch_teardown_msi_irqs(struct pci_dev *dev);
-int arch_msi_check_device(struct pci_dev* dev, int nvec, int type);
 void arch_restore_msi_irqs(struct pci_dev *dev);
 
 void default_teardown_msi_irqs(struct pci_dev *dev);
@@ -72,8 +71,6 @@ struct msi_chip {
 	int (*setup_irq)(struct msi_chip *chip, struct pci_dev *dev,
 			 struct msi_desc *desc);
 	void (*teardown_irq)(struct msi_chip *chip, unsigned int irq);
-	int (*check_device)(struct msi_chip *chip, struct pci_dev *dev,
-			    int nvec, int type);
 };
 
 #endif /* LINUX_MSI_H */

commit 9d686dd5bbf62a249d0e4f54bffd848d573d2380
Author: Alexander Gordeev <agordeev@redhat.com>
Date:   Tue Sep 23 14:25:11 2014 -0600

    PCI/MSI: Move D0 check into pci_msi_check_device()
    
    Both callers of pci_msi_check_device() check that the device is in D0
    state, so move the check from the callers into pci_msi_check_device()
    itself.
    
    In pci_enable_msi_range(), note that pci_msi_check_device() never returns a
    positive value any more, so the loop that called it until it returns zero
    or negative is no longer necessary.
    
    [bhelgaas: changelog, split to separate patch]
    Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index a0b623d97ad8..416a4917a64a 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -783,7 +783,10 @@ static int pci_msi_check_device(struct pci_dev *dev, int nvec)
 	struct pci_bus *bus;
 
 	/* MSI must be globally enabled and supported by the device */
-	if (!pci_msi_enable || !dev || dev->no_msi)
+	if (!pci_msi_enable)
+		return -EINVAL;
+
+	if (!dev || dev->no_msi || dev->current_state != PCI_D0)
 		return -EINVAL;
 
 	/*
@@ -907,13 +910,13 @@ int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
 	int status, nr_entries;
 	int i, j;
 
-	if (!entries || !dev->msix_cap || dev->current_state != PCI_D0)
-		return -EINVAL;
-
 	status = pci_msi_check_device(dev, nvec);
 	if (status)
 		return status;
 
+	if (!entries)
+		return -EINVAL;
+
 	nr_entries = pci_msix_vec_count(dev);
 	if (nr_entries < 0)
 		return nr_entries;
@@ -1020,8 +1023,9 @@ int pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec)
 	int nvec;
 	int rc;
 
-	if (dev->current_state != PCI_D0)
-		return -EINVAL;
+	rc = pci_msi_check_device(dev, minvec);
+	if (rc)
+		return rc;
 
 	WARN_ON(!!dev->msi_enabled);
 
@@ -1044,17 +1048,6 @@ int pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec)
 		nvec = maxvec;
 
 	do {
-		rc = pci_msi_check_device(dev, nvec);
-		if (rc < 0) {
-			return rc;
-		} else if (rc > 0) {
-			if (rc < minvec)
-				return -ENOSPC;
-			nvec = rc;
-		}
-	} while (rc);
-
-	do {
 		rc = msi_capability_init(dev, nvec);
 		if (rc < 0) {
 			return rc;

commit 99b4b82ffbc665cfa363a89144c8cc29eb46ce3d
Author: Alexander Gordeev <agordeev@redhat.com>
Date:   Tue Sep 23 12:45:58 2014 -0600

    PCI/MSI: Rename pci_msi_check_device() to pci_msi_supported()
    
    Rename pci_msi_check_device() to pci_msi_supported() for clarity.  Note
    that pci_msi_supported() returns true if MSI/MSI-X is supported, so code
    like:
    
      if (pci_msi_supported(...))
    
    reads naturally.
    
    [bhelgaas: changelog, split to separate patch, reverse sense]
    Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 416a4917a64a..d40323f0ed44 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -769,16 +769,15 @@ out_free:
 }
 
 /**
- * pci_msi_check_device - check whether MSI may be enabled on a device
+ * pci_msi_supported - check whether MSI may be enabled on a device
  * @dev: pointer to the pci_dev data structure of MSI device function
  * @nvec: how many MSIs have been requested ?
- * @type: are we checking for MSI or MSI-X ?
  *
  * Look at global flags, the device itself, and its parent buses
  * to determine if MSI/-X are supported for the device. If MSI/-X is
- * supported return 0, else return an error code.
+ * supported return 1, else return 0.
  **/
-static int pci_msi_check_device(struct pci_dev *dev, int nvec)
+static int pci_msi_supported(struct pci_dev *dev, int nvec)
 {
 	struct pci_bus *bus;
 
@@ -795,7 +794,7 @@ static int pci_msi_check_device(struct pci_dev *dev, int nvec)
 	 *  b) the list manipulation code assumes nvec >= 1.
 	 */
 	if (nvec < 1)
-		return -ERANGE;
+		return 0;
 
 	/*
 	 * Any bridge which does NOT route MSI transactions from its
@@ -806,9 +805,9 @@ static int pci_msi_check_device(struct pci_dev *dev, int nvec)
 	 */
 	for (bus = dev->bus; bus; bus = bus->parent)
 		if (bus->bus_flags & PCI_BUS_FLAGS_NO_MSI)
-			return -EINVAL;
+			return 0;
 
-	return 0;
+	return 1;
 }
 
 /**
@@ -910,9 +909,8 @@ int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
 	int status, nr_entries;
 	int i, j;
 
-	status = pci_msi_check_device(dev, nvec);
-	if (status)
-		return status;
+	if (!pci_msi_supported(dev, nvec))
+		return -EINVAL;
 
 	if (!entries)
 		return -EINVAL;
@@ -1023,9 +1021,8 @@ int pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec)
 	int nvec;
 	int rc;
 
-	rc = pci_msi_check_device(dev, minvec);
-	if (rc)
-		return rc;
+	if (!pci_msi_supported(dev, minvec))
+		return -EINVAL;
 
 	WARN_ON(!!dev->msi_enabled);
 

commit 83be7664f8492b8e4b72cd9375433909d40c018b
Author: Bjorn Helgaas <bhelgaas@google.com>
Date:   Tue Sep 23 14:38:28 2014 -0600

    PCI/MSI: Remove unnecessary temporary variable
    
    The only use of "status" is to hold a value which is immediately returned,
    so just return and remove the variable directly.
    
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index d40323f0ed44..aae2fc80692b 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -906,7 +906,7 @@ EXPORT_SYMBOL(pci_msix_vec_count);
  **/
 int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
 {
-	int status, nr_entries;
+	int nr_entries;
 	int i, j;
 
 	if (!pci_msi_supported(dev, nvec))
@@ -937,8 +937,7 @@ int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
 		dev_info(&dev->dev, "can't enable MSI-X (MSI IRQ already assigned)\n");
 		return -EINVAL;
 	}
-	status = msix_capability_init(dev, entries, nvec);
-	return status;
+	return msix_capability_init(dev, entries, nvec);
 }
 EXPORT_SYMBOL(pci_enable_msix);
 
