Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab3FYSdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:33:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40891 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab3FYSdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Helge Deller <deller@gmx.de>
Subject: [ 28/95] parisc: provide pci_mmap_page_range() for parisc
Date: Tue, 25 Jun 2013 11:32:15 -0700
Message-Id: <20130625182156.842578037@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

commit 2cc7138f4347df939ce03f313e3d87794bab36f8 upstream.

pci_mmap_page_range() is needed for X11-server support on C8000 with ATI
FireGL card.

Signed-off-by Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/include/asm/pci.h |    5 +++++
 arch/parisc/kernel/pci.c      |   27 +++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

--- a/arch/parisc/include/asm/pci.h
+++ b/arch/parisc/include/asm/pci.h
@@ -225,4 +225,9 @@ static inline int pci_get_legacy_ide_irq
 	return channel ? 15 : 14;
 }
 
+#define HAVE_PCI_MMAP
+
+extern int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
+	enum pci_mmap_state mmap_state, int write_combine);
+
 #endif /* __ASM_PARISC_PCI_H */
--- a/arch/parisc/kernel/pci.c
+++ b/arch/parisc/kernel/pci.c
@@ -220,6 +220,33 @@ resource_size_t pcibios_align_resource(v
 }
 
 
+int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
+			enum pci_mmap_state mmap_state, int write_combine)
+{
+	unsigned long prot;
+
+	/*
+	 * I/O space can be accessed via normal processor loads and stores on
+	 * this platform but for now we elect not to do this and portable
+	 * drivers should not do this anyway.
+	 */
+	if (mmap_state == pci_mmap_io)
+		return -EINVAL;
+
+	if (write_combine)
+		return -EINVAL;
+
+	/*
+	 * Ignore write-combine; for now only return uncached mappings.
+	 */
+	prot = pgprot_val(vma->vm_page_prot);
+	prot |= _PAGE_NO_CACHE;
+	vma->vm_page_prot = __pgprot(prot);
+
+	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+		vma->vm_end - vma->vm_start, vma->vm_page_prot);
+}
+
 /*
  * A driver is enabling the device.  We make sure that all the appropriate
  * bits are set to allow the device to operate as the driver is expecting.


