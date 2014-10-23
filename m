Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076AbaJWOfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 10:35:42 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:43907 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663AbaJWOdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 10:33:55 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Michal Nazarewicz <mina86@mina86.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 1/4] mm: cma: Don't crash on allocation if CMA area can't be activated
Date: Thu, 23 Oct 2014 17:33:45 +0300
Message-Id: <1414074828-4488-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1414074828-4488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1414074828-4488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If activation of the CMA area fails its mutex won't be initialized,
leading to an oops at allocation time when trying to lock the mutex. Fix
this by failing allocation if the area hasn't been successfully actived,
and detect that condition by moving the CMA bitmap allocation after page
block reservation completion.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 mm/cma.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index 963bc4a..16c6650 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -93,11 +93,6 @@ static int __init cma_activate_area(struct cma *cma)
 	unsigned i = cma->count >> pageblock_order;
 	struct zone *zone;
 
-	cma->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
-
-	if (!cma->bitmap)
-		return -ENOMEM;
-
 	WARN_ON_ONCE(!pfn_valid(pfn));
 	zone = page_zone(pfn_to_page(pfn));
 
@@ -114,17 +109,17 @@ static int __init cma_activate_area(struct cma *cma)
 			 * to be in the same zone.
 			 */
 			if (page_zone(pfn_to_page(pfn)) != zone)
-				goto err;
+				return -EINVAL;
 		}
 		init_cma_reserved_pageblock(pfn_to_page(base_pfn));
 	} while (--i);
 
+	cma->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
+	if (!cma->bitmap)
+		return -ENOMEM;
+
 	mutex_init(&cma->lock);
 	return 0;
-
-err:
-	kfree(cma->bitmap);
-	return -EINVAL;
 }
 
 static int __init cma_init_reserved_areas(void)
@@ -313,7 +308,7 @@ struct page *cma_alloc(struct cma *cma, int count, unsigned int align)
 	struct page *page = NULL;
 	int ret;
 
-	if (!cma || !cma->count)
+	if (!cma || !cma->count || !cma->bitmap)
 		return NULL;
 
 	pr_debug("%s(cma %p, count %d, align %d)\n", __func__, (void *)cma,
-- 
2.0.4

