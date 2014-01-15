Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbaAOWLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:11:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41326 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbaAOV7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:59:42 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mel Gorman <mgorman@suse.de>, Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 085/166] mm: clear pmd_numa before invalidating
Date: Wed, 15 Jan 2014 13:51:39 -0800
Message-Id: <1389822780-4729-86-git-send-email-kamal@canonical.com>
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

commit 67f87463d3a3362424efcbe8b40e4772fd34fc61 upstream.

On x86, PMD entries are similar to _PAGE_PROTNONE protection and are
handled as NUMA hinting faults.  The following two page table protection
bits are what defines them

	_PAGE_NUMA:set	_PAGE_PRESENT:clear

A PMD is considered present if any of the _PAGE_PRESENT, _PAGE_PROTNONE,
_PAGE_PSE or _PAGE_NUMA bits are set.  If pmdp_invalidate encounters a
pmd_numa, it clears the present bit leaving _PAGE_NUMA which will be
considered not present by the CPU but present by pmd_present.  The
existing caller of pmdp_invalidate should handle it but it's an
inconsistent state for a PMD.  This patch keeps the state consistent
when calling pmdp_invalidate.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/pgtable-generic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 0c8323f..eb900bb 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -166,6 +166,9 @@ pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm)
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
1.8.3.2

