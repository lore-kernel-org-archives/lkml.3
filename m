Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab3AXUjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:39:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34912 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab3AXUjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:39:35 -0500
Date: Thu, 24 Jan 2013 12:38:59 -0800
From: tip-bot for Alexander Gordeev <agordeev@redhat.com>
Message-ID: <tip-08261d87f7d1b6253ab3223756625a5c74532293@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@kernel.org, yinghai@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, jgarzik@pobox.com,
        willy@linux.intel.com, bhelgaas@google.com, akpm@linux-foundation.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        jgarzik@pobox.com, willy@linux.intel.com, bhelgaas@google.com,
        akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de
In-Reply-To: <c3de2419df94a0f95ca1a6f755afc421486455e6.1353324359.git.agordeev@redhat.com>
References: <c3de2419df94a0f95ca1a6f755afc421486455e6.1353324359.git.agordeev@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] PCI/MSI:
  Enable multiple MSIs with pci_enable_msi_block_auto()
Git-Commit-ID: 08261d87f7d1b6253ab3223756625a5c74532293
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 12:39:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  08261d87f7d1b6253ab3223756625a5c74532293
Gitweb:     http://git.kernel.org/tip/08261d87f7d1b6253ab3223756625a5c74532293
Author:     Alexander Gordeev <agordeev@redhat.com>
AuthorDate: Mon, 19 Nov 2012 16:02:10 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Jan 2013 17:25:13 +0100

PCI/MSI: Enable multiple MSIs with pci_enable_msi_block_auto()

The new function pci_enable_msi_block_auto() tries to allocate
maximum possible number of MSIs up to the number the device
supports. It generalizes a pattern when pci_enable_msi_block()
is contiguously called until it succeeds or fails.

Opposite to pci_enable_msi_block() which takes the number of
MSIs to allocate as a input parameter,
pci_enable_msi_block_auto() could be used by device drivers to
obtain the number of assigned MSIs and the number of MSIs the
device supports.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/c3de2419df94a0f95ca1a6f755afc421486455e6.1353324359.git.agordeev@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/PCI/MSI-HOWTO.txt | 37 ++++++++++++++++++++++++++++++++-----
 drivers/pci/msi.c               | 26 ++++++++++++++++++++++++++
 include/linux/pci.h             |  7 +++++++
 3 files changed, 65 insertions(+), 5 deletions(-)

diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
index 53e6fca..a091780 100644
--- a/Documentation/PCI/MSI-HOWTO.txt
+++ b/Documentation/PCI/MSI-HOWTO.txt
@@ -127,15 +127,42 @@ on the number of vectors that can be allocated; pci_enable_msi_block()
 returns as soon as it finds any constraint that doesn't allow the
 call to succeed.
 
-4.2.3 pci_disable_msi
+4.2.3 pci_enable_msi_block_auto
+
+int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *count)
+
+This variation on pci_enable_msi() call allows a device driver to request
+the maximum possible number of MSIs.  The MSI specification only allows
+interrupts to be allocated in powers of two, up to a maximum of 2^5 (32).
+
+If this function returns a positive number, it indicates that it has
+succeeded and the returned value is the number of allocated interrupts. In
+this case, the function enables MSI on this device and updates dev->irq to
+be the lowest of the new interrupts assigned to it.  The other interrupts
+assigned to the device are in the range dev->irq to dev->irq + returned
+value - 1.
+
+If this function returns a negative number, it indicates an error and
+the driver should not attempt to request any more MSI interrupts for
+this device.
+
+If the device driver needs to know the number of interrupts the device
+supports it can pass the pointer count where that number is stored. The
+device driver must decide what action to take if pci_enable_msi_block_auto()
+succeeds, but returns a value less than the number of interrupts supported.
+If the device driver does not need to know the number of interrupts
+supported, it can set the pointer count to NULL.
+
+4.2.4 pci_disable_msi
 
 void pci_disable_msi(struct pci_dev *dev)
 
 This function should be used to undo the effect of pci_enable_msi() or
-pci_enable_msi_block().  Calling it restores dev->irq to the pin-based
-interrupt number and frees the previously allocated message signaled
-interrupt(s).  The interrupt may subsequently be assigned to another
-device, so drivers should not cache the value of dev->irq.
+pci_enable_msi_block() or pci_enable_msi_block_auto().  Calling it restores
+dev->irq to the pin-based interrupt number and frees the previously
+allocated message signaled interrupt(s).  The interrupt may subsequently be
+assigned to another device, so drivers should not cache the value of
+dev->irq.
 
 Before calling this function, a device driver must always call free_irq()
 on any interrupt for which it previously called request_irq().
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 5099636..00cc78c 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -845,6 +845,32 @@ int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
 }
 EXPORT_SYMBOL(pci_enable_msi_block);
 
+int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec)
+{
+	int ret, pos, nvec;
+	u16 msgctl;
+
+	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
+	if (!pos)
+		return -EINVAL;
+
+	pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &msgctl);
+	ret = 1 << ((msgctl & PCI_MSI_FLAGS_QMASK) >> 1);
+
+	if (maxvec)
+		*maxvec = ret;
+
+	do {
+		nvec = ret;
+		ret = pci_enable_msi_block(dev, nvec);
+	} while (ret > 0);
+
+	if (ret < 0)
+		return ret;
+	return nvec;
+}
+EXPORT_SYMBOL(pci_enable_msi_block_auto);
+
 void pci_msi_shutdown(struct pci_dev *dev)
 {
 	struct msi_desc *desc;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 15472d6..6fa4dd2 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1101,6 +1101,12 @@ static inline int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
 	return -1;
 }
 
+static inline int
+pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec)
+{
+	return -1;
+}
+
 static inline void pci_msi_shutdown(struct pci_dev *dev)
 { }
 static inline void pci_disable_msi(struct pci_dev *dev)
@@ -1132,6 +1138,7 @@ static inline int pci_msi_enabled(void)
 }
 #else
 extern int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec);
+extern int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec);
 extern void pci_msi_shutdown(struct pci_dev *dev);
 extern void pci_disable_msi(struct pci_dev *dev);
 extern int pci_msix_table_size(struct pci_dev *dev);
