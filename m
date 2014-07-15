Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628AbaGOViW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:38:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54751 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759536AbaGOVh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:37:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 180/198] DMA, CMA: fix possible memory leak
Date: Tue, 15 Jul 2014 14:30:50 -0700
Message-Id: <1405459868-15089-181-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>

commit fe8eea4f4a3f299ef83ed090d5354698ebe4fda8 upstream.

We should free memory for bitmap when we find zone mismatch, otherwise
this memory will leak.

Additionally, I copy code comment from PPC KVM's CMA code to inform why
we need to check zone mis-match.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Reviewed-by: Michal Nazarewicz <mina86@mina86.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>
Cc: Alexander Graf <agraf@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/base/dma-contiguous.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index 165c2c2..d3bffa4 100644
--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -155,13 +155,23 @@ static int __init cma_activate_area(struct cma *cma)
 		base_pfn = pfn;
 		for (j = pageblock_nr_pages; j; --j, pfn++) {
 			WARN_ON_ONCE(!pfn_valid(pfn));
+			/*
+			 * alloc_contig_range requires the pfn range
+			 * specified to be in the same zone. Make this
+			 * simple by forcing the entire CMA resv range
+			 * to be in the same zone.
+			 */
 			if (page_zone(pfn_to_page(pfn)) != zone)
-				return -EINVAL;
+				goto err;
 		}
 		init_cma_reserved_pageblock(pfn_to_page(base_pfn));
 	} while (--i);
 
 	return 0;
+
+err:
+	kfree(cma->bitmap);
+	return -EINVAL;
 }
 
 static struct cma cma_areas[MAX_CMA_AREAS];
-- 
1.9.1

