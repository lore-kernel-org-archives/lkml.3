Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab3LJP46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:56:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687Ab3LJPvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:51:41 -0500
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 05/18] mm: numa: Do not clear PTE for pte_numa update
Date: Tue, 10 Dec 2013 15:51:23 +0000
Message-Id: <1386690695-27380-6-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386690695-27380-1-git-send-email-mgorman@suse.de>
References: <1386690695-27380-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TLB must be flushed if the PTE is updated but change_pte_range is clearing
the PTE while marking PTEs pte_numa without necessarily flushing the TLB if it
reinserts the same entry. Without the flush, it's conceivable that two processors
have different TLBs for the same virtual address and at the very least it would
generate spurious faults. This patch only unmaps the pages in change_pte_range for
a full protection change.

Cc: stable@vger.kernel.org
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
---
 mm/mprotect.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 2666797..0a07e2d 100644
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
 					if (!pte_numa(oldpte)) {
@@ -79,7 +80,10 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 
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

