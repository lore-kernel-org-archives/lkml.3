Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab3LPSt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 13:49:57 -0500
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:28866 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754897Ab3LPSt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 13:49:56 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH v4 7/9] PCI/MSI: Get rid of pci_enable_msi_block_auto() interface
Date: Mon, 16 Dec 2013 09:35:00 +0100
Message-Id: <d9037b2ab455abff30e9c2da0a98e5e01b0940d7.1387140921.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1387140921.git.agordeev@redhat.com>
References: <cover.1387140921.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of introduction of pci_get_msi_vec_count()
interface pci_enable_msi_block_auto() function became
superflous.

To enable maximum possible number of MSIs drivers will
first obtain that number from pci_get_msi_vec_count()
function and then call pci_enable_msi_block() interface.

Function pci_enable_msi_block_auto() has been introduced
recently and its only user is AHCI driver, which is also
updated by this change.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 Documentation/PCI/MSI-HOWTO.txt |   39 ++++-----------------------
 drivers/ata/ahci.c              |   56 ++++++++++++++++++++++++--------------
 drivers/pci/msi.c               |   25 -----------------
 include/linux/pci.h             |    7 -----
 4 files changed, 41 insertions(+), 86 deletions(-)

diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
index c03b815..8d35d62 100644
--- a/Documentation/PCI/MSI-HOWTO.txt
+++ b/Documentation/PCI/MSI-HOWTO.txt
@@ -127,49 +127,22 @@ on the number of vectors that can be allocated; pci_enable_msi_block()
 returns as soon as it finds any constraint that doesn't allow the
 call to succeed.
 
-4.2.3 pci_enable_msi_block_auto
-
-int pci_enable_msi_block_auto(struct pci_dev *dev, int *count)
-
-This variation on pci_enable_msi() call allows a device driver to request
-the maximum possible number of MSIs.  The MSI specification only allows
-interrupts to be allocated in powers of two, up to a maximum of 2^5 (32).
-
-If this function returns a positive number, it indicates that it has
-succeeded and the returned value is the number of allocated interrupts. In
-this case, the function enables MSI on this device and updates dev->irq to
-be the lowest of the new interrupts assigned to it.  The other interrupts
-assigned to the device are in the range dev->irq to dev->irq + returned
-value - 1.
-
-If this function returns a negative number, it indicates an error and
-the driver should not attempt to request any more MSI interrupts for
-this device.
-
-If the device driver needs to know the number of interrupts the device
-supports it can pass the pointer count where that number is stored. The
-device driver must decide what action to take if pci_enable_msi_block_auto()
-succeeds, but returns a value less than the number of interrupts supported.
-If the device driver does not need to know the number of interrupts
-supported, it can set the pointer count to NULL.
-
-4.2.4 pci_disable_msi
+4.2.3 pci_disable_msi
 
 void pci_disable_msi(struct pci_dev *dev)
 
 This function should be used to undo the effect of pci_enable_msi() or
-pci_enable_msi_block() or pci_enable_msi_block_auto().  Calling it restores
-dev->irq to the pin-based interrupt number and frees the previously
-allocated message signaled interrupt(s).  The interrupt may subsequently be
-assigned to another device, so drivers should not cache the value of
-dev->irq.
+pci_enable_msi_block().  Calling it restores dev->irq to the pin-based
+interrupt number and frees the previously allocated message signaled
+interrupt(s).  The interrupt may subsequently be assigned to another
+device, so drivers should not cache the value of dev->irq.
 
 Before calling this function, a device driver must always call free_irq()
 on any interrupt for which it previously called request_irq().
 Failure to do so results in a BUG_ON(), leaving the device with
 MSI enabled and thus leaking its vector.
 
-4.2.5 pci_get_msi_vec_count
+4.2.4 pci_get_msi_vec_count
 
 int pci_get_msi_vec_count(struct pci_dev *dev)
 
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index e2903d0..e490d42 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1095,26 +1095,40 @@ static inline void ahci_gtf_filter_workaround(struct ata_host *host)
 {}
 #endif
 
