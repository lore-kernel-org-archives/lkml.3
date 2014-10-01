Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaJAQsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:48:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbaJAQsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:48:31 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 1/3] Revert "PCI/MSI: Rename __read_msi_msg() to
	read_msi_msg()"
To: linux-pci@vger.kernel.org, bhelgaas@google.com
Cc: linux-kernel@vger.kernel.org, wangyijing@huawei.com
Date: Wed, 01 Oct 2014 10:48:22 -0600
Message-ID: <20141001164822.2709.44994.stgit@gimli.home>
In-Reply-To: <20141001163814.2709.92885.stgit@gimli.home>
References: <20141001163814.2709.92885.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes for an inconsistent MSI API, read_msi_msg() takes an
msi_desc arg, but write_msi_msg() takes an irq.  Let's keep the
API consistent that the __read/write interfaces take an msi_desc
and the standard interfaces take an irq.

This reverts 09d4ecd3f067e307211882412f8acd09daaacca2

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 arch/powerpc/platforms/pseries/msi.c |    2 +-
 arch/x86/pci/xen.c                   |    2 +-
 drivers/pci/msi.c                    |    2 +-
 include/linux/msi.h                  |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/msi.c b/arch/powerpc/platforms/pseries/msi.c
index 88f14a6..8ab5add 100644
--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -476,7 +476,7 @@ again:
 		irq_set_msi_desc(virq, entry);
 
 		/* Read config space back so we can restore after reset */
-		read_msi_msg(entry, &msg);
+		__read_msi_msg(entry, &msg);
 		entry->msg = msg;
 	}
 
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index ad03739..093f5f4 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -229,7 +229,7 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		return 1;
 
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
-		read_msi_msg(msidesc, &msg);
+		__read_msi_msg(msidesc, &msg);
 		pirq = MSI_ADDR_EXT_DEST_ID(msg.address_hi) |
 			((msg.address_lo >> MSI_ADDR_DEST_ID_SHIFT) & 0xff);
 		if (msg.data != XEN_PIRQ_MSI_DATA ||
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index b6565ea..12d0f29 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -249,7 +249,7 @@ void default_restore_msi_irqs(struct pci_dev *dev)
 	}
 }
 
-void read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
+void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 {
 	BUG_ON(entry->dev->current_state != PCI_D0);
 
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 36c63cf..0bb302f 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -15,7 +15,7 @@ struct irq_data;
 struct msi_desc;
 void mask_msi_irq(struct irq_data *data);
 void unmask_msi_irq(struct irq_data *data);
-void read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
+void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 void get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 void write_msi_msg(unsigned int irq, struct msi_msg *msg);

