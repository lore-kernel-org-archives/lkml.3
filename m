Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab3JSHIf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 03:08:35 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:15287 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750985Ab3JSHId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 03:08:33 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH RFC v2 12/29] PCI/MSI: Introduce pcim_enable_msi*() family helpers
Date: Fri, 18 Oct 2013 19:12:12 +0200
Message-Id: <6bc575621ef70f72b206e4aa944acd32f1a75718.1382103786.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1382103786.git.agordeev@redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently many device drivers need contiguously call functions
pci_enable_msix() for MSI-X or pci_enable_msi_block() for MSI
in a loop until success or failure. This update generalizes
this usage pattern and introduces pcim_enable_msi*() family
helpers.

As result, device drivers do not have to deal with tri-state
return values from pci_enable_msix() and pci_enable_msi_block()
functions directly and expected to have more clearer and straight
code.

So i.e. the request loop described in the documentation...

	int foo_driver_enable_msix(struct foo_adapter *adapter,
				   int nvec)
	{
		while (nvec >= FOO_DRIVER_MINIMUM_NVEC) {
			rc = pci_enable_msix(adapter->pdev,
					     adapter->msix_entries,
					     nvec);
			if (rc > 0)
				nvec = rc;
			else
				return rc;
		}

		return -ENOSPC;
	}

...would turn into a single helper call....

	rc = pcim_enable_msix_range(adapter->pdev,
				    adapter->msix_entries,
				    nvec,
				    FOO_DRIVER_MINIMUM_NVEC);

Device drivers with more specific requirements (i.e. a number of
MSI-Xs which is a multiple of a certain number within a specified
range) would still need to implement the loop using the two old
functions.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Suggested-by: Ben Hutchings <bhutchings@solarflare.com>
---
 Documentation/PCI/MSI-HOWTO.txt |  134 +++++++++++++++++++++++++++++++++++++--
 drivers/pci/msi.c               |   46 +++++++++++++
 include/linux/pci.h             |   59 +++++++++++++++++
 3 files changed, 234 insertions(+), 5 deletions(-)

diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
index fdf3ae3..f348b6f 100644
--- a/Documentation/PCI/MSI-HOWTO.txt
+++ b/Documentation/PCI/MSI-HOWTO.txt
@@ -127,7 +127,62 @@ on the number of vectors that can be allocated; pci_enable_msi_block()
 returns as soon as it finds any constraint that doesn't allow the
 call to succeed.
 
-4.2.3 pci_disable_msi
+4.2.3 pcim_enable_msi_range
+
+int pcim_enable_msi_range(struct pci_dev *dev, struct msix_entry *entries,
+			  unsigned int nvec, unsigned int minvec)
+
+This variation on pci_enable_msi_block() call allows a device driver to
+request any number of MSIs within specified range minvec to nvec. Whenever
+possible device drivers are encouraged to use this function rather than
+explicit request loop calling pci_enable_msi_block().
+
+If this function returns a negative number, it indicates an error and
+the driver should not attempt to request any more MSI interrupts for
+this device.
+
+If this function returns a positive number it indicates at least the
+returned number of MSI interrupts have been successfully allocated (it may
+have allocated more in order to satisfy the power-of-two requirement).
+Device drivers can use this number to further initialize devices.
+
+4.2.4 pcim_enable_msi
+
+int pcim_enable_msi(struct pci_dev *dev,
+		    struct msix_entry *entries, unsigned int maxvec)
+
+This variation on pci_enable_msi_block() call allows a device driver to
+request any number of MSIs up to maxvec. Whenever possible device drivers
+are encouraged to use this function rather than explicit request loop
+calling pci_enable_msi_block().
+
+If this function returns a negative number, it indicates an error and
+the driver should not attempt to request any more MSI interrupts for
+this device.
+
+If this function returns a positive number it indicates at least the
+returned number of MSI interrupts have been successfully allocated (it may
+have allocated more in order to satisfy the power-of-two requirement).
+Device drivers can use this number to further initialize devices.
+
+4.2.5 pcim_enable_msi_exact
+
+int pcim_enable_msi_exact(struct pci_dev *dev,
+			  struct msix_entry *entries, unsigned int nvec)
+
+This variation on pci_enable_msi_block() call allows a device driver to
+request exactly nvec MSIs.
+
+If this function returns a negative number, it indicates an error and
+the driver should not attempt to request any more MSI interrupts for
+this device.
+
+If this function returns the value of nvec it indicates MSI interrupts
+have been successfully allocated. No other value in case of success could
+be returned. Device drivers can use this value to further allocate and
+initialize device resources.
+
+4.2.6 pci_disable_msi
 
 void pci_disable_msi(struct pci_dev *dev)
 
