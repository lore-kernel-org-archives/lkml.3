Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbaENDgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 23:36:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33106 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbaENDgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 23:36:20 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-mm@kvack.org
Cc: kirill.shutemov@linux.intel.com, davej@redhat.com,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        peterz@infradead.org, mingo@kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] mm: remap_file_pages: grab file ref to prevent race while mmaping
Date: Tue, 13 May 2014 23:35:42 -0400
Message-Id: <1400038542-9705-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A file reference should be held while a file is mmaped, otherwise it might
be freed while being used.

Suggested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 mm/mmap.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/mmap.c b/mm/mmap.c
index 2a0e0a8..da3c212 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2593,6 +2593,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 	struct vm_area_struct *vma;
 	unsigned long populate = 0;
 	unsigned long ret = -EINVAL;
+	struct file *file;
 
 	pr_warn_once("%s (%d) uses deprecated remap_file_pages() syscall. "
 			"See Documentation/vm/remap_file_pages.txt.\n",
@@ -2636,8 +2637,10 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 		munlock_vma_pages_range(vma, start, start + size);
 	}
 
+	file = get_file(vma->vm_file);
 	ret = do_mmap_pgoff(vma->vm_file, start, size,
 			prot, flags, pgoff, &populate);
+	fput(file);
 out:
 	up_write(&mm->mmap_sem);
 	if (populate)
-- 
1.7.10.4

