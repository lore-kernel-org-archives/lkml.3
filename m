Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933692AbaGOTpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:45:49 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:38544 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933657AbaGOTpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:45:40 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        akpm@linux-foundation.org, arnd@arndb.de, konrad.wilk@oracle.com,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stefan.bader@canonical.com, luto@amacapital.net, airlied@gmail.com,
        bp@alien8.de, Toshi Kani <toshi.kani@hp.com>
Subject: [RFC PATCH 8/11] x86, mm, pat: Keep pgprot_<type>() slot-independent
Date: Tue, 15 Jul 2014 13:34:41 -0600
Message-Id: <1405452884-25688-9-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405452884-25688-1-git-send-email-toshi.kani@hp.com>
References: <1405452884-25688-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pgrot_<type>() interfaces only set the _PAGE_PCD and/or
_PAGE_PWT bits by assuming that a given pgprot_t value is always
set to the PA0 slot.

This patch changes the pgrot_<type>() interfaces to assure that
a requested memory type is set to the given pgprot_t regardless
of the original pgprot_t value.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 arch/x86/include/asm/pgtable.h       |    2 +-
 arch/x86/include/asm/pgtable_types.h |    4 ++++
 arch/x86/mm/pat.c                    |    4 ++--
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 0ec0560..df18b14 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -11,7 +11,7 @@
  */
 #define pgprot_noncached(prot)					\
 	((boot_cpu_data.x86 > 3)				\
-	 ? (__pgprot(pgprot_val(prot) | _PAGE_CACHE_UC_MINUS))	\
+	 ? pgprot_set_cache(prot, _PAGE_CACHE_UC_MINUS)		\
 	 : (prot))
 
 #ifndef __ASSEMBLY__
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 1fe8af7..81a3859 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -136,6 +136,10 @@
 #define _PAGE_CACHE_UC_MINUS	(_PAGE_PCD)
 #define _PAGE_CACHE_UC		(_PAGE_CACHE_UC_MINUS)
 
+/* Macro to set a page cache value */
+#define pgprot_set_cache(_prot, _type)					\
+	__pgprot((pgprot_val(_prot) & ~_PAGE_CACHE_MASK) | (_type))
+
 #define PAGE_NONE	__pgprot(_PAGE_PROTNONE | _PAGE_ACCESSED)
 #define PAGE_SHARED	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | \
 				 _PAGE_ACCESSED | _PAGE_NX)
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index a987071..0be7ebd 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -790,7 +790,7 @@ void untrack_pfn(struct vm_area_struct *vma, unsigned long pfn,
 pgprot_t pgprot_writecombine(pgprot_t prot)
 {
 	if (pat_enabled)
-		return __pgprot(pgprot_val(prot) | _PAGE_CACHE_WC);
+		return pgprot_set_cache(prot, _PAGE_CACHE_WC);
 	else
 		return pgprot_noncached(prot);
 }
@@ -799,7 +799,7 @@ EXPORT_SYMBOL_GPL(pgprot_writecombine);
 pgprot_t pgprot_writethrough(pgprot_t prot)
 {
 	if (pat_enabled)
-		return __pgprot(pgprot_val(prot) | _PAGE_CACHE_WT);
+		return pgprot_set_cache(prot, _PAGE_CACHE_WT);
 	else
 		return pgprot_noncached(prot);
 }
