Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbaKGIJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 03:09:49 -0500
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:53990 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaKGIJn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 03:09:43 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Feiner <pfeiner@google.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH -mm v7 08/13] numa_maps: remove numa_maps->vma
Thread-Topic: [PATCH -mm v7 08/13] numa_maps: remove numa_maps->vma
Thread-Index: AQHP+li6oIB49sysf0CtVi9lUPKweg==
Date: Fri, 7 Nov 2014 07:02:00 +0000
Message-ID: <1415343692-6314-9-git-send-email-n-horiguchi@ah.jp.nec.com>
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

pagewalk.c can handle vma in itself, so we don't have to pass vma via
walk->private. And show_numa_map() walks pages on vma basis, so using
walk_page_vma() is preferable.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 fs/proc/task_mmu.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git mmotm-2014-11-05-16-01.orig/fs/proc/task_mmu.c mmotm-2014-11-05-16-01/fs/proc/task_mmu.c
index bddae83fbf39..e7d86b97598b 100644
--- mmotm-2014-11-05-16-01.orig/fs/proc/task_mmu.c
+++ mmotm-2014-11-05-16-01/fs/proc/task_mmu.c
@@ -1290,7 +1290,6 @@ const struct file_operations proc_pagemap_operations = {
 #ifdef CONFIG_NUMA
 
 struct numa_maps {
-	struct vm_area_struct *vma;
 	unsigned long pages;
 	unsigned long anon;
 	unsigned long active;
@@ -1359,18 +1358,17 @@ static struct page *can_gather_numa_stats(pte_t pte, struct vm_area_struct *vma,
 static int gather_pte_stats(pmd_t *pmd, unsigned long addr,
 		unsigned long end, struct mm_walk *walk)
 {
-	struct numa_maps *md;
+	struct numa_maps *md = walk->private;
+	struct vm_area_struct *vma = walk->vma;
 	spinlock_t *ptl;
 	pte_t *orig_pte;
 	pte_t *pte;
 
-	md = walk->private;
-
-	if (pmd_trans_huge_lock(pmd, md->vma, &ptl) == 1) {
+	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
 		pte_t huge_pte = *(pte_t *)pmd;
 		struct page *page;
 
-		page = can_gather_numa_stats(huge_pte, md->vma, addr);
+		page = can_gather_numa_stats(huge_pte, vma, addr);
 		if (page)
 			gather_stats(page, md, pte_dirty(huge_pte),
 				     HPAGE_PMD_SIZE/PAGE_SIZE);
@@ -1382,7 +1380,7 @@ static int gather_pte_stats(pmd_t *pmd, unsigned long addr,
 		return 0;
 	orig_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
 	do {
-		struct page *page = can_gather_numa_stats(*pte, md->vma, addr);
+		struct page *page = can_gather_numa_stats(*pte, vma, addr);
 		if (!page)
 			continue;
 		gather_stats(page, md, pte_dirty(*pte), 1);
@@ -1429,7 +1427,12 @@ static int show_numa_map(struct seq_file *m, void *v, int is_pid)
 	struct numa_maps *md = &numa_priv->md;
 	struct file *file = vma->vm_file;
 	struct mm_struct *mm = vma->vm_mm;
-	struct mm_walk walk = {};
+	struct mm_walk walk = {
+		.hugetlb_entry = gather_hugetlb_stats,
+		.pmd_entry = gather_pte_stats,
+		.private = md,
+		.mm = mm,
+	};
 	struct mempolicy *pol;
 	char buffer[64];
 	int nid;
@@ -1440,13 +1443,6 @@ static int show_numa_map(struct seq_file *m, void *v, int is_pid)
 	/* Ensure we start with an empty set of numa_maps statistics. */
 	memset(md, 0, sizeof(*md));
 
-	md->vma = vma;
-
-	walk.hugetlb_entry = gather_hugetlb_stats;
-	walk.pmd_entry = gather_pte_stats;
-	walk.private = md;
-	walk.mm = mm;
-
 	pol = __get_vma_policy(vma, vma->vm_start);
 	if (pol) {
 		mpol_to_str(buffer, sizeof(buffer), pol);
@@ -1480,7 +1476,8 @@ static int show_numa_map(struct seq_file *m, void *v, int is_pid)
 	if (is_vm_hugetlb_page(vma))
 		seq_puts(m, " huge");
 
-	walk_page_range(vma->vm_start, vma->vm_end, &walk);
+	/* mmap_sem is held by m_start */
+	walk_page_vma(vma, &walk);
 
 	if (!md->pages)
 		goto out;
-- 
2.2.0.rc0.2.gf745acb
