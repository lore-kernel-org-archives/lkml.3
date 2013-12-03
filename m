Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab3LCIwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:52:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49424 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888Ab3LCIwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:52:08 -0500
From: Mel Gorman <mgorman@suse.de>
To: Alex Thorlton <athorlton@sgi.com>
Cc: Rik van Riel <riel@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 06/15] mm: Clear pmd_numa before invalidating
Date: Tue,  3 Dec 2013 08:51:53 +0000
Message-Id: <1386060721-3794-7-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386060721-3794-1-git-send-email-mgorman@suse.de>
References: <1386060721-3794-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pmdp_invalidate clears the present bit without taking into account that it
might be in the _PAGE_NUMA bit leaving the PMD in an unexpected state. Clear
pmd_numa before invalidating.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/pgtable-generic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 3929a40..a7aefd3 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -191,6 +191,9 @@ pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
 void pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 		     pmd_t *pmdp)
 {
+	pmd_t entry = *pmdp;
+	if (pmd_numa(entry))
+		entry = pmd_mknonnuma(entry);
 	set_pmd_at(vma->vm_mm, address, pmdp, pmd_mknotpresent(*pmdp));
 	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 }
-- 
1.8.4

