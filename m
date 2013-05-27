Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab3E0QNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 12:13:39 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:50875 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab3E0QNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 12:13:36 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>, Shuah Khan <shuah.khan@hp.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [RFC PATCH 1/2] dma-debug: allow size to become smaller in dma_unmap
Date: Tue, 28 May 2013 00:13:06 +0800
Message-Id: <1369671187-24430-2-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369671187-24430-1-git-send-email-ming.lei@canonical.com>
References: <1369671187-24430-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looses the check on DMA buffer size for streaming
DMA unmap, based on the below fact:

- it is common to see only part of DMA transfer is completed,
especially in case of DMA_FROM_DEVICE

So it isn't necessary to unmap the whole DMA buffer inside DMA
unmapping, and unmapping the actual completed buffer should be more
efficient. Considered that unmapping is often called in hard irq
context, time of irq handling can be saved.

Cc: Shuah Khan <shuah.khan@hp.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 lib/dma-debug.c |   39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index d87a17a..202c522 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -857,6 +857,7 @@ static void check_unmap(struct dma_debug_entry *ref)
 	struct dma_debug_entry *entry;
 	struct hash_bucket *bucket;
 	unsigned long flags;
+	unsigned int  size_invalid = 0;
 
 	bucket = get_hash_bucket(ref, &flags);
 	entry = bucket_find_exact(bucket, ref);
@@ -879,13 +880,8 @@ static void check_unmap(struct dma_debug_entry *ref)
 		return;
 	}
 
-	if (ref->size != entry->size) {
-		err_printk(ref->dev, entry, "DMA-API: device driver frees "
-			   "DMA memory with different size "
-			   "[device address=0x%016llx] [map size=%llu bytes] "
-			   "[unmap size=%llu bytes]\n",
-			   ref->dev_addr, entry->size, ref->size);
-	}
+	if (ref->size > entry->size)
+		size_invalid = 1;
 
 	if (ref->type != entry->type) {
 		err_printk(ref->dev, entry, "DMA-API: device driver frees "
@@ -894,18 +890,27 @@ static void check_unmap(struct dma_debug_entry *ref)
 			   "[mapped as %s] [unmapped as %s]\n",
 			   ref->dev_addr, ref->size,
 			   type2name[entry->type], type2name[ref->type]);
-	} else if ((entry->type == dma_debug_coherent) &&
-		   (ref->paddr != entry->paddr)) {
-		err_printk(ref->dev, entry, "DMA-API: device driver frees "
-			   "DMA memory with different CPU address "
-			   "[device address=0x%016llx] [size=%llu bytes] "
-			   "[cpu alloc address=0x%016llx] "
-			   "[cpu free address=0x%016llx]",
-			   ref->dev_addr, ref->size,
-			   (unsigned long long)entry->paddr,
-			   (unsigned long long)ref->paddr);
+	} else if (entry->type == dma_debug_coherent) {
+		if (ref->paddr != entry->paddr)
+			err_printk(ref->dev, entry, "DMA-API: device driver frees "
+				   "DMA memory with different CPU address "
+				   "[device address=0x%016llx] [size=%llu bytes] "
+				   "[cpu alloc address=0x%016llx] "
+				   "[cpu free address=0x%016llx]",
+				   ref->dev_addr, ref->size,
+				   (unsigned long long)entry->paddr,
+				   (unsigned long long)ref->paddr);
+		if (ref->size != entry->size)
+			size_invalid = 1;
 	}
 
+	if (size_invalid)
+		err_printk(ref->dev, entry, "DMA-API: device driver frees "
+			   "DMA memory with different size "
+			   "[device address=0x%016llx] [map size=%llu bytes] "
+			   "[unmap size=%llu bytes]\n",
+			   ref->dev_addr, entry->size, ref->size);
+
 	if (ref->sg_call_ents && ref->type == dma_debug_sg &&
 	    ref->sg_call_ents != entry->sg_call_ents) {
 		err_printk(ref->dev, entry, "DMA-API: device driver frees "
-- 
1.7.9.5

