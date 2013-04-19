Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968132Ab3DSJrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:47:15 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:47198 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758536Ab3DSJrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:47:13 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCH RFC] media: videobuf2: fix the length check for mmap
Date: Fri, 19 Apr 2013 15:16:56 +0530
Message-Id: <1366364816-3567-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

>From commit 068a0df76023926af958a336a78bef60468d2033
"[media] media: vb2: add length check for mmap"
patch verifies that the mmap() size requested by userspace
doesn't exceed the buffer size.

As the mmap() size is rounded up to the next page boundary
the check will fail for buffer sizes that are not multiple
of the page size.

This patch fixes the check by aligning the buffer size to page
size during the check. Alongside fixes the vmalloc allocator
to round up the size.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/v4l2-core/videobuf2-core.c    |    2 +-
 drivers/media/v4l2-core/videobuf2-vmalloc.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 58c1744..223fcd4 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1886,7 +1886,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 
 	vb = q->bufs[buffer];
 
-	if (vb->v4l2_planes[plane].length < (vma->vm_end - vma->vm_start)) {
+	if (PAGE_ALIGN(vb->v4l2_planes[plane].length) < (vma->vm_end - vma->vm_start)) {
 		dprintk(1, "Invalid length\n");
 		return -EINVAL;
 	}
diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index 313d977..bf3b95c 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -44,7 +44,7 @@ static void *vb2_vmalloc_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_fl
 		return NULL;
 
 	buf->size = size;
-	buf->vaddr = vmalloc_user(buf->size);
+	buf->vaddr = vmalloc_user(PAGE_ALIGN(buf->size));
 	buf->handler.refcount = &buf->refcount;
 	buf->handler.put = vb2_vmalloc_put;
 	buf->handler.arg = buf;
-- 
1.7.4.1

