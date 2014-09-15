Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218AbaIOWj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:39:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51117 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932904AbaIOWSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:18:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 029/187] sparc64: Do not insert non-valid PTEs into the TSB hash table.
Date: Mon, 15 Sep 2014 15:07:19 -0700
Message-Id: <1410818997-9432-30-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 18f38132528c3e603c66ea464727b29e9bbcb91b ]

The assumption was that update_mmu_cache() (and the equivalent for PMDs) would
only be called when the PTE being installed will be accessible by the user.

This is not true for code paths originating from remove_migration_pte().

There are dire consequences for placing a non-valid PTE into the TSB.  The TLB
miss frramework assumes thatwhen a TSB entry matches we can just load it into
the TLB and return from the TLB miss trap.

So if a non-valid PTE is in there, we will deadlock taking the TLB miss over
and over, never satisfying the miss.

Just exit early from update_mmu_cache() and friends in this situation.

Based upon a report and patch from Christopher Alexander Tobias Schulze.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/mm/init_64.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 848bea7..16b61aa 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -350,6 +350,10 @@ void update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t *
 
 	mm = vma->vm_mm;
 
+	/* Don't insert a non-valid PTE into the TSB, we'll deadlock.  */
+	if (!pte_accessible(mm, pte))
+		return;
+
 	spin_lock_irqsave(&mm->context.lock, flags);
 
 #if defined(CONFIG_HUGETLB_PAGE) || defined(CONFIG_TRANSPARENT_HUGEPAGE)
@@ -2613,6 +2617,10 @@ void update_mmu_cache_pmd(struct vm_area_struct *vma, unsigned long addr,
 
 	pte = pmd_val(entry);
 
+	/* Don't insert a non-valid PMD into the TSB, we'll deadlock.  */
+	if (!(pte & _PAGE_VALID))
+		return;
+
 	/* We are fabricating 8MB pages using 4MB real hw pages.  */
 	pte |= (addr & (1UL << REAL_HPAGE_SHIFT));
 
-- 
1.9.1

