Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236AbaBEAJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 19:09:27 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:48895 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590AbaBEAJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 19:09:19 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Colin Cross <ccross@android.com>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 5/7] staging: ion: Fix overflow and list bugs in system heap
Date: Tue,  4 Feb 2014 16:08:38 -0800
Message-Id: <1391558920-31590-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391558920-31590-1-git-send-email-john.stultz@linaro.org>
References: <1391558920-31590-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Fix a few bugs in ion_system_heap:

Initialize the list node in the info block.

Don't store size_remaining in a signed long, allocating >2GB
could overflow, resulting in a call to sg_alloc_table with
nents=0 which panics.  alloc_largest_available will never
return a block larger than size_remanining, so it can never
go negative.

Limit a single allocation to half of all memory.  Prevents a
large allocation from taking down the whole system.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Colin Cross <ccross@android.com>
[jstultz: Minor commit subject tweak]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 7f07291..9849f39 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -124,6 +124,7 @@ static struct page_info *alloc_largest_available(struct ion_system_heap *heap,
 
 		info->page = page;
 		info->order = orders[i];
+		INIT_LIST_HEAD(&info->list);
 		return info;
 	}
 	kfree(info);
@@ -145,12 +146,15 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 	struct list_head pages;
 	struct page_info *info, *tmp_info;
 	int i = 0;
-	long size_remaining = PAGE_ALIGN(size);
+	unsigned long size_remaining = PAGE_ALIGN(size);
 	unsigned int max_order = orders[0];
 
 	if (align > PAGE_SIZE)
 		return -EINVAL;
 
+	if (size / PAGE_SIZE > totalram_pages / 2)
+		return -ENOMEM;
+
 	INIT_LIST_HEAD(&pages);
 	while (size_remaining > 0) {
 		info = alloc_largest_available(sys_heap, buffer, size_remaining,
-- 
1.8.3.2

