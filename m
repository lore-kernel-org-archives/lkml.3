Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab3ITURX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:17:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41757 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223Ab3ITUPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:15:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Libin <huawei.libin@huawei.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 91/93] mm/huge_memory.c: fix potential NULL pointer dereference
Date: Fri, 20 Sep 2013 13:09:26 -0700
Message-Id: <1379707768-1804-92-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Libin <huawei.libin@huawei.com>

commit a8f531ebc33052642b4bd7b812eedf397108ce64 upstream.

In collapse_huge_page() there is a race window between releasing the
mmap_sem read lock and taking the mmap_sem write lock, so find_vma() may
return NULL.  So check the return value to avoid NULL pointer dereference.

collapse_huge_page
	khugepaged_alloc_page
		up_read(&mm->mmap_sem)
	down_write(&mm->mmap_sem)
	vma = find_vma(mm, address)

Signed-off-by: Libin <huawei.libin@huawei.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/huge_memory.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9459edd..e9308d3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2327,6 +2327,8 @@ static void collapse_huge_page(struct mm_struct *mm,
 		goto out;
 
 	vma = find_vma(mm, address);
+	if (!vma)
+		goto out;
 	hstart = (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
 	hend = vma->vm_end & HPAGE_PMD_MASK;
 	if (address < hstart || address + HPAGE_PMD_SIZE > hend)
-- 
1.8.1.2

