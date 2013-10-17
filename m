Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab3JQGDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 02:03:48 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:51353 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3JQGC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 02:02:58 -0400
X-AuditID: 9c93017d-b7b2eae000005519-38-525f7d90ea3e
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 3/5] slab: restrict the number of objects in a slab
Date: Thu, 17 Oct 2013 15:03:15 +0900
Message-Id: <1381989797-29269-4-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381989797-29269-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1381989797-29269-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To prepare to implement byte sized index for managing the freelist
of a slab, we should restrict the number of objects in a slab to be less
or equal to 256, since byte only represent 256 different values.
Setting the size of object to value equal or more than newly introduced
SLAB_MIN_SIZE ensures that the number of objects in a slab is less or
equal to 256 for a slab with 1 page.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index ec197b9..3cee122 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -157,6 +157,10 @@
 #define ARCH_KMALLOC_FLAGS SLAB_HWCACHE_ALIGN
 #endif
 
+/* We use byte sized index to manage the freelist of a slab */
+#define NR_PER_BYTE (1 << BITS_PER_BYTE)
+#define SLAB_MIN_SIZE (PAGE_SIZE >> BITS_PER_BYTE)
+
 /*
  * true if a page was allocated from pfmemalloc reserves for network-based
  * swap
@@ -2016,6 +2020,10 @@ static size_t calculate_slab_order(struct kmem_cache *cachep,
 		if (!num)
 			continue;
 
+		/* We can't handler number of objects more than NR_PER_BYTE */
+		if (num > NR_PER_BYTE)
+			break;
+
 		if (flags & CFLGS_OFF_SLAB) {
 			/*
 			 * Max number of objs-per-slab for caches which
@@ -2258,6 +2266,12 @@ __kmem_cache_create (struct kmem_cache *cachep, unsigned long flags)
 		flags |= CFLGS_OFF_SLAB;
 
 	size = ALIGN(size, cachep->align);
+	/*
+	 * We want to restrict the number of objects in a slab to be equal or
+	 * less than 256 in order to manage freelist via byte sized indexes.
+	 */
+	if (size < SLAB_MIN_SIZE)
+		size = ALIGN(SLAB_MIN_SIZE, cachep->align);
 
 	left_over = calculate_slab_order(cachep, size, cachep->align, flags);
 
-- 
1.7.9.5

