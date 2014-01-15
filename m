Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbaAOV6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:58:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41053 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbaAOV6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:58:11 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Alex Thorlton <athorlton@sgi.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 087/166] mm: numa: do not clear PTE for pte_numa update
Date: Wed, 15 Jan 2014 13:51:41 -0800
Message-Id: <1389822780-4729-88-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 0c5f83c23ca703d32f930393825487257a5cde6d upstream.

The TLB must be flushed if the PTE is updated but change_pte_range is
clearing the PTE while marking PTEs pte_numa without necessarily
flushing the TLB if it reinserts the same entry.  Without the flush,
it's conceivable that two processors have different TLBs for the same
virtual address and at the very least it would generate spurious faults.

This patch only unmaps the pages in change_pte_range for a full
protection change.

[riel@redhat.com: write pte_numa pte back to the page tables]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>
Cc: Chegu Vinod <chegu_vinod@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/mprotect.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 4c35eb8..79abf13 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -54,13 +54,14 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 			pte_t ptent;
 			bool updated = false;
 
-			ptent = ptep_modify_prot_start(mm, addr, pte);
 			if (!prot_numa) {
+				ptent = ptep_modify_prot_start(mm, addr, pte);
 				ptent = pte_modify(ptent, newprot);
 				updated = true;
 			} else {
 				struct page *page;
 
+				ptent = *pte;
 				page = vm_normal_page(vma, addr, oldpte);
 				if (page) {
 					int this_nid = page_to_nid(page);
@@ -73,6 +74,7 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 					if (!pte_numa(oldpte) &&
 					    page_mapcount(page) == 1) {
 						ptent = pte_mknuma(ptent);
+						set_pte_at(mm, addr, pte, ptent);
 						updated = true;
 					}
 				}
@@ -89,7 +91,10 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 
 			if (updated)
 				pages++;
-			ptep_modify_prot_commit(mm, addr, pte, ptent);
+
+			/* Only !prot_numa always clears the pte */
+			if (!prot_numa)
+				ptep_modify_prot_commit(mm, addr, pte, ptent);
 		} else if (IS_ENABLED(CONFIG_MIGRATION) && !pte_file(oldpte)) {
 			swp_entry_t entry = pte_to_swp_entry(oldpte);
 
-- 
1.8.3.2

