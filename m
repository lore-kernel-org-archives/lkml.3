Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934331Ab3AOW5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:57:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:48290 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934301Ab3AOW46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:56:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 40/71] thp, memcg: split hugepage for memcg oom on cow
Date: Tue, 15 Jan 2013 14:54:37 -0800
Message-Id: <20130115225343.315337142@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115225340.367496998@linuxfoundation.org>
References: <20130115225340.367496998@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rientjes <rientjes@google.com>

commit 1f1d06c34f7675026326cd9f39ff91e4555cf355 upstream.

On COW, a new hugepage is allocated and charged to the memcg.  If the
system is oom or the charge to the memcg fails, however, the fault
handler will return VM_FAULT_OOM which results in an oom kill.

Instead, it's possible to fallback to splitting the hugepage so that the
COW results only in an order-0 page being allocated and charged to the
memcg which has a higher liklihood to succeed.  This is expensive
because the hugepage must be split in the page fault handler, but it is
much better than unnecessarily oom killing a process.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/huge_memory.c |    3 +++
 mm/memory.c      |   18 +++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -920,6 +920,8 @@ int do_huge_pmd_wp_page(struct mm_struct
 		count_vm_event(THP_FAULT_FALLBACK);
 		ret = do_huge_pmd_wp_page_fallback(mm, vma, address,
 						   pmd, orig_pmd, page, haddr);
+		if (ret & VM_FAULT_OOM)
+			split_huge_page(page);
 		put_page(page);
 		goto out;
 	}
@@ -927,6 +929,7 @@ int do_huge_pmd_wp_page(struct mm_struct
 
 	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
 		put_page(new_page);
+		split_huge_page(page);
 		put_page(page);
 		ret |= VM_FAULT_OOM;
 		goto out;
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3470,6 +3470,7 @@ int handle_mm_fault(struct mm_struct *mm
 	if (unlikely(is_vm_hugetlb_page(vma)))
 		return hugetlb_fault(mm, vma, address, flags);
 
+retry:
 	pgd = pgd_offset(mm, address);
 	pud = pud_alloc(mm, pgd, address);
 	if (!pud)
@@ -3483,13 +3484,24 @@ int handle_mm_fault(struct mm_struct *mm
 							  pmd, flags);
 	} else {
 		pmd_t orig_pmd = *pmd;
+		int ret;
+
 		barrier();
 		if (pmd_trans_huge(orig_pmd)) {
 			if (flags & FAULT_FLAG_WRITE &&
 			    !pmd_write(orig_pmd) &&
-			    !pmd_trans_splitting(orig_pmd))
-				return do_huge_pmd_wp_page(mm, vma, address,
-							   pmd, orig_pmd);
+			    !pmd_trans_splitting(orig_pmd)) {
+				ret = do_huge_pmd_wp_page(mm, vma, address, pmd,
+							  orig_pmd);
+				/*
+				 * If COW results in an oom, the huge pmd will
+				 * have been split, so retry the fault on the
+				 * pte for a smaller charge.
+				 */
+				if (unlikely(ret & VM_FAULT_OOM))
+					goto retry;
+				return ret;
+			}
 			return 0;
 		}
 	}


