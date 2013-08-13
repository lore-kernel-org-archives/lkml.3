Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab3HMLMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 07:12:41 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:57104 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757459Ab3HMLMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 07:12:37 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <treding@nvidia.com>
Subject: [RFC 1/3] ARM: Allow unmapping of fixed PCI I/O mappings
Date: Tue, 13 Aug 2013 13:12:24 +0200
Message-Id: <1376392346-14127-2-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1376392346-14127-1-git-send-email-treding@nvidia.com>
References: <1376392346-14127-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new pci_iounmap_io() function can be used to unmap a fixed PCI I/O
mapping as established by pci_ioremap_io(). This will be useful to
support unbinding of PCI host drivers.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm/include/asm/io.h | 1 +
 arch/arm/mm/ioremap.c     | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index d070741..80c3826 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -172,6 +172,7 @@ static inline void __iomem *__typesafe_io(unsigned long addr)
 #define PCI_IO_VIRT_BASE	0xfee00000
 
 extern int pci_ioremap_io(unsigned int offset, phys_addr_t phys_addr);
+extern void pci_iounmap_io(unsigned int offset);
 
 /*
  * Now, pick up the machine-defined IO definitions
diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index f123d6e..c7504c9 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -448,4 +448,10 @@ int pci_ioremap_io(unsigned int offset, phys_addr_t phys_addr)
 				  __pgprot(get_mem_type(MT_DEVICE)->prot_pte));
 }
 EXPORT_SYMBOL_GPL(pci_ioremap_io);
+
+void pci_iounmap_io(unsigned int offset)
+{
+	unmap_kernel_range(PCI_IO_VIRT_BASE + offset, SZ_64K);
+}
+EXPORT_SYMBOL_GPL(pci_iounmap_io);
 #endif
-- 
1.8.3.4

