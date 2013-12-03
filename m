Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab3LCIwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:52:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49433 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab3LCIwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:52:10 -0500
From: Mel Gorman <mgorman@suse.de>
To: Alex Thorlton <athorlton@sgi.com>
Cc: Rik van Riel <riel@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 08/15] mm: numa: Do not clear PTE for pte_numa update
Date: Tue,  3 Dec 2013 08:51:55 +0000
Message-Id: <1386060721-3794-9-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386060721-3794-1-git-send-email-mgorman@suse.de>
References: <1386060721-3794-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TLB must be flushed if the PTE is updated but change_pte_range is clearing
the PTE while marking PTEs pte_numa without necessarily flushing the TLB if it
reinserts the same entry. Without the flush, it's conceivable that two processors
have different TLBs for the same virtual address and at the very least it would
generate spurious faults. This patch only unmaps the pages in change_pte_range for
a full protection change.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/mprotect.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 18f1117..c53e332 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -52,13 +52,14 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
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
 					/* only check non-shared pages */
@@ -81,7 +82,10 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 
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
1.8.4

