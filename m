Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab3LMWdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:33:32 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:35790 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab3LMW2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:28:03 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 074/115] ion: convert map_kernel to return ERR_PTR
Date: Fri, 13 Dec 2013 14:24:48 -0800
Message-Id: <1386973529-4884-75-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

ion is going to stop accepting NULL as an error value, use ERR_PTR.

Signed-off-by: Colin Cross <ccross@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_carveout_heap.c | 7 ++++++-
 drivers/staging/android/ion/ion_heap.c          | 3 +++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion_carveout_heap.c b/drivers/staging/android/ion/ion_carveout_heap.c
index fd64168..36df34c 100644
--- a/drivers/staging/android/ion/ion_carveout_heap.c
+++ b/drivers/staging/android/ion/ion_carveout_heap.c
@@ -112,13 +112,18 @@ void ion_carveout_heap_unmap_dma(struct ion_heap *heap,
 void *ion_carveout_heap_map_kernel(struct ion_heap *heap,
 				   struct ion_buffer *buffer)
 {
+	void *ret;
 	int mtype = MT_MEMORY_NONCACHED;
 
 	if (buffer->flags & ION_FLAG_CACHED)
 		mtype = MT_MEMORY;
 
-	return __arm_ioremap(buffer->priv_phys, buffer->size,
+	ret = __arm_ioremap(buffer->priv_phys, buffer->size,
 			      mtype);
+	if (ret == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	return ret;
 }
 
 void ion_carveout_heap_unmap_kernel(struct ion_heap *heap,
diff --git a/drivers/staging/android/ion/ion_heap.c b/drivers/staging/android/ion/ion_heap.c
index cc2a425..a584ec0 100644
--- a/drivers/staging/android/ion/ion_heap.c
+++ b/drivers/staging/android/ion/ion_heap.c
@@ -56,6 +56,9 @@ void *ion_heap_map_kernel(struct ion_heap *heap,
 	vaddr = vmap(pages, npages, VM_MAP, pgprot);
 	vfree(pages);
 
+	if (vaddr == NULL)
+		return ERR_PTR(-ENOMEM);
+
 	return vaddr;
 }
 
-- 
1.8.3.2

