Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934873AbaGRNMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:12:13 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17600 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030714AbaGRNL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:11:58 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 166/170] DMA, CMA: fix possible memory leak
Date: Fri, 18 Jul 2014 14:12:51 +0200
Message-Id: <46ceb0c5d9ab26761390d5fa9ae37653557b145f.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/base/dma-contiguous.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index 99802d6f3c60..e057744150ea 100644
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
2.0.0

