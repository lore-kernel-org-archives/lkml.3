Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab3AQPVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 10:21:35 -0500
Received: from service87.mimecast.com ([91.220.42.44]:43841 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab3AQPVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 10:21:32 -0500
Date: Thu, 17 Jan 2013 15:21:28 +0000
From: Andrew Murray <Andrew.Murray@arm.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH RFC] Provide MSI controller registration mechanism
Message-ID: <20130117152128.GA25960@arm.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 17 Jan 2013 15:21:29.0777 (UTC) FILETIME=[530E7210:01CDF4C6]
X-MC-Unique: 113011715213011101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was my initial attempt at providing an architecture agnostic MSI
controller. Whilst it does not do anything to allow multiple MSI controllers on
a platform as has been recently discussed, it can prevent linker errors when
building multiplatform kernels.
---
Implementing MSI controller support for devices that can be supported across
multiple architectures is made difficult due to the inconsistent handling of
MSIs across the architectures. This would lead to unnecessary conditional code
in an architecture agnostic MSI driver.

At present each MSI supporting architecture implements MSI callbacks
(include/linux/msi.h). In some architectures (arm, mips, tile) the callbacks
are implemented directly for each end user (SoC), e.g.
arch/arm/mach-iop13xx/msi.c, arch/mips/pci/pci-xlr.c, arch/tile/kernel/pci_gx.c.
In these scenarios where multiple MSI controllers exist (e.g. mips) it would be
impossible to produce a kernel image with support for multiple targets due to
multiple implementations of the callbacks (linker errors).

In other architectures (ia64, x86, powerpc) the callbacks are abstracted
through machine vector tables (e.g. arch/ia64/include/asm/machvec.h,
arch/powerpc/include/asm/machdep.h) - this approach allows for a form of
registration for end-users (in the case of powerpc: /platforms/*/*msi.c,
/platforms/powernv/pci.c, /sysdev/fsl_msi.c, /sysdev/*msi.c). Where multiple
controllers exist, run-time warnings may appear or the latest registered wins.

This patch provides for registration of MSI support in a common way. It is
hoped that further development of this mechansim will allow for multiple MSI
controllers serving different PCI domains and/or host-bridges.

In the case of sparc it appears as though the MSI implementation used depends
on the requesting PCI device's host bridge controller. As such multiple MSI
controllers can co-exist and as such sparc will not immediately benefit from
this patch.

This patch preserves the existing arch_ callback mechanism such that MSI support
will not break where this registration mechanism is not used - though it is
hoped that architectures will transition to this new mechanism and the old
callbacks can be deprecated.

The existing mechanism resulted in linker errors when arch_setup_msi_irq /
arch_teardown_msi_irq were not defined or defined multiple times - this no
longer occurs and a WARN is issued instead.

Signed-off-by: Andrew Murray <Andrew.Murray@arm.com>
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 drivers/pci/msi.c   |  113 +++++++++++++++++++++++++++++++++++++++++++--------
 include/linux/msi.h |   16 +++++++-
 2 files changed, 111 insertions(+), 18 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index a825d78..352d4fe 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -25,9 +25,21 @@
 #include "msi.h"
 
 static int pci_msi_enable = 1;
+static struct msi_controller *ops;
 
 /* Arch hooks */
 
+static int __arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
+{
+	if (!ops)
+		return arch_msi_check_device(dev, nvec, type);
+
+	if (ops->msi_check_device)
+		return ops->msi_check_device(dev, nvec, type);
+
+	return 0;
+}
+
 #ifndef arch_msi_check_device
 int arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
 {
@@ -35,12 +47,44 @@ int arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
 }
 #endif
 
+int __weak arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
+{
+	WARN_ON_ONCE(1);
+	return 1;
+}
+
+static int __arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
+{
+	if (!ops)
+		return arch_setup_msi_irq(dev, desc);
+
+	if (ops->setup_msi_irq)
+		return ops->setup_msi_irq(dev, desc);
+
+	WARN_ON_ONCE(1);
+	return 1;
+}
+
+void __weak arch_teardown_msi_irq(unsigned int irq)
+{
+	WARN_ON_ONCE(1);
+}
+
+static void __arch_teardown_msi_irq(unsigned int irq)
+{
+	if (!ops)
+		return arch_teardown_msi_irq(irq);
+
+	if (ops->teardown_msi_irq)
+		return ops->teardown_msi_irq(irq);
+
+	WARN_ON_ONCE(1);
+}
+
 #ifndef arch_setup_msi_irqs
 # define arch_setup_msi_irqs default_setup_msi_irqs
-# define HAVE_DEFAULT_MSI_SETUP_IRQS
 #endif
 
-#ifdef HAVE_DEFAULT_MSI_SETUP_IRQS
 int default_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
 	struct msi_desc *entry;
@@ -54,7 +98,7 @@ int default_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		return 1;
 
 	list_for_each_entry(entry, &dev->msi_list, list) {
-		ret = arch_setup_msi_irq(dev, entry);
+		ret = __arch_setup_msi_irq(dev, entry);
 		if (ret < 0)
 			return ret;
 		if (ret > 0)
@@ -63,14 +107,22 @@ int default_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 
 	return 0;
 }
-#endif
+
+static int __arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+{
+	if (!ops)
+		return arch_setup_msi_irqs(dev, nvec, type);
+
+	if (ops->setup_msi_irqs)
+		return ops->setup_msi_irqs(dev, nvec, type);
+
+	return default_setup_msi_irqs(dev, nvec, type);
+}
 
 #ifndef arch_teardown_msi_irqs
 # define arch_teardown_msi_irqs default_teardown_msi_irqs
-# define HAVE_DEFAULT_MSI_TEARDOWN_IRQS
 #endif
 
-#ifdef HAVE_DEFAULT_MSI_TEARDOWN_IRQS
 void default_teardown_msi_irqs(struct pci_dev *dev)
 {
 	struct msi_desc *entry;
@@ -81,17 +133,25 @@ void default_teardown_msi_irqs(struct pci_dev *dev)
 			continue;
 		nvec = 1 << entry->msi_attrib.multiple;
 		for (i = 0; i < nvec; i++)
-			arch_teardown_msi_irq(entry->irq + i);
+			__arch_teardown_msi_irq(entry->irq + i);
 	}
 }
