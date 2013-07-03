Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964771Ab3GCNCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 09:02:16 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:51881 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278Ab3GCNCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 09:02:11 -0400
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Konstantin Weitz <konstantin.weitz@gmail.com>
Subject: [PATCH 1/2] mm: add support for discard of unused ptes
Date: Wed,  3 Jul 2013 15:01:51 +0200
Message-Id: <1372856512-25710-2-git-send-email-schwidefsky@de.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372856512-25710-1-git-send-email-schwidefsky@de.ibm.com>
References: <1372856512-25710-1-git-send-email-schwidefsky@de.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070312-5024-0000-0000-0000067D7B91
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Weitz <konstantin.weitz@gmail.com>

In a virtualized environment and given an appropriate interface the guest
can mark pages as unused while they are free (for the s390 implementation
see git commit 45e576b1c3d00206 "guest page hinting light"). For the host
the unused state is a property of the pte.

This patch adds the primitive 'pte_unused' and code to the host swap out
handler so that pages marked as unused by all mappers are not swapped out
but discarded instead, thus saving one IO for swap out and potentially
another one for swap in.

[ Martin Schwidefsky: patch reordering and cleanup ]

Signed-off-by: Konstantin Weitz <konstantin.weitz@gmail.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 include/asm-generic/pgtable.h |   13 +++++++++++++
 include/linux/rmap.h          |    1 +
 mm/rmap.c                     |   28 +++++++++++++++++++++++++++-
 mm/vmscan.c                   |    3 +++
 4 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index b183698..aae349a 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -192,6 +192,19 @@ static inline int pte_same(pte_t pte_a, pte_t pte_b)
 }
 #endif
 
+#ifndef __HAVE_ARCH_PTE_UNUSED
+/*
+ * Some architectures provide facilities to virtualization guests
+ * so that they can flag allocated pages as unused. This allows the
+ * host to transparently reclaim unused pages. This function returns
+ * whether the pte's page is unused.
+ */
+static inline int pte_unused(pte_t pte)
+{
+	return 0;
+}
+#endif
+
 #ifndef __HAVE_ARCH_PMD_SAME
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline int pmd_same(pmd_t pmd_a, pmd_t pmd_b)
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 6dacb93..915e5c6 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -272,5 +272,6 @@ static inline int page_mkclean(struct page *page)
 #define SWAP_AGAIN	1
 #define SWAP_FAIL	2
 #define SWAP_MLOCK	3
+#define SWAP_FREE	4
 
 #endif	/* _LINUX_RMAP_H */
diff --git a/mm/rmap.c b/mm/rmap.c
index 6280da8..be2788d 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1233,6 +1233,10 @@ int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 		}
 		set_pte_at(mm, address, pte,
 			   swp_entry_to_pte(make_hwpoison_entry(page)));
+	} else if (pte_unused(pteval) && PageAnon(page)) {
+		pte_clear(mm, address, pte);
+		dec_mm_counter(mm, MM_ANONPAGES);
+		ret = SWAP_FREE;
 	} else if (PageAnon(page)) {
 		swp_entry_t entry = { .val = page_private(page) };
 
@@ -1455,6 +1459,7 @@ static int try_to_unmap_anon(struct page *page, enum ttu_flags flags)
 	pgoff_t pgoff;
 	struct anon_vma_chain *avc;
 	int ret = SWAP_AGAIN;
+	int used = 0;
 
 	anon_vma = page_lock_anon_vma_read(page);
 	if (!anon_vma)
@@ -1479,10 +1484,31 @@ static int try_to_unmap_anon(struct page *page, enum ttu_flags flags)
 
 		address = vma_address(page, vma);
 		ret = try_to_unmap_one(page, vma, address, flags);
+
+		/*
+		 * If SWAP_FREE was returned, we know that the page
+		 * is not used (as indicated by pte_unused()) by this
+		 * mapper. If only one of the mappers used the page,
+		 * it is considered used.
+		 */
+		if (ret == SWAP_FREE)
+			ret = SWAP_AGAIN;
+		else
+			used = 1;
+
 		if (ret != SWAP_AGAIN || !page_mapped(page))
 			break;
 	}
 
+	/*
+	 * If none of the mappers use the page, clear the dirty bit
+	 * so that the caller of try_to_unmap_anon() will free its mapping.
+	 */
+	if (!used && page_swapcount(page) == 0) {
+		ClearPageDirty(page);
+		ret = SWAP_FREE;
+	}
+
 	page_unlock_anon_vma_read(anon_vma);
 	return ret;
 }
@@ -1625,7 +1651,7 @@ int try_to_unmap(struct page *page, enum ttu_flags flags)
 		ret = try_to_unmap_anon(page, flags);
 	else
 		ret = try_to_unmap_file(page, flags);
-	if (ret != SWAP_MLOCK && !page_mapped(page))
+	if (ret != SWAP_FREE && ret != SWAP_MLOCK && !page_mapped(page))
 		ret = SWAP_SUCCESS;
 	return ret;
 }
diff --git a/mm/vmscan.c b/mm/vmscan.c
index fa6a853..093c1d7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -800,6 +800,9 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 				goto keep_locked;
 			case SWAP_MLOCK:
 				goto cull_mlocked;
+			case SWAP_FREE:
+				if (PageSwapCache(page))
+					try_to_free_swap(page);
 			case SWAP_SUCCESS:
 				; /* try to free the page below */
 			}
-- 
1.7.9.5

