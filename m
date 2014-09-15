Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbaIOWKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:10:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50451 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278AbaIOWK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:10:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 015/187] sparc64: Fix executable bit testing in set_pmd_at() paths.
Date: Mon, 15 Sep 2014 15:07:05 -0700
Message-Id: <1410818997-9432-16-git-send-email-kamal@canonical.com>
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

[ Upstream commit 5b1e94fa439a3227beefad58c28c17f68287a8e9 ]

This code was mistakenly using the exec bit from the PMD in all
cases, even when the PMD isn't a huge PMD.

If it's not a huge PMD, test the exec bit in the individual ptes down
in tlb_batch_pmd_scan().

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/mm/tlb.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
index ad3bf4b..3999297 100644
--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -135,7 +135,7 @@ no_cache_flush:
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static void tlb_batch_pmd_scan(struct mm_struct *mm, unsigned long vaddr,
-			       pmd_t pmd, bool exec)
+			       pmd_t pmd)
 {
 	unsigned long end;
 	pte_t *pte;
@@ -143,8 +143,11 @@ static void tlb_batch_pmd_scan(struct mm_struct *mm, unsigned long vaddr,
 	pte = pte_offset_map(&pmd, vaddr);
 	end = vaddr + HPAGE_SIZE;
 	while (vaddr < end) {
-		if (pte_val(*pte) & _PAGE_VALID)
+		if (pte_val(*pte) & _PAGE_VALID) {
+			bool exec = pte_exec(*pte);
+
 			tlb_batch_add_one(mm, vaddr, exec);
+		}
 		pte++;
 		vaddr += PAGE_SIZE;
 	}
@@ -178,15 +181,15 @@ void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 	}
 
 	if (!pmd_none(orig)) {
-		pte_t orig_pte = __pte(pmd_val(orig));
-		bool exec = pte_exec(orig_pte);
-
 		addr &= HPAGE_MASK;
 		if (pmd_trans_huge(orig)) {
+			pte_t orig_pte = __pte(pmd_val(orig));
+			bool exec = pte_exec(orig_pte);
+
 			tlb_batch_add_one(mm, addr, exec);
 			tlb_batch_add_one(mm, addr + REAL_HPAGE_SIZE, exec);
 		} else {
-			tlb_batch_pmd_scan(mm, addr, orig, exec);
+			tlb_batch_pmd_scan(mm, addr, orig);
 		}
 	}
 }
-- 
1.9.1

