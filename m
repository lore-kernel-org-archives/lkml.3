Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316AbaFLDUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 23:20:10 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:55658 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527AbaFLDRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 23:17:52 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 10/10] mm, cma: use spinlock instead of mutex
Date: Thu, 12 Jun 2014 12:21:47 +0900
Message-Id: <1402543307-29800-11-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we should take the mutex for manipulating bitmap.
This job may be really simple and short so we don't need to sleep
if contended. So I change it to spinlock.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/cma.c b/mm/cma.c
index 22a5b23..3085e8c 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -27,6 +27,7 @@
 #include <linux/memblock.h>
 #include <linux/err.h>
 #include <linux/mm.h>
+#include <linux/spinlock.h>
 #include <linux/mutex.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
@@ -36,7 +37,7 @@ struct cma {
 	unsigned long	count;
 	unsigned long	*bitmap;
 	int order_per_bit; /* Order of pages represented by one bit */
-	struct mutex	lock;
+	spinlock_t	lock;
 };
 
 /*
@@ -72,9 +73,9 @@ static void clear_cma_bitmap(struct cma *cma, unsigned long pfn, int count)
 	bitmapno = (pfn - cma->base_pfn) >> cma->order_per_bit;
 	nr_bits = cma_bitmap_pages_to_bits(cma, count);
 
-	mutex_lock(&cma->lock);
+	spin_lock(&cma->lock);
 	bitmap_clear(cma->bitmap, bitmapno, nr_bits);
-	mutex_unlock(&cma->lock);
+	spin_unlock(&cma->lock);
 }
 
 static int __init cma_activate_area(struct cma *cma)
@@ -112,7 +113,7 @@ static int __init cma_activate_area(struct cma *cma)
 		init_cma_reserved_pageblock(pfn_to_page(base_pfn));
 	} while (--i);
 
-	mutex_init(&cma->lock);
+	spin_lock_init(&cma->lock);
 	return 0;
 
 err:
@@ -261,11 +262,11 @@ struct page *cma_alloc(struct cma *cma, int count, unsigned int align)
 	nr_bits = cma_bitmap_pages_to_bits(cma, count);
 
 	for (;;) {
-		mutex_lock(&cma->lock);
+		spin_lock(&cma->lock);
 		bitmapno = bitmap_find_next_zero_area(cma->bitmap,
 					bitmap_maxno, start, nr_bits, mask);
 		if (bitmapno >= bitmap_maxno) {
-			mutex_unlock(&cma->lock);
+			spin_unlock(&cma->lock);
 			break;
 		}
 		bitmap_set(cma->bitmap, bitmapno, nr_bits);
@@ -274,7 +275,7 @@ struct page *cma_alloc(struct cma *cma, int count, unsigned int align)
 		 * our exclusive use. If the migration fails we will take the
 		 * lock again and unmark it.
 		 */
-		mutex_unlock(&cma->lock);
+		spin_unlock(&cma->lock);
 
 		pfn = cma->base_pfn + (bitmapno << cma->order_per_bit);
 		mutex_lock(&cma_mutex);
-- 
1.7.9.5

