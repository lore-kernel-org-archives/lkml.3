Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617Ab3IYBly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:41:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab3IYAIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:08:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Libin <huawei.libin@huawei.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 24/28] mm/huge_memory.c: fix potential NULL pointer dereference
Date: Tue, 24 Sep 2013 17:07:55 -0700
Message-Id: <20130925000654.152727471@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925000648.404447782@linuxfoundation.org>
References: <20130925000648.404447782@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/huge_memory.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1838,6 +1838,8 @@ static void collapse_huge_page(struct mm
 		goto out;
 
 	vma = find_vma(mm, address);
+	if (!vma)
+		goto out;
 	hstart = (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
 	hend = vma->vm_end & HPAGE_PMD_MASK;
 	if (address < hstart || address + HPAGE_PMD_SIZE > hend)


