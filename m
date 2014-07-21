Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759AbaGUOsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:48:41 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:46570 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbaGUOsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:48:38 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Marek Vasut <marex@denx.de>, Harro Haan <hrhaan@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH RFC 5/9] ARM: Add L1 PTE non-secure mapping
Date: Mon, 21 Jul 2014 15:47:16 +0100
Message-Id: <1405954040-30399-6-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405954040-30399-1-git-send-email-daniel.thompson@linaro.org>
References: <1405954040-30399-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Vasut <marex@denx.de>

Add new device type, MT_DEVICE_NS. This type sets the NS bit in L1 PTE [1].
Accesses to a memory region which is mapped this way generate non-secure
access to that memory area. One must be careful here, since the NS bit is
only available in L1 PTE, therefore when creating the mapping, the mapping
must be at least 1 MiB big and must be aligned to 1 MiB. If that condition
was false, the kernel would use regular L2 page mapping for this area instead
and the NS bit setting would be ineffective.

[1] See DDI0406B , Section B3 "Virtual Memory System Architecture (VMSA)",
    Subsection B3.3.1 "Translation table entry formats", paragraph
    "First-level descriptors", Table B3-1 and associated description
    of the NS bit in the "Section" table entry.

Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 arch/arm/include/asm/io.h                   |  5 ++++-
 arch/arm/include/asm/mach/map.h             |  4 ++--
 arch/arm/include/asm/pgtable-2level-hwdef.h |  1 +
 arch/arm/mm/mmu.c                           | 13 ++++++++++++-
 4 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index 3d23418..22765e0 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -125,8 +125,10 @@ static inline u32 __raw_readl(const volatile void __iomem *addr)
 #define MT_DEVICE_NONSHARED	1
 #define MT_DEVICE_CACHED	2
 #define MT_DEVICE_WC		3
+#define MT_DEVICE_NS		4
+
 /*
- * types 4 onwards can be found in asm/mach/map.h and are undefined
+ * types 5 onwards can be found in asm/mach/map.h and are undefined
  * for ioremap
  */
 
@@ -343,6 +345,7 @@ extern void _memset_io(volatile void __iomem *, int, size_t);
 #define ioremap_nocache(cookie,size)	__arm_ioremap((cookie), (size), MT_DEVICE)
 #define ioremap_cache(cookie,size)	__arm_ioremap((cookie), (size), MT_DEVICE_CACHED)
 #define ioremap_wc(cookie,size)		__arm_ioremap((cookie), (size), MT_DEVICE_WC)
