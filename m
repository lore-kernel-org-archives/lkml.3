Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbaGUHgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 03:36:05 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:59779 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaGUHgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 03:36:02 -0400
Date: Mon, 21 Jul 2014 09:35:48 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.16-rc7
Message-ID: <20140721093548.71d39d0f@mschwide>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072107-3548-0000-0000-000000A21183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:

A couple of last minute bug fixes for 3.16, including a fix for ptrace
to close a hole which allowed a user space program to write to the
kernel address space.

David Hildenbrand (1):
      s390: require mvcos facility, not tod clock steering facility

Ingo Tuchscherer (1):
      s390/zcrypt: improve device probing for zcrypt adapter cards

Martin Schwidefsky (3):
      s390/3270: correct size detection with the read-partition command
      s390/ptrace: fix PSW mask check
      s390: fix restore of invalid floating-point-control

Yijing Wang (1):
      s390/MSI: Use standard mask and unmask funtions

 arch/s390/include/asm/switch_to.h |    4 +--
 arch/s390/kernel/head.S           |    6 ++---
 arch/s390/kernel/ptrace.c         |   12 +++++++--
 arch/s390/pci/pci.c               |   49 +++++--------------------------------
 drivers/s390/char/raw3270.c       |    1 -
 drivers/s390/crypto/ap_bus.c      |    9 +++++--
 6 files changed, 28 insertions(+), 53 deletions(-)

diff --git a/arch/s390/include/asm/switch_to.h b/arch/s390/include/asm/switch_to.h
index df38c70..18ea9e3 100644
--- a/arch/s390/include/asm/switch_to.h
+++ b/arch/s390/include/asm/switch_to.h
@@ -51,8 +51,8 @@ static inline int restore_fp_ctl(u32 *fpc)
 		return 0;
 
 	asm volatile(
-		"0:	lfpc    %1\n"
-		"	la	%0,0\n"
+		"	lfpc    %1\n"
+		"0:	la	%0,0\n"
 		"1:\n"
 		EX_TABLE(0b,1b)
 		: "=d" (rc) : "Q" (*fpc), "0" (-EINVAL));
diff --git a/arch/s390/kernel/head.S b/arch/s390/kernel/head.S
index 7ba7d67..e88d35d 100644
--- a/arch/s390/kernel/head.S
+++ b/arch/s390/kernel/head.S
@@ -437,11 +437,11 @@ ENTRY(startup_kdump)
 
 #if defined(CONFIG_64BIT)
 #if defined(CONFIG_MARCH_ZEC12)
-	.long 3, 0xc100efea, 0xf46ce800, 0x00400000
+	.long 3, 0xc100eff2, 0xf46ce800, 0x00400000
 #elif defined(CONFIG_MARCH_Z196)
-	.long 2, 0xc100efea, 0xf46c0000
+	.long 2, 0xc100eff2, 0xf46c0000
 #elif defined(CONFIG_MARCH_Z10)
-	.long 2, 0xc100efea, 0xf0680000
+	.long 2, 0xc100eff2, 0xf0680000
 #elif defined(CONFIG_MARCH_Z9_109)
 	.long 1, 0xc100efc2
 #elif defined(CONFIG_MARCH_Z990)
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 2d716734..5dc7ad9 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -334,9 +334,14 @@ static int __poke_user(struct task_struct *child, addr_t addr, addr_t data)
 			unsigned long mask = PSW_MASK_USER;
 
 			mask |= is_ri_task(child) ? PSW_MASK_RI : 0;
-			if ((data & ~mask) != PSW_USER_BITS)
+			if ((data ^ PSW_USER_BITS) & ~mask)
+				/* Invalid psw mask. */
+				return -EINVAL;
+			if ((data & PSW_MASK_ASC) == PSW_ASC_HOME)
+				/* Invalid address-space-control bits */
 				return -EINVAL;
 			if ((data & PSW_MASK_EA) && !(data & PSW_MASK_BA))
+				/* Invalid addressing mode bits */
 				return -EINVAL;
 		}
 		*(addr_t *)((addr_t) &task_pt_regs(child)->psw + addr) = data;
