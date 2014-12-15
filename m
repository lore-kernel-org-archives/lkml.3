Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbaLONkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 08:40:33 -0500
Received: from xavier.telenet-ops.be ([195.130.132.52]:53355 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaLONka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 08:40:30 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Hans Verkuil <hansverk@cisco.com>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] [media] vb2-vmalloc: Protect DMA-specific code by #ifdef CONFIG_HAS_DMA
Date: Mon, 15 Dec 2014 14:40:28 +0100
Message-Id: <1418650828-28562-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

drivers/built-in.o: In function `vb2_vmalloc_dmabuf_ops_detach':
videobuf2-vmalloc.c:(.text+0x6f11b0): undefined reference to `dma_unmap_sg'
drivers/built-in.o: In function `vb2_vmalloc_dmabuf_ops_map':
videobuf2-vmalloc.c:(.text+0x6f1266): undefined reference to `dma_unmap_sg'
videobuf2-vmalloc.c:(.text+0x6f1282): undefined reference to `dma_map_sg'

As we don't want to make the core VIDEOBUF2_VMALLOC depend on HAS_DMA
(it's v4l2 core code, and selected by a lot of drivers), stub out the
DMA support if HAS_DMA is not set.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/v4l2-core/videobuf2-vmalloc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index fba944e502271069..d4fe55c85e0c5e71 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -211,6 +211,7 @@ static int vb2_vmalloc_mmap(void *buf_priv, struct vm_area_struct *vma)
 	return 0;
 }
 
+#ifdef CONFIG_HAS_DMA
 /*********************************************/
 /*         DMABUF ops for exporters          */
 /*********************************************/
@@ -380,6 +381,8 @@ static struct dma_buf *vb2_vmalloc_get_dmabuf(void *buf_priv, unsigned long flag
 
 	return dbuf;
 }
+#endif /* CONFIG_HAS_DMA */
+
 
 /*********************************************/
 /*       callbacks for DMABUF buffers        */
@@ -437,7 +440,9 @@ const struct vb2_mem_ops vb2_vmalloc_memops = {
 	.put		= vb2_vmalloc_put,
 	.get_userptr	= vb2_vmalloc_get_userptr,
 	.put_userptr	= vb2_vmalloc_put_userptr,
+#ifdef CONFIG_HAS_DMA
 	.get_dmabuf	= vb2_vmalloc_get_dmabuf,
+#endif
 	.map_dmabuf	= vb2_vmalloc_map_dmabuf,
 	.unmap_dmabuf	= vb2_vmalloc_unmap_dmabuf,
 	.attach_dmabuf	= vb2_vmalloc_attach_dmabuf,
-- 
1.9.1

