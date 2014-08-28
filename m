Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaH1SgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:36:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32834 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbaH1Sfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:35:52 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 05/97] mm: fix bad rss-counter if remap_file_pages raced migration
Date: Thu, 28 Aug 2014 19:34:13 +0100
Message-Id: <1409250945-30874-6-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

commit 887843961c4b4681ee993c36d4997bf4b4aa8253 upstream.

Fix some "Bad rss-counter state" reports on exit, arising from the
interaction between page migration and remap_file_pages(): zap_pte()
must count a migration entry when zapping it.

And yes, it is possible (though very unusual) to find an anon page or
swap entry in a VM_SHARED nonlinear mapping: coming from that horrid
get_user_pages(write, force) case which COWs even in a shared mapping.

Signed-off-by: Hugh Dickins <hughd@google.com>
Tested-by: Sasha Levin sasha.levin@oracle.com>
Tested-by: Dave Jones davej@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/fremap.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/mm/fremap.c b/mm/fremap.c
index bbc4d66..34feba6 100644
--- a/mm/fremap.c
+++ b/mm/fremap.c
@@ -23,28 +23,44 @@
 
 #include "internal.h"
 
+static int mm_counter(struct page *page)
+{
+	return PageAnon(page) ? MM_ANONPAGES : MM_FILEPAGES;
+}
+
 static void zap_pte(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long addr, pte_t *ptep)
 {
 	pte_t pte = *ptep;
+	struct page *page;
+	swp_entry_t entry;
 
 	if (pte_present(pte)) {
-		struct page *page;
-
 		flush_cache_page(vma, addr, pte_pfn(pte));
 		pte = ptep_clear_flush(vma, addr, ptep);
 		page = vm_normal_page(vma, addr, pte);
 		if (page) {
 			if (pte_dirty(pte))
 				set_page_dirty(page);
+			update_hiwater_rss(mm);
+			dec_mm_counter(mm, mm_counter(page));
 			page_remove_rmap(page);
 			page_cache_release(page);
+		}
+	} else {	/* zap_pte() is not called when pte_none() */
+		if (!pte_file(pte)) {
 			update_hiwater_rss(mm);
-			dec_mm_counter(mm, MM_FILEPAGES);
+			entry = pte_to_swp_entry(pte);
+			if (non_swap_entry(entry)) {
+				if (is_migration_entry(entry)) {
+					page = migration_entry_to_page(entry);
+					dec_mm_counter(mm, mm_counter(page));
+				}
+			} else {
+				free_swap_and_cache(entry);
+				dec_mm_counter(mm, MM_SWAPENTS);
+			}
 		}
-	} else {
-		if (!pte_file(pte))
-			free_swap_and_cache(pte_to_swp_entry(pte));
 		pte_clear_not_present_full(mm, addr, ptep, 0);
 	}
 }
-- 
1.8.4.5

