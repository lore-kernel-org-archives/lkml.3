Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251AbaBEUnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:43:40 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48312 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbaBEUGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:25 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andy Lutomirski <luto@amacapital.net>, Hugh Dickins <hugh@veritas.com>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Badari Pulavarty <pbadari@us.ibm.com>, Nick Piggin <npiggin@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 105/213] mm: Hold a file reference in madvise_remove
Date: Wed, 5 Feb 2014 15:01:00 -0500
Message-ID: <1391630568-49251-106-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <luto@amacapital.net>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 9ab4233dd08036fe34a89c7dc6f47a8bf2eb29eb upstream.

Otherwise the code races with munmap (causing a use-after-free
of the vma) or with close (causing a use-after-free of the struct
file).

The bug was introduced by commit 90ed52ebe481 ("[PATCH] holepunch: fix
mmap_sem i_mutex deadlock")

[bwh: Backported to 3.2:
 - Adjust context
 - madvise_remove() calls vmtruncate_range(), not do_fallocate()]
[luto: Backported to 3.0: Adjust context]

Cc: Hugh Dickins <hugh@veritas.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[PG: commit e12fcd38abe8a869cbabd77724008f1cf812a3e7 in v3.0.37]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/madvise.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 319528b8db74..83aa92aad8bc 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -13,6 +13,7 @@
 #include <linux/hugetlb.h>
 #include <linux/sched.h>
 #include <linux/ksm.h>
+#include <linux/file.h>
 
 /*
  * Any behaviour which results in changes to the vma->vm_flags needs to
@@ -191,14 +192,16 @@ static long madvise_remove(struct vm_area_struct *vma,
 	struct address_space *mapping;
 	loff_t offset, endoff;
 	int error;
+	struct file *f;
 
 	*prev = NULL;	/* tell sys_madvise we drop mmap_sem */
 
 	if (vma->vm_flags & (VM_LOCKED|VM_NONLINEAR|VM_HUGETLB))
 		return -EINVAL;
 
-	if (!vma->vm_file || !vma->vm_file->f_mapping
-		|| !vma->vm_file->f_mapping->host) {
+	f = vma->vm_file;
+
+	if (!f || !f->f_mapping || !f->f_mapping->host) {
 			return -EINVAL;
 	}
 
@@ -212,9 +215,16 @@ static long madvise_remove(struct vm_area_struct *vma,
 	endoff = (loff_t)(end - vma->vm_start - 1)
 			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
 
-	/* vmtruncate_range needs to take i_mutex and i_alloc_sem */
+	/*
+	 * vmtruncate_range may need to take i_mutex and i_alloc_sem.
+	 * We need to explicitly grab a reference because the vma (and
+	 * hence the vma's reference to the file) can go away as soon as
+	 * we drop mmap_sem.
+	 */
+	get_file(f);
 	up_read(&current->mm->mmap_sem);
 	error = vmtruncate_range(mapping->host, offset, endoff);
+	fput(f);
 	down_read(&current->mm->mmap_sem);
 	return error;
 }
-- 
1.8.5.2

