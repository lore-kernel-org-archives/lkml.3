Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab3LMWlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:41:39 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:35771 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab3LMW1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:17 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 044/115] gpu: ion: Don't flush allocatoins that come from the page pools
Date: Fri, 13 Dec 2013 14:24:18 -0800
Message-Id: <1386973529-4884-45-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index ad4933e..02726a9 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -76,9 +76,14 @@ static struct page *alloc_buffer_page(struct ion_system_heap *heap,
 		if (order > 4)
 			gfp_flags = high_order_gfp_flags;
 		page = alloc_pages(gfp_flags, order);
+		if (!page)
+			return 0;
+		__dma_page_cpu_to_dev(page, 0, PAGE_SIZE << order,
+				      DMA_BIDIRECTIONAL);
 	}
 	if (!page)
 		return 0;
+
 	if (split_pages)
 		split_page(page, order);
 	return page;
@@ -201,9 +206,6 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 		kfree(info);
 	}
 
-	dma_sync_sg_for_device(NULL, table->sgl, table->nents,
-			       DMA_BIDIRECTIONAL);
-
 	buffer->priv_virt = table;
 	return 0;
 err1:
-- 
1.8.3.2

