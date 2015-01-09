Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbbAIBYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 20:24:40 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49679 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbbAIBYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 20:24:39 -0500
From: Mitchel Humpherys <mitchelh@codeaurora.org>
To: devel@driverdev.osuosl.org, Android Kernel Team <kernel-team@android.com>,
        Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, Laura Abbott <lauraa@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Mitchel Humpherys <mitchelh@codeaurora.org>
Subject: [PATCH] staging: ion: always initialize the free list parameters
Date: Thu,  8 Jan 2015 17:24:27 -0800
Message-Id: <1420766667-5538-1-git-send-email-mitchelh@codeaurora.org>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we initialize the heap free_lock and free list size in
ion_heap_init_deferred_free, which is only called when the
ION_HEAP_FLAG_DEFER_FREE heap flag is given.  However, the lock and size
are used in the shrinker path as well as the deferred free path, and we
can register a shrinker *without* enabling deferred freeing.  So, if a
heap provides a shrinker but *doesn't* set the DEFER_FREE flag we will
use these parameters uninitialized (resulting in a spinlock bug and
broken shrinker accounting).

Fix these problems by initializing the free list parameters directly in
ion_device_add_heap, which is always called no matter which heap
features are being used.

Signed-off-by: Mitchel Humpherys <mitchelh@codeaurora.org>
---
 drivers/staging/android/ion/ion.c      | 3 +++
 drivers/staging/android/ion/ion_heap.c | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 296d347660fc..b8f1c491553e 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -1508,6 +1508,9 @@ void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap)
 		pr_err("%s: can not add heap with invalid ops struct.\n",
 		       __func__);
 
+	spin_lock_init(&heap->free_lock);
+	heap->free_list_size = 0;
+
 	if (heap->flags & ION_HEAP_FLAG_DEFER_FREE)
 		ion_heap_init_deferred_free(heap);
 
diff --git a/drivers/staging/android/ion/ion_heap.c b/drivers/staging/android/ion/ion_heap.c
index 4605e04712aa..fd13d05b538a 100644
--- a/drivers/staging/android/ion/ion_heap.c
+++ b/drivers/staging/android/ion/ion_heap.c
@@ -253,8 +253,6 @@ int ion_heap_init_deferred_free(struct ion_heap *heap)
 	struct sched_param param = { .sched_priority = 0 };
 
 	INIT_LIST_HEAD(&heap->free_list);
-	heap->free_list_size = 0;
-	spin_lock_init(&heap->free_lock);
 	init_waitqueue_head(&heap->waitqueue);
 	heap->task = kthread_run(ion_heap_deferred_free, heap,
 				 "%s", heap->name);
-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