-#endif
+
+static void __arch_teardown_msi_irqs(struct pci_dev *dev)
+{
+	if (!ops)
+		return arch_teardown_msi_irqs(dev);
+
+	if (ops->teardown_msi_irqs)
+		return ops->teardown_msi_irqs(dev);
+
+	default_teardown_msi_irqs(dev);
+}
 
 #ifndef arch_restore_msi_irqs
 # define arch_restore_msi_irqs default_restore_msi_irqs
-# define HAVE_DEFAULT_MSI_RESTORE_IRQS
 #endif
 
-#ifdef HAVE_DEFAULT_MSI_RESTORE_IRQS
 void default_restore_msi_irqs(struct pci_dev *dev, int irq)
 {
 	struct msi_desc *entry;
@@ -109,7 +169,26 @@ void default_restore_msi_irqs(struct pci_dev *dev, int irq)
 	if (entry)
 		write_msi_msg(irq, &entry->msg);
 }
-#endif
+
+static void __arch_restore_msi_irqs(struct pci_dev *dev, int irq)
+{
+	if (!ops)
+		return arch_restore_msi_irqs(dev, irq);
+
+	if (ops->restore_msi_irqs)
+		return ops->restore_msi_irqs(dev, irq);
+
+	default_restore_msi_irqs(dev, irq);
+}
+
+int pci_register_msi_controller(struct msi_controller *controller)
+{
+	WARN_ON(ops);
+	ops = controller;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_register_msi_controller);
 
 static void msi_set_enable(struct pci_dev *dev, int pos, int enable)
 {
@@ -341,7 +420,7 @@ static void free_msi_irqs(struct pci_dev *dev)
 			BUG_ON(irq_has_action(entry->irq + i));
 	}
 
-	arch_teardown_msi_irqs(dev);
+	__arch_teardown_msi_irqs(dev);
 
 	list_for_each_entry_safe(entry, tmp, &dev->msi_list, list) {
 		if (entry->msi_attrib.is_msix) {
@@ -397,7 +476,7 @@ static void __pci_restore_msi_state(struct pci_dev *dev)
 
 	pci_intx_for_msi(dev, 0);
 	msi_set_enable(dev, pos, 0);
-	arch_restore_msi_irqs(dev, dev->irq);
+	__arch_restore_msi_irqs(dev, dev->irq);
 
 	pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &control);
 	msi_mask_irq(entry, msi_capable_mask(control), entry->masked);
@@ -425,7 +504,7 @@ static void __pci_restore_msix_state(struct pci_dev *dev)
 	pci_write_config_word(dev, pos + PCI_MSIX_FLAGS, control);
 
 	list_for_each_entry(entry, &dev->msi_list, list) {
-		arch_restore_msi_irqs(dev, entry->irq);
+		__arch_restore_msi_irqs(dev, entry->irq);
 		msix_mask_irq(entry, entry->masked);
 	}
 
@@ -576,7 +655,7 @@ static int msi_capability_init(struct pci_dev *dev, int nvec)
 	list_add_tail(&entry->list, &dev->msi_list);
 
 	/* Configure MSI capability structure */
-	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSI);
+	ret = __arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSI);
 	if (ret) {
 		msi_mask_irq(entry, mask, ~mask);
 		free_msi_irqs(dev);
@@ -696,7 +775,7 @@ static int msix_capability_init(struct pci_dev *dev,
 	if (ret)
 		return ret;
 
-	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
+	ret = __arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
 	if (ret)
 		goto error;
 
@@ -785,7 +864,7 @@ static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
 		if (bus->bus_flags & PCI_BUS_FLAGS_NO_MSI)
 			return -EINVAL;
 
-	ret = arch_msi_check_device(dev, nvec, type);
+	ret = __arch_msi_check_device(dev, nvec, type);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/msi.h b/include/linux/msi.h
index ce93a34..f98c7f0 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -49,14 +49,28 @@ struct msi_desc {
 	struct kobject kobj;
 };
 
+struct msi_controller {
+	int (*setup_msi_irq)(struct pci_dev *dev, struct msi_desc *desc);
+	void (*teardown_msi_irq)(unsigned int irq);
+	int (*setup_msi_irqs)(struct pci_dev *dev, int nvec, int type);
+	void (*teardown_msi_irqs)(struct pci_dev *dev);
+	int (*msi_check_device)(struct pci_dev *dev, int nvec, int type);
+	void (*restore_msi_irqs)(struct pci_dev *dev, int irq);
+};
+
+/* Registration of MSI controller operations */
+int pci_register_msi_controller(struct msi_controller *);
+
 /*
  * The arch hook for setup up msi irqs
+ * These calls are deprecated and pci_register_msi_controller should be used
+ * instead.
  */
 int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc);
 void arch_teardown_msi_irq(unsigned int irq);
 extern int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
 extern void arch_teardown_msi_irqs(struct pci_dev *dev);
 extern int arch_msi_check_device(struct pci_dev* dev, int nvec, int type);
-
+void arch_restore_msi_irqs(struct pci_dev *dev, int irq);
 
 #endif /* LINUX_MSI_H */
-- 
1.7.0.4