@@ -143,7 +198,7 @@ on any interrupt for which it previously called request_irq().
 Failure to do so results in a BUG_ON(), leaving the device with
 MSI enabled and thus leaking its vector.
 
-4.2.4 pci_get_msi_cap
+4.2.7 pci_get_msi_cap
 
 int pci_get_msi_cap(struct pci_dev *dev)
 
@@ -224,7 +279,76 @@ static int foo_driver_enable_msix(struct foo_adapter *adapter, int nvec)
 	return -ENOSPC;
 }
 
-4.3.2 pci_disable_msix
+4.3.2 pcim_enable_msix_range
+
+int pcim_enable_msix_range(struct pci_dev *dev, struct msix_entry *entries,
+			   unsigned int nvec, unsigned int minvec)
+
+This variation on pci_enable_msix() call allows a device driver to request
+any number of MSI-Xs within specified range minvec to nvec. Whenever possible
+device drivers are encouraged to use this function rather than explicit
+request loop calling pci_enable_msix().
+
+If this function returns a negative number, it indicates an error and
+the driver should not attempt to allocate any more MSI-X interrupts for
+this device.
+
+If this function returns a positive number it indicates the number of
+MSI-X interrupts that have been successfully allocated. Device drivers
+can use this number to further allocate and initialize device resources.
+
+A modified function calling pci_enable_msix() in a loop might look like:
+
+static int foo_driver_enable_msix(struct foo_adapter *adapter, int nvec)
+{
+	rc = pcim_enable_msix_range(adapter->pdev, adapter->msix_entries,
+				    nvec, FOO_DRIVER_MINIMUM_NVEC);
+	if (rc < 0)
+		return rc;
+
+	rc = foo_driver_init_other(adapter, rc);
+	if (rc < 0)
+		pci_disable_msix(adapter->pdev);
+
+	return rc;
+}
+
+4.3.3 pcim_enable_msix
+
+int pcim_enable_msix(struct pci_dev *dev,
+		     struct msix_entry *entries, unsigned int maxvec)
+
+This variation on pci_enable_msix() call allows a device driver to request
+any number of MSI-Xs up to maxvec. Whenever possible device drivers are
+encouraged to use this function rather than explicit request loop calling
+pci_enable_msix().
+
+If this function returns a negative number, it indicates an error and
+the driver should not attempt to allocate any more MSI-X interrupts for
+this device.
+
+If this function returns a positive number it indicates the number of
+MSI-X interrupts that have been successfully allocated. Device drivers
+can use this number to further allocate and initialize device resources.
+
+4.3.4 pcim_enable_msix_exact
+
+int pcim_enable_msix_exact(struct pci_dev *dev,
+			   struct msix_entry *entries, unsigned int nvec)
+
+This variation on pci_enable_msix() call allows a device driver to request
+exactly nvec MSI-Xs.
+
+If this function returns a negative number, it indicates an error and
+the driver should not attempt to allocate any more MSI-X interrupts for
+this device.
+
+If this function returns the value of nvec it indicates MSI-X interrupts
+have been successfully allocated. No other value in case of success could
+be returned. Device drivers can use this value to further allocate and
+initialize device resources.
+
+4.3.5 pci_disable_msix
 
 void pci_disable_msix(struct pci_dev *dev)
 
@@ -238,14 +362,14 @@ on any interrupt for which it previously called request_irq().
 Failure to do so results in a BUG_ON(), leaving the device with
 MSI-X enabled and thus leaking its vector.
 
-4.3.3 The MSI-X Table
+4.3.6 The MSI-X Table
 
 The MSI-X capability specifies a BAR and offset within that BAR for the
 MSI-X Table.  This address is mapped by the PCI subsystem, and should not
 be accessed directly by the device driver.  If the driver wishes to
 mask or unmask an interrupt, it should call disable_irq() / enable_irq().
 