+#define ioremap_ns(cookie,size)		__arm_ioremap((cookie), (size), MT_DEVICE_NS)
 #define iounmap				__arm_iounmap
 
 /*
diff --git a/arch/arm/include/asm/mach/map.h b/arch/arm/include/asm/mach/map.h
index f98c7f3..42be265 100644
--- a/arch/arm/include/asm/mach/map.h
+++ b/arch/arm/include/asm/mach/map.h
@@ -21,9 +21,9 @@ struct map_desc {
 	unsigned int type;
 };
 
-/* types 0-3 are defined in asm/io.h */
+/* types 0-4 are defined in asm/io.h */
 enum {
-	MT_UNCACHED = 4,
+	MT_UNCACHED = 5,
 	MT_CACHECLEAN,
 	MT_MINICLEAN,
 	MT_LOW_VECTORS,
diff --git a/arch/arm/include/asm/pgtable-2level-hwdef.h b/arch/arm/include/asm/pgtable-2level-hwdef.h
index 5cfba15..d24e7ea 100644
--- a/arch/arm/include/asm/pgtable-2level-hwdef.h
+++ b/arch/arm/include/asm/pgtable-2level-hwdef.h
@@ -36,6 +36,7 @@
 #define PMD_SECT_S		(_AT(pmdval_t, 1) << 16)	/* v6 */
 #define PMD_SECT_nG		(_AT(pmdval_t, 1) << 17)	/* v6 */
 #define PMD_SECT_SUPER		(_AT(pmdval_t, 1) << 18)	/* v6 */
+#define PMD_SECT_NS		(_AT(pmdval_t, 1) << 19)	/* v6 */
 #define PMD_SECT_AF		(_AT(pmdval_t, 0))
 
 #define PMD_SECT_UNCACHED	(_AT(pmdval_t, 0))
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index ab14b79..9baf1cb 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -268,6 +268,13 @@ static struct mem_type mem_types[] = {
 		.prot_sect	= PROT_SECT_DEVICE,
 		.domain		= DOMAIN_IO,
 	},
+	[MT_DEVICE_NS] = {	  /* Non-secure accesses from secure mode */
+		.prot_pte	= PROT_PTE_DEVICE | L_PTE_MT_DEV_SHARED |
+				  L_PTE_SHARED,
+		.prot_l1	= PMD_TYPE_TABLE,
+		.prot_sect	= PROT_SECT_DEVICE | PMD_SECT_S | PMD_SECT_NS,
+		.domain		= DOMAIN_IO,
+	},
 	[MT_UNCACHED] = {
 		.prot_pte	= PROT_PTE_DEVICE,
 		.prot_l1	= PMD_TYPE_TABLE,
@@ -474,6 +481,7 @@ static void __init build_mem_type_table(void)
 			mem_types[MT_DEVICE_NONSHARED].prot_sect |= PMD_SECT_XN;
 			mem_types[MT_DEVICE_CACHED].prot_sect |= PMD_SECT_XN;
 			mem_types[MT_DEVICE_WC].prot_sect |= PMD_SECT_XN;
+			mem_types[MT_DEVICE_NS].prot_sect |= PMD_SECT_XN;
 
 			/* Also setup NX memory mapping */
 			mem_types[MT_MEMORY_RW].prot_sect |= PMD_SECT_XN;
@@ -489,6 +497,7 @@ static void __init build_mem_type_table(void)
 			mem_types[MT_DEVICE].prot_sect |= PMD_SECT_TEX(1);
 			mem_types[MT_DEVICE_NONSHARED].prot_sect |= PMD_SECT_TEX(1);
 			mem_types[MT_DEVICE_WC].prot_sect |= PMD_SECT_BUFFERABLE;
+			mem_types[MT_DEVICE_NS].prot_sect |= PMD_SECT_TEX(1);
 		} else if (cpu_is_xsc3()) {
 			/*
 			 * For Xscale3,
@@ -500,6 +509,7 @@ static void __init build_mem_type_table(void)
 			mem_types[MT_DEVICE].prot_sect |= PMD_SECT_TEX(1) | PMD_SECT_BUFFERED;
 			mem_types[MT_DEVICE_NONSHARED].prot_sect |= PMD_SECT_TEX(2);
 			mem_types[MT_DEVICE_WC].prot_sect |= PMD_SECT_TEX(1);
+			mem_types[MT_DEVICE_NS].prot_sect |= PMD_SECT_TEX(1) | PMD_SECT_BUFFERED;
 		} else {
 			/*
 			 * For ARMv6 and ARMv7 without TEX remapping,
@@ -511,6 +521,7 @@ static void __init build_mem_type_table(void)
 			mem_types[MT_DEVICE].prot_sect |= PMD_SECT_BUFFERED;
 			mem_types[MT_DEVICE_NONSHARED].prot_sect |= PMD_SECT_TEX(2);
 			mem_types[MT_DEVICE_WC].prot_sect |= PMD_SECT_TEX(1);
+			mem_types[MT_DEVICE_NS].prot_sect |= PMD_SECT_BUFFERED;
 		}
 	} else {
 		/*
@@ -856,7 +867,7 @@ static void __init create_mapping(struct map_desc *md)
 		return;
 	}
 
-	if ((md->type == MT_DEVICE || md->type == MT_ROM) &&
+	if ((md->type == MT_DEVICE || md->type == MT_DEVICE_NS || md->type == MT_ROM) &&
 	    md->virtual >= PAGE_OFFSET &&
 	    (md->virtual < VMALLOC_START || md->virtual >= VMALLOC_END)) {
 		printk(KERN_WARNING "BUG: mapping for 0x%08llx"
-- 
1.9.3

