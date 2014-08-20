Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbaHTMDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:03:54 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58924 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752520AbaHTLoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 045/104] sparc64: Fix executable bit testing in set_pmd_at() paths.
Date: Wed, 20 Aug 2014 13:43:08 +0200
Message-Id: <bf42f839476f1f447ca696fbbab7e741861d9d7d.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David S. Miller" <davem@davemloft.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 5b1e94fa439a3227beefad58c28c17f68287a8e9 ]

This code was mistakenly using the exec bit from the PMD in all
cases, even when the PMD isn't a huge PMD.

If it's not a huge PMD, test the exec bit in the individual ptes down
in tlb_batch_pmd_scan().

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/sparc/mm/tlb.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
index 7a91f288c708..b87ad6c5a8ab 100644
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
@@ -178,13 +181,13 @@ void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 	}
 
 	if (!pmd_none(orig)) {
-		bool exec = ((pmd_val(orig) & PMD_HUGE_EXEC) != 0);
-
 		addr &= HPAGE_MASK;
-		if (pmd_val(orig) & PMD_ISHUGE)
+		if (pmd_val(orig) & PMD_ISHUGE) {
+			bool exec = ((pmd_val(orig) & PMD_HUGE_EXEC) != 0);
+
 			tlb_batch_add_one(mm, addr, exec);
-		else
-			tlb_batch_pmd_scan(mm, addr, orig, exec);
+		} else
+			tlb_batch_pmd_scan(mm, addr, orig);
 	}
 }
 
-- 
2.0.4

