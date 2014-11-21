Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaKUWIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 17:08:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbaKUWIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 17:08:44 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 1/3] PCI/MSI: Initial hook for archs to declare multivector
	MSI support
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, joro@8bytes.org,
        iommu@lists.linux-foundation.org
Date: Fri, 21 Nov 2014 15:08:33 -0700
Message-ID: <20141121220833.31095.12371.stgit@gimli.home>
In-Reply-To: <20141121213752.31095.30735.stgit@gimli.home>
References: <20141121213752.31095.30735.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the most part multivector MSI is not supported and drivers and
hardware wanting multiple vectors opt for MSI-X instead.  It seems
though that having the ability to query the arch/platform code to
determine whether allocating multiple MSI vectors will ever succeed
is a useful thing.  For instance, vfio-pci can use this to determine
whether to expose multiple MSI vectors to the user.  If we know we
cannot ever support more than one vector, we have a better shot at
the userspace driver working, especially if it's a guest OS, if we
only expose one vector as being available in the interface.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/pci/msi.c   |    5 +++++
 include/linux/msi.h |    1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 9fab30a..36b503a 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -79,6 +79,11 @@ int __weak arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	return 0;
 }
 
+bool __weak arch_supports_multivector_msi(struct pci_dev *dev)
+{
+	return false;
+}
+
 /*
  * We have a default implementation available as a separate non-weak
  * function, as it is used by the Xen x86 PCI code
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 44f4746..2365c64 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -58,6 +58,7 @@ void arch_teardown_msi_irq(unsigned int irq);
 int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
 void arch_teardown_msi_irqs(struct pci_dev *dev);
 void arch_restore_msi_irqs(struct pci_dev *dev);
+bool arch_supports_multivector_msi(struct pci_dev *dev);
 
 void default_teardown_msi_irqs(struct pci_dev *dev);
 void default_restore_msi_irqs(struct pci_dev *dev);

