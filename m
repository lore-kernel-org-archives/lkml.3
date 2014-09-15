Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbaIOWKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:10:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50459 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287AbaIOWK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:10:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 017/187] sparc64: Fix bugs in get_user_pages_fast() wrt. THP.
Date: Mon, 15 Sep 2014 15:07:07 -0700
Message-Id: <1410818997-9432-18-git-send-email-kamal@canonical.com>
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

[ Upstream commit 04df419de34104d8818b8c5cffaa062fa36d20ea ]

The large PMD path needs to check _PAGE_VALID not _PAGE_PRESENT, to
decide if it needs to bail and return 0.

pmd_large() should therefore just check _PAGE_PMD_HUGE.

Calls to gup_huge_pmd() are guarded with a check of pmd_large(), so we
just need to add a valid bit check.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/include/asm/pgtable_64.h | 2 +-
 arch/sparc/mm/gup.c                 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index e3db4b8..1f28103 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -633,7 +633,7 @@ static inline unsigned long pmd_large(pmd_t pmd)
 {
 	pte_t pte = __pte(pmd_val(pmd));
 
-	return (pte_val(pte) & _PAGE_PMD_HUGE) && pte_present(pte);
+	return pte_val(pte) & _PAGE_PMD_HUGE;
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff --git a/arch/sparc/mm/gup.c b/arch/sparc/mm/gup.c
index c4d3da6..1aed043 100644
--- a/arch/sparc/mm/gup.c
+++ b/arch/sparc/mm/gup.c
@@ -73,7 +73,7 @@ static int gup_huge_pmd(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
 	struct page *head, *page, *tail;
 	int refs;
 
-	if (!pmd_large(pmd))
+	if (!(pmd_val(pmd) & _PAGE_VALID))
 		return 0;
 
 	if (write && !pmd_write(pmd))
-- 
1.9.1

