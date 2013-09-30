Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab3I3KR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:17:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43802 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab3I3KNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Libin <huawei.libin@huawei.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 091/104] mm/huge_memory.c: fix potential NULL pointer dereference
Date: Mon, 30 Sep 2013 11:11:08 +0100
Message-Id: <1380535881-9239-92-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/huge_memory.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7d0eb9e..613d436 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1900,6 +1900,8 @@ static void collapse_huge_page(struct mm_struct *mm,
 		goto out;
 
 	vma = find_vma(mm, address);
+	if (!vma)
+		goto out;
 	hstart = (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
 	hend = vma->vm_end & HPAGE_PMD_MASK;
 	if (address < hstart || address + HPAGE_PMD_SIZE > hend)
-- 
1.8.3.2

