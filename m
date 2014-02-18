Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaBRWNC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:13:02 -0500
Received: from shelob.surriel.com ([74.92.59.67]:50186 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaBRWM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:12:59 -0500
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, peterz@infradead.org,
        chegu_vinod@hp.com, aarcange@redhat.com, akpm@linux-foundation.org
Subject: [PATCH -mm 2/3] mm,numa: reorganize change_pmd_range
Date: Tue, 18 Feb 2014 17:12:45 -0500
Message-Id: <1392761566-24834-3-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392761566-24834-1-git-send-email-riel@redhat.com>
References: <1392761566-24834-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Reorganize the order of ifs in change_pmd_range a little, in
preparation for the next patch.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Xing Gang <gang.xing@hp.com>
Tested-by: Chegu Vinod <chegu_vinod@hp.com>
---
 mm/mprotect.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 769a67a..6006c05 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -118,6 +118,8 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 		unsigned long this_pages;
 
 		next = pmd_addr_end(addr, end);
+		if (!pmd_trans_huge(*pmd) && pmd_none_or_clear_bad(pmd))
+				continue;
 		if (pmd_trans_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
 				split_huge_page_pmd(vma, addr, pmd);
@@ -133,10 +135,9 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 					continue;
 				}
 			}
-			/* fall through */
+			/* fall through, the trans huge pmd just split */
 		}
-		if (pmd_none_or_clear_bad(pmd))
-			continue;
+		VM_BUG_ON(pmd_trans_huge(*pmd));
 		this_pages = change_pte_range(vma, pmd, addr, next, newprot,
 				 dirty_accountable, prot_numa);
 		pages += this_pages;
-- 
1.8.5.3