@@ -672,9 +677,12 @@ static int __poke_user_compat(struct task_struct *child,
 
 			mask |= is_ri_task(child) ? PSW32_MASK_RI : 0;
 			/* Build a 64 bit psw mask from 31 bit mask. */
-			if ((tmp & ~mask) != PSW32_USER_BITS)
+			if ((tmp ^ PSW32_USER_BITS) & ~mask)
 				/* Invalid psw mask. */
 				return -EINVAL;
+			if ((data & PSW32_MASK_ASC) == PSW32_ASC_HOME)
+				/* Invalid address-space-control bits */
+				return -EINVAL;
 			regs->psw.mask = (regs->psw.mask & ~PSW_MASK_USER) |
 				(regs->psw.mask & PSW_MASK_BA) |
 				(__u64)(tmp & mask) << 32;
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 9ddc51e..30de427 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -48,13 +48,10 @@
 static LIST_HEAD(zpci_list);
 static DEFINE_SPINLOCK(zpci_list_lock);
 
-static void zpci_enable_irq(struct irq_data *data);
-static void zpci_disable_irq(struct irq_data *data);
-
 static struct irq_chip zpci_irq_chip = {
 	.name = "zPCI",
-	.irq_unmask = zpci_enable_irq,
-	.irq_mask = zpci_disable_irq,
+	.irq_unmask = unmask_msi_irq,
+	.irq_mask = mask_msi_irq,
 };
 
 static DECLARE_BITMAP(zpci_domain, ZPCI_NR_DEVICES);
@@ -244,43 +241,6 @@ static int zpci_cfg_store(struct zpci_dev *zdev, int offset, u32 val, u8 len)
 	return rc;
 }
 
-static int zpci_msi_set_mask_bits(struct msi_desc *msi, u32 mask, u32 flag)
-{
-	int offset, pos;
-	u32 mask_bits;
-
-	if (msi->msi_attrib.is_msix) {
-		offset = msi->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
-			PCI_MSIX_ENTRY_VECTOR_CTRL;
-		msi->masked = readl(msi->mask_base + offset);
-		writel(flag, msi->mask_base + offset);
-	} else if (msi->msi_attrib.maskbit) {
-		pos = (long) msi->mask_base;
-		pci_read_config_dword(msi->dev, pos, &mask_bits);
-		mask_bits &= ~(mask);
-		mask_bits |= flag & mask;
-		pci_write_config_dword(msi->dev, pos, mask_bits);
-	} else
-		return 0;
-
-	msi->msi_attrib.maskbit = !!flag;
-	return 1;
-}
-
-static void zpci_enable_irq(struct irq_data *data)
-{
-	struct msi_desc *msi = irq_get_msi_desc(data->irq);
-
-	zpci_msi_set_mask_bits(msi, 1, 0);
-}
-
-static void zpci_disable_irq(struct irq_data *data)
-{
-	struct msi_desc *msi = irq_get_msi_desc(data->irq);
-
-	zpci_msi_set_mask_bits(msi, 1, 1);
-}
-
 void pcibios_fixup_bus(struct pci_bus *bus)
 {
 }
@@ -487,7 +447,10 @@ void arch_teardown_msi_irqs(struct pci_dev *pdev)
 
 	/* Release MSI interrupts */
 	list_for_each_entry(msi, &pdev->msi_list, list) {
-		zpci_msi_set_mask_bits(msi, 1, 1);
+		if (msi->msi_attrib.is_msix)
+			default_msix_mask_irq(msi, 1);
+		else
+			default_msi_mask_irq(msi, 1, 1);
 		irq_set_msi_desc(msi->irq, NULL);
 		irq_free_desc(msi->irq);
 		msi->msg.address_lo = 0;
diff --git a/drivers/s390/char/raw3270.c b/drivers/s390/char/raw3270.c
index 15b3459..220acb4 100644
--- a/drivers/s390/char/raw3270.c
+++ b/drivers/s390/char/raw3270.c
@@ -633,7 +633,6 @@ raw3270_reset_device_cb(struct raw3270_request *rq, void *data)
 	} else
 		raw3270_writesf_readpart(rp);
 	memset(&rp->init_reset, 0, sizeof(rp->init_reset));
-	memset(&rp->init_data, 0, sizeof(rp->init_data));
 }
 
 static int
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 69ef4f8..4038437 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -901,10 +901,15 @@ static int ap_device_probe(struct device *dev)
 	int rc;
 
 	ap_dev->drv = ap_drv;
+
+	spin_lock_bh(&ap_device_list_lock);
+	list_add(&ap_dev->list, &ap_device_list);
+	spin_unlock_bh(&ap_device_list_lock);
+
 	rc = ap_drv->probe ? ap_drv->probe(ap_dev) : -ENODEV;
-	if (!rc) {
+	if (rc) {
 		spin_lock_bh(&ap_device_list_lock);
-		list_add(&ap_dev->list, &ap_device_list);
+		list_del_init(&ap_dev->list);
 		spin_unlock_bh(&ap_device_list_lock);
 	}
 	return rc;

