Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaFFXAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 19:00:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbaFFW7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 18:59:04 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Dave Hansen <dave.hansen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] arch/powerpc/mm/subpage-prot.c: cleanup subpage_walk_pmd_entry()
Date: Fri,  6 Jun 2014 18:58:38 -0400
Message-Id: <1402095520-10109-6-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1402095520-10109-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1402095520-10109-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently subpage_mark_vma_nohuge() uses page table walker to find thps and
then split them. But this can be done by page table walker itself, so let's
rewrite it in more suitable way. No functional change.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 arch/powerpc/mm/subpage-prot.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git v3.15-rc8-mmots-2014-06-03-16-28.orig/arch/powerpc/mm/subpage-prot.c v3.15-rc8-mmots-2014-06-03-16-28/arch/powerpc/mm/subpage-prot.c
index fa9fb5b4c66c..555cfe15371d 100644
--- v3.15-rc8-mmots-2014-06-03-16-28.orig/arch/powerpc/mm/subpage-prot.c
+++ v3.15-rc8-mmots-2014-06-03-16-28/arch/powerpc/mm/subpage-prot.c
@@ -131,11 +131,10 @@ static void subpage_prot_clear(unsigned long addr, unsigned long len)
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static int subpage_walk_pmd_entry(pmd_t *pmd, unsigned long addr,
+static int subpage_walk_pte(pte_t *pte, unsigned long addr,
 				  unsigned long end, struct mm_walk *walk)
 {
-	struct vm_area_struct *vma = walk->vma;
-	split_huge_page_pmd(vma, addr, pmd);
+	walk->control = PTWALK_BREAK;
 	return 0;
 }
 
@@ -143,9 +142,14 @@ static void subpage_mark_vma_nohuge(struct mm_struct *mm, unsigned long addr,
 				    unsigned long len)
 {
 	struct vm_area_struct *vma;
+	/*
+	 * What this walking expects is to split all thps under this mm.
+	 * Page table walker internally splits thps just before we try to
+	 * call .pte_entry() on them, so let's utilize it.
+	 */
 	struct mm_walk subpage_proto_walk = {
 		.mm = mm,
-		.pmd_entry = subpage_walk_pmd_entry,
+		.pte_entry = subpage_walk_pte,
 	};
 
 	/*
-- 
1.9.3

