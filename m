Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbaAMQZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:25:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53519 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301AbaAMQEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:04:16 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mel Gorman <mgorman@suse.de>, Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 145/208] mm: clear pmd_numa before invalidating
Date: Mon, 13 Jan 2014 15:59:46 +0000
Message-Id: <1389628849-1614-146-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/pgtable-generic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index e1a6e4f..0e083c5 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -167,6 +167,9 @@ pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
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

