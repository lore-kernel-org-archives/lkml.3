Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801AbbAIODi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 09:03:38 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:33311 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756885AbbAIODh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 09:03:37 -0500
From: "George G. Davis" <ggdavisiv@gmail.com>
X-Google-Original-From: "George G. Davis" <george_davis@mentor.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "George G. Davis" <george_davis@mentor.com>
Subject: [PATCH] mm: cma: Fix totalcma_pages to include DT defined CMA regions
Date: Fri,  9 Jan 2015 09:01:05 -0500
Message-Id: <1420812065-129868-1-git-send-email-george_davis@mentor.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The totalcma_pages variable is not updated to account for CMA regions
defined via device tree reserved-memory sub-nodes.  Fix this omission by
moving the calculation of totalcma_pages into cma_init_reserved_mem()
instead of cma_declare_contiguous() such that it will include reserved
memory used by all CMA regions.

Signed-off-by: George G. Davis <george_davis@mentor.com>
---
 mm/cma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/cma.c b/mm/cma.c
index a85ae28..75016fd 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -199,6 +199,7 @@ int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 	cma->order_per_bit = order_per_bit;
 	*res_cma = cma;
 	cma_area_count++;
+	totalcma_pages += (size / PAGE_SIZE);
 
 	return 0;
 }
@@ -337,7 +338,6 @@ int __init cma_declare_contiguous(phys_addr_t base,
 	if (ret)
 		goto err;
 
-	totalcma_pages += (size / PAGE_SIZE);
 	pr_info("Reserved %ld MiB at %pa\n", (unsigned long)size / SZ_1M,
 		&base);
 	return 0;
-- 
1.9.3

