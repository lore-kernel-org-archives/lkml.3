Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaKGHxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 02:53:36 -0500
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:52435 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaKGHxf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 02:53:35 -0500
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
Subject: [PATCH -mm v7 04/13] smaps: remove mem_size_stats->vma and use
 walk_page_vma()
Thread-Topic: [PATCH -mm v7 04/13] smaps: remove mem_size_stats->vma and use
 walk_page_vma()
Thread-Index: AQHP+li4vt3VQDfqCE2B8aDGVnyIsg==
Date: Fri, 7 Nov 2014 07:01:56 +0000
Message-ID: <1415343692-6314-5-git-send-email-n-horiguchi@ah.jp.nec.com>
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
walk->private. And show_smap() walks pages on vma basis, so using
walk_page_vma() is preferable.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 fs/proc/task_mmu.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git mmotm-2014-11-05-16-01.orig/fs/proc/task_mmu.c mmotm-2014-11-05-16-01/fs/proc/task_mmu.c
index 2ab200d429be..c1b937095625 100644
--- mmotm-2014-11-05-16-01.orig/fs/proc/task_mmu.c
+++ mmotm-2014-11-05-16-01/fs/proc/task_mmu.c
@@ -433,7 +433,6 @@ const struct file_operations proc_tid_maps_operations = {
 
 #ifdef CONFIG_PROC_PAGE_MONITOR
 struct mem_size_stats {
-	struct vm_area_struct *vma;
 	unsigned long resident;
 	unsigned long shared_clean;
 	unsigned long shared_dirty;
@@ -480,7 +479,7 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 		struct mm_walk *walk)
 {
 	struct mem_size_stats *mss = walk->private;
-	struct vm_area_struct *vma = mss->vma;
+	struct vm_area_struct *vma = walk->vma;
 	pgoff_t pgoff = linear_page_index(vma, addr);
 	struct page *page = NULL;
 
@@ -512,7 +511,7 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 		struct mm_walk *walk)
 {
 	struct mem_size_stats *mss = walk->private;
-	struct vm_area_struct *vma = mss->vma;
+	struct vm_area_struct *vma = walk->vma;
 	struct page *page;
 
 	/* FOLL_DUMP will return -EFAULT on huge zero page */
@@ -533,8 +532,7 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			   struct mm_walk *walk)
 {
-	struct mem_size_stats *mss = walk->private;
-	struct vm_area_struct *vma = mss->vma;
+	struct vm_area_struct *vma = walk->vma;
 	pte_t *pte;
 	spinlock_t *ptl;
 
@@ -624,10 +622,8 @@ static int show_smap(struct seq_file *m, void *v, int is_pid)
 	};
 
 	memset(&mss, 0, sizeof mss);
-	mss.vma = vma;
 	/* mmap_sem is held in m_start */
-	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
-		walk_page_range(vma->vm_start, vma->vm_end, &smaps_walk);
+	walk_page_vma(vma, &smaps_walk);
 
 	show_map_vma(m, vma, is_pid);
 
-- 
2.2.0.rc0.2.gf745acb
