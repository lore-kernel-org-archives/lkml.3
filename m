Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab3LMW1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:27:00 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:61185 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab3LMW05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:57 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 033/115] gpu: ion: Stop trying to allocate from an order on first failure
Date: Fri, 13 Dec 2013 14:24:07 -0800
Message-Id: <1386973529-4884-34-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

With this patch the system heap will only try to allocate from each
order as long as allocations succeed.  If it failes to obtain a higher
order allocation, it doesn't retry that order.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index ef8afc7..30a225a 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -32,7 +32,8 @@ struct page_info {
 };
 
 static struct page_info *alloc_largest_available(unsigned long size,
-						 bool split_pages)
+						 bool split_pages,
+						 unsigned int max_order)
 {
 	static unsigned int orders[] = {8, 4, 0};
 	struct page *page;
@@ -42,6 +43,8 @@ static struct page_info *alloc_largest_available(unsigned long size,
 	for (i = 0; i < ARRAY_SIZE(orders); i++) {
 		if (size < (1 << orders[i]) * PAGE_SIZE)
 			continue;
+		if (max_order < orders[i])
+			continue;
 		page = alloc_pages(GFP_HIGHUSER | __GFP_ZERO |
 				   __GFP_NOWARN | __GFP_NORETRY, orders[i]);
 		if (!page)
@@ -71,13 +74,17 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 	bool split_pages = ion_buffer_fault_user_mappings(buffer);
 
 
+	unsigned int max_order = orders[0];
+
 	INIT_LIST_HEAD(&pages);
 	while (size_remaining > 0) {
-		info = alloc_largest_available(size_remaining, split_pages);
+		info = alloc_largest_available(size_remaining, split_pages,
+					       max_order);
 		if (!info)
 			goto err;
 		list_add_tail(&info->list, &pages);
 		size_remaining -= (1 << info->order) * PAGE_SIZE;
+		max_order = info->order;
 		i++;
 	}
 
-- 
1.8.3.2

