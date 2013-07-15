Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab3GOJer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 05:34:47 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:61798 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab3GOJeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 05:34:44 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org (open list)
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] videobuf2-dma-sg: Minimize the number of dma segments
Date: Mon, 15 Jul 2013 11:34:34 +0200
Message-Id: <1373880874-9270-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most DMA engines have limitations regarding the number of DMA segments
(sg-buffers) that they can handle. Videobuffers can easily spread through
houndreds of pages.

In the previous aproach, the pages were allocated individually, this
could led to the creation houndreds of dma segments (sg-buffers) that
could not be handled by some DMA engines.

This patch tries to minimize the number of DMA segments by using
alloc_pages_exact. In the worst case it will behave as before, but most
of the times it will reduce the number fo dma segments

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/videobuf2-dma-sg.c |   49 +++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 11 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 16ae3dc..67a94ab 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -42,10 +42,44 @@ struct vb2_dma_sg_buf {
 
 static void vb2_dma_sg_put(void *buf_priv);
 
+static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
+		gfp_t gfp_flags)
+{
+	unsigned int last_page = 0;
+	void *vaddr = NULL;
+	unsigned int req_pages;
+
+	while (last_page < buf->sg_desc.num_pages) {
+		req_pages = buf->sg_desc.num_pages-last_page;
+		while (req_pages >= 1) {
+			vaddr = alloc_pages_exact(req_pages*PAGE_SIZE,
+				GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN);
+			if (vaddr)
+				break;
+			req_pages >>= 1;
+		}
+		if (!vaddr) {
+			while (--last_page >= 0)
+				__free_page(buf->pages[last_page]);
+			return -ENOMEM;
+		}
+		while (req_pages) {
+			buf->pages[last_page] = virt_to_page(vaddr);
+			sg_set_page(&buf->sg_desc.sglist[last_page],
+					buf->pages[last_page], PAGE_SIZE, 0);
+			vaddr += PAGE_SIZE;
+			last_page++;
+			req_pages--;
+		}
+	}
+
+	return 0;
+}
+
 static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_flags)
 {
 	struct vb2_dma_sg_buf *buf;
-	int i;
+	int ret;
 
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
@@ -69,14 +103,9 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_fla
 	if (!buf->pages)
 		goto fail_pages_array_alloc;
 
-	for (i = 0; i < buf->sg_desc.num_pages; ++i) {
-		buf->pages[i] = alloc_page(GFP_KERNEL | __GFP_ZERO |
-					   __GFP_NOWARN | gfp_flags);
-		if (NULL == buf->pages[i])
-			goto fail_pages_alloc;
-		sg_set_page(&buf->sg_desc.sglist[i],
-			    buf->pages[i], PAGE_SIZE, 0);
-	}
+	ret = vb2_dma_sg_alloc_compacted(buf, gfp_flags);
+	if (ret)
+		goto fail_pages_alloc;
 
 	buf->handler.refcount = &buf->refcount;
 	buf->handler.put = vb2_dma_sg_put;
@@ -89,8 +118,6 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_fla
 	return buf;
 
 fail_pages_alloc:
-	while (--i >= 0)
-		__free_page(buf->pages[i]);
 	kfree(buf->pages);
 
 fail_pages_array_alloc:
-- 
1.7.10.4

