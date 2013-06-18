Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580Ab3FRURc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 16:17:32 -0400
Received: from longford.logfs.org ([213.229.74.203]:59571 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933069Ab3FRUR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 16:17:29 -0400
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Joern Engel <joern@logfs.org>
Subject: [PATCH 1/2] hugetlb: properly account rss
Date: Tue, 18 Jun 2013 14:47:04 -0400
Message-Id: <1371581225-27535-2-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1371581225-27535-1-git-send-email-joern@logfs.org>
References: <1371581225-27535-1-git-send-email-joern@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When moving a program from mmap'ing small pages to mmap'ing huge pages,
a remarkable drop in rss ensues.  For some reason hugepages were never
accounted for in rss, which in my book is a clear bug.  Sadly this bug
has been present in hugetlbfs since it was merged back in 2002.  There
is every chance existing programs depend on hugepages not being counted
as rss.

I think the correct solution is to fix the bug and wait for someone to
complain.  It is just as likely that noone cares - as evidenced by the
fact that noone seems to have noticed for ten years.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 mm/hugetlb.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1a12f5b..705036c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1174,6 +1174,7 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	set_page_private(page, (unsigned long)spool);
 
 	vma_commit_reservation(h, vma, addr);
+	add_mm_counter(vma->vm_mm, MM_ANONPAGES, pages_per_huge_page(h));
 	return page;
 }
 
@@ -2406,6 +2407,9 @@ again:
 		if (pte_dirty(pte))
 			set_page_dirty(page);
 
+		/* -pages_per_huge_page(h) wouldn't get sign-extended */
+		add_mm_counter(vma->vm_mm, MM_ANONPAGES, -1 << h->order);
+
 		page_remove_rmap(page);
 		force_flush = !__tlb_remove_page(tlb, page);
 		if (force_flush)
-- 
1.7.10.4

