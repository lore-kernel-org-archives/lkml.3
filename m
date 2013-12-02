Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab3LBIra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 03:47:30 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52774 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3LBIrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 03:47:24 -0500
X-AuditID: 9c930179-b7b6eae000007f2a-55-529c491a403a
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v3 1/5] slab: factor out calculate nr objects in cache_estimate
Date: Mon,  2 Dec 2013 17:49:39 +0900
Message-Id: <1385974183-31423-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385974183-31423-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1385974183-31423-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This logic is not simple to understand so that making separate function
helping readability. Additionally, we can use this change in the
following patch which implement for freelist to have another sized index
in according to nr objects.

Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index eb043bf..e749f75 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -565,9 +565,31 @@ static inline struct array_cache *cpu_cache_get(struct kmem_cache *cachep)
 	return cachep->array[smp_processor_id()];
 }
 
-static size_t slab_mgmt_size(size_t nr_objs, size_t align)
+static int calculate_nr_objs(size_t slab_size, size_t buffer_size,
+				size_t idx_size, size_t align)
 {
-	return ALIGN(nr_objs * sizeof(unsigned int), align);
+	int nr_objs;
+	size_t freelist_size;
+
+	/*
+	 * Ignore padding for the initial guess. The padding
+	 * is at most @align-1 bytes, and @buffer_size is at
+	 * least @align. In the worst case, this result will
+	 * be one greater than the number of objects that fit
+	 * into the memory allocation when taking the padding
+	 * into account.
+	 */
+	nr_objs = slab_size / (buffer_size + idx_size);
+
+	/*
+	 * This calculated number will be either the right
+	 * amount, or one greater than what we want.
+	 */
+	freelist_size = slab_size - nr_objs * buffer_size;
+	if (freelist_size < ALIGN(nr_objs * idx_size, align))
+		nr_objs--;
+
+	return nr_objs;
 }
 
 /*
@@ -600,25 +622,9 @@ static void cache_estimate(unsigned long gfporder, size_t buffer_size,
 		nr_objs = slab_size / buffer_size;
 
 	} else {
-		/*
-		 * Ignore padding for the initial guess. The padding
-		 * is at most @align-1 bytes, and @buffer_size is at
-		 * least @align. In the worst case, this result will
-		 * be one greater than the number of objects that fit
-		 * into the memory allocation when taking the padding
-		 * into account.
-		 */
-		nr_objs = (slab_size) / (buffer_size + sizeof(unsigned int));
-
-		/*
-		 * This calculated number will be either the right
-		 * amount, or one greater than what we want.
-		 */
-		if (slab_mgmt_size(nr_objs, align) + nr_objs*buffer_size
-		       > slab_size)
-			nr_objs--;
-
-		mgmt_size = slab_mgmt_size(nr_objs, align);
+		nr_objs = calculate_nr_objs(slab_size, buffer_size,
+					sizeof(unsigned int), align);
+		mgmt_size = ALIGN(nr_objs * sizeof(unsigned int), align);
 	}
 	*num = nr_objs;
 	*left_over = slab_size - nr_objs*buffer_size - mgmt_size;
-- 
1.7.9.5