-4.3.4 pci_msix_table_size
+4.3.7 pci_msix_table_size
 
 int pci_msix_table_size(struct pci_dev *dev)
 
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 96f51d0..91acd8a 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1042,3 +1042,49 @@ void pci_msi_init_pci_dev(struct pci_dev *dev)
 	if (dev->msix_cap)
 		msix_set_enable(dev, 0);
 }
+
+int pcim_enable_msi_range(struct pci_dev *dev,
+			  unsigned int nvec, unsigned int minvec)
+{
+	int rc;
+
+	if (nvec < minvec)
+		return -ERANGE;
+
+	do {
+		rc = pci_enable_msi_block(dev, nvec);
+		if (rc < 0) {
+			return rc;
+		} else if (rc > 0) {
+			if (rc < minvec)
+				return -ENOSPC;
+			nvec = rc;
+		}
+	} while (rc);
+
+	return nvec;
+}
+EXPORT_SYMBOL(pcim_enable_msi_range);
+
+int pcim_enable_msix_range(struct pci_dev *dev, struct msix_entry *entries,
+			   unsigned int nvec, unsigned int minvec)
+{
+	int rc;
+
+	if (nvec < minvec)
+		return -ERANGE;
+
+	do {
+		rc = pci_enable_msix(dev, entries, nvec);
+		if (rc < 0) {
+			return rc;
+		} else if (rc > 0) {
+			if (rc < minvec)
+				return -ENOSPC;
+			nvec = rc;
+		}
+	} while (rc);
+
+	return nvec;
+}
+EXPORT_SYMBOL(pcim_enable_msix_range);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index bef5775..3c18a8f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1185,6 +1185,39 @@ static inline int pci_msi_enabled(void)
 {
 	return 0;
 }
+
+int pcim_enable_msi_range(struct pci_dev *dev,
+			  unsigned int nvec, unsigned int minvec)
+{
+	return -ENOSYS;
+}
+static inline int pcim_enable_msi(struct pci_dev *dev, unsigned int maxvec)
+{
+	return -ENOSYS;
+}
+static inline int pcim_enable_msi_exact(struct pci_dev *dev, unsigned int nvec)
+{
+	return -ENOSYS;
+}
+
+static inline int
+pcim_enable_msix_range(struct pci_dev *dev, struct msix_entry *entries,
+		       unsigned int nvec, unsigned int maxvec)
+{
+	return -ENOSYS;
+}
+static inline int
+pcim_enable_msix(struct pci_dev *dev,
+		 struct msix_entry *entries, unsigned int maxvec)
+{
+	return -ENOSYS;
+}
+static inline int
+pcim_enable_msix_exact(struct pci_dev *dev,
+		       struct msix_entry *entries, unsigned int nvec)
+{
+	return -ENOSYS;
+}
 #else
 int pci_get_msi_cap(struct pci_dev *dev);
 int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec);
@@ -1198,6 +1231,32 @@ void pci_disable_msix(struct pci_dev *dev);
 void msi_remove_pci_irq_vectors(struct pci_dev *dev);
 void pci_restore_msi_state(struct pci_dev *dev);
 int pci_msi_enabled(void);
+
+int pcim_enable_msi_range(struct pci_dev *dev,
+			  unsigned int nvec, unsigned int minvec);
+static inline int pcim_enable_msi(struct pci_dev *dev, unsigned int maxvec)
+{
+	return pcim_enable_msi_range(dev, maxvec, 1);
+}
+static inline int pcim_enable_msi_exact(struct pci_dev *dev, unsigned int nvec)
+{
+	return pcim_enable_msi_range(dev, nvec, nvec);
+}
+
+int pcim_enable_msix_range(struct pci_dev *dev, struct msix_entry *entries,
+			   unsigned int nvec, unsigned int minvec);
+static inline int
+pcim_enable_msix(struct pci_dev *dev,
+		 struct msix_entry *entries, unsigned int maxvec)
+{
+	return pcim_enable_msix_range(dev, entries, maxvec, 1);
+}
+static inline int
+pcim_enable_msix_exact(struct pci_dev *dev,
+		       struct msix_entry *entries, unsigned int nvec)
+{
+	return pcim_enable_msix_range(dev, entries, nvec, nvec);
+}
 #endif
 
 #ifdef CONFIG_PCIEPORTBUS
-- 
1.7.7.6

