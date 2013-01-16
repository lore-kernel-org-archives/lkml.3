Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708Ab3APA1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:27:21 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:39047 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758296Ab3APA0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 19:26:04 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 16/17] mm/memory_hotplug: use zone_end_pfn() instead of open coding
Date: Tue, 15 Jan 2013 16:24:53 -0800
Message-Id: <1358295894-24167-17-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011600-3620-0000-0000-000000E82EC8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to using zone_end_pfn() in move_pfn_range_left() and
move_pfn_range_right() instead of open coding the same.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/memory_hotplug.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index c6149a3..515b917 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -278,7 +278,7 @@ static int __meminit move_pfn_range_left(struct zone *z1, struct zone *z2,
 	pgdat_resize_lock(z1->zone_pgdat, &flags);
 
 	/* can't move pfns which are higher than @z2 */
-	if (end_pfn > z2->zone_start_pfn + z2->spanned_pages)
+	if (end_pfn > zone_end_pfn(z2))
 		goto out_fail;
 	/* the move out part mast at the left most of @z2 */
 	if (start_pfn > z2->zone_start_pfn)
@@ -294,7 +294,7 @@ static int __meminit move_pfn_range_left(struct zone *z1, struct zone *z2,
 		z1_start_pfn = start_pfn;
 
 	resize_zone(z1, z1_start_pfn, end_pfn);
-	resize_zone(z2, end_pfn, z2->zone_start_pfn + z2->spanned_pages);
+	resize_zone(z2, end_pfn, zone_end_pfn(z2));
 
 	pgdat_resize_unlock(z1->zone_pgdat, &flags);
 
@@ -323,15 +323,15 @@ static int __meminit move_pfn_range_right(struct zone *z1, struct zone *z2,
 	if (z1->zone_start_pfn > start_pfn)
 		goto out_fail;
 	/* the move out part mast at the right most of @z1 */
-	if (z1->zone_start_pfn + z1->spanned_pages >  end_pfn)
+	if (zone_end_pfn(z1) >  end_pfn)
 		goto out_fail;
 	/* must included/overlap */
-	if (start_pfn >= z1->zone_start_pfn + z1->spanned_pages)
+	if (start_pfn >= zone_end_pfn(z1))
 		goto out_fail;
 
 	/* use end_pfn for z2's end_pfn if z2 is empty */
 	if (z2->spanned_pages)
-		z2_end_pfn = z2->zone_start_pfn + z2->spanned_pages;
+		z2_end_pfn = zone_end_pfn(z2);
 	else
 		z2_end_pfn = end_pfn;
 
-- 
1.8.0.3

