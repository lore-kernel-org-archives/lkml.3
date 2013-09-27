Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab3I0Qfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:35:53 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:46208 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab3I0Qft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:35:49 -0400
X-IronPort-AV: E=Sophos;i="4.90,994,1371081600"; 
   d="scan'208";a="55590938"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v6 16/19] arm,arm64: do not always merge biovec if we are running on Xen
Date: Fri, 27 Sep 2013 17:10:04 +0100
Message-ID: <1380298207-29151-16-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is similar to what it is done on X86: biovecs are prevented from merging
otherwise every dma requests would be forced to bounce on the swiotlb buffer.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/include/asm/io.h   |    8 ++++++++
 arch/arm64/include/asm/io.h |    9 +++++++++
 drivers/xen/biomerge.c      |    4 +++-
 3 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index d070741..c45effc 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -24,9 +24,11 @@
 #ifdef __KERNEL__
 
 #include <linux/types.h>
+#include <linux/blk_types.h>
 #include <asm/byteorder.h>
 #include <asm/memory.h>
 #include <asm-generic/pci_iomap.h>
+#include <xen/xen.h>
 
 /*
  * ISA I/O bus memory addresses are 1:1 with the physical address.
@@ -372,6 +374,12 @@ extern void pci_iounmap(struct pci_dev *dev, void __iomem *addr);
 #define BIOVEC_MERGEABLE(vec1, vec2)	\
 	((bvec_to_phys((vec1)) + (vec1)->bv_len) == bvec_to_phys((vec2)))
 
+extern bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
+				      const struct bio_vec *vec2);
+#define BIOVEC_PHYS_MERGEABLE(vec1, vec2)				\
+	(__BIOVEC_PHYS_MERGEABLE(vec1, vec2) &&				\
+	 (!xen_domain() || xen_biovec_phys_mergeable(vec1, vec2)))
+
 #ifdef CONFIG_MMU
 #define ARCH_HAS_VALID_PHYS_ADDR_RANGE
 extern int valid_phys_addr_range(phys_addr_t addr, size_t size);
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 1d12f89..c163287b 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -22,11 +22,14 @@
 #ifdef __KERNEL__
 
 #include <linux/types.h>
+#include <linux/blk_types.h>
 
 #include <asm/byteorder.h>
 #include <asm/barrier.h>
 #include <asm/pgtable.h>
 
+#include <xen/xen.h>
+
 /*
  * Generic IO read/write.  These perform native-endian accesses.
  */
@@ -263,5 +266,11 @@ extern int devmem_is_allowed(unsigned long pfn);
  */
 #define xlate_dev_kmem_ptr(p)	p
 
+extern bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
+				      const struct bio_vec *vec2);
+#define BIOVEC_PHYS_MERGEABLE(vec1, vec2)				\
+	(__BIOVEC_PHYS_MERGEABLE(vec1, vec2) &&				\
+	 (!xen_domain() || xen_biovec_phys_mergeable(vec1, vec2)))
+
 #endif	/* __KERNEL__ */
 #endif	/* __ASM_IO_H */
diff --git a/drivers/xen/biomerge.c b/drivers/xen/biomerge.c
index 0edb91c..f323a2d 100644
--- a/drivers/xen/biomerge.c
+++ b/drivers/xen/biomerge.c
@@ -2,6 +2,7 @@
 #include <linux/io.h>
 #include <linux/export.h>
 #include <xen/page.h>
+#include <xen/features.h>
 
 bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
 			       const struct bio_vec *vec2)
@@ -9,7 +10,8 @@ bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
 	unsigned long mfn1 = pfn_to_mfn(page_to_pfn(vec1->bv_page));
 	unsigned long mfn2 = pfn_to_mfn(page_to_pfn(vec2->bv_page));
 
-	return __BIOVEC_PHYS_MERGEABLE(vec1, vec2) &&
+	return !xen_feature(XENFEAT_auto_translated_physmap) &&
+		__BIOVEC_PHYS_MERGEABLE(vec1, vec2) &&
 		((mfn1 == mfn2) || ((mfn1+1) == mfn2));
 }
 EXPORT_SYMBOL(xen_biovec_phys_mergeable);
-- 
1.7.2.5

