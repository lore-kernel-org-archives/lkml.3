Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943AbaD1T2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:28:36 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:58380 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932923AbaD1T2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:28:32 -0400
Message-ID: <1398708571.25549.10.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH 7/6] media: videobuf2-dma-sg: call find_vma with the
 mmap_sem held
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org
Cc: davidlohr@hp.com, aswin@hp.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Date: Mon, 28 Apr 2014 11:09:31 -0700
In-Reply-To: <1397960791-16320-1-git-send-email-davidlohr@hp.com>
References: <1397960791-16320-1-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Performing vma lookups without taking the mm->mmap_sem is asking
for trouble. While doing the search, the vma in question can
be modified or even removed before returning to the caller.
Take the lock in order to avoid races while iterating through
the vmacache and/or rbtree.

Also do some very minor cleanup changes.

This patch is only compile tested.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
It would seem this is the last offending user. 
v4l2 is a maze but I believe that this is needed as I don't
see the mmap_sem being taken by any callers of vb2_dma_sg_get_userptr().

 drivers/media/v4l2-core/videobuf2-dma-sg.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index c779f21..2a21100 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -168,8 +168,9 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	unsigned long first, last;
 	int num_pages_from_user;
 	struct vm_area_struct *vma;
+	struct mm_struct *mm = current->mm;
 
-	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
 	if (!buf)
 		return NULL;
 
@@ -178,7 +179,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	buf->offset = vaddr & ~PAGE_MASK;
 	buf->size = size;
 
-	first = (vaddr           & PAGE_MASK) >> PAGE_SHIFT;
+	first = (vaddr & PAGE_MASK) >> PAGE_SHIFT;
 	last  = ((vaddr + size - 1) & PAGE_MASK) >> PAGE_SHIFT;
 	buf->num_pages = last - first + 1;
 
@@ -187,7 +188,8 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	if (!buf->pages)
 		goto userptr_fail_alloc_pages;
 
-	vma = find_vma(current->mm, vaddr);
+	down_write(&mm->mmap_sem);
+	vma = find_vma(mm, vaddr);
 	if (!vma) {
 		dprintk(1, "no vma for address %lu\n", vaddr);
 		goto userptr_fail_find_vma;
@@ -218,7 +220,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 			buf->pages[num_pages_from_user] = pfn_to_page(pfn);
 		}
 	} else
-		num_pages_from_user = get_user_pages(current, current->mm,
+		num_pages_from_user = get_user_pages(current, mm,
 					     vaddr & PAGE_MASK,
 					     buf->num_pages,
 					     write,
@@ -233,6 +235,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 			buf->num_pages, buf->offset, size, 0))
 		goto userptr_fail_alloc_table_from_pages;
 
+	up_write(&mm->mmap_sem);
 	return buf;
 
 userptr_fail_alloc_table_from_pages:
@@ -244,6 +247,7 @@ userptr_fail_get_user_pages:
 			put_page(buf->pages[num_pages_from_user]);
 	vb2_put_vma(buf->vma);
 userptr_fail_find_vma:
+	up_write(&mm->mmap_sem);
 	kfree(buf->pages);
 userptr_fail_alloc_pages:
 	kfree(buf);
-- 
1.8.1.4



