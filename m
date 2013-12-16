Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab3LPSv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 13:51:57 -0500
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:28962 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754565Ab3LPSvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 13:51:49 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH v4 9/9] PCI/MSI: Introduce pci_auto_enable_msi*() family helpers
Date: Mon, 16 Dec 2013 09:35:02 +0100
Message-Id: <bbf6f73ef3e16e5dfd7d41fc1e4412f641acb0f3.1387140921.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1387140921.git.agordeev@redhat.com>
References: <cover.1387140921.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently many device drivers need contiguously call functions
pci_enable_msix() for MSI-X or pci_enable_msi_block() for MSI
in a loop until success or failure. This update generalizes
this usage pattern and introduces pci_auto_enable_msi*() family
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

	rc = pci_auto_enable_msix_range(adapter->pdev,
					adapter->msix_entries,
					FOO_DRIVER_MINIMUM_NVEC,
					nvec);

Device drivers with more specific requirements (i.e. a number of
MSI-Xs which is a multiple of a certain number within a specified
range) would still need to implement the loop using the two old
functions.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Suggested-by: Ben Hutchings <bhutchings@solarflare.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
---
 Documentation/PCI/MSI-HOWTO.txt |  134 +++++++++++++++++++++++++++++++++++++--
 drivers/pci/msi.c               |   74 +++++++++++++++++++++
 include/linux/pci.h             |   57 +++++++++++++++++
 3 files changed, 260 insertions(+), 5 deletions(-)

diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
index 7d19656..168d9c3 100644
--- a/Documentation/PCI/MSI-HOWTO.txt
+++ b/Documentation/PCI/MSI-HOWTO.txt
@@ -127,7 +127,62 @@ on the number of vectors that can be allocated; pci_enable_msi_block()
 returns as soon as it finds any constraint that doesn't allow the
 call to succeed.
 
-4.2.3 pci_disable_msi
+4.2.3 pci_auto_enable_msi_range
+
+int pci_auto_enable_msi_range(struct pci_dev *dev, struct msix_entry *entries,
+			      int minvec, int maxvec)
+
+This variation on pci_enable_msi_block() call allows a device driver to
+request any number of MSIs within specified range 'minvec' to 'maxvec'.
+Whenever possible device drivers are encouraged to use this function
+rather than explicit request loop calling pci_enable_msi_block().
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
+4.2.4 pci_auto_enable_msi
+
+int pci_auto_enable_msi(struct pci_dev *dev,
+			struct msix_entry *entries, int maxvec)
+
+This variation on pci_enable_msi_block() call allows a device driver to
+request any number of MSIs up to 'maxvec'. Whenever possible device drivers
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
+4.2.5 pci_auto_enable_msi_exact
+
+int pci_auto_enable_msi_exact(struct pci_dev *dev,
+			      struct msix_entry *entries, int nvec)
+
+This variation on pci_enable_msi_block() call allows a device driver to
+request exactly 'nvec' MSIs.
+
+If this function returns a negative number, it indicates an error and
+the driver should not attempt to request any more MSI interrupts for
+this device.
+
+If this function returns the value of 'nvec' it indicates MSI interrupts
+have been successfully allocated. No other value in case of success could
+be returned. Device drivers can use this value to further allocate and
+initialize device resources.
+
+4.2.6 pci_disable_msi
 
 void pci_disable_msi(struct pci_dev *dev)
 
@@ -142,7 +197,7 @@ on any interrupt for which it previously called request_irq().
 Failure to do so results in a BUG_ON(), leaving the device with
 MSI enabled and thus leaking its vector.
 
-4.2.4 pci_get_msi_vec_count
+4.2.7 pci_get_msi_vec_count
 
 int pci_get_msi_vec_count(struct pci_dev *dev)
 
@@ -222,7 +277,76 @@ static int foo_driver_enable_msix(struct foo_adapter *adapter, int nvec)
 	return -ENOSPC;
 }
 
-4.3.2 pci_disable_msix
+4.3.2 pci_auto_enable_msix_range
+
+int pci_auto_enable_msix_range(struct pci_dev *dev, struct msix_entry *entries,
+			       int minvec, int maxvec)
+
+This variation on pci_enable_msix() call allows a device driver to request
+any number of MSI-Xs within specified range 'minvec' to 'maxvec'. Whenever
+possible device drivers are encouraged to use this function rather than
+explicit request loop calling pci_enable_msix().
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
+	rc = pci_auto_enable_msix_range(adapter->pdev, adapter->msix_entries,
+					FOO_DRIVER_MINIMUM_NVEC, nvec);
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
+4.3.3 pci_auto_enable_msix
+
+int pci_auto_enable_msix(struct pci_dev *dev,
+			 struct msix_entry *entries, int maxvec)
+
+This variation on pci_enable_msix() call allows a device driver to request
+any number of MSI-Xs up to 'maxvec'. Whenever possible device drivers are
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
+4.3.4 pci_auto_enable_msix_exact
+
+int pci_auto_enable_msix_exact(struct pci_dev *dev,
+			       struct msix_entry *entries, int nvec)
+
+This variation on pci_enable_msix() call allows a device driver to request
+exactly 'nvec' MSI-Xs.
+
+If this function returns a negative number, it indicates an error and
+the driver should not attempt to allocate any more MSI-X interrupts for
+this device.
+
+If this function returns the value of 'nvec' it indicates MSI-X interrupts
+have been successfully allocated. No other value in case of success could
+be returned. Device drivers can use this value to further allocate and
+initialize device resources.
+
+4.3.5 pci_disable_msix
 
 void pci_disable_msix(struct pci_dev *dev)
 
