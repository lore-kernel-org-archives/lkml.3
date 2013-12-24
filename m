Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab3LXByk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 20:54:40 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:42675 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3LXByi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 20:54:38 -0500
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Sasha Levin <sasha.levin@oracle.com>, Dave Jones <davej@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH] mm/thp: fix vmas tear down race with thp splitting
Date: Tue, 24 Dec 2013 09:54:19 +0800
Message-Id: <1387850059-18525-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13122401-5564-0000-0000-00000B3F2620
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha reports unmap_page_range tears down pmd range which is race with thp 
splitting during page reclaim. Transparent huge page will be splitting 
during page reclaim. However, split pmd lock which held by __split_trans_huge_lock
can't prevent __split_huge_page_refcount running in parallel. This patch fix 
it by hold compound lock to check if __split_huge_page_refcount is running 
underneath, in that case zap huge pmd range should be fallback.

[  265.474585] kernel BUG at mm/huge_memory.c:1440!
[  265.475129] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  265.476684] Dumping ftrace buffer:
[  265.477144]    (ftrace buffer empty)
[  265.478398] Modules linked in:
[  265.478807] CPU: 8 PID: 11344 Comm: trinity-c206 Tainted: G        W    3.13.0-rc5-next-20131223-sasha-00015-gec22156-dirty #8
[  265.480172] task: ffff8801cb573000 ti: ffff8801cbd3a000 task.ti: ffff8801cbd3a000
[  265.480172] RIP: 0010:[<ffffffff812c7f70>]  [<ffffffff812c7f70>] zap_huge_pmd+0x170/0x1f0
[  265.480172] RSP: 0000:ffff8801cbd3bc78  EFLAGS: 00010246
[  265.480172] RAX: 015fffff80090018 RBX: ffff8801cbd3bde8 RCX: ffffffffffffff9c
[  265.480172] RDX: ffffffffffffffff RSI: 0000000000000008 RDI: ffff8800bffd2000
[  265.480172] RBP: ffff8801cbd3bcb8 R08: 0000000000000000 R09: 0000000000000000
[  265.480172] R10: 0000000000000001 R11: 0000000000000000 R12: ffffea0002856740
[  265.480172] R13: ffffea0002d50000 R14: 00007ff915000000 R15: 00007ff930e48fff
[  265.480172] FS:  00007ff934899700(0000) GS:ffff88014d400000(0000) knlGS:0000000000000000
[  265.480172] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  265.480172] CR2: 00007ff93428a000 CR3: 000000010babe000 CR4: 00000000000006e0
[  265.480172] Stack:
[  265.480172]  00000000000004dd ffff8801ccbfbb60 ffff8801cbd3bcb8 ffff8801cbb15540
[  265.480172]  00007ff915000000 00007ff930e49000 ffff8801cbd3bde8 00007ff930e48fff
[  265.480172]  ffff8801cbd3bd48 ffffffff812885b6 ffff88005f5d20c0 00007ff915200000
[  265.480172] Call Trace:
[  265.480172]  [<ffffffff812885b6>] unmap_page_range+0x2c6/0x410
[  265.480172]  [<ffffffff81288801>] unmap_single_vma+0x101/0x120
[  265.480172]  [<ffffffff81288881>] unmap_vmas+0x61/0xa0
[  265.480172]  [<ffffffff8128f730>] exit_mmap+0xd0/0x170
[  265.480172]  [<ffffffff81138860>] mmput+0x70/0xe0
[  265.480172]  [<ffffffff8113c89d>] exit_mm+0x18d/0x1a0
[  265.480172]  [<ffffffff811ea355>] ? acct_collect+0x175/0x1b0
[  265.480172]  [<ffffffff8113ed0f>] do_exit+0x26f/0x520
[  265.480172]  [<ffffffff8113f069>] do_group_exit+0xa9/0xe0
[  265.480172]  [<ffffffff8113f0b7>] SyS_exit_group+0x17/0x20
[  265.480172]  [<ffffffff845f10d0>] tracesys+0xdd/0xe2
[  265.480172] Code: 0f 0b 66 0f 1f 84 00 00 00 00 00 eb fe 66 0f 1f
44 00 00 48 8b 03 f0 48 81 80 50 03 00 00 00 fe ff ff 49 8b 45 00 f6
c4 40 75 10 <0f> 0b 66 0f 1f 44 00 00 eb fe 66 0f 1f 44 00 00 48 8b 03
f0 48
[  265.480172] RIP  [<ffffffff812c7f70>] zap_huge_pmd+0x170/0x1f0
[  265.480172]  RSP <ffff8801cbd3bc78>

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/huge_memory.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7de1bf8..d1e0c80 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1414,6 +1414,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 {
 	spinlock_t *ptl;
 	int ret = 0;
+	unsigned long flags;
 
 	if (__pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
 		struct page *page;
@@ -1426,6 +1427,15 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 * operations.
 		 */
 		orig_pmd = pmdp_get_and_clear(tlb->mm, addr, pmd);
+		page = pmd_page(orig_pmd);
+		flags = compound_lock_irqsave(page);
+		if (unlikely(!PageHead(page))) {
+			/*
+			 * __split_huge_page_refcount run before us
+			 */
+			compound_unlock_irqrestore(page, flags);
+			return ret;
+		}
 		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 		pgtable = pgtable_trans_huge_withdraw(tlb->mm, pmd);
 		if (is_huge_zero_pmd(orig_pmd)) {
@@ -1433,7 +1443,6 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			spin_unlock(ptl);
 			put_huge_zero_page();
 		} else {
-			page = pmd_page(orig_pmd);
 			page_remove_rmap(page);
 			VM_BUG_ON(page_mapcount(page) < 0);
 			add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
@@ -1442,6 +1451,8 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			spin_unlock(ptl);
 			tlb_remove_page(tlb, page);
 		}
+		compound_unlock_irqrestore(page, flags);
+
 		pte_free(tlb->mm, pgtable);
 		ret = 1;
 	}
-- 
1.8.3.2

