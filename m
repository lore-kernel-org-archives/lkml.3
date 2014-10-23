Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbaJWOep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 10:34:45 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:43912 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178AbaJWOd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 10:33:58 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Michal Nazarewicz <mina86@mina86.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 3/4] mm: cma: Ensure that reservations never cross the low/high mem boundary
Date: Thu, 23 Oct 2014 17:33:47 +0300
Message-Id: <1414074828-4488-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1414074828-4488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1414074828-4488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 95b0e655f914 ("ARM: mm: don't limit default CMA region only to
low memory") extended CMA memory reservation to allow usage of high
memory. It relied on commit f7426b983a6a ("mm: cma: adjust address limit
to avoid hitting low/high memory boundary") to ensure that the reserved
block never crossed the low/high memory boundary. While the
implementation correctly lowered the limit, it failed to consider the
case where the base..limit range crossed the low/high memory boundary
with enough space on each side to reserve the requested size on either
low or high memory.

Rework the base and limit adjustment to fix the problem. The function
now starts by rejecting the reservation altogether for fixed
reservations that cross the boundary, then adjust the limit if
reservation from high memory is impossible, and finally first try to
reserve from high memory first and then falls back to low memory.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 mm/cma.c | 58 ++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 44 insertions(+), 14 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index 6b14346..b83597b 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -247,23 +247,38 @@ int __init cma_declare_contiguous(phys_addr_t base,
 		return -EINVAL;
 
 	/*
-	 * adjust limit to avoid crossing low/high memory boundary for
+	 * Adjust limit and base to avoid crossing low/high memory boundary for
 	 * automatically allocated regions
 	 */
-	if (((limit == 0 || limit > memblock_end) &&
-	     (memblock_end - size < highmem_start &&
-	      memblock_end > highmem_start)) ||
-	    (!fixed && limit > highmem_start && limit - size < highmem_start)) {
-		limit = highmem_start;
-	}
 
-	if (fixed && base < highmem_start && base+size > highmem_start) {
+	/*
+	 * If allocating at a fixed base the request region must not cross the
+	 * low/high memory boundary.
+	 */
+	if (fixed && base < highmem_start && base + size > highmem_start) {
 		ret = -EINVAL;
 		pr_err("Region at %08lx defined on low/high memory boundary (%08lx)\n",
 			(unsigned long)base, (unsigned long)highmem_start);
 		goto err;
 	}
 
+	/*
+	 * If the limit is unspecified or above the memblock end, its effective
+	 * value will be the memblock end. Set it explicitly to simplify further
+	 * checks.
+	 */
+	if (limit == 0 || limit > memblock_end)
+		limit = memblock_end;
+
+	/*
+	 * If the limit is above the highmem start by less than the reserved
+	 * size allocation in highmem won't be possible. Lower the limit to the
+	 * lowmem end.
+	 */
+	if (limit > highmem_start && limit - size < highmem_start)
+		limit = highmem_start;
+
+
 	/* Reserve memory */
 	if (fixed) {
 		if (memblock_is_region_reserved(base, size) ||
@@ -272,14 +287,29 @@ int __init cma_declare_contiguous(phys_addr_t base,
 			goto err;
 		}
 	} else {
-		phys_addr_t addr = memblock_alloc_range(size, alignment, base,
-							limit);
+		phys_addr_t addr = 0;
+
+		/*
+		 * If the requested region crosses the low/high memory boundary,
+		 * try allocating from high memory first and fall back to low
+		 * memory in case of failure.
+		 */
+		if (base < highmem_start && limit > highmem_start) {
+			addr = memblock_alloc_range(size, alignment,
+						    highmem_start, limit);
+			limit = highmem_start;
+		}
+
 		if (!addr) {
-			ret = -ENOMEM;
-			goto err;
-		} else {
-			base = addr;
+			addr = memblock_alloc_range(size, alignment, base,
+						    limit);
+			if (!addr) {
+				ret = -ENOMEM;
+				goto err;
+			}
 		}
+
+		base = addr;
 	}
 
 	ret = cma_init_reserved_mem(base, size, order_per_bit, res_cma);
-- 
2.0.4

