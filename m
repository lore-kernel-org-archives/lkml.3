Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918AbaCDUux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:50:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813AbaCDUEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.13 155/172] mm, thp: fix infinite loop on memcg OOM
Date: Tue,  4 Mar 2014 12:03:59 -0800
Message-Id: <20140304200304.677351959@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

commit 9845cbbd113fbb5b769a45d8e88dc47bc12df4e0 upstream.

Masayoshi Mizuma reported a bug with the hang of an application under
the memcg limit.  It happens on write-protection fault to huge zero page

If we successfully allocate a huge page to replace zero page but hit the
memcg limit we need to split the zero page with split_huge_page_pmd()
and fallback to small pages.

The other part of the problem is that VM_FAULT_OOM has special meaning
in do_huge_pmd_wp_page() context.  __handle_mm_fault() expects the page
to be split if it sees VM_FAULT_OOM and it will will retry page fault
handling.  This causes an infinite loop if the page was not split.

do_huge_pmd_wp_zero_page_fallback() can return VM_FAULT_OOM if it failed
to allocate one small page, so fallback to small pages will not help.

The solution for this part is to replace VM_FAULT_OOM with
VM_FAULT_FALLBACK is fallback required.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/huge_memory.c |    9 ++++++---
 mm/memory.c      |   14 +++-----------
 2 files changed, 9 insertions(+), 14 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1160,8 +1160,10 @@ alloc:
 		} else {
 			ret = do_huge_pmd_wp_page_fallback(mm, vma, address,
 					pmd, orig_pmd, page, haddr);
-			if (ret & VM_FAULT_OOM)
+			if (ret & VM_FAULT_OOM) {
 				split_huge_page(page);
+				ret |= VM_FAULT_FALLBACK;
+			}
 			put_page(page);
 		}
 		count_vm_event(THP_FAULT_FALLBACK);
@@ -1173,9 +1175,10 @@ alloc:
 		if (page) {
 			split_huge_page(page);
 			put_page(page);
-		}
+		} else
+			split_huge_page_pmd(vma, address, pmd);
+		ret |= VM_FAULT_FALLBACK;
 		count_vm_event(THP_FAULT_FALLBACK);
-		ret |= VM_FAULT_OOM;
 		goto out;
 	}
 
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3700,7 +3700,6 @@ static int __handle_mm_fault(struct mm_s
 	if (unlikely(is_vm_hugetlb_page(vma)))
 		return hugetlb_fault(mm, vma, address, flags);
 
-retry:
 	pgd = pgd_offset(mm, address);
 	pud = pud_alloc(mm, pgd, address);
 	if (!pud)
@@ -3738,20 +3737,13 @@ retry:
 			if (dirty && !pmd_write(orig_pmd)) {
 				ret = do_huge_pmd_wp_page(mm, vma, address, pmd,
 							  orig_pmd);
-				/*
-				 * If COW results in an oom, the huge pmd will
-				 * have been split, so retry the fault on the
-				 * pte for a smaller charge.
-				 */
-				if (unlikely(ret & VM_FAULT_OOM))
-					goto retry;
-				return ret;
+				if (!(ret & VM_FAULT_FALLBACK))
+					return ret;
 			} else {
 				huge_pmd_set_accessed(mm, vma, address, pmd,
 						      orig_pmd, dirty);
+				return 0;
 			}
-
-			return 0;
 		}
 	}
 


