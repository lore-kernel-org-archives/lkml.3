Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab3GYRWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:22:12 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:49708 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722Ab3GYRWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:22:08 -0400
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave@sr71.net>, Robert Jennings <rcj@linux.vnet.ibm.com>,
        Matt Helsley <matt.helsley@gmail.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Lei Li <lilei@linux.vnet.ibm.com>,
        Leonardo Garcia <lagarcia@linux.vnet.ibm.com>
Subject: [RFC PATCH 2/2] Add limited zero copy to vmsplice
Date: Thu, 25 Jul 2013 12:21:46 -0500
Message-Id: <1374772906-21511-3-git-send-email-rcj@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374772906-21511-1-git-send-email-rcj@linux.vnet.ibm.com>
References: <1374772906-21511-1-git-send-email-rcj@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072517-1618-0000-0000-00000457DEC3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Helsley <matthltc@us.ibm.com>

It is sometimes useful to move anonymous pages over a pipe rather than
save/swap them. Check the SPLICE_F_GIFT and SPLICE_F_MOVE flags to see
if userspace would like to move such pages. This differs from plain
SPLICE_F_GIFT in that the memory written to the pipe will no longer
have the same contents as the original -- it effectively faults in new,
empty anonymous pages.

On the read side the page written to the pipe will be copied unless
SPLICE_F_MOVE is used. Otherwise copying will be performed and the page
will be reclaimed. Note that so long as there is a mapping to the page
copies will be done instead because rmap will have upped the map count for
each anonymous mapping; this can happen do to fork(), for example. This
is necessary because moving the page will usually change the anonymous
page's nonlinear index and that can only be done if it's unmapped.

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Signed-off-by: Matt Helsley <matt.helsley@gmail.com>
Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
---
 fs/splice.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/fs/splice.c b/fs/splice.c
index 6aa964f..0a715c3 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -32,6 +32,10 @@
 #include <linux/gfp.h>
 #include <linux/socket.h>
 #include <linux/compat.h>
+#include <linux/page-flags.h>
+#include <linux/hugetlb.h>
+#include <linux/ksm.h>
+#include <linux/swapops.h>
 #include "internal.h"
 
 /*
@@ -1536,6 +1540,65 @@ static int pipe_to_user(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 	char *src;
 	int ret;
 
+	if (!buf->offset && (buf->len == PAGE_SIZE) &&
+	    (buf->flags & PIPE_BUF_FLAG_GIFT) && (sd->flags & SPLICE_F_MOVE)) {
+		struct page *page = buf->page;
+		struct mm_struct *mm;
+		struct vm_area_struct *vma;
+		spinlock_t *ptl;
+		pte_t *ptep, pte;
+		unsigned long useraddr;
+
+		if (!PageAnon(page))
+			goto copy;
+		if (PageCompound(page))
+			goto copy;
+		if (PageHuge(page) || PageTransHuge(page))
+			goto copy;
+		if (page_mapped(page))
+			goto copy;
+		useraddr = (unsigned long)sd->u.userptr;
+		mm = current->mm;
+
+		ret = -EAGAIN;
+		down_read(&mm->mmap_sem);
+		vma = find_vma_intersection(mm, useraddr, useraddr + PAGE_SIZE);
+		if (IS_ERR_OR_NULL(vma))
+			goto up_copy;
+		if (!vma->anon_vma) {
+			ret = anon_vma_prepare(vma);
+			if (ret)
+				goto up_copy;
+		}
+		zap_page_range(vma, useraddr, PAGE_SIZE, NULL);
+		ret = lock_page_killable(page);
+		if (ret)
+			goto up_copy;
+		ptep = get_locked_pte(mm, useraddr, &ptl);
+		if (!ptep)
+			goto unlock_up_copy;
+		pte = *ptep;
+		if (pte_present(pte))
+			goto unlock_up_copy;
+		get_page(page);
+		page_add_anon_rmap(page, vma, useraddr);
+		pte = mk_pte(page, vma->vm_page_prot);
+		set_pte_at(mm, useraddr, ptep, pte);
+		update_mmu_cache(vma, useraddr, ptep);
+		pte_unmap_unlock(ptep, ptl);
+		ret = 0;
+unlock_up_copy:
+		unlock_page(page);
+up_copy:
+		up_read(&mm->mmap_sem);
+		if (!ret) {
+			ret = sd->len;
+			goto out;
+		}
+		/* else ret < 0 and we should fallback to copying */
+		VM_BUG_ON(ret > 0);
+	}
+copy:
 	/*
 	 * See if we can use the atomic maps, by prefaulting in the
 	 * pages and doing an atomic copy
-- 
1.8.1.2

