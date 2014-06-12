Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaFLVtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 17:49:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbaFLVsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 17:48:43 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Dave Hansen <dave.hansen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org
Subject: [PATCH -mm v2 09/11] fs/proc/task_mmu.c: refactor smaps
Date: Thu, 12 Jun 2014 17:48:09 -0400
Message-Id: <1402609691-13950-10-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1402609691-13950-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1402609691-13950-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smaps_(pte|pmd)() are almost the same, so let's clean them up to a single
function.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 fs/proc/task_mmu.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git mmotm-2014-05-21-16-57.orig/fs/proc/task_mmu.c mmotm-2014-05-21-16-57/fs/proc/task_mmu.c
index a750d0842875..1f2eab58ae14 100644
--- mmotm-2014-05-21-16-57.orig/fs/proc/task_mmu.c
+++ mmotm-2014-05-21-16-57/fs/proc/task_mmu.c
@@ -437,7 +437,7 @@ struct mem_size_stats {
 	u64 pss;
 };
 
-static int smaps_pte(void *entry, unsigned long addr, unsigned long end,
+static int smaps_entry(void *entry, unsigned long addr, unsigned long end,
 			struct mm_walk *walk)
 {
 	pte_t *pte = entry;
@@ -490,15 +490,10 @@ static int smaps_pte(void *entry, unsigned long addr, unsigned long end,
 			mss->private_clean += ptent_size;
 		mss->pss += (ptent_size << PSS_SHIFT);
 	}
-	return 0;
-}
 
-static int smaps_pmd(void *entry, unsigned long addr, unsigned long end,
-			struct mm_walk *walk)
-{
-	struct mem_size_stats *mss = walk->private;
-	smaps_pte(entry, addr, end, walk);
-	mss->anonymous_thp += HPAGE_PMD_SIZE;
+	if (walk->size == PMD_SIZE)
+		mss->anonymous_thp += HPAGE_PMD_SIZE;
+
 	return 0;
 }
 
@@ -563,8 +558,8 @@ static int show_smap(struct seq_file *m, void *v, int is_pid)
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss;
 	struct mm_walk smaps_walk = {
-		.pmd_entry = smaps_pmd,
-		.pte_entry = smaps_pte,
+		.pmd_entry = smaps_entry,
+		.pte_entry = smaps_entry,
 		.mm = vma->vm_mm,
 		.vma = vma,
 		.private = &mss,
-- 
1.9.3

