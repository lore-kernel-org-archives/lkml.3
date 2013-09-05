Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762579Ab3IEMue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 08:50:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759571Ab3IEMuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 08:50:32 -0400
Date: Thu, 5 Sep 2013 14:52:08 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-pci@vger.kernel.org, linux-ide@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v2 1/6] PCI/MSI: Introduce pci_enable_msi_block_part()
 interface
Message-ID: <15ae99e10915eafcef9749de593ac6b0aa0bee53.1378383792.git.agordeev@redhat.com>
References: <cover.1378383792.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1378383792.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are PCI devices that require a particular value written
to the Multiple Message Enable (MME) register while aligned on
power of 2 boundary value of actually used MSI vectors 'nvec'
is a lesser of that MME value:

	roundup_pow_of_two(nvec) < 'Multiple Message Enable'

However the existing pci_enable_msi_block() interface is not
able to configure such devices, since the value written to the
MME register is calculated from the number of requested MSIs
'nvec':

	'Multiple Message Enable' = roundup_pow_of_two(nvec)

In this case the result written to the MME register may not
satisfy the aforementioned PCI devices requirement and therefore
the PCI functions will not operate in a desired mode.

This update introduces pci_enable_msi_block_part() extension to
pci_enable_msi_block() interface that accepts extra 'nvec_mme'
argument which is then written to the MME register while the
value of 'nvec' is still used to setup as many interrupts as
requested.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 Documentation/PCI/MSI-HOWTO.txt |   56 ++++++++++++++++++++++++----
 arch/mips/pci/msi-octeon.c      |    2 +-
 arch/powerpc/kernel/msi.c       |    4 +-
 arch/s390/pci/pci.c             |    2 +-
 arch/x86/include/asm/pci.h      |    8 +++--
 arch/x86/include/asm/x86_init.h |    3 +-
 arch/x86/kernel/apic/io_apic.c  |    3 +-
 drivers/iommu/irq_remapping.c   |    2 +-
 drivers/pci/msi.c               |   77 ++++++++++++++++++++++++++-------------
 include/linux/msi.h             |    5 ++-
 include/linux/pci.h             |    8 ++++
 11 files changed, 125 insertions(+), 45 deletions(-)

diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
index a091780..32d7d15 100644
--- a/Documentation/PCI/MSI-HOWTO.txt
+++ b/Documentation/PCI/MSI-HOWTO.txt
@@ -127,7 +127,47 @@ on the number of vectors that can be allocated; pci_enable_msi_block()
 returns as soon as it finds any constraint that doesn't allow the
 call to succeed.
 
-4.2.3 pci_enable_msi_block_auto
+4.2.3 pci_enable_msi_block_part
+
+int pci_enable_msi_block_part(struct pci_dev *dev, int count, int alloc)
+
+This variation on the above call allows a device driver to request 'alloc'
+number of multiple MSIs while setup 'count' number of MSIs, which could be
+a lesser of 'alloc'.  The MSI specification only allows interrupts to be
+allocated in powers of two, up to a maximum of 2^5 (32).
+
+In case the driver wants to allocate a maximum possible number of MSIs
+for the device it may pass a negative number as 'alloc' parameter.
+
+If this function returns 0, it has succeeded in allocating 'alloc'
+interrupts and setting up 'count' interrupts. In this case, the function
+enables MSI on this device and updates dev->irq to be the lowest of the
+new interrupts assigned to it.  The other interrupts assigned to the
+device are in the range dev->irq to dev->irq + count - 1.
+
+If this function returns -ERANGE, it indicates 'count' is greater than
+'alloc' and the driver should adjust either or both parameters.
+
+If this function returns other negative number, it indicates an error
+and the driver should not attempt to request any more MSI interrupts
+for this device.  If this function returns a positive number, it is
+less than 'alloc' and indicates the number of interrupts that could have
+been allocated.  In neither case is the irq value updated or the device
+switched into MSI mode.
+
+The device driver must decide what action to take if
+pci_enable_msi_block_part() returns a value less than 'alloc'.  For
+instance, the driver could still make use of fewer interrupts; in this
+case the driver should possibly adjust 'count' parameter and call
+pci_enable_msi_block_part() again or even call pci_enable_msi_block()
+instead.  Note that it is not guaranteed to succeed, even when the
+'alloc' has been reduced to the value returned from a previous call to
+pci_enable_msi_block_part().  This is because there are multiple
+constraints on the number of vectors that can be allocated;
+pci_enable_msi_block_part() returns as soon as it finds any constraint
+that doesn't allow the call to succeed.
+
+4.2.4 pci_enable_msi_block_auto
 
 int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *count)
 
