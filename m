Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab3LMW0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:26:47 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:55626 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab3LMW0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:44 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 025/115] gpu: ion: Switch to using kmalloc rather than kmap during allocation
Date: Fri, 13 Dec 2013 14:23:59 -0800
Message-Id: <1386973529-4884-26-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

Previously, metadata was stored in the allocated pages themselves
during allocation.  However the system can only have a limited
number of kmapped pages.  A very large allocation might exceed
this limit.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 7397bc4..2fb9a64 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -46,7 +46,7 @@ static struct page_info *alloc_largest_available(unsigned long size)
 		if (!page)
 			continue;
 		split_page(page, orders[i]);
-		info = kmap(page);
+		info = kmalloc(sizeof(struct page_info *), GFP_KERNEL);
 		info->page = page;
 		info->order = orders[i];
 		return info;
@@ -93,7 +93,7 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 		}
 		list_del(&info->list);
 		memset(info, 0, sizeof(struct page_info));
-		kunmap(page);
+		kfree(info);
 	}
 
 	dma_sync_sg_for_device(NULL, table->sgl, table->nents,
@@ -107,7 +107,7 @@ err:
 	list_for_each_entry(info, &pages, list) {
 		for (i = 0; i < (1 << info->order); i++)
 			__free_page(info->page + i);
-		kunmap(info->page);
+		kfree(info);
 	}
 	return -ENOMEM;
 }
-- 
1.8.3.2

