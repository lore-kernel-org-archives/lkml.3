Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab3LND2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:28:00 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:45393 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab3LND1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:27:17 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 112/115] ion: fix bugs in cma heap
Date: Fri, 13 Dec 2013 19:26:32 -0800
Message-Id: <1386991595-6251-20-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
 <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Implement ion_cma_unmap_kernel, ion will call it unconditionally.
Use correct gfp flags when calling dma_alloc_coherent so it doesn't
try to use atomic DMA memory.
Check for invalid alignment when allocating.
Reject cached allocations - the cpu address returned by
dma_alloc_coherent is always going to be an uncached mapping, so
map_kernel will not see data written by a cached userspace mapping.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_cma_heap.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion_cma_heap.c b/drivers/staging/android/ion/ion_cma_heap.c
index 3dcf9b4..f0f9889 100644
--- a/drivers/staging/android/ion/ion_cma_heap.c
+++ b/drivers/staging/android/ion/ion_cma_heap.c
@@ -69,13 +69,20 @@ static int ion_cma_allocate(struct ion_heap *heap, struct ion_buffer *buffer,
 
 	dev_dbg(dev, "Request buffer allocation len %ld\n", len);
 
+	if (buffer->flags & ION_FLAG_CACHED)
+		return -EINVAL;
+
+	if (align > PAGE_SIZE)
+		return -EINVAL;
+
 	info = kzalloc(sizeof(struct ion_cma_buffer_info), GFP_KERNEL);
 	if (!info) {
 		dev_err(dev, "Can't allocate buffer info\n");
 		return ION_CMA_ALLOCATE_FAILED;
 	}
 
-	info->cpu_addr = dma_alloc_coherent(dev, len, &(info->handle), 0);
+	info->cpu_addr = dma_alloc_coherent(dev, len, &(info->handle),
+						GFP_HIGHUSER | __GFP_ZERO);
 
 	if (!info->cpu_addr) {
 		dev_err(dev, "Fail to allocate buffer\n");
@@ -170,6 +177,11 @@ static void *ion_cma_map_kernel(struct ion_heap *heap,
 	return info->cpu_addr;
 }
 
+static void ion_cma_unmap_kernel(struct ion_heap *heap,
+					struct ion_buffer *buffer)
+{
+}
+
 static struct ion_heap_ops ion_cma_ops = {
 	.allocate = ion_cma_allocate,
 	.free = ion_cma_free,
@@ -178,6 +190,7 @@ static struct ion_heap_ops ion_cma_ops = {
 	.phys = ion_cma_phys,
 	.map_user = ion_cma_mmap,
 	.map_kernel = ion_cma_map_kernel,
+	.unmap_kernel = ion_cma_unmap_kernel,
 };
 
 struct ion_heap *ion_cma_heap_create(struct ion_platform_heap *data)
-- 
1.8.3.2

