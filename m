Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760436AbaGOXdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:33:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934067AbaGOXOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.15 64/84] DMA, CMA: fix possible memory leak
Date: Tue, 15 Jul 2014 16:18:01 -0700
Message-Id: <20140715231715.110135616@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/base/dma-contiguous.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -155,13 +155,23 @@ static int __init cma_activate_area(stru
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


