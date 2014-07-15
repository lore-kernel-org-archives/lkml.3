Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbaGOJ40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:56:26 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:61871 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758190AbaGOJ4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:56:23 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-6d-53c4faa17ee1
Subject: [PATCH] mm: fix faulting range in do_fault_around
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
To: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Korb <ingo.korb@tu-dortmund.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ning Qu <quning@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Date: Tue, 15 Jul 2014 13:55:39 +0400
Message-id: <20140715095539.2086.44482.stgit@buzz>
In-reply-to: <CALYGNiM9Fu9-i7hXMQNTUP69RfydN+2NqO29wZYd+4Gn25GbCQ@mail.gmail.com>
References: <CALYGNiM9Fu9-i7hXMQNTUP69RfydN+2NqO29wZYd+4Gn25GbCQ@mail.gmail.com>
User-Agent: StGit/0.17.1-dirty
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t/xa7oLfx0JNtj839Bizvo1bBZbrjcx
	WTz91Mdi0fKnk83ix85eVoubz+ewWKzsfMBqcXnXHDaLe2v+s1pc3zSPxWLxkdvMDtweO2fd
	ZfdYsKnUY9OnSeweJ2b8ZvGYdzLQ4+PTWywe7/ddZfPo27KK0aPxXC+zx+dNcgFcUVw2Kak5
	mWWpRfp2CVwZbafmMxfsFai48GECewPjYt4uRg4OCQETidlnErsYOYFMMYkL99azdTFycQgJ
	LGWUWH9uOzuE08gkcfPICxaQKmEBK4lvV1YwgdhsAmYS2/bdZgSxRQRqJXoeHGQEaWAW+M4o
	8fHHJ7AGFgFViTmTu9lAbF4BI4nzf9+xgticAsES3y90gQ0SEgiQ6LjZAGaLCshJrLzcwgpR
	LyjxY/I9FpBLmQXUJaZMyQUJMwvIS2xe85Z5AqPALCRVsxCqZiGpWsDIvIpRNLU0uaA4KT3X
	UK84Mbe4NC9dLzk/dxMjJHK+7GBcfMzqEKMAB6MSD2+F2OFgIdbEsuLK3EOMEhzMSiK8tz8d
	CRbiTUmsrEotyo8vKs1JLT7EyMTBKdXAaMX1ZJFd7+fHnzQjExonqTF6TNEX8b2/6sJPxR0X
	rE7ei3kT0MjV53P3vE2FSsX041urKjxyGjaast66w/zPtu/4g+8BB798E7fd9+db73TBZYmL
	Y26vO5kzdarDxeOSp9/6fVMtbll7sa7gUGfE+VWBAjdtvl4J3mR45eFT07nsPCfvnbL32qjE
	UpyRaKjFXFScCAAsLvxZegIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Khlebnikov <koct9i@gmail.com>

do_fault_around shoudn't cross pmd boundaries.

This patch does calculation in terms of addresses rather than pgoff.
It looks much cleaner in this way. Probably it's worth to replace
vmf->max_pgoff with vmf->end_address as well.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Reported-by: "Ingo Korb" <ingo.korb@tu-dortmund.de>
---
 mm/memory.c |   26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index d67fd9f..f27638a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2831,33 +2831,29 @@ late_initcall(fault_around_debugfs);
 static void do_fault_around(struct vm_area_struct *vma, unsigned long address,
 		pte_t *pte, pgoff_t pgoff, unsigned int flags)
 {
-	unsigned long start_addr;
+	unsigned long start_addr, end_addr;
 	pgoff_t max_pgoff;
 	struct vm_fault vmf;
 	int off;
 
-	start_addr = max(address & fault_around_mask(), vma->vm_start);
-	off = ((address - start_addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
+	start_addr = max3(vma->vm_start, address & PMD_MASK,
+			  address & fault_around_mask());
+
+	end_addr = min3(vma->vm_end, ALIGN(address, PMD_SIZE),
+			start_addr + PAGE_ALIGN(fault_around_bytes));
+
+	off = (address - start_addr) >> PAGE_SHIFT;
 	pte -= off;
 	pgoff -= off;
-
-	/*
-	 *  max_pgoff is either end of page table or end of vma
-	 *  or fault_around_pages() from pgoff, depending what is nearest.
-	 */
-	max_pgoff = pgoff - ((start_addr >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)) +
-		PTRS_PER_PTE - 1;
-	max_pgoff = min3(max_pgoff, vma_pages(vma) + vma->vm_pgoff - 1,
-			pgoff + fault_around_pages() - 1);
+	max_pgoff = pgoff + ((end_addr - start_addr) >> PAGE_SHIFT) - 1;
 
 	/* Check if it makes any sense to call ->map_pages */
 	while (!pte_none(*pte)) {
-		if (++pgoff > max_pgoff)
-			return;
 		start_addr += PAGE_SIZE;
-		if (start_addr >= vma->vm_end)
+		if (start_addr >= end_addr)
 			return;
 		pte++;
+		pgoff++;
 	}
 
 	vmf.virtual_address = (void __user *) start_addr;

