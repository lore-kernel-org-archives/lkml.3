Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab3LND1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:27:34 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:58925 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab3LND0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:26:54 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 098/115] ion: Fix two small issues in system_heap allocation
Date: Fri, 13 Dec 2013 19:26:18 -0800
Message-Id: <1386991595-6251-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
 <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In testing ion system heap allocations, I ran across two issues:

1) Not k*z*allocing the sg table. This can cause trouble if
we end up trying call sg_alloc_table() with too many entries,
then sg_alloc_table() internally fails and tries to free what it
thinks is internal table structure, which causes bad pointer
traversals.

2) The second list_for_each_entry probably should be _safe,
since I was seeing  strange lock warnings and oopses on occasion.
This seems to resolve it, but could use some extra checking.

Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 9250ee5..bec9d45 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -166,8 +166,7 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 		max_order = info->order;
 		i++;
 	}
-
-	table = kmalloc(sizeof(struct sg_table), GFP_KERNEL);
+	table = kzalloc(sizeof(struct sg_table), GFP_KERNEL);
 	if (!table)
 		goto err;
 
@@ -189,7 +188,7 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 err1:
 	kfree(table);
 err:
-	list_for_each_entry(info, &pages, list) {
+	list_for_each_entry_safe(info, tmp_info, &pages, list) {
 		free_buffer_page(sys_heap, buffer, info->page, info->order);
 		kfree(info);
 	}
-- 
1.8.3.2

