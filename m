Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaKGH7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 02:59:41 -0500
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:52435 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaKGH7j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 02:59:39 -0500
X-Greylist: delayed 2890 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Nov 2014 02:51:26 EST
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Feiner <pfeiner@google.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH -mm v7 01/13] mm/pagewalk: remove pgd_entry() and pud_entry()
Thread-Topic: [PATCH -mm v7 01/13] mm/pagewalk: remove pgd_entry() and
 pud_entry()
Thread-Index: AQHP+li1F2PIjEtmSki5v7CgUue6gQ==
Date: Fri, 7 Nov 2014 07:01:52 +0000
Message-ID: <1415343692-6314-2-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1415343692-6314-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1415343692-6314-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.128.101.22]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently no user of page table walker sets ->pgd_entry() or ->pud_entry(),
so checking their existence in each loop is just wasting CPU cycle.
So let's remove it to reduce overhead.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/mm.h | 6 ------
 mm/pagewalk.c      | 9 ++-------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git mmotm-2014-11-05-16-01.orig/include/linux/mm.h mmotm-2014-11-05-16-01/include/linux/mm.h
index 423024a0d3db..ba964aa0282a 100644
--- mmotm-2014-11-05-16-01.orig/include/linux/mm.h
+++ mmotm-2014-11-05-16-01/include/linux/mm.h
@@ -1120,8 +1120,6 @@ void unmap_vmas(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
 
 /**
  * mm_walk - callbacks for walk_page_range
- * @pgd_entry: if set, called for each non-empty PGD (top-level) entry
- * @pud_entry: if set, called for each non-empty PUD (2nd-level) entry
  * @pmd_entry: if set, called for each non-empty PMD (3rd-level) entry
  *	       this handler is required to be able to handle
  *	       pmd_trans_huge() pmds.  They may simply choose to
@@ -1135,10 +1133,6 @@ void unmap_vmas(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
  * (see walk_page_range for more details)
  */
 struct mm_walk {
-	int (*pgd_entry)(pgd_t *pgd, unsigned long addr,
-			 unsigned long next, struct mm_walk *walk);
-	int (*pud_entry)(pud_t *pud, unsigned long addr,
-	                 unsigned long next, struct mm_walk *walk);
 	int (*pmd_entry)(pmd_t *pmd, unsigned long addr,
 			 unsigned long next, struct mm_walk *walk);
 	int (*pte_entry)(pte_t *pte, unsigned long addr,
diff --git mmotm-2014-11-05-16-01.orig/mm/pagewalk.c mmotm-2014-11-05-16-01/mm/pagewalk.c
index ad83195521f2..5d41393260c8 100644
--- mmotm-2014-11-05-16-01.orig/mm/pagewalk.c
+++ mmotm-2014-11-05-16-01/mm/pagewalk.c
@@ -86,9 +86,7 @@ static int walk_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end,
 				break;
 			continue;
 		}
-		if (walk->pud_entry)
-			err = walk->pud_entry(pud, addr, next, walk);
-		if (!err && (walk->pmd_entry || walk->pte_entry))
+		if (walk->pmd_entry || walk->pte_entry)
 			err = walk_pmd_range(pud, addr, next, walk);
 		if (err)
 			break;
@@ -234,10 +232,7 @@ int walk_page_range(unsigned long addr, unsigned long end,
 			pgd++;
 			continue;
 		}
-		if (walk->pgd_entry)
-			err = walk->pgd_entry(pgd, addr, next, walk);
-		if (!err &&
-		    (walk->pud_entry || walk->pmd_entry || walk->pte_entry))
+		if (walk->pmd_entry || walk->pte_entry)
 			err = walk_pud_range(pgd, addr, next, walk);
 		if (err)
 			break;
-- 
2.2.0.rc0.2.gf745acb
