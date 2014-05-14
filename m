Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987AbaEMJlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:41:20 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:53753 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932570AbaEMJlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:41:08 -0400
Date: Wed, 14 May 2014 11:29:48 +0200
From: Anthony Iliopoulos <anthony.iliopoulos@huawei.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave@sr71.net>, Shay Goikhman <shay.goikhman@huawei.com>,
        Paul Mundt <paul.mundt@huawei.com>,
        "Carlos Villavieja" <villavieja@hps.utexas.edu>,
        Nacho Navarro <nacho.navarro@bsc.es>,
        Avi Mendelson <avi.mendelson@tce.technion.ac.il>,
        Yoav Etsion <yetsion@tce.technion.ac.il>
Subject: [PATCH] x86, hugetlb: add missing TLB page invalidation for
 hugetlb_cow()
Message-ID: <20140514092948.GA17391@server-36.huawei.corp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [10.220.139.36]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Suggested-by: Shay Goikhman <shay.goikhman@huawei.com>
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
1.8.1.2