-int ahci_init_interrupts(struct pci_dev *pdev, struct ahci_host_priv *hpriv)
+int ahci_init_interrupts(struct pci_dev *pdev, unsigned int n_ports,
+			 struct ahci_host_priv *hpriv)
 {
-	int rc;
-	unsigned int maxvec;
+	int rc, nvec;
 
-	if (!(hpriv->flags & AHCI_HFLAG_NO_MSI)) {
-		rc = pci_enable_msi_block_auto(pdev, &maxvec);
-		if (rc > 0) {
-			if ((rc == maxvec) || (rc == 1))
-				return rc;
-			/*
-			 * Assume that advantage of multipe MSIs is negated,
-			 * so fallback to single MSI mode to save resources
-			 */
-			pci_disable_msi(pdev);
-			if (!pci_enable_msi(pdev))
-				return 1;
-		}
-	}
+	if (hpriv->flags & AHCI_HFLAG_NO_MSI)
+		goto intx;
+
+	rc = pci_get_msi_vec_count(pdev);
+	if (rc < 0)
+		goto intx;
+
+	/*
+	 * If number of MSIs is less than number of ports then Sharing Last
+	 * Message mode could be enforced. In this case assume that advantage
+	 * of multipe MSIs is negated and use single MSI mode instead.
+	 */
+	if (rc < n_ports)
+		goto single_msi;
+
+	nvec = rc;
+	rc = pci_enable_msi_block(pdev, nvec);
+	if (rc)
+		goto intx;
 
+	return nvec;
+
+single_msi:
+	rc = pci_enable_msi(pdev);
+	if (rc)
+		goto intx;
+	return 1;
+
+intx:
 	pci_intx(pdev, 1);
 	return 0;
 }
@@ -1281,10 +1295,6 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	hpriv->mmio = pcim_iomap_table(pdev)[ahci_pci_bar];
 
-	n_msis = ahci_init_interrupts(pdev, hpriv);
-	if (n_msis > 1)
-		hpriv->flags |= AHCI_HFLAG_MULTI_MSI;
-
 	/* save initial config */
 	ahci_pci_save_initial_config(pdev, hpriv);
 
@@ -1339,6 +1349,10 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	n_ports = max(ahci_nr_ports(hpriv->cap), fls(hpriv->port_map));
 
+	n_msis = ahci_init_interrupts(pdev, n_ports, hpriv);
+	if (n_msis > 1)
+		hpriv->flags |= AHCI_HFLAG_MULTI_MSI;
+
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
 	if (!host)
 		return -ENOMEM;
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 8915edb..de1acb9 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -902,31 +902,6 @@ int pci_enable_msi_block(struct pci_dev *dev, int nvec)
 }
 EXPORT_SYMBOL(pci_enable_msi_block);
 
-int pci_enable_msi_block_auto(struct pci_dev *dev, int *maxvec)
-{
-	int ret, nvec;
-
-	if (dev->current_state != PCI_D0)
-		return -EINVAL;
-
-	ret = pci_get_msi_vec_count(dev);
-	if (ret < 0)
-		return ret;
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
index 997751d..8d9eb6b 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1164,12 +1164,6 @@ static inline int pci_enable_msi_block(struct pci_dev *dev, int nvec)
 	return -ENOSYS;
 }
 
-static inline int
-pci_enable_msi_block_auto(struct pci_dev *dev, int *maxvec)
-{
-	return -ENOSYS;
-}
-
 static inline void pci_msi_shutdown(struct pci_dev *dev)
 { }
 static inline void pci_disable_msi(struct pci_dev *dev)
@@ -1202,7 +1196,6 @@ static inline int pci_msi_enabled(void)
 #else
 int pci_get_msi_vec_count(struct pci_dev *dev);
 int pci_enable_msi_block(struct pci_dev *dev, int nvec);
-int pci_enable_msi_block_auto(struct pci_dev *dev, int *maxvec);
 void pci_msi_shutdown(struct pci_dev *dev);
 void pci_disable_msi(struct pci_dev *dev);
 int pci_msix_table_size(struct pci_dev *dev);
-- 
1.7.7.6

