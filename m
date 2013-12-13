Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab3LMW1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:27:04 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:47869 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab3LMW1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:01 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 035/115] gpu: ion: use vmalloc to allocate page array to map kernel
Date: Fri, 13 Dec 2013 14:24:09 -0800
Message-Id: <1386973529-4884-36-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

When ion_map_kernel is execute the system must allocate
an array large enough to hold a pointer to each page in
the buffer.  If the buffer is very large and the system
memory has become very fragmented, there may not be
sufficient high order allocations available from kmalloc.
Use vmalloc instead.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 25b0255..fcfbb66 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -174,10 +174,12 @@ void *ion_system_heap_map_kernel(struct ion_heap *heap,
 	pgprot_t pgprot;
 	struct sg_table *table = buffer->priv_virt;
 	int npages = PAGE_ALIGN(buffer->size) / PAGE_SIZE;
-	struct page **pages = kzalloc(sizeof(struct page *) * npages,
-				     GFP_KERNEL);
+	struct page **pages = vmalloc(sizeof(struct page *) * npages);
 	struct page **tmp = pages;
 
+	if (!pages)
+		return 0;
+
 	if (buffer->flags & ION_FLAG_CACHED)
 		pgprot = PAGE_KERNEL;
 	else
@@ -192,7 +194,7 @@ void *ion_system_heap_map_kernel(struct ion_heap *heap,
 		}
 	}
 	vaddr = vmap(pages, npages, VM_MAP, pgprot);
-	kfree(pages);
+	vfree(pages);
 
 	return vaddr;
 }
-- 
1.8.3.2

