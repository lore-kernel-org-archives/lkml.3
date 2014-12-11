Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbaLKNUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 08:20:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:61163 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611AbaLKNUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 08:20:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="427773629"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: akpm@linux-foundation.org
Cc: cl@linux.com, jmarchan@redhat.com, aneesh.kumar@linux.vnet.ibm.com,
        dave.hansen@intel.com, aarcange@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH] mm: add fields for compound destructor and order into struct page
Date: Thu, 11 Dec 2014 15:20:27 +0200
Message-Id: <1418304027-154173-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we use lru.next/lru.prev plus cast to access or set
destructor and order of compound page.

Let's replace it with explicit fields in struct page.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/mm.h       | 9 ++++-----
 include/linux/mm_types.h | 8 ++++++++
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5bfd9b9756fa..a8de6fe11d0a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -525,29 +525,28 @@ int split_free_page(struct page *page);
  * prototype for that function and accessor functions.
  * These are _only_ valid on the head of a PG_compound page.
  */
-typedef void compound_page_dtor(struct page *);
 
 static inline void set_compound_page_dtor(struct page *page,
 						compound_page_dtor *dtor)
 {
-	page[1].lru.next = (void *)dtor;
+	page[1].compound_dtor = dtor;
 }
 
 static inline compound_page_dtor *get_compound_page_dtor(struct page *page)
 {
-	return (compound_page_dtor *)page[1].lru.next;
+	return page[1].compound_dtor;
 }
 
 static inline int compound_order(struct page *page)
 {
 	if (!PageHead(page))
 		return 0;
-	return (unsigned long)page[1].lru.prev;
+	return page[1].compound_order;
 }
 
 static inline void set_compound_order(struct page *page, unsigned long order)
 {
-	page[1].lru.prev = (void *)order;
+	page[1].compound_order = order;
 }
 
 #ifdef CONFIG_MMU
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 03945eef1350..cbc71f32a53c 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -28,6 +28,8 @@ struct mem_cgroup;
 		IS_ENABLED(CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK))
 #define ALLOC_SPLIT_PTLOCKS	(SPINLOCK_SIZE > BITS_PER_LONG/8)
 
+typedef void compound_page_dtor(struct page *);
+
 /*
  * Each physical page in the system has a struct page associated with
  * it to keep track of whatever it is we are using the page for at the
@@ -131,6 +133,12 @@ struct page {
 		struct rcu_head rcu_head;	/* Used by SLAB
 						 * when destroying via RCU
 						 */
+		/* First tail page of compound page */
+		struct {
+			compound_page_dtor *compound_dtor;
+			unsigned long compound_order;
+		};
+
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && USE_SPLIT_PMD_PTLOCKS
 		pgtable_t pmd_huge_pte; /* protected by page->ptl */
 #endif
-- 
2.1.3

