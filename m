Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaLBIa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:30:27 -0500
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:46717 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaLBIaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:30:23 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
CC: David Rientjes <rientjes@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [PATCH v5 2/8] mm/hugetlb: pmd_huge() returns true for non-present
 hugepage
Thread-Topic: [PATCH v5 2/8] mm/hugetlb: pmd_huge() returns true for
 non-present hugepage
Thread-Index: AQHQDgmx9Rq4ytL+d0OCciaohodjDA==
Date: Tue, 2 Dec 2014 08:26:39 +0000
Message-ID: <1417508759-10848-3-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1417508759-10848-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1417508759-10848-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.128.101.13]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Migrating hugepages and hwpoisoned hugepages are considered as
non-present hugepages, and they are referenced via migration entries
and hwpoison entries in their page table slots.

This behavior causes race condition because pmd_huge() doesn't tell
non-huge pages from migrating/hwpoisoned hugepages. follow_page_mask()
is one example where the kernel would call follow_page_pte() for such
hugepage while this function is supposed to handle only normal pages.

To avoid this, this patch makes pmd_huge() return true when pmd_none()
is true *and* pmd_present() is false. We don't have to worry about mixing
up non-present pmd entry with normal pmd (pointing to leaf level pte
entry) because pmd_present() is true in normal pmd.

The same race condition could happen in (x86-specific) gup_pmd_range(),
where this patch simply adds pmd_present() check instead of pmd_huge().
This is because gup_pmd_range() is fast path. If we have non-present
hugepage in this function, we will go into gup_huge_pmd(), then return
0 at flag mask check, and finally fall back to the slow path.

Fixes: 290408d4a2 ("hugetlb: hugepage migration core")
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org> # [2.6.36+]
---
 arch/x86/mm/gup.c         | 2 +-
 arch/x86/mm/hugetlbpage.c | 8 +++++++-
 mm/hugetlb.c              | 2 ++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git mmotm-2014-11-26-15-45.orig/arch/x86/mm/gup.c mmotm-2014-11-26-15-45/arch/x86/mm/gup.c
index 207d9aef662d..448ee8912d9b 100644
--- mmotm-2014-11-26-15-45.orig/arch/x86/mm/gup.c
+++ mmotm-2014-11-26-15-45/arch/x86/mm/gup.c
@@ -172,7 +172,7 @@ static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
 		 */
 		if (pmd_none(pmd) || pmd_trans_splitting(pmd))
 			return 0;
-		if (unlikely(pmd_large(pmd))) {
+		if (unlikely(pmd_large(pmd) || !pmd_present(pmd))) {
 			/*
 			 * NUMA hinting faults need to be handled in the GUP
 			 * slowpath for accounting purposes and so that they
diff --git mmotm-2014-11-26-15-45.orig/arch/x86/mm/hugetlbpage.c mmotm-2014-11-26-15-45/arch/x86/mm/hugetlbpage.c
index 03b8a7c11817..9161f764121e 100644
--- mmotm-2014-11-26-15-45.orig/arch/x86/mm/hugetlbpage.c
+++ mmotm-2014-11-26-15-45/arch/x86/mm/hugetlbpage.c
@@ -54,9 +54,15 @@ int pud_huge(pud_t pud)
 
 #else
 
+/*
+ * pmd_huge() returns 1 if @pmd is hugetlb related entry, that is normal
+ * hugetlb entry or non-present (migration or hwpoisoned) hugetlb entry.
+ * Otherwise, returns 0.
+ */
 int pmd_huge(pmd_t pmd)
 {
-	return !!(pmd_val(pmd) & _PAGE_PSE);
+	return !pmd_none(pmd) &&
+		(pmd_val(pmd) & (_PAGE_PRESENT|_PAGE_PSE)) != _PAGE_PRESENT;
 }
 
 int pud_huge(pud_t pud)
diff --git mmotm-2014-11-26-15-45.orig/mm/hugetlb.c mmotm-2014-11-26-15-45/mm/hugetlb.c
index 6be4a690e554..dd42878549d5 100644
--- mmotm-2014-11-26-15-45.orig/mm/hugetlb.c
+++ mmotm-2014-11-26-15-45/mm/hugetlb.c
@@ -3679,6 +3679,8 @@ follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 {
 	struct page *page;
 
+	if (!pmd_present(*pmd))
+		return NULL;
 	page = pte_page(*(pte_t *)pmd);
 	if (page)
 		page += ((address & ~PMD_MASK) >> PAGE_SHIFT);
-- 
2.2.0.rc0.2.gf745acb
