Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbaHAUTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 16:19:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755872AbaHAUTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 16:19:14 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Jerome Marchand <jmarchan@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [PATCH -mm v6 09/13] memcg: cleanup preparation for page table walk
Date: Fri,  1 Aug 2014 15:20:45 -0400
Message-Id: <1406920849-25908-10-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1406920849-25908-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1406920849-25908-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pagewalk.c can handle vma in itself, so we don't have to pass vma via
walk->private. And both of mem_cgroup_count_precharge() and
mem_cgroup_move_charge() do for each vma loop themselves, but now it's
done in pagewalk.c, so let's clean up them.

ChangeLog v4:
- use walk_page_range() instead of walk_page_vma() with for loop.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 mm/memcontrol.c | 49 ++++++++++++++++---------------------------------
 1 file changed, 16 insertions(+), 33 deletions(-)

diff --git mmotm-2014-07-30-15-57.orig/mm/memcontrol.c mmotm-2014-07-30-15-57/mm/memcontrol.c
index dc35886a1c89..e8b44a50ef1a 100644
--- mmotm-2014-07-30-15-57.orig/mm/memcontrol.c
+++ mmotm-2014-07-30-15-57/mm/memcontrol.c
@@ -5876,7 +5876,7 @@ static int mem_cgroup_count_precharge_pte_range(pmd_t *pmd,
 					unsigned long addr, unsigned long end,
 					struct mm_walk *walk)
 {
-	struct vm_area_struct *vma = walk->private;
+	struct vm_area_struct *vma = walk->vma;
 	pte_t *pte;
 	spinlock_t *ptl;
 
@@ -5902,20 +5902,13 @@ static int mem_cgroup_count_precharge_pte_range(pmd_t *pmd,
 static unsigned long mem_cgroup_count_precharge(struct mm_struct *mm)
 {
 	unsigned long precharge;
-	struct vm_area_struct *vma;
 
+	struct mm_walk mem_cgroup_count_precharge_walk = {
+		.pmd_entry = mem_cgroup_count_precharge_pte_range,
+		.mm = mm,
+	};
 	down_read(&mm->mmap_sem);
-	for (vma = mm->mmap; vma; vma = vma->vm_next) {
-		struct mm_walk mem_cgroup_count_precharge_walk = {
-			.pmd_entry = mem_cgroup_count_precharge_pte_range,
-			.mm = mm,
-			.private = vma,
-		};
-		if (is_vm_hugetlb_page(vma))
-			continue;
-		walk_page_range(vma->vm_start, vma->vm_end,
-					&mem_cgroup_count_precharge_walk);
-	}
+	walk_page_range(0, ~0UL, &mem_cgroup_count_precharge_walk);
 	up_read(&mm->mmap_sem);
 
 	precharge = mc.precharge;
@@ -6051,7 +6044,7 @@ static int mem_cgroup_move_charge_pte_range(pmd_t *pmd,
 				struct mm_walk *walk)
 {
 	int ret = 0;
-	struct vm_area_struct *vma = walk->private;
+	struct vm_area_struct *vma = walk->vma;
 	pte_t *pte;
 	spinlock_t *ptl;
 	enum mc_target_type target_type;
@@ -6151,7 +6144,10 @@ put:			/* get_mctgt_type() gets the page */
 
 static void mem_cgroup_move_charge(struct mm_struct *mm)
 {
-	struct vm_area_struct *vma;
+	struct mm_walk mem_cgroup_move_charge_walk = {
+		.pmd_entry = mem_cgroup_move_charge_pte_range,
+		.mm = mm,
+	};
 
 	lru_add_drain_all();
 retry:
@@ -6167,24 +6163,11 @@ static void mem_cgroup_move_charge(struct mm_struct *mm)
 		cond_resched();
 		goto retry;
 	}
-	for (vma = mm->mmap; vma; vma = vma->vm_next) {
-		int ret;
-		struct mm_walk mem_cgroup_move_charge_walk = {
-			.pmd_entry = mem_cgroup_move_charge_pte_range,
-			.mm = mm,
-			.private = vma,
-		};
-		if (is_vm_hugetlb_page(vma))
-			continue;
-		ret = walk_page_range(vma->vm_start, vma->vm_end,
-						&mem_cgroup_move_charge_walk);
-		if (ret)
-			/*
-			 * means we have consumed all precharges and failed in
-			 * doing additional charge. Just abandon here.
-			 */
-			break;
-	}
+	/*
+	 * When we have consumed all precharges and failed in doing
+	 * additional charge, the page walk just aborts.
+	 */
+	walk_page_range(0, ~0UL, &mem_cgroup_move_charge_walk);
 	up_read(&mm->mmap_sem);
 }
 
-- 
1.9.3

