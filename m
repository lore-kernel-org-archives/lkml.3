Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755AbaJ2Liq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 07:38:46 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:42297 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461AbaJ2Lip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 07:38:45 -0400
From: Minfei Huang <mnfhuang@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, pbonzini@redhat.com,
        akpm@linux-foundation.org, bp@suse.de
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Minfei Huang <mnfhuang@gmail.com>
Subject: [PATCH v2] x86/mm: Re-use the early_ioremap fixed area
Date: Wed, 29 Oct 2014 19:38:37 +0800
Message-Id: <1414582717-32729-1-git-send-email-mnfhuang@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The temp fixed area is only used during boot for early_ioremap(), and
it is unused when the ioremap() is functional. vmalloc/pkmap area become
available after early boot so the temp fixed area is available for re-use.

The virtual address is more precious on i386, especially turning on the
high memory. So we can re-use the virtual address whichever we can.

The macros of FIXADDR_BOOT_START and FIXADDR_BOOT_SIZE donot use any
more.

Signed-off-by: Minfei Huang <mnfhuang@gmail.com>
---
 arch/x86/include/asm/fixmap.h           |  2 --
 arch/x86/include/asm/highmem.h          | 25 ++++++++++++++-----------
 arch/x86/include/asm/pgtable_32_types.h |  4 ++--
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index ffb1733..bf728e4 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -136,9 +136,7 @@ enum fixed_addresses {
 extern void reserve_top_address(unsigned long reserve);
 
 #define FIXADDR_SIZE	(__end_of_permanent_fixed_addresses << PAGE_SHIFT)
-#define FIXADDR_BOOT_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
 #define FIXADDR_START		(FIXADDR_TOP - FIXADDR_SIZE)
-#define FIXADDR_BOOT_START	(FIXADDR_TOP - FIXADDR_BOOT_SIZE)
 
 extern int fixmaps_set;
 
diff --git a/arch/x86/include/asm/highmem.h b/arch/x86/include/asm/highmem.h
index 302a323..fa0713d 100644
--- a/arch/x86/include/asm/highmem.h
+++ b/arch/x86/include/asm/highmem.h
@@ -38,17 +38,20 @@ extern unsigned long highstart_pfn, highend_pfn;
 /*
  * Ordering is:
  *
- * FIXADDR_TOP
- * 			fixed_addresses
- * FIXADDR_START
- * 			temp fixed addresses
- * FIXADDR_BOOT_START
- * 			Persistent kmap area
- * PKMAP_BASE
- * VMALLOC_END
- * 			Vmalloc area
- * VMALLOC_START
- * high_memory
+ * high memory on:			              high_memory off:
+ *    FIXADDR_TOP                                        FIXADDR_TOP
+ *        fixed addresses                                    fixed addresses
+ *    FIXADDR_START                                      FIXADDR_START
+ *        temp fixed addresses/persistent kmap area      VMALLOC_END
+ *    PKMAP_BASE                                             temp fixed addresses/vmalloc area
+ *    VMALLOC_END                                        VMALLOC_START
+ *        vmalloc area                                   high_memory
+ *    VMALLOC_START
+ *    high_memory
+ *
+ * The temp fixed area is only used during boot for early_ioremap(), and
+ * it is unused when the ioremap() is functional. vmalloc/pkmap area become
+ * available after early boot so the temp fixed area is available for re-use.
  */
 #define LAST_PKMAP_MASK (LAST_PKMAP-1)
 #define PKMAP_NR(virt)  ((virt-PKMAP_BASE) >> PAGE_SHIFT)
diff --git a/arch/x86/include/asm/pgtable_32_types.h b/arch/x86/include/asm/pgtable_32_types.h
index 2ac5fc8..9fb2f2b 100644
--- a/arch/x86/include/asm/pgtable_32_types.h
+++ b/arch/x86/include/asm/pgtable_32_types.h
@@ -37,13 +37,13 @@ extern bool __vmalloc_start_set; /* set once high_memory is set */
 #define LAST_PKMAP 1024
 #endif
 
-#define PKMAP_BASE ((FIXADDR_BOOT_START - PAGE_SIZE * (LAST_PKMAP + 1))	\
+#define PKMAP_BASE ((FIXADDR_START - PAGE_SIZE * (LAST_PKMAP + 1))	\
 		    & PMD_MASK)
 
 #ifdef CONFIG_HIGHMEM
 # define VMALLOC_END	(PKMAP_BASE - 2 * PAGE_SIZE)
 #else
-# define VMALLOC_END	(FIXADDR_BOOT_START - 2 * PAGE_SIZE)
+# define VMALLOC_END	(FIXADDR_START - 2 * PAGE_SIZE)
 #endif
 
 #define MODULES_VADDR	VMALLOC_START
-- 
1.8.3.1