@@ -153,16 +193,16 @@ succeeds, but returns a value less than the number of interrupts supported.
 If the device driver does not need to know the number of interrupts
 supported, it can set the pointer count to NULL.
 
-4.2.4 pci_disable_msi
+4.2.5 pci_disable_msi
 
 void pci_disable_msi(struct pci_dev *dev)
 
-This function should be used to undo the effect of pci_enable_msi() or
-pci_enable_msi_block() or pci_enable_msi_block_auto().  Calling it restores
-dev->irq to the pin-based interrupt number and frees the previously
-allocated message signaled interrupt(s).  The interrupt may subsequently be
-assigned to another device, so drivers should not cache the value of
-dev->irq.
+This function should be used to undo the effect of pci_enable_msi_block(),
+pci_enable_msi(), pci_enable_msi_block_auto() or pci_enable_msi_block_part().
+Calling it restores dev->irq to the pin-based interrupt number and frees the
+previously allocated message signaled interrupt(s). The interrupt may
+subsequently be assigned to another device, so drivers should not cache the
+value of dev->irq.
 
 Before calling this function, a device driver must always call free_irq()
 on any interrupt for which it previously called request_irq().
diff --git a/arch/mips/pci/msi-octeon.c b/arch/mips/pci/msi-octeon.c
index d37be36..c9aaf8d 100644
--- a/arch/mips/pci/msi-octeon.c
+++ b/arch/mips/pci/msi-octeon.c
@@ -177,7 +177,7 @@ msi_irq_allocated:
 	return 0;
 }
 
-int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int nvec_mme, int type)
 {
 	struct msi_desc *entry;
 	int ret;
diff --git a/arch/powerpc/kernel/msi.c b/arch/powerpc/kernel/msi.c
index 8bbc12d..fc70513 100644
--- a/arch/powerpc/kernel/msi.c
+++ b/arch/powerpc/kernel/msi.c
@@ -13,7 +13,7 @@
 
 #include <asm/machdep.h>
 
-int arch_msi_check_device(struct pci_dev* dev, int nvec, int type)
+int arch_msi_check_device(struct pci_dev* dev, int nvec, int nvec_mme, int type)
 {
 	if (!ppc_md.setup_msi_irqs || !ppc_md.teardown_msi_irqs) {
 		pr_debug("msi: Platform doesn't provide MSI callbacks.\n");
@@ -32,7 +32,7 @@ int arch_msi_check_device(struct pci_dev* dev, int nvec, int type)
         return 0;
 }
 
-int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int nvec_mme, int type)
 {
 	return ppc_md.setup_msi_irqs(dev, nvec, type);
 }
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index e2956ad..688a5db 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -538,7 +538,7 @@ static void zpci_teardown_msi(struct pci_dev *pdev)
 		aisb_max--;
 }
 
