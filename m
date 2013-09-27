Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab3I0N2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:28:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55786 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645Ab3I0N20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:28:26 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 36/63] mm: numa: Only trap pmd hinting faults if we would otherwise trap PTE faults
Date: Fri, 27 Sep 2013 14:27:21 +0100
Message-Id: <1380288468-5551-37-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380288468-5551-1-git-send-email-mgorman@suse.de>
References: <1380288468-5551-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Base page PMD faulting is meant to batch handle NUMA hinting faults from
PTEs. However, even is no PTE faults would ever be handled within a
range the kernel still traps PMD hinting faults. This patch avoids the
overhead.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/mprotect.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index f0b087d..5aae390 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -146,6 +146,8 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 
 	pmd = pmd_offset(pud, addr);
 	do {
+		unsigned long this_pages;
+
 		next = pmd_addr_end(addr, end);
 		if (pmd_trans_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
@@ -165,8 +167,9 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 		}
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
-		pages += change_pte_range(vma, pmd, addr, next, newprot,
+		this_pages = change_pte_range(vma, pmd, addr, next, newprot,
 				 dirty_accountable, prot_numa, &all_same_nidpid);
+		pages += this_pages;
 
 		/*
 		 * If we are changing protections for NUMA hinting faults then
@@ -174,7 +177,7 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 		 * node. This allows a regular PMD to be handled as one fault
 		 * and effectively batches the taking of the PTL
 		 */
-		if (prot_numa && all_same_nidpid)
+		if (prot_numa && this_pages && all_same_nidpid)
 			change_pmd_protnuma(vma->vm_mm, addr, pmd);
 	} while (pmd++, addr = next, addr != end);
 
-- 
1.8.1.4

