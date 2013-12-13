Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab3LMWse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:48:34 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:62351 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab3LMW0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:25 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 012/115] gpu: ion: Set the dma_address of the sg list at alloc time
Date: Fri, 13 Dec 2013 14:23:46 -0800
Message-Id: <1386973529-4884-13-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

This patch sets the dma_address field of the sglist representing
an allocation at allocation time.  This technically breaks the dma api
which states that these addresses should be set when a particular device
takes ownership of a buffer via the dma_map apis.  In the case of our
systems the only dma address space is physical addresses.  Additionally,
we can not afford the overhead of calling dma_map_sg from this location
as it implies a cache invalidate that is not necessary if the memory
was previously mapped cached.  Instead, the expectation is that memory
being returned from the heaps is ready for dma in that if any cached
mappings of that memory exist they have been invalidated.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 552a86a..ddfe49a 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -136,7 +136,8 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 {
 	struct ion_buffer *buffer;
 	struct sg_table *table;
-	int ret;
+	struct scatterlist *sg;
+	int i, ret;
 
 	buffer = kzalloc(sizeof(struct ion_buffer), GFP_KERNEL);
 	if (!buffer)
@@ -163,6 +164,16 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 	buffer->sg_table = table;
 
 	mutex_init(&buffer->lock);
+	/* this will set up dma addresses for the sglist -- it is not
+	   technically correct as per the dma api -- a specific
+	   device isn't really taking ownership here.  However, in practice on
+	   our systems the only dma_address space is physical addresses.
+	   Additionally, we can't afford the overhead of invalidating every
+	   allocation via dma_map_sg. The implicit contract here is that
+	   memory comming from the heaps is ready for dma, ie if it has a
+	   cached mapping that mapping has been invalidated */
+	for_each_sg(buffer->sg_table->sgl, sg, buffer->sg_table->nents, i)
+		sg_dma_address(sg) = sg_phys(sg);
 	ion_buffer_add(dev, buffer);
 	return buffer;
 }
-- 
1.8.3.2

