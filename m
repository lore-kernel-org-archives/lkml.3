Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223AbaHHVgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:36:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60526 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932916AbaHHVgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:36:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 19/39] sparc64: Fix executable bit testing in set_pmd_at() paths.
Date: Fri,  8 Aug 2014 14:35:05 -0700
Message-Id: <20140808213355.798633560@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213354.980430919@linuxfoundation.org>
References: <20140808213354.980430919@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 5b1e94fa439a3227beefad58c28c17f68287a8e9 ]

This code was mistakenly using the exec bit from the PMD in all
cases, even when the PMD isn't a huge PMD.

If it's not a huge PMD, test the exec bit in the individual ptes down
in tlb_batch_pmd_scan().

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/mm/tlb.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -134,7 +134,7 @@ no_cache_flush:
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static void tlb_batch_pmd_scan(struct mm_struct *mm, unsigned long vaddr,
-			       pmd_t pmd, bool exec)
+			       pmd_t pmd)
 {
 	unsigned long end;
 	pte_t *pte;
@@ -142,8 +142,11 @@ static void tlb_batch_pmd_scan(struct mm
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
@@ -177,15 +180,15 @@ void set_pmd_at(struct mm_struct *mm, un
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