-int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
+int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int nvec_mme, int type)
 {
 	pr_debug("%s: requesting %d MSI-X interrupts...", __func__, nvec);
 	if (type != PCI_CAP_ID_MSIX && type != PCI_CAP_ID_MSI)
diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index d9e9e6c..620642f 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -101,9 +101,10 @@ extern void pci_iommu_alloc(void);
 
 #ifdef CONFIG_PCI_MSI
 /* MSI arch specific hooks */
-static inline int x86_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+static inline int x86_setup_msi_irqs(struct pci_dev *dev,
+				     int nvec, int nvec_mme, int type)
 {
-	return x86_msi.setup_msi_irqs(dev, nvec, type);
+	return x86_msi.setup_msi_irqs(dev, nvec, nvec_mme, type);
 }
 
 static inline void x86_teardown_msi_irqs(struct pci_dev *dev)
@@ -125,7 +126,8 @@ static inline void x86_restore_msi_irqs(struct pci_dev *dev, int irq)
 #define arch_restore_msi_irqs x86_restore_msi_irqs
 /* implemented in arch/x86/kernel/apic/io_apic. */
 struct msi_desc;
-int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
+int native_setup_msi_irqs(struct pci_dev *dev,
+			  int nvec, int nvec_mme, int type);
 void native_teardown_msi_irq(unsigned int irq);
 void native_restore_msi_irqs(struct pci_dev *dev, int irq);
 int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 828a156..04a8767 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -174,7 +174,8 @@ struct pci_dev;
 struct msi_msg;
 
 struct x86_msi_ops {
-	int (*setup_msi_irqs)(struct pci_dev *dev, int nvec, int type);
+	int (*setup_msi_irqs)(struct pci_dev *dev,
+			      int nvec, int nvec_mme, int type);
 	void (*compose_msi_msg)(struct pci_dev *dev, unsigned int irq,
 				unsigned int dest, struct msi_msg *msg,
 			       u8 hpet_id);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 9ed796c..21f6a44 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3132,7 +3132,8 @@ int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 	return 0;
 }
 
-int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+int native_setup_msi_irqs(struct pci_dev *dev,
+			  int nvec, int nvec_mme, int type)
 {
 	unsigned int irq, irq_want;
 	struct msi_desc *msidesc;
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 39f81ae..1a220a0 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -142,7 +142,7 @@ error:
 }
 
 static int irq_remapping_setup_msi_irqs(struct pci_dev *dev,
-					int nvec, int type)
+					int nvec, int nvec_mme, int type)
 {
 	if (type == PCI_CAP_ID_MSI)
 		return do_setup_msi_irqs(dev, nvec);
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index aca7578..647e9b1 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -31,7 +31,8 @@ static int pci_msi_enable = 1;
 /* Arch hooks */
 
 #ifndef arch_msi_check_device
-int arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
+int arch_msi_check_device(struct pci_dev *dev,
+			  int nvec, int nvec_mme, int type)
 {
 	return 0;
 }
@@ -43,7 +44,8 @@ int arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
 #endif
 
 #ifdef HAVE_DEFAULT_MSI_SETUP_IRQS
-int default_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+int default_setup_msi_irqs(struct pci_dev *dev,
+			   int nvec, int nvec_mme, int type)
 {
 	struct msi_desc *entry;
 	int ret;
@@ -540,6 +542,7 @@ out_unroll:
  * msi_capability_init - configure device's MSI capability structure
  * @dev: pointer to the pci_dev data structure of MSI device function
  * @nvec: number of interrupts to allocate
+ * @nvec_mme: number of interrupts to write to Multiple Message Enable register
  *
  * Setup the MSI capability structure of the device with the requested
  * number of interrupts.  A return value of zero indicates the successful
@@ -547,7 +550,7 @@ out_unroll:
  * an error, and a positive return value indicates the number of interrupts
  * which could have been allocated.
  */
-static int msi_capability_init(struct pci_dev *dev, int nvec)
+static int msi_capability_init(struct pci_dev *dev, int nvec, int nvec_mme)
 {
 	struct msi_desc *entry;
 	int ret;
@@ -582,7 +585,7 @@ static int msi_capability_init(struct pci_dev *dev, int nvec)
 	list_add_tail(&entry->list, &dev->msi_list);
 
 	/* Configure MSI capability structure */
-	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSI);
+	ret = arch_setup_msi_irqs(dev, nvec, nvec_mme, PCI_CAP_ID_MSI);
 	if (ret) {
 		msi_mask_irq(entry, mask, ~mask);
 		free_msi_irqs(dev);
@@ -700,7 +703,8 @@ static int msix_capability_init(struct pci_dev *dev,
 	if (ret)
 		return ret;
 
-	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
+	/* nvec_mme parameter does not make sense in case of MSI-X */
+	ret = arch_setup_msi_irqs(dev, nvec, -1, PCI_CAP_ID_MSIX);
 	if (ret)
 		goto error;
 
@@ -755,13 +759,15 @@ error:
  * pci_msi_check_device - check whether MSI may be enabled on a device
  * @dev: pointer to the pci_dev data structure of MSI device function
  * @nvec: how many MSIs have been requested ?
+ * @nvec_mme: how many MSIs write to Multiple Message Enable register ?
  * @type: are we checking for MSI or MSI-X ?
  *
  * Look at global flags, the device itself, and its parent busses
  * to determine if MSI/-X are supported for the device. If MSI/-X is
  * supported return 0, else return an error code.
  **/
-static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
+static int pci_msi_check_device(struct pci_dev *dev,
+				int nvec, int nvec_mme, int type)
 {
 	struct pci_bus *bus;
 	int ret;
@@ -789,27 +795,15 @@ static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
 		if (bus->bus_flags & PCI_BUS_FLAGS_NO_MSI)
 			return -EINVAL;
 
-	ret = arch_msi_check_device(dev, nvec, type);
+	ret = arch_msi_check_device(dev, nvec, nvec_mme, type);
 	if (ret)
 		return ret;
 
 	return 0;
 }
 
-/**
- * pci_enable_msi_block - configure device's MSI capability structure
- * @dev: device to configure
- * @nvec: number of interrupts to configure
- *
- * Allocate IRQs for a device with the MSI capability.
- * This function returns a negative errno if an error occurs.  If it
- * is unable to allocate the number of interrupts requested, it returns
- * the number of interrupts it might be able to allocate.  If it successfully
- * allocates at least the number of interrupts requested, it returns 0 and
- * updates the @dev's irq member to the lowest new interrupt number; the
- * other interrupt numbers allocated to this device are consecutive.
- */
-int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
+int pci_enable_msi_block_part(struct pci_dev *dev,
+			      unsigned int nvec, int nvec_mme)
 {
 	int status, maxvec;
 	u16 msgctl;
@@ -819,10 +813,17 @@ int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
 
 	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &msgctl);
 	maxvec = 1 << ((msgctl & PCI_MSI_FLAGS_QMASK) >> 1);
-	if (nvec > maxvec)
+
+	if (nvec_mme < 0)
+		nvec_mme = maxvec;
+	if (nvec_mme > maxvec)
 		return maxvec;
+	if (!is_power_of_2(nvec_mme))
+		return -EINVAL;
+	if (nvec > nvec_mme)
+		return -ERANGE;
 
-	status = pci_msi_check_device(dev, nvec, PCI_CAP_ID_MSI);
+	status = pci_msi_check_device(dev, nvec, nvec_mme, PCI_CAP_ID_MSI);
 	if (status)
 		return status;
 
@@ -835,9 +836,34 @@ int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
 		return -EINVAL;
 	}
 
-	status = msi_capability_init(dev, nvec);
+	status = msi_capability_init(dev, nvec, nvec_mme);
 	return status;
 }
+EXPORT_SYMBOL(pci_enable_msi_block_part);
+
+/**
+ * pci_enable_msi_block - configure device's MSI capability structure
+ * @dev: device to configure
+ * @nvec: number of interrupts to configure
+ *
+ * Allocate IRQs for a device with the MSI capability.
+ * This function returns a negative errno if an error occurs.  If it
+ * is unable to allocate the number of interrupts requested, it returns
+ * the number of interrupts it might be able to allocate.  If it successfully
+ * allocates at least the number of interrupts requested, it returns 0 and
+ * updates the @dev's irq member to the lowest new interrupt number; the
+ * other interrupt numbers allocated to this device are consecutive.
+ */
+int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
+{
+	/*
+	 * Archtectures which do not support nvec_mme should ignore it.
+	 * However, it would be surprising if an architecture write to
+	 * the Multiple Message Enable register something else than nvec
+	 * rounded up to the power of two.
+	 */
+	return pci_enable_msi_block_part(dev, nvec, roundup_pow_of_two(nvec));
+}
 EXPORT_SYMBOL(pci_enable_msi_block);
 
 int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec)
@@ -941,7 +967,8 @@ int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
 	if (!entries || !dev->msix_cap)
 		return -EINVAL;
 
-	status = pci_msi_check_device(dev, nvec, PCI_CAP_ID_MSIX);
+	/* nvec_mme parameter does not make sense in case of MSI-X */
+	status = pci_msi_check_device(dev, nvec, -1, PCI_CAP_ID_MSIX);
 	if (status)
 		return status;
 
diff --git a/include/linux/msi.h b/include/linux/msi.h
index ee66f3a..e27ad31 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -55,8 +55,9 @@ struct msi_desc {
  */
 int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc);
 void arch_teardown_msi_irq(unsigned int irq);
-int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
+int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int nvec_mme, int type);
 void arch_teardown_msi_irqs(struct pci_dev *dev);
-int arch_msi_check_device(struct pci_dev* dev, int nvec, int type);
+int arch_msi_check_device(struct pci_dev* dev,
+			  int nvec, int nvec_mme, int type);
 
 #endif /* LINUX_MSI_H */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 0fd1f15..6552cee 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1122,6 +1122,12 @@ struct msix_entry {
 
 
 #ifndef CONFIG_PCI_MSI
+static inline int
+pci_enable_msi_block_part(struct pci_dev *dev, unsigned int nvec, int nvec_mme)
+{
+	return -1;
+}
+
 static inline int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
 {
 	return -1;
@@ -1163,6 +1169,8 @@ static inline int pci_msi_enabled(void)
 	return 0;
 }
 #else
+int pci_enable_msi_block_part(struct pci_dev *dev,
+			      unsigned int nvec, int nvec_mme);
 int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec);
 int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec);
 void pci_msi_shutdown(struct pci_dev *dev);
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
