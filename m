Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967553AbaFQWJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:09:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54674 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966935AbaFQVvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:51:53 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anthony Iliopoulos <anthony.iliopoulos@huawei.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 116/212] x86, mm, hugetlb: Add missing TLB page invalidation for hugetlb_cow()
Date: Tue, 17 Jun 2014 14:43:30 -0700
Message-Id: <1403041506-13646-117-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Iliopoulos <anthony.iliopoulos@huawei.com>

commit 9844f5462392b53824e8b86726e7c33b5ecbb676 upstream.

The invalidation is required in order to maintain proper semantics
under CoW conditions. In scenarios where a process clones several
threads, a thread operating on a core whose DTLB entry for a
particular hugepage has not been invalidated, will be reading from
the hugepage that belongs to the forked child process, even after
hugetlb_cow().

The thread will not see the updated page as long as the stale DTLB
entry remains cached, the thread attempts to write into the page,
the child process exits, or the thread gets migrated to a different
processor.

Signed-off-by: Anthony Iliopoulos <anthony.iliopoulos@huawei.com>
Link: http://lkml.kernel.org/r/20140514092948.GA17391@server-36.huawei.corp
Suggested-by: Shay Goikhman <shay.goikhman@huawei.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/include/asm/hugetlb.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/hugetlb.h b/arch/x86/include/asm/hugetlb.h
index a809121..68c0539 100644
--- a/arch/x86/include/asm/hugetlb.h
+++ b/arch/x86/include/asm/hugetlb.h
@@ -52,6 +52,7 @@ static inline pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
 static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
 					 unsigned long addr, pte_t *ptep)
 {
+	ptep_clear_flush(vma, addr, ptep);
 }
 
 static inline int huge_pte_none(pte_t pte)
-- 
1.9.1

