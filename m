Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab3LND1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:27:47 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:57535 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab3LND1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:27:03 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 103/115] ion: check return value from remap_pfn_range
Date: Fri, 13 Dec 2013 19:26:23 -0800
Message-Id: <1386991595-6251-11-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
 <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Check the return value of remap_pfn_range and return an error if
it fails.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_heap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion_heap.c b/drivers/staging/android/ion/ion_heap.c
index ce31561..ecc14fd 100644
--- a/drivers/staging/android/ion/ion_heap.c
+++ b/drivers/staging/android/ion/ion_heap.c
@@ -76,6 +76,7 @@ int ion_heap_map_user(struct ion_heap *heap, struct ion_buffer *buffer,
 	unsigned long offset = vma->vm_pgoff * PAGE_SIZE;
 	struct scatterlist *sg;
 	int i;
+	int ret;
 
 	for_each_sg(table->sgl, sg, table->nents, i) {
 		struct page *page = sg_page(sg);
@@ -91,8 +92,10 @@ int ion_heap_map_user(struct ion_heap *heap, struct ion_buffer *buffer,
 			offset = 0;
 		}
 		len = min(len, remainder);
-		remap_pfn_range(vma, addr, page_to_pfn(page), len,
+		ret = remap_pfn_range(vma, addr, page_to_pfn(page), len,
 				vma->vm_page_prot);
+		if (ret)
+			return ret;
 		addr += len;
 		if (addr >= vma->vm_end)
 			return 0;
-- 
1.8.3.2

