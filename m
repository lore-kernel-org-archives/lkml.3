Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934391AbaFTUMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:12:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805AbaFTUMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:12:05 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [PATCH v3 04/13] smaps: remove mem_size_stats->vma and use walk_page_vma()
Date: Fri, 20 Jun 2014 16:11:30 -0400
Message-Id: <1403295099-6407-5-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1403295099-6407-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1403295099-6407-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pagewalk.c can handle vma in itself, so we don't have to pass vma via
walk->private. And show_smap() walks pages on vma basis, so using
walk_page_vma() is preferable.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 fs/proc/task_mmu.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git v3.16-rc1.orig/fs/proc/task_mmu.c v3.16-rc1/fs/proc/task_mmu.c
index cfa63ee92c96..9b6c7d4fd3f4 100644
--- v3.16-rc1.orig/fs/proc/task_mmu.c
+++ v3.16-rc1/fs/proc/task_mmu.c
@@ -430,7 +430,6 @@ const struct file_operations proc_tid_maps_operations = {
 
 #ifdef CONFIG_PROC_PAGE_MONITOR
 struct mem_size_stats {
-	struct vm_area_struct *vma;
 	unsigned long resident;
 	unsigned long shared_clean;
 	unsigned long shared_dirty;
@@ -449,7 +448,7 @@ static void smaps_pte_entry(pte_t ptent, unsigned long addr,
 		unsigned long ptent_size, struct mm_walk *walk)
 {
 	struct mem_size_stats *mss = walk->private;
-	struct vm_area_struct *vma = mss->vma;
+	struct vm_area_struct *vma = walk->vma;
 	pgoff_t pgoff = linear_page_index(vma, addr);
 	struct page *page = NULL;
 	int mapcount;
@@ -501,7 +500,7 @@ static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			   struct mm_walk *walk)
 {
 	struct mem_size_stats *mss = walk->private;
-	struct vm_area_struct *vma = mss->vma;
+	struct vm_area_struct *vma = walk->vma;
 	pte_t *pte;
 	spinlock_t *ptl;
 
@@ -590,14 +589,13 @@ static int show_smap(struct seq_file *m, void *v, int is_pid)
 	struct mm_walk smaps_walk = {
 		.pmd_entry = smaps_pte_range,
 		.mm = vma->vm_mm,
+		.vma = vma,
 		.private = &mss,
 	};
 
 	memset(&mss, 0, sizeof mss);
-	mss.vma = vma;
 	/* mmap_sem is held in m_start */
-	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
-		walk_page_range(vma->vm_start, vma->vm_end, &smaps_walk);
+	walk_page_vma(vma, &smaps_walk);
 
 	show_map_vma(m, vma, is_pid);
 
-- 
1.9.3

