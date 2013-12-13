Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab3LMWhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:37:25 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:49916 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab3LMW1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:40 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 059/115] gpu: ion: Only flush buffers in the chunk heap if they were used cached
Date: Fri, 13 Dec 2013 14:24:33 -0800
Message-Id: <1386973529-4884-60-git-send-email-john.stultz@linaro.org>
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
 drivers/staging/android/ion/ion_chunk_heap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
index 5582909..60cd91c 100644
--- a/drivers/staging/android/ion/ion_chunk_heap.c
+++ b/drivers/staging/android/ion/ion_chunk_heap.c
@@ -104,8 +104,9 @@ static void ion_chunk_heap_free(struct ion_buffer *buffer)
 	ion_heap_buffer_zero(buffer);
 
 	for_each_sg(table->sgl, sg, table->nents, i) {
-		__dma_page_cpu_to_dev(sg_page(sg), 0, sg_dma_len(sg),
-				      DMA_BIDIRECTIONAL);
+		if (ion_buffer_cached(buffer))
+			__dma_page_cpu_to_dev(sg_page(sg), 0, sg_dma_len(sg),
+					      DMA_BIDIRECTIONAL);
 		gen_pool_free(chunk_heap->pool, page_to_phys(sg_page(sg)),
 			      sg_dma_len(sg));
 	}
-- 
1.8.3.2