@@ -236,14 +360,14 @@ on any interrupt for which it previously called request_irq().
 Failure to do so results in a BUG_ON(), leaving the device with
 MSI-X enabled and thus leaking its vector.
 
-4.3.3 The MSI-X Table
+4.3.6 The MSI-X Table
 
 The MSI-X capability specifies a BAR and offset within that BAR for the
 MSI-X Table.  This address is mapped by the PCI subsystem, and should not
 be accessed directly by the device driver.  If the driver wishes to
 mask or unmask an interrupt, it should call disable_irq() / enable_irq().
 
-4.3.4 pci_get_msix_vec_count
+4.3.7 pci_get_msix_vec_count
 
 int pci_get_msix_vec_count(struct pci_dev *dev)
 
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 18e877f5..ccfd49b 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1093,3 +1093,77 @@ void pci_msi_init_pci_dev(struct pci_dev *dev)
 	if (dev->msix_cap)
 		msix_set_enable(dev, 0);
 }
+
+/**
+ * pci_auto_enable_msi_range - configure device's MSI capability structure
+ * @dev: device to configure
+ * @minvec: minimal number of interrupts to configure
+ * @maxvec: maximum number of interrupts to configure
+ *
+ * This function tries to allocate a maximum possible number of interrupts in a
+ * range between @minvec and @maxvec. It returns a negative errno if an error
+ * occurs. If it succeeds, it returns the actual number of interrupts allocated
+ * and updates the @dev's irq member to the lowest new interrupt number;
+ * the other interrupt numbers allocated to this device are consecutive.
+ **/
+int pci_auto_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec)
+{
+	int nvec = maxvec;
+	int rc;
+
+	if (maxvec < minvec)
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
+EXPORT_SYMBOL(pci_auto_enable_msi_range);
+
+/**
+ * pci_auto_enable_msix_range - configure device's MSI-X capability structure
+ * @dev: pointer to the pci_dev data structure of MSI-X device function
+ * @entries: pointer to an array of MSI-X entries
+ * @minvec: minimum number of MSI-X irqs requested
+ * @maxvec: maximum number of MSI-X irqs requested
+ *
+ * Setup the MSI-X capability structure of device function with a maximum
+ * possible number of interrupts in the range between @minvec and @maxvec
+ * upon its software driver call to request for MSI-X mode enabled on its
+ * hardware device function. It returns a negative errno if an error occurs.
+ * If it succeeds, it returns the actual number of interrupts allocated and
+ * indicates the successful configuration of MSI-X capability structure
+ * with new allocated MSI-X interrupts.
+ **/
+int pci_auto_enable_msix_range(struct pci_dev *dev, struct msix_entry *entries,
+			       int minvec, int maxvec)
+{
+	int nvec = maxvec;
+	int rc;
+
+	if (maxvec < minvec)
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
+EXPORT_SYMBOL(pci_auto_enable_msix_range);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 7941f06..7e30b52 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1193,6 +1193,38 @@ static inline int pci_msi_enabled(void)
 {
 	return 0;
 }
+
+int pci_auto_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec)
+{
+	return -ENOSYS;
+}
+static inline int pci_auto_enable_msi(struct pci_dev *dev, int maxvec)
+{
+	return -ENOSYS;
+}
+static inline int pci_auto_enable_msi_exact(struct pci_dev *dev, int nvec)
+{
+	return -ENOSYS;
+}
+
+static inline int
+pci_auto_enable_msix_range(struct pci_dev *dev,
+			   struct msix_entry *entries, int minvec, int maxvec)
+{
+	return -ENOSYS;
+}
+static inline int
+pci_auto_enable_msix(struct pci_dev *dev,
+		     struct msix_entry *entries, int maxvec)
+{
+	return -ENOSYS;
+}
+static inline int
+pci_auto_enable_msix_exact(struct pci_dev *dev,
+			   struct msix_entry *entries, int nvec)
+{
+	return -ENOSYS;
+}
 #else
 int pci_get_msi_vec_count(struct pci_dev *dev);
 int pci_enable_msi_block(struct pci_dev *dev, int nvec);
@@ -1205,6 +1237,31 @@ void pci_disable_msix(struct pci_dev *dev);
 void msi_remove_pci_irq_vectors(struct pci_dev *dev);
 void pci_restore_msi_state(struct pci_dev *dev);
 int pci_msi_enabled(void);
+
+int pci_auto_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec);
+static inline int pci_auto_enable_msi(struct pci_dev *dev, int maxvec)
+{
+	return pci_auto_enable_msi_range(dev, 1, maxvec);
+}
+static inline int pci_auto_enable_msi_exact(struct pci_dev *dev, int nvec)
+{
+	return pci_auto_enable_msi_range(dev, nvec, nvec);
+}
+
+int pci_auto_enable_msix_range(struct pci_dev *dev, struct msix_entry *entries,
+			       int minvec, int maxvec);
+static inline int
+pci_auto_enable_msix(struct pci_dev *dev,
+		     struct msix_entry *entries, int maxvec)
+{
+	return pci_auto_enable_msix_range(dev, entries, 1, maxvec);
+}
+static inline int
+pci_auto_enable_msix_exact(struct pci_dev *dev,
+			   struct msix_entry *entries, int nvec)
+{
+	return pci_auto_enable_msix_range(dev, entries, nvec, nvec);
+}
 #endif
 
 #ifdef CONFIG_PCIEPORTBUS
-- 
1.7.7.6

