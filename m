Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbaBUN7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:59:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46765 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738AbaBUMtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:49:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans Verkuil <hans.verkuil@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 011/121] [media] Revert "[media] videobuf_vm_{open,close} race fixes"
Date: Fri, 21 Feb 2014 12:47:15 +0000
Message-Id: <1392986945-9693-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil@xs4all.nl>

commit cca36e2eecec2b8fc869a50ffd3bd0adeed92b8b upstream.

This reverts commit a242f426108c284049a69710f871cc9f11b13e61.

That commit actually caused deadlocks, rather then fixing them.

If ext_lock is set to NULL (otherwise videobuf_queue_lock doesn't do
anything), then you get this deadlock:

The driver's mmap function calls videobuf_mmap_mapper which calls
videobuf_queue_lock on q. videobuf_mmap_mapper calls  __videobuf_mmap_mapper,
__videobuf_mmap_mapper calls videobuf_vm_open and videobuf_vm_open
calls videobuf_queue_lock on q (introduced by above patch): deadlocked.

This affects drivers using dma-contig and dma-vmalloc. Only dma-sg is
not affected since it doesn't call videobuf_vm_open from __videobuf_mmap_mapper.

Most drivers these days have a non-NULL ext_lock. Those that still use
NULL there are all fairly obscure drivers, which is why this hasn't been
seen earlier.

Since everything worked perfectly fine for many years I prefer to just
revert this patch rather than trying to fix it. videobuf is quite fragile
and I rather not touch it too much. Work is (slowly) progressing to move
everything over to vb2 or at the very least use non-NULL ext_lock in
videobuf.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Reported-by: Pete Eberlein <pete@sensoray.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/v4l2-core/videobuf-dma-contig.c | 12 +++++-------
 drivers/media/v4l2-core/videobuf-dma-sg.c     | 10 ++++------
 drivers/media/v4l2-core/videobuf-vmalloc.c    | 10 ++++------
 3 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
index 65411ad..7e6b209 100644
--- a/drivers/media/v4l2-core/videobuf-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
@@ -66,14 +66,11 @@ static void __videobuf_dc_free(struct device *dev,
 static void videobuf_vm_open(struct vm_area_struct *vma)
 {
 	struct videobuf_mapping *map = vma->vm_private_data;
-	struct videobuf_queue *q = map->q;
 
-	dev_dbg(q->dev, "vm_open %p [count=%u,vma=%08lx-%08lx]\n",
+	dev_dbg(map->q->dev, "vm_open %p [count=%u,vma=%08lx-%08lx]\n",
 		map, map->count, vma->vm_start, vma->vm_end);
 
-	videobuf_queue_lock(q);
 	map->count++;
-	videobuf_queue_unlock(q);
 }
 
 static void videobuf_vm_close(struct vm_area_struct *vma)
@@ -85,11 +82,12 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 	dev_dbg(q->dev, "vm_close %p [count=%u,vma=%08lx-%08lx]\n",
 		map, map->count, vma->vm_start, vma->vm_end);
 
-	videobuf_queue_lock(q);
-	if (!--map->count) {
+	map->count--;
+	if (0 == map->count) {
 		struct videobuf_dma_contig_memory *mem;
 
 		dev_dbg(q->dev, "munmap %p q=%p\n", map, q);
+		videobuf_queue_lock(q);
 
 		/* We need first to cancel streams, before unmapping */
 		if (q->streaming)
@@ -128,8 +126,8 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 
 		kfree(map);
 
+		videobuf_queue_unlock(q);
 	}
-	videobuf_queue_unlock(q);
 }
 
 static const struct vm_operations_struct videobuf_vm_ops = {
diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
index 9db674c..828e7c1 100644
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -338,14 +338,11 @@ EXPORT_SYMBOL_GPL(videobuf_dma_free);
 static void videobuf_vm_open(struct vm_area_struct *vma)
 {
 	struct videobuf_mapping *map = vma->vm_private_data;
-	struct videobuf_queue *q = map->q;
 
 	dprintk(2, "vm_open %p [count=%d,vma=%08lx-%08lx]\n", map,
 		map->count, vma->vm_start, vma->vm_end);
 
-	videobuf_queue_lock(q);
 	map->count++;
-	videobuf_queue_unlock(q);
 }
 
 static void videobuf_vm_close(struct vm_area_struct *vma)
@@ -358,9 +355,10 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 	dprintk(2, "vm_close %p [count=%d,vma=%08lx-%08lx]\n", map,
 		map->count, vma->vm_start, vma->vm_end);
 
-	videobuf_queue_lock(q);
-	if (!--map->count) {
+	map->count--;
+	if (0 == map->count) {
 		dprintk(1, "munmap %p q=%p\n", map, q);
+		videobuf_queue_lock(q);
 		for (i = 0; i < VIDEO_MAX_FRAME; i++) {
 			if (NULL == q->bufs[i])
 				continue;
@@ -376,9 +374,9 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 			q->bufs[i]->baddr = 0;
 			q->ops->buf_release(q, q->bufs[i]);
 		}
+		videobuf_queue_unlock(q);
 		kfree(map);
 	}
-	videobuf_queue_unlock(q);
 	return;
 }
 
diff --git a/drivers/media/v4l2-core/videobuf-vmalloc.c b/drivers/media/v4l2-core/videobuf-vmalloc.c
index 1365c65..2ff7fcc 100644
--- a/drivers/media/v4l2-core/videobuf-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf-vmalloc.c
@@ -54,14 +54,11 @@ MODULE_LICENSE("GPL");
 static void videobuf_vm_open(struct vm_area_struct *vma)
 {
 	struct videobuf_mapping *map = vma->vm_private_data;
-	struct videobuf_queue *q = map->q;
 
 	dprintk(2, "vm_open %p [count=%u,vma=%08lx-%08lx]\n", map,
 		map->count, vma->vm_start, vma->vm_end);
 
-	videobuf_queue_lock(q);
 	map->count++;
-	videobuf_queue_unlock(q);
 }
 
 static void videobuf_vm_close(struct vm_area_struct *vma)
@@ -73,11 +70,12 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 	dprintk(2, "vm_close %p [count=%u,vma=%08lx-%08lx]\n", map,
 		map->count, vma->vm_start, vma->vm_end);
 
-	videobuf_queue_lock(q);
-	if (!--map->count) {
+	map->count--;
+	if (0 == map->count) {
 		struct videobuf_vmalloc_memory *mem;
 
 		dprintk(1, "munmap %p q=%p\n", map, q);
+		videobuf_queue_lock(q);
 
 		/* We need first to cancel streams, before unmapping */
 		if (q->streaming)
@@ -116,8 +114,8 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 
 		kfree(map);
 
+		videobuf_queue_unlock(q);
 	}
-	videobuf_queue_unlock(q);
 
 	return;
 }
-- 
1.9.0

