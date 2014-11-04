Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaKDWS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 17:18:58 -0500
Received: from g4t3426.houston.hp.com ([15.201.208.54]:10294 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbaKDWSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 17:18:55 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        akpm@linux-foundation.org, arnd@arndb.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, jgross@suse.com,
        stefan.bader@canonical.com, luto@amacapital.net, hmh@hmh.eng.br,
        yigal@plexistor.com, konrad.wilk@oracle.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v5 7/8] x86, mm, asm: Add WT support to set_page_memtype()
Date: Tue,  4 Nov 2014 15:04:37 -0700
Message-Id: <1415138678-22958-8-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415138678-22958-1-git-send-email-toshi.kani@hp.com>
References: <1415138678-22958-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As set_memory_wb() calls set_page_memtype() with -1, _PGMT_DEFAULT is
solely used for tracking the WB type.  _PGMT_WB is defined but unused.
Hence, this patch renames _PGMT_DEFAULT to _PGMT_WB to clarify its
usage, and releases the slot used by _PGMT_WB before.  As a result,
set_memory_wb() is changed to call set_page_memtype() with _PGMT_WB,
and get_page_memtype() returns _PAGE_CACHE_MODE_WB for _PGMT_WB.

This patch then defines _PGMT_WT to the released slot.  This enables
set_page_memtype() to track the WT type.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 arch/x86/mm/pat.c |   48 +++++++++++++++++++++---------------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 5f5b950..c255ba8 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -313,17 +313,17 @@ static int pat_pagerange_is_ram(resource_size_t start, resource_size_t end)
 }
 
 /*
- * X86 PAT uses page flags WC and Uncached together to keep track of
- * memory type of pages that have backing page struct. X86 PAT supports 3
- * different memory types, _PAGE_CACHE_MODE_WB, _PAGE_CACHE_MODE_WC and
- * _PAGE_CACHE_MODE_UC_MINUS and fourth state where page's memory type has not
- * been changed from its default (value of -1 used to denote this).
+ * X86 PAT uses page flags arch_1 and uncached together to keep track of
+ * memory type of pages that have backing page struct. X86 PAT supports 4
+ * different memory types, _PAGE_CACHE_MODE_WT, _PAGE_CACHE_MODE_WC,
+ * _PAGE_CACHE_MODE_UC_MINUS and _PAGE_CACHE_MODE_WB where page's memory
+ * type has not been changed from its default.
  * Note we do not support _PAGE_CACHE_MODE_UC here.
  */
-#define _PGMT_DEFAULT		0
+#define _PGMT_WB		0	/* default */
 #define _PGMT_WC		(1UL << PG_arch_1)
 #define _PGMT_UC_MINUS		(1UL << PG_uncached)
-#define _PGMT_WB		(1UL << PG_uncached | 1UL << PG_arch_1)
+#define _PGMT_WT		(1UL << PG_uncached | 1UL << PG_arch_1)
 #define _PGMT_MASK		(1UL << PG_uncached | 1UL << PG_arch_1)
 #define _PGMT_CLEAR_MASK	(~_PGMT_MASK)
 
@@ -331,14 +331,14 @@ static inline enum page_cache_mode get_page_memtype(struct page *pg)
 {
 	unsigned long pg_flags = pg->flags & _PGMT_MASK;
 
-	if (pg_flags == _PGMT_DEFAULT)
-		return -1;
+	if (pg_flags == _PGMT_WB)
+		return _PAGE_CACHE_MODE_WB;
 	else if (pg_flags == _PGMT_WC)
 		return _PAGE_CACHE_MODE_WC;
 	else if (pg_flags == _PGMT_UC_MINUS)
 		return _PAGE_CACHE_MODE_UC_MINUS;
 	else
-		return _PAGE_CACHE_MODE_WB;
+		return _PAGE_CACHE_MODE_WT;
 }
 
 static inline void set_page_memtype(struct page *pg,
@@ -355,11 +355,12 @@ static inline void set_page_memtype(struct page *pg,
 	case _PAGE_CACHE_MODE_UC_MINUS:
 		memtype_flags = _PGMT_UC_MINUS;
 		break;
-	case _PAGE_CACHE_MODE_WB:
-		memtype_flags = _PGMT_WB;
+	case _PAGE_CACHE_MODE_WT:
+		memtype_flags = _PGMT_WT;
 		break;
+	case _PAGE_CACHE_MODE_WB:
 	default:
-		memtype_flags = _PGMT_DEFAULT;
+		memtype_flags = _PGMT_WB;	/* default */
 		break;
 	}
 
@@ -371,8 +372,9 @@ static inline void set_page_memtype(struct page *pg,
 
 /*
  * For RAM pages, we use page flags to mark the pages with appropriate type.
- * The page flags are limited to three types, WB, WC and UC-.
- * WT and WP requests fail with -EINVAL, and UC gets redirected to UC-.
+ * The page flags are limited to four types, WB (default), WC, WT and UC-.
+ * WP request fails with -EINVAL, and UC gets redirected to UC-.
+ * A new memtype can only be set to the default memtype WB.
  * Here we do two pass:
  * - Find the memtype of all the pages in the range, look for any conflicts
  * - In case of no conflicts, set the new memtype for pages in the range
@@ -384,8 +386,7 @@ static int reserve_ram_pages_type(u64 start, u64 end,
 	struct page *page;
 	u64 pfn;
 
-	if ((req_type == _PAGE_CACHE_MODE_WT) ||
-	    (req_type == _PAGE_CACHE_MODE_WP)) {
+	if (req_type == _PAGE_CACHE_MODE_WP) {
 		if (new_type)
 			*new_type = _PAGE_CACHE_MODE_UC_MINUS;
 		return -EINVAL;
@@ -402,7 +403,7 @@ static int reserve_ram_pages_type(u64 start, u64 end,
 
 		page = pfn_to_page(pfn);
 		type = get_page_memtype(page);
-		if (type != -1) {
+		if (type != _PAGE_CACHE_MODE_WB) {
 			pr_info("reserve_ram_pages_type failed [mem %#010Lx-%#010Lx], track 0x%x, req 0x%x\n",
 				start, end - 1, type, req_type);
 			if (new_type)
@@ -429,7 +430,7 @@ static int free_ram_pages_type(u64 start, u64 end)
 
 	for (pfn = (start >> PAGE_SHIFT); pfn < (end >> PAGE_SHIFT); ++pfn) {
 		page = pfn_to_page(pfn);
-		set_page_memtype(page, -1);
+		set_page_memtype(page, _PAGE_CACHE_MODE_WB);
 	}
 	return 0;
 }
@@ -558,7 +559,7 @@ int free_memtype(u64 start, u64 end)
  * @paddr: physical address of which memory type needs to be looked up
  *
  * Returns _PAGE_CACHE_MODE_WB, _PAGE_CACHE_MODE_WC, _PAGE_CACHE_MODE_UC_MINUS
- * or _PAGE_CACHE_MODE_UC
+ * or _PAGE_CACHE_MODE_WT.
  */
 static enum page_cache_mode lookup_memtype(u64 paddr)
 {
@@ -572,13 +573,6 @@ static enum page_cache_mode lookup_memtype(u64 paddr)
 		struct page *page;
 		page = pfn_to_page(paddr >> PAGE_SHIFT);
 		rettype = get_page_memtype(page);
-		/*
-		 * -1 from get_page_memtype() implies RAM page is in its
-		 * default state and not reserved, and hence of type WB
-		 */
-		if (rettype == -1)
-			rettype = _PAGE_CACHE_MODE_WB;
-
 		return rettype;
 	}
 
