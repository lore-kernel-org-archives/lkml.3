Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879Ab3ECAC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 20:02:27 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:35737 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761867Ab3ECACW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 20:02:22 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v3 11/31] page-flags dnuma: reserve a pageflag for determining if a page needs a node lookup.
Date: Thu,  2 May 2013 17:00:43 -0700
Message-Id: <1367539263-19999-12-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050300-5518-0000-0000-00000E3E2D63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a pageflag called "lookup_node"/ PG_lookup_node / Page*LookupNode().

Used by dynamic numa to indicate when a page has a new node assignment
waiting for it.

FIXME: This also exempts PG_lookup_node from PAGE_FLAGS_CHECK_AT_PREP
due to the asynchronous usage of PG_lookup_node, which needs to be
avoided.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/page-flags.h | 19 +++++++++++++++++++
 mm/page_alloc.c            |  3 +++
 2 files changed, 22 insertions(+)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 6d53675..09dd94e 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -109,6 +109,9 @@ enum pageflags {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	PG_compound_lock,
 #endif
+#ifdef CONFIG_DYNAMIC_NUMA
+	PG_lookup_node,		/* extra lookup required to find real node */
+#endif
 	__NR_PAGEFLAGS,
 
 	/* Filesystems */
@@ -275,6 +278,17 @@ PAGEFLAG_FALSE(HWPoison)
 #define __PG_HWPOISON 0
 #endif
 
+/* Setting is unconditional, simply leads to an extra lookup.
+ * Clearing must be conditional so we don't miss any memlayout changes.
+ */
+#ifdef CONFIG_DYNAMIC_NUMA
+PAGEFLAG(LookupNode, lookup_node)
+TESTCLEARFLAG(LookupNode, lookup_node)
+#else
+PAGEFLAG_FALSE(LookupNode)
+TESTCLEARFLAG_FALSE(LookupNode)
+#endif
+
 u64 stable_page_flags(struct page *page);
 
 static inline int PageUptodate(struct page *page)
@@ -509,7 +523,12 @@ static inline void ClearPageSlabPfmemalloc(struct page *page)
  * Pages being prepped should not have any flags set.  It they are set,
  * there has been a kernel bug or struct page corruption.
  */
+#ifndef CONFIG_DYNAMIC_NUMA
 #define PAGE_FLAGS_CHECK_AT_PREP	((1 << NR_PAGEFLAGS) - 1)
+#else
+#define PAGE_FLAGS_CHECK_AT_PREP	(((1 << NR_PAGEFLAGS) - 1) \
+						& ~(1 << PG_lookup_node))
+#endif
 
 #define PAGE_FLAGS_PRIVATE				\
 	(1 << PG_private | 1 << PG_private_2)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9de55a2..ea4fda8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6238,6 +6238,9 @@ static const struct trace_print_flags pageflag_names[] = {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	{1UL << PG_compound_lock,	"compound_lock"	},
 #endif
+#ifdef CONFIG_DYNAMIC_NUMA
+	{1UL << PG_lookup_node,		"lookup_node"   },
+#endif
 };
 
 static void dump_page_flags(unsigned long flags)
-- 
1.8.2.2

