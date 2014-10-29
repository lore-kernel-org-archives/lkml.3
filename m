Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbaJ2GMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 02:12:49 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35144 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaJ2GMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 02:12:48 -0400
From: Minfei Huang <mnfhuang@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, pbonzini@redhat.com,
        akpm@linux-foundation.org, bp@suse.de
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Minfei Huang <mnfhuang@gmail.com>
Subject: [PATCH] x86/mm: Re-use the early_ioremap fixed area
Date: Wed, 29 Oct 2014 14:12:31 +0800
Message-Id: <1414563151-7175-1-git-send-email-mnfhuang@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FIXADDR_BOOT area is only used during boot for early_ioremap, and
it is unused when the ioremap is functional. vmalloc becomes available
after early boot so the FIXADDR_BOOT_START area is available for reuse.

The virtual address is more precious on i386, especially turning on the
high memory. So we can reuse the virtual address whichever we can.

The macros of FIXADDR_BOOT_START and FIXADDR_BOOT_SIZE donot use any
more.

Signed-off-by: Minfei Huang <mnfhuang@gmail.com>
---
 arch/x86/include/asm/fixmap.h           | 2 --
 arch/x86/include/asm/highmem.h          | 4 +---
 arch/x86/include/asm/pgtable_32_types.h | 4 ++--
 3 files changed, 3 insertions(+), 7 deletions(-)

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
index 302a323..49b7469 100644
--- a/arch/x86/include/asm/highmem.h
+++ b/arch/x86/include/asm/highmem.h
@@ -41,9 +41,7 @@ extern unsigned long highstart_pfn, highend_pfn;
  * FIXADDR_TOP
  * 			fixed_addresses
  * FIXADDR_START
- * 			temp fixed addresses
- * FIXADDR_BOOT_START
- * 			Persistent kmap area
+ *                     temp fixed addresses / Persistent kmap area
  * PKMAP_BASE
  * VMALLOC_END
  * 			Vmalloc area
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

