Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087Ab3DARWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:22:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756702Ab3DARWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:22:38 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2 1/2] hugetlbfs: stop setting VM_DONTDUMP in initializing vma(VM_HUGETLB)
Date: Mon,  1 Apr 2013 13:21:21 -0400
Message-Id: <1364836882-9713-2-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1364836882-9713-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1364836882-9713-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we fail to include any data on hugepages into coredump,
because VM_DONTDUMP is set on hugetlbfs's vma. This behavior was recently
introduced by commit 314e51b98 "mm: kill vma flag VM_RESERVED and
mm->reserved_vm counter". This looks to me a serious regression,
so let's fix it.

ChangeLog v2:
 - add 'return 0' in hugepage memory check

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: stable@vger.kernel.org
---
 fs/binfmt_elf.c      | 1 +
 fs/hugetlbfs/inode.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git v3.9-rc3.orig/fs/binfmt_elf.c v3.9-rc3/fs/binfmt_elf.c
index 3939829..86af964 100644
--- v3.9-rc3.orig/fs/binfmt_elf.c
+++ v3.9-rc3/fs/binfmt_elf.c
@@ -1137,6 +1137,7 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
 			goto whole;
 		if (!(vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_PRIVATE))
 			goto whole;
+		return 0;
 	}
 
 	/* Do not dump I/O mapped devices or special mappings */
diff --git v3.9-rc3.orig/fs/hugetlbfs/inode.c v3.9-rc3/fs/hugetlbfs/inode.c
index 84e3d85..523464e 100644
--- v3.9-rc3.orig/fs/hugetlbfs/inode.c
+++ v3.9-rc3/fs/hugetlbfs/inode.c
@@ -110,7 +110,7 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	 * way when do_mmap_pgoff unwinds (may be important on powerpc
 	 * and ia64).
 	 */
-	vma->vm_flags |= VM_HUGETLB | VM_DONTEXPAND | VM_DONTDUMP;
+	vma->vm_flags |= VM_HUGETLB | VM_DONTEXPAND;
 	vma->vm_ops = &hugetlb_vm_ops;
 
 	if (vma->vm_pgoff & (~huge_page_mask(h) >> PAGE_SHIFT))
-- 
1.7.11.7

