Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab3LMWlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:41:21 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:38307 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab3LMW1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:19 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 045/115] gpu: ion: Fix bug in ion_system_heap map_user
Date: Fri, 13 Dec 2013 14:24:19 -0800
Message-Id: <1386973529-4884-46-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

When the requested mmap length was not an integer number of
chunks or the buffer, or if an offset was provided, a bug
would cause extra or incorrect pages of the buffer to be mapped.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 02726a9..df08469 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -292,18 +292,27 @@ int ion_system_heap_map_user(struct ion_heap *heap, struct ion_buffer *buffer,
 {
 	struct sg_table *table = buffer->priv_virt;
 	unsigned long addr = vma->vm_start;
-	unsigned long offset = vma->vm_pgoff;
+	unsigned long offset = vma->vm_pgoff * PAGE_SIZE;
 	struct scatterlist *sg;
 	int i;
 
 	for_each_sg(table->sgl, sg, table->nents, i) {
-		if (offset) {
-			offset--;
+		struct page *page = sg_page(sg);
+		unsigned long remainder = vma->vm_end - addr;
+		unsigned long len = sg_dma_len(sg);
+
+		if (offset >= sg_dma_len(sg)) {
+			offset -= sg_dma_len(sg);
 			continue;
+		} else if (offset) {
+			page += offset / PAGE_SIZE;
+			len = sg_dma_len(sg) - offset;
+			offset = 0;
 		}
-		remap_pfn_range(vma, addr, page_to_pfn(sg_page(sg)),
-				sg_dma_len(sg), vma->vm_page_prot);
-		addr += sg_dma_len(sg);
+		len = min(len, remainder);
+		remap_pfn_range(vma, addr, page_to_pfn(page), len,
+				vma->vm_page_prot);
+		addr += len;
 		if (addr >= vma->vm_end)
 			return 0;
 	}
-- 
1.8.3.2

